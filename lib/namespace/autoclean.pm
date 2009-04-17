use strict;
use warnings;

package namespace::autoclean;
# ABSTRACT: Keep imports out of your namespace

use Class::MOP;
use B::Hooks::EndOfScope;
use namespace::clean;

=head1 SYNOPSIS

    package Foo;
    use namespace::autoclean;
    use Some::Package qw/imported_function/;

    sub bar { imported_function('stuff') }

    # later on:
    Foo->bar;               # works
    Foo->imported_function; # will fail. imported_function got cleaned after compilation

=head1 DESCRIPTION

When you import a function into a Perl package, it will naturally also be
available as a method.

The C<namespace::autoclean> pragma will remove all imported symbols at the end
of the current package's compile cycle. Functions called in the package itself
will still be bound by their name, but they won't show up as methods on your
class or instances.

This module is very similar to L<namespace::clean|namespace::clean>, except it
will clean all imported functions, no matter if you imported them before or
after you C<use>d the pagma. It will also not touch anything that looks like a
method, according to C<Class::MOP::Class::get_method_list>.

=head1 SEE ALSO

L<namespace::clean>

L<Class::MOP>

L<B::Hooks::EndOfScope>

=cut

sub import {
    my ($class, %args) = @_;
    my $caller = caller();
    my @also = @{ $args{-also} || [] };
    on_scope_end {
        my $meta = Class::MOP::class_of($caller) || Class::MOP::Class->initialize($caller);
        my %methods = map { ($_ => 1) } $meta->get_method_list;
        my @symbols = keys %{ $meta->get_all_package_symbols('CODE') };
        namespace::clean->clean_subroutines($caller, @also, grep { !$methods{$_} } @symbols);
    };
}

1;
