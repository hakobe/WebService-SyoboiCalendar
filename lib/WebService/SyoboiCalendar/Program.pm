package WebService::SyoboiCalendar::Program;
use Moo;
use Smart::Args;
use DateTime;

has api_result => ( is => 'rw' );

sub pid {
    args my $self;
    $self->api_result
}

sub count {
    args my $self;
    $self->api_result->{Count};
}

sub start_time {
    args my $self;

    DateTime->from_epoch(
        time_zone => 'Asia/Tokyo',
        epoch     => $self->api_result->{StTime},
    );
}

sub end_time {
    args my $self;
    DateTime->from_epoch(
        time_zone => 'Asia/Tokyo',
        epoch     => $self->api_result->{EdTime},
    );
}

sub ch_name {
    args my $self;
    $self->api_result->{ChName};
}

1;

=head1 NAME

WebService::SyoboiCalendar::Program - Anime Program Object

=head1 SYNOPSIS

  my $program = $result->program;

  $program->pid;
  $program->count;
  $program->start_time;
  $program->end_time;
  $program->ch_name;

=head1 DESCRIPTION

This object provides methods to access Anime Program information.
You can generate this from WebService::SyoboiCalendar::API::Result.

=cut
