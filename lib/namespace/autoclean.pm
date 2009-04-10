use strict;
use warnings;

package namespace::autoclean;

use Class::MOP;
use B::Hooks::EndOfScope;
use namespace::clean;

sub import {
    my $caller = caller();
    on_scope_end {
        my $meta = Class::MOP::class_of($caller) || Class::MOP::Class->initialize($caller);
        my %methods = map { ($_ => 1) } $meta->get_method_list;
        my @symbols = keys %{ $meta->get_all_package_symbols('CODE') };
        namespace::clean->clean_subroutines($caller, grep { !$methods{$_} } @symbols);
    };
}

1;
