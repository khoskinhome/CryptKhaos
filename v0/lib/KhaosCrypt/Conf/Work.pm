package KhaosCrypt::Conf::Work;
use strict;

# THIS IS THE OLD WAY OF DOING STUFF. THIS FILE AND ALL ITS CONTENTS WILL GET DELETED ONCE "Crypt::Khaos" is working


use base 'KhaosCrypt::ConfBase';

use KhaosCrypt::Chars;
# the "truetrue" signature . i.e. last 2 chars of encoded
our $TT_SIGNATURE = 'x1';

# when the vpn keepy up is invoked, it needs the password generated
# by a service . This following variable indicates the service
# that is used for vpn-keepy-up . If it is a blank string , then
# no service for this conf can "vpn-keepy-up"
our $CAN_VPN_KEEPY_UP = 'work_blah_service';

# define services that have a maxlength on the password.
our $MAXLENGTH = {
    blah_work => 20,
};

our $SERVICES = {

    blah_work      => $KhaosCrypt::Chars::Eon,

};

1;
