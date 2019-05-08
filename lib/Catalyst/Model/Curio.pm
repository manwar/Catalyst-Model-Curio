package Catalyst::Model::Curio;
our $VERSION = '0.01';

=encoding utf8

=head1 NAME

Catalyst::Model::Curio - Curio Model for Catalyst.

=head1 SYNOPSIS

Create your model class:

    package MyApp::Model::Cache;
    
    use Moo;
    use strictures 2;
    use namespace::clean;
    
    extends 'Catalyst::Model::Curio';
    
    __PACKAGE__->config(
        class  => 'MyApp::Service::Cache',
    );
    
    1;

Then use it in your controllers:

    my $chi = $c->model('Cache::geo_ip')->chi();

See L<Curio/SYNOPSIS> as this SYNOPSIS is based on it.

=head1 DESCRIPTION

This module glues L<Curio> classes into Catalyst's model system.

This distribution also comes with L<Catalyst::Helper::Model::Curio>
which makes it somewhat simpler to create your Catalyst model class.

You may want to check out L<Curio/Use Curio Directly> for an
alternative viewpoint on using Catalyst models when you are
already using Curio.

=head1 KEYS

There are several ways to handle keys in your Curio models because
Curio classes can optionally support keys.

=head2 No Keys

A Curio class which does not support keys just means you don't
set the L</key> configuration.

=head2 Single Key

If your Curio class does support keys you can choose to create a model
for each key you want exposed in catalyst by specifying the L</key>
configuration in each model for each key you want available in Catalyst.
Each model would have the same L</class>.

=head2 Multiple Keys

If your Curio class supports keys and you do not set the L</key>
configuration then the model will automatically create pseudo
models for each key.

This is done by appending each declared key to your model name.
You can see this in the L</SYNOPSIS> where the model name is
C<Cache> but since L</key> is not set, and the Curio class does
have declared keys then the way you get the model is by appending
C<::geo_ip> to the model name, or whatever key you want to access.

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

=head1 CONFIGURATION

=head2 class

The Curio class that this model wraps around.

This is required to be set, otherwise Catalyst will throw
and exception when trying to load your model.

=cut

has class => (
    is       => 'ro',
    isa      => NonEmptySimpleStr,
    required => 1,
);

=head2 key

If your Curio class supports keys then, if set, this forces
your model to interact with one key only.

=cut

has key => (
    is  => 'ro',
    isa => NonEmptySimpleStr,
);

=head2 method

By default when you (per the L</SYNOPSIS>):

    $c->model('Cache::geo_ip')

It will call the C<fetch> method on your L</class> which will
return a Curio object.  If you'd like, you can change this to
call a different method, returning something else of your choice.

=cut

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

