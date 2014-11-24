package Crypt::Khaos::Documentation;



=head Crypt::Khaos

(Q). What is Crypt::Khaos ?

(A). Crypt::Khaos is a password generator, that uses several different pieces of
information to generate very different passwords for different services.

The primary pieces of information it uses are a user typed "salt" and
user typed "passphrase" that are used different "service-names".

So the user just remembers one (or more) salt-and-passphrase pair and
can then generate unique strong passphrases for different "services".

A "service" can be a web-site , or password protected command line too.

Crypt::Khaos has a configuration system that allows for lots of services.

Servics are grouped into "service-sets" ( you have to have at least one
service-set ), where usually a "service-set" would share the same
salt-and-passphrase pair. Usually different service-sets
would have different salt-and-passphrase pairs ( although they don't have to )

The idea behind service-sets, is that you want to group say "home" services
together , and "work" services together, and you probably want different
salt-and-passphrase-pairs for each of them.



(Q). How secure is it ?

(A) The primary weakness of this system, is if a hacker, has this program,
has your config files to this program, access to your usb-stick, and can key-log you.
If they have all of these well then your XXXXed, because they will be able to
generate your passphrases. Mind you even if you weren't using Crypt::Khaos
you'd be XXXXed with the forementioned scenario.

Where this system is strong, is say a hacker, gets the hashing table of a web-service,
and then brute force attacks it ( nothing this generator ever looks like a dictionary word ),
even if they do crack your passphrase, the rest of your webservices and logins will
be using completely different generated passphrases. They will only have access
to one web-service.


(Q). What does Crypt::Khaos use to generate the unique passphrases ?

(A). At the core of this program the passphrase is generated Crypt::PBKDF2,
and this uses the salt-and-passphrase joined with the service-name and a few other
bits-and-bobs to generate very long hard to brute force passphrases.


(Q). So do I have just one user typed in salt and passphrase ?

(A). Well you can if you want, but you can also have different groupings of services, known as service-sets.
i.e you might have a "home" service-set , a "work" service-set and these could have different
salt-phrase pairs.


(Q). How does the program know which service-set I wish to use ?

(A). There is a feature called "signatures", where a service-name added your salt-phrase pair generates
a generated-passphrase. The last 2 or maybe 3 characters of this generated passphrase are put in the
service-set config file, and when you come along and type your salt-phrase pair, this generated passphrase
is created and if the last 2 maybe 3 characters match the "signature", then the program calculates
that is the service-set you wish to use.

This obviously gives an attacker a route into brute forcing your salt-phrase pair, so if you want
you don't have to have the signature in a service-set config, but then the program will have to display
these service-sets all the time because it will have no way of knowing that you have typed the correct
salt-passphrase .



that will generate service-passphrase for one salt-phrase pair, and














=cut 

=pod

# environment variable

    $CRYPT_KHAOS_CONF_DIR which if not set will default to $HOME/.cryptkhaos/conf


all the config files will be encoded in JSON,
and the filename suffix will be .json

# we will have
one "main-config"

   type => 'main',
   timeout => 1800 ,

one or more "char-def-sets" confs
    type => 'char_set'
    name => 'name-of-the-char-set'
    chars=>{


    }

there will be a hard-coded "char_set" with the "name" of "default". This will be in perl-code


one or more "service-configs"
    type => 'service_set',
    name => 'name-of-the-service-set',

    signature_service_name => 'name-for-signature-generation',
    the_signature => 'vE',

    service_name_suffix_executable => '/path/to/executable',

    services => {
        some-web-site =>{
            char_set => 'char-set-name',
            maxlength => 23,
            iterations => 987,
            hash_class => 'HMACSHA1',
            use_514_sym_char_sort => 1,
        },


    }


    command-conf ( in the service-config )

    this will be to configure the name of the commands that are typed in,
    what service_set , and then what service(name) should be used for the encrypting.
    what the command will be run , and where the encrypted password will be put on the CLI.

    commands => {
            command-name => { # command-name must have some alphabettical chars in it. It cannot be wholely numeric.
                CLI_command=>'/some/executable -username=blah -password=$CRYPT_KHAOS_PASSWORD', # and $CRYPT_KHAOS_PASSWORD will get changed to what is generated.
                service_name => 'name-of-the-service', # that does the encrypting .
            },

    }


=cut

# new param added , maybe this should just be the last bit of the package-name
## our $CONF_NAME='NewLayout'

# the "truetrue" signature . i.e. last 2 chars of encoded



#The length of the suffixed signature to truetrue encoding needs to be more flexible
# A checking process that makes sure the flex-length signatures don't clash would also
# be needed, and 1 char signatures would probably have to be forbidden. 2 chars at a minimum.
# I guess the signature length needs to be standardised over all Conf files, and is  a global
# setting.

# Also need the feature of NOT checking signature for one Conf. So there could be
# a NO_TT_SIGNATURE conf which will get picked in the event of the TT_SIGNATURE not being found.
# This would be the most secure one, since nothing would be leaked about encoding by saying
#   "this last 2 chars of signature was encoded with the salt-passphrase pair.
#    Generate these last 2 chars , and you might  have the salt-passphrase pair."
#
# Also the "service-name" that generates the signature is currently truetrue .
# This should be changable . So everyone could pick a different "service-name" on which to work out the signatures.
# Otherwise there would be an attack based on working out all truetrue signatures could be possible
# for salt-passphrase pairs.

##our $SERVICE_NAME_TO_GENERATE_TT_SIGNATURE='';  # New param.

##our $TT_SIGNATURE = 'sD'; # THE SIGNATURE TO LOOK FOR


# So you could have a USB flash drive / Mounted-drive , on it there would be a file, in the file would be some phrase, words, numbers
# This would get appended to the service-name when doing the encryption. If this is used it would also work on the TT_SIGNATURE stuff.
# If this is defined , and un-readable, then this config file would not be usable.
##our $SERVICENAME_SUFFIX_FROM_INPUT_FROM_FILE = '/some/path/to/file';


# The whole running of a external prog and passing it the generated password
# Needs to be completely re-thought, and done by some type of plugin
# with the plugin knowing What "SERVICE" in what "CONF_NAME" is required
# to encode the password that gets put onto the command line to run the command.
#our $CAN_VPN_KEEPY_UP = 'blahtheservicetokeepyup';  # GOING TO BE DEPRECATED !

# define services that have a maxlength on the password.
# The MAXLENGTH should really be incorporated into the SERVICES definitons
#
#our $MAXLENGTH = {  # GOING TO BE DEPRECATED
#    work_blah => 20,
#};

# This old style hash of the service => character-defs is not too flexible.
#our $SERVICES = { # GOING TO BE DEPRECATED
#
#    work_blah => $KhaosCrypt::Chars::Eon,
#
#};
#
#  ## ./cryptf6.pl:19:my $pbkdf2 = Crypt::PBKDF2->new( # TODO rm this line
#our $SERVICES = {
#
#    work_blah =>
#        {
#            char_defs => $KhaosCrypt::Chars::Eon, # optional, default = $KhaosCrypt::Chars::Default
#            maxlength => 23,    # optional.
#            iterations => 987,  # optional. The number of iterations passed to Crypt::PBKDF2 , default == 1000
#            hash_class => 'HMACSHA1'  # optional. The hash_class passed to Crypt::PBKDF2 , default == 'HMACSHA1'
#            use_514_sym_char_sort => 1,  # optional. the fix to make the SymbolicCharacter names (hash-keys) sorted as they were in perl 5.14 instead of the enforced randomness needed in perl-5.18 onwards . default = 0. eventually this should be deprecated, and the enforced SymbolicCharacter name sort enforced.
#        },
#
#};
#
## The char_defs need changing to being the symbolic_char_name
#
#

##########################################################


=pod

# environment variable

    $CRYPT_KHAOS_CONF_DIR which if not set will default to $HOME/.cryptkhaos/conf

    $CRYPT_KHAOS_DIR which will do , I dunno what.

all the config files will be encoded in JSON,
and the filename suffix will be .json

# we will have
one "main-config"

   type => 'main',
   timeout => 1800 ,

one or more "char-def-sets" confs
    type => 'char_set'
    name => 'name-of-the-char-set'
    chars=>{


    }

there will be a hard-coded "char_set" with the "name" of "default". This will be in perl-code


one or more "service-configs"
    type => 'service_set',
    name => 'name-of-the-service-set',

    signature_service_name => 'name-for-signature-generation',
    the_signature => 'vE',

    service_name_suffix_executable => '/path/to/executable',

    services => {
        some-web-site =>{
            char_set => 'char-set-name',
            maxlength => 23,
            iterations => 987,
            hash_class => 'HMACSHA1',
            use_514_sym_char_sort => 1,
        },


    }


    command-conf ( in the service-config )

    this will be to configure the name of the commands that are typed in,
    what service_set , and then what service(name) should be used for the encrypting.
    what the command will be run , and where the encrypted password will be put on the CLI.

    commands => {
            command-name => { # command-name must have some alphabettical chars in it. It cannot be wholely numeric.
                CLI_command=>'/some/executable -username=blah -password=$CRYPT_KHAOS_PASSWORD', # and $CRYPT_KHAOS_PASSWORD will get changed to what is generated.
                service_name => 'name-of-the-service', # that does the encrypting .
            },

    }


=cut

# new param added , maybe this should just be the last bit of the package-name
## our $CONF_NAME='NewLayout'

# the "blaqhblah" signature . i.e. last 2 chars of encoded



#The length of the suffixed signature to blahblah encoding needs to be more flexible
# A checking process that makes sure the flex-length signatures don't clash would also
# be needed, and 1 char signatures would probably have to be forbidden. 2 chars at a minimum.
# I guess the signature length needs to be standardised over all Conf files, and is  a global
# setting.

# Also need the feature of NOT checking signature for one Conf. So there could be
# a NO_TT_SIGNATURE conf which will get picked in the event of the TT_SIGNATURE not being found.
# This would be the most secure one, since nothing would be leaked about encoding by saying
#   "this last 2 chars of signature was encoded with the salt-passphrase pair.
#    Generate these last 2 chars , and you might  have the salt-passphrase pair."
#
# Also the "service-name" that generates the signature is currently blahblah .
# This should be changable . So everyone could pick a different "service-name" on which to work out the signatures.
# Otherwise there would be an attack based on working out all blahblah signatures could be possible
# for salt-passphrase pairs.

##our $SERVICE_NAME_TO_GENERATE_TT_SIGNATURE='';  # New param.

##our $TT_SIGNATURE = 'sD'; # THE SIGNATURE TO LOOK FOR


# So you could have a USB flash drive / Mounted-drive , on it there would be a file, in the file would be some phrase, words, numbers
# This would get appended to the service-name when doing the encryption. If this is used it would also work on the TT_SIGNATURE stuff.
# If this is defined , and un-readable, then this config file would not be usable.
##our $SERVICENAME_SUFFIX_FROM_INPUT_FROM_FILE = '/some/path/to/file';


# The whole running of a external prog and passing it the generated password
# Needs to be completely re-thought, and done by some type of plugin
# with the plugin knowing What "SERVICE" in what "CONF_NAME" is required
# to encode the password that gets put onto the command line to run the command.
#our $CAN_VPN_KEEPY_UP = 'blahtheservicetokeepyup';  # GOING TO BE DEPRECATED !

# define services that have a maxlength on the password.
# The MAXLENGTH should really be incorporated into the SERVICES definitons
#
#our $MAXLENGTH = {  # GOING TO BE DEPRECATED 
#    skype_invna => 20,
#};

# This old style hash of the service => character-defs is not too flexible.
#our $SERVICES = { # GOING TO BE DEPRECATED
#
#    skype_invna =>   => $KhaosCrypt::Chars::Eon,
#
#};
#
#  ## ./cryptf6.pl:19:my $pbkdf2 = Crypt::PBKDF2->new( # TODO rm this line
#our $SERVICES = {
#
#    skype_invna =>
#        {
#            char_defs => $KhaosCrypt::Chars::Eon, # optional, default = $KhaosCrypt::Chars::Default
#            maxlength => 23,    # optional.
#            iterations => 987,  # optional. The number of iterations passed to Crypt::PBKDF2 , default == 1000
#            hash_class => 'HMACSHA1'  # optional. The hash_class passed to Crypt::PBKDF2 , default == 'HMACSHA1'
#            use_514_sym_char_sort => 1,  # optional. the fix to make the SymbolicCharacter names (hash-keys) sorted as they were in perl 5.14 instead of the enforced randomness needed in perl-5.18 onwards . default = 0. eventually this should be deprecated, and the enforced SymbolicCharacter name sort enforced.
#        },
#
#};
#
# The char_defs need changing to being the symbolic_char_name






1;
