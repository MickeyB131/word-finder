#!/usr/local/bin/perl
use Dancer;
use File::Slurp;

#set logger => 'file';
#set log => 'core';
#set show_errors => 1;

# Get all the words
my $words_file = '/usr/share/dict/words';
my @DictionaryWords = read_file($words_file);

get '/ping' => sub {
    return '200 OK';
};

get '/wordfinder/:word' => sub {
    my $word = params->{word};
    # Get the words
    my @FoundWords = get_words($word);
    return to_json (\@FoundWords);
};

# Main routine to do all the work.
sub get_words {
    my ($word_string) = @_;

    my @FoundWords;

    my @StringChars = split(//,$word_string);
    my $string_length = length $word_string;

    # What are we looking for?
    my %SearchChars = character_distribution($word_string);

  WORD:
    foreach my $word (@DictionaryWords){
        chomp $word;
        # Skip words that are too long.
        if (length $word > $string_length) {
            next WORD;
        }elsif (length $word == 1){
            next WORD;
        }
        my %DictionaryChars = character_distribution($word);
        my $found = 0;
        # Loop through the current dictionary word and see if it fits in the word we are searching for
      CHR:
        foreach my $char (keys %DictionaryChars){
            my $search_cnt = exists $SearchChars{$char} ? $SearchChars{$char} : 0;
            if ($search_cnt == 0){
                $found = 0;
                last CHR;
            }elsif ($DictionaryChars{$char} <= $search_cnt){
                $found = 1;
                next CHR;
            } else {
                $found = 0;
                last CHR;
            }
        }
        if ($found){
            push @FoundWords, $word;
        }
    }
    return @FoundWords;

}

sub character_distribution {
    my ($word) = @_;

    # Create a hash of the character distribution of the word.
    my %CharDist = ();
    my @Chars = split(//,$word);
    foreach my $chr (@Chars){
        $CharDist{$chr}++;
    }
    return %CharDist;
}

dance;
