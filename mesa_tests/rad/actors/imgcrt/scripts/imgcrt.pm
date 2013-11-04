#!/usr/local/bin/perl -w

# Package for Image Creator scripts.

use Env;

package imgcrt;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
 );

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
}

sub cstore {
  my $fileName = shift(@_);
  my $deltaFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

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

sub lookup_filnam_uid_by_series_uid
{
  my $verbose = shift(@_);
  my $seriesUID = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c serinsuid $seriesUID " .
        " filnam sopins imgmgr tmp/filename.txt";

  print main::LOG "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not select File Name from Image Manager table \n";
    exit 1;
  }

  open (NAMES, "tmp/filename.txt") or die
        "Could not open tmp/filename.txt (output of mesa_select_column) \n";

  $idx = 0;
  undef @rtnFileNames;
  while (<NAMES>) {
    $f = $_;
    chomp $f;
    $rtnFileNames[$idx] = $f;
    $idx++;
  }
  return @rtnFileNames;
}

sub lookup_series_uid_by_study_uid
{
  my $verbose = shift(@_);
  my $studyUID = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c stuinsuid $studyUID " .
        " serinsuid series imgmgr tmp/seruid.txt";

  print main::LOG "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not select Series UID from Image Manager table \n";
    exit 1;
  }

  open (SERIES_UIDS, "tmp/seruid.txt") or die
        "Could not open tmp/seruid.txt (output of mesa_select_column) \n";

  $idx = 0;
  undef @rtnSeries;
  while (<SERIES_UIDS>) {
    $f = $_;
    chomp $f;
    $rtnSeries[$idx] = $f;
    $idx++;
  }
  return @rtnSeries;
}

sub lookup_sopins_uid_by_series_uid
{
  my $verbose = shift(@_);
  my $seriesUID = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c serinsuid $seriesUID " .
        " insuid sopins imgmgr tmp/sopinsuid.txt";

  print main::LOG "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not select SOP Instance UID from Image Manager table \n";
    exit 1;
  }

  open (SOPINS_UIDS, "tmp/sopinsuid.txt") or die
        "Could not open tmp/sopinsuid.txt (output of mesa_select_column) \n";

  $idx = 0;
  undef @rtnSOPINS;
  while (<SOPINS_UIDS>) {
    $f = $_;
    chomp $f;
    $rtnSOPINS[$idx] = $f;
  }
  return @rtnSOPINS;
}


sub lookup_study_uid_by_patient_id
{
  my $verbose = shift(@_);
  my $patientID = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c patid $patientID " .
        " stuinsuid ps_view imgmgr tmp/stuuid.txt";

  print main::LOG "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not select Study UID from Image Manager table \n";
    exit 1;
  }

  open (STUDY_UIDS, "tmp/stuuid.txt") or die
        "Could not open tmp/stuuid.txt (output of mesa_select_column) \n";

  $idx = 0;
  undef @rtnStudies;
  while (<STUDY_UIDS>) {
    $f = $_;
    chomp $f;
    $rtnStudies[$idx] = $f;
    $idx++;
  }
  return @rtnStudies;
}


sub find_images_by_patient_sop_class
{
  my $verbose = shift(@_);
  my $patientID = shift( @_ );
  my $sopClass = shift( @_ );

  print main::LOG "Patient ID = $patientID \n" if $verbose;

  undef @studyUID;
  my @studyUID = imgcrt::lookup_study_uid_by_patient_id($verbose, $patientID);
  $count = scalar(@studyUID);
  if ($count == 0) {
    print "In imgcrt::find_images_by_patient, found 0 studies \n" .
        "for the Patient ID: $patientID.  The count should be at least 1.\n ";
    print main::LOG "In imgcrt::find_images_by_patient, found 0 studies\n" .
        "for the Patient ID: $patientID.  The count should be at least 1.\n ";
    exit 1;
  }
  my $idx = 0;
  undef @rtnFiles;
  foreach $study(@studyUID) {
    print  main::LOG " Study: $study \n" if $verbose;
    print  " Study: $study \n" if $verbose;
    undef @seriesUID;
    my @seriesUID = imgcrt::lookup_series_uid_by_study_uid($verbose, $study);
    foreach $series(@seriesUID) {
      print  main::LOG "  Series: $series \n" if $verbose;
      print  "  Series: $series \n" if $verbose;
      undef @fileNames;
      @fileNames = imgcrt::lookup_filnam_uid_by_series_uid($verbose, $series);
      foreach $f(@fileNames) {
	$x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0016 $f";
	$uid = `$x`; chomp $uid;
	if ($uid eq $sopClass) {
	  if ($idx == 0) {
	    print main::LOG "$idx $f \n" if $verbose;
	  }
	  $rtnFiles[$idx] = $f;
	  $idx++;
	}
      }
    }
  }
  return @rtnFiles;
}

