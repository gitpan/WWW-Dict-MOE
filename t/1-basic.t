#!/usr/bin/perl
use strict;
use Test;

BEGIN { plan tests => 3 }

require WWW::Dict::MOE;
ok($WWW::Dict::MOE::VERSION) if $WWW::Dict::MOE::VERSION or 1;

# Create WWW::Dict::MOE::Sentence object (->Sentence also works)
my $dict = WWW::Dict::MOE->new( exact_match => 1 );
ok($dict->query('天氣'),'【天氣】', 'Lookup "Weather" in Chinese'); 
ok($dict->query('籃球'),'【籃球】', 'Lookup "Basketball" in Chinese'); 

1;
