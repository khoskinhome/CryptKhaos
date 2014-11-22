package Crypt::Khaos::Documentation;

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
