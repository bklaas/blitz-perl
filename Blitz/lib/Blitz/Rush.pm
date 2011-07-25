package Blitz::Rush;

use strict;
use warnings;

use Blitz;
use base qw(Blitz::Exercise);

=head1 NAME

Blitz::Rush - Perl module for executing rushes on Blitz.io
Subclass of Blitz::Exercise

=cut

sub new {
    my $class = shift;
    
    my $return = $class->SUPER::new(@_);
    
    return $return;
}

return 1;
