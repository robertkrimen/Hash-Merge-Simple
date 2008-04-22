use inc::Module::Install;

name 'Hash-Merge-Simple';
all_from 'lib/Hash/Merge/Simple.pm';

build_requires 'Test::More';

auto_install;

WriteAll;

