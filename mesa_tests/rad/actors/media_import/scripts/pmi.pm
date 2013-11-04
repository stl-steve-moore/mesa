#!/usr/local/bin/perl -w

# Package for Portable Media Importer scripts.

use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

package pmi;
require Exporter;
#@ISA = qw(Exporter);
#@EXPORT = qw(
#);


# Send HL7 message to a server.  Arguments:
# 1 - Directory with messages
# 2 - Message to send
# 3 - Host name of target
# 4 - Port number of target

#sub send_hl7 {
#  my $hl7Dir = shift(@_);
#  my $msg = shift(@_);
#  my $target = shift(@_);
#  my $port   = shift(@_);
#
#  if (! -e ("$hl7Dir/$msg")) {
#    print "Message $hl7Dir/$msg does not exist; exiting. \n";
#    main::goodbye();
#  }
#
#  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe ";
#  print "$send_hl7 $target $port $hl7Dir/$msg \n";
#  print `$send_hl7 $target $port $hl7Dir/$msg`;
#
#  return 1 if $?;
#
#  return 0;
#}


#sub read_config_params {
#  my $f = shift(@_);
#  open (CONFIGFILE, $f) or die "Can't open $f.\n";
#  while ($line = <CONFIGFILE>) {
#    chomp($line);
#    next if $line =~ /^#/;
#    next unless $line =~ /\S/;
#    ($varname, $varvalue) = split(" = ", $line);
#    $varnames{$varname} = $varvalue;
#  }
#  my $opPort = $varnames{"MESA_ORD_PLC_PORT"};
#  my $imPortHL7 = $varnames{"MESA_IMG_MGR_PORT_HL7"};
#  my $imPortDICOM = $varnames{"MESA_IMG_MGR_PORT_DCM"};
##  my $ppwfPortDICOM = $varnames{"MESA_PPWF_MGR_PORT_DCM"};
#
#  my $ofPortHL7 = $varnames{"TEST_HL7_PORT"};
#  my $ofHostHL7 = $varnames{"TEST_HL7_HOST"};
#
#  my $mwlAE     = $varnames{"TEST_MWL_AE"};
#  my $mwlHost   = $varnames{"TEST_MWL_HOST"};
#  my $mwlPort   = $varnames{"TEST_MWL_PORT"};
#
#  my $mppsHost = $varnames{"TEST_MPPS_HOST"};
#  my $mppsPort = $varnames{"TEST_MPPS_PORT"};
#  my $mppsAE = $varnames{"TEST_MPPS_AE"};
#
##  my $ppwfHost = $varnames{"TEST_PPWF_HOST"};
##  my $ppwfPort = $varnames{"TEST_PPWF_PORT"};
##  my $ppwfAE = $varnames{"TEST_PPWF_AE"};
##
##  $logLevel = $varnames{"LOGLEVEL"};
#
#  return ($opPort, $ofPortHL7, $ofHostHL7,
#          $mwlAE, $mwlHost, $mwlPort,
#	  $mppsAE, $mppsHost, $mppsPort,
#          $imPortHL7, $imPortDICOM,
#	);
##	  $ppwfAE, $ppwfHost, $ppwfPort,
##	  $ppwfPortDICOM);
#}

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
	"MESA_IMG_MGR_PORT_HL7", "MESA_IMG_MGR_PORT_DCM",
	"MESA_PMI_PORT_HL7",
	"TEST_HL7_HOST", "TEST_HL7_PORT",
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

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

# Evaluate HL7 message against standard message
# Arguments:
#  1 - Directory with standard message
#  2 - Standard message
#  3 - Directory with message for evaluation
#  4 - Message to be evaluated
#  5 - File describes format of message for hl7_evaluate
#  6 - File describes fields to compare for compare_hl7

