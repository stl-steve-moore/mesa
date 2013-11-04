#!/usr/local/bin/perl -w

# Package for Report Creator scripts.

use Env;

package rpt_mgr;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
);

use lib "../common/scripts";
require mesa;

sub read_config_params {
  my $f = shift(@_);
  open (CONFIGFILE, $f) or die "Can't open $f.\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    $varnames{$varname} = $varvalue;
  }

  $rptMgrHost = $varnames{"TEST_MANAGER_HOST"};
  $rptMgrPort = $varnames{"TEST_MANAGER_PORT"};
  $rptMgrAE= $varnames{"TEST_MANAGER_AE"};

  return ( $rptMgrHost, $rptMgrPort, $rptMgrAE);
}

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
	"TEST_HL7_HOST", "TEST_HL7_PORT",
        "MESA_ORD_PLC_PORT_HL7", 
        "MESA_ORD_FIL_PORT_HL7", 
	"MESA_IMG_MGR_PORT_HL7", "MESA_IMG_MGR_PORT_DCM",
        "TEST_RPT_MGR_RWL_AE", "TEST_RPT_MGR_RWL_HOST", "TEST_RPT_MGR_RWL_PORT",
        "TEST_MANAGER_AE", "TEST_MANAGER_HOST", "TEST_MANAGER_PORT"
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

  $x = "$main::MESA_TARGET/bin/mesa_select_column filnam sopins rpt_repos files.txt";
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

sub send_hl7 {
  my $hl7Dir = shift(@_);
  my $msg = shift(@_);
  my $target = shift(@_);
  my $port   = shift(@_);

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe ";
  print "$send_hl7 $target $port $hl7Dir/$msg \n";
  print `$send_hl7 $target $port $hl7Dir/$msg`;

  return 0 if $?;

  return 1;
}

sub evaluate_hl7 {
  my $verbose  = shift(@_);
  my $stdDir  = shift(@_);
  my $stdMsg  = shift(@_);
  my $testDir = shift(@_);
  my $testMsg = shift(@_);
  my $formatFile = shift(@_);
  my $iniFile = shift(@_);

  print main::LOG "$stdMsg $testMsg \n";

  my $pathStd = "$stdDir/$stdMsg";
  my $pathTest = "$testDir/$testMsg";

  my $evaluateCmd = "$main::MESA_TARGET/bin/hl7_evaluate ";
     $evaluateCmd .= " -v " if ($verbose);
     $evaluateCmd .= " -b $main::MESA_TARGET/runtime -m $formatFile $pathTest";

  print main::LOG "$evaluateCmd \n";
  print main::LOG `$evaluateCmd`;
  return 1 if ($?);

  my $compareCmd = "$main::MESA_TARGET/bin/compare_hl7 ";
     $compareCmd .= " -v " if ($verbose);
     $compareCmd .= " -b $main::MESA_TARGET/runtime -m $iniFile $pathStd $pathTest";

  print main::LOG "$compareCmd \n";
  print main::LOG `$compareCmd`;

  return 1 if ($?);

  return 0;
}

# Obtains the GPPPS Instance UID that is stored as
# text in gppps_uid.txt. In the arugment list:
# 1 - logLevel	Controls output level
# 2 - inDir	Input directory

#sub getGPPPSUID {
#  my ($logLevel, $gpppsDirectory) = @_;
#
#  print "RPT_MGR::getGPPPSUID Dir: $gpppsDirectory\n" if ($logLevel >= 3);
#  my $fileName = "$gpppsDirectory/gppps_uid.txt";
#  open (TEXTFILE, "<$fileName") or die "Can't open $fileName.\n";
#
#  my $sopuid = <TEXTFILE>;
#  return (1, "") if ($?);
#  chomp $sopuid;
#
#  return (1, "") if ($sopuid eq "");
#
#  return (0, $sopuid);
#}

# Obtains the SOP Instance UID that is stored 
# in a DCM file
sub getSOPInstanceUID {
  my $dicomObjectFile = shift(@_);
  $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0018 $dicomObjectFile";
  my $sopuid = `$x`;
  chomp $sopuid;
  return $sopuid;
}


sub evaluate_one_gpsps_resp {
  my ($logLevel, $testFile, $stdFile) = @_;

  my $evalString = "$main::MESA_TARGET/bin/cfind_gpsps_evaluate " .
     " -l $logLevel $testFile $stdFile";

  print main::LOG "$evalString \n";
  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

# subroutine for sort function.  Allows a list of files to be sorted
# from newest to oldest by age since modification.
sub files_new2old {
  -M $a <=> -M $b
}

# make_composite_gppps
#
# Take a gppps ncreate object and apply one or more nsets to create
# the final gppps object. The objects are all assumed to be in the same
# directory with the ncreate file having suffix .crt and the nsets
# having suffix .set
sub make_composite_gppps {
 my $verbose = shift(@_);  # boolean flag
 my $dir = shift(@_);      # Directory with gppps create and nset objects.
 my $gppps_template_file = shift(@_); # a gppps object that defines the
                                      # attributes of interest.
 my $outfile = shift(@_); # filename of resulting composite object.

 opendir DIR, $dir or die "Unable to locate directory: $dir\n";
 @allfiles = readdir DIR;
 closedir DIR;

 # find files that end with .crt
 @crtfiles = grep /\.crt$/, @allfiles;
 $nfiles = @crtfiles;
 if( $nfiles == 0) {
   print main::LOG "Failed to find GPPPS Ncreate in $dir\n";
   return 1;
 }
 if( $nfiles > 1) {
   print main::LOG "Error: found multiple GPPPS Ncreates in $dir\n";
   return 1;
 }

 $crtpath = $dir . $crtfiles[0];

 # find files that end with .set
 @setfiles = grep /\.set$/, @allfiles;
 $nfiles = @setfiles;
 if( $nfiles == 0) {
  print main::LOG "Failed to find GPPPS Nset in $dir\n";
   return 1;
 }

 @setpaths = ();
 foreach $file (@setfiles) {
  push @setpaths, $dir . $file
 }

 # sort the set files from oldest to newest.
 @setfiles = reverse sort files_new2old @setpaths;

 $x = "$MESA_TARGET/bin/update_gppps -t $gppps_template_file";
 $x .= " -o $outfile";
 $x .= " $crtpath @setfiles";

 print main::LOG "\n$x\n" if($verbose);
 print main::LOG `$x` if($verbose);
 return 0;
}

# perl modules included with the require command must return true.
1;
