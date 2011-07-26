package Blitz::API;

use strict;
use warnings;

use LWP;
use Data::Dump qw(dump);
use JSON::XS;

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
    
#    Data::Dump::dump($self->{credentials});
    
    my $browser = LWP::UserAgent->new;
    my $url = "http://" . $self->{credentials}{host}; # fix for https later?
    #$url .= ":$self->{credentials}{port}" if $self->{credentials}{port};
    
    my $response = $browser->get($url,
        'X-API-User'   => $self->{credentials}{username},
        'X-API-Key'    => $self->{credentials}{api_key},
        'X-API-Client' => 'Perl',
        'testme' => 'foo',
    );
    
    my $result = {};
    if ( $response->code() != 200 ) {
        $result->{error} = 'server';
        $result->{cause} = $response->code();
    }
    else {
        $result = decode_json($response->{_content});
    }
    
    if ($closure) {
        &$closure($self, $result);
    }
    return $result;
}

return 1;
