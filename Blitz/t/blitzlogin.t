#!perl -T

use strict;
use warnings;
use Blitz;
use Blitz::API;
use JSON::XS;

use Test::More tests => 6;
use Test::MockObject;

my $blitz = Blitz->new({ 
    username => 'me@foo.com',
    api_key  => '12121212-aaaaaaaa-bbbbbbbb-01010101',
});

my $client = Blitz::API->client($blitz->{credentials});
my $success = "{\"api_key\":\"9fbc5302-6002bea0-d38f8ace-0285a4ec\",\"ok\":true}";
my $fail = "{\"reason\":\"authentication failed\",\"error\":\"login\"}";
my $success_hash = decode_json($success);
my $fail_hash = decode_json($fail);

# Successful login
{
    my $lwp = Test::MockObject->new();
    $lwp->fake_module( 'LWP::UserAgent'=> (
        new => sub { $lwp },
    ));
    
    $lwp->mock( get => sub {
        # Return a hand crafted HTTP::Response object
        my $response = HTTP::Response->new;
        $response->code(200);
        $response->content($success);
        return $response;
    });

    my $response = $client->login();
    ok($response->{ok}, 'login response ok');
    is($response->{api_key}, $success_hash->{api_key}, 'api_key is correct');
}

# Server error
{
    my $lwp = Test::MockObject->new();
    $lwp->fake_module( 'LWP::UserAgent'=> (
        new => sub { $lwp },
    ));
    
    $lwp->mock( get => sub {
        # Return a hand crafted HTTP::Response object
        my $response = HTTP::Response->new;
        $response->code(500);
        $response->content('');
        return $response;
    });

    my $response = $client->login();
    is($response->{error}, 'server');
    is($response->{cause}, 500);
}

# Failed login
{
    my $lwp = Test::MockObject->new();
    $lwp->fake_module( 'LWP::UserAgent'=> (
        new => sub { $lwp },
    ));
    
    $lwp->mock( get => sub {
        # Return a hand crafted HTTP::Response object
        my $response = HTTP::Response->new;
        $response->code(200);
        $response->content($fail);
        return $response;
    });

    my $response = $client->login();
    ok($response->{reason}, 'error reason as expected');
    is($response->{error}, $fail_hash->{error}, 'error response as expected');
}