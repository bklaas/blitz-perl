package Blitz::API;

use strict;
use warnings;

use LWP;
use Data::Dump qw(dump);
=head1 NAME

Blitz::API - Perl module for API access to Blitz

=cut

sub client {
    my $this = shift;
    my $creds = shift;
    my $self = {
        credentials => $creds,
    };
    bless $self;
    return $self;
}

sub login {
    my $self = shift;
    my $closure = shift;
    
    Data::Dump::dump($self->{credentials});
    
    my $browser = LWP::UserAgent->new;
    my $url = "http://" . $self->{credentials}{host}; # fix for https later?
    #$url .= ":$self->{credentials}{port}" if $self->{credentials}{port};
    
    my $response = $browser->get($url,
        'X-API-User'   => $self->{credentials}{username},
        'X-API-Key'    => $self->{credentials}{api_key},
        'X-API-Client' => 'Perl',
        'testme' => 'foo',
    );
    
    Data::Dump::dump($response);
    
    die $response->is_success;
    
    my $result = {
        #error => 'something went wrong',
        ok => 'booyah!',
    };
    &$closure($self, $result);
}

return 1;
