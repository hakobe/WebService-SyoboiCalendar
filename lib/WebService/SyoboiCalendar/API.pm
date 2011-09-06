package WebService::SyoboiCalendar::API;
use Mouse;
use Smart::Args;
use Readonly;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common;
use URI;
use URI::QueryParam;
use JSON::XS;
use UNIVERSAL::require;

use WebService::SyoboiCalendar::Error;

our $DEBUG = 0;

Readonly my $API_RSS2 => "http://cal.syoboi.jp/rss2.php";
Readonly my $API_JSON => "http://cal.syoboi.jp/json.php";

has ua => (
    is => 'ro',
    isa => 'LWP::UserAgent',
    default => sub { LWP::UserAgent->new },
);

has user => ( is => 'ro' );

no Mouse;
__PACKAGE__->meta->make_immutable;

sub p {
    Data::Dumper->require;
    warn Data::Dumper::Dumper(@_);
}

sub get {
    my ($self, $url, $args) = @_;
    $url = URI->new($url);
    $url->query_form(%$args);
    my $res = $self->ua->get($url);
    p $res if $DEBUG;
    WebService::SyoboiCalendar::APIRequestError->throw(
        error => qq(error while requesting to "$url"),
        res => $res,
    ) if $res->is_error;
    $res;
}

sub get_json {
    my ($self, $url, $args) = @_;
    my $res = $self->get($url, $args);
    my $json = decode_json($res->content);
    p $json if $DEBUG;
    $json;
}

sub _param {
    args_pos my $hash, my $key;
    my $val = delete($hash->{$key}) || delete($hash->{lc($key)});
    $val ? ($key => $val) : ();
}

sub _datetime_param {
    args_pos my $hash, my $key;
    my $val = delete($hash->{$key}) || delete($hash->{lc($key)});
    $val = $val->strftime('%Y%m%d%H%M') if $val && $val->isa('DateTime');
    $val ? ($key => $val) : ();
}

sub rss2 {
    my ($self, $args) = @_;
    $self->get_json($API_RSS2, {
        (map {
            _param($args, $_);
        } qw(days titlefmt usr filter usch ssch)),
        (map {
            _datetime_param($args, $_);
        } qw(start end)),
        alt => 'json',
        ($self->user ? (usr => $self->user) : () ),
        %$args,
    });
}

sub json {
    my ($self, $args) = @_;
    $self->get_json($API_JSON, {
        (map {
            _param($args, $_);
        } qw(Req Start Days TID PID ChID Count Search Limit)),
        %$args,
    });
}

1;
