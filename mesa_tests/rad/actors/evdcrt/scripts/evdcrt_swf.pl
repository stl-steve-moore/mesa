#!/usr/local/bin/perl -w
use strict;

# Runs the Evidence Creator scripts interactively
use Env;
Env::import();
use File::Copy;
use Getopt::Std;
use lib "../common/scripts";
use lib "scripts";
require mesa;
require evdcrt_utils;
require evdcrt_announce;

$SIG{INT} = \&goodbye;


sub goodbye () {
    print "Exiting...\n";

    exit 1;
}

sub processTransaction1 {
    my ($src, $dst, $event, $msg) = @_;

    if ($dst ne "OF") {
        print "IHE Transaction 1 from ($src) to ($dst) is not required for IM test\n";
        return;
    }

    my $hl7Msg = "../../msgs/" . $msg;
    my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");

    print "IHE Transaction 1: $pid $patientName \n";
    print "MESA will send ADT message ($msg) for event $event to MESA $dst\n";

    my $x = mesa::send_hl7("../../msgs", $msg, "localhost", $main::mesaOFPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
}

sub processTransaction2 {
    my ($src, $dst, $event, $msg) = @_;

    my $hl7Msg = "../../msgs/" . $msg;
    my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
    my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "0", "Procedure Code");

    print "IHE Transaction 2: $pid $patientName $procedureCode \n";
    print "MESA will send ORM message ($msg) for event $event to MESA $dst\n";

    my $x = mesa::send_hl7("../../msgs", $msg, "localhost", $main::mesaOFPortHL7);
    mesa::xmit_error($msg) if ($x != 0);
}

sub processTransaction4a {
    my ($src, $dst, $event, $msg, $testName, $inputDir, $SPSCode, $PPSCode) = @_;

# for 1701
# src = OF, dst = OF, event = SCHEDULE, msg = sched/1701/1701.106.o01.hl7, testName = T1701
# inDir = MR/MR4/MR4S1, spsCode = X1_A1, ppsCode = X1

    my $hl7Msg = "../../msgs/" . $msg;
    my $pid = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
    my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");

    print `$MESA_TARGET/bin/of_schedule -t MESA_MOD -m MR -s STATION1 ordfil`;

    my $outputDir = "$MESA_STORAGE/modality/$testName";

    produce_scheduled_images("MR", "MESA_MOD", $pid, $procedureCode, $testName,
            "MESA", "localhost", $main::mesaOFPortDICOM, $SPSCode, $PPSCode, $inputDir);
#    produce_scheduled_images("MESA_MOD", $pid, $testName, "MESA", "localhost", 
#            $main::mesaOFPortDICOM);


# create images -- this is done by mod_generatestudy
#    print "Copying $MESA_STORAGE/modality/$inputDir/* to $outputDir\n";
#    my @images = glob("$MESA_STORAGE/modality/$inputDir/*");
#    foreach my $f (@images) {
#        copy($f, $outputDir) or die "Failed copying $f to $outputDir: $!\n";
#    }

    print "\nThis is the scheduling prelude to transaction 4\n";
    print "All work here is internal to the MESA software \n";

    print "PID: $pid Name: $patientName Code: $procedureCode \n";
}

sub processTransaction8 {
    my ($src, $dst, $event, $inputDir) = @_;
    announce_T8(@_);
    return if not $main::selfTest;

    mesa::store_images($inputDir, "", "MODALITY1", $main::mesaImgMgrAE, 
            $main::mesaImgMgrHost, $main::mesaImgMgrPortDICOM, 0);

    mesa::store_images($inputDir, "", "MODALITY1", "MESA_IMG_MGR", "localhost", 
            $main::mesaImgMgrPortDICOM, 1);
}

sub processTransaction10 {
    my ($src, $dst, $event, $inputParam) = @_;
    announce_T10(@_);
    return if not $main::selfTest;

# These two files were created by T43.  
    my $NActionFile = "$MESA_STORAGE/modality/$inputParam/NAction.dcm";
    my $NEventFile = "$MESA_STORAGE/modality/$inputParam/NEvent.dcm";
    my $commitUID = "1.2.840.10008.1.20.1.1";

    if ($event eq "COMMIT-N-ACTION") {

        my $naction = "$main::MESA_TARGET/bin/naction -a $main::testAE -c $main::mesaImgMgrAE ".
            "$main::mesaImgMgrHost $main::mesaImgMgrPortDICOM commit ";
        my $nactionExec = "$naction $NActionFile $commitUID ";
        print "$nactionExec \n";
        print `$nactionExec`;
        if ($?) {
            die "Could not send Storage Commitment N-Action to Image Mgr \n";
        }
    } elsif ($event eq "COMMIT-N-EVENT") {

        my $nevent  = "$main::MESA_TARGET/bin/nevent -a MESA localhost " .
            "$main::mesaModalityPortDICOM commit $NEventFile $commitUID ";
        print "$nevent\n";
        print `$nevent`;
        if ($?) {
            die "Could not send Storage Commitment N-Event to MESA modality\n";
        }
    } else {
        die "Unrecognized event for Transaction 10: $event \n";
    }

    
}

