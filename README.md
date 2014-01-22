[![Build Status](https://travis-ci.org/hakobe/WebService-SyoboiCalendar.png?branch=master)](https://travis-ci.org/hakobe/WebService-SyoboiCalendar)
# NAME

WebService::SyoboiCalendar - Retrieve Anime info. with SyoboiCalendar API.

# SYNOPSIS

    my $syobocal = WebService::SyoboiCalendar->new(
        user => 'USERNAME',
        pass => 'PASSWORD',
    );

    # Search
    my $results = $syobocal->search_title(title => 'Fate/Zero')

    # Retrieve timetable
       $results = $syobocal->timetable;

    # Retrieve a current result of an anime program
    my $result = $syobocal->current;

    # Title object
    my $title = $result->title;
    $title->urls;
    $title->characters;
    $title->voice_actors;

    # Program object
    my $program = $result->program;
    $program->count;
    $program->start_time;
    $program->end_time;

# DESCRIPTION

WebService::SyoboiCalendar provides a convinient way 
to access Syoboi Calendar(http://cal.syoboi.jp/).

# METHODS

- new

        my $syobocal = WebService::SyoboiCalendar->new(
            user => 'USERNAME',
            pass => 'PASSWORD',
        );

    Creates a new WebService::SyoboiCalendar object. 

- current

        my $result = $syobocal->current;

    Returns a WebService::SyoboiCalendar::API::Result of current
    Anime program.

- timetable

        my $results = $syobocal->timetable;

    Returns an Anime program timetable as a 
    WebService::SyoboiCalendar::API::Result list.

- search\_title

        my $results = $syobocal->search_title(
            title => $title,
            range => $range,
        );

    Searches Anime titles, and returns
    a WebService::SyoboiCalendar::API::Result list as a result.

- search\_program

        my $results = $syobocal->search_program(
            title    => $title,
            channel  => $channel,
            subtitle => $subtitle,
            comment  => $comment,
            fresh    => 1,
            final    => 1,
            special  => 1,
        );

    Searches Anime programs, and returns
    a WebService::SyoboiCalendar::API::Result list as a result.

# AUTHOR

Yohei Fushii <hakobe@gmail.com>

# LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.