sub eval_key_image
{
  my $verbose    = shift(@_);
  my $masterFile = shift(@_);
  my $testFile   = shift(@_);
  my $iniFile    = shift(@_);
  my $reqFile    = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "In comparing Key Image note, the master file $masterFile is missing\n";
    print main::LOG " This means there is a problem in the installation.\n";
    return 1;
  }
  if (! (-e $testFile) ) {
    print main::LOG "In comparing Key Image note, the test file $testFile is missing\n";
    print main::LOG " This means the MESA database is inconsistent with files\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/dcm_print_element 0020 000D $masterFile";
  print main::LOG "$x \n" if $verbose;
  $uid = `$x`;
  print main::LOG "Study Instance UID master file: $uid\n" if $verbose;
  
  $x = "$main::MESA_TARGET/bin/dcm_print_element 0020 000D $testFile";
  print main::LOG "$x \n" if $verbose;
  $uid = `$x`;
  print main::LOG "Study Instance UID test file:   $uid\n" if $verbose;

  $x = "$main::MESA_TARGET/bin/compare_dcm -m $iniFile ";
  $x .= " -v " if $verbose;
  $x .= " $masterFile $testFile";

  $rtnValue = 0;
  print main::LOG "$x\n";
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "Attribute comparison failed for Key Image Note\n";
    print main::LOG " File name is $testFile \n";
    $rtnValue = 1;
  }

  $x = "$main::MESA_TARGET/bin/mesa_sr_eval -r $reqFile -t 2010:DCMR ";
  $x .= " -v " if $verbose;
  $x .= " -p $masterFile $testFile ";
  print main::LOG "$x\n";
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "SR Evaluation failed for Key Image Note\n";
    print main::LOG " File name is $testFile \n";
    $rtnValue = 1;
  }

  return $rtnValue;
}

sub getSOPUID {
  my $dicomObjectFile = shift(@_);

  if ($main::MESA_OS eq "WINDOWS_NT") {
    $dicomObjectFile =~ s(/)(\\)g;
  }
  $x = "dcm_print_element 0008 0018 $dicomObjectFile";
  my $sopuid = `$x`;

  return $sopuid;
}

sub read_config_params {
  my $f = shift(@_);
  open (CONFIGFILE, $f ) or die "Can't open $f .\n";
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

  $imCFindHost = $varnames{"TEST_CFIND_HOST"};
  $imCFindPort = $varnames{"TEST_CFIND_PORT"};
  $imCFindAE= $varnames{"TEST_CFIND_AE"};

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

sub read_ppm_config_params {
  my $f = shift(@_);
  open (CONFIGFILE, $f ) or die "Can't open $f .\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    $varnames{$varname} = $varvalue;
  }

  $test_ppmHost = $varnames{"TEST_PPM_HOST"};
  $test_ppmPort = $varnames{"TEST_PPM_PORT"};
  $test_ppmAE = $varnames{"TEST_PPM_AE"};

  $mesa_ppmHost = $varnames{"MESA_PPM_HOST"};
  $mesa_ppmPort = $varnames{"MESA_PPM_PORT"};
  $mesa_ppmAE = $varnames{"MESA_PPM_AE"};

  return ( $mesa_ppmHost, $mesa_ppmPort, $mesa_ppmAE,
           $test_ppmHost, $test_ppmPort, $test_ppmAE,
  );
}

