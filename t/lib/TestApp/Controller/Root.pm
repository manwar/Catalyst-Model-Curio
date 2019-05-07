package TestApp::Controller::Root;

use Moose;
use strictures 2;
use namespace::clean;

BEGIN { extends 'Catalyst::Controller' }

__PACKAGE__->config(namespace => '');

sub index :Path :Args(0) {
    my ($self, $c) = @_;
    $c->res->content_type( 'text/plain' );
    $c->res->body( 'Hello World!' );
}

sub set :Path('/set') :Args(2) {
    my ($self, $c, $key, $value) = @_;

    $c->model('Cache')->set( $key, $value );

    $c->res->content_type( 'text/plain' );
    $c->res->body( 'Cache value set' );
}

sub get :Path('/get') :Args(1) {
    my ($self, $c, $key) = @_;

    my $value = $c->model('Cache')->get( $key );

    $c->res->content_type( 'text/plain' );

    if (!defined $value) {
        $c->res->status(500);
        $c->res->body( 'Unknown cache key' );
        return;
    }

    $c->res->body( $value );
}

sub default :Path {
    my ($self, $c) = @_;

    $c->res->status(404);
    $c->res->content_type( 'text/plain' );
    $c->res->body( 'Page not found' );
}

sub end : ActionClass('RenderView') {}

1;
