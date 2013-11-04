#!/usr/local/bin/perl -w

# Package for Image Display scripts.

use Env;

package imgdisp;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
);

sub read_config_params {
  open (CONFIGFILE, "imgmgr_test.cfg") or die "Can't open imgmgr_test.cfg.\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    $varnames{$varname} = $varvalue;
  }

  $mesaOFPortDICOM = "2250";
  $mesaOFPortHL7 = "2200";

  $mesaImgMgrPortDICOM = "2350";
  $mesaImgMgrPortHL7   = "2300";

  $mesaModPortDICOM = "2400";

  $mppsHost = $varnames{"TEST_MPPS_HOST"};
  $mppsPort = $varnames{"TEST_MPPS_PORT"};
  $mppsAE = $varnames{"TEST_MPPS_AE"};

  $imCStoreHost = $varnames{"TEST_CSTORE_HOST"};
  $imCStorePort = $varnames{"TEST_CSTORE_PORT"};
  $imCStoreAE= $varnames{"TEST_CSTORE_AE"};

  $imCFindHost = $varnames{"TEST_CSTORE_HOST"};
  $imCFindPort = $varnames{"TEST_CSTORE_PORT"};
  $imCFindAE= $varnames{"TEST_CSTORE_AE"};

  $imCommitHost = $varnames{"TEST_COMMIT_HOST"};
  $imCommitPort = $varnames{"TEST_COMMIT_PORT"};
  $imCommitAE= $varnames{"TEST_COMMIT_AE"};

  $imHL7Host = $varnames{"TEST_HL7_HOST"};
  $imHL7Port = $varnames{"TEST_HL7_PORT"};

#  $logLevel = $varnames{"LOGLEVEL"};

  return ( $mesaOFPortDICOM, $mesaOFPortHL7,
	$mesaImgMgrPortDICOM, $mesaImgMgrPortHL7,
	$mesaModPortDICOM,

	$mppsHost, $mppsPort, $mppsAE,
	$imCStoreHost, $imCStorePort, $imCStoreAE,
	$imCFindHost, $imCFindPort, $imCFindAE,
	$imCommitHost, $imCommitPort, $imCommitAE,
	$imHL7Host, $imHL7Port
  );

}

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

sub delete_directory {
  my $osName = $main::MESA_OS;

  die "Env variable MESA_OS is undefined; please read Installation Guide \n" if $osName eq "";

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
  my $dirName = shift(@_);
  my $osName = $main::MESA_OS;

  die "Env variable MESA_OS is undefined; please read Installation Guide \n" if $osName eq "";

  if ($osName eq "WINDOWS_NT") {
    $dirName =~ s(/)(\\)g;
  }

  if (! (-d $dirName)) {
    `mkdir $dirName`;
  }
}

sub send_images {
  my $dirName = shift(@_);
  my $deltaFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  my $cstore = "$main::MESA_TARGET/bin/cstore -a MODALITY1 "
      . " -c $imgMgrAE ";
  $cstore .= " -d $deltaFile " if ($deltaFile ne "");
  $cstore .= " $imgMgrHost $imgMgrPort";

  print "$dirName \n";

  $imageDir = "$main::MESA_STORAGE/modality/$dirName";

  my $cstoreExec = "$cstore $imageDir";
  print "$cstoreExec \n";
  print `$cstoreExec`;
  if ($?) {
    print "Could not send $dirName to Image Manager \n";
    print " Img Mgr params: $imgMgrAE:$imgMgrHost:$imgMgrPort \n";
    main::goodbye;
  }
#  if ($main::MESA_OS eq "WINDOWS_NT") {
#    $imageDir = "$main::MESA_STORAGE\\modality\\$procedureName";
#  } else {
#    $imageDir = "$main::MESA_STORAGE/modality/$procedureName";
#  }
#  opendir IMAGE, $imageDir or die "directory: $imageDir not found!";
#  @imageMsgs = readdir IMAGE;
#  closedir IMAGE;
#
#  foreach $imageFile (@imageMsgs) {
#    if ($imageFile =~ /.dcm/) {
#      my $cstoreExec = "$cstore $main::MESA_STORAGE/modality/$procedureName/$imageFile";
#      print "$cstoreExec \n";
#      print `$cstoreExec`;
#      if ($? != 0) {
#	print "Could not send image $imageFile to Image Manager: $imgMgrAE\n";
#	  main::goodbye;
#      }
#    }
#  }
}


sub send_cfind {
  my $cfindFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);
  my $outDir = shift(@_);

  $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $imgMgrAE -f $cfindFile -o $outDir -x STUDY $imgMgrHost $imgMgrPort ";

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
}

sub make_dcm_object {
  my $cfindTextFile = shift(@_);

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $cfindTextFile.txt $cfindTextFile.dcm";
  print "$x \n";
  print `$x`;

  if ($?) {
    print "Could not create DCM object from $cfindTextFile \n";
    exit 1;
  }
}

sub find_matching_query {
  my $verbose = shift(@_);
  my $queryDirectory = shift(@_);
  my $tagValue = shift(@_);
  my $attributeValue = shift(@_);

  print main::LOG
	"Searching for C-Find query $tagValue $attributeValue in $queryDirectory \n";

  opendir CFINDDIR, $queryDirectory or die "Could not open: $queryDirectory \n";
  @cfindMsgs = readdir CFINDDIR;
  closedir CFINDDIR;

  foreach $cfindFile (@cfindMsgs) {
    if ($cfindFile =~ /.qry/) {

      $v = `$main::MESA_TARGET/bin/dcm_print_element $tagValue $queryDirectory/$cfindFile`;
      chomp $v;
      print main::LOG " $queryDirectory/$cfindFile $v \n" if $verbose;

      if ($v eq $attributeValue) {
	return $cfindFile;
      }
    }
  }

  return "";
}

sub find_all_queries {
  my $verbose = shift(@_);
  my $queryDirectory = shift(@_);

  print main::LOG
	"Searching for all C-Find queries in $queryDirectory \n";

  opendir CFINDDIR, $queryDirectory or die "Could not open: $queryDirectory \n";
  @cfindMsgs = readdir CFINDDIR;
  closedir CFINDDIR;

  return @cfindMsgs;
}


sub cstore_file{
  my $fileName = shift(@_);
  my $deltaFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  die "In imgdisp::cstore_file, file $fileName does not exist \n" if (! (-e $fileName));

  my $cstore = "$main::MESA_TARGET/bin/cstore -a MODALITY1 "
      . " -c $imgMgrAE ";
  $cstore .= " -d $deltaFile " if ($deltaFile ne "");
  $cstore .= " $imgMgrHost $imgMgrPort";

  print "$fileName \n";

  my $cstoreExec = "$cstore $fileName";
  print "$cstoreExec \n";
  print `$cstoreExec`;
  if ($?) {
    print "Could not send $fileName to Image Manager \n";
    print " Img Mgr params: $imgMgrAE:$imgMgrHost:$imgMgrPort \n";
    main::goodbye;
  }
}

1;