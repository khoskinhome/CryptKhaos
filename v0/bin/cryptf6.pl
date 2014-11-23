#!/usr/bin/perl
use warnings;
use strict;
use 5.14.2;
use Data::Dumper;
use Term::ReadKey;
use Term::ReadLine;
use Crypt::PBKDF2;
use Clipboard;

# THIS IS THE OLD WAY OF DOING STUFF. THIS FILE AND ALL ITS CONTENTS WILL GET DELETED ONCE "Crypt::Khaos" is working



## TODO , should use cd $KHAOS_CRYPT_DIR to work out the ./lib for the KhaosCrypt Modules.

## TODO , maybe  call it Crypt::Khaos::CLI , need to look at cpan for sensible module names.

use KhaosCrypt::ConfBase;

# the returnpushedtimeout is only used in the loop when
# giving out pass phrases. we don't need to timeout anywhere else.
my $returnpushedtimeout = 1800;

  ## ./lib/KhaosCrypt/Conf/NewLayout.pm:42:  ## ./cryptf6.pl:19:my $pbkdf2 = Crypt::PBKDF2->new( # TODO rm this line # TODO rm this line
my $pbkdf2 = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA1', # this is the default
    iterations => 1000,       # so is this  # TODO change this before you give it to anyone. TODO maybe put this in individual service-confs
    output_len => 20,         # and this
    salt_len => 4,            # and this.
);

######################################################################
# getting the terminal input of $salt and $phrase

clear_terminal();
print_title();

my ( $salt, $phrase, $checkon);

my $ask_options = 0; # ask the "check-on" and "show-input" options
my $showinput = '';
while ( 1 )
{

    if ( ! $ask_options ) {
        $showinput  = '';
        last;
    }

    print "show input (y/n or blank) ? ";
    $showinput  = get_shielded_stdin();
    if ( lc($showinput) eq 'n' || ! $showinput){
        $showinput  = '';
        last;
    }
    last if lc($showinput) eq 'y';
}

# if we insist on the blank char bug we need the checkon sanity check.
while ( 1 )
{

    if ( ! $ask_options ) {
        $checkon ='y';
        last;
    }

    print "checkon ? (y/n) only >";
    $checkon = get_shielded_stdin();

    if ( ! $checkon ) {
        $checkon ='y';
        last;
    }
    last if $checkon =~ /^(y|n)$/i;
}

print "Enter rest of salt >\n";
$salt    .= get_shielded_stdin();
chomp $salt;


print "Enter rest of passphrase >\n";
$phrase .= get_shielded_stdin();
chomp $phrase;

if (length ($phrase) < 7 ) {
    die "phrase must be 7 or more chars\n";
}

my $truetrue_encode = '';
$truetrue_encode = encode ( $salt, $phrase, "truetrue" ) ;

my $vpnkeepyup_servicename = KhaosCrypt::ConfBase->get_vpn_ServiceName( $truetrue_encode );

#print "\nHERE \n";

print "\ntruetrue encode signature == ".substr($truetrue_encode,-2)."\n";

print "\nand you can do vpn keepy up with this service = $vpnkeepyup_servicename\n" if $vpnkeepyup_servicename;

########################
# populate service_names and service_number
my @service_names = KhaosCrypt::ConfBase->getServiceNames($truetrue_encode);

my @service_number = ();
{
my $i = 0;
    for my $theservice ( @service_names ) {
        $i++;
        $service_number[$i] = $theservice;
    }
}
########################

