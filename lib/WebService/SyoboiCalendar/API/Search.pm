package WebService::SyoboiCalendar::API::Search;
use Mouse;
use Smart::Args;
use Web::Query;
use Readonly;
use URI;
use URI::QueryParam;

Readonly my $API_SEARCH => "http://cal.syoboi.jp/find";

has api => (
    is => 'ro',
    isa => 'WebService::SyoboiCalendar::API',
    required => 1,
);

has mode => (
    is => 'ro',
    required => 1,
);

my %field_to_param = (
    title    => 'kw',
    channel  => 'ch',
    subtitle => 'st',
    comment  => 'cm',
    fresh    => 'pfn', # 新番組
    final    => 'pfl', # 最終回
    special  => 'pfs', # 特番
);

for my $field (keys %field_to_param) {
    has $field => ( is => 'rw' );
}

has range => ( is => 'rw');

no Mouse;
__PACKAGE__->meta->make_immutable;

sub get {
    args my $self;
    my $content = $self->api->get( $self->request_url )->content;
    my $scraper = 'scrape_search_' . $self->mode;
    $self->$scraper($content);
}

sub request_url {
    args my $self; 

    my $url = URI->new( $API_SEARCH );
    $url->query_param_append(sd  => {
        title   => 0,
        program => 2,
    }->{$self->mode}); 
    $url->query_param_append(uuc => 1); # ユーザ設定を使う
    $url->query_param_append(v   => 0); # リスト

    for my $key (keys %field_to_param) {
        if ($self->$key) {
            $url->query_param_append(
                $field_to_param{$key} => $self->$key,
            );
        }
    }

    my $range = $self->range || '';
    if ($range eq 'all') {
        $url->query_param_append( r => 0 );
    }
    elsif ($range eq 'past') {
        $url->query_param_append( r => 1 );
    }
    elsif ($range eq 'future') {
        $url->query_param_append( r => 2 );
    }
    else {
        $url->query_param_append( r => 3 );
        $url->query_param_append( rd => $range );
    }
    return $url;
}

sub _scrape {
    args_pos my $self, my $content, my $query;
    my $results = [];
    wq($content)->find($query)->each( sub {
        my ($i, $elem) = @_;
        my $href = $elem->attr('href');
        my ($tid, $pid) = $href =~ m!^/tid/(\d+)(?:/time\#(\d+))?$!xms;
        push @$results, {
            TID => $tid,
            PID => $pid,
        } if ($tid || $pid);
    });
    $results;
}

sub scrape_search_title {
    args_pos my $self, my $content;
    $self->_scrape($content, '.tframe tr td:nth-child(1) a');
}

sub scrape_search_program {
    args_pos my $self, my $content;
    $self->_scrape($content, '.tframe tr td:nth-child(2) a');
}

1;
