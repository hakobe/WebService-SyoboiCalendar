package WebService::SyoboiCalendar::Program;
use Mouse;
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
        time_zone => 'local',
        epoch     => $self->api_result->{StTime},
    );
}

sub end_time {
    args my $self;
    DateTime->from_epoch(
        time_zone => 'local',
        epoch     => $self->api_result->{EdTime},
    );
}

sub ch_name {
    args my $self;
    $self->api_result->{ChName};
}

no Mouse;
__PACKAGE__->meta->make_immutable;
