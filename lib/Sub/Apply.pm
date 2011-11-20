package Sub::Apply;

use 5.008008;
use strict;
use warnings;
use parent 'Exporter';
use Carp ();

our $VERSION   = '0.05';
our @EXPORT_OK = qw(apply apply_if);

our $WARNING = 0;

sub apply {
    my $orig   = shift;
    my $caller = caller;
    my $proc   = _find_proc( $caller, $orig );
    Carp::croak "No such proc $orig" unless $proc;
    $proc->(@_);
}

sub apply_if {
    my $orig   = shift;
    my $caller = caller;
    my $proc   = _find_proc( $caller, $orig );
    unless ( $proc ) {
        Carp::carp "No such proc $orig" if $WARNING;
        return;
    }
    $proc->(@_);
}

sub _find_proc {
    my ( $caller, $proc ) = @_;
    ( my $package, $proc ) = $proc =~ m/^(?:(.+)::)?(.+)$/;
    $package ||= $caller;
    my $code = do {
        no strict 'refs';
        my $stash = \%{ $package . '::' };
        $stash && $stash->{$proc} && *{ $stash->{$proc} }{CODE};
    };
    return $code;
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

Same as apply. But apply_if does not die unless $procname does not exist.

You can set C<$Sub::Apply::WARNING=1> for debugging.

=head1 WARNING

C<apply> and C<apply_if> cannot call CORE functions.

=head1 AUTHOR

Yoshihiro Sasaki, E<lt>ysasaki at cpan.org<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2011 by Yoshihiro Sasaki

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
