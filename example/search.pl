use strict;
use warnings;
use utf8;
use WebService::SyoboiCalendar;
use Config::Pit qw(pit_get);

my $config = pit_get("cal.syoboi.jp", require => {
    user => "your username on Syoboi Calendar",
    pass => "your password on Syoboi Calendar"
});

my $syoboi = WebService::SyoboiCalendar->new($config);

use Data::Dumper;

my $results = $syoboi->search_program({
    range => '2011/10/1-',
    fresh => 2,
});

warn $results->[0]->title->title;