sub processTransaction14 {
# writes the cfind response to the directory given by $outDir.  
    my ($src, $dst, $event, $inputParam, $inDir, $outDir) = @_;
# inputParam is typically T1701
    announce_T14(@_);
    return if not $main::selfTest;

    mesa::delete_directory($main::logLevel, $outDir);
    mesa::create_directory($main::logLevel, $outDir);

# image files are images sent by mesa::store_images.  We will take the first one.
#    my @imageFiles = glob "$MESA_STORAGE/modality/$inputParam/*";
#    my $imageName = shift @imageFiles;

# for mod_generatestudy version...
    my $imageName = "$MESA_STORAGE/modality/$inputParam/x1.dcm";

    my ($errorCode, $studyInstanceUID) = mesa::getDICOMAttribute($main::logLevel, 
            $imageName, "0020 000D");
    if ($errorCode) {
        die "Cannot find study instance UID in $imageName\n";
    }

    print "Study Instance: $studyInstanceUID\n";

    mesa::construct_cfind_query_study(
            $main::logLevel,
            "$inDir/cfind_study_uid_templ.txt",
            "$outDir/cfind_study_uid.txt",
            "$outDir/cfind_study_uid.dcm",
            $studyInstanceUID) and die();  #die executed upon failure (return value 1)

    mesa::send_cfind_log(
            $main::logLevel,
            "$outDir/cfind_study_uid.dcm",
            $main::mesaImgMgrAE, $main::mesaImgMgrHost, $main::mesaImgMgrPortDICOM,
            $outDir . "/test") and die(); 

# Repeat the process for queries to MESA Image Manager
    mesa::send_cfind_log(
          $main::logLevel,
          "$outDir/cfind_study_uid.dcm",
          "MESA_ARCHIVE", "localhost", $main::mesaImgMgrPortDICOM,
          "$outDir/mesa") and die();
    return 1;
}

sub processTransaction16 {
    my ($src, $dst, $event, $inputParam, $inDir, $outDir) = @_;
    announce_T16(@_);
    return if not $main::selfTest;

    my $cfindResponse = $inDir . "/test/msg1_result.dcm";
    my ($errorCode, $studyInstanceUID) = mesa::getDICOMAttribute($main::logLevel, 
            $cfindResponse, "0020 000D");
    if ($errorCode) {
        die "Cannot find study instance UID in $cfindResponse\n";
    }

    print "Looking for SIUID = $studyInstanceUID\n";
    print "writing to $outDir/cmove.dcm\n";

    my @elements = split "\n", <<CMOVE; 
0020 000D, $studyInstanceUID
0008 0052, STUDY
CMOVE

    mesa::create_dcm("", $outDir, "cmove.dcm", @elements);

# make sure hostname is known.  Edit file, $MESA_TARGET/db/loaddicomapp.pgsql then run,
# psql imgmgr < loaddicomapp.pgsql.  Alternatively, edit /etc/hosts

    my $cmoveString = "$main::MESA_TARGET/bin/cmove -a MESA -c $main::mesaImgMgrAE " .
        "-f $outDir/cmove.dcm -x STUDY $main::mesaImgMgrHost " . 
        "$main::mesaImgMgrPortDICOM $main::ECAE";

    print "$cmoveString \n";
    print `$cmoveString`;
    die "Could not send C-Move request \n" if ($?);

    return 1;
}

