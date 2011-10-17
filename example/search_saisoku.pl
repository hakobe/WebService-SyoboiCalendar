use strict;
use warnings;
use utf8;
use WebService::SyoboiCalendar;
use Config::Pit qw(pit_get);
use YAML;
use Perl6::Say;

my $config = pit_get("cal.syoboi.jp", require => {
    user => "your username on Syoboi Calendar",
    pass => "your password on Syoboi Calendar"
});

sub get_all_pids_of_tid {
    my $syoboi = WebService::SyoboiCalendar->new($config);
}

my $results = $syoboi->search_program({
    range => '2011/10/1-2011/10/31',
    fresh => 2,
});

for my $result (@$results) {
    my $title = $result->title;
    my $program = $result->program;

    my $first_ch = $title->first_ch;
    $first_ch =~ s/毎日//g;
    $first_ch =~ s/放送//g;
    $first_ch =~ s/テレビ//g;

    my $ch_name = $program->ch_name;
    $ch_name =~ s/毎日//g;
    $ch_name =~ s/放送//g;
    $ch_name =~ s/テレビ//g;

    if ($first_ch =~ m/$ch_name/ || $ch_name =~ m/$first_ch/) {
        say sprintf "%s - %s", $result->program->ch_name, $result->title->title;
    }
}

