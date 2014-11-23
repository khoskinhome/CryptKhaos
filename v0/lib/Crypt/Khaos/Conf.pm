package Crypt::Khaos::Conf;
use strict;
use warnings;

use JSON;
use Crypt::Khaos::Utils;
use Crypt::Khaos::Conf::CharSetDefaults;
use File::Slurp;
use Params::Validate;

# all_conf holds all the conf that is read in.
# it gets reset everytime the readInConf is run.
my $all_conf ;

=pod

This module is to read in all the configs, all 3 types of them.
Sanity check them.
supply accessors for this information that the rest of the program can use.

=cut

&getConfDir; # this will check some conf stuff. it might die.

=item getConfDir

B<Description>

gets the config directory this can be either in the $ENV{CRYPT_KHAOS_CONF_DIR},
if that doesn't exist it defaults to $ENV{CRYPT_KHAOS_CONF_DIR}

B<Parameters>

none

B<Returns>

string value of the config directory.

B<Throws>

dies if $ENV{CRYPT_KHAOS_CONF_DIR} is defined, but the directory doesn't exist on the filing system.

=cut


sub getConfDir {
    if ( exists $ENV{CRYPT_KHAOS_CONF_DIR} && $ENV{CRYPT_KHAOS_CONF_DIR} && ! -d $ENV{CRYPT_KHAOS_CONF_DIR} ){
        die "Error::Crypt::Khaos::Conf : env var \$CRYPT_KHAOS_CONF_DIR is defined, but the dir doesn't exist. This script is dying.\n";
    }
    return $ENV{CRYPT_KHAOS_CONF_DIR} || "$ENV{HOME}/.cryptkhaos/conf";
}

=item readInConf

B<Description>

read in all the config, the hard-coded char-sets and
the conf files in the conf dir.

parse, validate them and fills up the conf-data-structure.

B<Parameters>

none

B<Returns>

void

B<Throws>

dies if the config is broken.

=cut

sub readInConf {

    my ( $class, $force ) = @_;

    if ( ! $force && $all_conf->{readInConf_run} ){
        return;
    }

    # clear the all_conf :-
    # and populate with the default char-sets
    $all_conf = {
        readInConf_run   => 0,   # boolean that indicates if readInConf has run.
        main         => undef,
        char_sets    => Crypt::Khaos::Conf::CharSetDefaults->getAll(),
        service_sets => {},
    };

    my $confDir = getConfDir();
    opendir( DIR, $confDir ) or die "Error::Crypt::Khaos::Conf : $!";

    my $json_conf_count = 0 ;
    while (my $file = readdir(DIR)) {
        if ( ! -d $file && $file =~ /\.json$/ ){
            $json_conf_count++;
            my $abs_file = $confDir."/".$file ;
            $abs_file =~ s{/+}{/}g; # turn multiple slashes to single.
            print $abs_file."\n";

            my $json_text = read_file( $abs_file ) ;

            my $json_struct = JSON->new->utf8->decode($json_text);
#use Data::Dumper;print STDERR "\n##########################\nkarl dumper of  $file  =".Dumper ($json_struct); # TODO rm this line

            # dispatch to a sub dependent on the type of config

            if ( $json_struct->{type} eq 'main' ) {
                $class->_parseConf_main($json_struct);
                next;
            }
            if ( $json_struct->{type} eq 'char_set' ) {
                $class->_parseConf_char_set($json_struct);
                next;
            }
            if ( $json_struct->{type} eq 'service_set' ) {
                $class->_parseConf_service_set($json_struct);
                next;
            }
            die "We have a config $abs_file and its type '$json_struct->{type}' is unrecognised\n";
        }
    }

    die "Error::Crypt::Khaos::Conf : didn't find any json conf files in $confDir \n" if ! $json_conf_count;

    $class->validateAllConf();

    $all_conf->{readInConf_run} = 1;

    return;
}

sub _parseConf_main {
    # TODO write this
    my ($class, $json_struct) = @_;
#    print STDERR "karl _parseConf_main  \n"; # TODO rm this line

    if (defined $all_conf->{main}) {
        die "Error::Crypt::Khaos::Conf : we have more than 1 json config of the 'type' == 'main' ";
    }

    $all_conf->{main} = $json_struct;
}

sub _parseConf_char_set {
    # TODO write this
    my ($class, $json_struct) = @_;
#    print STDERR "karl _parseConf_char_set  \n"; # TODO rm this line

    my $char_set_name = $json_struct->{name};

    if ( exists $all_conf->{char_sets}{$char_set_name} ) {
        die "Error::Crypt::Khaos::Conf : we have more than 1 json config of the 'type' == 'char_set' , name == $char_set_name\n";
    };

    $all_conf->{char_sets}{$char_set_name} = $json_struct;
}

