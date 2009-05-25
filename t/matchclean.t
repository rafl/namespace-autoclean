use strict;
use warnings;
use Test::More tests => 6;

{

    package Foo;
    use namespace::autoclean -match => qr/^_/;
    use namespace::autoclean -match => sub { $_ =~ m{x} and $_ !~ m{y} };
    sub _hidden               { }
    sub xsubs_are_bad         { }
    sub ysubs_are_good        { }
    sub xsubs_with_y_are_good { }
}
{

    package Bar;
    use namespace::autoclean -match =>
      [ qr/^_/, sub { $_ =~ m{x} and $_ !~ m{y} } ];
    sub _hidden               { }
    sub xsubs_are_bad         { }
    sub ysubs_are_good        { }
    sub xsubs_with_y_are_good { }

}

ok( !Foo->can('_hidden'),              '-match regex works' );
ok( !Foo->can('xsubs_are_bad'),        '-match sub works' );
ok( Foo->can('xsubs_with_y_are_good'), '-match sub doesnt overclean' );

ok( !Bar->can('_hidden'),       '-match list with regex works' );
ok( !Bar->can('xsubs_are_bad'), '-match list with sub works' );
ok( Bar->can('xsubs_with_y_are_good'),
    '-match list with sub doesnt overclean' );

