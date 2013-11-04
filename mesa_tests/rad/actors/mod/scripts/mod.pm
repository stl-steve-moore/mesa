#!/usr/local/bin/perl -w

# Package for Modality scripts.

use Env;

package mod;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(make_dcm_object);

#@EXPORT = qw(send_hl7
#);

use lib "../common/scripts";
require mesa;
require evaluate;

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

  if (! -e "$hl7Dir/$msg") {
    print "HL7 message $hl7Dir/$msg does not exist \n";
    exit 1;
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe ";
  print "$send_hl7 $target $port $hl7Dir/$msg \n";
  print `$send_hl7 $target $port $hl7Dir/$msg`;

  return 1 if $?;

  return 0;
}

sub get_config_params {
  my $f = shift(@_);
  open (CONFIGFILE, $f ) or die "Can't open $f .\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);

# varname cannot be longer than 20 characters (C Shell limit on variable names)
#    (length($varname) <= 20) or die "Variable $varname is longer than 20 characters. In $f line $..\n";

    $varnames{$varname} = $varvalue;
  }

  return %varnames;
}
sub read_config_params {
  %varnames = get_config_params(@_);

  my $modality = $varnames{"MODALITY"};
  my $modalityHost = $varnames{"TEST_MODALITY_HOST"};
  my $modalityPort = $varnames{"TEST_MODALITY_PORT"};
  my $modalityAE = $varnames{"TEST_MODALITY_AE"};
  my $modalityStationName = $varnames{"TEST_MODALITY_STATION"};

  return ($modality,
          $modalityAE, $modalityHost, $modalityPort,
	  $modalityStationName);
}

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}


sub schedule_MR {
  print `main::$MESA_BIN/bin/of_schedule -t MODALITY1 -m MR -s STATION1 ordfil`;
}

sub delete_file {
  my $osName = $main::MESA_OS;
  my $fileName = shift(@_);

  if (! (-e $fileName)) {
    return;
  }

  if ($osName eq "WINDOWS_NT") {
    $fileName =~ s(/)(\\)g;
    `del $fileName`;
  } else {
    `rm -f $fileName`;
  } 
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

#sub send_images {
#  my $cstore = "$main::MESA_TARGET/bin/send_image -q -r -a MODALITY1 "
#      . " -c MESA ";
#  $cstore .= " localhost $main::imPortDICOM";
#
#  foreach $procedure(@_) {
#    print "$procedure \n";
#
#    my $imageDir = "$main::MESA_STORAGE/modality/$procedure";
#    opendir IMAGE, $imageDir or die "directory: $imageDir not found!";
#    @imageMsgs = readdir IMAGE;
#    closedir IMAGE;
#
#    foreach $imageFile (@imageMsgs) {
#      if ($imageFile =~ /.dcm/) {
#	my $cstoreExec = "$cstore $main::MESA_STORAGE/modality/$procedure/$imageFile";
#	print "$cstoreExec \n";
#	print `$cstoreExec`;
#	if ($? != 0) {
#	  print "Could not send image $imageFile to MESA Image Manager\n";
#	  exit 1;
#	}
#      }
#    }
#  }
#}

sub cstore {
  my $fileName = shift(@_);
  my $deltaFile = shift(@_);
  my $mgrAE = shift(@_);
  my $mgrHost = shift(@_);
  my $mgrPort = shift(@_);

  my $cstore = "$main::MESA_TARGET/bin/cstore -a MESA "
      . " -c $mgrAE ";
  $cstore .= " -d $deltaFile " if ($deltaFile ne "");
  $cstore .= " $mgrHost $mgrPort";

  print "$fileName \n";

  if (! -e $fileName) {
    print "File/directory $fileName does not exist.\n";
    exit 1;
  }
  my $cstoreExec = "$cstore $fileName";
  print "$cstoreExec \n";
  print `$cstoreExec`;
  if ($?) {
    print "Could not send $fileName to storage manager \n";
    print " Params: $mgrAE:$mgrHost:$mgrPort \n";
    exit 1;
  }
}

sub store_images {
  my $directoryName   = shift(@_);
  my $deltafile       = shift(@_);
  my $sourceAE        = shift(@_);
  my $destinationAE   = shift(@_);
  my $destinationHost = shift(@_);
  my $destinationPort = shift(@_);

  $cmd = "$main::MESA_TARGET/bin/cstore";

  $cmd .= " -q  ";
  $cmd .= " -a $sourceAE";
  $cmd .= " -c $destinationAE";
  if( $deltafile) { $cmd .= " -d $deltafile"}
  $cmd .= " $destinationHost $destinationPort";

  $imageDir = "$main::MESA_STORAGE/modality/$directoryName/";

  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(/)(\\)g;
    $imageDir =~ s(/)(\\)g;
  }

  opendir IMAGE, $imageDir or die "directory: $imageDir not found!";
  @imageMsgs = readdir IMAGE;
  closedir IMAGE;

  foreach $imageFile (@imageMsgs) {
    if ($imageFile =~ /.dcm/) {
      my $cstoreExec = "$cmd $imageDir$imageFile";
      print "$cstoreExec \n";
      print `$cstoreExec`;
      if ($? != 0) {
        print "Could not send image $imageFile to Image Manager: $destinationAE\n";
        main::goodbye();
      }
    }
  }
}


