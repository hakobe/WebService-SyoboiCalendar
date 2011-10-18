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

my $results = $syoboi->search_title({
    title => 'まどか☆マギカ',
});
warn join "\n", @{ $results->[0]->title->voice_actors };
