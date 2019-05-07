package Catalyst::Model::Curio;
our $VERSION = '0.01';

=encoding utf8

=head1 NAME

Catalyst::Model::Curio - Curio Model for Catalyst.

=head1 SYNOPSIS

    ...

=head1 DESCRIPTION

...

=cut

use Curio qw();
use Module::Runtime qw( require_module );
use Types::Common::String qw( NonEmptySimpleStr );
use Types::Standard qw( Bool );

use Moo;
use strictures 2;
use namespace::clean;

extends 'Catalyst::Model';

sub BUILD {
    my ($self) = @_;

    # Get the Curio class loaded early.
    require_module( $self->class() );

    # And get the Curio object instantiation happening early too.
    $self->ACCEPT_CONTEXT() if $self->preload();

    return;
}

sub ACCEPT_CONTEXT {
    my ($self) = @_;

    my $method = $self->method();

    return $self->class->$method(
        $self->key() ? $self->key() : ()
    );
}

has class => (
    is       => 'ro',
    isa      => NonEmptySimpleStr,
    required => 1,
);

has key => (
    is  => 'ro',
    isa => NonEmptySimpleStr,
);

has method => (
    is      => 'ro',
    isa     => NonEmptySimpleStr,
    default => 'fetch',
);

has preload => (
    is      => 'ro',
    isa     => Bool,
    default => 1,
);

1;
__END__

=head1 SUPPORT

Please submit bugs and feature requests to the
Catalyst-Model-Curio GitHub issue tracker:

L<https://github.com/bluefeet/Catalyst-Model-Curio/issues>

=head1 AUTHORS

    Aran Clary Deltac <bluefeet@gmail.com>

=head1 ACKNOWLEDGEMENTS

Thanks to L<ZipRecruiter|https://www.ziprecruiter.com/>
for encouraging their employees to contribute back to the open
source ecosystem.  Without their dedication to quality software
development this distribution would not exist.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

