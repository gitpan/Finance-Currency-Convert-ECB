use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Finance::Currency::Convert::ECB',
    'VERSION_FROM'	=> 'ECB.pm', # finds $VERSION
    'PREREQ_PM'		=> {LWP::Simple => 5.827, Cache::Cache => 1.06, Finance::Currency::Convert => 1.07, XML::Simple => 2.18}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ? (
      ABSTRACT_FROM => 'ECB.pm', 
      AUTHOR     => '-',
    ) : ()),
);
