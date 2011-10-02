#!/usr/bin/perl

{
    package TestOverload;

    use Moose;
    use namespace::autoclean;
    use overload '""' => sub { shift->id         }, fallback => 1;

    has id => (is => 'ro', default => 'bar');

    __PACKAGE__->meta->make_immutable;
}

use strict;
use warnings;

use Test::More tests => 3;

my $one = TestOverload->new;
isa_ok $one => 'TestOverload';

is $one->id, 'bar', 'id is "bar"';
is "$one",   'bar', 'id stringifies to "bar"';