sub processTransaction20 {
    my ($src, $dst, $event, $inputParam, $templateFile, $srFile, $outDir) = @_;
# $inputParam may be the directory off of $MESA_STORAGE/modality/ where the
# images are; in this case, we will use the first file there for further
# processing.  Alternatively, $imageParam may be a normal filename, in which
# case this file will be used as the image file.
    announce_T20(@_);
    return if not $main::selfTest;

    mesa::delete_directory($main::logLevel, $outDir);
    mesa::create_directory($main::logLevel, $outDir);

# We ought to be reading from results from transaction 16 above.  The storage for these is
# in the MESA/storage/wkstation/instances/MESA_IMGMGR directory.

#    my $imageFile;
#    if (-f $inputParam) {
#        $imageFile = $inputParam;
#    } else {
#        my @files = glob "$MESA_STORAGE/modality/$inputParam/*";
#        $imageFile = shift @files;
#    }

    
# mod_generatestudy version...
    my $imageFile = "$MESA_STORAGE/modality/$inputParam/x1.dcm";

# create sr.dcm file from the text srFile.
    my $srFileDcm = "$outDir/sr.dcm";
    my $cmd = "$main::MESA_TARGET/bin/dcm_create_object -i $srFile $srFileDcm";
    print $cmd . "\n" if $main::logLevel >= 3;
    print `$cmd`;
    if ($?) {
        print "Could not create dcm object $srFileDcm from $srFile:\n$cmd\n";
        return 1;
    }


    my $mppsFile = "$outDir/mpps.dcm";
    print "Image File: $imageFile\n" if $main::logLevel >= 3;

    mesa::createT20MPPS($imageFile, $srFileDcm, $templateFile, $mppsFile);

# this mpps UID will be used for transactions 21 and 43 as well
    $main::mpps_uid = `$main::MESA_TARGET/bin/mesa_identifier mod1 pps_uid`;

    $cmd = "$main::MESA_TARGET/bin/ncreate -a $main::testAE -c $main::mesaImgMgrAE " .
        " $main::mesaImgMgrHost $main::mesaImgMgrPortDICOM mpps $mppsFile $main::mpps_uid ";
    print "$cmd \n";
    print `$cmd`;
    die "Could not send MPPS N-Create \n" if ($?);
}

sub processTransaction21 {
    my ($src, $dst, $event, $templateFile, $outDir) = @_;
    announce_T21(@_);
    return if not $main::selfTest;

#    my $outDir = "1701/results/21";
    mesa::delete_directory($main::logLevel, $outDir);
    mesa::create_directory($main::logLevel, $outDir);

#    my $templateFile = "1701/data/21/T21MPPS.txt";
    my $mppsFile = "$outDir/mpps.dcm";

    mesa::createT21MPPS($templateFile, $mppsFile);

    my $cmd = "$main::MESA_TARGET/bin/nset -a $main::testAE -c $main::mesaImgMgrAE " .
        " $main::mesaImgMgrHost $main::mesaImgMgrPortDICOM mpps $mppsFile $main::mpps_uid ";
    print "$cmd \n";
    print `$cmd`;
    die "Could not send MPPS N-Create \n" if ($?);
}

sub processTransaction43 {
    my ($src, $dst, $event, $inputParam, $srFile, $outDir) = @_;
    announce_T43(@_);
    return if not $main::selfTest;

#    my $outDir = "1701/results/sr";
    mesa::delete_directory($main::logLevel, $outDir);
    mesa::create_directory($main::logLevel, $outDir);

#    my $srFile = "1701/data/sr/sr.dcm";
    my $srFileNew = "$outDir/srUID.dcm";

#    my $imageFile;
#    if (-f $inputParam) {
#        $imageFile = $inputParam;
#    } else {
#        my @files = glob "$MESA_STORAGE/modality/$inputParam/*";
#        $imageFile = shift @files;
#    }

# mod_generatestudy version...
    my $imageFile = "$MESA_STORAGE/modality/$inputParam/x1.dcm";

    mesa::createT43EvDoc($srFile, $imageFile, $main::mpps_uid, $srFileNew);

# Now send the modified SR object
    my $cstore = "$main::MESA_TARGET/bin/cstore -a $main::testAE "
        . " -c $main::mesaImgMgrAE $main::mesaImgMgrHost $main::mesaImgMgrPortDICOM";

    print "$cstore $srFileNew\n";
    print `$cstore $srFileNew`;
    if ($?) {
      die "Could not send $srFileNew to Image Manager \n";
    }

# Create the NAction and NEvent objects we will use in T10.  We will store these
# in the $MESA_STORAGE tree where T10 will be able to find it.
    my $NActionFile = "$MESA_STORAGE/modality/$inputParam/NAction.dcm";
    my $NEventFile = "$MESA_STORAGE/modality/$inputParam/NEvent.dcm";
    mesa::createT10Objects($srFileNew, $NActionFile, $NEventFile)
}

