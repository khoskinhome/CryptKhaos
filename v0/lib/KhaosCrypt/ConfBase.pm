package KhaosCrypt::ConfBase;
use strict;

# THIS IS THE OLD WAY OF DOING STUFF. THIS FILE AND ALL ITS CONTENTS WILL GET DELETED ONCE "Crypt::Khaos" is working

no strict 'refs';

use KhaosCrypt::Chars;

our %TT_SIGS = (); # to lookup the signature -> Conf-Package. (KhaosCrypt::Conf::xxxxx)

# TODO these use statements are then used again in the check for conflicting TT_SIGNATURES
# really need just one place for this stuff.

use KhaosCrypt::Conf::Home;
use KhaosCrypt::Conf::HomeShared;
use KhaosCrypt::Conf::Work;

for my $tpackage ( qw/  KhaosCrypt::Conf::Home
                        KhaosCrypt::Conf::HomeShared
                        KhaosCrypt::Conf::Work / ){

    my $ourttsig_var = $tpackage."::TT_SIGNATURE";

    my $actual_tt_sig = ${$ourttsig_var};

    if ( exists $TT_SIGS{"$actual_tt_sig"} ) {
        die " we have conflicting TT_SIGNATURES in KhaosCrypt::Conf(s)\n";
    }
    $TT_SIGS{"$actual_tt_sig"} = $tpackage;

}

sub getServiceCharSpec {

    my ($class , $service, $truetrue_encode) = @_ ;

    if ( $service eq "truetrue" ) {
        # we can't start looking up what KhaosCrypt::Conf::xxxx truetrue service is in
        # because the 2 char suffix signature from encoding truetrue is used to identify
        # which KhaosCrypt::Conf::xxxx to use.
        return $KhaosCrypt::Chars::Default;
    }

    my $ConfPackage = $class->getConfPackage($truetrue_encode);

    my $service2ret = ${"${ConfPackage}::SERVICES"}->{$service};

    return $service2ret;
}


sub getConfPackage {

    my ($class , $truetrue_encode) = @_ ;

    if ( ! $truetrue_encode ) {
        # we have a problem. We need the truetrue_encode to work out the 2 char suffixed TT_SIGNATURE
use Devel::StackTrace; print STDERR Devel::StackTrace->new->as_string; # TODO rm this line
        die "NO truetrue_encode supplied to KhaosCrypt::ConfBase->getConfPackage\n";
    }


    if ( ! exists $TT_SIGS{substr( $truetrue_encode , -2 )}){
        die "Can't find the TT_SIGNATURE ".substr( $truetrue_encode , -2 )."\n";
    }

    my $ConfPackage = $TT_SIGS{substr( $truetrue_encode , -2 )};

    return $ConfPackage;
}

sub getServiceNames {
    # just return a list of all the service names for the specific TT_SIGNATURE
    my ($class , $truetrue_encode) = @_ ;

    my $ConfPackage = $class->getConfPackage($truetrue_encode);

    return sort keys %{${"${ConfPackage}::SERVICES"}};
}

sub getServiceMaxLengthSpec {

    my ($class , $service, $truetrue_encode) = @_ ;

    return '' if $service eq "truetrue" ;

    my $ConfPackage = $class->getConfPackage($truetrue_encode);

    my $maxlength = ${"${ConfPackage}::MAXLENGTH"}->{$service} || '';

    return $maxlength;
}

sub get_vpn_ServiceName {

    my ($class , $truetrue_encode) = @_ ;

    return '' if ! $truetrue_encode ;

    my $ConfPackage = $class->getConfPackage($truetrue_encode);

    my $vpn_service_name = ${"${ConfPackage}::CAN_VPN_KEEPY_UP"} || '';

    return $vpn_service_name;
}

1;
