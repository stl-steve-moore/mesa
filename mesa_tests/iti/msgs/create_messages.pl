#!/usr/local/bin/perl

# This script creates test/data messages for IHE Year 3 tests.

use Env;
use Cwd;

@adtNames = ("10501", "10502", "10506", "10511", "10512", "10514", "10515", "113aa", "113xx",
	"12101", "12102", "12103", "12120", "12121");

$dir = cwd();

foreach $adt(@adtNames) {
  print "adt/$adt \n";
  chdir ("adt/$adt") or die "Could not change to adt/$adt \n";

  if (! (-e "$adt.pl")) {
    print "Could not find perl file in adt/$adt \n";
    exit 1;
  }

  print `perl $adt.pl` or die "Could not execute in adt/$adt \n";

  chdir ($dir);
}

@qbpNames = ("10501", "10502", "10503", "10506", "10511", "10514", "10515");

$dir = cwd();

foreach $qbp(@qbpNames) {
  print "qbp/$qbp \n";
  chdir ("qbp/$qbp") or die "Could not change to qbp/$qbp \n";

  if (! (-e "$qbp.pl")) {
    print "Could not find perl file in qbp/$qbp \n";
    exit 1;
  }

  print `perl $qbp.pl` or die "Could not execute in qbp/$qbp \n";

  chdir ($dir);
}

@pdqNames = ("11311", "11312", "11315", "11320", "11325", "11335", "11350", "11365");

$dir = cwd();

foreach $pdq(@pdqNames) {
  print "pdq/$pdq \n";
  chdir ("pdq/$pdq") or die "Could not change to pdq/$pdq \n";

  if (! (-e "$pdq.pl")) {
    print "Could not find perl file in pdq/$pdq \n";
    exit 1;
  }

  print `perl $pdq.pl` or die "Could not execute in pdq/$pdq \n";

  chdir ($dir);
}

