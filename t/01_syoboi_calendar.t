use strict;
use warnings;

use utf8;

use lib 'lib';
use lib 't/lib';

use SyobocalMock;
use Test::More;
use Test::use::ok;

SyobocalMock->register;

use ok('WebService::SyoboiCalendar');

subtest new => sub {
    my $syobocal;

    $syobocal = WebService::SyoboiCalendar->new(
        user => 'user',
        pass => 'pass',
    );

    isa_ok $syobocal, 'WebService::SyoboiCalendar';
    is $syobocal->user, 'user';
    is $syobocal->pass, 'pass';
    isa_ok $syobocal->api, 'WebService::SyoboiCalendar::API';
};

subtest title => sub {
    my $syobocal = WebService::SyoboiCalendar->new;
    my $title = $syobocal->title(2077); # http://cal.syoboi.jp/tid/2077
    isa_ok $title, 'WebService::SyoboiCalendar::Title';
    is $title->tid, '2077';
    is $title->title, '魔法少女まどか☆マギカ';
    is $title->first_ch, 'MBS'; # 関西最速
    ok $title->comment;
    is $title->sub_titles->[0], '夢の中で会った、ような・・・・・';
    is $title->cast->{'佐倉杏子'}, '野中藍';
    is $title->characters->[0], 'キュゥべえ';
    is $title->voice_actors->[0], '加藤英美里';
};

subtest program => sub {
    my $syobocal = WebService::SyoboiCalendar->new;
    my $program = $syobocal->program(180773);
    isa_ok $program, 'WebService::SyoboiCalendar::Program';
    is $program->count, 12;
    is $program->start_time, '2011-04-22T03:10:00';
    isa_ok $program->start_time, 'DateTime';
    is $program->end_time, '2011-04-22T03:40:00';
    isa_ok $program->end_time, 'DateTime';
    is $program->ch_name, 'MBS毎日放送';
};

subtest timetable => sub {
    my $syobocal = WebService::SyoboiCalendar->new;
    my $timetable = $syobocal->timetable;

    is scalar(@$timetable), 3;

    isa_ok $timetable->[0], 'WebService::SyoboiCalendar::API::Result';
    is $timetable->[0]->tid, 2148;
    is $timetable->[0]->pid, 210905;

    isa_ok $timetable->[1], 'WebService::SyoboiCalendar::API::Result';
    is $timetable->[1]->tid, 636;
    is $timetable->[1]->pid, 214354;

    isa_ok $timetable->[2], 'WebService::SyoboiCalendar::API::Result';
    is $timetable->[2]->tid, 748;
    is $timetable->[2]->pid, 215317;
};

subtest search_tiny => sub {
    my $syobocal = WebService::SyoboiCalendar->new;
    my $results = $syobocal->search_tiny('まどか☆マギカ');
    is scalar(@$results), 3;

    isa_ok $results->[0], 'WebService::SyoboiCalendar::API::Result';
    is $results->[0]->tid, 3216;

    isa_ok $results->[1], 'WebService::SyoboiCalendar::API::Result';
    is $results->[1]->tid, 3219;

    isa_ok $results->[2], 'WebService::SyoboiCalendar::API::Result';
    is $results->[2]->tid, 2077;
};

subtest search_title => sub {
    TODO : {
        local $TODO = 'requires HTML scraping test';
        fail();
    };
};

subtest search_program => sub {
    TODO : {
        local $TODO = 'requires HTML scraping test';
        fail();
    };
};

done_testing;
