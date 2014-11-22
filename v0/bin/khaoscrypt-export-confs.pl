#!/usr/bin/perl
use warnings;
use strict;
use 5.14.2;
use Data::Dumper;

use lib "$ENV{CRYPT_KHAOS_LIB}";

use KhaosCrypt::Conf::ExportAll;

KhaosCrypt::Conf::ExportAll->export();