#sub evaluate_mpps {
#  my $stdDir  = shift(@_);
#  my $storageDir  = shift(@_);
#  my $mpps_UID = shift(@_);
#  my $testNumber = shift(@_);
#
#  if (! -e($storageDir)) {
#    print main::LOG "MESA Image Mgr storage directory does not exist \n";
#    print main::LOG " Directory is expected to be: $storageDir \n";
#    print main::LOG " Did you invoke the evaluation script with the proper AE title? \n";
#    return 1;
#  }
#
#  if (! -e("$storageDir/$mpps_UID")) {
#    print main::LOG "MESA Image Mgr MPPS directory does not exist \n";
#    print main::LOG " Directory is expected to be: $storageDir/$mpps_UID \n";
#    print main::LOG " This implies you did not forward MPPS messages for these MPPS events.\n";
#    return 1;
#  }
#
#  if (! -e("$storageDir/$mpps_UID/mpps.dcm")) {
#    print main::LOG "MPPS status file does not exist \n";
#    print main::LOG " File is expected to be: $storageDir/$mpps_UID/mpps.dcm \n";
#    print main::LOG " This implies a problem in the MESA software because the directory exists but the file is missing.\n";
#    return 1;
#  }
#
#  $evalString = "$main::MESA_TARGET/bin/mpps_evaluate -v mgr $testNumber " .
#	"$storageDir/$mpps_UID/mpps.dcm $stdDir/mpps.status ";
#
#  print main::LOG "$evalString \n";
#
#  print main::LOG `$evalString`;
#
#  return 1 if ($?);
#
#  return 0;
#}

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
	"Searching for procedure code $procedureCode in MWL dir: $queryResultsDir\n";

#  if ($main::MESA_OS eq "WINDOWS_NT") {
#    $dirName = "mwl\\$queryResultsDir";
#  } else {
#    $dirName = "mwl/$queryResultsDir";
#  }

  opendir MWL, $queryResultsDir or die "directory: $queryResultsDir not found!";
  @mwlMsgs = readdir MWL;
  closedir MWL;

  foreach $mwlFile (@mwlMsgs) {
    if ($mwlFile =~ /.MWL/) {

      $mwlProcedureCode = `$main::MESA_TARGET/bin/dcm_print_element -s 0032 1064 0008 0100 $queryResultsDir/$mwlFile`;
      chomp $mwlProcedureCode;
      print main::LOG " $queryResultsDir/$mwlFile $mwlProcedureCode \n";

      if ($mwlProcedureCode eq $procedureCode) {
	return $mwlFile;
      }
    }
  }

  return "";
}

sub universal_service_id {
  my $dirName  = shift(@_);
  my $msgName  = shift(@_);

  my $pathMsg = "$dirName/$msgName";

  $x = "$main::MESA_TARGET/bin/hl7_get_value -f $pathMsg OBR 4 0";

  $y = `$x`;

  return $y;
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

sub lookup_all_study_uids 
{
  my $logLevel = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column " .
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

sub lookup_all_images
{
  my ($logLevel) = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column " .
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

sub eval_image_unscheduled
{
  my $level      = shift(@_);
  my $verbose    = shift(@_);
  my $masterFile = shift(@_);
  my $testFile   = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "ERR In comparing images, the master file $masterFile is missing\n";
    print main::LOG "ERR  This probably means you forgot to run the setup step.\n";
    return 1;
  }
  if (! (-e $testFile) ) {
    print main::LOG "ERR In comparing images, the test file $testFile is missing\n";
    print main::LOG "ERR  This means the MESA database is inconsistent with files\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/mesa_composite_eval -l $level -p $masterFile " .
	" $testFile";

#  $x = "$main::MESA_TARGET/bin/compare_dcm -m ini/compare_store_uns.ini ";
#  $x .= " -o " if $verbose;
#  $x .= " $masterFile $testFile";

  print main::LOG "$x\n" if $verbose;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "ERR Attribute comparison failed for unscheduled case \n";
    print main::LOG "ERR  File name is $testFile\n";
    return 1;
  }
  return 0;
}

sub eval_image_scheduled
{
  my $level      = shift(@_);
  my $verbose    = shift(@_);
  my $masterFile = shift(@_);
  my $testFile   = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "ERR In comparing images, the master file $masterFile is missing\n";
    print main::LOG "ERR  This probably means you forgot to run the setup step.\n";
    return 1;
  }
  if (! (-e $testFile) ) {
    print main::LOG "ERR In comparing images, the test file $testFile is missing\n";
    print main::LOG "ERR  This means the MESA database is inconsistent with files\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/dcm_print_element 0020 000D $masterFile";
  print main::LOG "CTX $x \n" if $verbose;
  $uid = `$x`;
  print main::LOG "CTX Study Instance UID master file: $uid\n" if $verbose;
  
  $x = "$main::MESA_TARGET/bin/dcm_print_element 0020 000D $testFile";
  print main::LOG "CTX $x \n" if $verbose;
  $uid = `$x`;
  print main::LOG "CTX Study Instance UID test file:   $uid\n" if $verbose;

  $x = "$main::MESA_TARGET/bin/mesa_composite_eval -l $level -o mwl -p $masterFile ";
  $x .= " -v " if $verbose;
  $x .= " $testFile";

  print main::LOG "CTX $x\n";
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "ERR Attribute comparison failed for scheduled case \n";
    print main::LOG "ERR  File name is $testFile \n";
    return 1;
  }
  return 0;
}

sub eval_image_scheduled_group_case
{
  my $level      = shift(@_);
  my $verbose    = shift(@_);
  my $masterFile = shift(@_);
  my $testFile   = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "ERR In comparing images, the master file $masterFile is missing\n";
    print main::LOG "ERR  This probably means you forgot to run the setup step.\n";
    return 1;
  }
  if (! (-e $testFile) ) {
    print main::LOG "ERR In comparing images, the test file $testFile is missing\n";
    print main::LOG "ERR  This means the MESA database is inconsistent with files\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/dcm_print_element 0020 000D $masterFile";
  print main::LOG "CTX $x \n" if $verbose;
  $uid = `$x`;
  print main::LOG "CTX Study Instance UID master file: $uid\n" if $verbose;
  
  $x = "$main::MESA_TARGET/bin/dcm_print_element 0020 000D $testFile";
  print main::LOG "CTX $x \n" if $verbose;
  $uid = `$x`;
  print main::LOG "CTX Study Instance UID test file:   $uid\n" if $verbose;

  $x = "$main::MESA_TARGET/bin/mesa_composite_eval -o nouid -o mwl -p $masterFile ";
  $x .= " -v " if $verbose;
  $x .= " $testFile";

  print main::LOG "CTX $x\n";
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "ERR Attribute comparison failed for scheduled case \n";
    print main::LOG "ERR  File name is $testFile \n";
    return 1;
  }
  return 0;
}