sub _parseConf_service_set {
    # TODO write this
    my ($class, $json_struct) = @_;
#    print STDERR "karl _parseConf_service_set  \n"; # TODO rm this line
    my $service_set_name = $json_struct->{name};

    if ( exists $all_conf->{service_sets}{$service_set_name} ) {
        die "Error::Crypt::Khaos::Conf : we have more than 1 json config of the 'type' == 'service_set' , name == $service_set_name\n";
    };

    $all_conf->{service_sets}{$service_set_name} = $json_struct;
}

=item validateAllConf

B<Description>

validates the conf in the $all_conf global lexical variable,
and validates that it is consistent, and has all the necessary parts

B<Parameters>

none

B<Throws>

will die if the conf is bad

=cut

sub validateAllConf {
    my ($class) = @_;

    $class->validateMainConf();

    for my $char_set ( sort keys %{$all_conf->{char_sets}} ){
        $class->validateCharSetConf($char_set);
    }

    for my $service_set ( sort keys %{$all_conf->{service_sets}} ){
        $class->validateServiceSetConf($service_set);
    }

    return;
}

=item validateCharSetConf

B<Description>

validates an individual char-set-conf in the $all_conf global lexical variable,
and validates that it is consistent, and has all the necessary parts

B<Parameters>

char-set-name

B<Throws>

will die if the conf is bad
will die if char-set-name isn't supplied or doesn't exist.

=cut


sub validateCharSetConf {
    my ($class, $charsetname) = @_;

    # TODO , write the validation based on the following structure :-

#$examples{char_set_one} = {
#    type  => 'char_set',
#    name  => 'one', # the hard-coded char_set are reserved, see Crypt::Khaos::Conf::CharSetDefaults for there names;
#    chars => { # the ones defined in Crypt::Khaos::CharactersSymbolic;
#        lower_case_alpha        => 'required',
#        upper_case_alpha        => 'required',
#        numeric                 => 'required',
#        exclamation_mark        => 'notallowed',
#        question_mark           => 'notallowed',
#        double_quote            => 'optional',
#        single_quote            => 'optional',
#        pound_sign              => 'optional',
#        dollar_sign             => 'optional',
#        percent_sign            => 'optional',
#        hat_sign                => 'optional',
#        ampersand               => 'optional',
#        asterisk                => 'optional',
#        hyphen                  => 'optional',
#        underscore              => 'optional',
#        plus_sign               => 'optional',
#        equals_sign             => 'optional',
#        hash_sign               => 'optional',
#        tilde_sign              => 'optional',
#        left_curly_bracket      => 'optional',
#        right_curly_bracket     => 'optional',
#        left_square_bracket     => 'optional',
#        right_square_bracket    => 'optional',
#        left_parentheses        => 'optional',
#        right_parentheses       => 'optional',
#        left_angle_bracket      => 'optional',
#        right_angle_bracket     => 'optional',
#        colon                   => 'optional',
#        semi_colon              => 'optional',
#        fullstop                => 'optional',
#        comma                   => 'optional',
#        forward_slash           => 'optional',
#        back_slash              => 'optional',
#        pipe                    => 'optional',
#    },
#};
#
#

    return;
}

=item validateServiceSetConf

B<Description>

validates an individual service-set-conf in the $all_conf global lexical variable,
and validates that it is consistent, and has all the necessary parts

B<Parameters>

service-set-name

B<Throws>

will die if the conf is bad
will die if service-set-name isn't supplied or doesn't exist.

=cut

