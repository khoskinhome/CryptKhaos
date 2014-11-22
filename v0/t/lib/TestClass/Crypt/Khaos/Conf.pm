package TestClass::Crypt::Khaos::Conf;
use strict;

# also tests the Crypt::Khaos::Conf::ExampleDumps

use base qw( Test::Class );

use Test::More;
use Test::Exception;

use Data::Dumper;

BEGIN {
    require Crypt::Khaos::Conf;
    require Crypt::Khaos::Conf::ExampleDumps;

}


my $tmp_test_crypt_khaos = "/tmp/test-crypt-khaos/";

sub make_fixture : Test(setup) {
    my ( $self ) = @_;
    $ENV{CRYPT_KHAOS_CONF_DIR}="$tmp_test_crypt_khaos/conf";

    _setup_tmp_test_dirs();
}


sub test_getConfDir : Test(no_plan) {
    my ($self) = @_;
    ok ( 1 );

    is ( Crypt::Khaos::Conf->getConfDir , "$tmp_test_crypt_khaos/conf" );

    delete $ENV{CRYPT_KHAOS_CONF_DIR};

    is ( Crypt::Khaos::Conf->getConfDir , "$ENV{HOME}/.cryptkhaos/conf" );

    diag ( "finished test_getConfDir\n" );
};

sub test_readInConf : Test(no_plan) {
    my ($self) = @_;
    ok ( 1 );

    is ( Crypt::Khaos::Conf->getConfDir , "$tmp_test_crypt_khaos/conf" );

    my @service_set_names;

    dies_ok { Crypt::Khaos::Conf->readInConf() } 'no conf files yet';
    dies_ok { @service_set_names = Crypt::Khaos::Conf->getServiceSetNames()} 'no service sets yet';

    # first use the Crypt::Khaos::Conf::ExampleDumps
    Crypt::Khaos::Conf::ExampleDumps->dump( Crypt::Khaos::Conf->getConfDir );

    lives_ok { Crypt::Khaos::Conf->readInConf(1) } 'conf files ';
    lives_ok { @service_set_names = Crypt::Khaos::Conf->getServiceSetNames()} 'service sets defined';

    is_deeply( \@service_set_names , ['an-example-service-set'], "test result from getServiceSetNames" );



    #diag ( "finished test_readInConf\n" );
};


sub test_check_config_with_good_config : Test(no_plan) {
    my ($self) = @_;



    ok (  1 );

    #diag ( "finished test_check_config_with_good_config\n" );
}



sub _setup_tmp_test_dirs : Test(no_plan) {
    for my $cmd (

            "rm -rf $tmp_test_crypt_khaos" ,
            "mkdir -p $ENV{CRYPT_KHAOS_CONF_DIR}",

        ){
        system ( $cmd ) && die "couldn't run $cmd to prepare test\n";
    }
}

