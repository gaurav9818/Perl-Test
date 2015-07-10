package FileStatsTool;

##############################################################################
#File: FileStatsTool.pm
#Author: Gopal Agrawal
#Purpose: This script basically display stats of file in the given directory
#         like no of word, no of records,size,10 common words
###############################################################################

use strict;
#use Tie::File;

###
#Constructor for Tool
sub new{
	my $class = shift;
	my $self  = {
	_dirPath => undef,
	_displayStat => undef
	};
	bless $self, $class;
	return $self;
}

###
#this method generates file stats
sub getFileStats {
	my ($self, $dirPath) = @_;

	die "Directory Path is not a valid" unless defined($dirPath);

	$self->{_dirPath} = $dirPath if defined($dirPath);

	opendir(DIR, "$dirPath") or die "cannot open directory";

	@ARGV=<$dirPath/*.txt>;

	die "No text file present in directory" unless (scalar(@ARGV)>0);

	my (%display_output, $count);

	foreach my $file(@ARGV) {
		my %word_count;
		my %sentence_length;
		my $n_words=0;
		my $size= -s $file;
		my ($unmatched, $line, @sentences, $n_recs, @array);
			#instead of using below approach we also use tie @array, 'Tie: :File',$File or gignatic files
		open (Input, $file) ||die "can't open $file: $!";
		while(<input>) {
			chomp;
			#do something with $_
				$line=$_;
			$line=$unmatched.' '.$line if($unmatched);
			@sentences=($line =~ /.*?[?!\.]/g );
			$unmatched=$';
			if(scalar(@sentences)==0) {
				   $unmatched=$line;
			}
			foreach my $sentence (@sentences) {
					$sentence_length{$sentence}=length($sentence);
			}

			while (/(\w[\w'-]*)/g) {
					$n_words++;
					$word_count{lc $1}++;
			}
		    $n_recs=$. ;
		}
		close INPUT;

		$count=0;
		foreach my $word (sort{$word_count{$b}<=>$word_count{$a}}keys %word_count) {
			$count++;
			push @{$display_output{$file}->{common_word}},$word;
			$display_output{total}->{common_word_temp}->{$word}=$word_count{$word};
			last if($count==10);
		}
		foreach my $sentence (sort{$sentence_length{$b} <=> $sentence_length{$a}} keys %sentence_length) {
		   $display_output{$file}->{longest_sentence}=$sentence;
		   $display_output{total}->{longest_sentence_temp}->{$sentence}=$sentence_length{$sentence};
		   last;
		}

		$display_output{$file}->{no_of_rec}=$n_recs;
		$display_output{$file}->{no_of_word}=$n_words;
		$display_output{$file}->{size}=$size;


		$display_output{total}->{no_of_rec}=($display_output{total}->{no_of_rec}+ $n_recs);
		$display_output{total}->{no_of_word}=($display_output{total}->{no_of_word}+ $n_words);
		$display_output{total}->{size}=($display_output{total}->{size}+ $size);
		
	}
	
	$count=0;
	foreach my $word (sort {$display_output{total}->{common_word_temp}->{$b} <=> $display_output{total}->{common_word_temp}->{$a}} keys %{$display_output{total}->{common_word_temp}}) {
	$count++;
	push @{$display_output{total}->{common_word}},$word;
	last if($count==10);
	}
	foreach my $sentence (sort{$display_output{total}->{longest_sentence_temp}->{$b} <=> $display_output{total}->{longest_sentence_temp}->{$a}} keys %{$display_output{total}->{longest_sentence_temp}})   {
	        $display_output{total}->{longest_sentence}=$sentence;
	        last;
	}
	$self->{_displayStat}=\%display_output;
	return $self->{_displayStat};
}
###
# this method displays file stats
sub displayStat {
    my ($self)= @_;
    die"No File Stats To Display" unless defined %{$self->{_displayStat}};

    foreach my $file (keys %{$self->{_displayStat}})  {
        print "File $file\n";
        print "==========================\n";

	foreach my $attr (keys%{$self->{_displayStat}})  {

	        my $stat=$self->{_displayStat}->{$file}->{$attr};

		print "No of record=>$stat\n"if($attr eq 'no_of_rec');
                print "No of word=>$stat\n"if($attr eq 'no_of_word');
                print "size=>$stat\n"if($attr eq 'size');
                print "Longest Sentence=>$stat\n"if($attr eq 'Longest Sentence');

		if($attr eq 'common_word') {
		my @common_words = @{$stat};
		my $words=join ', ', @common_words;
		print "10 most common words $words \n";
		}
	}
    }
}

1;