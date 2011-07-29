package Blitz::Exercise;

use strict;
use warnings;

use Blitz;
use Blitz::API;
use Blitz::Validate;
use MIME::Base64;
use JSON::XS;
use LWP;

=head1 NAME

Blitz::Exercise - Superclass for Sprint and Rush modules

=head1 SUBROUTINES/METHODS


=head2 new

Create a blitz exercise object, which returns a closure with execute and abort methods

=cut

sub new {
    my ($name, $blitzObj, $options, $callback) = @_;
    # convenience vars
    my $self = {
        blitzObj    => $blitzObj,
        options     => $options,
        callback    => $callback,
        job_id      => 0,
    };

    bless $self;
    return $self;
}

sub blitzObj {
    my $self = shift;
    return $self->{blitzObj};
}

sub execute {
    my $self = shift;
    my $client = $self->blitzObj->client();
    
    print STDERR "-------------------\n";
    Data::Dump::dump($self->blitzObj);
    print STDERR "-------------------\n";
    my ($valid, $result) = Blitz::Validate::validate($self->{options});
    if (!$valid) {
        &{$self->{callback}}($result, $result->{error});
        exit 0;
    }
    else {
        # send execute request to host
        my $response = $client->start_job();
        
        if ($response->{_id}) {
            my $job_id = $client->job_id($response->{_id});
            # wait 2 secs, then get status
            until ($client->{job_status} eq 'completed' or 
                    $client->{job_status} eq 'fail') {
                sleep 2;
                $response = $client->job_status();
                my $error = 0;
                if ($response->{error}) {
                    $error = $response->{error};
                }
                elsif (         
                    $response->{response} && 
                    $response->{response}{result} && 
                    $response->{response}{result}{error}
                ) {
                    $error = $response->{response}{result}{error};
                }
                if ($error) {
                    $client->{job_status} = 'fail';
                    &{$self->{callback}}($response, $response->{error});
                }
            }
        }
        else {
            # no id means failure
            &{$self->{callback}}($response, 'No job id returned');
        }
    }
    return $self;
}


return 1;
