use strict;
use warnings;
use Test::More tests => 6;

{

    package Foo;
    use namespace::autoclean -also => qr/^_/;
    use namespace::autoclean -also => sub { $_ =~ m{x} and $_ !~ m{y} };
    sub _hidden               { }
    sub xsubs_are_bad         { }
    sub ysubs_are_good        { }
    sub xsubs_with_y_are_good { }
}
{

    package Bar;
    use namespace::autoclean -also =>
      [ qr/^_/, sub { $_ =~ m{x} and $_ !~ m{y} } ];
    sub _hidden               { }
    sub xsubs_are_bad         { }
    sub ysubs_are_good        { }
    sub xsubs_with_y_are_good { }

}

ok( !Foo->can('_hidden'),              '-also regex works' );
ok( !Foo->can('xsubs_are_bad'),        '-also sub works' );
ok( Foo->can('xsubs_with_y_are_good'), '-also sub doesnt overclean' );

ok( !Bar->can('_hidden'),              '-also list with regex works' );
ok( !Bar->can('xsubs_are_bad'),        '-also list with sub works' );
ok( Bar->can('xsubs_with_y_are_good'), '-also list with sub doesnt overclean' );

