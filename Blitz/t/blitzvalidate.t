#!perl -T

use strict;
use warnings;
use Blitz;
use Blitz::Validate;
use Data::Dump qw(dump);
use Test::More tests => 23;

my $error_response = 'Invalid parameters';

# url
{

    my $correct_params = {
        url => 'http://foo.com?some_extra_params=foobar',
    };
    my $validate_with_no_url = {};
    my $validate_with_bad_url = {
        url => 'http:/foo',
    };
    
    my ($valid, $response) = Blitz::Validate::validate($correct_params);
    ok($valid, 'Validate with URL pushes no error');
    ok(!$response->{error}, 'no error on success');

    ($valid, $response) = Blitz::Validate::validate($validate_with_no_url);
    ok(!$valid, 'No URL returns invalid');
    is($response->{error}, $error_response, 'Correct error response');
}

# region
{
    my $correct_params = {
        url => 'http://foo.com',
        region => 'ireland',
    };
    my $validate_with_bad_region = {
        url => 'http://foo.com',
        region => 'china'
    };
    
    my ($valid, $response) = Blitz::Validate::validate($correct_params);

    ok($valid, "Correct region pushes no error");
    ($valid, $response) = Blitz::Validate::validate($validate_with_bad_region);
    ok(!$valid, 'Bad region returns invalid');
    is($response->{error}, $error_response, 'Correct error response for bad region');
}

# ssl
{
    my $validate_with_bad_ssl = {
        url => 'http://foo.com',
        region => 'ireland',
        ssl => 'sslv1',
    };
    
    for my $ssl ('tlsv1', 'sslv2', 'sslv3') {
        my $correct_params = {
            url => 'http://foo.com',
            region => 'ireland',
            ssl => $ssl,
        };
        my ($valid, $response) = Blitz::Validate::validate($correct_params);
        ok($valid, "Correct SSL param of $ssl pushes no error");
    }
    my ($valid, $response) = Blitz::Validate::validate($validate_with_bad_ssl);
    is($response->{error}, $error_response, 'Bad SSL returns invalid');
}

# data
{
    my $validate_with_bad_content = {
        url => 'http://foo.com',
        content => 'some content',
    };
    my $correct_params = {
        url => 'http://foo.com',
        content => {
            data => [
                'some data',
            ],
        }
    };
    my ($valid, $response) = Blitz::Validate::validate($correct_params);
    ok($valid, "Correct data->content pushes no error");
    ($valid, $response) = Blitz::Validate::validate($validate_with_bad_content);
    is($response->{error}, $error_response, 'Badly formated data hash returns invalid');
    
}

# user-agent
{
    my $validate_with_bad_user_agent = {
        url => 'http://foo.com',
        'user-agent' => { key => 'val'},
    };
    my $correct_params = {
        url => 'http://foo.com',
        'user-agent' => 'Mozilla/5.0 (iPad; U; CPU OS 3_2_1 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Mobile/7B405',
    };
    my ($valid, $response) = Blitz::Validate::validate($correct_params);
    Data::Dump::dump($response);
    ok($valid, "Correct user-agent pushes no error");
    ($valid, $response) = Blitz::Validate::validate($validate_with_bad_user_agent);
    is($response->{error}, $error_response, 'Badly formated user-agent returns invalid');

}

# referer
{
    my $validate_with_bad_referer = {
        url => 'http://foo.com',
        referer => 'http:/foo.com',
    };
    my $correct_params = {
        url => 'http://foo.com',
        referer => 'http://google.com',
    };
    my ($valid, $response) = Blitz::Validate::validate($correct_params);
    ok($valid, "Correct referer pushes no error");
    ($valid, $response) = Blitz::Validate::validate($validate_with_bad_referer);
    is($response->{error}, $error_response, 'Badly formated referer returns invalid');

}

# user
{
    my $validate_with_bad_user = {
        url => 'http://foo.com',
        user => { name => 'foo', pass => 'bar', },
    };
    my $correct_params = {
        url => 'http://foo.com',
        user => 'foo:bar',
    };
    my ($valid, $response) = Blitz::Validate::validate($correct_params);
    ok($valid, "Correct user pushes no error");
    ($valid, $response) = Blitz::Validate::validate($validate_with_bad_user);
    is($response->{error}, $error_response, 'Badly formated user returns invalid');
    
}

# status and timeout
{
    for my $key ('timeout', 'status') {
        my $validate_with_bad_format = {
            url => 'http://foo.com',
            $key => 'a string instead of an integer',
        };
        my $correct_params = {
            url => 'http://foo.com',
            $key => 500,
        };
        my ($valid, $response) = Blitz::Validate::validate($correct_params);
        ok($valid, "Correct $key pushes no error");
        ($valid, $response) = Blitz::Validate::validate($validate_with_bad_format);
        is($response->{error}, $error_response, 'Badly formated $key returns invalid');
    }
    
}

# XXX: cookies and headers

# XXX: variables
