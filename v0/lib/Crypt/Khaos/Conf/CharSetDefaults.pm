package Crypt::Khaos::Conf::CharSetDefaults;
use strict;
use warnings;

=pod

contains the four hard-coded char_sets

The "default", "alphanumericonly", "alloptional" and "alphanumericonly_and_optional" ones.

possibly the two most useful char_sets there are.

so the hard-coded char_sets are BANNED from
being used in user-defined char_sets defined in json config files,
because they are defined here, and we'd get a conflict .

=cut


=item char_set_default

this requires a lower_case_alpha, upper_case_alpha, numeric characters,
all the rest are optional

=cut

my $char_set_default = {
    type  => 'char_set',
    name  => 'default',
    chars => {
        lower_case_alpha        => 'required',
        upper_case_alpha        => 'required',
        numeric                 => 'required',
        exclamation_mark        => 'optional',
        question_mark           => 'optional',
        double_quote            => 'optional',
        single_quote            => 'optional',
        pound_sign              => 'optional',
        dollar_sign             => 'optional',
        percent_sign            => 'optional',
        hat_sign                => 'optional',
        ampersand               => 'optional',
        asterisk                => 'optional',
        hyphen                  => 'optional',
        underscore              => 'optional',
        plus_sign               => 'optional',
        equals_sign             => 'optional',
        hash_sign               => 'optional',
        tilde_sign              => 'optional',
        left_curly_bracket      => 'optional',
        right_curly_bracket     => 'optional',
        left_square_bracket     => 'optional',
        right_square_bracket    => 'optional',
        left_parentheses        => 'optional',
        right_parentheses       => 'optional',
        left_angle_bracket      => 'optional',
        right_angle_bracket     => 'optional',
        colon                   => 'optional',
        semi_colon              => 'optional',
        fullstop                => 'optional',
        comma                   => 'optional',
        forward_slash           => 'optional',
        back_slash              => 'optional',
        pipe                    => 'optional',
    },
};

sub getDefault{
    return $char_set_default ;
}

#######################

my $char_set_alphanumeric_only = {
    type  => 'char_set',
    name  => 'alphanumericonly',
    chars => {
        lower_case_alpha        => 'required',
        upper_case_alpha        => 'required',
        numeric                 => 'required',
        exclamation_mark        => 'notallowed',
        question_mark           => 'notallowed',
        double_quote            => 'notallowed',
        single_quote            => 'notallowed',
        pound_sign              => 'notallowed',
        dollar_sign             => 'notallowed',
        percent_sign            => 'notallowed',
        hat_sign                => 'notallowed',
        ampersand               => 'notallowed',
        asterisk                => 'notallowed',
        hyphen                  => 'notallowed',
        underscore              => 'notallowed',
        plus_sign               => 'notallowed',
        equals_sign             => 'notallowed',
        hash_sign               => 'notallowed',
        tilde_sign              => 'notallowed',
        left_curly_bracket      => 'notallowed',
        right_curly_bracket     => 'notallowed',
        left_square_bracket     => 'notallowed',
        right_square_bracket    => 'notallowed',
        left_parentheses        => 'notallowed',
        right_parentheses       => 'notallowed',
        left_angle_bracket      => 'notallowed',
        right_angle_bracket     => 'notallowed',
        colon                   => 'notallowed',
        semi_colon              => 'notallowed',
        fullstop                => 'notallowed',
        comma                   => 'notallowed',
        forward_slash           => 'notallowed',
        back_slash              => 'notallowed',
        pipe                    => 'notallowed',
    },
};

sub getAlphaNumericOnly {
    return $char_set_alphanumeric_only;
}

#######################

my $char_set_all_optional = {
    type  => 'char_set',
    name  => 'alloptional',
    chars => {
        lower_case_alpha        => 'optional',
        upper_case_alpha        => 'optional',
        numeric                 => 'optional',
        exclamation_mark        => 'optional',
        question_mark           => 'optional',
        double_quote            => 'optional',
        single_quote            => 'optional',
        pound_sign              => 'optional',
        dollar_sign             => 'optional',
        percent_sign            => 'optional',
        hat_sign                => 'optional',
        ampersand               => 'optional',
        asterisk                => 'optional',
        hyphen                  => 'optional',
        underscore              => 'optional',
        plus_sign               => 'optional',
        equals_sign             => 'optional',
        hash_sign               => 'optional',
        tilde_sign              => 'optional',
        left_curly_bracket      => 'optional',
        right_curly_bracket     => 'optional',
        left_square_bracket     => 'optional',
        right_square_bracket    => 'optional',
        left_parentheses        => 'optional',
        right_parentheses       => 'optional',
        left_angle_bracket      => 'optional',
        right_angle_bracket     => 'optional',
        colon                   => 'optional',
        semi_colon              => 'optional',
        fullstop                => 'optional',
        comma                   => 'optional',
        forward_slash           => 'optional',
        back_slash              => 'optional',
        pipe                    => 'optional',
    },
};

sub getAllOptional {
    return $char_set_all_optional;
}

#######################

my $char_set_alphanumericonly_and_optional = {
    type  => 'char_set',
    name  => 'alphanumericonly_and_optional',
    chars => {
        lower_case_alpha        => 'optional',
        upper_case_alpha        => 'optional',
        numeric                 => 'optional',
        exclamation_mark        => 'notallowed',
        question_mark           => 'notallowed',
        double_quote            => 'notallowed',
        single_quote            => 'notallowed',
        pound_sign              => 'notallowed',
        dollar_sign             => 'notallowed',
        percent_sign            => 'notallowed',
        hat_sign                => 'notallowed',
        ampersand               => 'notallowed',
        asterisk                => 'notallowed',
        hyphen                  => 'notallowed',
        underscore              => 'notallowed',
        plus_sign               => 'notallowed',
        equals_sign             => 'notallowed',
        hash_sign               => 'notallowed',
        tilde_sign              => 'notallowed',
        left_curly_bracket      => 'notallowed',
        right_curly_bracket     => 'notallowed',
        left_square_bracket     => 'notallowed',
        right_square_bracket    => 'notallowed',
        left_parentheses        => 'notallowed',
        right_parentheses       => 'notallowed',
        left_angle_bracket      => 'notallowed',
        right_angle_bracket     => 'notallowed',
        colon                   => 'notallowed',
        semi_colon              => 'notallowed',
        fullstop                => 'notallowed',
        comma                   => 'notallowed',
        forward_slash           => 'notallowed',
        back_slash              => 'notallowed',
        pipe                    => 'notallowed',
    },
};

sub getAlphaNumericOnlyAndOptional {
    return $char_set_alphanumericonly_and_optional;
}


1;
