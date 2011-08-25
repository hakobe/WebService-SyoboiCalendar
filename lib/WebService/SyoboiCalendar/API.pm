package WebService::SyoboiCalendar::API;
use Mouse;
use Readonly;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common;
use URI;
use URI::QueryParam;
use JSON::XS;

use WebService::SyoboiCalendar::Error;

Readonly my $API_RSS2 => "http://cal.syoboi.jp/rss2.php";
Readonly my $API_JSON => "http://cal.syoboi.jp/json.php";

has ua => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    default => sub { LWP::UserAgent->new },
);

no Mouse;
__PACKAGE__->meta->make_immutable;

sub get {
    my ($self, $url, $args) = @_;
    $url = URI->new($url);
    $url->query_form(%$args);
    my $res = $self->ua->get($url);
    WebService::SyoboiCalendar::APIRequestError->throw(
        error => qq(error while requesting to "$url"),
        res => $res,
    ) if $res->is_error;
    $res;
}

sub get_json {
    my ($self, $url, $args) = @_;
    my $res = $self->get($url, $args);
    decode_json($res->content);
}

sub timetable {
    my ($self, $args) = @_;
    my $res = $self->get_json($API_RSS2, { %$args, alt => 'json' });
}

sub detail {
    my ($self, $args) = @_;
    $self->get_json($API_JSON, $args);
}

1;