sub eval_mpps_unscheduled
{
  my $level   = shift(@_);
  my $verbose = shift(@_);
  my $aet = shift(@_);
  my $masterFile = shift(@_);
  my $testFile = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "ERR In comparing MPPS, the master file $masterFile is missing\n";
    print main::LOG "ERR  This probably means you forgot to run the setup step.\n";
    return 1;
  }

  if (! (-e $testFile) ) {
    print main::LOG "ERR In comparing MPPS, we are missing the MPPS status:\n" .
	"  $testFile\n";
    print main::LOG "ERR  You either gave us the wrong AE title or we are missing the MPPS events.\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/compare_dcm -m ini/compare_mpps_uns.ini ";
  $x .= " -o " if $verbose;
  $x .= " $masterFile $testFile";

  print main::LOG "CTX $x\n" if $verbose;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "ERR MPPS comparison failed for unscheduled case \n";
    print main::LOG "ERR  File name is $testFile \n";
    return 1;
  }
  return 0;
}

sub eval_mpps_scheduled
{
  my $level = shift(@_);
  my $verbose = shift(@_);
  my $aet = shift(@_);
  my $masterFile = shift(@_);
  my $testFile = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "In comparing MPPS, the master file $masterFile is missing\n";
    print main::LOG " This probably means you forgot to run the setup step.\n";
    return 1;
  }

  if (! (-e $testFile) ) {
    print main::LOG "In comparing MPPS, we are missing the MPPS status:\n" .
	"  $testFile\n";
    print main::LOG " You either gave us the wrong AE title or we are missing the MPPS events.\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/mpps_evaluate -l $level ";
  $x .= " mod 1 $testFile $masterFile ";

  print main::LOG "$x\n" if $verbose;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "MPPS comparison failed for scheduled case \n";
    print main::LOG " File name is $testFile \n";
    return 1;
  }
  return 0;
}

sub evaluate_billing_procedure_step_sequence {
  my ($level, $masterFile, $testFile) = @_;
  my $rtnValue = 0;

  @tags = (
	"0008 0100",	# Code Value
	"0008 0102",	# Coding Scheme Designator
	"0008 0104"	# Code Meaning
  );

  foreach $tag(@tags) {
    $x = mesa::compareSequenceAttribute(
	$level,
	"0040 0320", $tag,
	$masterFile,
	$testFile);
    $rtnValue = 1 if ($x != 0);
  }
  return $rtnValue;
}

sub evaluate_film_consumption_sequence {
  my ($level, $masterFile, $testFile) = @_;
  my $rtnValue = 0;

  @tags = (
	"2100 0170",	# Number of films actually printed
	"2000 0030",	# Medium Type
	"2010 0050"	# Film Size ID
  );

  foreach $tag(@tags) {
    $x = mesa::compareSequenceAttribute(
	$level,
	"0040 0321", $tag,
	$masterFile,
	$testFile);
    $rtnValue = 1 if ($x != 0);
  }
  return $rtnValue;
}

sub evaluate_billing_supplies_and_devices_sequence {
  my ($level, $masterFile, $testFile) = @_;
  my $rtnValue = 0;

  @tags = (
	"0008 0100",	# Code Value
	"0008 0102",	# Coding Scheme Designator
	"0008 0104"	# Code Meaning
  );

  foreach $tag(@tags) {
    $x = mesa::compareSequenceAttributeLevel2(
	$level,
	"0040 0324", "0040 0296", $tag,
	$masterFile,
	$testFile);
    $rtnValue = 1 if ($x != 0);
  }
  $x = mesa::compareSequenceAttributeLevel2(
	$level,
	"0040 0324",	# Billing Supplies and Devices Sequence
	"0040 0293",	# Quantity Sequence
	"0040 0294",	# Quantity
	$masterFile,
	$testFile);
    $rtnValue = 1 if ($x != 0);
  return $rtnValue;
}


sub eval_mpps_billing_material_option
{
  my $level = shift(@_);
  my $aet = shift(@_);
  my $masterFile = shift(@_);
  my $testFile = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "In comparing MPPS, the master file $masterFile is missing\n";
    print main::LOG " This probably means you forgot to run the setup step.\n";
    return 1;
  }

  $rtnValue = 1;	# We assume a failure
  print main::LOG "CTX: $testFile\n" if ($level >= 3);

  $x = evaluate_billing_procedure_step_sequence(
	$level, $masterFile, $testFile);
  if ($x == 0) {
    $rtnValue = 0;
  }

  $x = evaluate_film_consumption_sequence(
	$level, $masterFile, $testFile);
  if ($x == 0) {
    $rtnValue = 0;
  }

  $x = evaluate_billing_supplies_and_devices_sequence(
	$level, $masterFile, $testFile);
  if ($x == 0) {
    $rtnValue = 0;
  }
  return $rtnValue;

  if (! (-e $testFile) ) {
    print main::LOG "In comparing MPPS, we are missing the MPPS status:\n" .
	"  $testFile\n";
    print main::LOG " You either gave us the wrong AE title or we are missing the MPPS events.\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/mpps_evaluate -l $level ";
  $x .= " mod 1 $testFile $masterFile ";

  print main::LOG "$x\n" if $verbose;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "MPPS comparison failed for scheduled case \n";
    print main::LOG " File name is $testFile \n";
    return 1;
  }
  return 0;
}


