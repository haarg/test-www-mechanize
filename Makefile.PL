use strict;
use warnings;
use ExtUtils::MakeMaker;

my $eumm_version = $ExtUtils::MakeMaker::VERSION;
$eumm_version =~ tr/_//d;

my %test_prereqs = (
    'HTTP::Server::Simple'      => '0.42',
    'HTTP::Server::Simple::CGI' => 0,
    'Test::Builder::Tester'     => '1.09',
    'URI::file'                 => 0,
    'Test::More'                => '0.96', # subtest() and done_testing()
);

my %prereqs = (
    'Carp'                      => 0,
    'Carp::Assert::More'        => 0,
    'HTML::TokeParser'          => 0,
    'LWP'                       => '6.02',
    'Test::Builder'             => 0,
    'Test::LongString'          => '0.15',
    'WWW::Mechanize'            => '1.68',
    'parent'                    => 0,
);

my $parms = {
    NAME                => 'Test::WWW::Mechanize',
    AUTHOR              => 'Andy Lester <andy@petdance.com>',
    VERSION_FROM        => 'Mechanize.pm',
    ABSTRACT_FROM       => 'Mechanize.pm',
    PL_FILES            => {},
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'Test-WWW-Mechanize-*' },
};

if ( $eumm_version >= 6.63_03 ) {
    $parms->{TEST_REQUIRES} = \%test_prereqs;
}
elsif ( $eumm_version >= 6.55_01 ) {
    $parms->{BUILD_REQUIRES} = \%test_prereqs;
}
else {
    %prereqs = ( %prereqs, %test_prereqs );
}
$parms->{PREREQ_PM} = \%prereqs;

if ( $eumm_version > 6.30 ) {
    $parms->{LICENSE} = 'artistic_2';
}

if ( $eumm_version >= 6.46 ) {
    $parms->{META_MERGE} = {
        resources => {
            license     => 'http://www.opensource.org/licenses/artistic-license-2.0',
            homepage    => 'https://github.com/petdance/test-www-mechanize',
            bugtracker  => 'https://github.com/petdance/test-www-mechanize/issues',
            repository  => 'https://github.com/petdance/test-www-mechanize',
        }
    };
}
if ( $eumm_version >= 6.48 ) {
    $parms->{MIN_PERL_VERSION} = 5.008;
}

my $module = 'HTML::Lint 2.20';
if ( not eval "use $module; 1;" ) {
    print "You don't have $module installed, so cannot use autolinting.\n";
}

WriteMakefile( %{$parms} );


sub MY::postamble {
    return <<'MAKE_FRAG';
.PHONY: critic tags

critic:
	perlcritic -1 -q -profile perlcriticrc Mechanize.pm t/

tags:
	ctags -f tags --recurse --totals \
		--exclude=blib \
		--exclude=.svn \
		--exclude='*~' \
		--languages=Perl --langmap=Perl:+.t \

MAKE_FRAG
}
