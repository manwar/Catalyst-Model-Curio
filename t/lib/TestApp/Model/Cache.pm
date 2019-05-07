package TestApp::Model::Cache;

use Moo;
use strictures 2;
use namespace::clean;

extends 'Catalyst::Model::Curio';

__PACKAGE__->config(
    class => 'TestApp::Service::Cache',
);

1;
