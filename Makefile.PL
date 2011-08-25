use inc::Module::Install;
name 'WebService-SyoboiCalendar';
all_from 'lib/WebService/SyoboiCalendar.pm';

requires 'Mouse';
requires 'JSON';
requires 'Try::Tiny';
requires 'parent';

build_requires 'Test::More';
auto_include;
WriteAll;
