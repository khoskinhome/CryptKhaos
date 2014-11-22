package KhaosCrypt::Conf::Home;
use strict;

# THIS IS THE OLD WAY OF DOING STUFF. THIS FILE AND ALL ITS CONTENTS WILL GET DELETED ONCE "Crypt::Khaos" is working


use base 'KhaosCrypt::ConfBase';

use KhaosCrypt::Chars;


our $TT_SIGNATURE = 'x3' ;

our $CAN_VPN_KEEPY_UP = '';

our $MAXLENGTH = {
    home_blah    => 20,
    another_home => 1,
};

our $SERVICES = {

    home_blah    => $KhaosCrypt::Chars::Default,
    another_home => $KhaosCrypt::Chars::Eon,
    this_aint_g  => $KhaosCrypt::Chars::Google,

};

1;