sub processTransaction44 {
    print "Transaction 44 not applicable for Evidence Creator\n";
}

sub processTransaction45 {
    print "Transaction 45 not applicable for Evidence Creator\n";
}

sub processTransaction {
# the arguments to each transaction is the remainder of each line, with
# the first two tokens stripped off.  e.g. for the line,
#   TRANSACTION	1	ADT	OP	REGISTER	adt/1701/1701.102.a04.hl7
# the arguments are (ADT, OP, REGISTER, adt/1701/1701.102.a04.hl7)

    my ($cmd) = @_;
    my @tokens = split /\s+/, $cmd;
    my $verb = shift @tokens;
    my $trans= shift @tokens;

    if ($trans eq "1") {
        processTransaction1(@tokens);
    } elsif ($trans eq "2") {
        processTransaction2(@tokens);
    } elsif ($trans eq "4a") {
        processTransaction4a(@tokens);
    } elsif ($trans eq "8") {
        processTransaction8(@tokens);
    } elsif ($trans eq "10") {
        processTransaction10(@tokens);
    } elsif ($trans eq "14") {
        processTransaction14(@tokens);
    } elsif ($trans eq "16") {
        processTransaction16(@tokens);
    } elsif ($trans eq "20") {
        processTransaction20(@tokens);
    } elsif ($trans eq "21") {
        processTransaction21(@tokens);
    } elsif ($trans eq "43") {
        processTransaction43(@tokens);
    } elsif ($trans eq "44") {
        processTransaction44(@tokens);
    } elsif ($trans eq "45") {
        processTransaction45(@tokens);
    } else {
        die "Unknown Transaction <$cmd>\n";
    }
}

sub printText {
    my $cmd = shift(@_);
    my @tokens = split /\s+/, $cmd;

    my $txtFile = "../common/" . $tokens[1];
    open TXT, $txtFile or die "Could not open text file: $txtFile";
    while (my $line = <TXT>) {
        print $line;
    }
    close TXT;
    print "\nHit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);
}

sub processMESAInternal {
  my ($cmd, $logLevel, $selfTest) = @_;
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];

  my $rtnValue = 0;
  if ($trans eq "RAD-SCHEDULE") {
    shift (@tokens); shift(@tokens);
    $rtnValue = mesa::processInternalSchedulingRequest($logLevel, $selfTest, @tokens);

  } elsif ($trans eq "GEN-MPPS-ABANDON") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateMPPSAbandon($logLevel, $selfTest, "MESAMWL", $main::mesaOFHost, $main::mesaOFPortDICOM, @tokens);
  } elsif ($trans eq "GEN-SOP-INSTANCES") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::generateSOPInstances($logLevel, $selfTest, "MESAMWL", $main::mesaOFHost, $main::mesaOFPortDICOM, @tokens);
    return 1 if ($rtnValue != 0);
    $rtnValue = mesa::update_scheduling_ORM_message($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "GEN-UNSCHED-SOP-INSTANCES") {
    shift (@tokens);
    $rtnValue = mesa::produceUnscheduledImages($logLevel, $selfTest, @tokens);
  } elsif ($trans eq "MOD-MPPS") {
    shift (@tokens); shift (@tokens);
    $rtnValue = mesa::modifyMPPS($logLevel, $selfTest, @tokens);
  } else {
    die "Unable to process command <$cmd>";
  }

  return $rtnValue;
}


sub processMessage {
  my $cmd = shift(@_);
  my $logLevel = shift(@_);
  my $selfTest = shift(@_);
  my @tokens = split /\s+/, $cmd;
  my $verb = $tokens[0];
  my $trans= $tokens[1];
  my $rtnValue = 0;

  if ($trans eq "RAD-SCHEDULE") {
    # Nothing to do, we are not going to announce this
    $rtnValue = 0;
  } else {
    die "Unable to process command <$cmd>\n";
  }
  return $rtnValue;
}


sub printPatient {
    my $cmd = shift(@_);
    my @tokens = split /\s+/, $cmd;

    my $hl7Msg = "../../msgs/" . $tokens[1];
    my $pid = mesa::getField($hl7Msg, "PID", "3", "0", "Patient ID");
    my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
    print "Patient Name: $patientName \n";
    print "Patient ID:   $pid\n";
    print "\nHit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);
}

#sub localScheduling {
#  my $cmd = shift(@_);
#  my @tokens = split /\s+/, $cmd;
#
#  my $orderFile = $tokens[1];
#  print "Local scheduling for file: $orderFile \n";
#}