sub validateServiceSetConf {
    my ($class) = @_;

    # TODO , write the validation based on the following structure :-
#$examples{default_service_set} = {
#    type => 'service_set',
#    name => 'an-example-service-set',
#
#    use_5_14_OriginalKeyOrder_sort => 1, # optional. the fix to make the SymbolicCharacter names (hash-keys) sorted as they were in perl 5.14 instead of the enforced randomness needed in perl-5.18 onwards . default = 0. eventually this should be deprecated, and the enforced SymbolicCharacter name sort enforced.
#
#    # signature generation and detection stuff >> 
#    signature_service_name => 'name-for-signature-generation',
#    signature_service_name_char_set => 'char-set-default',
#    signature_service_name_iterations => 1000, # The number of iterations passed to Crypt::PBKDF2 
#    signature_service_name_hash_class => 'HMACSHA1',
#    # Deliberately NO signature_service_name_maxlength.
#    signature_result => 'vE', # the last 2 or say 3 characters of the signature that was generated.
#
#    default_services_username  => '',
#    default_services_char_set  => 'allchars',
#    default_services_maxlength => 99999,
#    default_services_iterations => 1000,
#    default_services_hashclass => 'HMACSHA1',
#    default_services_suffix_executable => '/path/to/executable', # this is an executable program for ALL services, that will output something to suffix onto the end of the service_name. If this is set to a blank string, then nothing will be added. This would allow say a usb-crypto key to generate some number or string, to add on to the service_name. Blank will mean it will not run anything.
#
#    services => {
#        'some-web-site' =>{  # so here 'some-web-site' is a service_name. doesn't have to be a web-site ;) . it is just a unique name for the "service".
#            username =>'optional-username', # optional. If this is present, it will get output when an encrypted password is generated, or substituted into $CRYPT_KHAOS_USERNAME in CLI_command strings.
#            char_set => 'char-set-google',  # this char_set must exist
#            maxlength => 999, # optional. If this does exist it will truncate the generated key down to the length defined.
#            iterations => 987,  # optional. The number of iterations passed to Crypt::PBKDF2 , default == 1000 (hardcoded in the prog. somewhere)
#            hash_class => 'HMACSHA1', # optional. The hash_class passed to Crypt::PBKDF2 , default == 'HMACSHA1'(hardcoded in the prog. somewhere)
#            suffix_executable => '/path/to/executable', # this is an executable program for This service. overriding the default one. You'll rarely use this. Blank will mean it will not run anything.
#        },
#        'some-cli-prog' =>{
#            char_set => 'char-set-name',
#            username =>'optional-username', # optional. If this is present, it will get output when an encrypted password is generated,
#            maxlength => 999,
#            iterations => 987,
#            hash_class => 'HMACSHA1',
#        },
#    },
#
#    commands => { # these are the cli "commands" that can be run. the executable they run, and the service_name they use to generate the password.
#        'runthis' => {
#            CLI_command=>'/some/executable -username=blah -password=$CRYPT_KHAOS_PASSWORD -username=$CRYPT_KHAOS_USERNAME', # and $CRYPT_KHAOS_PASSWORD will get changed to what is generated. If the service->username is present, then $CRYPT_KHAOS_USERNAME will get changed to that.
#            service_name => 'name-of-the-service', # that does the encrypting .
#        },
#    },
#
#};
#


    return;
}

=item validateMainConf

B<Description>

validates the main conf in the $all_conf global lexical variable,
and validates that it is consistent, and has all the necessary parts

B<Parameters>

none

B<Throws>

will die if the conf is bad

=cut

sub validateMainConf {
    my ($class) = @_;

    if ( ! defined $all_conf->{main} ) {
        die "Error::Crypt::Khaos::Conf : main conf not defined\n";
    }

    # TODO , write the validation based on the following structure :-
#
#$examples{main} = {
#    name =>"main", # same as the filename.
#    type=>"main", # there are only 3 'types' of json conf file. "main" , "char_set" and "service_set"
#    timeout=>1800,
#    copy_to_clipboard => 1, # this is what you'll usually want.
#    hide_generated_password => 1, # this is what you'll want if the password is copied to clipboard
#};
#

#    my $allowed_field_names = {
#        name => { 'optional',
#        type => 'required',
#        timeout => 'default:1800',
#        copy_to_clipboard = > 'default:1',
#        hide_generated_password => 
#
#    };
#

    # does it really need a "name" ? there's only 1 of the frickin' things. Deprecate this crap.
    #if ( ! defined $all_conf->{main}{name} || $all_conf->{main}{name} ne 'main' ) {
    #    die "Error::Crypt::Khaos::Conf : main conf name isn't called main\n";
    #}
#
#    if ( ! defined $all_conf->{main}{type} || $all_conf->{main}{type} ne 'main' ) {
#        die "Error::Crypt::Khaos::Conf : main type isn't called main\n";
#    }
#
#    if ( ! defined $all_conf->{main}{timeout} || $all_conf->{main}{type} ne 'main' ) {
#        die "Error::Crypt::Khaos::Conf : main type isn't called main\n";
#    }
#
#    timeout=>1800,
#    copy_to_clipboard => 1, # this is what you'll usually want.
#    hide_generated_password => 1, # this is what you'll want if the password is copied to clipboard
#
#
    return;
}

=item getServiceSetNames

B<Description>

returns a list of service-set names.
a service-set-name is needed when getting a service-set.

B<Parameters>

none

B<Returns>

a list of the service-set-names (NOT service-names)

=cut

sub getServiceSetNames {
    my ($class) = @_;

    $class->readInConf if ( ! $all_conf->{readInConf_run} );

    my @service_sets = sort keys %{$all_conf->{service_sets}};

    die "Error::Crypt::Khaos::Conf : there doesn't seem to be any service-sets defined\n" if ! @service_sets ;

    return @service_sets;
}

=item getCharSetNames

B<Description>

returns a list of char-set names.
a char-set-name is needed when getting a char-set.

B<Parameters>

none

B<Returns>

a list of the char-set-names

=cut

sub getCharSetNames {
    my ($class) = @_;

    $class->readInConf if ( ! $all_conf->{readInConf_run} );

    my @char_sets = sort keys %{$all_conf->{char_sets}};

    die "Error::Crypt::Khaos::Conf : there doesn't seem to be any char-sets defined\n" if ! @char_sets ;

    return @char_sets;
}

# the following should be dropped, asap. TODO
# and be replaced with individual accessors.
sub get_all_conf {
    return $all_conf;
}

1;
