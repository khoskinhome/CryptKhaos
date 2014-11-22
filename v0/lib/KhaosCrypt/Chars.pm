package KhaosCrypt::Chars;

# THIS IS THE OLD WAY OF DOING STUFF. THIS FILE AND ALL ITS CONTENTS WILL GET DELETED ONCE "Crypt::Khaos" is working

use strict;
no strict 'refs';

use JSON;
# This package has all the standard definitions of the character sets
# that a "service" can use.

# It also supplies the method that gives out the hash key order for the
# character sets. (actually a TODO item)
# ( This feature happened because of a bug that became apparent when
# perl 5.18 started randomising hash key order )

# required, optional, notallowed
# the notalloweds don't get fed to the baseencode as a valid character.
# the requireds are checked up once the phrase is encode to see that they're all present,
# if one of them is not present , then a number is added onto the end of the passphrase
# and it is tried again and again , until all the requireds are got or until 1000 encodes have been tried.

# it is not a good idea to put requireds against a single punctuation char.
# really this script needs a "one-of-these-punctuation-chars" is in the built passphrase.
# at the moment it

# AllChars really means that alpha numerics are required, and the rest are optional.
our $AllChars = {
    lower_case_alpha        => ['RANGE'  ,'required'], # a-z : never 'notallowed'
    upper_case_alpha        => ['RANGE'  ,'required'], # A-Z : never 'notallowed'
    numeric                 => ['RANGE'  ,'required'], # 0-9 : never 'notallowed'
    exclamation_mark        => ['!' ,'optional'],  # !
    question_mark           => ['?' ,'optional'],  # ?
    double_quote            => ['"' ,'optional'],  # "
    single_quote            => ["'" ,'optional'],  # '
    pound_sign              => ['£' ,'optional'],  # £
    dollar_sign             => ['$' ,'optional'],  # $
    percent_sign            => ['%' ,'optional'],  # %
    hat_sign                => ['^' ,'optional'],  # ^
    ampersand               => ['&' ,'optional'],  # &
    asterisk                => ['*' ,'optional'],  # *
    hyphen                  => ['-' ,'optional'],  # -
    underscore              => ['_' ,'optional'],  # _
    plus_sign               => ['+' ,'optional'],  # +
    equals_sign             => ['=' ,'optional'],  # =
    hash_sign               => ['#' ,'optional'],  # #
    tilde_sign              => ['~' ,'optional'],  # ~
    left_curly_bracket      => ['{' ,'optional'],  # {
    right_curly_bracket     => ['}' ,'optional'],  # }
    left_square_bracket     => ['[' ,'optional'],  # [
    right_square_bracket    => [']' ,'optional'],  # ]
    left_parentheses        => ['(' ,'optional'],  # (
    right_parentheses       => [')' ,'optional'],  # )
    left_angle_bracket      => ['<' ,'optional'],  # <
    right_angle_bracket     => ['>' ,'optional'],  # > # was once a bug with right_parentheses
    colon                   => [':' ,'optional'],  # :
    semi_colon              => [';' ,'optional'],  # ;
    fullstop                => ['.' ,'optional'],  # .
    comma                   => [',' ,'optional'],  # ,
    forward_slash           => ['/' ,'optional'],  # /
    back_slash              => ['\\','optional'],  # \
    pipe                    => ['|' ,'optional'],  # |
};
# and AllChars used to be known as Default.
our $Default = $AllChars;

# Google, the set of chars that I found worked for Google.
# This *might* not be completely accurate , but it Works-For-Me.
our $Google =
    {
        %$AllChars,
        exclamation_mark        => ['!' ,'optional'],  # !
        question_mark           => ['?' ,'optional'],  # ?
        double_quote            => ['"' ,'notallowed'],  # "
        single_quote            => ["'" ,'optional'],  # '
        pound_sign              => ['£' ,'optional'],  # £
        dollar_sign             => ['$' ,'notallowed'],  # $
        percent_sign            => ['%' ,'notallowed'],  # %
        hat_sign                => ['^' ,'notallowed'],  # ^
        ampersand               => ['&' ,'notallowed'],  # &
        asterisk                => ['*' ,'optional'],  # *
        hyphen                  => ['-' ,'optional'],  # -
        underscore              => ['_' ,'optional'],  # _
        plus_sign               => ['+' ,'optional'],  # +
        equals_sign             => ['=' ,'optional'],  # =
        hash_sign               => ['#' ,'notallowed'],  # #
        tilde_sign              => ['~' ,'notallowed'],  # ~
        left_curly_bracket      => ['{' ,'notallowed'],  # {
        right_curly_bracket     => ['}' ,'notallowed'],  # }
        left_square_bracket     => ['[' ,'notallowed'],  # [
        right_square_bracket    => [']' ,'notallowed'],  # ]
        left_parentheses        => ['(' ,'notallowed'],  # (
        right_parentheses       => [')' ,'notallowed'],  # )
        left_angle_bracket      => ['<' ,'notallowed'],  # <
        right_angle_bracket     => ['>' ,'notallowed'],  # >
        colon                   => [':' ,'notallowed'],  # :
        semi_colon              => [';' ,'notallowed'],  # ;
        fullstop                => ['.' ,'optional'],  # .
        comma                   => [',' ,'optional'],  # ,
        forward_slash           => ['/' ,'notallowed'],  # /
        back_slash              => ['\\','notallowed'],  # \
        pipe                    => ['|' ,'notallowed'],  # |
    };


