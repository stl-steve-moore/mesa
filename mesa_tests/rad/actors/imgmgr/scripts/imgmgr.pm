#!/usr/local/bin/perl -w

# Package for Image Manager scripts.

use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

package imgmgr;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
);

sub read_config_params_hash {
  %varnames = mesa::get_config_params("imgmgr_test.cfg");
}

sub read_config_params {
  %varnames = mesa::get_config_params(@_);

  $mesaOFPortDICOM = $varnames{"MESA_OF_DICOM_PORT"};
  $mesaOFPortHL7 = $varnames{"MESA_OF_HL7_PORT"};

  $mesaImgMgrPortDICOM = $varnames{"MESA_IMGMGR_DICOM_PT"};
  $mesaImgMgrPortHL7   = $varnames{"MESA_IMGMGR_HL7_PORT"};

  $mesaModPortDICOM = $varnames{"MESA_MODALITY_PORT"};

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

sub schedule_MR {
  print `main::$MESA_BIN/bin/of_schedule -t MESA_MOD -m MR -s STATION1 ordfil`;
}

sub evaluate_mpps  {
  print main::LOG "imgmgr::evaluate_mpps is retired.  Error in the test script\n";
  print "imgmgr::evaluate_mpps is retired.  Error in the test script\n";
  exit 1;
  my $verbose = shift(@_);
  my $stdDir  = shift(@_);
  my $storageDir  = shift(@_);
  my $mpps_UID = shift(@_);
  my $testNumber = shift(@_);

  if (! -e($storageDir)) {
    print main::LOG "MESA Image Mgr storage directory does not exist \n";
    print main::LOG " Directory is expected to be: $storageDir \n";
    print main::LOG " Did you invoke the evaluation script with the proper AE title? \n";
    return 1;
  }

  if (! -e("$storageDir/$mpps_UID")) {
    print main::LOG "MESA Image Mgr MPPS directory does not exist \n";
    print main::LOG " Directory is expected to be: $storageDir/$mpps_UID \n";
    print main::LOG " This implies you did not forward MPPS messages for these MPPS events.\n";
    return 1;
  }

  if (! -e("$storageDir/$mpps_UID/mpps.dcm")) {
    print main::LOG "MPPS status file does not exist \n";
    print main::LOG " File is expected to be: $storageDir/$mpps_UID/mpps.dcm \n";
    print main::LOG " This implies a problem in the MESA software because the directory exists but the file is missing.\n";
    return 1;
  }

  $evalString = "$main::MESA_TARGET/bin/mpps_evaluate ";
  $evalString .= " -v " if ($verbose);
  $evalString .= " mgr $testNumber $storageDir/$mpps_UID/mpps.dcm $stdDir/mpps.status ";

  print main::LOG "$evalString \n";

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub update_scheduling_message {
  my $target = shift( @_);
  my $mppsMsg = shift (@_ );

  die "HL7 scheduling message $target does not exist" if (! -e $target);
  die "MPPS message $mppsMsg does not exist" if (! -e $mppsMsg);

  my $uid = `$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 00020 000D $mppsMsg`;
  chomp $uid;
  print "Study Instance UID: $uid \n";
  print `perl scripts/change_scheduling_uid.pl $target $uid`;

  # Change Accession Number (OBR-18)
  my $xxx = `$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 008 0050 $mppsMsg`;
  chomp $xxx;
  print "Accession Number: $xxx \n";
  print `perl scripts/change_hl7_field.pl $target OBR 18 $xxx -1`;

  # Change Requested Procedure ID (OBR-19)
  $xxx = `$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 1001 $mppsMsg`;
  chomp $xxx;
  print "Requested Procedure ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl $target OBR 19 $xxx -1`;

# Change Scheduled Procedure Step ID (OBR-20)
  $xxx = `$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $mppsMsg`;
  chomp $xxx;
  print "Scheduled Procedure Step ID: $xxx \n";
  print `perl scripts/change_hl7_field.pl $target OBR 20 $xxx 1`;
}

sub evaluate_cmove_key_object_note {
  my ($verbose, $patternFile, $requirements) = @_;

  $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0018 $patternFile";
  $sop_ins_uid = `$x`; chomp $sop_ins_uid;

  if (sop_ins_uid eq "") {
    print LOG "Failed to grab the SOP Instance UID from $patternFile \n";
    print LOG " This is a failure of the test software/installation \n";
    return 1;
  }

  print main::LOG "SOP Instance UID: $sop_ins_uid \n" if $verbose;

  @fileNames = lookup_filname_by_sopins_uid($verbose, $sop_ins_uid);

  $x = scalar(@fileNames);
  if ($x == 0) {
    print main::LOG "No SR objects were found with SOP Ins UID $sop_ins_uid \n";
    print main::LOG " That is a failure\n";
    return 1;
  }
  if ($x != 1) {
    print main::LOG "Found $x SR objects with SOP Ins UID $sop_ins_uid \n";
    print main::LOG " That indicates a failure of the MESA tools \n";
    return 1;
  }

  $f = $fileNames[0];

  print main::LOG "\nEvaluating $f\n";
  $x = "$main::MESA_TARGET/bin/mesa_sr_eval ";
  $x .= " -v " if $verbose;
  $x .= " -r $requirements ";
  $x .= " -p $patternFile $f";

  print main::LOG "$x \n";
  print main::LOG `$x`;
  if ($? != 0) {
    print LOG "SR object $f does not pass SR evaluation.\n";
    return 1;
  }

  return 0;
}

sub evaluate_cmove_gsps_object {
  my ($verbose, $patternFile, $maskFile) = @_;

  $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0018 $patternFile";
  $sop_ins_uid = `$x`; chomp $sop_ins_uid;

  if (sop_ins_uid eq "") {
    print LOG "Failed to grab the SOP Instance UID from $patternFile \n" ;
    print LOG " This is a failure of the test software/installation \n";
    return 1;
  }

  print main::LOG "SOP Instance UID: $sop_ins_uid \n" if $verbose;

  @fileNames = lookup_filname_by_sopins_uid($verbose, $sop_ins_uid);

  $x = scalar(@fileNames);
  if ($x == 0) {
    print main::LOG "No GSPS objects were found with SOP Ins UID $sop_ins_uid \n";
    print main::LOG " That is a failure\n";
    return 1;
  }
  if ($x != 1) {
    print main::LOG "Found $x GSPS objects with SOP Ins UID $sop_ins_uid \n";
    print main::LOG " That indicates a failure of the MESA tools \n";
    return 1;
  }

  $f = $fileNames[0];

  print main::LOG "\nEvaluating $f\n";
  $x = "$main::MESA_TARGET/bin/compare_dcm ";
  $x .= " -v " if $verbose;
  $x .= " -m $maskFile ";
  $x .= " $patternFile $f";

  print main::LOG "$x \n";
  print main::LOG `$x`;
  if ($? != 0) {
    print main::LOG "GSPS object $f does not pass evaluation.\n";
    return 1;
  }

  return 0;
}

sub lookup_filname_by_sopins_uid {
  my $verbose = shift(@_);
  my $uid = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c insuid $uid " .
        " filnam sopins wkstation tmp/filename.txt";

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

sub build_cfind {
  my $inputText = shift(@_);
  my $outputFile = shift(@_);

  my $cmd = "$main::MESA_TARGET/bin/dcm_create_object -i $inputText $outputFile";
  print "$cmd \n";
  print `$cmd`;
  die "Could not produce query from $inputText \n" if $?;
}

sub get_dicom_attribute {
 my $fileName = shift(@_);
 my $groupN = shift(@_);
 my $elementN = shift(@_);

 my $cmd = "$main::MESA_TARGET/bin/dcm_print_element $groupN $elementN $fileName";

 my $v = `$cmd`;

 chomp $v;

 return $v;
}

sub get_dicom_seq_attribute {
 my $fileName = shift(@_);
 my $seqGroupN = shift(@_);
 my $seqElementN = shift(@_);
 my $groupN = shift(@_);
 my $elementN = shift(@_);

 my $cmd = "$main::MESA_TARGET/bin/dcm_print_element -s $seqGroupN $seqElementN $groupN $elementN $fileName";

 my $v = `$cmd`;

 chomp $v;

 return $v;
}

sub getSOPUID {
  my $dicomObjectFile = shift(@_);

  if ($main::MESA_OS eq "WINDOWS_NT") {
    $dicomObjectFile =~ s(/)(\\)g;
  }
  $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0018 $dicomObjectFile";
  my $sopuid = `$x`;

  return $sopuid;
}

sub send_storage_commit_secure {
  my $procedureName = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);
  my $mesaModalityPort = shift(@_);
  my $commitUID = "1.2.840.10008.1.20.1.1";

# Security parameters

  my $randomsFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers = shift(@_);

  $naction = "$main::MESA_TARGET/bin/naction_secure " .
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers " .
	" -a MESA_MOD -c $imgMgrAE $imgMgrHost $imgMgrPort commit ";
  $nevent  = "$main::MESA_TARGET/bin/nevent  -a MESA localhost $mesaModalityPort commit ";

  print "$procedureName \n";

  $nactionExec = "$naction $main::MESA_STORAGE/modality/$procedureName/sc.xxx $commitUID ";

  print "$nactionExec \n";
  print `$nactionExec`;
  if ($?) {
    print "Could not send Storage Commitment N-Action to Image Mgr \n";
    exit 1;
  }

  $neventExec = "$nevent $main::MESA_STORAGE/modality/$procedureName/sc.xxx $commitUID ";
  print "$neventExec \n";
  print `$neventExec`;
  if ($?) {
    print "Could not send Storage Commitment N-Event to MESA modality\n";
    exit 1;
  }
}

sub send_cfind_secure {
  my $cfindFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);
  my $outDir = shift(@_);

  my $randomsFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers = shift(@_);

  if( $outDir) {
     $cfindString = "$main::MESA_TARGET/bin/cfind_secure -a MESA -c $imgMgrAE -f $cfindFile -o $outDir -x STUDY " .
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers " .
	" $imgMgrHost $imgMgrPort ";
  }
  else {
     $cfindString = "$main::MESA_TARGET/bin/cfind_secure -a MESA -c $imgMgrAE -f $cfindFile -x STUDY " .
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers " .
	" $imgMgrHost $imgMgrPort ";
  }

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
}

sub find_gpsps_with_matching_procedure {
  my $searchDir = shift(@_);
  my $attributeVal = shift(@_);

  $seqGroup = "0040"; $seqElement = "4018";
  $group = "0008"; $element = "0100";
  $tagName = "Scheduled Workitem Code Value";

  $val = find_dicom_file_with_matching_attribute(
             $searchDir, $attributeVal, $seqGroup, $seqElement,
             $group, $element, $tagName);

  return $val;
}

sub find_dicom_file_with_matching_attribute {
  my $searchDir = shift(@_);
  my $attributeVal = shift(@_);
  my $seqGroup = shift(@_);
  my $seqElement = shift(@_);
  my $group = shift(@_);
  my $element = shift(@_);
  my $tagName = shift(@_);

  print main::LOG
        "Searching for $tagName $attributeVal in dir: $searchDir\n";

  opendir DIR, $searchDir or die "directory: $searchDir not found!";
  @files = readdir DIR;
  closedir DIR;

  foreach $file (@files) {
    if ($file =~ /.dcm/) {

      $path = "$searchDir/$file";
      if( $main::MESA_OS eq "WINDOWS_NT") {
         $path =~ s(/)(\\)g;
      }

      $val = `$main::MESA_TARGET/bin/dcm_print_element -s $seqGroup $seqElement $group $element $path`;
      chomp $val;
      print main::LOG " $searchDir/$file $val \n";

      if ($val eq $attributeVal) {
        return $path;
      }
    }
  }

  return "";
}

sub evaluate_one_gpsps_resp {
  my $verbose   = shift(@_);
  my $testFile  = shift(@_);
  my $stdFile   = shift(@_);

  my $evalString = "$main::MESA_TARGET/bin/cfind_gpsps_evaluate ";
     $evalString .= " -v " if ($verbose);
     $evalString .= " $testFile $stdFile";

  print main::LOG "$evalString \n";
  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
	"MESA_OF_DICOM_PORT", "MESA_OF_HL7_PORT",
	"MESA_IMGMGR_DICOM_PT", "MESA_IMGMGR_HL7_PORT",
	"MESA_MODALITY_PORT",
	"TEST_MPPS_AE", "TEST_MPPS_HOST", "TEST_MPPS_PORT",
	"TEST_CSTORE_AE", "TEST_CSTORE_HOST", "TEST_CSTORE_PORT",
	"TEST_CFIND_AE", "TEST_CFIND_HOST", "TEST_CFIND_PORT",
	"TEST_COMMIT_AE", "TEST_COMMIT_HOST", "TEST_COMMIT_PORT",
	"TEST_HL7_HOST", "TEST_HL7_PORT",
  );

  foreach $n (@names) {
    my $v = $h{$n};
    if (! $v) {
      print "No value for $n \n";
      $rtnVal = 1;
    }
  }
  return $rtnVal;
}


1;
