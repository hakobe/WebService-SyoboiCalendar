package WebService::SyoboiCalendar;
use Mouse;
use Readonly;
use WebService::SyoboiCalendar::API;

has user => (is => 'rw', isa => 'String');

has api => (
    is => 'ro',
    default => sub { WebService::SyoboiCalendar::API->new },
);

no Mouse;
__PACKAGE__->meta->make_immutable;

sub _param {
    my ($hash, $key) = @_;
    my $val = delete($hash->{$key}) || delete($hash->{lc($key)});
    $val ? ($key => $val) : ();
}

sub timetable {
    my ($self, $args) = @_;

    my $start = delete $args->{start};
    $start = $start->strftime('%Y%m%d%H%M') if $start && $start->isa('DateTime');

    my $end = delete $args->{end};
    $end = $end->strftime('%Y%m%d%H%M') if $end && $end->isa('DateTime');

    $self->api->timetable({
        ($start ? (start    => $start) : ()),
        ($end ? (end    => $end) : ()),
        map {
            _param($args, $_);
        } qw(days titlefmt usr filter usch ssch),

        %$args,
    });
}

sub detail {
    my ($self, $args) = @_;
    $self->api->detail({
        map {
            _param($args, $_);
        } qw(Req Start Days TID PID ChID Count),

        %$args,
    });
}

sub detail_from_program {
    my ($self, $program) = @_;
    $self->detail({
        req => 'ProgramByPID,TitleFull',
        pid => $program->{PID},
    });
}

1;

__END__

=head1 NAME

WebService::SyoboiCalendar -

=head1 SYNOPSIS

  use WebService::SyoboiCalendar;

=head1 DESCRIPTION

WebService::SyoboiCalendar is

=head1 AUTHOR

Yohei Fushii E<lt>hakobe@gmail.comE<gt>

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 SEE ALSO

=cut
