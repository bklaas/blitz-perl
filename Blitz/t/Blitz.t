#!perl -T

use strict;
use warnings;
use Test::More tests => 3;
use Blitz;
use Scalar::Util qw(blessed);

my $obj = Blitz->new({ username => 'foo'});
$obj->port(8080);

create_object_ok($obj);
required_blitz_parameters($obj);

sub create_object_ok {
    my $obj = shift;
    is( blessed($obj), 'Blitz', 'Creating a new object OK');
}

sub required_blitz_parameters {
    my $obj = shift;
    is( $obj->username, 'foo', "Username properly set");
    is( $obj->port, 8080, 'Port properly set');
}

sub required_rush_parameters {
    
}