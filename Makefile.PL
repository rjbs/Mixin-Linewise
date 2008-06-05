use inc::Module::Install;

all_from('lib/Mixin/Linewise.pm');
requires('Carp'       => 0.000); # sure, it's core, but let's be thorough
requires('IO::String' => 0.000); # minimum unknown
requires('IO::File'   => 0.000); # minimum unknown

extra_tests;

WriteAll;
