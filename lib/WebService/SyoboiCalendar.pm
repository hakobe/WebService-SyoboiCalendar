package WebService::SyoboiCalendar;
use Mouse;
use Smart::Args;
use Readonly;
use WebService::SyoboiCalendar::API;
use WebService::SyoboiCalendar::API::Result;

has user => (is => 'rw', isa => 'Str');
has pass => (is => 'rw', isa => 'Str');

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

    [ $self->_map_to_results(values %{ $self->api->json({
        req    => 'TitleSearch',
        search => $title,
        limit  => 15,
    })->{Titles} }) ];
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

no Mouse;
__PACKAGE__->meta->make_immutable;

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
