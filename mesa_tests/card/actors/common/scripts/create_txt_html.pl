#!/usr/local/bin/perl

# This script creates txt/html files for IHE Card tests

use Env;
use Cwd;

@fileNames = (
	"20101:cath",
	"20102:cath",
	"20106:cath",
	"20108:cath",
	"20204:echo",
	"20205:echo",
	"20206:echo",
	"20520:drpt",
	"20530:drpt",
	"20710:stress",
	"20712:stress",
	);

$dir = cwd();

foreach $file (@fileNames) {
  my ($case, $profile) = split /:/, $file;
  print `perl $dir/scripts/mesa_test_xml_process.pl $case card/$profile/test_cases/html` or die "Could not execute script to generate txt/html files \n";
}

