package WebService::SyoboiCalendar::API;
use Moo;
use Smart::Args;
use Readonly;
use LWP::UserAgent;
use HTTP::Request;
use HTTP::Request::Common;
use URI;
use JSON::XS;
use Web::Query;

use WebService::SyoboiCalendar::Error;
use WebService::SyoboiCalendar::API::Search;

Readonly my $API_RSS2  => "http://cal.syoboi.jp/rss2.php";
Readonly my $API_JSON  => "http://cal.syoboi.jp/json.php";
Readonly my $API_LOGIN => "http://cal.syoboi.jp/usr";

has ua => (
    is => 'ro',
    default => sub { 
        my $ua = LWP::UserAgent->new;
        $ua->cookie_jar( {} );
        $ua;
    },
);

has user => ( is => 'ro' );
has pass => ( is => 'ro' );

has is_logging_in => (
    is      => 'rw',
    default => 0,
);

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

sub post {
    my ($self, $url, $args) = @_;
    $url = URI->new($url);
    my $res = $self->ua->post($url, $args);
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

sub login {
    my ($self) = @_;
    return if $self->is_logging_in;

    my $res = $self->get($API_LOGIN);
    my $frame = wq($res->content)->find('.LoginFrame')->first;
    my $params = {};
    $frame->find('input[type="hidden"]')->each( sub {
        my ($i, $elem) = @_;
        my $name  = $elem->attr('name');
        my $value = $elem->attr('value');
        $params->{$name} = $value;
    });
    $params->{usr}  = $self->user;
    $params->{pass} = $self->pass;
    $self->post($API_LOGIN.".php", $params);
    $self->is_logging_in(1);
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
    my $result = $self->get_json($API_JSON, {
        (map {
            _param($args, $_);
        } qw(Req Start Days TID PID ChID Count Search Limit)),
        %$args,
    });

    $result;
}

sub search {
    my ($self, $args) = @_;
    $self->login;

    my $search = WebService::SyoboiCalendar::API::Search->new(
        api => $self,
        mode => $args->{mode},
    );
    for my $key (qw(
        title channel subtitle comment fresh final special range
    )) {
        $search->$key( $args->{$key} ) if exists $args->{$key};
    }
    $search->get;
}

1;
