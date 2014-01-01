use strict;
use warnings;
use utf8;
use Encode;
use WebService::SyoboiCalendar;
use Config::Pit qw(pit_get);
use JSON::XS;
use Data::Dumper;
use Text::Xslate;
use Data::Section::Simple qw(get_data_section);

my ($year, $season) = @ARGV;

die "USAGE: perl $0 year winter|spring|summer|fall\n" if !$year || !$season;

my $config = pit_get("cal.syoboi.jp", require => {
    user => "your username on Syoboi Calendar",
    pass => "your password on Syoboi Calendar"
});

my $syoboi = WebService::SyoboiCalendar->new($config);

my $seasons = {
    winter => [qw(  1/1   1/31 )],
    spring => [qw(  3/20  4/30 )],
    summer => [qw(  6/20  7/31 )],
    fall   => [qw(  9/30 10/30 )],
};

my $results = $syoboi->search_program({
    range => join('-', map { "$year/$_" } @{ $seasons->{$season} } ),
    fresh => 2,
});
my $day_of_weeks = [qw(月 火 水 木 金 土 日)];
my $template = get_data_section('row');
my $tx = Text::Xslate->new(
    syntax => 'TTerse'
);

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

    my $is_saisoku =  ($first_ch =~ m/$ch_name/ || $ch_name =~ m/$first_ch/) ? 1 : 0;

    my ($month, $day, $hour, $minute, $day_of_week);
    {
        my $start_time = $program->start_time;
        if ($program->start_time->hour <= 5) { # 深夜帯は読み易い表記にする
            $start_time->add( days => -1 );
            $hour = $start_time->hour <= 5 ? $start_time->hour + 24 : $start_time->hour;
        }
        else {
            $hour = $start_time->hour;
        }
        $month       = $start_time->month;
        $day         = $start_time->day;
        $minute      = $start_time->minute;
        $day_of_week = $day_of_weeks->[ $start_time->day_of_week - 1 ];
    }

    my $result = $tx->render_string( $template, {
        ch_name     => $program->ch_name,
        title       => $title->title,
        title_link  => $title->official_site_url,
        tid         => $title->tid,
        month       => $month,
        day         => $day,
        hour        => $hour,
        minute      => $minute,
        day_of_week => $day_of_week,
        is_saisoku  => $is_saisoku,
    });
    print encode_utf8( $result );
}


__DATA__
@@ row
| [% month %]月[% day %]日 ([% day_of_week %]) [% hour %]時[% minute %]分〜 | [% IF is_saisoku%](最速!)[% END %] [% ch_name %] | <a href="[% title_link %]">[% title %]</a> | <a href="http://cal.syoboi.jp/tid/[% tid %]">しょぼいカレンダー</a> |
