requires 'LWP::UserAgent';
requires 'Moo';
requires 'JSON::XS';
requires 'Web::Query';
requires 'Smart::Args' => "0.08";
requires 'Regexp::Common';
requires 'Encode';
requires 'Readonly';
requires 'URI';
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

