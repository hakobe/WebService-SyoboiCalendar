package WebService::SyoboiCalendar::Error;
use strict;
use warnings;
use Exception::Class (
    'WebService::SyoboiCalendar::APIRequestError' => {
        fields => [qw(res)],
    },
);

1;
