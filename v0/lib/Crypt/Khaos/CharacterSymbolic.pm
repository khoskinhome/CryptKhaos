package Crypt::Khaos::CharactersSymbolic;
use strict;
use warnings;

=pod

This module holds the symbolic names for the permitted characters,
and the characters they map to.

i.e. exclamation_mark is the symbolic name for a !

Also note that the char_set's both the predefined ones in Crypt::Khaos::Conf::CharSetDefaults
and user-defined ones that end up in (most likely) $ENV{HOME}/.cryptkhaos/conf/
and the hard-coded user examples that get dumped out in Crypt::Khaos::Conf::ExampleDumps;
must ONLY define the characters that are listed here.

They don't have to define ALL of them, but they must only define the ones
defined here.

i.e. they can be the exact same set of these characters or a subset of these characters.

The above char_sets will be sanity checked against the characters defined here.

=cut

# @OriginalKeyOrder copuld be called perl-5-14-hash-key-order ;) well just before perl-5.17.sumin order.
my @OriginalKeyOrder = qw{ right_curly_bracket hyphen right_parentheses pipe
        plus_sign back_slash hash_sign pound_sign tilde_sign exclamation_mark
        comma semi_colon double_quote colon percent_sign lower_case_alpha
        left_square_bracket fullstop left_parentheses hat_sign equals_sign
        left_curly_bracket upper_case_alpha dollar_sign question_mark single_quote
        underscore ampersand right_square_bracket right_angle_bracket
        forward_slash numeric left_angle_bracket asterisk };

sub getOriginalKeyOrder {
    return \@OriginalKeyOrder;
}

# SymbolicCharname maps the charname to the actual character, unless its a RANGE character definition.
my $SymbolicCharnames = {
    lower_case_alpha        => 'RANGE', # a -> z
    upper_case_alpha        => 'RANGE', # A -> Z
    numeric                 => 'RANGE', # 0 -> 9
    exclamation_mark        => '!',
    question_mark           => '?',
    double_quote            => '"',
    single_quote            => "'",
    pound_sign              => '£',
    dollar_sign             => '$',
    percent_sign            => '%',
    hat_sign                => '^',
    ampersand               => '&',
    asterisk                => '*',
    hyphen                  => '-',
    underscore              => '_',
    plus_sign               => '+',
    equals_sign             => '=',
    hash_sign               => '#',
    tilde_sign              => '~',
    left_curly_bracket      => '{',
    right_curly_bracket     => '}',
    left_square_bracket     => '[',
    right_square_bracket    => ']',
    left_parentheses        => '(',
    right_parentheses       => ')',
    left_angle_bracket      => '<',
    right_angle_bracket     => '>',
    colon                   => ':',
    semi_colon              => ';',
    fullstop                => '.',
    comma                   => ',',
    forward_slash           => '/',
    back_slash              => '\\',
    pipe                    => '|',
};

sub getSymbolicCharnames {
    return $SymbolicCharnames;
}

# This is a sanity check to make sure the keys of $SymbolicCharname is exactly
# the same as the OriginalKeyOrder.
# It would be majorly bad if they don't match up.
# when the 5-14 to 5-18 bug and all the services I generated passwords for it are fixed
# then I guess I'll deprecate the OriginalKeyOrder and with it this sanity check. So TODO on that.
# and all the stuff in the config files would have to be deprecated too.

my $sorted_SymbolicCharnames = join( ' ', sort keys %{$SymbolicCharname} );
my $orig_sorted_keys         = join( ' ', sort @OriginalKeyOrder );
if ( $orig_sorted_keys ne $sorted_SymbolicCharnames ) {
    # sanity check on the serialised-sorted-array-of-the-keys
    die "DIE !!!! because :-\n    $sorted_SymbolicCharnames\n IS NOT THE SAME AS :-\n    $orig_sorted_keys  \n These are serialisations of the keys of the character defs. \n";
}

1;
