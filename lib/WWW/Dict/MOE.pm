package Lingua::ZH::Dict;

use strict;
use warnings;

require Exporter;
our @ISA       = qw(Exporter);
our $VERSION   = '0.02';

use LWP::UserAgent;
use HTML::LinkExtractor;

=head1 NAME

Lingua::ZH::Dict - Chinese Word MOE Dictionary Lookup

=head1 VERSION

This document describes version 0.02 of Lingua::ZH::Dict, released
July 25, 2004.

=head1 SYNOPSIS

    use Lingua::ZH::Dict;

    # Create Lingua::ZH::Dict object with exact_match set
    my $dict = Lingua::ZH::Dict->new( exact_match => 1);
    # Exact match for "天氣"
    print $token->query('天氣')."\n";

    # Query for any word have "天氣" in dictionary
    $token->exact_match(0);
    print $token->query('天氣')."\n";

=head1 DESCRIPTION

This module lookup Dictionary of MOE (Ministry of Education), Taiwan.

=head1 METHODS

=head1 CAVEATS

This module does not care about efficiency or memory consumption yet,
hence it's likely to fail miserably if you demand either of them.
Patches welcome.

As the name suggests, the chosen interface is very bizzare.  Use it at
the risk of your own sanity.

=cut

# MOE url
my $base_url = qw(http://140.111.1.22/clc/dict/); 
# base CGI
my $base_cgi = qw(newsearch.cgi);
# reserved
my @field = qw(Word ChuYin1 ChuYin2 Synonym Antonym Explan);

sub new {
    my($class, %options) = @_;

    my $self =  {
	ua => LWP::UserAgent->new(timeout => 300),
	le => HTML::LinkExtractor->new(),
	%options,
	query_word => '',
    };
    bless $self, $class;
}
sub exact_match {
    my $self = shift;
    $self->{exact_match} = shift;
};
sub query {
    my $self = shift;
    my $word = shift;
    $self->{query_word} = $word;
    if ($self->{exact_match}) {
	$word = '^'.$word.'$';
    }
    my $ua = $self->{ua};
    my $res = $ua->post ( 
	$base_url.$base_cgi, 
	[
	    Database => 'dict',
	    QueryScope => 'Name',
	    QueryCommand => 'find',
	    GraphicWord => 'no',
	    QueryString => $word,
	]
	
    );
    if ($res->is_success) {
	my $le = $self->{le};
	$le->strip(1);
	$le->parse(\$res->content);
	for my $link ( @{$le->links } ) {
	    next until defined($$link{_TEXT});
	    if ($$link{_TEXT} =~ m/$self->{query_word}/) {
		return $$link{_TEXT};
	    }
	}
    } else {
	die $res->status_line;
    }

}
sub CLONE { }
sub DESTROY { }

1;

=head1 SEE ALSO

L<LWP::UserAgent>, L<HTML::LinkExtractor>

=head1 AUTHORS

Cheng-Lung Sung E<lt>clsung@dragon2.netE<gt>

=head1 COPYRIGHT

Copyright 2004 by Cheng-Lung Sung E<lt>clsung@dragon2.netE<gt>.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See L<http://www.perl.com/perl/misc/Artistic.html>

=cut
