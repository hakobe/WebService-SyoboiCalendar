package WebService::SyoboiCalendar::API::Result;
use Mouse;
use Smart::Args;
use WebService::SyoboiCalendar::Program;
use WebService::SyoboiCalendar::Title;

has api => (
    is => 'ro',
    default => sub { 
        my $self = shift;
        WebService::SyoboiCalendar::API->new(user => shift->user);
    },
);
has result => ( is => 'ro' );

sub pid {
    args my $self;
    $self->result->{PID};
}

sub tid {
    args my $self;
    $self->result->{TID};
}

sub program {
    args_pos my $self, my $args => { optional => 1, default => {} } ;
    my ($result) = values %{ $self->api->json({
        req => 'ProgramByPID',
        PID => $self->result->{PID},
        %$args,
    })->{Programs} };
    WebService::SyoboiCalendar::Program->new( api_result => $result);
}

sub title {
    args_pos my $self, my $args => { optional => 1, default => {} } ;
    my ($result) = values %{ $self->api->json({
        req => 'TitleFull',
        TID => $self->result->{TID},
        %$args,
    })->{Titles} };
    WebService::SyoboiCalendar::Title->new( api_result => $result );
}

no Mouse;
__PACKAGE__->meta->make_immutable;