sub eval_mpps_group
{
  my $verbose = shift(@_);
  my $aet = shift(@_);
  my $masterFile = shift(@_);
  my $testFile = shift(@_);

  if (! (-e $masterFile) ) {
    print main::LOG "In comparing MPPS, the master file $masterFile is missing\n";
    print main::LOG " This probably means you forgot to run the setup step.\n";
    return 1;
  }

  if (! (-e $testFile) ) {
    print main::LOG "In comparing MPPS, we are missing the MPPS status:\n" .
	"  $testFile\n";
    print main::LOG " You either gave us the wrong AE title or we are missing the MPPS events.\n";
    return 1;
  }

  $x = "$main::MESA_TARGET/bin/mpps_evaluate ";
  $x .= " -v " if $verbose;
  $x .= " mod 3 $testFile $masterFile ";

  print main::LOG "$x\n" if $verbose;
  print main::LOG `$x`;
  if ($?) {
    print main::LOG "MPPS comparison failed for unscheduled case \n";
    print main::LOG " File name is $testFile \n";
    return 1;
  }
  return 0;
}

sub find_mpps_dir_by_patient_id
{
  my $verbose = shift(@_);
  my $aet = shift(@_);
  my $patientID = shift(@_);

  my $d = "$main::MESA_STORAGE/imgmgr/mpps/$aet";
  print main::LOG "Searching for MPPS files in: $d \n" if $verbose;
  print main::LOG " Patient ID for MPPS files is $patientID \n" if $verbose;

  if (! -e $d) {
    print "Failure: The directory $d does not exist. \n" .
	  " Are you using the proper AE title for MPPS ? \n";
    print main::LOG "Failure: The directory $d does not exist. \n" .
	  " Are you using the proper AE title for MPPS ? \n";
    exit 1;
  }

  opendir MPPS, $d  or die "directory: $d not found!";
  @mppsDirectories = readdir MPPS;
  closedir MWL;

  my $mppsIDX = 0;
  undef @rtnMPPS;

  ENTRY: foreach $dirName (@mppsDirectories) {
    next ENTRY if ($dirName eq ".");
    next ENTRY if ($dirName eq "..");

    $f = "$d/$dirName/mpps.dcm";
    print main::LOG " Searching $f for MPPS information. \n" if $verbose;
    next ENTRY if (! (-e $f));

    $id = `$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f`;
    chomp $id;
    print main::LOG " $f <$id> \n" if $verbose;

    if ($patientID eq $id) {
      $rtnMPPS[$mppsIDX] = "$d/$dirName";
      $mppsIDX++;
    }
  }

  return @rtnMPPS;
}


sub find_mpps_dir_by_patient_id_sps_id
{
  my $verbose = shift(@_);
  my $aet = shift(@_);
  my $patientID = shift(@_);
  my $spsID = shift(@_);

  my $d = "$main::MESA_STORAGE/imgmgr/mpps/$aet";
  print main::LOG "Searching for MPPS files in: $d \n" if $verbose;
  print main::LOG " Patient ID for MPPS files is $patientID \n" if $verbose;

  opendir MPPS, $d  or die "directory: $d not found; this implies you used an incorrect AE title when invoking a test script";
  @mppsDirectories = readdir MPPS;
  closedir MWL;

  my $mppsIDX = 0;
  undef @rtnMPPS;

  ENTRY: foreach $dirName (@mppsDirectories) {
    next ENTRY if ($dirName eq ".");
    next ENTRY if ($dirName eq "..");

    $f = "$d/$dirName/mpps.dcm";
    print main::LOG " Searching $f for MPPS information. \n" if $verbose;
    next ENTRY if (! (-e $f));

    my $id = `$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f`;
    chomp $id;
    print main::LOG " $f <$id> \n" if $verbose;
    my $testSPS = `$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $f`;
    chomp $testSPS;

    if (($patientID eq $id) && ($spsID eq $testSPS)) {
      $rtnMPPS[$mppsIDX] = "$d/$dirName";
      $mppsIDX++;
    }
  }

  return @rtnMPPS;
}

sub find_mpps_dir_by_patient_id_perf_ai
{
  my $verbose = shift(@_);
  my $aet = shift(@_);
  my $patientID = shift(@_);
  my $aiCode = shift(@_);

  my $d = "$main::MESA_STORAGE/imgmgr/mpps/$aet";
  print main::LOG "Searching for MPPS files in: $d \n" if $verbose;
  print main::LOG " Patient ID for MPPS files is $patientID \n" if $verbose;
  print main::LOG " Perf Protocol Code for MPPS files is $aiCode\n" if $verbose;

  opendir MPPS, $d  or die "directory: $d not found!";
  @mppsDirectories = readdir MPPS;
  closedir MWL;

  my $mppsIDX = 0;
  undef @rtnMPPS;

  ENTRY: foreach $dirName (@mppsDirectories) {
    next ENTRY if ($dirName eq ".");
    next ENTRY if ($dirName eq "..");

    $f = "$d/$dirName/mpps.dcm";
    print main::LOG " Searching $f for MPPS information. \n" if $verbose;
    next ENTRY if (! (-e $f));

    my $id = `$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f`;
    chomp $id;
    my $testAICode = `$main::MESA_TARGET/bin/dcm_print_element -s 0040 0260 0008 0100 $f`;
    chomp $testAICode;
    print main::LOG " $f <$id> <$testAICode> \n" if $verbose;

    if (($patientID eq $id) && ($aiCode eq $testAICode)) {
      print main::LOG " Found matching file: $f\n" if $verbose;
      $rtnMPPS[$mppsIDX] = "$d/$dirName";
      $mppsIDX++;
    }
  }

  return @rtnMPPS;
}