{
    my $err_msg = '';
    my $selected_service = '';
    my $encstr = '';
    my $selected_service_number = '';
    while ( 1 ){

        if (  $err_msg || $selected_service || $encstr ) {
            # if one of them is set , then we must have already done 1 loop,
            # so lets clear the screen :-
            clear_terminal();
        }

        print_title();

        # start printing the options in columns >
        my $termwidth = qx{tput cols};
        chomp $termwidth;
        my $one_entry_maxwidth = 0;
        for ( my $i=1; $i<@service_number ; $i++){
            my $out = "($i) $service_number[$i] | ";
            $one_entry_maxwidth = $one_entry_maxwidth < length($out) ? length($out) : $one_entry_maxwidth;
        }

        my $cols = int ( $termwidth / $one_entry_maxwidth ) || 1;

        my @rows= ();
        my $maxrow = int ((scalar @service_number) / $cols)+1;

        my $actualrow = 0;
        for ( my $i=1; $i<@service_number ; $i++){

            my $out = "($i) $service_number[$i]";
            my $lenout = length($out);

            my $spaces = $one_entry_maxwidth - $lenout - 3;
            $spaces = $spaces > 0 ? $spaces : 0 ;

            $out .= ( " " x $spaces   )." | ";

            $rows[$actualrow] .= $out ;
            $actualrow ++ ;

            $actualrow = 0 if $actualrow > $maxrow;
        }

        for my $trow ( @rows ){
            $trow =~ s/ \| $/\n/;
            print $trow;
        }
        print "####################\n";
        # < finished printing the columns in columns

        ####################
        my $datetime = qx{date};
        chomp $datetime;
        print "\n$datetime . Timeout in $returnpushedtimeout seconds\n";
        ####################

        if ( $encstr ) {
            print "\nlast result was :-\n\n";
            print "($selected_service_number) $selected_service . sig==".substr($encstr,-2)."\n";
        }

        # output and clear the err_msg :-
        print $err_msg if $err_msg;
        $err_msg = '';

        print "\nType number for service OR 'q' to quit ";
        print "OR 'vpn ' for vpn-keepy-up " if $vpnkeepyup_servicename ;
        print substr($truetrue_encode,-2);
        print " > ";

        ###############################################
        # Now get and process the input of what service :-

        $selected_service_number  = trim(get_shielded_stdin()) ;

        if ( ! $selected_service_number ) {
            $err_msg .= "\nyou need to enter something to get a result...\n";
            $selected_service ='';
            $encstr           ='';
            Clipboard->copy();
            next;
        }
        exit if lc($selected_service_number) eq 'q';

        ## firing up the VPN keepy up stuff :-
        if ( lc($selected_service_number) eq 'vpn' ) {
            if ( $vpnkeepyup_servicename ){
                print "we are in the correct grouping to run vpn , so ....";
                my $encpass = encode ( $salt, $phrase, $vpnkeepyup_servicename );
                system( "sudo touch /tmp/blah"); # just to get a sudo , so we can put '&' at the end of the next system command :-
                system( "sudo ".$ENV{HOME}."/bin/the_keepup_script.pl --password $encpass " );
                print "exiting crypt prog\n";
                exit;
            } else {
                $err_msg .= "\nwe aren't in the correct Conf-Service-Grouping for you to run vpnkeepyup\n";
                $selected_service ='';
                $encstr           ='';
                Clipboard->copy();
                next;
            }
        }

        if ( $selected_service_number !~ /^\d+$/ ) {
            $err_msg .= "\nyou need to enter a valid number that is on the list to get a result...\n";
            $selected_service ='';
            $encstr           ='';
            Clipboard->copy();
            next;
        }

        $selected_service = $service_number[$selected_service_number];

        if ( ! $selected_service ) {
            $err_msg .= "\nyou need to enter a valid number that is on the list to get a result...\n";
            $selected_service ='';
            $encstr           ='';
            Clipboard->copy();
            next;
        }

        $encstr = encode ( $salt, $phrase, $selected_service );

        Clipboard->copy($encstr);
    }
}
exit;

###################################################################

sub encode {
    my ($salt, $phrase, $service ) = @_;
    my $addonifcheckbuiltfails = '';

    my $built = '';
    while (1) {
        my $hexhash = $pbkdf2->PBKDF2_hex( $salt, $phrase.$service.$addonifcheckbuiltfails );

        $built = '';
        # _baseencode() can't cope with big numbers, so we have to chop up the hex string.
        # chop the hex number up into 8 digit parts as far as possible and encode each part separately
        my $str2encode='';
        for my $char ( $hexhash =~ /(.)/g ) {
            if ( length($str2encode) < 8 ) {
                $str2encode .= $char;
            } else {
                my $numeric = hex($str2encode);
                my $baseE = _baseencode($service, $numeric);
                $built .= $baseE;
                $str2encode = '';
            }
        }

        if ( $str2encode ) {
            #add any hex digits at the end that didn't make it into a block of 8
            my $numeric = hex($str2encode);
            $built .= _baseencode($service, $numeric);
            $str2encode = '';
        }

        # Truncate down to maxlength if maxlength is specified.
        my $maxlength = KhaosCrypt::ConfBase->getServiceMaxLengthSpec($service, $truetrue_encode);
        if ( $maxlength ){
            $built = substr($built, 0, $maxlength);
        }

        last if checkbuilt( $built , $service ); # and this will exit the endless loop.

        # So if checkbuilt fails then we'll be here,
        # and we'll add something on to addonifcheckbuiltfails and
        # try again to get all the characters required in the built string.
        $addonifcheckbuiltfails++;

        # TODO , some sort of warning about lots of iterations trying to get
        # all the required characters, and taking too many attempts.

        ## print "addonifcheckbuiltfails = ".$addonifcheckbuiltfails."\n";
    }
    return "$built";
}

=item checkbuilt

checkthat the built hash meets the required chars.

=cut

