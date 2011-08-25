use strict;
use warnings;

use WebService::SyoboiCalendar;
#use Data::Dumper;
use YAML;
use DateTime;
use Perl6::Say;
use Regexp::Common qw(URI);

my $syoboi = WebService::SyoboiCalendar->new;
my $result = $syoboi->timetable({
    start => DateTime->now(time_zone => 'local')->subtract(hours => 1),
    usr   => 'yohei',
});

for my $program (@{ $result->{items} }[0..9]) {
    my $start = DateTime->from_epoch(epoch => $program->{StTime}, time_zone => 'local');
    say sprintf("%s\t%s\t(%s)", $start, $program->{Title}, $program->{SubTitle});

    my $detail = $syoboi->detail_from_program($program);
    my $comment = join ',', split(/\r?\n/, $detail->{Titles}->{$program->{TID}}->{Comment});
    warn $comment;
    my ($url) = $comment =~ /($RE{URI}{HTTP})/;
    warn $url;
    system('open', $url);
}

