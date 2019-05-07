#!/usr/bin/env perl
use strictures 2;
use Test2::V0;

use FindBin '$Bin';
use lib "$Bin/lib";
use Catalyst::Test 'TestApp';

subtest set => sub{
    my $content = get('/set/foo/bar');
    is( $content, 'Cache value set', 'set says it worked' );
};

subtest get => sub{
    my $content = get('/get/foo');
    is( $content, 'bar', 'get returned the setted value' );
};

done_testing;
