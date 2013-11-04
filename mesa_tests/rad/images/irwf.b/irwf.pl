#!/usr/bin/perl

 sub process {
  my ($localPatient) = @_;
#  print "$localPatient\n";

  $idx = 0;
  foreach $image(@images) {
   open F_in, "<$localPatient.txt" or die "Could not open: $localPatient.txt";
   open F_out, ">$localPatient.$idx.csh";
   print F_out "#!/bin/csh\n";
   print F_out "mkdir -p $localPatient/IMAGES\n";
   print F_out "dcm_modify_object -t -T ../tcia-rembrandt/$image $localPatient/IMAGES/$image << __EOF\n";
   while ($x = <F_in>) {
    print F_out $x;
   }
   print F_out "0020 000D $root" . "$studySuffix"  . ".$studyCounter\n";
   print F_out "0020 000E $root" . "$seriesSuffix" . ".$seriesCounter\n";
   print F_out "0008 0018 $root" . "$instanceSuffix" . ".$instanceCounter\n";
   print F_out "__EOF\n";
   close F_in;
   close F_out;
   $idx++;
   $instanceCounter++;
  }

  $studyCounter++;
  $seriesCounter++;
  print "X $main::root $localPatient $studyCounter $seriesCounter $instanceCounter\n";
 }


 our $root = "1.3.6.1.4.21367.999.10";
 our $studySuffix = ".1";
 our $seriesSuffix = ".2";
 our $instanceSuffix = ".3";

 our $studyCounter = 1;
 our $seriesCounter = 1;
 our $instanceCounter = 1;

 @images = ("000000", "000001", "000002");
 @patients = ("555", "777", "888","999", "100", "200", "300",
	"1824", "1362", "2048", "3385", "3464", "4712",
	"6418", "6418G", "7012");

 foreach $p(@patients) {
#  print "$p\n";
  process($p);
 }