# Send HL7 message to a server.  Arguments:
# 1 - Directory with messages
# 2 - Message to send
# 3 - Host name of target
# 4 - Port number of target

sub send_hl7 {
  my $hl7Dir = shift(@_);
  my $msg = shift(@_);
  my $target = shift(@_);
  my $port   = shift(@_);

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe ";
  print "$send_hl7 $target $port $hl7Dir/$msg \n";
  print `$send_hl7 $target $port $hl7Dir/$msg`;

  return 1 if $?;

  return 0;
}

sub send_mpps
{
  my $directoryName   = "$main::MESA_STORAGE/modality/" . shift(@_);
  my $sourceAE        = shift(@_);
  my $destAE   = shift(@_);
  my $destHost = shift(@_);
  my $destPort = shift(@_);

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/ncreate -a MESA_MOD -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.crt $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Create \n" if ($?);

  $x = "$main::MESA_TARGET/bin/nset    -a MESA_MOD -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.set $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Set \n" if ($?);
}

# store_images
#
# like send_images but use cstore application. Cstore allows the specification
# of a "deltafile" to alter the images before sending.
#
#    procedureName is the path, relative to MESA_STORAGE/modality, of the
#    directory containing all images to be sent. All files in this directory
#    ending in .dcm or .pre (presentation state) will be processed.
#
#    deltafile should be "" if there is not one to apply to the images.
#
sub store_images {
  my $procedureName   = shift(@_);
  my $deltafile       = shift(@_);
  my $sourceAE        = shift(@_);
  my $destinationAE   = shift(@_);
  my $destinationHost = shift(@_);
  my $destinationPort = shift(@_);
  my $noPixels        = shift(@_);

  $cmd = "$main::MESA_TARGET/bin/cstore";

  $cmd .= " -q -r";
  $cmd .= " -a $sourceAE";
  $cmd .= " -c $destinationAE";
  if( $deltafile) { $cmd .= " -d $deltafile"}
  if( $noPixels == 1) {
    $cmd .= " -p";
  }

  $cmd .= " $destinationHost $destinationPort";

  $imageDir = "$main::MESA_STORAGE/modality/$procedureName/";

  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(/)(\\)g;
    $imageDir =~ s(/)(\\)g;
  }

  opendir IMAGE, $imageDir or die "directory: $imageDir not found!";
  @imageMsgs = readdir IMAGE;
  closedir IMAGE;

  foreach $imageFile (@imageMsgs) {
    if ($imageFile =~ /.dcm/ or $imageFile =~ /.pre/) {
      my $cstoreExec = "$cmd $imageDir$imageFile";
      print "$cstoreExec \n";
      print `$cstoreExec`;
      if ($? != 0) {
        print "Could not send image $imageFile to Image Manager: $destinationAE\n";
        print "Exiting...\n";
        exit 1;
      }
    }
  }
}

# Send a storage commitment request to an Image Manager
# While we are at it, send the N-Event response that we expect
# to the MESA modality.  We will compare that response with what
# is sent later by the Image Manager.

sub send_storage_commit {
  my $procedureName = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);
  my $mesaModalityPort = shift(@_);
  my $commitUID = "1.2.840.10008.1.20.1.1";

  $naction = "$main::MESA_TARGET/bin/naction -a MESA_MOD -c $imgMgrAE " .
                " $imgMgrHost $imgMgrPort commit ";
  $nevent  = "$main::MESA_TARGET/bin/nevent  -a MESA localhost " .
                " $mesaModalityPort commit ";

  print "$procedureName \n";

  $nactionExec = "$naction $main::MESA_STORAGE/modality/$procedureName/sc.xxx ".           " $commitUID ";

  print "$nactionExec \n";
  print `$nactionExec`;
  if ($?) {
    print "Could not send Storage Commitment N-Action to Image Mgr \n";
    exit 1;
  }

  $neventExec = "$nevent $main::MESA_STORAGE/modality/$procedureName/sc.xxx " .
        " $commitUID ";
  print "$neventExec \n";
  print `$neventExec`;
  if ($?) {
    print "Could not send Storage Commitment N-Event to MESA modality\n";
    exit 1;
  }
}

1;