our $AlphaNumericOnly = {
    %$Default,
    exclamation_mark        => ['!' ,'notallowed'],  # !
    question_mark           => ['?' ,'notallowed'],  # ?
    double_quote            => ['"' ,'notallowed'],  # "
    single_quote            => ["'" ,'notallowed'],  # '
    pound_sign              => ['£' ,'notallowed'],  # £
    dollar_sign             => ['$' ,'notallowed'],  # $
    percent_sign            => ['%' ,'notallowed'],  # %
    hat_sign                => ['^' ,'notallowed'],  # ^
    ampersand               => ['&' ,'notallowed'],  # &
    asterisk                => ['*' ,'notallowed'],  # *
    hyphen                  => ['-' ,'notallowed'],  # -
    underscore              => ['_' ,'notallowed'],  # _
    plus_sign               => ['+' ,'notallowed'],  # +
    equals_sign             => ['=' ,'notallowed'],  # =
    hash_sign               => ['#' ,'notallowed'],  # #
    tilde_sign              => ['~' ,'notallowed'],  # ~
    left_curly_bracket      => ['{' ,'notallowed'],  # {
    right_curly_bracket     => ['}' ,'notallowed'],  # }
    left_square_bracket     => ['[' ,'notallowed'],  # [
    right_square_bracket    => [']' ,'notallowed'],  # ]
    left_parentheses        => ['(' ,'notallowed'],  # (
    right_parentheses       => [')' ,'notallowed'],  # )
    left_angle_bracket      => ['<' ,'notallowed'],  # <
    right_angle_bracket     => ['>' ,'notallowed'],  # > # should be right_angle_bracket
    colon                   => [':' ,'notallowed'],  # :
    semi_colon              => [';' ,'notallowed'],  # ;
    fullstop                => ['.' ,'notallowed'],  # .
    comma                   => [',' ,'notallowed'],  # ,
    forward_slash           => ['/' ,'notallowed'],  # /
    back_slash              => ['\\','notallowed'],  # \
    pipe                    => ['|' ,'notallowed'],  # |
};

# AlphaNumericOnly used to be known as Eon
our $Eon = $AlphaNumericOnly;

our $ThreeEx = {
    %$Default,
    exclamation_mark        => ['!' ,'required'],  # !
    question_mark           => ['?' ,'optional'],  # ?
    double_quote            => ['"' ,'notallowed'],  # "
    single_quote            => ["'" ,'notallowed'],  # '
    pound_sign              => ['£' ,'notallowed'],  # £
    dollar_sign             => ['$' ,'notallowed'],  # $
    percent_sign            => ['%' ,'notallowed'],  # %
    hat_sign                => ['^' ,'notallowed'],  # ^
    ampersand               => ['&' ,'notallowed'],  # &
    asterisk                => ['*' ,'notallowed'],  # *
    hyphen                  => ['-' ,'notallowed'],  # -
    underscore              => ['_' ,'notallowed'],  # _
    plus_sign               => ['+' ,'notallowed'],  # +
    equals_sign             => ['=' ,'notallowed'],  # =
    hash_sign               => ['#' ,'notallowed'],  # #
    tilde_sign              => ['~' ,'notallowed'],  # ~
    left_curly_bracket      => ['{' ,'notallowed'],  # {
    right_curly_bracket     => ['}' ,'notallowed'],  # }
    left_square_bracket     => ['[' ,'notallowed'],  # [
    right_square_bracket    => [']' ,'notallowed'],  # ]
    left_parentheses        => ['(' ,'notallowed'],  # (
    right_parentheses       => [')' ,'notallowed'],  # )
    left_angle_bracket      => ['<' ,'notallowed'],  # <
    right_angle_bracket     => ['>' ,'notallowed'],  # > # should be right_angle_bracket
    colon                   => [':' ,'notallowed'],  # :
    semi_colon              => [';' ,'notallowed'],  # ;
    fullstop                => ['.' ,'notallowed'],  # .
    comma                   => [',' ,'notallowed'],  # ,
    forward_slash           => ['/' ,'notallowed'],  # /
    back_slash              => ['\\','notallowed'],  # \
    pipe                    => ['|' ,'notallowed'],  # |
};

