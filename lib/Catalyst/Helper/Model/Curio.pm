package Catalyst::Helper::Model::Curio;
our $VERSION = '0.01';

use strictures 2;

sub mk_compclass {
    my ( $self, $helper, $class, $key ) = @_;

    $helper->{curio_class} = $class || '';
    $helper->{curio_key}   = $key   || '';

    my $file = $helper->{file};
    $helper->render_file( 'curioclass', $file );

    return 1;
}

1;
__DATA__

__curioclass__
package [% class %];

use Moo;
use strictures 2;
use namespace::clean;

extends 'Catalyst::Model::Curio';

__PACKAGE__->config(
    class => '[% curio_class %]',
[%- IF curio_key %]
    key   => '[% curio_key %]',
[%- END %]
);

1;
