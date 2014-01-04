package WebService::SyoboiCalendar;

use Moo;

use 5.008_001;
our $VERSION = '0.01';
$VERSION = eval $VERSION;

use Smart::Args;
use WebService::SyoboiCalendar::API;
use WebService::SyoboiCalendar::API::Result;

has user => (is => 'rw');
has pass => (is => 'rw');

has api => (
    is => 'ro',
    default => sub { 
        my $self = shift;
        WebService::SyoboiCalendar::API->new(
            user => $self->user,
            pass => $self->pass,
        );
    },
);

sub current {
    args my $self;
    my $results = $self->timetable;
    return unless $results;
    $results->[0];
}

sub title {
    args_pos my $self, my $tid;
    WebService::SyoboiCalendar::API::Result->new(
        api => $self->api,
        result => { TID => $tid },
    )->title;
}

sub program {
    args_pos my $self, my $pid;
    WebService::SyoboiCalendar::API::Result->new(
        api => $self->api,
        result => { PID => $pid },
    )->program;
}

sub timetable {
    args_pos my $self, my $args => { optional => 1, default => {} } ;

    [ $self->_map_to_results(@{ 
        $self->api->rss2({ %$args, })->{items} 
    }) ];
}

sub search_tiny {
    args_pos my $self, my $title;

    my $titles = $self->api->json({
        req    => 'TitleSearch',
        search => $title,
        limit  => 15,
    })->{Titles};

    [ $self->_map_to_results(map { $titles->{$_} } sort { $b <=> $a } keys(%$titles)) ];
}

sub search_title {
    my ($self, $args) = @_;

    [ $self->_map_to_results( @{ $self->api->search({
        mode => 'title',
        %$args
    })}) ];
}

sub search_program {
    my ($self, $args) = @_;

    [ $self->_map_to_results( @{ $self->api->search({
        mode => 'program',
        %$args
    })}) ];
}

sub _map_to_results {
    my ($self, @results) = @_;

    map {
        WebService::SyoboiCalendar::API::Result->new(
            api => $self->api,
            result => $_,
        )
    } @results;
}

1;

__END__

=head1 NAME

WebService::SyoboiCalendar - Retrieve Anime info. with SyoboiCalendar API.

=head1 SYNOPSIS

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

=head1 DESCRIPTION

WebService::SyoboiCalendar provides a convinient way 
to access Syoboi Calendar(http://cal.syoboi.jp/).

=head1 METHODS

=over 4

=item new

  my $syobocal = WebService::SyoboiCalendar->new(
      user => 'USERNAME',
      pass => 'PASSWORD',
  );

Creates a new WebService::SyoboiCalendar object. 

=item current

  my $result = $syobocal->current;

Returns a WebService::SyoboiCalendar::API::Result of current
Anime program.

=item timetable

  my $results = $syobocal->timetable;

Returns an Anime program timetable as a 
WebService::SyoboiCalendar::API::Result list.

=item search_title

  my $results = $syobocal->search_title(
      title => $title,
      range => $range,
  );

Searches Anime titles, and returns
a WebService::SyoboiCalendar::API::Result list as a result.

=item search_program

  my $results = $syobocal->search_title(
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

=back

=head1 AUTHOR

Yohei Fushii E<lt>hakobe@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
