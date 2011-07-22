package Blitz;

use strict;
use warnings;

=head1 NAME

Blitz - The great new Blitz!

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS

Blitz provides an interface to the blitz API. Blitz is a
performance and load testing application for testing cloud service apps. 
More information on blitz can be found at http://blitz.io


    use Blitz;

    my $blitz = Blitz->new();

=cut

sub new {
    my $this = shift;
    my $self = {
    };
    bless $self;
    return $self;
}

=head1 SUBROUTINES/METHODS


=head2 sprint

# Sprint
$blitz->sprint({
    url => 'www.mycoolapp.com',
    region => 'california',
    callback => \&sprint_sink($ok, $err)
});


=cut

sub sprint {
    my $self = shift;
}

=head2 rush

# Rush
$blitz->rush({
    url => 'www.mycoolapp.com',
    region => 'california',
    pattern => [
        {
            start => 1,
            end => 100,
            duration => 60,
        }],
    callback => \&rush_sink($ok, $err)
});


=cut

sub rush {
    my $self = shift;
}

=head1 AUTHOR

Ben Klaas, C<< <ben at benklaas.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-blitz at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Blitz>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Blitz


You can also look for information at:

=over 4

=item * Github: Open source code repository

L<http://github.com/bklaas/blitz-perl>

=item * RT: CPAN's request tracker (report bugs here)

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Blitz>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Blitz>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Blitz>

=item * Search CPAN

L<http://search.cpan.org/dist/Blitz/>

=back


=head1 ACKNOWLEDGEMENTS

Thanks to Guilherme Hermeto and Kowsik Guruswamy for assistance
in understanding the blitz API and requirements of the Perl client.

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Ben Klaas.

This program is free software; you can redistribute it and/or modify it
under the terms of either: the GNU General Public License as published
by the Free Software Foundation; or the Artistic License.

See http://dev.perl.org/licenses/ for more information.


=cut

1; # End of Blitz
