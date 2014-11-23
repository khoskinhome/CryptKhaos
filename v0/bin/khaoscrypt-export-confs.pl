#!/usr/bin/perl
use warnings;
use strict;
use 5.14.2;
use Data::Dumper;

use KhaosCrypt::Conf::ExportAll;

print "###########################################\n";
print "START KhaosCrypt::Conf::ExportAll->export()\n";
print "###########################################\n";

KhaosCrypt::Conf::ExportAll->export();

print "##############################################\n";
print "FINISHED KhaosCrypt::Conf::ExportAll->export()\n";
print "##############################################\n";
