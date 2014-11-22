package Crypt::Khaos::Conf::ExampleDumps;
use strict;
use warnings;

use JSON;

use Crypt::Khaos::Conf;
use Crypt::Khaos::Utils;
use File::Slurp;

=pod

Dump example configs to an examples Dir.
########################################

dumps the 3 types of example json config files to Crypt::Khaos::Conf->getConfDir()."/examples";

(see  Crypt::Khaos::Conf->getConfDir() for how it works out the config directory,
unless defined by an environment variable this will default to $ENV{HOME}/.cryptkhaos/conf )

The above dir is "mkdir -p" , so if it didn't exist before
this was run, it will exist afterwards ( assuming filesystem
permissions allow this )

the script ./bin/crypt-khaos-dump-example-confs.pl will run the
dump() method on this module.

=cut

my %examples = ();

$examples{main} = {
    name =>"main", # same as the filename.
    type=>"main", # there are only 3 'types' of json conf file. "main" , "char_set" and "service_set"
    timeout=>1800,
    copy_to_clipboard => 1, # this is what you'll usually want.
    hide_generated_password => 1, # this is what you'll want if the password is copied to clipboard
};

# char_sets MUST only have the "chars" as those returned by Crypt::Khaos::CharactersSymbolic->getSymbolicCharnames
# they don't have to have ALL of them, but any character defined in a char_set
# must be in Crypt::Khaos::CharactersSymbolic->getSymbolicCharnames

$examples{char_set_one} = {
    type  => 'char_set',
    name  => 'one', # the hard-coded char_set are reserved, see Crypt::Khaos::Conf::CharSetDefaults for there names;
    chars => {
        lower_case_alpha        => 'required',
        upper_case_alpha        => 'required',
        numeric                 => 'required',
        exclamation_mark        => 'notallowed',
        question_mark           => 'notallowed',
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

$examples{char_set_google} = {  # a char_set that I found I could get to work with google.
    type  => 'char_set',
    name  => 'google', # same as the filename.
    chars => {
        lower_case_alpha        => 'required',
        upper_case_alpha        => 'required',
        numeric                 => 'required',
        exclamation_mark        => 'optional',
        question_mark           => 'optional',
        double_quote            => 'notallowed',
        single_quote            => 'optional',
        pound_sign              => 'optional',
        dollar_sign             => 'notallowed',
        percent_sign            => 'notallowed',
        hat_sign                => 'notallowed',
        ampersand               => 'notallowed',
        asterisk                => 'optional',
        hyphen                  => 'optional',
        underscore              => 'optional',
        plus_sign               => 'optional',
        equals_sign             => 'optional',
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
        fullstop                => 'optional',
        comma                   => 'optional',
        forward_slash           => 'notallowed',
        back_slash              => 'notallowed',
        pipe                    => 'notallowed',
    },
};

$examples{default_service_set} = {
    type => 'service_set',
    name => 'an-example-service-set',

    use_5_14_OriginalKeyOrder_sort => 1, # optional. the fix to make the SymbolicCharacter names (hash-keys) sorted as they were in perl 5.14 instead of the enforced randomness needed in perl-5.18 onwards . default = 0. eventually this should be deprecated, and the enforced SymbolicCharacter name sort enforced.

    # signature generation and detection stuff >> 
    signature_service_name => 'name-for-signature-generation',
    signature_service_name_char_set => 'char-set-default',
    signature_service_name_iterations => 1000, # The number of iterations passed to Crypt::PBKDF2 
    signature_service_name_hash_class => 'HMACSHA1',
    # Deliberately NO signature_service_name_maxlength.
    signature_result => 'vE', # the last 2 or say 3 characters of the signature that was generated.

    default_services_username  => '',
    default_services_char_set  => 'allchars',
    default_services_maxlength => 99999,
    default_services_iterations => 1000,
    default_services_hashclass => 'HMACSHA1',
    default_services_suffix_executable => '/path/to/executable', # this is an executable program for ALL services, that will output something to suffix onto the end of the service_name. If this is set to a blank string, then nothing will be added. This would allow say a usb-crypto key to generate some number or string, to add on to the service_name. Blank will mean it will not run anything.

    services => {
        'some-web-site' =>{  # so here 'some-web-site' is a service_name. doesn't have to be a web-site ;) . it is just a unique name for the "service".
            username =>'optional-username', # optional. If this is present, it will get output when an encrypted password is generated, or substituted into $CRYPT_KHAOS_USERNAME in CLI_command strings.
            char_set => 'char-set-google',  # this char_set must exist
            maxlength => 999, # optional. If this does exist it will truncate the generated key down to the length defined.
            iterations => 987,  # optional. The number of iterations passed to Crypt::PBKDF2 , default == 1000 (hardcoded in the prog. somewhere)
            hash_class => 'HMACSHA1', # optional. The hash_class passed to Crypt::PBKDF2 , default == 'HMACSHA1'(hardcoded in the prog. somewhere)
            suffix_executable => '/path/to/executable', # this is an executable program for This service. overriding the default one. You'll rarely use this. Blank will mean it will not run anything.
        },
        'some-cli-prog' =>{
            char_set => 'char-set-name',
            username =>'optional-username', # optional. If this is present, it will get output when an encrypted password is generated,
            maxlength => 999,
            iterations => 987,
            hash_class => 'HMACSHA1',
        },
    },

    commands => { # these are the cli "commands" that can be run. the executable they run, and the service_name they use to generate the password.
        'runthis' => {
            CLI_command=>'/some/executable -username=blah -password=$CRYPT_KHAOS_PASSWORD -username=$CRYPT_KHAOS_USERNAME', # and $CRYPT_KHAOS_PASSWORD will get changed to what is generated. If the service->username is present, then $CRYPT_KHAOS_USERNAME will get changed to that.
            service_name => 'name-of-the-service', # that does the encrypting .
        },
    },

};


sub dump {
    my ($class, $examplesdir ) = @_;

    $examplesdir = $examplesdir || Crypt::Khaos::Conf->getConfDir()."/examples";

    print "\n\nmkdir -p $examplesdir\n\n";
    system( "mkdir -p $examplesdir");

    my $json = JSON->new->allow_nonref;

    for my $t_ex ( keys \%examples ) {

        my $json_text = $json->pretty->encode( $examples{$t_ex} );


        my $filename = $examplesdir."/".$examples{$t_ex}{name}.".".$examples{$t_ex}{type}.".json";

        print STDERR "dumping $t_ex : name = ".$examples{$t_ex}{name}." : type = ".$examples{$t_ex}{type}." TO $filename\n\n"; # TODO rm this line


        write_file($filename, \$json_text);

    }
}

1;
