requires 'LWP::UserAgent';
requires 'Mouse';
requires 'JSON::XS';
requires 'Try::Tiny';
requires 'parent';
requires 'Web::Query';
requires 'Smart::Args' => "0.08";
requires 'Regexp::Common';
requires 'Encode';
requires 'Readonly';
requires 'URI';
requires 'URI::QueryParam';
requires 'DateTime';
requires 'Exception::Class';

recommends 'Eval::WithLexicals';
recommends 'YAML';
recommends 'Term::ANSIColor::Markup';
recommends 'Term::Encoding';
recommends 'Config::Pit';
recommends 'Text::Xslate';

on 'test' => sub {
    requires 'Test::More';
    requires 'Test::use::ok';
    requires 'LWP::Protocol::PSGI';
    requires 'Router::Simple';
    requires 'Data::Section::Simple';
};

