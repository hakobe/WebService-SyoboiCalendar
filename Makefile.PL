use inc::Module::Install;
name 'WebService-SyoboiCalendar';
all_from 'lib/WebService/SyoboiCalendar.pm';

requires 'LWP::UserAgent';
requires 'Mouse';
requires 'JSON::XS';
requires 'Try::Tiny';
requires 'parent';
requires 'Web::Query';
requires 'Smart:Args';
requires 'Regexp::Common';
requires 'Encode';
requires 'Readonly';
requires 'URI';
requires 'URI::QueryParam';
requires 'DateTime';

build_requires 'Test::More';
auto_include;
WriteAll;
