package Crypt::Khaos::Conf;
use strict;
use warnings;


&getConfDir;
# TODO check $ENV{CRYPT_KHAOS_LIB} and $ENV{CRYPT_KHAOS_BIN} and die
# better still check how other modules put executables in /usr/local/bin/ and how they install to the perl-path


use JSON;
use Crypt::Khaos::Utils;
use File::Slurp;


my $all_conf = {
    readInConf_run   => 0,   # boolean that indicates if readInConf has run.
    main         => undef,
    char_sets    => {},
    service_sets => {},
};

sub new {
    my ( $class )  = @_;

}

sub getConfDir {

    if ( exists $ENV{CRYPT_KHAOS_CONF_DIR} && $ENV{CRYPT_KHAOS_CONF_DIR} && ! -d $ENV{CRYPT_KHAOS_CONF_DIR} ){
        die "env var \$CRYPT_KHAOS_CONF_DIR is defined, but the dir doesn't exist. This script is dying.\n";
    }

    return $ENV{CRYPT_KHAOS_CONF_DIR} || "$ENV{HOME}/.cryptkhaos/conf";
}

=item readInConf

B<Description>

To find all the conf files in the conf dir, parse and validate them
and fill up the conf-data-structure.

=cut

sub readInConf {

    my ( $class, $force ) = @_;

    if ( ! $force && $all_conf->{readInConf_run} ){
        return;
    }

    my $confDir = getConfDir();
    opendir (DIR, $confDir ) or die $!;

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
            die "We have a config $abs_file and its type = '$json_struct->{type}'. This isn't allowed\n";
        }

    }

    die "didn't find any json conf files in $confDir \n" if ! $json_conf_count;

    $all_conf->{readInConf_run} = 1;

    return;
}

sub _parseConf_main {
    # TODO write this
    my ($class, $json_struct) = @_;
#    print STDERR "karl _parseConf_main  \n"; # TODO rm this line

    if (defined $all_conf->{main}) {
        die "we have more than 1 json config of the 'type' == 'main' ";
    }
 
    $all_conf->{main} = $json_struct;

}

sub _parseConf_char_set {
    # TODO write this
    my ($class, $json_struct) = @_;
#    print STDERR "karl _parseConf_char_set  \n"; # TODO rm this line

    $all_conf->{char_sets}{$json_struct->{name}} = $json_struct;

}

sub _parseConf_service_set {
    # TODO write this
    my ($class, $json_struct) = @_;
#    print STDERR "karl _parseConf_service_set  \n"; # TODO rm this line

    $all_conf->{service_sets}{$json_struct->{name}} = $json_struct;
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

    die "there doesn't seem to be any service-sets defined\n" if ! @service_sets ;

    return @service_sets;


}


# the following should be dropped, asap. TODO
sub get_all_conf {
    return $all_conf;
}


=pod

This module is to read in all the configs, all 3 types of them.
Sanity check them.
Then give the rest of the program the config information.

=cut



1;