#sub evaluate_hl7 {
#  my $verbose = shift(@_);
#  my $stdDir  = shift(@_);
#  my $stdMsg  = shift(@_);
#  my $testDir = shift(@_);
#  my $testMsg = shift(@_);
#  my $formatFile = shift(@_);
#  my $iniFile = shift(@_);
#
#  my $rtnStatus = 0;
#
#  print main::LOG "$stdMsg $testMsg \n";
#
#  my $pathStd = "$stdDir/$stdMsg";
#  my $pathTest = "$testDir/$testMsg";
#
#  my $evaluateCmd = "$main::MESA_TARGET/bin/hl7_evaluate ";
#     $evaluateCmd .= " -v " if ($verbose);
#     $evaluateCmd .= "-b $main::MESA_TARGET/runtime -m $formatFile $pathTest";
#
#  print main::LOG "$evaluateCmd \n";
#  print main::LOG `$evaluateCmd`;
#  $rtnStatus = 1 if ($?);
#
#  my $compareCmd = "$main::MESA_TARGET/bin/compare_hl7 ";
#     $compareCmd .= " -v " if ($verbose);
#     $compareCmd .= "-b $main::MESA_TARGET/runtime -m $iniFile $pathStd $pathTest";
#
#  print main::LOG "$compareCmd \n";
#  print main::LOG `$compareCmd`;
#
#  $rtnStatus = 1 if ($?);
#
#  return $rtnStatus;
#}

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

