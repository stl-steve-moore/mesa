#!/usr/local/bin/perl -w

# Package for Importer scripts.

use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

package mod;
require Exporter;
#@ISA = qw(Exporter);
#@EXPORT = qw(
#);



sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
	"MESA_IMG_MGR_PORT_HL7", "MESA_IMG_MGR_PORT_DCM",
	"MESA_IMG_MGR_AE_MPPS",  "MESA_IMG_MGR_AE_CSTORE",
	"MESA_OF_HOST",
	"MESA_OF_PORT_DCM",	 "MESA_OF_AE",
	"MESA_OF_PORT_HL7"
  );

  foreach $n (@names) {
#    print "$n\n";
    my $v = $h{$n};
#    print " $v \n";
    if (! $v) {
      print "No value for $n \n";
      $rtnVal = 1;
    }
  }
  return $rtnVal;
}











sub read_ppsSOPUID {
  my $fname = shift(@_);

  open FILE, $fname or die "Unable to find PPS SOP UID file: $fname\n";

  $uid = <FILE>;
  return $uid;
}

sub universal_service_id {
  my $dirName  = shift(@_);
  my $msgName  = shift(@_);

  my $pathMsg = "$dirName/$msgName";

  $x = "$main::MESA_TARGET/bin/hl7_get_value -f $pathMsg OBR 4 0";

  $y = `$x`;

  return $y;
}

sub local_scheduling_postprocessing {
  my $plaOrdNum  = shift(@_);
  my $proc  = shift(@_);
  my $gpspsFile  = shift(@_);

  $x = "$main::MESA_TARGET/bin/ppm_sched_gpsps -o $plaOrdNum " .
       " -p $proc ordfil $gpspsFile";
  if ($main::MESA_OS eq "WINDOWS_NT") {
    $x =~ s(/)(\\)g;
  }
  print "$x\n";
  print `$x`;

}


1;
