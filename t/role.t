use strict;
use warnings;
use Test::More;

BEGIN {
    eval 'use Moose ()';
    plan skip_all => 'requires Moose' if $@;
    plan tests => 1;
}

{
    package Foo;
    use Moose::Role;
    use namespace::autoclean;
}

# meta doesn't get cleaned, although it's not in get_method_list for roles
can_ok('Foo', 'meta')
