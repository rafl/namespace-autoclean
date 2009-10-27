#!/usr/bin/perl

=head1 NAME

overloads.t - Make sure we don't klobber overloaded functions

=head1 DESCRIPTION 

This test exercises namespace::autoclean with overloaded operators; making
sure we don't klobber them.

=cut

{
    package TestOverload;

    use Moose;
    use namespace::autoclean;
    use overload '""' => sub { shift->id         }, fallback => 1;
    use overload '+'  => sub { (shift) + (shift) }, fallback => 1;

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

__END__

=head1 AUTHOR

Chris Weyl  <cweyl@alumni.drew.edu>

