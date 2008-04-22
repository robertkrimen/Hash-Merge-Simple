package Hash::Merge::Simple;

use warnings;
use strict;

=head1 NAME

Hash::Merge::Simple - Recursively merge two or more hashes, simply

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
use vars qw/@ISA @EXPORT_OK/;
@ISA = qw/Exporter/;
@EXPORT_OK = qw/merge/;

=head1 SYNOPSIS

    use Hash::Merge::Simple qw/merge/;

    my $a = { a => 1 };
    my $b = { a => 100, b => 2};

    # Merge with righthand hash taking precedence
    my $c = merge $a, $b;
    # $c is { a => 100, b => 2 } ... Note: a => 100 has overridden => 1

    # Also, merge will take care to recursively merge any child hashes found
    my $a = { a => 1, c => 3, d => { i => 2 }, r => {} };
    my $b = { b => 2, a => 100, d => { l => 4 } };
    my $c = merge $a, $b;
    # $c is { a => 100, b => 2, c => 3, d => { i => 2, l => 4 }, r => {} }

    # You can also merge more than two hashes at the same time 
    # The precedence increases from left to right (the rightmost has the most precedence)
    my $everything = merge $this, $that, $mine, $yours, $kitchen_sink, 

=head1 DESCRIPTION

Hash::Merge::Simple will recursively merge two or more hashes and return the result as a new hash reference. The merge function will descend and merge
hashes that exist under the same node in both the left and right hash, but doesn't attempt to combine arrays, objects, scalars, or anything else. The rightmost hash
also takes precedence, replacing whatever was in the left hash if a conflict occurs.

This code was pretty much taken straight from L<Catalyst::Utils>, and modified to handle more than 2 hashes at the same time....

=head1 EXPORTS

=head2 merge

See below.

=head1 METHODS

=head2 Hash::Merge::Simple->merge( <hash1>, <hash2>, <hash3>, ..., <hashN> )

=head2 Hash::Merge::Simple::merge( <hash1>, <hash2>, <hash3>, ..., <hashN> )

Merge <hash1> through <hashN>, with the nth-most (rightmost) hash taking precedence.

Returns a new hash reference representing the merge.

NOTE: The code does not currently check for cycles, so infinite loops are possible.

=cut

# This was stoled from Catalyst::Utils... thanks guys!
sub merge (@);
sub merge (@) {
    shift if ! ref $_[0]; # Take care of the case we're called like Hash::Merge::Simple->merge(...)
    my ($left, @right) = @_;

    return $left unless @right;

    return merge($left, merge(@right)) if @right > 1;

    my ($right) = @right;

    my %merge = %$left;

    for my $key (keys %$right) {
        my $hr = (ref $right->{$key} || '') eq 'HASH';
        my $hl  = ((exists $left->{$key} && ref $left->{$key}) || '') eq 'HASH';

        if ($hr and $hl){
            $merge{$key} = merge($left->{$key}, $right->{$key});
        }
        else {
            $merge{$key} = $right->{$key};
        }
    }
    
    return \%merge;
}

=head1 AUTHOR

Robert Krimen, C<< <rkrimen at cpan.org> >>

L<Catalyst>

=head1 BUGS

Please report any bugs or feature requests to C<bug-hash-merge-simple at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Hash-Merge-Simple>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Hash::Merge::Simple


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Hash-Merge-Simple>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Hash-Merge-Simple>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Hash-Merge-Simple>

=item * Search CPAN

L<http://search.cpan.org/dist/Hash-Merge-Simple>

=back


=head1 ACKNOWLEDGEMENTS

This code was pretty much taken directly from L<Catalyst::Utils>

=head1 COPYRIGHT & LICENSE

Copyright 2008 Robert Krimen, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Hash::Merge::Simple
