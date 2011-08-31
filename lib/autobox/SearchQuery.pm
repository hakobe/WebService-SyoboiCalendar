package autobox::SearchQuery;
use strict;
use warnings;
use base qw/autobox/;
use URI;

sub import {
    shift->SUPER::import( SCALAR => 'autobox::SearchQuery::Scalar' );
}

package # hide from pause :-)
    autobox::SearchQuery::Scalar;

sub wikipedia {
    URI->new(sprintf('http://ja.wikipedia.org/wiki/%s', $_[0]));
}

1;
