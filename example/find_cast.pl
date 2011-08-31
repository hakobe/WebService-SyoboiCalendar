package main;

use strict;
use warnings;
use utf8;

use WebService::SyoboiCalendar;
use YAML;
use DateTime;
use Perl6::Say;
use Regexp::Common qw(URI);
use Encode;
use autobox;
use autobox::SearchQuery;
use URI::BrowserOpen;

binmode STDOUT, ":utf8"; 

my $syoboi = WebService::SyoboiCalendar->new({
    user => 'yohei',
});

my ($query_title, $query_character) = @ARGV;

my $title =  $syoboi->search(decode_utf8($query_title))->[0]->title;
if ($query_character) {
    $title->find_cast(decode_utf8($query_character))->wikipedia->open;
}
else {
    print Dump $title->cast;
}