sub find_mpps_dir_by_patient_id_perf_ai_modality
{
  my $verbose   = shift(@_);
  my $aet       = shift(@_);
  my $patientID = shift(@_);
  my $aiCode    = shift(@_);
  my $modality  = shift(@_);

  my $d = "$main::MESA_STORAGE/imgmgr/mpps/$aet";
  print main::LOG "Searching for MPPS files in: $d \n" if $verbose;
  print main::LOG " Patient ID for MPPS files is $patientID \n" if $verbose;
  print main::LOG " Perf Protocol Code for MPPS files is $aiCode\n" if $verbose;
  print main::LOG " Modality for MPPS files is $modality\n" if $verbose;

  opendir MPPS, $d  or die "directory: $d not found!";
  @mppsDirectories = readdir MPPS;
  closedir MWL;

  my $mppsIDX = 0;
  undef @rtnMPPS;

  ENTRY: foreach $dirName (@mppsDirectories) {
    next ENTRY if ($dirName eq ".");
    next ENTRY if ($dirName eq "..");

    $f = "$d/$dirName/mpps.dcm";
    print main::LOG " Searching $f for MPPS information. \n" if $verbose;
    next ENTRY if (! (-e $f));

    my $id = `$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f`;
    chomp $id;
    my $testAICode = `$main::MESA_TARGET/bin/dcm_print_element -s 0040 0260 0008 0100 $f`;
    chomp $testAICode;
    my $testModality = `$main::MESA_TARGET/bin/dcm_print_element 0008 0060 $f`;
    chomp $testModality;
    print main::LOG " $f <$id> <$testAICode> <$testModality> \n" if $verbose;

    if (($patientID eq $id) && ($aiCode eq $testAICode) && ($modality eq $testModality)) {
      print main::LOG " Found matching file: $f\n" if $verbose;
      $rtnMPPS[$mppsIDX] = "$d/$dirName";
      $mppsIDX++;
    }
  }

  return @rtnMPPS;
}

