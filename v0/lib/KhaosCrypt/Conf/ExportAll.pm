package  KhaosCrypt::Conf::ExportAll;
use warnings;
use strict;

# THIS IS THE OLD WAY OF DOING STUFF. THIS FILE AND ALL ITS CONTENTS WILL GET DELETED ONCE "Crypt::Khaos" is working


use 5.14.2;
use Data::Dumper;

use JSON;


use Crypt::Khaos::Conf;
use Crypt::Khaos::Utils;
use File::Slurp;

use KhaosCrypt::Chars;

use KhaosCrypt::Conf::Home;
use KhaosCrypt::Conf::HomeShared;
use KhaosCrypt::Conf::Work;

=pod

This is a transitional package that uses a couple of Crypt::Khaos modules even though this is KhaosCrypt.

it is just here to do the export of all the existing perl based configs into the JSON format.

As soon as Crypt::Khaos is fully working , with the exported configs, all this stuff will be deleted.

=cut


sub export {
    my ($class) = @_;

    my $exportdir = Crypt::Khaos::Conf->getConfDir()."/export";

    print "\n\nmkdir -p $exportdir\n\n";
    system( "mkdir -p $exportdir");

    my $json = JSON->new->allow_nonref;


    # export the charsets

    my $hashref2char_set_suffix_map = {};

    #for my $char_set_suffix ( qw/AllChars Default Google ThreeEx Eon AlphaNumericOnly VariousOpts/ ){
    #
    # only qw/Eon Google Default ThreeEx/ char_sets are the only ones referenced in the "Home" , "Work" , "HomeShared" confs.
    # Also , the following are synonyms :-
    # AllChars == Default
    # Eon      == AlphaNumericOnly
    #
    # this is the set of char set names i want to use , rather than the synonyms of Default and Eon.
    #

    print "###############\nExport the char_sets \n";
    for my $char_set_suffix ( qw/AllChars Google ThreeEx AlphaNumericOnly/ ){

        my $char_set = "KhaosCrypt::Chars::$char_set_suffix";
        print "\nExport $char_set\n";

        my $char_set_rh;
        {
            no strict 'refs';
            $char_set_rh = ${$char_set};
        };

        my $json_rh = {
            type => 'char_set' ,
            name => lc($char_set_suffix) ,
            chars => {} ,
        };

        for my $char_name ( keys %$char_set_rh ){
            $json_rh->{chars}{$char_name} = $char_set_rh->{$char_name}[1];
        }
        print "\n";

        $hashref2char_set_suffix_map->{"$char_set_rh"} = lc($char_set_suffix);

        my $json_text = $json->pretty->encode( $json_rh );
        my $filename = $exportdir."/".lc($char_set_suffix).".char_set.json";
        print "dumping $char_set_rh char_set $char_set_suffix TO $filename\n\n";
        write_file($filename, \$json_text);

    }

    ################################################################
    print "###############\nExport the service_sets \n";
    for my $cfpackage_suffix ( qw/Home HomeShared Work/ ) {
        my $cfpackage = "KhaosCrypt::Conf::$cfpackage_suffix";
        print "\nExport conf package = $cfpackage\n";
        # package KhaosCrypt::Conf::Home;
        # MAXLENGTH
        # SERVICES

        my ( $services_rh , $maxlength_rh , $tt_signature );
        {

            no strict 'refs';
            $services_rh  = ${"${cfpackage}::SERVICES"};
            $maxlength_rh = ${"${cfpackage}::MAXLENGTH"};
            $tt_signature = ${"${cfpackage}::TT_SIGNATURE"};

        }

        #use Data::Dumper;print STDERR "karl dumper of  services  =".Dumper ($services_rh); # TODO rm this line

        my $lc_cfpackage = lc($cfpackage_suffix);

        my $json_rh = {
            type => 'service_set' ,
            name => $lc_cfpackage ,
            use_5_14_OriginalKeyOrder_sort => 1,
            signature_service_name => 'truetrue',
            signature_service_name_char_set => 'allchars',
            signature_service_name_iterations => 1000,
            signature_service_name_hash_class => 'HMACSHA1',
            signature_result => 'xx' ,

            default_services_username  => '',
            default_services_char_set  => 'allchars',
            default_services_maxlength => 99999,
            default_services_iterations => 1000,
            default_services_hashclass => 'HMACSHA1',
            default_services_suffix_executable => '',

            services => { },
            commands => { }, # this can be filled in manually . anyway there isn't anything to export for this.
        };

        for my $service_name ( keys %$services_rh ){
            # now we can lookup the hash-ref-hexadecimal and map it to the char_set_name ( that we export earlier in this export sub ) :-
            my $the_char_set_name = $hashref2char_set_suffix_map->{$services_rh->{$service_name}} ;

            my %maxlength = ();
            if ( exists $maxlength_rh->{$service_name} ) {
                %maxlength = ( maxlength  => $maxlength_rh->{$service_name} ) ;
            }

            my %char_set = ();
            if ( $the_char_set_name ne 'allchars' ) { # we don't have to put the char_set in , if it is the default one.
                %char_set = ( char_set => $the_char_set_name );
            }

            $json_rh->{services}{$service_name} = {
                username   => '',
                %char_set  ,
                %maxlength ,
#                iterations => 1000,
#                hash_class => 'HMACSHA1',
#                suffix_executable => '', # the localised to this service-name one.
            };

        }
        print "\n";


        my $json_text = $json->pretty->encode( $json_rh );
        my $filename = $exportdir."/$lc_cfpackage.service_set.json";
        print "dumping service_set $lc_cfpackage TO $filename\n\n";
        write_file($filename, \$json_text);

    }

}

1;

