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
    my ($name, $creds, $options, $callback) = @_;
    # convenience vars
    my $self = {
        credentials => $creds,
        options => $options,
        callback => $callback,
    };

    bless $self;
    return $self;

#    my $closure = sub {
#        sub execute {
#            Data::Dump::dump(@_);
#            my $self = shift;
#            my $result = shift;
#            print "EXECUTE!\n";
#            &$callback($self, $result);
#        }
#        sub abort {
#            print "ABORT!\n";
#        }
#    };
#    bless $closure;
#   return $closure;

}

sub execute {
    my $self = shift;
    
    my ($valid, $result) = Blitz::Validate::validate($self->{options});
    
    if (!$valid) {
#        Data::Dump::dump($self);
        &{$self->{callback}}($result, $result->{error});
    }
    else {
        
    }
    return $self;
}

sub abort {
    my $self = shift;
    &{$self->{callback}}($self->{credentials});
    return $self;
}


return 1;