sub find_mpps_dir_by_patient_id_no_gsps
{
  my $verbose = shift(@_);
  my $aet = shift(@_);
  my $patientID = shift(@_);
  my $aiCode = shift(@_);

  my $d = "$main::MESA_STORAGE/imgmgr/mpps/$aet";
  print main::LOG "Searching for MPPS files in: $d \n" if $verbose;
  print main::LOG " Patient ID for MPPS files is $patientID \n" if $verbose;

  opendir MPPS, $d  or die "directory: $d not found!";
  @mppsDirectories = readdir MPPS;
  closedir MWL;

  my $mppsIDX = 0;
  undef @rtnMPPS;

  ENTRY: foreach $dirName (@mppsDirectories) {
    next ENTRY if ($dirName eq ".");
    next ENTRY if ($dirName eq "..");

    $f = "$d/$dirName/mpps.dcm";
    print main::LOG " Searching $f for MPPS information. \n" if $verbose;
    next ENTRY if (! (-e $f));

    my $id = `$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f`;
    chomp $id;
    print main::LOG " $f <$id> \n" if $verbose;
    my $modality = `$main::MESA_TARGET/bin/dcm_print_element 0008 0060 $f`;
    chomp $modality;

    print main::LOG "$patientID $modality \n" if $verbose;
    if (($patientID eq $id) && ($modality ne "PR")) {
      print main::LOG "Found MPPS match: $dirName \n" if $verbose;
      $rtnMPPS[$mppsIDX] = "$d/$dirName";
      $mppsIDX++;
    }
  }

  return @rtnMPPS;
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

sub find_images_by_patient
{
  my $verbose = shift(@_);
  my $patientID = shift( @_ );

  print main::LOG "Patient ID = $patientID \n" if $verbose;

  undef @studyUID;
  my @studyUID = mod::lookup_study_uid_by_patient_id($verbose, $patientID);
  $count = scalar(@studyUID);
  if ($count == 0) {
    print "In mod::find_images_by_patient_sps_id, found 0 studies \n" .
	"for the Patient ID: $patientID.  The count should be at least 1.\n " .
	"You need to get the proper MWL entry and submit data to the \n " .
	"MESA Image Manager.\n";
    print main::LOG "In mod::find_images_by_patient_sps_id, found 0 studies\n" .
	"for the Patient ID: $patientID.  The count should be at least 1.\n " .
	"You need to get the proper MWL entry and submit data to the \n " .
	"MESA Image Manager.\n";
    exit 1;
  }

  my $idx = 0;
  undef @rtnFiles;
  foreach $study(@studyUID) {
    print  main::LOG " Study: $study \n" if $verbose;
    print  " Study: $study \n" if $verbose;
    undef @seriesUID;
    my @seriesUID = mod::lookup_series_uid_by_study_uid($verbose, $study);
    foreach $series(@seriesUID) {
      print  main::LOG "  Series: $series \n" if $verbose;
      print  "  Series: $series \n" if $verbose;
      undef @fileNames;
      @fileNames = mod::lookup_filnam_uid_by_series_uid($verbose, $series);
      foreach $f(@fileNames) {
	$x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $f";
	$id = `$x`; chomp $id;
	if ($idx == 0) {
	  print main::LOG "Found image for Patient ID: $patientID, Scheduled Procedure Step ID: $id \n" if $verbose;
	  print main::LOG "$f \n" if $verbose;
	}
	$rtnFiles[$idx] = $f;
	$idx++;
      }
    }
  }
  return @rtnFiles;
}

sub find_images_by_patient_sps_id
{
  my $verbose = shift(@_);
  my $patientID = shift( @_ );
  my $spsID = shift( @_ );

  print main::LOG "Patient ID = $patientID \n" if $verbose;
  print main::LOG "SPS ID = $spsID \n" if $verbose;

  undef @studyUID;
  my @studyUID = mod::lookup_study_uid_by_patient_id($verbose, $patientID);
  $count = scalar(@studyUID);
  if ($count == 0) {
    print "In mod::find_images_by_patient_sps_id, found 0 studies \n" .
	"for the Patient ID: $patientID.  The count should be at least 1.\n " .
	"You need to get the proper MWL entry and submit data to the \n " .
	"MESA Image Manager.\n";
    print main::LOG "In mod::find_images_by_patient_sps_id, found 0 studies\n" .
	"for the Patient ID: $patientID.  The count should be at least 1.\n " .
	"You need to get the proper MWL entry and submit data to the \n " .
	"MESA Image Manager.\n";
    exit 1;
  }

  my $idx = 0;
  undef @rtnFiles;
  foreach $study(@studyUID) {
    print  main::LOG " Study: $study \n" if $verbose;
    print  " Study: $study \n" if $verbose;
    undef @seriesUID;
    my @seriesUID = mod::lookup_series_uid_by_study_uid($verbose, $study);
    foreach $series(@seriesUID) {
      print  main::LOG "  Series: $series \n" if $verbose;
      print  "  Series: $series \n" if $verbose;
      undef @fileNames;
      @fileNames = mod::lookup_filnam_uid_by_series_uid($verbose, $series);
      foreach $f(@fileNames) {
	$x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $f";
	$id = `$x`; chomp $id;
	$y = "$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f";
	$idY = `$y`; chomp $idY;
	print main::LOG "   Patient ID: $idY SPS ID: <$id> file $f\n" if $verbose;

	if ($id eq $spsID) {
	  if ($idx == 0) {
	    print main::LOG "$id $spsID \n" if $verbose;
	    print main::LOG "$f \n" if $verbose;
	  }
	  $rtnFiles[$idx] = $f;
	  $idx++;
	}
      }
    }
  }
  return @rtnFiles;
}

sub find_gsps_by_patient_sps_id
{
  my $verbose = shift(@_);
  my $patientID = shift( @_ );
  my $spsID = shift( @_ );

  print main::LOG "Patient ID = $patientID \n" if $verbose;
  print main::LOG "SPS ID = $spsID \n" if $verbose;

  undef @studyUID;
  my @studyUID = mod::lookup_study_uid_by_patient_id($verbose, $patientID);
  $count = scalar(@studyUID);
  if ($count == 0) {
    print "In mod::find_images_by_patient_sps_id, found 0 studies \n" .
	"for the Patient ID: $patientID.  The count should be at least 1.\n " .
	"You need to get the proper MWL entry and submit data to the \n " .
	"MESA Image Manager.\n";
    print main::LOG "In mod::find_images_by_patient_sps_id, found 0 studies\n" .
	"for the Patient ID: $patientID.  The count should be at least 1.\n " .
	"You need to get the proper MWL entry and submit data to the \n " .
	"MESA Image Manager.\n";
    exit 1;
  }

  my $idx = 0;
  my $sopClass = "1.2.840.10008.5.1.4.1.1.11.1";
  undef @rtnFiles;
  foreach $study(@studyUID) {
    print  main::LOG " Study: $study \n" if $verbose;
    print  " Study: $study \n" if $verbose;
    undef @seriesUID;
    my @seriesUID = mod::lookup_series_uid_by_study_uid($verbose, $study);
    foreach $series(@seriesUID) {
      print  main::LOG "  Series: $series \n" if $verbose;
      print  "  Series: $series \n" if $verbose;
      undef @fileNames;
      @fileNames = mod::lookup_filnam_uid_by_series_uid($verbose, $series);
      foreach $f(@fileNames) {
	$x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0275 0040 0009 $f";
	$id = `$x`; chomp $id;
	$x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0016 $f";
	my $uid = `$x`; chomp $uid;
	if (($id eq $spsID) && ($uid eq $sopClass)) {
	  if ($idx == 0) {
	    print main::LOG "$id $spsID \n" if $verbose;
	    print main::LOG "$f \n" if $verbose;
	  }
	  $rtnFiles[$idx] = $f;
	  $idx++;
	}
      }
    }
  }
  return @rtnFiles;
}

sub find_images_by_patient_sop_class
{
  my $verbose = shift(@_);
  my $patientID = shift( @_ );
  my $sopClass = shift( @_ );

  print main::LOG "Patient ID = $patientID \n" if $verbose;

  undef @studyUID;
  my @studyUID = mod::lookup_study_uid_by_patient_id($verbose, $patientID);
  $count = scalar(@studyUID);
  if ($count == 0) {
    print "In mod::find_images_by_patient, found 0 studies \n" .
        "for the Patient ID: $patientID.  The count should be at least 1.\n ";
    print main::LOG "In mod::find_images_by_patient, found 0 studies\n" .
        "for the Patient ID: $patientID.  The count should be at least 1.\n ";
    exit 1;
  }
  my $idx = 0;
  undef @rtnFiles;
  foreach $study(@studyUID) {
    print  main::LOG " Study: $study \n" if $verbose;
    print  " Study: $study \n" if $verbose;
    undef @seriesUID;
    my @seriesUID = mod::lookup_series_uid_by_study_uid($verbose, $study);
    foreach $series(@seriesUID) {
      print  main::LOG "  Series: $series \n" if $verbose;
      print  "  Series: $series \n" if $verbose;
      undef @fileNames;
      @fileNames = mod::lookup_filnam_uid_by_series_uid($verbose, $series);
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

sub find_images_by_patient_no_gsps_no_key_images
{
  my $verbose = shift(@_);
  my $patientID = shift( @_ );

  print main::LOG "Patient ID = $patientID \n" if $verbose;

  undef @studyUID;
  my @studyUID = mod::lookup_study_uid_by_patient_id($verbose, $patientID);
  $count = scalar(@studyUID);
  if ($count == 0) {
    print "In mod::find_images_by_patient, found 0 studies \n" .
        "for the Patient ID: $patientID.  The count should be at least 1.\n ";
    print main::LOG "In mod::find_images_by_patient, found 0 studies\n" .
        "for the Patient ID: $patientID.  The count should be at least 1.\n ";
    exit 1;
  }
  my $idx = 0;
  undef @rtnFiles;
  my $sop1 = "1.2.840.10008.5.1.4.1.1.88.59";
  my $sop2 = "1.2.840.10008.5.1.4.1.1.11.1";

  foreach $study(@studyUID) {
    print  main::LOG " Study: $study \n" if $verbose;
    print  " Study: $study \n" if $verbose;
    undef @seriesUID;
    my @seriesUID = mod::lookup_series_uid_by_study_uid($verbose, $study);
    foreach $series(@seriesUID) {
      print  main::LOG "  Series: $series \n" if $verbose;
      print  "  Series: $series \n" if $verbose;
      undef @fileNames;
      @fileNames = mod::lookup_filnam_uid_by_series_uid($verbose, $series);
      foreach $f(@fileNames) {
	$x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0016 $f";
	$uid = `$x`; chomp $uid;
	if (($uid ne $sop1) && ($uid ne $sop2)) {
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

sub send_storage_commit {
  my $dirName          = shift(@_);
  my $imgMgrAE         = shift(@_);
  my $imgMgrHost       = shift(@_);
  my $imgMgrPort       = shift(@_);
  my $mesaModalityPort = shift(@_);
  my $commitUID        = "1.2.840.10008.1.20.1.1";

  $naction = "$main::MESA_TARGET/bin/naction -a MODALITY1 -c $imgMgrAE $imgMgrHost $imgMgrPort commit ";
  $nevent  = "$main::MESA_TARGET/bin/nevent  -a MESA localhost $mesaModalityPort commit ";

  print "$dirName \n";
  $nactionExec = "$naction $main::MESA_STORAGE/modality/$dirName/sc.xxx $commitUID ";


  print "$nactionExec \n";
  print `$nactionExec`;
  die "Could not send Storage Commitment N-Action to Image Mgr \n" if ($?);

  return;

  $neventExec = "$nevent $main::MESA_STORAGE/modality/$dirName/sc.xxx $commitUID ";
  print "$neventExec \n";
  print `$neventExec`;
  die "Could not send Storage Commitment N-Event to MESA modality\n" if ($?);
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
    `del/q $dirName\\*.xml`;
  } else {
    `rm -f $dirName/*.xml`;
  }
}

sub extract_syslog_messages() {
 my $x = "$main::MESA_TARGET/bin/syslog_extract";
 print "$x \n";
 print `$x`;
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

sub evaluate_NM_image_type {
 my ($level, $imageType) = @_;
 my ($t1, $t2, $t3) = split("\\\\", $imageType);
 @ legalTypes = ("STATIC", "WHOLE BODY", "DYNAMIC", "GATED", 
	"TOMO", "RECON TOMO", "GATED TOMO", "RECON GATED TOMO");
 my $rtnValue = 1;

 if (! $t3) {
  print main::LOG "ERR mod:evaluate_NM_image_type no value in 3rd component of $imageType\n";
  return 1;
 }

 print main::LOG "CTX mod::evaluate_NM_image_type Image Type $imageType\n" if ($level >= 3);
 print main::LOG "CTX mod::evaluate_NM_image_type testing $t3\n" if ($level >= 3);

 foreach $t(@legalTypes) {
  print main::LOG "CTX  <$t3> <$t>\n" if ($level >= 3);
  if ($t3 eq $t) {
    $rtnValue = 0;
  }
 }
 if ($rtnValue == 0) {
  print main::LOG "CTX Found matching value in Image Type, 3rd value: ($t3)\n";
 } else {
  print main::LOG "ERR Your Image type 3rd value ($t3) does not match an expected value\n";
 }

 return $rtnValue;
}

sub update_mwl {
  my $whereClause = shift(@_);
  my $updateClause = shift(@_);

  my $osName = $main::MESA_OS;
  if ($osName eq "WINDOWS_NT") {
    open SQL, ">update_mwl.sql" or die "Could not create update_mwl.sql";
    print SQL "update mwl $updateClause $whereClause \n";
    print SQL "go\n";
    print SQL "select patid, nam from mwl\n";
    print SQL "go\n";
    close SQL;
    print `isql -d ordfil -U$main::MESA_SQL_LOGIN -P$main::MESA_SQL_PASSWORD < update_mwl.sql`;
  } else {
    open SQL, ">update_mwl.sql" or die "Could not create update_mwl.sql";
    print SQL "update mwl $updateClause $whereClause ;\n";
    print SQL "select patid, nam from mwl;\n";
    close SQL;
    print `psql ordfil < update_mwl.sql`;
  }
}

sub store_images_secure {
  my $directoryName   = shift(@_);
  my $deltafile       = shift(@_);
  my $sourceAE        = shift(@_);
  my $destinationAE   = shift(@_);
  my $destinationHost = shift(@_);
  my $destinationPort = shift(@_);

# Security parameters

  my $randomsFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers = shift(@_);

  $cmd = "$main::MESA_TARGET/bin/cstore_secure ";

  $cmd .= " -q -r ";
  $cmd .= " -a $sourceAE";
  $cmd .= " -c $destinationAE";
  if( $deltafile) {
    $cmd .= " -d $deltafile"
  }
  $cmd .=
        " -R $randomsFile " .
        " -K $keyFile " .
        " -C $certificateFile " .
        " -P $peerList " .
        " -Z $ciphers ";

  $cmd .= " $destinationHost $destinationPort";

  $imageDir = "$main::MESA_STORAGE/modality/$directoryName/";

  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(/)(\\)g;
    $imageDir =~ s(/)(\\)g;
  }

  opendir IMAGE, $imageDir or die "directory: $imageDir not found!";
  @imageMsgs = readdir IMAGE;
  closedir IMAGE;

  foreach $imageFile (@imageMsgs) {
    if ($imageFile =~ /.dcm/) {
      my $cstoreExec = "$cmd $imageDir$imageFile";
      print "$cstoreExec \n";
      print `$cstoreExec`;
      if ($? != 0) {
        print "Could not send image $imageFile to Image Manager: $destinationAE\n";
        main::goodbye();
      }
    }
  }
}

sub send_mpps_secure
{
  my $directoryName   = "$main::MESA_STORAGE/modality/" . shift(@_);
  my $sourceAE        = shift(@_);
  my $destAE   = shift(@_);
  my $destHost = shift(@_);
  my $destPort = shift(@_);

# Security parameters

  my $randomsFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers = shift(@_);

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/ncreate_secure -a MESA_MODALITY -c $destAE " .
        " -R $randomsFile " .
        " -K $keyFile " .
        " -C $certificateFile " .
        " -P $peerList " .
        " -Z $ciphers " .
	" $destHost $destPort " .
	" mpps $directoryName/mpps.crt $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Create \n" if ($?);

  $x = "$main::MESA_TARGET/bin/nset_secure    -a MESA_MODALITY -c $destAE " .
        " -R $randomsFile " .
        " -K $keyFile " .
        " -C $certificateFile " .
        " -P $peerList " .
        " -Z $ciphers " .
	" $destHost $destPort " .
	" mpps $directoryName/mpps.set $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Set \n" if ($?);
}

sub send_storage_commit_secure {
  my $dirName          = shift(@_);
  my $imgMgrAE         = shift(@_);
  my $imgMgrHost       = shift(@_);
  my $imgMgrPort       = shift(@_);
  my $mesaModalityPort = shift(@_);
  my $commitUID        = "1.2.840.10008.1.20.1.1";

# Security parameters

  my $randomsFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers = shift(@_);

  $naction = "$main::MESA_TARGET/bin/naction_secure -a MODALITY1 -c $imgMgrAE " .
        " -R $randomsFile " .
        " -K $keyFile " .
        " -C $certificateFile " .
        " -P $peerList " .
        " -Z $ciphers " .
	" $imgMgrHost $imgMgrPort commit ";

  $nevent  = "$main::MESA_TARGET/bin/nevent  -a MESA localhost $mesaModalityPort commit ";

  print "$dirName \n";
  $nactionExec = "$naction $main::MESA_STORAGE/modality/$dirName/sc.xxx $commitUID ";


  print "$nactionExec \n";
  print `$nactionExec`;
  die "Could not send Storage Commitment N-Action to Image Mgr \n" if ($?);

  return;

  $neventExec = "$nevent $main::MESA_STORAGE/modality/$dirName/sc.xxx $commitUID ";
  print "$neventExec \n";
  print `$neventExec`;
  die "Could not send Storage Commitment N-Event to MESA modality\n" if ($?);
}

sub dump_demographics
{
  my $f = shift (@_);

  my $x = "$main::MESA_TARGET/bin/dcm_print_element 0010 0010 $f";
  my $patientName = `$x`; chomp $patientName;

     $x = "$main::MESA_TARGET/bin/dcm_print_element 0010 0020 $f";
  my $patientID = `$x`; chomp $patientID;

  print main::LOG "CTX Patient Name: $patientName\n";
  print main::LOG "CTX Patient ID:   $patientID\n";
}

sub get_NM_image_type {
  my ($logLevel, $f) = @_;

  print "CTX mod::get_NM_image_type file name $f\n" if $logLevel >= 3;
  my $t = mesa::getImageType($f);
  my ($t1, $t2, $t3) = split("\\\\", $t);
  return $t3;
}

sub extract_nm_frames {
  my ($params, $dcmFile, $pixels) = @_;

  $x = "$main::MESA_TARGET/bin/mesa_extract_nm_frames $params $dcmFile $pixels";
  print "$x \n";
  print `$x`;

  if ($?) {
    print "Could not extract NM frames \n";
    exit 1;
  }
}

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
       "MESA_IMGMGR_AE", "MESA_IMGMGR_HOST", "MESA_IMGMGR_DICOM_PT"
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



sub animate_frames {
  my ($paramsFileName, $inputFileName, $outputFileName) = @_;
  use Fcntl qw(:seek);
#  use Image::Magick;
#
  open PARAMS, "+<$paramsFileName"
    or die "Could not open file - $paramsFileName: $!\n";
  my @fileHandle = <PARAMS>;
  foreach my $line (@fileHandle) {
    ($rowCount, $colCount, $imgHighBit, $imgPixRep, $imgBitAlloc, $imgBitStored, $frameSize, $frameCount, $matchingFrameCount) = split(" ",$line);
  }
  close(PARAMS); 


  open F, "+<$inputFileName"
    or die "Could not open file - $inputFileName: $!\n";
  open G, ">PIXELS.gray" or die "Could not open PIXELS.gray\n";

  my @fileStat = stat($inputFileName);

  my $count = 0;
  my @image;
  my $image;

  my $imgSize = "";
  die "animate_frames: No matching frames in params file ($paramsFileName) \n" if ($matchingFrameCount == 0);

  for (my $frame = $matchingFrameCount; $frame > 0; $frame--) {
    $count++;
    my $pos = tell(F);
    foreach (1 .. $count) { print "." }
    # Read bytes 131072 into $rawData
    seek(F, $pos, SEEK_SET);

    my $rawData;
    read(F,$rawData,$frameSize);
    print G $rawData;

    $imgSize = $rowCount."x".$colCount;
    print "$imgSize, $imgBitAlloc\n";
  }

  close(F);
  close(G);
  my $x = "convert -size $imgSize -depth $imgBitAlloc PIXELS.gray $outputFileName";
  print "$x\n";
  print `$x`;
}

1;
