package Finance::Currency::Convert::ECB;
use strict;
use warnings;
use Exporter;
our @ISA = qw/Exporter/;
our @EXPORT = qw/newcurrency newcurrency2 currencylist/;
our $VERSION = '0.3';

use XML::Simple;
use LWP::Simple;
use Cache::FileCache;
use Finance::Currency::Convert;

sub newcurrency {
	my($amount, $from, $to) = @_;
	$amount = 1 unless defined $amount;
	$from = "EUR" unless defined $from;
	$to = "USD" unless defined $to;
	my $cache = new Cache::FileCache( { 'namespace' => 'ecb', 'default_expires_in' => 86400 } );

	my $load = $cache->get( 'ecb' );
	if(not defined $load){
		$cache->set( 'ecb', get("http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml"));
		$load = $cache->get( 'ecb' );
	}
	my $ref = XMLin($load);
	my $converter = new Finance::Currency::Convert;

	foreach my $key (@{$ref->{'Cube'}->{'Cube'}->{'Cube'}}){
		$converter->setRate("EUR", $key->{currency}, $key->{rate});
	}
	return $converter->convert($amount, $from, $to);
}

sub newcurrency2 {
	my($amount, $from, $to, $to2) = @_;
	return(sprintf("%.2f",newcurrency($amount, $from, $to) / newcurrency($amount, $from, $to2)));
}

sub currencylist {
	my $output;
	my $cache = new Cache::FileCache( { 'namespace' => 'ecb', 'default_expires_in' => 86400 } );

	my $load = $cache->get( 'ecb' );
	if(not defined $load){
		$cache->set( 'ecb', get("http://www.ecb.int/stats/eurofxref/eurofxref-daily.xml"));
		$load = $cache->get( 'ecb' );
	}
	my $ref = XMLin($load);

	$output .= "EUR: 1.00\n";
	foreach my $key (@{$ref->{'Cube'}->{'Cube'}->{'Cube'}}){
		$output .= $key->{currency}.": ".$key->{rate}."\n";
	}
	return($output);
}

=pod

=head1 NAME

Finance::Currency::Convert::ECB - convert currencies with up to date currencies from European Central Bank (ecb.int)

=head1 SYNOPSIS

	use Finance::Currency::Convert::ECB;
	$result = newcurrency(100, "EUR", "USD");

	# Difference
	$result = newcurrency2(100, "EUR", "USD", "GBP");

	# available currencies:
	# USD, JPY, BGN, CZK, DKK, EEK, GBP, HUF, LTL, LVL, PLN, 
	# RON, SEK, CHF, NOK, HRK, RUB, TRY, AUD, BRL, CAD, CNY, 
	# HKD, IDR, INR, KRW, MXN, MYR, NZD, PHP, SGD, THB, TAR
	#
	# or use:
	# print currencylist();

=head1 DESCRIPTION

Finance::Currency::Convert::ECB uses a XML list to convert currencies.

=head1 AUTHOR

    -

=head1 COPYRIGHT

This program is free software; you can redistribute
it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO



=cut
