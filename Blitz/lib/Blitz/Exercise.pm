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
    my $blitz = $self->blitzObj();
    my $client = Blitz::get_client($self->blitzObj());
    
    my ($valid, $result) = Blitz::Validate::validate($self->{options});
    if (!$valid) {
        &{$self->{callback}}($result, $result->{error});
    }
    else {
        # send execute request to host

        my $response = $client->start_job($self->{options}, $self->{callback});

        if ($response->{job_id}) {
            my $job_id = $client->job_id($response->{job_id});
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
                    $response->{result} && 
                    $response->{result}{error}
                ) {
                    $error = $response->{result}{error};
                }
                if ($error) {
                    $client->{job_status} = 'fail';
                    &{$self->{callback}}($response, $error);
                }
                else {
                    $client->{job_status} = $response->{job_status};
                    &{$self->{callback}}($response, $error);
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
