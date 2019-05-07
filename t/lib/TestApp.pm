package TestApp;

use Moose;
use strictures 2;
use namespace::clean;

use Catalyst;

extends 'Catalyst';

__PACKAGE__->config(
    name => 'TestApp',
    disable_component_resolution_regex_fallback => 1,
);

__PACKAGE__->setup();

1;
