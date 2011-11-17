package Sub::Apply;

use 5.008008;
use strict;
use warnings;
use parent 'Exporter';

our $VERSION   = '0.02';
our @EXPORT_OK = qw(apply apply_if);

sub apply {
    my $orig   = shift;
    my $caller = caller;
    my $proc   = _proc( $caller, $orig );
    die "no such proc:$orig" unless $proc;
    $proc->(@_);
}

sub apply_if {
    my $orig   = shift;
    my $caller = caller;
    my $proc   = _proc( $caller, $orig );
    return unless $proc;
    $proc->(@_);
}

sub _proc {
    my ( $caller, $proc ) = @_;
    ( my $package, $proc ) = $proc =~ m/^(?:(.+)::)?(.+)$/;
    return $package && $package->can($proc)
        || $caller->can($proc);
}

1;
__END__

=head1 NAME

Sub::Apply - apply arguments to proc.

=head1 SYNOPSIS

  use Sub::Apply qw(apply apply_if);

  {
    my $procname = 'sum';
    my $sum = apply( $procname, 1, 2, 3);
  }

  {
    my $procname = 'sum';
    my $sum = apply_if( $procname, 1, 2, 3); 
    # not die if $procname does not exist.
  }

=head1 DESCRIPTION

Sub::Apply provides function C<apply>. This function apply arguments to proc.

=head1 EXPORT_OK

apply, apply_if

=head1 METHOD

=head2 apply($procname, @args)

Apply @args to $procname. If you want to call function that not in current package, you do like below.

    apply('Foo::sum', 1, 2)

=head2 apply_if($procname, @args)

Same as apply. but apply_if does not die unless $procname does not exist.

=head1 WARNING

C<apply> and C<apply_if> cannot call CORE functions.

=head1 AUTHOR

Yoshihiro Sasaki, E<lt>ysasaki at cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Yoshihiro Sasaki

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
