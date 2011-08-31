package WebService::SyoboiCalendar;
use Mouse;
use Smart::Args;
use Readonly;
use WebService::SyoboiCalendar::API;
use WebService::SyoboiCalendar::API::Result;

has user => (is => 'rw', isa => 'Str');

has api => (
    is => 'ro',
    default => sub { 
        my $self = shift;
        WebService::SyoboiCalendar::API->new(user => $self->user);
    },
);

sub timetable {
    args_pos my $self, my $args => { optional => 1, default => {} } ;

    my @results = map { 
        WebService::SyoboiCalendar::API::Result->new(
            api => $self->api,
            result => $_,
        )
    } @{ $self->api->rss2({
        %$args,
    })->{items} };

    \@results;
}

sub current {
    args my $self;
    my $results = $self->timetable;
    return unless $results;
    $results->[0];
}

sub search {
    args_pos my $self, my $title;
    my @results = map {
        WebService::SyoboiCalendar::API::Result->new(
            api => $self->api,
            result => $_,
        )
    } values %{ $self->api->json({
        req    => 'TitleSearch',
        search => $title,
        limit  => 15,
    })->{Titles} };
    \@results;
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