sub processOneLine {
# TRANSACTION	14	ID	IM	QUERY	T131	131/cfind_q1
    my ($cmd)  = @_;
    return if $cmd eq "";
    my @verb = split /\s+/, $cmd;
#  print "$verb[0] \n";
    if ($verb[0] eq "TRANSACTION") {
        processTransaction($cmd);
    } elsif ($verb[0] eq "TEXT") {
        printText($cmd);
    } elsif ($verb[0] eq "PATIENT") {
        printPatient($cmd);
    } elsif ($verb[0] eq "MESA-INTERNAL") {
        processMESAInternal($cmd, $main::logLevel, $main::selfTest);
    } elsif ($verb[0] eq "MESSAGE") {
        processMessage($cmd, $main::logLevel, $main::selfTest);
    } elsif (substr($verb[0], 0, 1) eq "#") {
        print "Comment: $cmd \n";
    } else {
        die "Did not recognize verb in command: $cmd \n";
    }
}

sub usage {
    print "Usage: evdcrt_swf [-h] [-s] [-c configfile] <test file> <output level: 0-4> \n";
    print "Runs the test specified by the <test file> with given verbosity level.\n";
    print " <test file> may be path to test script, or numeric name of test (eg. 1701)\n";
    print " -h  Print this help message.\n";
    print " -s  Self test mode.\n";
    print " -c The file defining server configuration (default is \"evdcrt_test.cfg\").\n";
    exit;
}

sub getParams {
    my $configFile = shift;

    my %varnames = mesa::get_config_params($configFile);

    $main::testAE               = $varnames{"TEST_AE"} or die;

    $main::mesaOFHost           = $varnames{"MESA_OF_HOST"} or die;
    $main::mesaOFPortDICOM      = $varnames{"MESA_OF_DICOM_PORT"} or die;
    $main::mesaOFPortHL7        = $varnames{"MESA_OF_HL7_PORT"} or die;
#    $main::mesaOFAE             = $varnames{"MESA_OF_AE"} or die;

    $main::mesaImgMgrHost       = $varnames{"MESA_IMGMGR_HOST"} or die;
    $main::mesaImgMgrPortDICOM  = $varnames{"MESA_IMGMGR_DICOM_PT"} or die;
    $main::mesaImgMgrAE         = $varnames{"MESA_IMGMGR_AE"} or die;

#    $main::mesaModalityHost       = $varnames{"MESA_MODALITY_HOST"} or die;
    $main::mesaModalityPortDICOM  = $varnames{"MESA_MODALITY_PORT"} or die;
#    $main::mesaMODALITYAE         = $varnames{"MESA_MODALITY_AE"} or die;

    if ($main::selfTest) {
# this is for Evidence Creator self test
        print "SELF TEST";
        $main::ECHost           = $varnames{"MESA_EC_HOST"} or die;
        $main::ECPort           = $varnames{"MESA_EC_DICOM_PORT"} or die;
        $main::ECAE             = $varnames{"MESA_EC_AE"} or die;
    } else {
# this is for Evidence Creator production test 
        print "PRODUCTION TEST";
        $main::ECHost           = $varnames{"TEST_EC_HOST"} or die;
        $main::ECPort           = $varnames{"TEST_EC_PORT"} or die;
        $main::ECAE             = $varnames{"TEST_EC_AE"} or die;
    }
}


# Main starts here


use vars qw($opt_h $opt_s $opt_c);
usage() if not getopts("hsc:");
usage() if $opt_h;

#my $runningDir = "$MESA_ROOT/testdata/y3_actor/actors/evdcrt";
#chdir $runningDir;

my $defaultConfigFile = "evdcrt_test.cfg";
my $configFile = $opt_c ? $opt_c : $defaultConfigFile;

my $testName = shift or usage();
$main::logLevel = shift or usage();
$main::selfTest = $opt_s;

getParams($configFile);
my $host = `hostname`; chomp $host;

system "perl scripts/mesa_servers.pl -l $main::logLevel reset";
die "Could not reset servers\n" if ($?);

if ($testName !~ /\.txt$/) {
    $testName =  "../common/$testName/$testName.txt";
# modify for windows?
}

print "opening $testName\n";
open TESTFILE, $testName or die "Could not open: $testName\n";

my $lineNumber = 1;

while (my $l = <TESTFILE>) {
    chomp $l;
    print "$lineNumber $l\n";
    processOneLine($l);
    $lineNumber += 1;
}
close TESTFILE;

goodbye;
