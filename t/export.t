use strict;
use warnings;
use Test::More tests => 2;

{
    package Foo;
    use namespace::autoclean;
    use Exporter qw( import );
    our @EXPORT = qw( foo );

    sub foo { 'foo' }
    sub bar { 'bar' }
}

ok( Foo->can('foo'));
ok( Foo->can('bar'));

{
    package Buz;

    Foo->import();
}

ok( Buz->can('foo'));
ok( !Buz->can('bar'));
