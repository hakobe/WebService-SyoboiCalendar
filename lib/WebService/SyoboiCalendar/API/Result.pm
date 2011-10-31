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

__END__

=head1 NAME

WebService::SyoboiCalendar::API::Result - Intermediate API result representation.

=head1 SYNOPSIS

  my $result = $syobocal->current;

  $result->title;
  $result->program;

=head1 DESCRIPTION

APIs often returns insufficient results. WebService::SyoboiCalendar::API::Result 
wraps results, and provides methods to create object enough;

=head1 METHODS

=over 4

=item program

  my $program = $result->program;

Creates WebService::SyoboiCalendar::Program object from this result.

=item title

  my $title = $result->title;

Creates WebService::SyoboiCalendar::Title object from this result.

=item pid

  my $pid = $result->pid;

Returns program id of this result.

=item tid

  my $tid = $result->tid;

Returns title id of this result.

=back

=cut
