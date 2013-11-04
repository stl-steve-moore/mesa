#!/usr/local/bin/perl -w

# Package for Report Creator scripts.

use Env;

package rpt_crt;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(read_config_params xmit_error delete_directory create_directory send_images);


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
  my $dirName = shift(@_);

  if (! (-d $dirName)) {
    return;
  }

  if ($osName eq "WINDOWS_NT") {
    `rmdir/q/s $dirName`;
  } else {
    `rm -rf $dirName`;
  } 
}

sub create_directory {
  my $dirName = shift(@_);

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
}

sub cstore {
  my $fileName = shift(@_);
  my $deltaFile = shift(@_);
  my $mgrAE = shift(@_);
  my $mgrHost = shift(@_);
  my $mgrPort = shift(@_);

  my $cstore = "$main::MESA_TARGET/bin/cstore -a MODALITY1 "
      . " -c $mgrAE ";
  $cstore .= " -d $deltaFile " if ($deltaFile ne "");
  $cstore .= " $mgrHost $mgrPort";

  print "$fileName \n";

  my $cstoreExec = "$cstore $fileName";
  print "$cstoreExec \n";
  print `$cstoreExec`;
  if ($?) {
    print "Could not send $fileName to storage manager \n";
    print " Params: $mgrAE:$mgrHost:$mgrPort \n";
    main::goodbye;
  }
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

sub make_dcm_object_japanese {
  my ($outputFile, $inputFile1, $inputFile2) = @_;

  my $x;
  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $inputFile1 $outputFile.tmp";
  print "$x \n";
  print `$x`;

  if ($?) {
    print "Could not create DCM object from $inputFile1 \n";
    exit 1;
  }

  $x = "$main::MESA_TARGET/bin/dcm_modify_elements $outputFile.tmp $outputFile < $inputFile2";
  print "$x \n";
  print `$x`;

  if ($?) {
    print "Could not modify DCM object from $inputFile2 \n";
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

sub find_matching_composite_objs {
  my $verbose = shift(@_);
  my $tagValue = shift(@_);
  my $attributeValue = shift(@_);

  print main::LOG
    "Searching for composite objects by $tagValue $attributeValue \n";

  $x = "$main::MESA_TARGET/bin/mesa_select_column filnam sopins rpt_manager files.txt";
  print "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not execute $x \n";
    exit 1;
  }

  open(FILENAMES, "files.txt") or die
	"Could not open files.txt (output of mesa_select_column) \n";

  $idx = 0;
  while (<FILENAMES>) {
    $f = $_;
    chomp $f;

    $v = `$main::MESA_TARGET/bin/dcm_print_element $tagValue $f`;
    chomp $v;
    print main::LOG " $f $v \n" if $verbose;

    if ($v eq $attributeValue) {
      $rtnValues[$idx] = $f;
      $idx ++;
    }
  }
  return @rtnValues
}

sub convert_sr_to_hl7 {
  my $srDICOM = shift(@_);
  my $hl7Report = shift(@_);
  my $mshFile = shift(@_);

  $x = "$main::MESA_TARGET/bin/sr_to_hl7 -t $mshFile $srDICOM $hl7Report";
  print "$x \n";
  print `$x`;
  if ($?) {
    print "Could not convert DICOM SR to HL7 report \n";
    exit 1;
  }
}


