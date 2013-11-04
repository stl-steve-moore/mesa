#!/usr/local/bin/perl

# This script creates test/data messages for IHE Year 3 tests.

use Env;
use Cwd;

@adtNames = (
	"20101", "20102", "20106", "20108", "20204", "20205", "20206",
	"20710", "20712");

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

@orderNames = (
	"20101", "20102", "20106", "20108", "20204", "20205", "20206",
	"20710", "20712");

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

@schedNames = (
	"20101", "20102", "20106", "20108", "20204", "20205", "20206",
	"20710", "20712");

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

@statusNames = ("20204", "20205");

foreach $x(@statusNames) {
  print "status/$x\n";
  chdir ("status/$x") or die "Could not change to status/$x\n";

  if (! (-e "$x.pl")) {
    print "Could not find perl file in status/$x \n";
    exit 1;
  }

  print `perl $x.pl` or die "Could not execute in status/$x\n";

  chdir ($dir);
}

@rptNames = ("20501", "20503", "20520", "20530");

foreach $x(@rptNames) {
  print "rpt/$x\n";
  chdir ("rpt/$x") or die "Could not change to rpt/$x\n";

  if (! (-e "$x.pl")) {
    print "Could not find perl file in rpt/$x \n";
    exit 1;
  }

  print `perl $x.pl` or die "Could not execute in rpt/$x\n";

  chdir ($dir);
}

@idcoNames = ("20810");

foreach $x(@idcoNames) {
  print "idco/$x\n";
  chdir ("idco/$x") or die "Could not change to idco/$x\n";

  if (! (-e "$x.pl")) {
    print "Could not find perl file in idco/$x \n";
    exit 1;
  }

  print `perl $x.pl` or die "Could not execute in idco/$x\n";

  chdir ($dir);
}