our $VariousOpts = {
    %$Default,
    exclamation_mark        => ['!' ,'optional'],  # !
    question_mark           => ['?' ,'optional'],  # ?
    double_quote            => ['"' ,'notallowed'],  # "
    single_quote            => ["'" ,'notallowed'],  # '
    pound_sign              => ['£' ,'optional'],  # £
    dollar_sign             => ['$' ,'optional'],  # $
    percent_sign            => ['%' ,'optional'],  # %
    hat_sign                => ['^' ,'notallowed'],  # ^
    ampersand               => ['&' ,'optional'],  # &
    asterisk                => ['*' ,'notallowed'],  # *
    hyphen                  => ['-' ,'optional'],  # -
    underscore              => ['_' ,'optional'],  # _
    plus_sign               => ['+' ,'notallowed'],  # +
    equals_sign             => ['=' ,'notallowed'],  # =
    hash_sign               => ['#' ,'notallowed'],  # #
    tilde_sign              => ['~' ,'notallowed'],  # ~
    left_curly_bracket      => ['{' ,'notallowed'],  # {
    right_curly_bracket     => ['}' ,'notallowed'],  # }
    left_square_bracket     => ['[' ,'notallowed'],  # [
    right_square_bracket    => [']' ,'notallowed'],  # ]
    left_parentheses        => ['(' ,'notallowed'],  # (
    right_parentheses       => [')' ,'notallowed'],  # )
    left_angle_bracket      => ['<' ,'notallowed'],  # <
    right_angle_bracket     => ['>' ,'notallowed'],  # > # should be right_angle_bracket
    colon                   => [':' ,'notallowed'],  # :
    semi_colon              => [';' ,'notallowed'],  # ;
    fullstop                => ['.' ,'notallowed'],  # .
    comma                   => [',' ,'notallowed'],  # ,
    forward_slash           => ['/' ,'notallowed'],  # /
    back_slash              => ['\\','notallowed'],  # \
    pipe                    => ['|' ,'notallowed'],  # |
};


########
# Checking out of the OriginalKeyOrder against the Char defs.
########
# The OriginalKeyOrder was needed because of a bug in KhaosCrypt
# that became apparent when perl 5.18 started randomising hash key order
# and this was the "quick fix" to stop me from having to reset a LOT
# of passwords that had been generated.

# @OriginalKeyOrder copuld be called perl-5-14-hash-key-order ;) well just before perl-5.17.sumin order.
our @OriginalKeyOrder = qw{ right_curly_bracket hyphen right_parentheses pipe
        plus_sign back_slash hash_sign pound_sign tilde_sign exclamation_mark
        comma semi_colon double_quote colon percent_sign lower_case_alpha
        left_square_bracket fullstop left_parentheses hat_sign equals_sign
        left_curly_bracket upper_case_alpha dollar_sign question_mark single_quote
        underscore ampersand right_square_bracket right_angle_bracket
        forward_slash numeric left_angle_bracket asterisk };

# TODO , the symbolic_char_names like "question_mark" need factoring out from the char_definition_sets.

# SymbolicCharname maps the charname to the actual character, unless its a RANGE character definition.
our $SymbolicCharname = {
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

my $sorted_SymbolicCharnames = join( ' ', sort keys %{$SymbolicCharname} );
my $orig_sorted_keys         = join( ' ', sort @OriginalKeyOrder );
if ( $orig_sorted_keys ne $sorted_SymbolicCharnames ) {
    # sanity check on the serialised-sorted-array-of-the-keys
    die "DIE !!!! because :-\n    $sorted_SymbolicCharnames\n IS NOT THE SAME AS :-\n    $orig_sorted_keys  \n These are serialisations of the keys of the character defs. \n";
}

for my $char_def ( qw/AllChars Default Google ThreeEx Eon AlphaNumericOnly VariousOpts/){

    my $t_our = __PACKAGE__."::$char_def";

    my $t_our_sorted_keys = join( ' ', sort keys %{${$t_our}});
    ## my $orig_sorted_keys  = join( ' ', sort @OriginalKeyOrder);

    if ( $orig_sorted_keys ne $t_our_sorted_keys ) {
        # sanity check on the serialised-sorted-array-of-the-keys
        die "DIE !!!! because :-\n    $t_our_sorted_keys\n IS NOT THE SAME AS :-\n    $orig_sorted_keys  \n These are serialisations of the keys of the character defs. \n";
    }
}
################################
## Hacking 

1;