sub evaluate_mpps {
  print main::LOG "pmi::evaluate_mpps is retired.  Error in the test script\n";
  print "pmi::evaluate_mpps is retired.  Error in the test script\n";
  exit 1;

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

  $evalString = "$main::MESA_TARGET/bin/mpps_evaluate -v mgr $testNumber " .
	"$storageDir/$mpps_UID/mpps.dcm $stdDir/mpps.status ";

  print main::LOG "$evalString \n";

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub evaluate_mpps_v2 {
  my $verbose     = shift(@_);
  my $stdDir      = shift(@_);
  my $storageDir  = shift(@_);
  my $testNumber  = shift(@_);

  if (! -e($storageDir)) {
    print main::LOG "MESA Image Mgr storage directory does not exist \n";
    print main::LOG " Directory is expected to be: $storageDir \n";
    print main::LOG " Did you invoke the evaluation script with the proper AE title? \n";
    return 1;
  }

  open(MPPS_HANDLE, "< $stdDir/mpps_uid.txt") ||
	die "Could not open MPPS UID File: $stdDir/mpps_uid.txt";

  $mpps_UID = <MPPS_HANDLE>;
  chomp $mpps_UID;
  print main::LOG "MPPS UID = $mpps_UID \n" if $verbose;

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
  $evalString .= " -v " if $verbose;
  $evalString .= " mgr $testNumber " .
	" $storageDir/$mpps_UID/mpps.dcm $stdDir/mpps.status ";

  print main::LOG "$evalString \n";

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub evaluate_image_avail {
  my $queryDir  = shift(@_);

  $evalString = "$main::MESA_TARGET/bin/cfind_evaluate -v IMG_AVAIL $queryDir";

  print main::LOG "$evalString \n";

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub send_image_avail {
  my $mppsFile = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  $cfindString = "$main::MESA_TARGET/bin/cfind_image_avail $imgMgrHost $imgMgrPort $mppsFile";

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
}

sub send_mwl {
  my $queryTextFile = shift(@_);
  my $queryResultsDir = shift(@_);
  my $mwlAE = shift(@_);
  my $mwlHost = shift(@_);
  my $mwlPort = shift(@_);

  if ($main::MESA_OS eq "WINDOWS_NT") {
    `$main::MESA_TARGET/bin/dcm_create_object -i mwl\\$queryTextFile.txt mwl\\$queryTextFile.dcm`;
    delete_directory($main::MESA_OS, "mwl\\$queryResultsDir");
    create_directory("mwl\\$queryResultsDir");
  } else {
    `$main::MESA_TARGET/bin/dcm_create_object -i mwl/$queryTextFile.txt mwl/$queryTextFile.dcm`;
    delete_directory($main::MESA_OS, "mwl/$queryResultsDir");
    create_directory("mwl/$queryResultsDir");
  }
  $cfindString = "$main::MESA_TARGET/bin/cfind -f mwl/$queryTextFile.dcm -x MWL -o mwl/$queryResultsDir -c $mwlAE $mwlHost $mwlPort";

  print "$cfindString \n";
  print `$cfindString `;

  return 0;
}

sub mwl_find_matching_procedure_code {
  my $queryResultsDir = shift(@_);
  my $procedureCode = shift(@_);
#  my $dirName = "";

  print main::LOG
	"CTX: Searching for procedure code $procedureCode in MWL dir: $queryResultsDir\n";

  opendir MWL, $queryResultsDir or die "directory: $queryResultsDir not found!";
  @mwlMsgs = readdir MWL;
  closedir MWL;

  foreach $mwlFile (@mwlMsgs) {
    if ($mwlFile =~ /.MWL/ || $mwlFile =~ /.dcm/ ) {

      $mwlProcedureCode = `$main::MESA_TARGET/bin/dcm_print_element -s 0032 1064 0008 0100 $queryResultsDir/$mwlFile`;
      chomp $mwlProcedureCode;
      print main::LOG "CTX:  $queryResultsDir/$mwlFile $mwlProcedureCode \n";

      if ($mwlProcedureCode eq $procedureCode) {
	return $mwlFile;
      }
    }
  }

  return "";
}

sub mwl_search_by_procedure_code {
  my ($logLevel, $queryResultsDir, $procedureCode) = @_;

  print main::LOG
	"CTX: Searching for procedure code $procedureCode in MWL dir: $queryResultsDir\n"
	if ($logLevel >= 3);

  if (!opendir MWL, $queryResultsDir) {
    print main::LOG "ERR: directory: $queryResultsDir not found\n";
    return "";
  };

  @mwlMsgs = readdir MWL;
  closedir MWL;

  foreach $mwlFile (@mwlMsgs) {
    if ($mwlFile =~ /.dcm/) {

      $mwlProcedureCode = `$main::MESA_TARGET/bin/dcm_print_element -s 0032 1064 0008 0100 $queryResultsDir/$mwlFile`;
      chomp $mwlProcedureCode;
      print main::LOG "CTX:  $queryResultsDir/$mwlFile $mwlProcedureCode \n" if ($logLevel >= 3);

      if ($mwlProcedureCode eq $procedureCode) {
	return $queryResultsDir . "/" . $mwlFile;
      }
    }
  }

  return "";
}

sub mwl_search_by_procedure_code_aetitle {
  my ($logLevel, $queryResultsDir, $procedureCode, $scheduledAET) = @_;

  print main::LOG
	"CTX: Searching for procedure code $procedureCode, AE Title $scheduledAET in MWL dir: $queryResultsDir\n"
	if ($logLevel >= 3);

  if (!opendir MWL, $queryResultsDir) {
    print main::LOG "ERR: directory: $queryResultsDir not found\n";
    return "";
  };

  @mwlMsgs = readdir MWL;
  closedir MWL;

  my @listOfFiles;
  $idx = 0;
  foreach $mwlFile (@mwlMsgs) {
    if ($mwlFile =~ /.dcm/) {

      $mwlProcedureCode = `$main::MESA_TARGET/bin/dcm_print_element -s 0032 1064 0008 0100 $queryResultsDir/$mwlFile`;
      chomp $mwlProcedureCode;
      $mwlScheduledAETitle = `$main::MESA_TARGET/bin/dcm_print_element -s 0040 0100 0040 0001 $queryResultsDir/$mwlFile`;
      chomp $mwlScheduledAETitle;
      print main::LOG "CTX:  $queryResultsDir/$mwlFile $mwlProcedureCode \n" if ($logLevel >= 3);
      print main::LOG "CTX:  $queryResultsDir/$mwlFile $mwlScheduledAETitle\n" if ($logLevel >= 3);

      if ($mwlProcedureCode eq $procedureCode && $mwlScheduledAETitle eq $scheduledAET) {
	$listOfFiles[$idx] = $queryResultsDir . "/" . $mwlFile;
	$idx++;
      }
    }
  }

  return @listOfFiles;
}

sub mwl_search_by_procedure_code_only {
  my ($logLevel, $queryResultsDir, $procedureCode) = @_;

  print main::LOG
	"CTX: Searching for procedure code $procedureCode, in MWL dir: $queryResultsDir\n"
	if ($logLevel >= 3);

  if (!opendir MWL, $queryResultsDir) {
    print main::LOG "ERR: directory: $queryResultsDir not found\n";
    return "";
  };

  @mwlMsgs = readdir MWL;
  closedir MWL;

  my @listOfFiles;
  $idx = 0;
  foreach $mwlFile (@mwlMsgs) {
    if ($mwlFile =~ /.dcm/) {

      $mwlProcedureCode = `$main::MESA_TARGET/bin/dcm_print_element -s 0032 1064 0008 0100 $queryResultsDir/$mwlFile`;
      chomp $mwlProcedureCode;
      print main::LOG "CTX:  $queryResultsDir/$mwlFile $mwlProcedureCode \n" if ($logLevel >= 3);

      if ($mwlProcedureCode eq $procedureCode) {
	$listOfFiles[$idx] = $queryResultsDir . "/" . $mwlFile;
	$idx++;
      }
    }
  }

  return @listOfFiles;
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
	"CTX: Searching for $tagName $attributeVal in dir: $searchDir\n";

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
      print main::LOG "CTX:  $searchDir/$file $val \n";

      if ($val eq $attributeVal) {
	return $path;
      }
    }
  }

  return "";
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

sub evaluate_mwl_resp {
  my $verbose   = shift(@_);
  my $seqGroup  = shift(@_);
  my $seqElement = shift(@_);
  my $group     = shift(@_);
  my $element   = shift(@_);

  my $maskFile = shift(@_);
  my $tstDir   = shift(@_);
  my $stdDir   = shift(@_);

  if (! -e($tstDir)) {
    print main::LOG "Evaluation of C-Find responses failed.\n";
    print main::LOG "Directory with test messages: $tstDir does not exist.\n";
    return 1;
  }
  if (! -e($tstDir)) {
    print main::LOG "Evaluation of C-Find responses failed.\n";
    print main::LOG "Directory with standard messages: $sdtDir does not exist.\n
";
    return 1;
  }
  $evalString = "$main::MESA_TARGET/bin/cfind_resp_evaluate ";
  $evalString .= " -v " if ($verbose);
  $evalString .= " -s $seqGroup $seqElement " if ($seqGroup ne "0000");
  $evalString .= "$group $element $maskFile $tstDir $stdDir";

  print main::LOG "$evalString \n";

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub evaluate_one_mwl_resp {
  my $verbose   = shift(@_);
  my $testFile  = shift(@_);
  my $stdFile   = shift(@_);

  my $evalString = "$main::MESA_TARGET/bin/cfind_mwl_evaluate ";
     $evalString .= " -v " if ($verbose);
     $evalString .= " $testFile $stdFile";

  print main::LOG "$evalString \n";
  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub evaluate_mwl_suid {
  my ($logLevel, $testFile) = @_;

  my $x = "$main::MESA_TARGET/bin/dcm_print_element 0020 000D $testFile";
  print main::LOG "CTX: $x \n" if ($logLevel >= 3);
  my $suid = `$x`;
  return 1 if ($?);
  chomp $suid;

  my $y = "$main::MESA_TARGET/bin/dcm_print_element -s 0008 1110 0008 1155 $testFile";
  print main::LOG "CTX: $x \n" if ($logLevel >= 3);
  my $refSUID = `$y`;
  return 1 if ($?);
  chomp $refSUID;

  if ($suid ne $refSUID) {
    print main::LOG "ERR: In MWL response, the value for Study Instance UID (0020 000D) ($suid) \n";
    print main::LOG "ERR:  differs from Ref Study Seq (0008 1110 0008 1155) ($refSUID) \n";
    print main::LOG "REF: See TF Vol II, Appendix A, Table A-1, Note IHE-23 \n" if ($logLevel >= 4);
    return 1;
  }

  print main::LOG "CTX: Study Instance UID value matchs Ref Study Seq: $suid\n" if ($logLevel >= 3);

  return 0;
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

sub local_scheduling_mg {
  print `perl scripts/schedule_mg.pl`;
}


sub local_scheduling_hd {
  my ($logLevel, $spsLocation, $scheduledAET) = @_;
  print "About to invoke HD scheduling script\n" if ($logLevel >= 3);
  print `perl ../../../rad/actors/ordfil/scripts/schedule_hd.pl $logLevel $spsLocation $scheduledAET`;
}

#sub local_scheduling_ivus_mpps_trigger {
#  my ($logLevel, $spsLocation, $scheduledAET, $SPSCode, $SPSIndex ) = @_;
#  print "About to invoke IVUS scheduling script\n" if ($logLevel >= 3);
#  my $x = "perl ../../../rad/actors/ordfil/scripts/schedule_ivus_mpps_trigger.pl $logLevel $spsLocation $scheduledAET $SPSIndex $SPSCode";
#  print "$x\n" if ($logLevel >= 3);
#  print `$x`;
#  return 1 if ($?);
#  return 0;
#}

sub local_scheduling_mr {
  my ($logLevel, $spsLocation, $scheduledAET) = @_;
  print "Log level $logLevel\n";
  print "sps location $spsLocation\n";
  print "ae Title: $scheduledAET\n";
  die "xx";
  print "About to invoke MR scheduling script\n" if ($logLevel >= 3);
  print `perl ../../../rad/actors/ordfil/scripts/schedule_mr.pl $logLevel $spsLocation $scheduledAET`;
}

sub local_scheduling_rt {
  print `perl ../../../rad/actors/ordfil/scripts/schedule_rt.pl`;
}

#sub local_scheduling_xa_mpps_trigger {
#  my ($logLevel, $spsLocation, $scheduledAET, $SPSCode, $SPSIndex ) = @_;
#  print "About to invoke XA scheduling script\n" if ($logLevel >= 3);
#  my $x = "perl ../../../rad/actors/ordfil/scripts/schedule_xa_mpps_trigger.pl $logLevel $spsLocation $scheduledAET $SPSIndex $SPSCode";
#  print "$x\n" if ($logLevel >= 3);
#  print `$x`;
#  return 1 if ($?);
#  return 0;
#}

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

  $x = "$main::MESA_TARGET/bin/ncreate -a MESA_MODALITY -c $destAE " .
	" $destHost $destPort " .
	" mpps $directoryName/mpps.crt $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Create \n" if ($?);

  $x = "$main::MESA_TARGET/bin/nset    -a MESA_MODALITY -c $destAE " .
	" $destHost $destPort " .
	" mpps $directoryName/mpps.set $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Set \n" if ($?);
}

sub update_filler_order
{
  my $directoryName   = shift(@_);
  my $hl7ORM          = shift(@_);
  my $fillerOrdNumber = shift(@_);

  my $fileName = $directoryName . "/" . $hl7ORM;
  my $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $fileName " .
	"ORC 3 0 $fillerOrdNumber ";

  print "$x\n";
  print `$x`;

  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $fileName " .
	"OBR 3 0 $fillerOrdNumber ";

  print "$x\n";
  print `$x`;
}

sub update_accession_number 
{
  my ($logLevel, $hl7ORM, $accessionNumber) = @_;

  my $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM " .
	"OBR 18 0 $accessionNumber";

  print "$x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update accession number\n" if ($?);

  return 0;
}

sub announce_a01 {
  my $patientName = shift(@_);
  print "\n" .
"The ADT system will send an A01 to admit $patientName \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_a03 {
  my $patientName = shift(@_);
  print "\n" .
"The ADT system will send an A03 to discharge $patientName \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_a04 {
  my $patientName = shift(@_);
  print "\n" .
"The ADT system will send an A04 to register $patientName \n" .
" as an outpatient.\n\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_a05 {
  my $patientName = shift(@_);
  print "\n" .
"The ADT system will send an A05 to preregister $patientName \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_p01 {
  my $patientName = shift(@_);
  print "\n" .
"The ADT system will send an P01 to create an account for $patientName \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_order_orm {
  my $codeValue = shift(@_);
  print "\n";
  print "The MESA Order Placer will send you an ORM^O01 to request $codeValue.\n";
  print " Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}


sub announce_CFIND {
  my $procedureCode = shift(@_);
  print "\n" .
"The MESA Modality will send a C-Find to query for its worklist.\n" .
" The current (requested) procedure is: $procedureCode \n" .
" This will also lead to image production, so this step may take some time.\n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_PPS {
  my $stepName= shift(@_);
  my $mppsHost = shift(@_);
  my $mppsPort = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  print "\n" .
"The MESA Modality will send MPPS messages to you at $mppsHost:$mppsPort.\n" .
" You are expected to forward these to the MESA Image Mgr $imgMgrHost:$imgMgrPort\n" .
" The procedure (shorthand) name is $stepName \n" .

" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);

}

sub announce_CSTORE {
  my $procedureName = shift(@_);

  print "\n" .
"Starting to send Images for $procedureName to Image Manager. \n";
}

sub announce_CSTORE_complete {
  my $procedureName = shift(@_);

  print "\n" .
"Images for $procedureName have been sent to the MESA Image Image Manager.\n" .
" Maybe you want to send another Image Availability C-Find request.\n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gpsps_CFIND {
  my $procedureName = shift(@_);

  print "\n" .
"The MESA CAD station will send a C-Find to query for its worklist.\n" .
" The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gpsps_claim {
  my $procedureName = shift(@_);

  print "\n" .
"The MESA CAD station will send a GPSPS NACTION to claim the scheduled procedure step.\n" .
" The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gppps_create {
#  my $procedureName = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  print "\n" .
"The MESA CAD station will send a GPPPS NCREATE to create the performed \n" .
"procedure step in progress. You should relay this information to the \n" .
"MESA Image Manager at $imgMgrHost:$imgMgrPort\n" .
# " The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gppps_completed {
#  my $procedureName = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  print "\n" .
"The MESA CAD station will send a GPPPS NSET to mark the performed \n" .
"procedure step complete.  You should relay this information to the\n" .
"MESA Image Manager at $imgMgrHost:$imgMgrPort\n" .
# " The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_gpsps_completed {
  my $procedureName = shift(@_);

  print "\n" .
"The MESA CAD station will send a GPSPS NACTION to mark the scheduled procedure step complete.\n" .
# " The current procedure is: $procedureName \n" .
" Press <enter> when ready to continue or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub request_procedure {
  my $headerMessage = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  print "\n";
  print "$headerMessage \n";
  print " Your scheduling message goes to the MESA Image Manager at $imgMgrHost: $imgMgrPort \n";
  print " Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
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

sub create_send_audit {
  my $hostName = shift(@_);
  my $port = shift(@_);
  my $fileSpec = shift(@_);
  my $msgType = shift(@_);

  my $x = "$main::MESA_TARGET/bin/ihe_audit_message -t $msgType $fileSpec.txt $fileSpec.xml ";
  print "$x \n";
  print `$x`;
  if ($?) {
    print "Unable to generate audit message: msgType $fileSpec \n";
    exit(1);
  }
  my $y = "$main::MESA_TARGET/bin/syslog_client -f 10 -s 0 $hostName $port $fileSpec.xml";
  print "$y \n";
  print `$y`;
  if ($?) {
    print "Unable to transmit audit message: $fileSpec \n";
    exit(1);
  }
  print "\n";
}

sub clear_syslog_files {
  my $osName = $main::MESA_OS;

  my $dirName = "$main::MESA_TARGET/logs/syslog";
  if (! (-d $dirName)) {
    return;
  }

  if ($osName eq "WINDOWS_NT") {
    $dirName =~ s(/)(\\)g;
    `delete/q $dirName\\*.xml`;
  } else {
    `rm -f $dirName/*.xml`;
  }
}

sub extract_syslog_messages() {
 $x = "$main::MESA_TARGET/bin/syslog_extract";
 print "$x \n";
 `$x`;
 if ($?) {
  die "Could not extract syslog messages from database";
 }
}

sub count_syslog_xml_files {
 my $dirName = "$main::MESA_TARGET/logs/syslog";
 opendir SYSLOGDIR, $dirName or die "Could not open directory: $dirName \n";
 @xmlFiles = readdir SYSLOGDIR;
 closedir SYSLOGDIR;

 my $count = 0;
 foreach $f (@xmlFiles) {
  if ($f =~ /.xml/) {
   $count += 1;
  }
 }
 return $count;
}

sub evaluate_all_xml_files {
 my $level = 1;

 my $dirName = "$main::MESA_TARGET/logs/syslog";
 opendir SYSLOGDIR, $dirName or die "Could not open directory: $dirName \n";
 @xmlFiles = readdir SYSLOGDIR;
 closedir SYSLOGDIR;

 my $x = "$main::MESA_TARGET/bin/mesa_xml_eval -l $level ";
 my $rtnValue = 0;
 foreach $f (@xmlFiles) {
  if ($f =~ /.xml/) {
   print main::LOG "\nEvaluating $f\n";
   my $cmd = $x . " $dirName/$f";
   print main::LOG "$cmd \n";
   print main::LOG `$cmd`;
   $rtnValue = 1 if $?;
  }
 }
 return $rtnValue;
}

sub update_object {
 my $inFile = shift(@_);
 my $deltaFile = shift(@_);

 my $outFile = $inFile . ".xxx";

 my $x = "$main::MESA_TARGET/bin/dcm_modify_object -i $deltaFile $inFile $outFile";
 print "$x \n";
 print `$x`;

 die "Could not modify object $inFile" if $?;

 my $osName = $main::MESA_OS;
 if ($osName eq "WINDOWS_NT") {
  $inFile =~ s(/)(\\)g;
  $outFile =~ s(/)(\\)g;
  `copy $outFile $inFile`;
 } else {
  `mv $outFile $inFile`;
 }
}

sub request_dft {
  my $patientName = shift(@_);
  my $chargeType  = shift(@_);
  my $transactionCode = shift(@_);

  print "\n" .
"You should now send a DFT message with charge information to \n" .
" the MESA Charge Processor listening on port 2150.\n" .
" The patient is:          $patientName \n" .
" The charge type is:      $chargeType \n" .
" The transaction code is: $transactionCode \n" .
" Other expected values for the DFT can be found using the \n" .
" web documentation. \n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

1;
