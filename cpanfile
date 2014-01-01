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

on 'develop' => sub {
    requires 'Module::Install';
    requires 'Module::Install::CPANfile';
    requires 'Module::Install::AuthorTests';
    requires 'Module::Install::Repository';
};