sub checkbuilt {

    my ($built , $service ) = @_;

    # get the required structure.
    my %required = ();

    my $use_chars = KhaosCrypt::ConfBase->getServiceCharSpec($service, $truetrue_encode);

    for my $charspec ( sort keys %{$use_chars}){
        if ( lc($use_chars->{$charspec}[1]) eq 'required' ){
            $required{$charspec}{char} = $use_chars->{$charspec}[0];
            $required{$charspec}{found} = 0;
        }
    };

TCHAR:
    for my $tchar ( $built =~ /(.)/g ){
        if ( $tchar =~ /[A-Z]/){
            $required{upper_case_alpha}{found}++;
            $required{upper_case_alpha}{char}='RANGE' if ! exists $required{upper_case_alpha}{char};
            next;
        }
        if ( $tchar =~ /[a-z]/){
            $required{lower_case_alpha}{found}++;
            $required{lower_case_alpha}{char}='RANGE' if ! exists $required{lower_case_alpha}{char};
            next;
        }
        if ( $tchar =~ /[0-9]/){
            $required{numeric}{found}++;
            $required{numeric}{char}='RANGE' if ! exists $required{numeric}{char};
            next;
        }
        for my $charlongname ( keys %required ){
            next if ( $charlongname =~ /(lower_case_alpha|numeric|upper_case_alpha)/);
            if ( $required{$charlongname}{char} eq $tchar ) {
                $required{$charlongname}{found}++;
                next TCHAR;
            }
        }
    }

    # make sure we got all the requireds
    # and return 0 if we didn't:-
    for my $charlongname ( keys %required ){
        return 0 if  ( ! $required{$charlongname}{found} );
    }
    return 1;
}

=item  _baseencode

=cut

sub _baseencode {
    my ($service, $num) = @_ ;

    if ( $num < 0 ) {
        die "can't convert negative numbers";
    }

    # special case of where we want the leading zero :-
    return "0" if $num == 0;

# bug seems to be in here somewher KARL 20141111

    my @chars =  @{get_optional_n_required_chars_for_service($service)};

    my $base = scalar @chars;

    my $base54num = '';
    while ( 1 ) {
        my $lsd = $num % $base; # lsd = least significant digit.

        $num = ( $num - $lsd ) / $base ;
        # return result suppressing most significant zero
        if ( $lsd == 0 && ( $num - .001 )  <= 0 ) {
            return $base54num;
        }
        $base54num = $chars[$lsd].$base54num;
        return $base54num if ( $num - .001 )  <= 0 ;
    }
}

sub get_optional_n_required_chars_for_service {
    my ( $service )  = @_ ;

    my @chars;

    # the below are always going to be in passwords , and are at the very least optional
    # ( if not required )
    #    lower_case_alpha        => 'required',
    #    upper_case_alpha        => 'required',
    #    numeric                 => 'required',
    # so just add them to the list of chars like so :-

    for my $c ( 0..9 , 'a'..'z' , 'A'..'Z' ) {
        push @chars, $c;
    }

    my $use_chars = KhaosCrypt::ConfBase->getServiceCharSpec($service, $truetrue_encode);

    my $new_join_keys = join ( ' ', sort keys %{$use_chars} );

    # the original_key_order is what perl version prior to 5.18 ( specifically 5.14.2 )
    # used to do on a "keys %$use_chars". The randomisation of keys as a security  fix
    # broke this , because I'd forgot to put a sort in front of the "keys"
    # This is therefore my "quick fix" , with sanity check on the
    # serialised-sorted-array-of-the-keys. The sanity check is now in KhaosCrypt::Chars module.

    my @original_key_order = @KhaosCrypt::Chars::OriginalKeyOrder;

    # stop the 'notallowed' chars from appearing in the list of valid chars.
    # and all the 'RANGE' characters have already been added above.
    for my $key ( @original_key_order ) {
        my $c = $use_chars->{$key};
        next if uc($c->[0]) eq 'RANGE';
        next if lc($c->[1]) eq 'notallowed';
        push @chars, $c->[0];
    }

    return \@chars;
}

sub get_shielded_stdin {
    my ($self) = @_;

    my ($retv) = eval {
        local $SIG{ALRM} = sub{die"alarm\n"};

        alarm($returnpushedtimeout);
        if ( lc($showinput) eq 'y') {
            my $in = <STDIN>;
            chomp $in;
            alarm(0);
            return $in;
        };

        my $in;
        ReadMode 2;
        while (not defined ($in = ReadLine(-1) )) {}
        ReadMode 0;
        chomp $in;
        print "\n";
        alarm(0);
        return $in;
    };

    if ($@){
        ReadMode 0;
        die "\ntimed out\n";
    }

    return $retv;
}

sub trim {
    my ($txt) = @_;
    $txt =~ s/^\s*//;
    $txt =~ s/\s*$//;
    return $txt;
}

sub clear_terminal {

    # TODO , maybe I should use something like :-
#
#    require Term::Screen::Uni;
#    my $scr = new Term::Screen::Uni;
#
#    $scr->clrscr()
#
#    or
#
#    use Term::ANSIScreen qw(cls);
#    cls();
#
#   instead of the un-portable :-

    print "\033[2J";   #clear the screen
    print "\033[0;0H"; #jump to 0,0

}

sub print_title { print "\n##################\nKhaos Crypt ! \n##################\n"; };
