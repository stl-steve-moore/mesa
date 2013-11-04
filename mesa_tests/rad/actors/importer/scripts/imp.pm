#!/usr/local/bin/perl -w

# Package for Importer scripts.

use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

package imp;
require Exporter;
#@ISA = qw(Exporter);
#@EXPORT = qw(
#);



sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
	"TEST_IMPORTER_STORAGE_COMMITMENT_AE",
	"TEST_IMPORTER_STORAGE_COMMITMENT_HOST",
	"TEST_IMPORTER_STORAGE_COMMITMENT_PORT",

	"MESA_IMG_MGR_PORT_HL7", "MESA_IMG_MGR_PORT_DCM",
	"MESA_IMG_MGR_AE_MPPS",  "MESA_IMG_MGR_AE_CSTORE",
	"MESA_OF_HOST",
	"MESA_OF_PORT_DCM",	 "MESA_OF_AE_MWL",
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


sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}


sub schedule_MR {
  print `main::$MESA_BIN/bin/of_schedule -t MODALITY1 -m MR -s STATION1 ordfil`;
}

sub delete_directory {
  my $osName = $main::MESA_OS;
  my $dirName = shift(@_);

  if (! (-d $dirName)) {
    return;
  }

  if ($osName eq "WINDOWS_NT") {
    $dirName =~ s(/)(\\)g;
    `rmdir/q/s $dirName`;
  } else {
    `rm -rf $dirName`;
  } 
}

sub create_directory {
  my $osName = $main::MESA_OS;
  my $dirName = shift(@_);

  if ($osName eq "WINDOWS_NT") {
    $dirName =~ s(/)(\\)g;
  }

  if (! (-d $dirName)) {
    `mkdir $dirName`;
  }
}

sub send_images {
  my $cstore = "$main::MESA_TARGET/bin/send_image -q -r -a MODALITY1 "
      . " -c MESA ";
  $cstore .= " localhost $main::imPortDICOM";

  foreach $procedure(@_) {
    print "$procedure \n";

    my $imageDir = "$main::MESA_STORAGE/modality/$procedure";
    opendir IMAGE, $imageDir or die "directory: $imageDir not found!";
    @imageMsgs = readdir IMAGE;
    closedir IMAGE;

    foreach $imageFile (@imageMsgs) {
      if ($imageFile =~ /.dcm/) {
	my $cstoreExec = "$cstore $main::MESA_STORAGE/modality/$procedure/$imageFile";
	print "$cstoreExec \n";
	print `$cstoreExec`;
	if ($? != 0) {
	  print "Could not send image $imageFile to MESA Image Manager\n";
	  main::goodbye;
	}
      }
    }
  }
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
