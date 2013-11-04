#!/usr/local/bin/perl -w

# Package for External Report Repository scripts.

use Env;

package rptrepos;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
);


sub read_config_params {
  open (CONFIGFILE, "ext_repos.cfg") or die "Can't open ext_repos.cfg.\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    $varnames{$varname} = $varvalue;
  }

  $reposCFindHost = $varnames{"TEST_CFIND_HOST"};
  $reposCFindPort = $varnames{"TEST_CFIND_PORT"};
  $reposCFindAE= $varnames{"TEST_CFIND_AE"};

  return ($reposCFindAE, $reposCFindHost, $reposCFindPort);

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
  my $dirName = shift(@_);

  if ( -d $dirName) {
    return;
  }
  if( $main::MESA_OS eq "WINDOWS_NT") {
     $dirName =~ s(/)(\\)g;
     `mkdir $dirName`;
  }
  else {
     `mkdir -p $dirName`;
  }
  if( $? != 0) {
     die "Failed to create directory: $dirName\n";
  }
}

sub make_object {
  my $baseName = shift(@_);

  my $txtName = "$baseName.txt";
  my $objName = "$baseName.dcm";

  if (! -e $txtName) {
    print "File $txtName does not exist; exiting. \n";
    exit 1;
  }

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $txtName $objName";
  `$x`;
  die "Could not create $objName\n" if ($?);
}

sub send_cfind {
  my ($cfindFile, $reposAE, $reposHost, $reposPort, $outDir) = @_;

  if( $outDir) {
     $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $reposAE -f $cfindFile -o $outDir -x STUDY $reposHost $reposPort ";
  }
  else {
     $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $reposAE -f $cfindFile -x STUDY $reposHost $reposPort ";
  }

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
}

sub send_cfind_patient_id {
  my ($cfindFile, $reposAE, $reposHost, $reposPort, $patientID, $outDir) = @_;
  open PIDFILE, ">pid.txt" or die "Could not open pid.txt to write patient ID\n";
  print PIDFILE "AA 0010 0020 $patientID \n";
  close PIDFILE;

  if( $outDir) {
     $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $reposAE " .
	" -d pid.txt " .
	" -f $cfindFile -o $outDir -x STUDY $reposHost $reposPort ";
  } else {
     $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $reposAE " .
	" -d pid.txt " .
	" -f $cfindFile -x STUDY $reposHost $reposPort ";
  }

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
}

sub send_cmove_study_uid {
  my ($cmoveFile, $reposAE,$reposHost,$reposPort, $studyUID, $wkstationAE) = @_;
  open UIDFILE, ">uid.txt" or die "Could not open uid.txt to write Study Instance UID\n";
  print UIDFILE "AA 0020 000D $studyUID \n";
  close UIDFILE;

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $cmoveFile.txt $cmoveFile.dcm";
  `$x`;

  $cmoveString = "$main::MESA_TARGET/bin/cmove -a MESA -c $reposAE " .
	" -d uid.txt " .
	" -f $cmoveFile.dcm -x STUDY $reposHost $reposPort $wkstationAE";

  print "$cmoveString \n";
  print `$cmoveString`;

  die "Could not send C-Move request \n" if ($?);

  return 0;
}

