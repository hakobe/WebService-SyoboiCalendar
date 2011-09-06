package WebService::SyoboiCalendar::Title;
use Mouse;
use Smart::Args;
use utf8;
use Regexp::Common qw /URI/;
use Encode;

has api_result => (
    is => 'rw',
);
has cast => (
    is => 'rw',
    default => sub { +{} },
);

sub BUILD {
    args_pos my $self, my $args;

    my @parts = split /\*/, $self->comment;

    for my $part (@parts) {
        if ($part =~ m/キャスト/) {
            my $cast = {};
            my @lines = (split /\r\n/, $part);
            for my $line (@lines[1..$#lines]) {
                my (undef, $character, $voice_actor) = split /:/, decode_utf8($line);
                $cast->{$character} = $voice_actor if $character && $voice_actor;
            }
            $self->cast($cast);
        }
    }
}

sub tid {
    args my $self;
    $self->api_result->{TID};
}

sub urls {
    args my $self;
    my @urls = $self->api_result->{Comment} =~ m/$RE{URI}{HTTP}/g;
    \@urls;
}

sub official_site_url {
    args my $self;
    $self->urls->[0];
}

sub title {
    args my $self;
    $self->api_result->{Title};
}

sub sub_titles {
    args my $self;
    my $sub_titles = $self->api_result->{SubTitles};
    $sub_titles =~ s/^\*\d+?\*//xmsg;
    [split /\r\n/, $sub_titles];
}

sub sub_title {
    args_pos my $self, my $count;
    my $sub_titles = $self->sub_titles;
    $sub_titles && $sub_titles->[$count - 1];
}

sub characters {
    args my $self;
    [keys %{ $self->cast }];
}

sub voice_actors {
    args my $self;
    [values %{ $self->cast }];
}

sub find_cast {
    args_pos my $self, my $character;
    $character = decode_utf8($character); # XXX

    my ($result) = map { $self->cast->{$_} } grep {
        $_ =~ m/$character/;
    } @{ $self->characters };
    $result;
}

sub comment {
    args my $self;
    $self->api_result->{Comment};
}

no Mouse;
__PACKAGE__->meta->make_immutable;
