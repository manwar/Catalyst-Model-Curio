package TestApp::Service::Cache;

use Curio;
use strictures 2;

does_caching;

has _cache => (
    is       => 'ro',
    init_arg => undef,
    default  => sub{ {} },
);

sub set {
    my ($self, $key, $value) = @_;
    $self->_cache->{$key} = $value;
    return;
}

sub get {
    my ($self, $key) = @_;
    return $self->_cache->{$key};
}

1;
