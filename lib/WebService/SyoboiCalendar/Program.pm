package WebService::SyoboiCalendar::Program;
use Mouse;
use Smart::Args;

has api_result => ( is => 'rw' );

sub pid {
    args my $self;
    $self->api_result
}

sub title {
}

sub start {
}

no Mouse;
__PACKAGE__->meta->make_immutable;
