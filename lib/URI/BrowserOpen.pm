package URI::QueryParam;
use strict;
use warnings;

package URI;

sub open {
    my ($self) = @_;
    system('open', $self->as_string);
}

1;
