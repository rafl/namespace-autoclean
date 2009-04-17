use strict;
use warnings;
use Test::More tests => 2;

{
    package Foo;
    use namespace::autoclean -also => ['bar'];
    sub bar {}
    sub baz {}
}

ok(!Foo->can('bar'), '-also works');
ok( Foo->can('baz'), 'method not specified in -also remains');
