package KhaosCrypt::Conf::HomeShared;
use strict;

# THIS IS THE OLD WAY OF DOING STUFF. THIS FILE AND ALL ITS CONTENTS WILL GET DELETED ONCE "Crypt::Khaos" is working


use base 'KhaosCrypt::ConfBase';

use KhaosCrypt::Chars;

our $TT_SIGNATURE = 'x2' ;

our $CAN_VPN_KEEPY_UP = '';

our $MAXLENGTH = {

};

our $SERVICES = {
    'somesharedservice'  => $KhaosCrypt::Chars::Eon,
};

1;
