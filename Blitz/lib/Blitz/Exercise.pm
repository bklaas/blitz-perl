package Blitz::Exercise;

use strict;
use warnings;

use Blitz;
use Blitz::API;
use Blitz::Validate;
use MIME::Base64;
use JSON::XS;

=head1 NAME

Blitz::Exercise - Superclass for Sprint and Rush modules

=head1 SUBROUTINES/METHODS

=head2 Result

Decode the JSON result object from Blitz
Decode base64 response in content areas of request and response

=cut

sub Result {
    my $result = shift;
    
    my $return = decode_json($result);

    for my $key ('result', 'return') {
        $return->{$key}{content} = decode_base64($return->{$key}{content});
    }
    
    return $return;
}

=head2 new

Create a blitz exercise object, which returns a closure with execute and abort methods

=cut

sub new {
    my ($name, $options, $callback) = @_;
    # convenience vars
    my $self = {
        options => $options,
    };

    my $closure = sub {
        sub execute {
            print "EXECUTE!\n";
        }
        sub abort {
            print "ABORT!\n";
        }
    };
    bless $closure;
    return $closure;

}

return 1;
