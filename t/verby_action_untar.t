#!/usr/bin/perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::MockObject;

use Hash::AsObject;
use File::Temp qw(tempdir);
use POE;

use ok 'Verby::Action::Untar';

my $dir = tempdir( CLEANUP => 1 );

my $obj = Verby::Action::Untar->new();

my $logger = Test::MockObject->new;

$logger->set_true($_) for qw(info debug warn);

my $c = Hash::AsObject->new({
    logger => $logger,
    tarball => "foo.tar.gz",
    dest    => "$dir",
});

ok( not($obj->verify($c)), "verify failed" );

$obj->do($c);

$poe_kernel->run;

ok( $obj->verify($c), "verify passed" );
