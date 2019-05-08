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

our $_KEY;

sub BUILD {
    my ($self) = @_;

    # Get the Curio class loaded early.
    require_module( $self->class() );

    $self->_install_key_models();

    return;
}

sub ACCEPT_CONTEXT {
    my ($self) = @_;

    my $method = $self->method();

    my $key = $self->key() || $_KEY;

    return $self->class->$method(
        $key ? $key : (),
    );
}

sub _install_key_models {
    my ($self) = @_;

    return if $self->key();
    return if !$self->class->factory->does_keys();

    my $model_class = ref( $self );

    my $model_name = $model_class;
    $model_name =~ s{^.*::(?:Model|M)::}{};

    foreach my $key (@{ $self->class->keys() }) {
        no strict 'refs';

        *{"$model_class\::$key\::ACCEPT_CONTEXT"} = sub{
            my ($self, $c) = @_;
            local $_KEY = $key;
            return $c->model( $model_name );
        };
    }

    return;
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

1;
__END__

=head1 SUPPORT

Please submit bugs and feature requests to the
Catalyst-Model-Curio GitHub issue tracker:

L<https://github.com/bluefeet/Catalyst-Model-Curio/issues>

=head1 AUTHORS

    Aran Clary Deltac <aran@bluefeet.dev>

=head1 ACKNOWLEDGEMENTS

Thanks to L<ZipRecruiter|https://www.ziprecruiter.com/>
for encouraging their employees to contribute back to the open
source ecosystem.  Without their dedication to quality software
development this distribution would not exist.

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