sub evaluate_cfind_resp {
  my $verbose = shift(@_);
  my $group  = shift(@_);
  my $element  = shift(@_);
  my $maskFile = shift(@_);
  my $tstDir = shift(@_);
  my $stdDir = shift(@_);

  if (! -e($tstDir)) {
    print main::LOG "Evaluation of C-Find responses failed.\n";
    print main::LOG "Directory with test messages: $tstDir does not exist.\n";
    return 1;
  }
  if (! -e($tstDir)) {
    print main::LOG "Evaluation of C-Find responses failed.\n";
    print main::LOG "Directory with standard messages: $sdtDir does not exist.\n";
    return 1;
  }
  $evalString = "$main::MESA_TARGET/bin/cfind_resp_evaluate ";
  $evalString .= " -v " if ($verbose);
  $evalString .= "$group $element $maskFile $tstDir $stdDir";

  print main::LOG "$evalString \n";

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub create_hash_test_messages {
  my $verb = shift(@_);
  my $testAETitle = shift(@_);

  $testDir = "$main::MESA_STORAGE/modality/st_comm/$testAETitle";

  opendir TESTDIR, $testDir or die "directory: $testDir not found! Is $testAETitle correct for your Storage Commitment SCP?";
  @testFiles = readdir TESTDIR;

  MESSAGE: foreach $message (@testFiles) {
    next MESSAGE if ($message eq ".");
    next MESSAGE if ($message eq "..");

    $z = "$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $testDir/$message";
    print ("$z \n") if ($verbose);
    $x = `$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $testDir/$message`;
    chomp $x;
    next MESSAGE if ($x eq "");

    print ("$x \n") if ($verbose);
    $testMessages{$x} = "$testDir/$message";
  }
}

sub read_mesa_messages() {
  $scDir = "$main::MESA_STORAGE/modality/st_comm/MESA";

  opendir SC, $scDir or die "directory: $scDir not found";
  @scMsgs = readdir SC;
  closedir SC;
}

sub grade_messages () {
  my $verbose = shift(@_);
  my $rtnValue = 0;

  MESSAGE: foreach $message (@scMsgs) {
    next MESSAGE if ($message eq ".");
    next MESSAGE if ($message eq "..");

    $mesa = "$scDir/$message";

    print main::LOG "$mesa \n";

    $uid = `$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $mesa`;
    chomp $uid;
    if ($uid eq "") {
      print main::LOG "Could not get transaction UID for $mesa \n";
      $rtnValue = 1;
      next MESSAGE;
    }

    print main::LOG "$uid \n";

    $testFile = $testMessages{$uid};
    if ($testFile eq "") {
      print main::LOG "No matching vendor file for $uid \n";
      $rtnValue = 1;
      next MESSAGE;
    }

    print main::LOG "$testFile \n";

    $x = "$main::MESA_TARGET/bin/evaluate_storage_commitment $mesa $testFile";
    print main::LOG "$x\n" if ($verbose);

    print main::LOG `$x`;
    if ($? != 0) {
      $rtnValue = 1;
    }
  }
  return $rtnValue;
}

# OS-neutral file delete. 
sub rm_files {
   my $target = shift( @_);

   if( $MESA_OS eq "WINDOWS_NT") {
      $target =~ s(/)(\\)g;
      $cmd = "del/Q $target";
   }
   else {
      $cmd = "rm -f $target";
   }
   print "$cmd\n";
#   `$cmd`;
}

sub local_scheduling_mr {
  print `perl scripts/schedule_mr.pl`;
}

sub local_scheduling_rt {
  print `perl scripts/schedule_rt.pl`;
}

sub find_responses {
  my $queryResultsDir = shift(@_);

  print main::LOG
	"Searching for reponses in dir: $queryResultsDir\n";

  opendir QDIR, $queryResultsDir or die "directory: $queryResultsDir not found";
  @qMsgs = readdir QDIR;
  closedir QDIR;

  undef @responseFiles;
  my $idx = 0;

  ENTRY: foreach $msg (@qMsgs) {
    next ENTRY if ($msg eq ".");
    next ENTRY if ($msg eq "..");
    $responseFiles[$idx] = $msg;
    $idx++;
  }

  return @responseFiles;
}

sub lookup_study_uid_by_patient_id
{
  my $verbose = shift(@_);
  my $patientID = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c patid $patientID " .
	" stuinsuid ps_view wkstation tmp/stuuid.txt";

  print main::LOG "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not select Study UID from Workstation table \n";
    exit 1;
  }

  open (STUDY_UIDS, "tmp/stuuid.txt") or die
	"Could not open tmp/stuuid.txt (output of mesa_select_column) \n";

  my $idx = 0;
  undef @rtnStudies;
  while (<STUDY_UIDS>) {
    $f = $_;
    chomp $f;
    $rtnStudies[$idx] = $f;
    $idx++;
  }
  return @rtnStudies;
}

sub lookup_sop_ins_files_by_patient_id
{
  my $verbose = shift(@_);
  my $patientID = shift(@_);

  my @studyUIDs = lookup_study_uid_by_patient_id($verbose, $patientID);

  undef @sopInsFileNames;
  my $idx = 0;

  foreach $study(@studyUIDs) {
    print main::LOG "Study UID = $study \n" if $verbose;
    my @seriesUIDs = rptrepos::lookup_series_uid_by_study_uid($verbose, $study);
    foreach $series(@seriesUIDs) {
      print main::LOG " Series UID = $series \n" if $verbose;
      my @fileNames = lookup_filnam_uid_by_series_uid($verbose, $series);
      foreach $f(@fileNames) {
        print main::LOG "   File name = $f\n" if $verbose;
	$sopInsFileNames[$idx] = $f;
	$idx++;
      }
    }
  }
  return @sopInsFileNames;
}

sub lookup_series_uid_by_study_uid
{
  my $verbose = shift(@_);
  my $studyUID = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c stuinsuid $studyUID " .
	" serinsuid series wkstation tmp/seruid.txt";

  print main::LOG "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not select Series UID from Workstation table \n";
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

sub lookup_filnam_uid_by_series_uid
{
  my $verbose = shift(@_);
  my $seriesUID = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c serinsuid $seriesUID " .
	" filnam sopins wkstation tmp/filename.txt";

  print main::LOG "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not select File Name from Workstation table \n";
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

1;
