use inc::Module::Install;

name('WWW-Dict-MOE');
author('Cheng-Lung Sung <clsung@dragon2.net>');
abstract('MOE Chinese Word Lookup Agent');
license('perl');
version_from('lib/WWW/Dict/MOE.pm');

requires(qw(
    perl        5.6.1
    LWP::UserAgent  0
    HTML::LinkExtractor	0
));

WriteAll( );

