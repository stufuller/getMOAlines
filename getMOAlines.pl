#!/usr/bin/perl -w

use strict;

my $defaultFile = "c:/users/stu/desktop/moa-2019-q2.csv";

my $inputFile = $ARGV[0] || $defaultFile;
my $infil;
my $inlin;
my $runDate;
my $account;
my $action;
my @unused;
my $kept;
my @contrib;
my @fees;
my @ending;
my $fundName;
my $transDate;
my $type;
my $dollars;
my $price;
my $shares;
my $junk;
my $outlin;
my $oldFundName = "";
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

open($infil, $inputFile) or die("Failed to open input file $inputFile\n");

while (!eof($infil)) {
	$inlin = readline $infil || die("error reading input file $!");
	chomp $inlin;
	if (split(/,/, $inlin) == 10) {
		($junk, $fundName, $transDate, $type, $dollars, $price, $shares) = split(/,/, $inlin);
		$type = trim($type);
		if ($type eq "Type") { 
			next;
		}
		$dollars =~ s/^\$//;
		$dollars = sprintf("%6.2f", $dollars);
		$price =~ s/^\$//;
		$price = sprintf("%6.2f", $price);
		$shares =~ s/^\$//;
		$shares = sprintf("%6.2f", $shares);
		
		if ($type eq "Contributions") {
			$outlin = join(' : ', $fundName, $transDate, "Con", $dollars, $price, $shares); 
			if ($oldFundName eq "") {
				$oldFundName = $fundName;
			}
			elsif ($oldFundName ne $fundName) {
				push(@contrib, "\n");
				$oldFundName = $fundName;
			}
			push(@contrib, $outlin . "\n");
		}
		elsif ($type eq "Recordkeeping Fee") {
			$outlin = join(' : ', $fundName, $transDate, "Fee", $dollars, $price, $shares); 
			push(@fees, $outlin . "\n");
		}
	}
}

print  @contrib;
print "\n";
print @fees;
