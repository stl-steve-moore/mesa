#!/usr/local/bin/perl

# This script creates test/data messages for IHE Year 3 tests.

use Env;
use Cwd;

@adtNames = ("100", "101", "102", "103", "104", "105", "106", "107", "109", "110",
	"111", "131", "132", "133", "134",
	"141", "142",
	"151", "152", "153",
	"1240",
	"1301", "1302", "1303", "1305",
	"1411", "1412", "142x", "1601", "1603", "1701",
	"3725", "3726", "3740", "3742",
	"50000", "50001", "50002", "50004",
	"502xx",
	"eyecare2006",
	"2xx", "2xx-j");

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

@chgNames = ("1301", "1302", "1303", "1305");

$dir = cwd();

foreach $chg(@chgNames) {
  print "chg/$chg \n";
  chdir ("chg/$chg") or die "Could not change to chg/$chg \n";

  if (! (-e "$chg.pl")) {
    print "Could not find perl file in chg/$chg \n";
    exit 1;
  }

  print `perl $chg.pl` or die "Could not execute in chg/$chg \n";

  chdir ($dir);
}

@orderNames = ("100", "101", "102", "103", "104", "105", "106", "107", "109", "110",
	"111", "131", "132", "133", "134",
	"141", "142",
	"151", "152", "153",
	"1305",
	"1411", "1412", "142x", "1601", "1603", "1701",
	"3725", "3726", "3740", "3742",
	"50000", "50001", "50002", "50004",
	"502xx",
	"eyecare2006",
	"2xx", "2xx-j" );

foreach $order(@orderNames) {
  print "order/$order \n";
  chdir ("order/$order") or die "Could not change to order/$order \n";

  if (! (-e "$order.pl")) {
    print "Could not find perl file in order/$order \n";
    exit 1;
  }

  print `perl $order.pl` or die "Could not execute in order/$order \n";

  chdir ($dir);
}

@schedNames = ("100", "101", "102", "103", "104", "105", "106", "107", "109", "110",
	"111", "131", "132", "133", "134",
	"141", "142",
	"1305",
	"1412", "142x", "1601", "1603", "1701",
	"3725", "3726", "3740", "3742",
	"50000", "50002", "50004",
	"eyecare2006",
	 );

foreach $sched(@schedNames) {
  print "sched/$sched \n";
  chdir ("sched/$sched") or die "Could not change to sched/$sched \n";

  if (! (-e "$sched.pl")) {
    print "Could not find perl file in sched/$sched \n";
    exit 1;
  }

  print `perl $sched.pl` or die "Could not execute in sched/$sched \n";

  chdir ($dir);
}

@statusNames = ("107" );

foreach $status(@statusNames) {
  print "status/$status \n";
  chdir ("status/$status") or die "Could not change to status/$status \n";

  if (! (-e "$status.pl")) {
    print "Could not find perl file in status/$status \n";
    exit 1;
  }

  print `perl $status.pl` or die "Could not execute in status/$status \n";

  chdir ($dir);
}

@srNames = ("511", "512", "513",
	"601", "601-j", "602", "602-j", "603", "603-j",
	"604", "604-j", "605", "605-j", "606", "606-j",
	"611", "611-j", "661", "661-j", "663", "663-j",
	"1402", "4404");

foreach $sr(@srNames) {
  print "sr/$sr \n";
  chdir ("sr/$sr") or die "Could not change to sr/$sr \n";
  if (! (-e "$sr.pl")) {
    print "Could not find perl file in sr directory \n";
    exit 1;
  }

  print `perl $sr.pl` or die "Could not execute $sr perl file \n";

  chdir ($dir);
}

@ppmNames = ("111", "1412", "142x" );

foreach $ppm(@ppmNames) {
  print "ppm/$ppm \n";
  chdir ("ppm/$ppm") or die "Could not change to ppm/$ppm \n";
  if (! (-e "$ppm.pl")) {
    print "Could not find perl file in ppm directory \n";
    exit 1;
  }

  print `perl $ppm.pl` or die "Could not execute $ppm perl file \n";

  chdir ($dir);
}

@rwfNames = ("1601", "1603", "common" );

foreach $rwf(@rwfNames) {
  print "rwf/$rwf \n";
  chdir ("rwf/$rwf") or die "Could not change to rwf/$rwf \n";
  if (! (-e "$rwf.pl")) {
    print "Could not find perl file in rwf directory \n";
    exit 1;
  }

  print `perl $rwf.pl` or die "Could not execute $rwf perl file \n";

  chdir ($dir);

}

@appointNames = (
	"151", "152", "153"
	);

foreach $appoint(@appointNames) {
  print "appoint/$appoint \n";
  chdir ("appoint/$appoint") or die "Could not change to appoint/$appoint \n";

  if (! (-e "$appoint.pl")) {
    print "Could not find perl file in order/$appoint \n";
    exit 1;
  }

  print `perl $appoint.pl` or die "Could not execute in appoint/$appoint \n";

  chdir ($dir);
}
