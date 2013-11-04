#!/usr/local/bin/perl -w

# General package for MESA scripts.

use Env;

package mesa;

use File::Copy;
require "announce.pm";
require "evaluate.pm";
require "evaluate_japanese.pm";
require "utilities.pm";
require "mesaget.pm";
require "transactions.pm";
require "evaluate_tfcte.pm";

require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

# Subroutines found in this module:

# create_send_audit 
# clear_syslog_files 
# extract_syslog_messages 
# count_syslog_xml_files 
# evaluate_all_xml_files 
# send_hl7 
# send_hl7_log 
# send_hl7_secure 
# xmit_error 
# send_mpp
# send_mpps_in_progres
# send_mpps_complet
# send_mpps_secur
# local_scheduling_mg 
# local_scheduling_mr 
# local_scheduling_rt 
# send_cfind 
# send_cfind_log 
# send_cfind_mwl 
# create_hash_test_messages 
# read_mesa_sc_messages 
# evaluate_storage_commit_nevents 
# evaluate_cfind_resp 
# send_storage_commit 
# send_storage_commit_naction 
# send_storage_commit_nevent 
# send_cmove_study_uid 
# cstore_file 
# send_image_avail 
# store_images 
# store_images_secure 
# cstore_secure 
# getField 
# setField 
# getDICOMAttribute 
# getDICOMElements 
# create_object_from_template 
# evaluate_hl7 
# construct_mwl_query_pid 
# construct_cfind_query_study 
# construct_cfind_query_patient_name 
# update_scheduling_ORM 
# update_O02 



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
    $dirName =~ s(\/)(\\)g; 
    `del/q $dirName\\*.xml`;
  } else {
    `rm -f $dirName/*.xml`;
  }
}

sub extract_syslog_messages {
 my $osName = $main::MESA_OS;
 $x = "$main::MESA_TARGET/bin/syslog_extract";
 if ($osName eq "WINDOWS_NT") {
    $x =~ s(\/)(\\)g;
 }
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

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 ";

  print "$send_hl7 $target $port $hl7Dir/$msg \n";
  print `$send_hl7 $target $port $hl7Dir/$msg`;

  return 1 if $?;

  return 0;
}

sub send_hl7_log {
  my ($logLevel, $hl7Dir, $msg, $target, $port)  = @_;

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 ";

  $x = "$send_hl7 -l $logLevel ";
  $x .= "-c " if ($logLevel) >= 3;
  $x .= " $target $port $hl7Dir/$msg";
  print "$x\n" if ($logLevel >= 3);
  print `$x`;

  return 1 if $?;

  return 0;
}

sub send_hl7_secure {
  my ($hl7Dir, $msg, $target, $port, $r, $k, $c, $p, $ciphers) = @_;

  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/$r";
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/$k";
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/$c";
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/$p";

  if (! -e ("$hl7Dir/$msg")) {
    print "Message $hl7Dir/$msg does not exist; exiting. \n";
    main::goodbye();
  }

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7_secure -l 4 " .
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers ";

  print "$send_hl7 $target $port $hl7Dir/$msg \n";
  print `$send_hl7 $target $port $hl7Dir/$msg`;

  return 1 if $?;

  return 0;
}

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
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

  $x = "$main::MESA_TARGET/bin/ncreate -a MODALITY1 -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.crt $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Create \n" if ($?);

  $x = "$main::MESA_TARGET/bin/nset    -a MODALITY1 -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.set $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Set \n" if ($?);
}

sub send_mpps_in_progress
{
  my $directoryName   = "$main::MESA_STORAGE/modality/" . shift(@_);
  my $sourceAE        = shift(@_);
  my $destAE   = shift(@_);
  my $destHost = shift(@_);
  my $destPort = shift(@_);

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  #$x = "$main::MESA_TARGET/bin/ncreate -a MODALITY1 -c $destAE " .
  $x = "$main::MESA_TARGET/bin/ncreate -a $sourceAE -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.crt $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Create \n" if ($?);
}

sub send_mpps_in_progress_log
{
  my $logLevel = shift(@_);
  my $directoryName   = "$main::MESA_STORAGE/modality/" . shift(@_);
  my $sourceAE        = shift(@_);
  my $destAE   = shift(@_);
  my $destHost = shift(@_);
  my $destPort = shift(@_);

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  #$x = "$main::MESA_TARGET/bin/ncreate -L $logLevel -a MODALITY1 -c $destAE " .
  $x = "$main::MESA_TARGET/bin/ncreate -L $logLevel -a $sourceAE -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.crt $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Create \n" if ($?);
}

sub send_mpps_in_progress_secure
{
  my ($dir, $sourceAE, $destAE, $destHost, $destPort, $r, $k, $c, $p) = @_;

  my $directoryName   = "$main::MESA_STORAGE/modality/$dir";
  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/$r";
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/$k";
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/$c";
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/$p";

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/ncreate_secure -a MODALITY1 -c $destAE " .
	" -R $randomsFile -K $keyFile -C $certificateFile -P $peerList " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.crt $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Create \n" if ($?);
}

sub send_mpps_complete
{
  my $directoryName   = "$main::MESA_STORAGE/modality/" . shift(@_);
  my $sourceAE        = shift(@_);
  my $destAE   = shift(@_);
  my $destHost = shift(@_);
  my $destPort = shift(@_);

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/nset    -a $sourceAE -c $destAE " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.set $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Set \n" if ($?);
}

sub send_mpps_complete_secure
{
  my ($dir, $sourceAE, $destAE, $destHost, $destPort, $r, $k, $c, $p) = @_;

  my $directoryName   = "$main::MESA_STORAGE/modality/$dir";
  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/$r";
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/$k";
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/$c";
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/$p";

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/nset_secure    -a MODALITY1 -c $destAE " .
	" -R $randomsFile -K $keyFile -C $certificateFile -P $peerList " .
        " $destHost $destPort " .
        " mpps $directoryName/mpps.set $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Set \n" if ($?);
}


sub send_mpps_secure
{
  my $directoryName   = "$main::MESA_STORAGE/modality/" . shift(@_);
  my $sourceAE        = shift(@_);
  my $destAE   = shift(@_);
  my $destHost = shift(@_);
  my $destPort = shift(@_);

# Secure parameters

  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers         = shift(@_);

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/ncreate_secure -a MODALITY1 -c $destAE " .
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

  $x = "$main::MESA_TARGET/bin/nset_secure    -a MODALITY1 -c $destAE " .
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

sub send_gppps_in_progress
{
  my ($logLevel, $directoryPath, $gpppsFile, $sourceAE, $destAE, $destHost, $destPort) = @_;

  open(MPPS_HANDLE, "< $directoryPath/gppps_uid.txt") || die "Could not open GP PPS UID File: $directoryPath/gppps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/ncreate -L $logLevel -a $sourceAE -c $destAE " .
        " $destHost $destPort " .
        " gppps $directoryPath/$gpppsFile $uid ";
  print "$x \n" if ($logLevel >= 3);
  print `$x`;
  die "Could not send GP PPS N-Create \n" if ($?);
}

sub send_gppps_complete
{
  my ($logLevel, $directoryPath, $gpppsFile, $sourceAE, $destAE, $destHost, $destPort) = @_;

  open(MPPS_HANDLE, "< $directoryPath/gppps_uid.txt") || die "Could not open GP PPS UID File: $directoryPath/gppps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  $x = "$main::MESA_TARGET/bin/nset -L $logLevel -a $sourceAE -c $destAE " .
        " $destHost $destPort " .
        " gppps $directoryPath/$gpppsFile $uid ";
  print "$x \n" if ($logLevel >= 3);
  print `$x`;
  die "Could not send GP PPS N-Set \n" if ($?);
}

sub local_scheduling_hd {
  my ($logLevel, $spsLocation, $scheduledAET) = @_;

  $x = "$MESA_TARGET/bin/of_schedule -l $spsLocation -t $scheduledAET -m HD -s STATION1 ordfil";

  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  if ($?) {
    print "Could not schedule MR SPS with command: $x\n";
    return 1;
  }
  return 0;
}

sub local_scheduling_mg {
  my ($logLevel, $spsLocation, $scheduledAET) = @_;


  $x = "$MESA_TARGET/bin/of_schedule -l $spsLocation -t $scheduledAET -m MG -s STATION1 ordfil";

  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  if ($?) {
    print "Could not schedule MR SPS with command: $x\n";
    return 1;
  }
  return 0;
}

sub local_scheduling_mr {
  my ($logLevel, $spsLocation, $scheduledAET) = @_;


  $x = "$MESA_TARGET/bin/of_schedule -l $spsLocation -t $scheduledAET -m MR -s STATION1 ordfil";

  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  if ($?) {
    print "Could not schedule MR SPS with command: $x\n";
    return 1;
  }
  return 0;
}

sub local_scheduling_ct {
  my ($logLevel, $spsLocation, $scheduledAET) = @_;


  $x = "$MESA_TARGET/bin/of_schedule -l $spsLocation -t $scheduledAET -m CT -s STATION1 ordfil";

  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  if ($?) {
    print "Could not schedule CT SPS with command: $x\n";
    return 1;
  }
  return 0;
}

sub local_scheduling_rt {
  my ($logLevel, $spsLocation, $scheduledAET) = @_;

  $x = "$MESA_TARGET/bin/of_schedule -l $spsLocation -t $scheduledAET -m RT -s STATION1 ordfil";

  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  if ($?) {
    print "Could not schedule MR SPS with command: $x\n";
    return 1;
  }
  return 0;
}

sub local_scheduling_us {
  my ($logLevel, $spsLocation, $scheduledAET) = @_;

  $x = "$MESA_TARGET/bin/of_schedule -l $spsLocation -t $scheduledAET -m US -s STATION1 ordfil";

  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  if ($?) {
    print "Could not schedule US SPS with command: $x\n";
    return 1;
  }
  return 0;
}

sub local_scheduling_xa_mpps_trigger {
  my ($logLevel, $spsLocation, $scheduledAET, $SPSCode, $SPSIndex ) = @_;
  print "About to invoke XA scheduling script\n" if ($logLevel >= 3);
  print " This is trigged by MPPS messages   \n" if ($logLevel >= 3);

  my $x = "$MESA_TARGET/bin/mesa_mwl_add_sps -c spsindex $SPSIndex -c mod IVUS -l $logLevel -t $scheduledAET -m XA -s STATION2 ordfil $SPSCode";

  print "$x\n" if ($logLevel >= 3);
  print `$x`;
  return 1 if ($?);
  return 0;
}

sub local_scheduling_xa_mpps_trigger_no_order {
  my ($logLevel, $spsLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID ) = @_;
  print "About to invoke XA scheduling script\n" if ($logLevel >= 3);
  print " This is trigged by MPPS messages   \n" if ($logLevel >= 3);

  my $x = "$MESA_TARGET/bin/mesa_mwl_sps_from_mpps -u \"$universalServiceID\" -c spsindex $SPSIndex -l $logLevel -t $scheduledAET -m XA -s STATION2 ordfil $SPSCode, $mppsDir/mpps.status";


  print "$x\n" if ($logLevel >= 3);
  print `$x`;
  return 1 if ($?);
  return 0;
}

sub local_scheduling_ivus_mpps_trigger {
  my ($logLevel, $spsLocation, $scheduledAET, $SPSCode, $SPSIndex ) = @_;
  print "About to invoke IVUA scheduling script\n" if ($logLevel >= 3);

  my $x = "$MESA_TARGET/bin/mesa_mwl_add_sps -c spsindex $SPSIndex -l $logLevel -t $scheduledAET -m IVUS -s STATION2 ordfil $SPSCode";

  print "$x\n" if ($logLevel >= 3);
  print `$x`;
  return 1 if ($?);
  return 0;
}

sub local_scheduling_ivus_mpps_trigger_no_order {
  my ($logLevel, $spsLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID) = @_;
  print "About to invoke IVUA scheduling script\n" if ($logLevel >= 3);

  my $x = "$MESA_TARGET/bin/mesa_mwl_sps_from_mpps -u \"$universalServiceID\" -c spsindex $SPSIndex -l $logLevel -t $scheduledAET -m IVUS -s STATION2 ordfil $SPSCode $mppsDir/mpps.status";

  print "$x\n" if ($logLevel >= 3);
  print `$x`;
  return 1 if ($?);
  return 0;
}


sub local_scheduling_echo_mpps_trigger_no_order {
  my ($logLevel, $spsLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID) = @_;
  print "About to invoke ECHO scheduling script\n" if ($logLevel >= 3);

  my $x = "$MESA_TARGET/bin/mesa_mwl_sps_from_mpps -u \"$universalServiceID\" -c spsindex $SPSIndex -l $logLevel -t $scheduledAET -m ECHO -s STATION2 ordfil $SPSCode $mppsDir/mpps.status";

  print "$x\n" if ($logLevel >= 3);
  print `$x`;
  return 1 if ($?);
  return 0;
}

sub local_scheduling_echo_mpps_trigger_no_order_with_demographics {
  my ($logLevel, $spsLocation, $scheduledAET, $SPSCode, $SPSIndex, $mppsDir, $universalServiceID, $pid, $patientName) = @_;
  print "About to invoke ECHO scheduling script\n" if ($logLevel >= 3);

  my $x = "$MESA_TARGET/bin/mesa_mwl_sps_from_mpps -D nam $patientName -D patid $pid -u \"$universalServiceID\" -c spsindex $SPSIndex -l $logLevel -t $scheduledAET -m ECHO -s STATION2 ordfil $SPSCode $mppsDir/mpps.status";

  print "$x\n" if ($logLevel >= 3);
  print `$x`;
  return 1 if ($?);
  return 0;
}

# create a general purpose workitem for PWF or RWF
sub local_scheduling_gpworkitem {
  my ($plaOrdNum, $proc, $gpspsFile, $DB) = @_;

  $x = "$main::MESA_TARGET/bin/ppm_sched_gpsps -o \"$plaOrdNum\" " .
       " -p \"$proc\" $DB $gpspsFile";
  if ($main::MESA_OS eq "WINDOWS_NT") {
    $x =~ s(\/)(\\)g;
  }
  print "$x\n";
  print `$x`;
  return 1 if ($?);
  return 0;
}

sub send_cfind {
  my ($cfindFile, $imgMgrAE, $imgMgrHost, $imgMgrPort, $outDir) = @_;

  if( $outDir) {
     $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $imgMgrAE -f $cfindFile " .
         "-o $outDir -x STUDY $imgMgrHost $imgMgrPort ";
  }
  else {
     $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $imgMgrAE -f $cfindFile " .
         "-x STUDY $imgMgrHost $imgMgrPort ";
  }

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
}

sub send_cfind_log {
  my ($logLevel, $cfindFile, $imgMgrAE, $imgMgrHost, $imgMgrPort, $outDir) = @_;

  mesa::delete_directory($logLevel, $outDir);
  mesa::create_directory($logLevel, $outDir);

  $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $imgMgrAE -f $cfindFile " .
      "-o $outDir -x STUDY $imgMgrHost $imgMgrPort ";

  print "$cfindString \n" if ($logLevel >= 3);
  print `$cfindString`;

  return 0;
}

sub send_cfind_secure {
  my ($logLevel, $cfindFile, $imgMgrAE, $imgMgrHost, $imgMgrPort, $outDir,
	$r, $k, $c, $p, $ciphers) = @_;

  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/$r";
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/$k";
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/$c";
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/$p";

  mesa::delete_directory($logLevel, $outDir);
  mesa::create_directory($logLevel, $outDir);

  $cfindString =
	"$main::MESA_TARGET/bin/cfind_secure -a MESA -c $imgMgrAE -f $cfindFile " .
	"-R $randomsFile -K $keyFile -C $certificateFile -P $peerList -Z $ciphers " .
      "-o $outDir -x STUDY $imgMgrHost $imgMgrPort ";

  print "$cfindString \n" if ($logLevel >= 3);
  print `$cfindString`;

  return 0;
}

sub send_cfind_mwl {
  my ($logLevel, $cfindFile, $mwlAE, $mwlHost, $mwlPort, $outDir) = @_;

  print "$cfindFile $mwlAE $mwlHost $mwlPort $outDir\n" if ($logLevel >= 4);

  mesa::delete_directory($logLevel, $outDir) and return 1;
  mesa::create_directory($logLevel, $outDir) and return 1;

  my $cfindString = "$main::MESA_TARGET/bin/cfind -a MODALITY1 -c $mwlAE " .
      "-f $cfindFile -o $outDir -x MWL $mwlHost $mwlPort ";

  my $rtnValue = 0;
  if ($logLevel >= 3) {
    print "$cfindString \n";
    print `$cfindString`;
    $rtnValue = 1 if ($?);
  } else {
    `$cfindString`;
    $rtnValue = 1 if ($?);
  }

  return $rtnValue;
}

sub send_cfind_gpwl {
  my ($logLevel, $cfindFile, $gpwlAE, $gpwlHost, $gpwlPort, $outDir, $callingAETitle) = @_;

  print "$cfindFile $gpwlAE $gpwlHost $gpwlPort $outDir\n" if ($logLevel >= 4);

  mesa::delete_directory($logLevel, $outDir) and return 1;
  mesa::create_directory($logLevel, $outDir) and return 1;

  my $cfindString = "$main::MESA_TARGET/bin/cfind -a $callingAETitle -c $gpwlAE " .
      "-f $cfindFile -o $outDir -x GPWL $gpwlHost $gpwlPort ";

  my $rtnValue = 0;
  if ($logLevel >= 3) {
    print "$cfindString \n";
    print `$cfindString`;
    $rtnValue = 1 if ($?);
  } else {
    `$cfindString`;
    $rtnValue = 1 if ($?);
  }

  return $rtnValue;
}

sub send_cfind_mwl_secure {
  my ($logLevel, $cfindFile, $mwlAE, $mwlHost, $mwlPort, $outDir, $r, $k, $c, $p, $ciphers) = @_;

  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/$r";
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/$k";
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/$c";
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/$p";

  print "$cfindFile $main::mwlAE $main::mwlHost $main::mwlPort $outDir\n" if ($logLevel >= 4);

  mesa::delete_directory($logLevel, $outDir) and return 1;
  mesa::create_directory($logLevel, $outDir) and return 1;

  my $cfindString = "$main::MESA_TARGET/bin/cfind_secure -a MODALITY1 -c $main::mwlAE " .
	"-R $randomsFile -K $keyFile -C $certificateFile -P $peerList -Z $ciphers " .
	"-f $cfindFile -o $outDir -x MWL $main::mwlHost $main::mwlPort ";

  my $rtnValue = 0;
  if ($logLevel >= 3) {
    print "$cfindString \n";
    print `$cfindString`;
    $rtnValue = 1 if ($?);
  } else {
    `$cfindString`;
    $rtnValue = 1 if ($?);
  }

  return $rtnValue;
}

sub create_hash_test_messages {
  my $logLevel = shift(@_);
  my $testAETitle = shift(@_);

  $testDir = "$main::MESA_STORAGE/modality/st_comm/$testAETitle";
  print main::LOG "CTX: $testDir \n" if ($logLevel >= 3);

  opendir TESTDIR, $testDir or die "directory: $testDir not found! Is $testAETitle " .
      "correct for your Storage Commitment SCP?";
  @testFiles = readdir TESTDIR;

  MESSAGE: foreach $message (@testFiles) {
    next MESSAGE if ($message eq ".");
    next MESSAGE if ($message eq "..");

    $z = "$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $testDir/$message";
    print main::LOG  "CTX: $z \n"  if ($logLevel >= 3);
    $x = `$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $testDir/$message`;
    chomp $x;
    next MESSAGE if ($x eq "");

    print ("$x \n") if ($verbose);
    $testMessages{$x} = "$testDir/$message";
  }
  return 0;
}

sub read_mesa_sc_messages {
  $scDir = "$main::MESA_STORAGE/modality/st_comm/MESA";

  opendir SC, $scDir or die "directory: $scDir not found";
  @scMsgs = readdir SC;
  closedir SC;
}

#sub grade_messages () {
#  my $verbose = shift(@_);
#  my $rtnValue = 0;
#
#  MESSAGE: foreach $message (@scMsgs) {
#    next MESSAGE if ($message eq ".");
#    next MESSAGE if ($message eq "..");
#
#    $mesa = "$scDir/$message";
#
#    print main::LOG "$mesa \n";
#
#    $uid = `$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $mesa`;
#    chomp $uid;
#    if ($uid eq "") {
#      print main::LOG "Could not get transaction UID for $mesa \n";
#      $rtnValue = 1;
#      next MESSAGE;
#    }
#
#    print main::LOG "$uid \n";
#
#    $testFile = $testMessages{$uid};
#    if ($testFile eq "") {
#      print main::LOG "No matching vendor file for $uid \n";
#      $rtnValue = 1;
#      next MESSAGE;
#    }
#
#    print main::LOG "$testFile \n";
#
#    $x = "$main::MESA_TARGET/bin/evaluate_storage_commitment $mesa $testFile";
#    print main::LOG "$x\n" if ($verbose);
#
#    print main::LOG `$x`;
#    if ($? != 0) {
#      $rtnValue = 1;
#    }
#  }
#  return $rtnValue;
#}

sub evaluate_storage_commit_nevents {
  my $logLevel = shift(@_);
  # Next values in the input list are the messages to evaluate
  my $rtnValue = 0;

  MESSAGE: foreach $message (@scMsgs) {
    next MESSAGE if ($message eq ".");
    next MESSAGE if ($message eq "..");

    $mesa = "$scDir/$message";

    print main::LOG "CTX: $mesa \n";

    $uid = `$main::MESA_TARGET/bin/dcm_print_element 0008 1195 $mesa`;
    chomp $uid;
    if ($uid eq "") {
      print main::LOG "ERR: Could not get transaction UID for $mesa \n";
      $rtnValue = 1;
      next MESSAGE;
    }

    print main::LOG "CTX: $uid \n" if ($logLevel >= 3);

    $testFile = $testMessages{$uid};
    if ($testFile eq "") {
      print main::LOG "ERR: No matching vendor file for $uid \n";
      $rtnValue = 1;
      next MESSAGE;
    }

    print main::LOG "CTX: $testFile \n";

    $x = "$main::MESA_TARGET/bin/evaluate_storage_commitment $mesa $testFile";
    print main::LOG "CTX: $x\n" if ($logLevel >= 3);

    print main::LOG `$x`;
    if ($? != 0) {
      $rtnValue = 1;
    }
  }
  return $rtnValue;
}

#sub evaluate_mpps_v2 {
#  my ($logLevel, $stdDir, $storageDir, $testNumber)= @_;
#
#  if (! -e($storageDir)) {
#    print main::LOG "MESA storage directory does not exist \n";
#    print main::LOG " Directory is expected to be: $storageDir \n";
#    print main::LOG " Did you invoke the evaluation script with the proper AE title? \n";
#    return 1;
#  }
#
#  open(MPPS_HANDLE, "< $stdDir/mpps_uid.txt") ||
#        die "Could not open MPPS UID File: $stdDir/mpps_uid.txt";
#
#  $mpps_UID = <MPPS_HANDLE>;
#  chomp $mpps_UID;
#  print main::LOG "MPPS UID = $mpps_UID \n" if $verbose;
#
#  if (! -e("$storageDir/$mpps_UID")) {
#    print main::LOG "MESA MPPS directory does not exist \n";
#    print main::LOG " Directory is expected to be: $storageDir/$mpps_UID \n";
#    print main::LOG " This implies you did not forward MPPS messages for these MPPS events.\n";
#    return 1;
#  }
#
#  if (! -e("$storageDir/$mpps_UID/mpps.dcm")) {
#    print main::LOG "MPPS status file does not exist \n";
#    print main::LOG " File is expected to be: $storageDir/$mpps_UID/mpps.dcm \n";
#    print main::LOG " This implies a problem in the MESA software because the directory exists but the\
#file is missing.\n";
#    return 1;
#  }
#
#  $evalString = "$main::MESA_TARGET/bin/mpps_evaluate -l $logLevel ";
#  $evalString .= " mgr $testNumber $storageDir/$mpps_UID/mpps.dcm $stdDir/mpps.status ";
#
#  print main::LOG "$evalString \n";
#
#  print main::LOG `$evalString`;
#
#  return 1 if ($?);
#
#  return 0;
#}


sub evaluate_cfind_resp {
  my ($logLevel, $group, $element, $maskFile, $tstDir, $stdDir) = @_;

  if (! -e($tstDir)) {
    print main::LOG "ERR: Evaluation of C-Find responses failed.\n";
    print main::LOG "ERR: Directory with test messages: $tstDir does not exist.\n";
    return 1;
  }
  if (! -e($stdDir)) {
    print main::LOG "ERR: Evaluation of C-Find responses failed.\n";
    print main::LOG "ERR: Directory with standard messages: $sdtDir does not exist.\n";
    return 1;
  }
  $evalString = "$main::MESA_TARGET/bin/cfind_resp_evaluate ";
  $evalString .= " -v " if ($logLevel >= 3);
  $evalString .= "$group $element $maskFile $tstDir $stdDir";

  print main::LOG "CTX: $evalString \n" if ($logLevel >= 3);

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
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

  $naction = "$main::MESA_TARGET/bin/naction -a MODALITY1 -c $imgMgrAE $imgMgrHost $imgMgrPort commit ";
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

sub send_storage_commit_naction {
  my ($procedureName, $imgMgrAE, $imgMgrHost, $imgMgrPort, $callingAETitle) = @_;
  my $commitUID = "1.2.840.10008.1.20.1.1";

  $naction = "$main::MESA_TARGET/bin/naction -a $callingAETitle -c $imgMgrAE $imgMgrHost $imgMgrPort commit ";

  print "$procedureName \n";

  $nactionExec = "$naction $main::MESA_STORAGE/modality/$procedureName/sc.xxx $commitUID ";

  print "$nactionExec \n";
  print `$nactionExec`;
  if ($?) {
    print "Could not send Storage Commitment N-Action to Image Mgr \n";
    exit 1;
  }
}

sub send_storage_commit_naction_secure {
  my ($procedureName, $imgMgrAE, $imgMgrHost, $imgMgrPort, $r, $k, $c, $p, $ciphers) = @_;

  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/$r";
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/$k";
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/$c";
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/$p";

  my $commitUID = "1.2.840.10008.1.20.1.1";

  $naction = "$main::MESA_TARGET/bin/naction_secure -a MODALITY1 -c $imgMgrAE " .
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers " .
	" $imgMgrHost $imgMgrPort commit ";

  print "$procedureName \n";

  $nactionExec = "$naction $main::MESA_STORAGE/modality/$procedureName/sc.xxx $commitUID ";

  print "$nactionExec \n";
  print `$nactionExec`;
  if ($?) {
    print "Could not send Storage Commitment N-Action to Image Mgr \n";
    exit 1;
  }
}

sub send_storage_commit_nevent {
  my $procedureName = shift(@_);
  my $mesaModalityPort = shift(@_);
  my $commitUID = "1.2.840.10008.1.20.1.1";

  $nevent  = "$main::MESA_TARGET/bin/nevent  -a MESA localhost $mesaModalityPort commit ";
  $neventExec = "$nevent $main::MESA_STORAGE/modality/$procedureName/sc.xxx $commitUID ";
  print "$neventExec \n";
  print `$neventExec`;
  if ($?) {
    print "Could not send Storage Commitment N-Event to MESA modality\n";
    exit 1;
  }
}

sub send_storage_commit_nevent_secure {
  my ($logLevel, $procedureName, $mesaModalityPort, $r, $k, $c, $p, $ciphers) = @_;

  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/$r";
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/$k";
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/$c";
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/$p";
  my $commitUID = "1.2.840.10008.1.20.1.1";

  $nevent  = "$main::MESA_TARGET/bin/nevent_secure  -a MESA" .
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers " .
	" -l $logLevel " .
	" localhost $mesaModalityPort commit ";
  $neventExec = "$nevent $main::MESA_STORAGE/modality/$procedureName/sc.xxx $commitUID ";
  print "$neventExec \n";
  print `$neventExec`;
  if ($?) {
    print "Could not send Storage Commitment N-Event to MESA modality\n";
    exit 1;
  }
}


sub send_cmove_study_uid {
  my ($cmoveFile, $reposAE,$reposHost,$reposPort, $studyUID, $wkstationAE) = @_;
  open UIDFILE, ">uid.txt" or die "Could not open uid.txt to write Study Instance UID\n";
  print UIDFILE "AA 0020 000D $studyUID\n";
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

sub cstore_file {
  my $fileName = shift(@_);
  my $deltaFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  die "In imgmgr::cstore_file, file $fileName does not exist \n" if (! (-e $fileName));

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


sub send_image_avail {
  my $mppsFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);
  my $outDir = shift(@_);

  $cfindString = "$main::MESA_TARGET/bin/cfind_image_avail -a MESA_OF -c $imgMgrAE -o $outDir $imgMgrHost $imgMgrPort $mppsFile";

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
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

  $cmd = "$main::MESA_TARGET/bin/cstore -l 4";

  $cmd .= " -q ";
  $cmd .= " -a $sourceAE";
  $cmd .= " -c $destinationAE";
  if( $deltafile) { $cmd .= " -d $deltafile"}
  if( $noPixels == 1) {
    $cmd .= " -p";
  }

  $cmd .= " $destinationHost $destinationPort";

  $imageDir = "$main::MESA_STORAGE/modality/$procedureName/";

  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(\/)(\\)g;
    $imageDir =~ s(\/)(\\)g;
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

# store_images_absolute_path
#
# like send_images but use cstore application. Cstore allows the specification
# of a "deltafile" to alter the images before sending.
#
#    fullPath is the path of the
#    directory containing all images to be sent. All files in this directory
#    ending in .dcm or .pre (presentation state) will be processed.
#
#    deltafile should be "" if there is not one to apply to the images.
#
sub store_images_absolute_path {
  my $fullPath        = shift(@_);
  my $deltafile       = shift(@_);
  my $sourceAE        = shift(@_);
  my $destinationAE   = shift(@_);
  my $destinationHost = shift(@_);
  my $destinationPort = shift(@_);
  my $noPixels        = shift(@_);

  $cmd = "$main::MESA_TARGET/bin/cstore";

  $cmd .= " -q ";
  $cmd .= " -a $sourceAE";
  $cmd .= " -c $destinationAE";
  if( $deltafile) { $cmd .= " -d $deltafile"}
  if( $noPixels == 1) {
    $cmd .= " -p";
  }

  $cmd .= " $destinationHost $destinationPort";

  $imageDir = $fullPath;

  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(\/)(\\)g;
    $imageDir =~ s(\/)(\\)g;
  }

  opendir IMAGE, $imageDir or die "directory: $imageDir not found!";
  @imageMsgs = readdir IMAGE;
  closedir IMAGE;

  foreach $imageFile (@imageMsgs) {
    if ($imageFile =~ /.dcm/ or $imageFile =~ /.pre/) {
      my $cstoreExec = "$cmd $imageDir/$imageFile";
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

sub store_images_secure {
  my $procedureName   = shift(@_);
  my $deltafile       = shift(@_);
  my $sourceAE        = shift(@_);
  my $destinationAE   = shift(@_);
  my $destinationHost = shift(@_);
  my $destinationPort = shift(@_);
  my $noPixels        = shift(@_);

# Security parameters

  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers         = shift(@_);

  $cmd = "$main::MESA_TARGET/bin/cstore_secure";

  $cmd .= " -q ";
  $cmd .= " -a $sourceAE";
  $cmd .= " -c $destinationAE";
  if( $deltafile) { $cmd .= " -d $deltafile"}
  if( $noPixels == 1) {
    $cmd .= " -p";
  }
  $cmd .=
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers ";

  $cmd .= " $destinationHost $destinationPort";

  $imageDir = "$main::MESA_STORAGE/modality/$procedureName/";
  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(\/)(\\)g;
    $imageDir =~ s(\/)(\\)g;
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


sub cstore_secure {
  my $fileName        = shift(@_);
  my $deltafile       = shift(@_);
  my $sourceAE        = shift(@_);
  my $destinationAE   = shift(@_);
  my $destinationHost = shift(@_);
  my $destinationPort = shift(@_);

# Security parameters

  my $randomsFile     = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile         = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList        = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers         = shift(@_);

  $cmd = "$main::MESA_TARGET/bin/cstore_secure";

  $cmd .= " -q ";
  $cmd .= " -a $sourceAE";
  $cmd .= " -c $destinationAE";
  if( $deltafile) { $cmd .= " -d $deltafile"}
  $cmd .=
	" -R $randomsFile " .
	" -K $keyFile " .
	" -C $certificateFile " .
	" -P $peerList " .
	" -Z $ciphers ";

  $cmd .= " $destinationHost $destinationPort";

  if( $main::MESA_OS eq "WINDOWS_NT") {
    $cmd      =~ s(\/)(\\)g;
  }

  my $cstoreExec = "$cmd $fileName";
  print "$cstoreExec \n";
  print `$cstoreExec`;
  if ($? != 0) {
    print "Could not send image $fileName to Image Manager: $destinationAE\n";
    print "Exiting...\n";
    exit 1;
  }
}

sub getField {
  my $hl7File = shift(@_);
  my $seg     = shift(@_);
  my $field   = shift(@_);
  my $comp    = shift(@_);
  my $fieldName = shift(@_);

  my $x = "$main::MESA_TARGET/bin/hl7_get_value -f $hl7File $seg $field $comp";
#  print "$x\n";
  my $y = `$x`;

  die "Could not get $fieldName from $hl7File \n" if $?;

  chomp $y;
  return $y;
}

sub getHL7Field {
  my ($logLevel, $hl7File, $seg, $field, $comp, $fieldName) = @_;

  my $x = "$main::MESA_TARGET/bin/hl7_get_value -f $hl7File $seg $field $comp";
  print "$x\n" if ($logLevel >= 3);
  my $y = `$x`;

  my $rtnStatus = 0;
  if ($?) {
    print "Could not get $fieldName from $hl7File \n";
    $rtnStatus = 1;
  }

  chomp $y;
  return ($rtnStatus, $y);
}

sub getHL7FieldWithSegmentIndex {
  my ($logLevel, $hl7File, $seg, $segIndex, $field, $comp, $fieldName) = @_;

  my $x = "$main::MESA_TARGET/bin/hl7_get_value -f $hl7File -i $segIndex $seg $field $comp";
  print "$x\n" if ($logLevel >= 3);
  my $y = `$x`;

  my $rtnStatus = 0;
  if ($?) {
    print "Could not get $fieldName in segment $segIndex from $hl7File \n";
    $rtnStatus = 1;
  }

  chomp $y;
  return ($rtnStatus, $y);
}

sub setField {
  my ($logLevel, $msg, $seg, $field, $comp, $fieldName, $val) = @_;

  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $msg " .
        "$seg $field $comp $val";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update $fieldName ($seg $field $compo)\n" if ($?);
  return 0;
}

# Usage: getDICOMAttribute($logLevel, $fileName, $tag)
#	or
#        getDICOMAttribute($logLevel, $fileName, $tag, $sequenceTag)
#	or
#        getDICOMAttribute($logLevel, $fileName, $tag, $sequenceTag, $idx)
# Returns: ($errorCode, $value)
#   where $errorCode = 0 on success, 1 on failure
sub getDICOMAttribute {
  my ($logLevel, $fileName, $tag, $sequenceTag, $idx) = @_;
  my $x;

  if (not -e $fileName) {
      warn "Cannot find file $fileName\n" if $logLevel >= 2;
      return (1, 0);
  }

  if ($sequenceTag) {
      if (! $idx) {
	$idx = 1;
      }
      $x = "$main::MESA_TARGET/bin/dcm_print_element -i $idx -s $sequenceTag $tag $fileName";
  } else {
      $x = "$main::MESA_TARGET/bin/dcm_print_element $tag $fileName";
  }
  print "$x\n" if ($logLevel >= 3);

  my $v = `$x`;
  if ($?) {
      warn "Could not get DICOM attribute $tag from file $fileName " if $logLevel >= 2;
      return (1, 0);
  }
  chomp $v;
  #print "got $v\n";
  return (0, $v);
}

sub getDICOMElements {
# usage: ($errorCode, $value) = getDICOMElements(tag, filename) or
#        ($errorCode, $value) = getDICOMElements(tag, filename, ignorable)
# where ignorable = 1 makes us print no warnings of missing elements.
#     
# returns (errorCode, value) where errorCode = 0 for OK, 1 for missing tag,
# and other values for other errors, as defined in dcm_get_elements.hpp  
# for non-SQ elements, value is of form "xxxx yyyy value"
# for SQ elements, the entire sequence is returned.
#
# you can get rid of the leading tag and get just the value of one element 
# like this:
#        $value =~ s/^\s*[0-9a-f]{4} [0-9a-f]{4}//i;
# (but this won't strip all tag values from sequences)
#
# The tag must be in the form acceptable to dcm_get_elements of the form,
#    group.element[:item][,group.element[:item]...]
# Example: to obtain value of tag 0008 0100 nested inside second item of
# sequence 0040 a043, tag = "0040.a043:2,0008.0100"
#
# Definition of error codes from dcm_get_elements.hpp:
#
#define NO_ERROR 0
#define ELEMENT_DOES_NOT_EXIST 1
#define NO_ERROR_USAGE_PRINTED 2
#define USAGE_ERROR 3
#define MALFORMED_ROOT_ELEMENT 10
#define ITEM_IN_NON_SQ_TAG 11
#define NON_SQ_TAG_NOT_LAST 12
#define UNKNOWN_TAG 13
#define UNKNOWN_ERROR 14
#define ERROR_GETTING_ITEM 15
#define ERROR_GETTING_SEQUENCE 16
#define ERROR_OPENING_FILE 17
    
    my $tag = shift or die "No tag name given";
    my $filename = shift or die "No filename name given";
    my $ignorable = shift;
    $ignorable = 0 if not defined $ignorable;

    my $cmd = "$main::MESA_TARGET/bin/dcm_get_elements -o -s -e $tag $filename";
    if ($ignorable) {
        # add the -i flag to keep it from outputting error.
        $cmd =~ s/elements -o/elements -i -o/;
    }
# redirect output to /dev/null (will this work for Windows?)
#    if ($main::MESA_OS eq "WINDOWS_NT") {
      print "$cmd > zzz.txt\n";
      `$cmd > zzz.txt`;
      open DGE, "< zzz.txt";
#    } else {
#      my $pid = open(DGE, "$cmd 2>/dev/null |");
#    }
# get the whole output
    my $savedSeparator = $/;
    undef $/;
    my $output = <DGE>;
    $/ = $savedSeparator;
    close(DGE);

    my $errorCode = $? >> 8;
    return ($errorCode, $output);
}

# usage: ($errorCode, $value) = getSingleDICOMElement(tag, filename) or
#        ($errorCode, $value) = getSingleDICOMElement(tag, filename, ignorable)
# a convenience function which returns the dicom element value with the 
# tag values stripped.  Works only for one non-sequence element.  For instance,
# calling getDICOMElement might return "0008 1195 1.113654.5.21.1267" and
# calling getSingleDICOMElement will return "1.113654.5.21.1267"
sub getSingleDICOMElement {
    my $tag = shift or die "No tag name given";
    my $filename = shift or die "No filename name given";
    my $ignorable = shift;
    $ignorable = 0 if not defined $ignorable;

    my ($errorCode, $value) = getDICOMElements(@_);
    if (not $errorCode) {
        $value =~ s/^\s*[0-9a-f]{4} [0-9a-f]{4}//i;
    }
    return ($errorCode, $value);
}

# usage:
#   $newElements = add_object_elements_to_template(elements, fromObject)
# or
#   $newElements = add_object_elements_to_template(elements, fromObject, verboseFlag)
#
# Modifies a series of elements based on values in an existing dicom object (fromObject).  
# The return value is a new-line delimited string which may then be fed into 
# add_object_elements_to_template to produce a dicom object on disk.
# This function is particularly useful in creating MPPS files whose element 
# values need to be supplied by the values of an existing object.
#
# the elements variable is a scalar string of newline-delimited values describing the
# elements which need to be created.  It is generally of the format which will be input
# to dcm_create_objects.  Fields enclosed in brackets specify tags to be looked up in
# the fromObject.  Generally,
#
#   [outTAG <inTAG [T1 | T2 | T3 | S2]> | [outTAG] value] [// comments]
#
# Or, for instance,
#
#   0020 000D <0021.000D>            // Study Instance UID 
#
# will create an element (tag = 0020 000D) in the outputObject whose value is the
# value of the element (tag = 0021 000D) in the fromObject.  The format of the inTAG 
# is as must be passed to dcm_get_elements (see comments for mesa::getDICOMElements
# above); it allows for unambiguous specification of sequences. 
#
# Comments beginning with "//" (as above) are stripped here and ignored.
#
# If the inTAG above were to be a sequence, the sequence would be expanded fully (including
# all its containing sequences and elements) in a format which is acceptable to 
# dcm_create_object.
#
# MISSING TAGS
# If an inTAG (eg. 0021 000D) is not found an error will be reported unless the behavior
# is modified by one of the TYPE tags below.
# T1 -- (Type 1 value) Report an error if the value is missing (default behavior)
# T2 -- (Type 2 value) No error if value is missing, but put in an empty element if it is.
# S2 -- (Type 2 value, sequence) No error if value is missing, but put in an empty
#       sequence if it is.
# T3 -- (Type 3 value) No error if value is missing.  Do not put in element if missing.
# 
#
# An explicit value may also be supplied instead of the inTAG; in fact, anything not
# enclosed in brackets will be passed verbatim to dcm_create_object.
#
# Here is an example elements string:
#
#  0040 0270  (                  // Scheduled Step Attributes Sequence
#    0020 000D <0020.000D>            // Study Instance UID 
#    0008 1110  ####                 // References Study Sequence
#    0008 0050  #                    // Accession Number
#    0040 1001 <0040.0275,0040.1001>  // Requested Procedure ID
#    0032 1060 <0040.0275,0032.1060  T2> // Requested Procedure Description
#  )
#  0040 0260 <0040.0260 S2>// Peformed Protocol Code Sequence 
#
# ERROR VALUES:
#
# Execute add_object_elements_to_template within an eval block.  This will trap die's
# and put in the error message in $@.  For instance,
#
# eval {
#   $newElements = add_object_elements_to_template($e, $f);
# };
# if ($@) {
#   warn "The following error occured: $@\n";
# }
# 
sub add_object_elements_to_template {

    my $elements = shift or die "Elements not given\n";
    my $inFile = shift or die "Image filename not given.\n";
    my $verbose = shift or $verbose = 0;

# outTAG is in format of dcm_create_object
# optional inTAG is in format of dcm_get_elements (eg. xxxx.yyyy:z,aaaa.bbbb)
# inTag's without the IGNORABLE tag will cause an error if not found in inFile.

    my @tags = split "\n", $elements; 

# Now we need to take the above and process to make an input structure
# fit for dcm_create_object to accept.  We need to replace values in
# brackets with values from the image file.
    my (@object, $line);

    while (defined ($line = shift @tags)) {
        $line =~ s(\/\/.*$)(); # take off comments
        $line =~ s/\s+$//; # take off trailing whitespace    
        next if $line eq "";
        if ($line =~ /<(.+)>/) {
            $imageTag = $1;
        } else {   
            push @object, $line;
#            print "Adding $line\n" if $verbose;
            next;
        }

        if ($imageTag =~ /(T1|T2|S2|T3)/) {
            $typeTag = $1;
            $imageTag =~ s/$typeTag//;
        } else {
            $typeTag = "T1";
        }
        my ($errorCode, $value) = getDICOMElements($imageTag, $inFile, 1);
        if ($errorCode == 1) {
            if ($typeTag eq "T1") {
                die "Required tag $imageTag not found in file $inFile.\n";
            } elsif ($typeTag eq "T2") {
                print "Type 2 element not found, inserting empty element.\n" if $verbose;
                $value = "#";
            } elsif ($typeTag eq "S2") {
                print "Type 2 element not found, inserting empty sequence.\n" if $verbose;
                $value = "####";
            } elsif ($typeTag eq "T3") {
                print "Type 3 element not found.  Continuing.\n" if $verbose;
                next;
            }
            $errorCode = 0;
        }
        die "Error ($errorCode) parsing line $line in $inFile\n" if $errorCode;

# Get rid of leading tag and trailing whitespace in value
        $value =~ s/^\s*[0-9a-f]{4} [0-9a-f]{4}//i;
        $value =~ s/\s+$//;

# insert value into line
        $line =~ s/<.+>/$value/;
        push @object, $line;
        print "Added $line\n" if $verbose;
    }
    return join "\n", @object;
}

# usage:
#   create_object_from_template(template, outputFile)
# or
#   create_object_from_template(template, outputObject, verboseFlag)
#
sub create_object_from_template {
    my $template = shift or die "Template not given\n";
    my $outFile = shift or die "Output filename not specified\n";
    my $verbose = shift or $verbose = 0;

    my $cmd = "$main::MESA_TARGET/bin/dcm_create_object $outFile";
# dcm_create_object will take input from STDIN
    open CREATE, "| $cmd" or die "Cannot execute $cmd";

    print "INPUT INTO \"$cmd\":\n" if $verbose; 
    print $template if $verbose;
    print CREATE $template; 
    close CREATE or die "Error in dcm_modify_object: $!\n";
}

# Updates a DICOM object
sub update_DICOM_object {
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
 return 0;
}

# Updates a DICOM object
sub update_DICOM_object_debug {
 my $logLevel = shift(@_);
 my $inFile = shift(@_);
 my $deltaFile = shift(@_);

 my $outFile = $inFile . ".xxx";

 my $x = "$main::MESA_TARGET/bin/dcm_modify_object -i $deltaFile $inFile $outFile";
 print "$x \n" if ($logLevel >= 3);
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
 return 0;
}

sub evaluate_hl7 {
  my $logLevel = shift(@_);
  my $verbose = shift(@_);
  my $stdDir  = shift(@_);
  my $stdMsg  = shift(@_);
  my $testDir = shift(@_);
  my $testMsg = shift(@_);
  my $formatFile = shift(@_);
  my $iniFile = shift(@_);
  my $rtnValue = 0;

  print main::LOG "CTX: $stdMsg $testMsg \n";

  my $pathStd = "$stdDir/$stdMsg";
  my $pathTest = "$testDir/$testMsg";

  my $evaluateCmd = "$main::MESA_TARGET/bin/hl7_evaluate ";
  $evaluateCmd .= " -l $logLevel ";
  $evaluateCmd .= " -b $main::MESA_TARGET/runtime -m $formatFile $pathTest";

  print main::LOG "CTX: $evaluateCmd \n" if ($logLevel >= 3);
  print main::LOG `$evaluateCmd`;
  $rtnValue = 1 if ($?);

  my $compareCmd = "$main::MESA_TARGET/bin/compare_hl7 ";
  $compareCmd .= " -l $logLevel ";
  $compareCmd .= " -b $main::MESA_TARGET/runtime -m $iniFile $pathStd $pathTest";

  print main::LOG "CTX: $compareCmd \n" if ($logLevel >= 3);
  print main::LOG `$compareCmd`;

  $rtnValue = 1 if ($?);

  return $rtnValue;
}

sub construct_mwl_query_pid {
  my $logLevel  = shift(@_);
  my $templateFile = shift(@_);
  my $temporaryTxt = shift(@_);
  my $outputDCM    = shift(@_);
  my $pid          = shift(@_);
  my @lineArray;

  if (! -e $templateFile) {
    print "mesa::construct_mwl_query_pid: Template file $templateFile does not exist\n";
    return 1;
  }

  open (TPL, $templateFile ) || die "mesa::construct_mwl_query_pid: Could not open template file: $templateFile";
  my @fileHandle = <TPL>;
  foreach my $line (@fileHandle) { 
    if ($line =~ m/0010 0020 #/) {
        $line =~ s/0010 0020 #/0010 0020 $pid/;
    }
    push @lineArray,$line;
  }
  close TPL;

  open (TMP, ">$temporaryTxt" ) || die "mesa::construct_mwl_query_pid: Could not open temp txt file: $temporaryTxt";
  print TMP @lineArray;
  close TMP;
#  undef @lineArray;

  my $rtnValue = 0;
  my $x = "$main::MESA_TARGET/bin/dcm_create_object -i $temporaryTxt $outputDCM";
  if ($logLevel >= 3) {
    print "$x \n";
    print `$x`;
    $rtnValue = 1 if ($?);
  } else {
    `$x`; 
    $rtnValue = 1 if ($?);
  }

  print "mesa:: construct_mwl_query_pid: unable to create output DICOM object\n" if ($rtnValue == 1);
  return $rtnValue;
}

sub construct_mwl_query_key {
  my $logLevel  = shift(@_);
  my $templateFile = shift(@_);
  my $temporaryTxt = shift(@_);
  my $outputDCM    = shift(@_);
  my $event    =  shift(@_);
  my $key          = shift(@_);
  my @lineArray;

  if (! -e $templateFile) {
    print "mesa::construct_mwl_query_pid: Template file $templateFile does not exist\n";
    return 1;
  }

  open (TPL, $templateFile ) || die "mesa::construct_mwl_query_key: Could not open template file: $templateFile";
  my @fileHandle = <TPL>;
  foreach my $line (@fileHandle) { 
    if ($event =~ /MWL_MOD/) {
     # if ($line =~ m/0008 0060 #/) {
        $line =~ s/0008 0060 #/0008 0060 $key/;
    }elsif ($event =~ /MWL_AETITLE/) {
        $line =~ s/0040 0001 #/0040 0001 $key/;
    }
    push @lineArray,$line;
  }
  close TPL;

  open (TMP, ">$temporaryTxt" ) || die "mesa::construct_mwl_query_pid: Could not open temp txt file: $temporaryTxt";
  print TMP @lineArray;
  close TMP;

#  undef @lineArray;
#  open (TMP, "> $temporaryTxt" ) || die "mesa::construct_mwl_query_key: Could not create temp txt file: $temporaryTxt";
#  while ($l = <TPL>) {
#    print TMP $l;
#  }
#  print TMP "\n";
#  close TPL;
#  if ($event =~ /MWL_MOD/) {
#     print TMP "0040 0100 ( \n" .
#	" 0008 0060 $key // Key \n" .
#	") \n";  
#  }elsif ($event =~ /MWL_AETITLE/) {
#     print TMP "0040 0001 ( \n" .
#	" 0008 0060 $key // Key \n" .
#	") \n";  
#  }else {
#     print "mesa::construct_mwl_query_key: Unrecognized event - $event \n";
#     return 1;
#  }
#  close TMP;

  my $rtnValue = 0;
  my $x = "$main::MESA_TARGET/bin/dcm_create_object -i $temporaryTxt $outputDCM";
  if ($logLevel >= 3) {
    print "$x \n";
    print `$x`;
    $rtnValue = 1 if ($?);
  } else {
    `$x`; 
    $rtnValue = 1 if ($?);
  }

  print "mesa:: construct_mwl_query_key: unable to create output DICOM object\n" if ($rtnValue == 1);
  return $rtnValue;
}

sub construct_cfind_query_study {
  my ($logLevel, $templateFile, $temporaryTxt, $outputDCM, $studyInstanceUID) = @_;

  if (! -e $templateFile) {
    print "mesa::construct_cfind_query_study: Template file $templateFile does not exist\n";
    return 1;
  }

  open (TPL, $templateFile ) || die "mesa::construct_cfind_query_study: Could not open template file: $templateFile";
  open (TMP, "> $temporaryTxt" ) || die "mesa::construct_cfind_query_study: Could not create temp txt file: $temporaryTxt";
  while ($l = <TPL>) {
    print TMP $l;
  }
  close TPL;
  print TMP "0020 000D $studyInstanceUID // Study Instance UID \n";
  close TMP;

  my $rtnValue = 0;
  my $x = "$main::MESA_TARGET/bin/dcm_create_object -i $temporaryTxt $outputDCM";
  if ($logLevel >= 3) {
    print "$x \n";
    print `$x`;
    $rtnValue = 1 if ($?);
  } else {
    `$x`; 
    $rtnValue = 1 if ($?);
  }

  print "mesa:: construct_cfind_query_study: unable to create output DICOM object\n" if ($rtnValue == 1);
  return $rtnValue;
}

sub construct_cfind_query_patient_name {
  my ($logLevel, $templateFile, $temporaryTxt, $outputDCM, $patientName) = @_;

  if (! -e $templateFile) {
    print "mesa::construct_cfind_query_patient_name: Template file $templateFile does not exist\n";
    return 1;
  }

  open (TPL, $templateFile ) || die "mesa::construct_cfind_query_patient_name: Could not open template file: $templateFile";
  open (TMP, "> $temporaryTxt" ) || die "mesa::construct_cfind_query_patient_name: Could not create temp txt file: $temporaryTxt";
  while ($l = <TPL>) {
    print TMP $l;
  }
  close TPL;
  print TMP "0010 0010 $patientName // Patient Name \n";
  close TMP;

  my $rtnValue = 0;
  my $x = "$main::MESA_TARGET/bin/dcm_create_object -i $temporaryTxt $outputDCM";
  if ($logLevel >= 3) {
    print "$x \n";
    print `$x`;
    $rtnValue = 1 if ($?);
  } else {
    `$x`; 
    $rtnValue = 1 if ($?);
  }

  print "mesa:: construct_cfind_query_patient_name: unable to create output DICOM object\n" if ($rtnValue == 1);
  return $rtnValue;
}

sub update_scheduling_ORM {
  my ($logLevel, $hl7ORM, $modDirectory) = @_;

  print "CTX: update_scheduling_ORM $hl7ORM, $modDirectory\n" if ($logLevel >= 3);

  # Update Accession Number, OBR 18
  my $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0050 $modDirectory/x1.dcm";
  print "CTX: $x\n" if ($logLevel) >= 3;
  my $y = `$x`;
  die "Could not get accession number out of $modDirectory/x1.dcm" if ($?);
  chomp $y;

  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM " .
        "OBR 18 0 $y";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Accession Number (OBR 18)\n" if ($?);
  chomp $y;

  # Update Requested Procedure ID, OBR 19
  $x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 1001 $modDirectory/mpps.status";
  print "CTX: $x\n" if ($logLevel) >= 3;
  $y = `$x`;
  die "Could not get Requested Procedure ID out of $modDirectory/mpps.status" if ($?);
  chomp $y;

  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM " .
        "OBR 19 0 $y";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Requested Procedure ID (OBR 19)\n" if ($?);

  # Update Scheduled Procedure Step ID, OBR 20
  $x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $modDirectory/mpps.status";
  print "CTX: $x\n" if ($logLevel) >= 3;
  $y = `$x`;
  die "Could not get Scheduled Procedure Step ID out of $modDirectory/mpps.status" if ($?);
  chomp $y;

  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM " .
        "OBR 20 0 $y";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Scheduled Procedure Step ID (OBR 20)\n" if ($?);

  # Update Study Instance UID
  $x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0020 000D $modDirectory/mpps.status";
  print "CTX: $x\n" if ($logLevel) >= 3;
  $y = `$x`;
  die "Could not get Study Instance UID out of $modDirectory/mpps.status" if ($?);
  chomp $y;

  my $z = "^100^Application^DICOM";
  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM ZDS  1 0 $y$z";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Study Instance UID (ZDS 1)\n" if ($?);

  return 0;
}

sub update_scheduling_ORM_message {
  my ($logLevel, $selfTest, $src, $dest, $event, $hl7ORM, $modDirectory) = @_;

  $hl7ORM = "../../msgs/$hl7ORM";
  $modDirectory = "$main::MESA_STORAGE/modality/$modDirectory";

  print "CTX: update_scheduling_ORM $hl7ORM, $modDirectory\n" if ($logLevel >= 3);

  # Update Accession Number, OBR 18
  my $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0050 $modDirectory/x1.dcm";
  print "CTX: $x\n" if ($logLevel) >= 3;
  my $y = `$x`;
  die "Could not get accession number out of $modDirectory/x1.dcm" if ($?);
  chomp $y;

  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM " .
        "OBR 18 0 $y";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Accession Number (OBR 18)\n" if ($?);
  chomp $y;

  # Update Requested Procedure ID, OBR 19
  $x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 1001 $modDirectory/mpps.status";
  print "CTX: $x\n" if ($logLevel) >= 3;
  $y = `$x`;
  die "Could not get Requested Procedure ID out of $modDirectory/mpps.status" if ($?);
  chomp $y;

  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM OBR 19 0 $y";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Requested Procedure ID (OBR 19)\n" if ($?);

  # Update Scheduled Procedure Step ID, OBR 20
  $x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0040 0009 $modDirectory/mpps.status";
  print "CTX: $x\n" if ($logLevel) >= 3;
  $y = `$x`;
  die "Could not get Scheduled Procedure Step ID out of $modDirectory/mpps.status" if ($?);
  chomp $y;

  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM OBR 20 0 $y";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Scheduled Procedure Step ID (OBR 20)\n" if ($?);

  # Update Study Instance UID
  $x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0020 000D $modDirectory/mpps.status";
  print "CTX: $x\n" if ($logLevel) >= 3;
  $y = `$x`;
  die "Could not get Study Instance UID out of $modDirectory/mpps.status" if ($?);
  chomp $y;

  my $z = "^100^Application^DICOM";
  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM ZDS  1 0 $y$z";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Study Instance UID (ZDS 1)\n" if ($?);

  return 0;
}

sub update_scheduling_ORM_post_procedure {
  my ($logLevel, $hl7ORM, $modDirectory, $accessionNum, $requestedProcedureID, $scheduledProcedureStepID) = @_;

  print "CTX: update_scheduling_ORM $hl7ORM, $modDirectory\n" if ($logLevel >= 3);

  # Update Accession Number, OBR 18
  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM " .
        "OBR 18 0 $accessionNum";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Accession Number (OBR 18)\n" if ($?);

  # Update Requested Procedure ID, OBR 19
  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM " .
        "OBR 19 0 $requestedProcedureID";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Requested Procedure ID (OBR 19)\n" if ($?);

  # Update Scheduled Procedure Step ID, OBR 20
  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM " .
        "OBR 20 0 $scheduledProcedureStepID";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Scheduled Procedure Step ID (OBR 20)\n" if ($?);

  # Update Study Instance UID
  $x = "$main::MESA_TARGET/bin/dcm_print_element -s 0040 0270 0020 000D $modDirectory/mpps.status";
  print "CTX: $x\n" if ($logLevel) >= 3;
  $y = `$x`;
  die "Could not get Study Instance UID out of $modDirectory/mpps.status" if ($?);
  chomp $y;

  my $z = "^100^Application^DICOM";
  $x = "$main::MESA_TARGET/bin/hl7_set_value -a -f $hl7ORM ZDS  1 0 $y$z";

  print "CTX: $x\n" if ($logLevel >= 3);
  print `$x`;
  die "Could not update Study Instance UID (ZDS 1)\n" if ($?);

  return 0;
}

sub update_O02 {
  my ($logLevel, $hl7_O02, $hl7_O01) = @_;

  print "CTX: update_O02 $hl7_O02, $hl7_O01\n" if ($logLevel >= 3);

  # Update Filler Order Number
  my $fillerOrderNumber = mesa::getField($hl7_O01, "ORC", "3", "0", "Filler Order Number");

  mesa::setField($logLevel, $hl7_O02, "ORC", "3", "0", "Filler Order Number", $fillerOrderNumber);
  mesa::setField($logLevel, $hl7_O02, "OBR", "3", "0", "Filler Order Number", $fillerOrderNumber);

  return 0;
}

sub update_Status_ORM {
  my ($logLevel, $hl7Status, $hl7OriginalOrder) = @_;

  print "CTX: update_Status_ORM $hl7Status, $hl7OriginalOrder\n" if ($logLevel >= 3);

  # Update Placer Order Number
  my $placerOrderNumber = mesa::getField($hl7OriginalOrder, "ORC", "2", "0", "Placer Order Number");

  mesa::setField($logLevel, $hl7Status, "ORC", "2", "0", "Placer Order Number", $placerOrderNumber);
  mesa::setField($logLevel, $hl7Status, "OBR", "2", "0", "Placer Order Number", $placerOrderNumber);

  return 0;
}

# Usage: getRequestedProcedureID ($logLevel, $dbName)
# Returns: ($errorCode, $value)
#   where $errorCode = 0 on success, 1 on failure
sub getRequestedProcedureID {
  my ($logLevel, $dbName) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName req_proc_id";
  my $rtnStatus = 0;
  print "$x\n" if ($logLevel >= 3);

  my $y = `$x`;
  $rtnStatus = 1 if ($?);
  chomp $y;

  return ($rtnStatus, $y);
}

# Usage: getSPSID ($logLevel, $dbName)
# Returns: ($errorCode, $value)
#   where $errorCode = 0 on success, 1 on failure
sub getSPSID {
  my ($logLevel, $dbName) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName sps_id";
  my $rtnStatus = 0;
  print "$x\n" if ($logLevel >= 3);

  my $y = `$x`;
  $rtnStatus = 1 if ($?);
  chomp $y;

  return ($rtnStatus, $y);
}

sub getMESAVersion {
  open(H, "< $main::MESA_TARGET/runtime/version.txt") || return "Unable to open $main::MESA_TARGET/runtime/version.txt";

  my $ v = <H>;
  chomp $v;
  return $v;
}

# Create a DICOM GPPPS message set from another GPPPS message set.
# This is for status updates.
# 1 - logLevel
# 2 - output directory
# 3 - template file
# 4 - input directory (with GPPPS messages)
# 5 - database name

sub create_gppps_status_ncreate_from_gppps {

  my ($logLevel, $outDir, $templateFile, $inDir, $dbName) = @_;
  print "MESA::create_gppps_status_ncreat_from_gppps $outDir $templateFile $inDir $dbName \n" if ($logLevel >= 3);

  # General Purpose PPS Relationship
  # Remove 0040 4016 Ref General Purpose Scheduled Procedure
  # Step Sequence, this is an unscheduled step
  $x = "$main::MESA_TARGET/bin/dcm_rm_element 0040 4016 $inDir/gppps.crt $outDir/gppps.tmp";
  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  return 1 if ($?);

  open DELTA, ">$outDir/delta_ncreate.txt";
  # General Purpose PPS Relationship
  ($x, $accessionNumber) = mesa::getDICOMAttribute($logLevel, "$inDir/gppps.crt", "0008 0050", "0040 A370");
  if ($x != 0 || $accessionNumber eq "") {
    print "Unable to get Accession Number (0040 A370) 0008 0050 from $inDir/gppps.crt\n";
    print "This is a MESA programming error; please log a bug report.\n";
  }
  print DELTA "// General Purposed Performed Procedure Step Relationship \n";
  print DELTA "0040 A370 (\t//Referenced Request Sequence\n";
  print DELTA " 0008 0050 $accessionNumber\t//Accession Number\n";
  print DELTA ")\n";

  # General Purpose PPS Information
  $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName pps";
  if ($logLevel >= 3) {
    print "$x\n";
    $y = `$x`;
  } else {
    $y = `$x`;
  }
  return 1 if ($?);
  chomp $y;

  print DELTA "0040 0253 $y\t//Performed Procedure Step ID\n";

  $ppsStartDate = dateDICOM();
  $ppsStartTime = timeDICOM();
  print DELTA "0040 0244 $ppsStartDate\t//PPS Start Date\n";
  print DELTA "0040 0245 $ppsStartTime\t//PPS Start Time\n";

  close DELTA;
  $x = "$main::MESA_TARGET/bin/dcm_modify_object -i $outDir/delta_ncreate.txt $outDir/gppps.tmp $outDir/gppps.crt";
  print "$x\n" if ($logLevel >= 3);
  `$x`;
  return 1 if ($?);

  $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName sop_inst_uid";
  $y = `$x`; chomp $y;
  open  GPPPSUID, ">$outDir/gppps_uid.txt" or return 1;
  print GPPPSUID "$y\n";
  close GPPPSUID;

#  $x = "$main::MESA_TARGET/bin/dcm_modify_object -i $outDir/delta.txt $templateFile $outDir/gppps.status";
#  print "$x\n" if ($logLevel >= 3);
#  `$x`;
#  return 1 if ($?);

  return 0;
}

# Create a DICOM GPPPS N-Set message from another GPPPS N-Set message.
# This is for status updates.
# 1 - logLevel
# 2 - output directory
# 3 - template file
# 4 - input directory (with GPPPS messages)
# 5 - database name

sub create_gppps_status_nset_from_gppps {

  my ($logLevel, $outDir, $templateFile, $inDir, $dbName) = @_;
  print "MESA::create_gppps_status_nset_from_gppps $outDir $templateFile $inDir $dbName \n" if ($logLevel >= 3);

  open DELTA, ">$outDir/delta_nset.txt";

  # General Purpose PPS Information
  print DELTA "// General Purpose PPS Information\n";

  $ppsEndDate = dateDICOM();
  $ppsEndTime = timeDICOM();
  print DELTA "0040 0250 $ppsStartDate\t//PPS End Date\n";
  print DELTA "0040 0251 $ppsStartTime\t//PPS End Time\n";

  close DELTA;
  $x = "$main::MESA_TARGET/bin/dcm_modify_object -i $outDir/delta_nset.txt $templateFile $outDir/gppps.set";
  print "$x\n" if ($logLevel >= 3);
  `$x`;
  return 1 if ($?);

  $x = "$main::MESA_TARGET/bin/dcm_modify_object -i $outDir/delta_nset.txt $outDir/gppps.crt $outDir/gppps.status";
  print "$x\n" if ($logLevel >= 3);
  `$x`;
  return 1 if ($?);

  return 0;
}

sub dateDICOM {
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

  $y = $year+1900;
  $m = $mon + 1;
  $d = $mday;

  $rtnDate = "$y";
  $monthDay = ($m * 100) + $d;
  $rtnDate .= "0" if ($monthDay < 1000);
  $rtnDate .= "$monthDay";
  return $rtnDate;
}

sub timeDICOM {
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

  my $rtnTime = "";
  my $hourMinute = ($hour * 100) + $min;
  $rtnTime .= "0" if ($hour < 10);
  $rtnTime .= "$hourMinute";
  return $rtnTime;
}

sub schedule_mr {
}

sub newTransactionUID {
  my ($logLevel, $dbName, $inputFile, $outputFile) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName transact_uid";
  print "$x\n" if ($logLevel >= 3);

  my $y = `$x`;
  return (1, "") if ($?);
  chomp $y;

  return (0, $y);
}

sub updateTransactionUID {
  my ($logLevel, $inputFile, $uidTextFile, $tmpFile, $outputFile) = @_;

  open U, "< $uidTextFile" || return 1;
  my $uid = <U>;
  chomp $uid;

  open(H, "> $tmpFile") || return 1;
  print H "0008 1195 $uid\n";
  close H;

  my $x = "$main::MESA_TARGET/bin/dcm_modify_object -i $tmpFile $inputFile $outputFile";
  print "$x\n" if ($logLevel >= 3);
  `$x`;
  return 1 if ($?);
  return 0;
}

sub generateSOPInstances {
  my ($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;
  print "mesa::generateSOPInstances\n" if ($logLevel >= 3);

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  my $rtnValue = 0;
  $outputDir = "$main::MESA_STORAGE/modality/$outputDir";

  print "$pid $patientName $procedureCode $modality $outputDir" if ($logLevel >= 3);

  print "Removing previous data (if any) in $outputDir\n" if ($logLevel >= 3);
  mesa::delete_directory($logLevel, $outputDir);
  print "Now, create an empty output directory\n" if ($logLevel >= 3);
  mesa::create_directory($logLevel, $outputDir);
  mesa::delete_directory($logLevel, "mwl/results");
  mesa::create_directory($logLevel, "mwl/results");

  if (! (-e "mwl/mwlquery.txt") ) {
    print "The file mwl/mwlquery.txt does not exist; MESA distribution error\n";
    die   "Please log a bug report.";
  }
  `$main::MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery.txt mwl/mwlquery.dcm`;
  die "Unable to create mwl/mwlquery.dcm; runtime problem or permission error." if ($?);

  open PIDFILE, ">pid.txt" or die "Could not open pid.txt to write patient ID";
  print PIDFILE "0010 0020 $pid\n";
  close PIDFILE;

  open MWLOUTPUT, ">mwlquery.out";
  my $x = "$main::MESA_TARGET/bin/mwlquery -a $scheduledAET -c $mwlAE -d pid.txt -f mwl/mwlquery.dcm -o mwl/results $mwlHost $mwlPort";
  print "$x\n" if ($logLevel >= 3);
  print MWLOUTPUT `$x`;
  die "Unable to obtain MWL from $mwlHost at port $mwlPort with AE title $mwlAE" if ($?);

  my $modName = "MESA_MOD";
  $x = "$MESA_TARGET/bin/mod_generatestudy -m $modality  -p $pid " .
	" -s $SPSCode -c $PPSCode " .
	" -i $MESA_STORAGE/modality/$inputDir -t $outputDir " .
	" -y mwl/results " .
	" -z \"IHE Protocol 1\" ";

  open  STUDYOUT, ">generatestudy.out";
  print STUDYOUT "$x\n";
  print STUDYOUT `$x`;

  if ($?) {
    print "Unable to produce unscheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    die;
  }
  return 0;
}

sub generateSOPInstancesSecure {
  my ($logLevel, $selfTest, $actorFlag, $mwlAE, $mwlHost, $mwlPort, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;
  print "mesa::generateSOPInstances\n" if ($logLevel >= 3);

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  my $rtnValue = 0;
  $outputDir = "$main::MESA_STORAGE/modality/$outputDir";

  print "$pid $patientName $procedureCode $modality $outputDir" if ($logLevel >= 3);

  print "Removing previous data (if any) in $outputDir\n" if ($logLevel >= 3);
  mesa::delete_directory($logLevel, $outputDir);
  print "Now, create an empty output directory\n" if ($logLevel >= 3);
  mesa::create_directory($logLevel, $outputDir);
  mesa::delete_directory($logLevel, "mwl/results");
  mesa::create_directory($logLevel, "mwl/results");

  if (! (-e "mwl/mwlquery.txt") ) {
    print "The file mwl/mwlquery.txt does not exist; MESA distribution error\n";
    die   "Please log a bug report.";
  }
  `$main::MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery.txt mwl/mwlquery.dcm`;
  die "Unable to create mwl/mwlquery.dcm; runtime problem or permission error." if ($?);

  open PIDFILE, ">pid.txt" or die "Could not open pid.txt to write patient ID";
  print PIDFILE "0010 0020 $pid\n";
  close PIDFILE;

  open MWLOUTPUT, ">mwlquery.out";
  my ($C, $K, $P, $R);
  if ($actorFlag eq "IM") {
    $C = "$MESA_TARGET/runtime/certificates/test_sys_1.cert.pem";
    $K = "$MESA_TARGET/runtime/certificates/test_sys_1.key.pem";
    $P = "$MESA_TARGET/runtime/certificates/mesa_list.cert";
    $R = "$MESA_TARGET/runtime/certificates/randoms.dat";
  } elsif ($actorFlag eq "OF") {
    $C = "$MESA_TARGET/runtime/certificates/mesa_1.cert.pem";
    $K = "$MESA_TARGET/runtime/certificates/mesa_1.key.pem";
    $P = "$MESA_TARGET/runtime/certificates/test_list.cert";
    $R = "$MESA_TARGET/runtime/certificates/randoms.dat";
  } else {
    die "Unrecognized actor flag $actorFlag\n";
  }

  my $x = "$main::MESA_TARGET/bin/mwlquery_secure -C $C -K $K -P $P -R $R -a $scheduledAET -c $mwlAE -d pid.txt -f mwl/mwlquery.dcm -o mwl/results $mwlHost $mwlPort";
  print "$x\n" if ($logLevel >= 3);
  print MWLOUTPUT `$x`;
  die "Unable to obtain MWL from $mwlHost at port $mwlPort with AE title $mwlAE" if ($?);

  my $modName = "MESA_MOD";
  $x = "$MESA_TARGET/bin/mod_generatestudy -m $modality  -p $pid " .
	" -s $SPSCode -c $PPSCode " .
	" -i $MESA_STORAGE/modality/$inputDir -t $outputDir " .
	" -y mwl/results " .
	" -z \"IHE Protocol 1\" ";

  open  STUDYOUT, ">generatestudy.out";
  print STUDYOUT "$x\n";
  print STUDYOUT `$x`;

  if ($?) {
    print "Unable to produce unscheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    die;
  }
  return 0;
}

sub generateMPPSAbandon {
  my ($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;
  print "mesa::generateMPPSAbandon\n" if ($logLevel >= 3);

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  my $rtnValue = 0;
  $outputDir = "$main::MESA_STORAGE/modality/$outputDir";

  print "$pid $patientName $procedureCode $modality $outputDir" if ($logLevel >= 3);

  print "Removing previous data (if any) in $outputDir\n" if ($logLevel >= 3);
  mesa::delete_directory($logLevel, $outputDir);
  print "Now, create an empty output directory\n" if ($logLevel >= 3);
  mesa::create_directory($logLevel, $outputDir);

  if (! (-e "mwl/mwlquery.txt") ) {
    print "The file mwl/mwlquery.txt does not exist; MESA distribution error\n";
    die   "Please log a bug report.";
  }
  `$main::MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery.txt mwl/mwlquery.dcm`;
  die "Unable to create mwl/mwlquery.dcm; runtime problem or permission error." if ($?);

  open PIDFILE, ">pid.txt" or die "Could not open pid.txt to write patient ID";
  print PIDFILE "0010 0020 $pid\n";
  close PIDFILE;

  open MWLOUTPUT, ">mwlquery.out";
  my $x = "$main::MESA_TARGET/bin/mwlquery -a $scheduledAET -c $mwlAE -d pid.txt -f mwl/mwlquery.dcm -o mwl/results $mwlHost $mwlPort";
  print "$x\n" if ($logLevel >= 3);
  print MWLOUTPUT `$x`;
  die "Unable to obtain MWL from $mwlHost at port $mwlPOrt with AE title $mwlAE" if ($?);

  my $discontinuedCode = "110513";
  my $modName = "MESA_MOD";
  $x = "$MESA_TARGET/bin/mod_generatestudy -m $modality  -p $pid " .
	" -D $discontinuedCode " .
	" -s $SPSCode -c $PPSCode " .
	" -i $MESA_STORAGE/modality/$inputDir -t $outputDir " .
	" -y mwl/results " .
	" -z \"IHE Protocol 1\" ";

  open  STUDYOUT, ">generatestudy.out";
  print STUDYOUT "$x\n";
  print STUDYOUT `$x`;

  if ($?) {
    print "Unable to produce unscheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    die;
  }
  return 0;
}
sub generateMPPSAbandonCoded {
  my ($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, $src, $dst, $event,
	$msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation,
	$scheduledAET, $discontinuedCode)  = @_;
  print "mesa::generateMPPSAbandonCoded\n" if ($logLevel >= 3);

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  my $rtnValue = 0;
  $outputDir = "$main::MESA_STORAGE/modality/$outputDir";

  print "$pid $patientName $procedureCode $modality $outputDir" if ($logLevel >= 3);

  print "Removing previous data (if any) in $outputDir\n" if ($logLevel >= 3);
  mesa::delete_directory($logLevel, $outputDir);
  print "Now, create an empty output directory\n" if ($logLevel >= 3);
  mesa::create_directory($logLevel, $outputDir);

  if (! (-e "mwl/mwlquery.txt") ) {
    print "The file mwl/mwlquery.txt does not exist; MESA distribution error\n";
    die   "Please log a bug report.";
  }
  `$main::MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery.txt mwl/mwlquery.dcm`;
  die "Unable to create mwl/mwlquery.dcm; runtime problem or permission error." if ($?);

  open PIDFILE, ">pid.txt" or die "Could not open pid.txt to write patient ID";
  print PIDFILE "0010 0020 $pid\n";
  close PIDFILE;

  open MWLOUTPUT, ">mwlquery.out";
  my $x = "$main::MESA_TARGET/bin/mwlquery -a $scheduledAET -c $mwlAE -d pid.txt -f mwl/mwlquery.dcm -o mwl/results $mwlHost $mwlPort";
  print "$x\n" if ($logLevel >= 3);
  print MWLOUTPUT `$x`;
  die "Unable to obtain MWL from $mwlHost at port $mwlPOrt with AE title $mwlAE" if ($?);

#  my $discontinuedCode = "110513";
  my $modName = "MESA_MOD";
  $x = "$MESA_TARGET/bin/mod_generatestudy -m $modality  -p $pid " .
	" -D $discontinuedCode " .
	" -s $SPSCode -c $PPSCode " .
	" -i $MESA_STORAGE/modality/$inputDir -t $outputDir " .
	" -y mwl/results " .
	" -z \"IHE Protocol 1\" ";

  open  STUDYOUT, ">generatestudy.out";
  print STUDYOUT "$x\n";
  print STUDYOUT `$x`;

  if ($?) {
    print "Unable to produce unscheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    die;
  }
  return 0;
}

sub modifyMPPS {
   my ($logLevel, $selfTest, $src, $dst, $event, $outputDir, $deltaNCreate, $deltaNSet)  = @_;
   print "mesa::modifyMPPS\n" if ($logLevel >= 3);

  mesa::update_DICOM_object("$main::MESA_STORAGE/modality/$outputDir/mpps.crt",    $deltaNCreate);
  mesa::update_DICOM_object("$main::MESA_STORAGE/modality/$outputDir/mpps.set",    $deltaNSet);
  mesa::update_DICOM_object("$main::MESA_STORAGE/modality/$outputDir/mpps.status", $deltaNSet);
  return 0;
}

sub gpppsNCreate {
   my ($logLevel, $selfTest, $src, $dst, $event, $outputFile, $outputDir, $inputModalityDir, $inputGPWLQueryDir)  = @_;
   print "mesa::gpppsNCreate\n" if ($logLevel >= 3);

  my $createUID = "$main::MESA_TARGET/bin/mesa_identifier ordfil pps_uid";
  print $createUID if ($logLevel >= 3);
  open UIDOUT, ">../../msgs/$outputDir/gppps_uid.txt";
  my $gpppsUID = `$createUID`;
  if ($?) {
    print "Could not generate GP PPS UID from $createUID\n";
    return 1;
  }
  print UIDOUT "$gpppsUID\n";
  close UIDOUT;

  open  GPPSOUT, ">../../msgs/$outputDir/delta.txt";
  my ($status, $v);
  $mppsStatus = "$main::MESA_STORAGE/modality/$inputModalityDir/mpps.status";
  ($status, $v) = mesa::getDICOMAttribute($logLevel, $mppsStatus, "0020 000d", "0040 0270");
  if ($status != 0) {
    print "Unable to obtain Study Ins UID from $mppsStatus\n";
    return 1;
  }
  my $accNum;
  ($status, $accNum) = mesa::getDICOMAttribute($logLevel, $mppsStatus, "0008 0050", "0040 0270");
  if ($status != 0) {
    print "Unable to obtain Study Ins UID from $mppsStatus\n";
    return 1;
  }
  my $requestedProcID;
  ($status, $requestedProcID) = mesa::getDICOMAttribute($logLevel, $mppsStatus, "0040 1001", "0040 0270");
  if ($status != 0) {
    print "Unable to obtain Study Ins UID from $mppsStatus\n";
    return 1;
  }

  $gpwlQueryResult = "$inputGPWLQueryDir/msg1_result.dcm";
  my $spsSOPUID;
  ($status, $spsSOPUID) = mesa::getDICOMAttribute($logLevel, $gpwlQueryResult, "0008 0018");
  if ($status != 0) {
    print "Unable to obtain SOP Ins UID from $gpwlQueryResult\n";
    return 1;
  }
  my $y = "$main::MESA_TARGET/bin/mesa_identifier ordfil transact_uid";
  print "$y\n" if ($logLevel >= 3);
  my $transactionUID = `$y`;
  if ($status != 0) {
    print "Unable to produce transaction UID: $y\n";
    return 1;
  }
  $y = "$main::MESA_TARGET/bin/mesa_identifier ordfil date";
  print "$y\n" if ($logLevel >= 3);
  my $date = `$y`;
  if ($status != 0) {
    print "Unable to produce current date for PPS Start Date: $y\n";
    return 1;
  }
  $y = "$main::MESA_TARGET/bin/mesa_identifier ordfil time";
  print "$y\n" if ($logLevel >= 3);
  my $time = `$y`;
  if ($status != 0) {
    print "Unable to produce current time for PPS Start Time: $y\n";
    return 1;
  }


  # General Purpose Performed Procedure Step Relationship
  # Referenced Request Sequence
  print GPPSOUT "0040 A370 (\n";		# Referenced Request Sequence
  print GPPSOUT " 0020 000D $v\n";		# Study Instance UID
  print GPPSOUT " 0008 1110 ( \n";		# Referenced Study Sequence
  print GPPSOUT "  0008 1150 1.2.840.10008.3.1.2.3.1\n";
  print GPPSOUT "  0008 1155 $v\n";		# Referenced SOP Instance UID
  print GPPSOUT " )\n";
  print GPPSOUT " 0008 0050 $accNum\n";		# Accession Number
  print GPPSOUT " 0032 1064 (  ) \n";		# Requested Procedure Code Sequence
  print GPPSOUT " 0040 1001 $requestedProcID\n"; # Requested Procedure ID
  print GPPSOUT " 0032 1060 #\n";		# Requested Procedure Description
  print GPPSOUT ")\n";

  # Referenced GPSPS Sequence
  print GPPSOUT "0040 4016 (\n";		# Referenced GPSPS Step Sequence
  print GPPSOUT " 0008 1150 1.2.840.10008.5.1.4.32.1\n";	# Referenced SOP Class UID
  print GPPSOUT " 0008 1155 $spsSOPUID\n";	# Referenced SOP Instance UID
  print GPPSOUT " 0040 4023 $transactionUID\n";	# Referenced GPSPS Transaction UID
  print GPPSOUT ")\n";

  # General Purpose Performed Procedure Step Information
  print GPPSOUT "0040 0244 $date\n";	# Performed Procedure Step Start Date
  print GPPSOUT "0040 0245 $time\n";	# Performed Procedure Step Start Time
  close GPPSOUT;

  mesa::update_DICOM_object("../../msgs/$outputDir/$outputFile", "../../msgs/$outputDir/delta.txt");

  return 0;
}

sub gpppsNSet {
   my ($logLevel, $selfTest, $src, $dst, $event, $outputFile, $outputDir, $inputModalityDir, $inputGPWLQueryDir)  = @_;
   print "mesa::gpppsNSet\n" if ($logLevel >= 3);

  my $deltaFile = "../../msgs/$outputDir/deltanset.txt";
  open  GPPSOUT, ">$deltaFile";
  my $status;

  $y = "$main::MESA_TARGET/bin/mesa_identifier ordfil date";
  print "$y\n" if ($logLevel >= 3);
  my $date = `$y`;
  if ($status != 0) {
    print "Unable to produce current date for PPS Start Date: $y\n";
    return 1;
  }
  $y = "$main::MESA_TARGET/bin/mesa_identifier ordfil time";
  print "$y\n" if ($logLevel >= 3);
  my $time = `$y`;
  if ($status != 0) {
    print "Unable to produce current time for PPS Start Time: $y\n";
    return 1;
  }


  # General Purpose Performed Procedure Step Information
  print GPPSOUT "0040 0250 $date\n";	# Performed Procedure Step End Date
  print GPPSOUT "0040 0251 $time\n";	# Performed Procedure Step End Time
  close GPPSOUT;

  mesa::update_DICOM_object("../../msgs/$outputDir/$outputFile", $deltaFile);

  return 0;
}


sub processInternalSchedulingRequest{
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");
  print "This is the MESA scheduling prelude to transaction Rad-4\n";
  print "The MESA tools will now perform scheduling to place SPS on the MESA MWL\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The SPS Location should be $SPSLocation\n";
  print " PID: $pid Name: $patientName Code: $procedureCode \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye() if ($x =~ /^q/);

#  if ($modality eq "MR") {
#    mesa::local_scheduling_mr($logLevel, $SPSLocation, $scheduledAET);
#  } elsif ($modality eq "CT") {
#    mesa::local_scheduling_ct($logLevel, $SPSLocation, $scheduledAET);
#  } elsif ($modality eq "RT") {
#    mesa::local_scheduling_rt($logLevel, $SPSLocation, $scheduledAET);
#  } elsif ($modality eq "HD") {
#    mesa::local_scheduling_hd($logLevel, $SPSLocation, $scheduledAET);
#  } elsif ($modality eq "MG") {
#    mesa::local_scheduling_mg($logLevel, $SPSLocation, $scheduledAET);
#  } elsif ($modality eq "US") {
#    mesa::local_scheduling_us($logLevel, $SPSLocation, $scheduledAET);
#  } else {
#    die "Unrecognized modality type for local scheduling: $modality \n";
#  }
  if ($modality ne "MR" &&
      $modality ne "CT" &&
      $modality ne "RT" &&
      $modality ne "HD" &&
      $modality ne "MG" &&
      $modality ne "OP" &&
      $modality ne "US") {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }
  $x = "$main::MESA_TARGET/bin/of_schedule -l $SPSLocation -t $scheduledAET -m $modality -s STATION1 ordfil";

  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  if ($?) {
    print "Could not schedule $modality SPS with command: $x\n";
    return 1;
  }
  return 0;


  return 0;
}

sub processPPMSchedulingRequest {
  my ($logLevel, $selfTest, $src, $dst, $event, $originalOrder, $processingCode, $gpspsFile) = @_;
# $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  my $hl7Msg = "../../msgs/" . $originalOrder;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $placerOrderNumber = mesa::getField($hl7Msg, "OBR", "2", "0", "Placer Order Number");

  print "This is the MESA Post Processing Scheduling prelude to transaction Rad-37\n";
  print "The MESA tools will now perform scheduling to place GPSPS on the MESA MWL\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " PID: $pid Name: $patientName Placer Order Number: $placerOrderNumber\n";
  print " Processing Code: $processingCode\n";
  print " (MESA Internal) GPSPS file: $gpspsFile\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye() if ($x =~ /^q/);

  $x = "$main::MESA_TARGET/bin/ppm_sched_gpsps -o $placerOrderNumber " .
	" -p $processingCode ordfil $gpspsFile";
  $x =~ s(/)(\\)g if ($main::MESA_OS eq "WINDOWS_NT");

  print "$x\n" if ($logLevel >= 3);
  print `$x`;
  return 1 if ($?);

  return 0;
}

sub produceUnscheduledImages {
  my ($logLevel, $selfTest, @tokens) = @_;

  my $rtnValue      = 0;
  my $verb          = $tokens[0];
  my $outputDir     = "$MESA_STORAGE/modality/$tokens[1]";
  my $hl7Msg        = "../../msgs/" . $tokens[2];
  my $modality      = $tokens[3];
  my $procedureCode = $tokens[4];
  my $performedCode = $tokens[5];
  my $inputDir      = $tokens[6];

  my $pid         = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $modName = $patientName;
  $modName =~ s/\^/_/;  # Because of problems passing ^ through the shell
  #$patientName =~ s/\^/_/;     # Because of problems passing ^ through the shell

  print "Test script now produces unscheduled images for $patientName\n";
  print "Removing previous data (if any) in $outputDir\n";
  mesa::delete_directory($logLevel, $outputDir);
  print "Now, create an empty output directory\n";
  mesa::create_directory($logLevel, $outputDir);

  my $x = "$MESA_TARGET/bin/mod_generatestudy -m $modality " .
	" -a MODALITY1 -p $pid -r $modName -c $performedCode " .
	" -i $MESA_STORAGE/modality/$inputDir -t $outputDir " .
	" -z \"IHE Protocol 1\" ";

  open  STUDYOUT, ">generatestudy.out";
  print STUDYOUT "$x\n";
  print STUDYOUT `$x`;

  if ($?) {
    print "Unable to produce unscheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    die;
  }
  return 0;

}

sub produceUnscheduledImagesTF {
  my ($logLevel, $selfTest, @tokens) = @_;

  my $rtnValue      = 0;
  my $verb          = $tokens[0];
  my $outputDir     = "$MESA_STORAGE/modality/$tokens[1]";
  my $patientName    = $tokens[2];
  my $pid       	= $tokens[3];
  my $patDOB       	= $tokens[4];
  my $patSex       	= $tokens[5];
  my $modality      = $tokens[6];
  my $procedureCode = $tokens[7];
  my $performedCode = $tokens[8];
  my $inputDir      = $tokens[9];

  my $modName = $patientName;
  $modName =~ s/\^/_/;  # Because of problems passing ^ through the shell
  #$patientName =~ s/\^/_/;     # Because of problems passing ^ through the shell

  print "Test script now produces unscheduled images for $patientName\n" if ($logLevel >= 3);
  print "Removing previous data (if any) in $outputDir\n" if ($logLevel >= 3);
  mesa::delete_directory($logLevel, $outputDir);
  print "Now, create an empty output directory\n" if ($logLevel >= 3);
  mesa::create_directory($logLevel, $outputDir);

  my $x = "$MESA_TARGET/bin/mod_generatestudy -m $modality " .
	" -a MODALITY1 -p $pid -r $modName -c $performedCode " .
	" -i $MESA_STORAGE/modality/$inputDir -t $outputDir " .
	" -z \"IHE Protocol 1\" ";

  open  STUDYOUT, ">generatestudy.out";
  print STUDYOUT "$x\n";
  print STUDYOUT `$x`;

  if ($?) {
    print "Unable to produce unscheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    die;
  }
  return 0;
}

sub edits() {
	##-d and print "$_\n";
   	return unless (-f and /\.dcm$/);
   	#print "File: $File::Find::name\n";
   	push @files, $File::Find::name;
}

sub produceKONTF {
  my ($logLevel, $selfTest, @tokens) = @_;
  use File::Find;

  my $rtnValue      = 0;
  my $verb          = $tokens[0];
  my $outputDir     = "$main::MESA_STORAGE/modality/$tokens[1]";
  my $inputDir      = "$main::MESA_STORAGE/modality/$tokens[2]";
  my $konCode      = $tokens[3];

  print "Output: $outputDir\n" if ($logLevel >= 3);
  print "Input:  $inputDir\n" if ($logLevel >= 3);

  mesa::delete_directory($logLevel, $outputDir);
  mesa::create_directory($logLevel, $outputDir);

  my $templateFile = "../../msgs/sr/templates/kon_tfcte_tpl.txt";
  my $outputTextFile = "$outputDir/kon.txt";

  open (TPL, $templateFile ) || die "mesa::produceKONTF: Could not open template file: $templateFile";
  open(TXT, "> $outputTextFile") || die "Could not create output txt file: $outputTextFile";
  while ($line = <TPL>) {
    print TXT "$line";
  }
  close TPL;

  my $v = "";
  @files = ();
  my $status = 0;
  @attributes = (
	"0010 0010",	# Patient Name
	"0010 0020",	# Patient IDproduceKONTF
	"0010 0030",	# DOB
	"0010 0040",	# Sex
	"0020 000D",	# Study Instance UID
	"0008 0020",	# Study Date
	"0008 0030",	# Study Time
	"0008 0090",	# Referring Physician's Name
	"0020 0010",	# Study ID
	"0008 0050",	# Accession Number
#	"0008 0060",	# Modality
	"0008 0070",	# Manufacturer
#    "0008 0016",	# SOP Class UID 
  );

  %att = (
    "0008 0016" => "0008 1150",
    "0008 0018" => "0008 1155",
	);

  find(\&edits, $inputDir);

  foreach (sort @files) {
    print TXT "(\n";
    print TXT " 0040 a010  CONTAINS\n";
    print TXT " 0040 a040  IMAGE\n";
    print TXT " 0008 1199 (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT "   $att{$key} $v\n";
    }
    print TXT " )\n";
    print TXT ")\n";
  }
 

  foreach $att ( @attributes ) {
    print "ATT: $att\n" if ($logLevel >= 3);
    ($status, $v) = mesa::getDICOMAttribute($logLevel, "$inputDir/x1.dcm", $att);
    return 1 if ($status != 0);
    $v = "#" if ($v eq "");
    print TXT "$att $v\n";
  }
  print TXT "0008 0016 1.2.840.10008.5.1.4.1.1.88.59\n";
  print TXT "0008 0060 KO\n";
  print TXT "0008 1111 ####\n";
  print TXT "0008 0070 MIR\n";
  print TXT "0020 0013 1\n";
  print TXT "0020 0011 20\n";

  # Generate Content Date/Time
  my ($sec, $min, $hours, $mday, $month, $year) = localtime;
  my $date = sprintf "%4d%02d%02d", (1900+$year, $month+1, $mday);
  my $time = sprintf "%02d%02d%02d", ($hours, $min, $sec);

  print TXT "0008 0023 $date\n";
  print TXT "0008 0033 $time\n";
  
  # Generate Series Instance UID
  my $dbname = "mod1";
  my $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname series_uid";
  my $seriesUID= `$x`;
  print TXT "0020 000E $seriesUID\n";

  # Generate SOP Instance UID
  $dbname = "mod1";
  $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname sop_inst_uid";
  my $sopUID= `$x`;
  print TXT "0008 0018 $sopUID\n";
 

  # Read directory of images and generate reference list
  print TXT "0040 A375 (\n";
  
  # Get Study Instance UID
  $att = " 0020 000D";
  ($status, $v) = mesa::getDICOMAttribute($logLevel, "$inputDir/x1.dcm", $att);
  print TXT "$att $v\n";
  print TXT " 0008 1115 (\n";

  # Get Series Instance UID
  $att = "  0020 000E";
  ($status, $v) = mesa::getDICOMAttribute($logLevel, "$inputDir/x1.dcm", $att);
  print TXT "$att $v\n";
  print TXT "  0008 1199\n";

  foreach (sort @files) {
    print TXT "   (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT "   $att{$key} $v\n";
    }
    print TXT "   )\n";
  }
  print TXT "  )\n)\n";

  close TXT;


  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputTextFile $outputDir/kon.dcm";
  print "$x\n" if ($logLevel >= 3);
  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }
  return 1 if $?;
  return 0;
}


sub produceMOD_KONTF {
  my ($logLevel, $selfTest, @tokens) = @_;
  use File::Find;

  my $rtnValue      = 0;
  my $verb          = $tokens[0];
  my $outputDir     = "$main::MESA_STORAGE/modality/$tokens[1]";
  my $inputDir      = "$main::MESA_STORAGE/modality/$tokens[2]";
  my $konCode      = $tokens[3];
  @files = ();

  print "Output: $outputDir\n" if ($logLevel >= 3);
  print "Input:  $inputDir\n" if ($logLevel >= 3);

  mesa::delete_directory($logLevel, $outputDir);
  mesa::create_directory($logLevel, $outputDir);

  my $templateFile = "../../msgs/sr/templates/kon_wait_tfcte_tpl.txt";
  my $outputTextFile = "$outputDir/kon.txt";

  open (TPL, $templateFile ) || die "mesa::produceKONTF: Could not open template file: $templateFile";
  open(TXT, "> $outputTextFile") || die "Could not create output txt file: $outputTextFile";
  while ($line = <TPL>) {
    print TXT "$line";
  }
  close TPL;

  my $v = "";
  my $status = 0;
  @attributes = (
	"0010 0010",	# Patient Name
	"0010 0020",	# Patient ID
	"0010 0030",	# DOB
	"0010 0040",	# Sex
	"0020 000D",	# Study Instance UID
	"0008 0020",	# Study Date
	"0008 0030",	# Study Time
	"0008 0090",	# Referring Physician's Name
	"0020 0010",	# Study ID
	"0008 0050",	# Accession Number
#	"0008 0060",	# Modality
	"0008 0070",	# Manufacturer
#    "0008 0016",	# SOP Class UID 
  );

  %att = (
    "0008 0016" => "0008 1150",
    "0008 0018" => "0008 1155",
	);

  find(\&edits, $inputDir);

  foreach (sort @files) {
    print TXT "(\n";
    print TXT " 0040 a010  CONTAINS\n";
    print TXT " 0040 a040  IMAGE\n";
    print TXT " 0008 1199 (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT "   $att{$key} $v\n";
    }
    print TXT " )\n";
    print TXT ")\n";
  }
 

  foreach $att ( @attributes ) {
    print "ATT: $att\n" if ($logLevel >= 3);
    ($status, $v) = mesa::getDICOMAttribute($logLevel, "$inputDir/x1.dcm", $att);
    return 1 if ($status != 0);
    $v = "#" if ($v eq "");
    print TXT "$att $v\n";
  }
  print TXT "0008 0016 1.2.840.10008.5.1.4.1.1.88.59\n";
  print TXT "0008 0060 KO\n";
  print TXT "0008 1111 ####\n";
  print TXT "0008 0070 MIR\n";
  print TXT "0020 0013 1\n";
  print TXT "0020 0011 20\n";

  # Generate Content Date/Time
  my ($sec, $min, $hours, $mday, $month, $year) = localtime;
  my $date = sprintf "%4d%02d%02d", (1900+$year, $month+1, $mday);
  my $time = sprintf "%02d%02d%02d", ($hours, $min, $sec);

  print TXT "0008 0023 $date\n";
  print TXT "0008 0033 $time\n";
  
  # Generate Series Instance UID
  my $dbname = "mod1";
  my $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname series_uid";
  my $seriesUID= `$x`;
  print TXT "0020 000E $seriesUID\n";

  # Generate SOP Instance UID
  $dbname = "mod1";
  $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname sop_inst_uid";
  my $sopUID= `$x`;
  print TXT "0008 0018 $sopUID\n";
 

  # Read directory of images and generate reference list
  print TXT "0040 A375 (\n";
  
  # Get Study Instance UID
  $att = " 0020 000D";
  ($status, $v) = mesa::getDICOMAttribute($logLevel, "$inputDir/x1.dcm", $att);
  print TXT "$att $v\n";
  print TXT " 0008 1115 (\n";

  # Get Series Instance UID
  $att = "  0020 000E";
  ($status, $v) = mesa::getDICOMAttribute($logLevel, "$inputDir/x1.dcm", $att);
  print TXT "$att $v\n";
  print TXT "  0008 1199\n";

  foreach (sort @files) {
    print TXT "   (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT "   $att{$key} $v\n";
    }
    print TXT "   )\n";
  }
  print TXT "  )\n)\n";

  close TXT;


  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputTextFile $outputDir/kon.dcm";
  print "$x\n" if ($logLevel >= 3);
  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }
  return 1 if $?;
  return 0;
}

sub produce_KONTF2 {
  my ($logLevel, $selfTest, @tokens) = @_;
  use File::Find;

  ## Empty the arrays
  @files = ();
  @dcm1 = ();
  @dcm2 = ();
  @allFiles = ();

  my $rtnValue      = 0;
  my $verb          = $tokens[0];
  my $outputDir     = "$main::MESA_STORAGE/modality/$tokens[1]";
  my $inputDir1      = "$main::MESA_STORAGE/modality/$tokens[2]";
  my $inputDir2      = "$main::MESA_STORAGE/modality/$tokens[3]";

  print "Output: $outputDir\n" if ($logLevel >= 3);
  print "Input1:  $inputDir1\n" if ($logLevel >= 3);
  print "Input2:  $inputDir2\n" if ($logLevel >= 3);

  mesa::delete_directory($logLevel, $outputDir);
  mesa::create_directory($logLevel, $outputDir);

  my $templateFile = "../../msgs/sr/templates/kon_tfcte_tpl.txt";
  my $outputTextFile1 = "$outputDir/kon1.txt";
  my $outputTextFile2 = "$outputDir/kon2.txt";

  open (TPL, $templateFile ) || die "mesa::produceKONTF: Could not open template file: $templateFile";
  open(TXT1, "> $outputTextFile1") || die "Could not create output txt file: $outputTextFile1";
  open(TXT2, "> $outputTextFile2") || die "Could not create output txt file: $outputTextFile2";
  while ($line = <TPL>) {
    print TXT1 "$line";
    print TXT2 "$line";
  }
  close TPL;

  # Get Study Instance UID - Study1
  $tagStudy1UID = " 0020 000D";
  ($status, $study1UID) = mesa::getDICOMAttribute($logLevel, "$inputDir1/x1.dcm", $tagStudy1UID);

  # Get Series Instance UID - Study1
  $tagStudy1SeriesUID = "  0020 000E";
  ($status, $study1SeriesUID) = mesa::getDICOMAttribute($logLevel, "$inputDir1/x1.dcm", $tagStudy1SeriesUID);

  # Get Study Instance UID - Study2
  $tagStudy2UID = " 0020 000D";
  ($status, $study2UID) = mesa::getDICOMAttribute($logLevel, "$inputDir2/x1.dcm", $tagStudy2UID);

  # Get Series Instance UID - Study2
  $tagStudy2SeriesUID = "  0020 000E";
  ($status, $study2SeriesUID) = mesa::getDICOMAttribute($logLevel, "$inputDir2/x1.dcm", $tagStudy2SeriesUID);

  my $v = "";
  my $status = 0;
  @attributes = (
	"0010 0010",	# Patient Name
	"0010 0020",	# Patient ID
	"0010 0030",	# DOB
	"0010 0040",	# Sex
	"0020 000D",	# Study Instance UID
	"0008 0020",	# Study Date
	"0008 0030",	# Study Time
	"0008 0090",	# Referring Physician's Name
	"0020 0010",	# Study ID
	"0008 0050",	# Accession Number
	"0008 0070",	# Manufacturer
  );

  %att = (
    "0008 0016" => "0008 1150",
    "0008 0018" => "0008 1155",
	);

  find(\&edits, $inputDir1);
  push (@dcm1, @files);
  @files = ();
  push (@allFiles, @dcm1);

  find(\&edits, $inputDir2);
  push (@dcm2, @files);
  push (@allFiles, @dcm2);

  # Generate SOP Instance UID
  $dbname = "mod1";
  $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname sop_inst_uid";
  my $sopUID1 = `$x`;
  my $sopUID2 = `$x`;

  # Generate Series Instance UID
  $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname series_uid";
  my $seriesUID1= `$x`;
  my $seriesUID2 = `$x`;

  foreach (sort @allFiles) {
    print TXT1 "(\n";
    print TXT2 "(\n";
    print TXT1 " 0040 a010  CONTAINS\n";
    print TXT2 " 0040 a010  CONTAINS\n";
    print TXT1 " 0040 a040  IMAGE\n";
    print TXT2 " 0040 a040  IMAGE\n";
    print TXT1 " 0008 1199 (\n";
    print TXT2 " 0008 1199 (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT1 "   $att{$key} $v\n";
      print TXT2 "   $att{$key} $v\n";
    }
    print TXT1 " )\n";
    print TXT2 " )\n";
    print TXT1 ")\n";
    print TXT2 ")\n";
  }

  # IDENTICAL DOCUMENTS SEQUENCE
  # Write to Kon1.txt
  print TXT1 "0040 A525\n"; 
  print TXT1 "(\n";
  print TXT1 "$tagStudy2UID $study2UID\n";
  print TXT1 " 0008 1115 (\n";
  print TXT1 "$tagStudy2SeriesUID $seriesUID2\n";
  print TXT1 "  0008 1199\n";
  print TXT1 "   (\n";
  print TXT1 "   0008 1150 1.2.840.10008.5.1.4.1.1.88.59\n";
  print TXT1 "   0008 1155 $sopUID2\n";
  print TXT1 "   )\n";
  print TXT1 "  )\n";
  print TXT1 ")\n";

  # Write to Kon2.txt
  print TXT2 "0040 A525\n"; 
  print TXT2 "(\n";
  
  print TXT2 "$tagStudy1UID $study1UID\n";
  print TXT2 " 0008 1115 (\n";
  print TXT2 "$tagStudy1SeriesUID $seriesUID1\n";
  print TXT2 "  0008 1199\n";
  print TXT2 "   (\n";
  print TXT2 "   0008 1150 1.2.840.10008.5.1.4.1.1.88.59\n";
  print TXT2 "   0008 1155 $sopUID1\n";
  print TXT2 "   )\n";
  print TXT2 "  )\n";
  print TXT2 ")\n";


  foreach $att ( @attributes ) {
    print "ATT: $att\n" if ($logLevel >= 3);
    ($status, $v) = mesa::getDICOMAttribute($logLevel, "$inputDir1/x1.dcm", $att);
    return 1 if ($status != 0);
    $v = "#" if ($v eq "");
    print TXT1 "$att $v\n";
  }
 
  foreach $att ( @attributes ) {
    print "ATT: $att\n" if ($logLevel >= 3);
    ($status, $v) = mesa::getDICOMAttribute($logLevel, "$inputDir2/x1.dcm", $att);
    return 1 if ($status != 0);
    $v = "#" if ($v eq "");
    print TXT2 "$att $v\n";
  }

  print TXT1 "0008 0016 1.2.840.10008.5.1.4.1.1.88.59\n";
  print TXT2 "0008 0016 1.2.840.10008.5.1.4.1.1.88.59\n";
  print TXT1 "0008 0060 KO\n";
  print TXT2 "0008 0060 KO\n";
  print TXT1 "0008 1111 ####\n";
  print TXT2 "0008 1111 ####\n";
  print TXT1 "0008 0070 MIR\n";
  print TXT2 "0008 0070 MIR\n";
  print TXT1 "0020 0013 1\n";
  print TXT2 "0020 0013 1\n";
  print TXT1 "0020 0011 20\n";
  print TXT2 "0020 0011 20\n";

  # Generate Content Date/Time
  my ($sec, $min, $hours, $mday, $month, $year) = localtime;
  my $date = sprintf "%4d%02d%02d", (1900+$year, $month+1, $mday);
  my $time = sprintf "%02d%02d%02d", ($hours, $min, $sec);

  print TXT1 "0008 0023 $date\n";
  print TXT2 "0008 0023 $date\n";
  print TXT1 "0008 0033 $time\n";
  print TXT2 "0008 0033 $time\n";
  
  print TXT1 "0020 000E $seriesUID1\n";
  print TXT2 "0020 000E $seriesUID2\n";

  print TXT1 "0008 0018 $sopUID1\n";
  print TXT2 "0008 0018 $sopUID2\n";

  # CURRENT REQUESTED PROCEDURE EVIDENCE SEQUENCE
  # Write to Kon1.txt
  print TXT1 "0040 A375\n"; 
  print TXT1 "(\n";
  print TXT1 "$tagStudy1UID $study1UID\n";
  print TXT1 " 0008 1115 (\n";
  print TXT1 "$tagStudy1SeriesUID $study1SeriesUID\n";
  print TXT1 "  0008 1199\n";

  foreach (sort @dcm1) {
    print TXT1 "   (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT1 "   $att{$key} $v\n";
    }
    print TXT1 "   )\n";
  }
  print TXT1 "  )\n";
  print TXT1 ")\n";

  print TXT1 "(\n";
  print TXT1 "$tagStudy2UID $study2UID\n";
  print TXT1 " 0008 1115 (\n";
  print TXT1 "$tagStudy2SeriesUID $study2SeriesUID\n";
  print TXT1 "  0008 1199\n";

  foreach (sort @dcm2) {
    print TXT1 "   (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT1 "   $att{$key} $v\n";
    }
    print TXT1 "   )\n";
  }
  print TXT1 "  )\n";
  print TXT1 ")\n";
  
  # Write to kon2.txt
  print TXT2 "0040 A375\n"; 
  print TXT2 "(\n";
  print TXT2 "$tagStudy1UID $study1UID\n";
  print TXT2 " 0008 1115 (\n";
  print TXT2 "$tagStudy1SeriesUID $study1SeriesUID\n";
  print TXT2 "  0008 1199\n";

  foreach (sort @dcm1) {
    print TXT2 "   (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT2 "   $att{$key} $v\n";
    }
    print TXT2 "   )\n";
  }
  print TXT2 "  )\n";
  print TXT2 ")\n";

  print TXT2 "(\n";
  print TXT2 "$tagStudy2UID $study2UID\n";
  print TXT2 " 0008 1115 (\n";
  print TXT2 "$tagStudy2SeriesUID $study2SeriesUID\n";
  print TXT2 "  0008 1199\n";

  foreach (sort @dcm2) {
    print TXT2 "   (\n";
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print TXT2 "   $att{$key} $v\n";
    }
    print TXT2 "   )\n";
  }
  print TXT2 "  )\n";
  print TXT2 ")\n";
  
  close TXT1;
  close TXT2;

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputTextFile1 $outputDir/kon1.dcm";
  print "$x\n" if ($logLevel >= 3);
  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }

  $y = "$main::MESA_TARGET/bin/dcm_create_object -i $outputTextFile2 $outputDir/kon2.dcm";
  print "$y\n" if ($logLevel >= 3);
  if ($logLevel >= 3) {
    print `$y`;
  } else {
    `$y`;
  }

  return 1 if $?;
  return 0;
}

sub deidentifyKON{
  my ($logLevel, $selfTest, $deltaDir, $deltaFile, @genKON) = @_;
  my $dstDir = "$main::MESA_STORAGE/modality/$genKON[1]";
  my $delta = "../common/$deltaDir/$deltaFile";
  
  #print "Removing previous data (if any) in $dstDir\n";
  #mesa::delete_directory($logLevel, $dstDir);
  #print "Now, create an empty output directory\n";
  #mesa::create_directory($logLevel, $dstDir);

  if($genKON[0] eq "GEN-TF-KON2"){
    produce_KONTF2($logLevel, $selfTest, @genKON);
  }elsif($genKON[0] eq "GEN-TF-KON"){
    produceKONTF($logLevel, $selfTest, @genKON);
  }
  return 1 if $?;

  #print `cp $delta $dstDir`;
  
  #processing each dicom object in the folder
  opendir(DEST,"$dstDir") || die "Cannot find $dstDir: $!";

  foreach $name (readdir(DEST)){
    if($name =~ /.dcm\b/){
      mesa::update_DICOM_object_debug($logLevel,"$dstDir/$name", "$delta");
    }
  }
  closedir(DEST);
  
  #print "Removing the delta file from $dstDir";
  #print `rm $dstDir\/$deltaFile` if ($logLevel >= 3);
  
  return 0;
}

sub deidentifyImages {
  my ($logLevel, $selfTest, $inSrcDir, $inDstDir, $deltaDir, $deltaFile) = @_;
  my $srcDir = "$main::MESA_STORAGE/modality/$inSrcDir";
  my $dstDir = "$main::MESA_STORAGE/modality/$inDstDir";
  my $delta = "../common/$deltaDir/$deltaFile";

  #print "Removing previous data (if any) in $dstDir\n";
  mesa::delete_directory($logLevel, $dstDir);
  #print "Now, create an empty output directory\n";
  mesa::create_directory($logLevel, $dstDir);
  
  #print "Copying the delta file $delta to $dstDir.\n";

  my $cpCommand;
  if ($MESA_OS eq "WINDOWS_NT") {
    $cpCommand = "copy $delta $dstDir";
    $cpCommand =~ s-/-\\-g;
  } else {
    $cpCommand = "cp $delta $dstDir";
  }
  if ($logLevel >= 3) {
    print "$cpCommand\n";
    print `$cpCommand`;
  } else {
    `$cpCommand`;
  }
  die "Could not copy: $cpCommand" if $?;

  
  # Generate Series Instance UID
  my $dbname = "mod1";
  my $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname series_uid";
  my $seriesUID= `$x`; 
  
  # Generate Study Instance UID
  $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname study_uid";
  my $studyUID= `$x`;
  
  #processing each dicom object in the folder
  opendir(SRC,"$srcDir") || die "Cannot find $srcDir: $!";
  foreach $name (readdir(SRC)){
    if($name =~ /.dcm\b/){
      if ($MESA_OS eq "WINDOWS_NT") {
      $cpCommand = "copy $srcDir/$name $dstDir";
      $cpCommand =~ s-/-\\-g;
      } else {
	$cpCommand = "cp $srcDir/$name $dstDir";
      }
#      print `cp $srcDir\/$name $dstDir`;
      if ($logLevel >= 3) {
	print `$cpCommand`;
      } else {
	`$cpCommand`;
      }
      die "Could not copy: $cpCommand" if $?;

      mesa::update_DICOM_object_debug($logLevel,"$dstDir/$name", "$dstDir/$deltaFile");
      mesa::deidentify_Image_UID($logLevel, $selfTest,$name, $dstDir, $seriesUID, $dbname, $studyUID);
    }
  }
  closedir(SRC);

  #print "Removing the delta file from $dstDir";
  #print `rm $dstDir\/$deltaFile`;
  
  return 0;
}

# Remove element of a DICOM object
sub remove_DICOM_object_element {
 my ($inFile, $group, $element) = @_;
 my $outFile = $inFile . ".xxx";

 my $x = "$main::MESA_TARGET/bin/dcm_rm_element $group $element $inFile $outFile";
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
 return 0;
}

sub deidentify_Image_UID{
  my($logLevel, $selfTest, $name, $dstDir, $seriesUID, $dbname, $studyUID) = @_;
  my $deltaFile = "deltaIMUID.txt";
  
  #print "Debug:: $dstDir/$deltaFile\n";
  open (DELTA, ">$dstDir/$deltaFile") or die "Could not open: $dstDir/$deltaFile\n";
  print DELTA "0020 000d $studyUID\n";
  print DELTA "0020 000e $seriesUID\n";
  
  # Generate SOP Instance UID
  my $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname sop_inst_uid";
  my $sopUID= `$x`;
  print DELTA "0008 0018 $sopUID\n";

  close(DELTA);
  mesa::update_DICOM_object_debug($logLevel,"$dstDir/$name", "$dstDir/$deltaFile");
  
  #print `rm $dstDir\/$deltaFile`;
  return 0;  
}

sub getKONInstanceManifest {
  my ($logLevel, $path, $maxIndex) = @_;
  my %hash;
  
  mesa::delete_directory($logLevel, "$main::MESA_STORAGE/tmp");
  mesa::create_directory($logLevel, "$main::MESA_STORAGE/tmp");
  if(!$maxIndex){
    $maxIndex = 1;
  }
  
  for($i = $maxIndex; $i >=1; $i--){
    my $error = 0;
    my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $i 0040 A375 $path $main::MESA_STORAGE/tmp/evdseq.dcm";
    print main::LOG "CTX: $x\n" if ($logLevel >= 3);
    `$x`;
    #return (1,%hash) if $?;
    $error++ if $?;
    
    if(!$error){
      my $y = "$main::MESA_TARGET/bin/dcm_dump_element 0008 1115 $main::MESA_STORAGE/tmp/evdseq.dcm $main::MESA_STORAGE/tmp/refser.dcm";
      print main::LOG "CTX: $y\n" if ($logLevel >= 3);
      `$y`;
      $error++ if $?;
      #return (1,%hash) if $?;
    }
  
    if(!$error){
      my $idx = 1;
      my $done = 0;
      my $seriesPath = "$main::MESA_STORAGE/tmp/refser.dcm";
      while (! $done) {
        my ($s1, $instanceUID) = mesa::getDICOMAttribute($logLevel, $seriesPath, "0008 1155", "0008 1199", $idx);
        my ($s2, $classUID) = mesa::getDICOMAttribute($logLevel, $seriesPath, "0008 1150", "0008 1199", $idx);
        #print "$idx $s1 $s2 <$classUID> $instanceUID\n";
        if ($s1 != 0) {
          print main::LOG "ERR: In $i item of evidence sequence, could not get instance UID value for index $idx\n";
          #return (1, %hash);
        }
        if ($instanceUID eq "") {
          $done = 1;
        } else {
          #print "<$classUID> $instanceUID\n";
          # Add instance UID and class UID to a hash
          $hash{$instanceUID} = $classUID;
          $idx++;
        }
      }
    }  
  }
  
  #print main::LOG "\n";
  if($error){
    return (1, %hash);
  }else{
    # return status and hash
    return (0,%hash);
  }  
}

sub getPatientDemographics() {
  print "Please enter Patient's First Name: ";
  chomp(my $firstName = <STDIN>);

  print "Please enter Patient's Last Name: ";
  chomp(my $lastName = <STDIN>);

  print "Please enter Patient ID: ";
  chomp($patID = <STDIN>);

  print "Please enter Assigning Authority: ";
  chomp($assignAuth = <STDIN>);

  $patientName = $lastName."^".$firstName;
  $patientID = $patID."^^^".$assignAuth;
  
  return $patientName, $patientID;
}

sub updatePatientDemographics {
  my ($logLevel, $selfTest, @tokens) = @_;

  my $rtnValue      = 0;
  my $hl7Msg        = "../../msgs/" . $tokens[0];

  print "CTX: update hL7 message with Patient Name and Patient ID \n" if ($logLevel >= 3);

  if ($hl7Msg =~ m/adt/i) {
  	($patientName, $patientID) = &getPatientDemographics();
  } elsif ($hl7Msg =~ m/sched|order/i) {
  }

  # Update Patient Name and PID
  mesa::setField($logLevel, $hl7Msg, "PID", "5", "0", "Patient Name", $patientName);
  mesa::setField($logLevel, $hl7Msg, "PID", "3", "0", "Patient ID", $patientID);

  return 0;
}

sub generateIAN {
  my ($logLevel, $selfTest, $imgmgrAETitleRetrieve, $src, $dst, $event, $outputDir, $inputDir)  = @_;
  if($selfTest == 1){
    print "MESA will generate Instance Availability Notice for self test mode.\n";
  } else{
    print "You system will need to generate Instance Available Notice for the next step.\n";
  }
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  if ($x =~ /^q/){
    print "Exiting...\n";
    exit 1;
  }

  my $rtnValue = 0;
  my $studyTag = "0020 000d";
  my $seriesTag = "0020 000e";
  my $classTag = "0008 0016";
  my $instanceTag = "0008 0018";

  $inputDir = "$main::MESA_STORAGE/modality/$inputDir";
  $outputDir = "$main::MESA_STORAGE/modality/$outputDir";

  #if (! (-e "ian/ian.txt") ) {
  #  print "The file ian/ian.txt does not exist; MESA distribution error\n";
  #  die   "Please log a bug report.";
  #}
  
  open MPPSUID, "$inputDir/mpps_uid.txt" or die "Could not open mpps_uid.txt";
  my $mppsInsUID = <MPPSUID>;
  chomp($mppsInsUID);
  print "MPPS Instance UID: $mppsInsUID\n";
  close MPPSUID;
  
  open IANFILE, ">$outputDir/ian.txt" or die "Could not open ian.txt";
  print IANFILE "0008 1111 (\n";
  print IANFILE "  0008 1150 1.2.840.10008.3.1.2.3.3\n";
  print IANFILE "  0008 1155 $mppsInsUID\n";
  print IANFILE "  0040 4019 ####\n";
  print IANFILE ")\n";
  
  
  find(\&edits, $inputDir);
  
#  sub edits() {
#    return unless -f;
#    push @files, $File::Find::name;
#  }
  
  my %studies = ();
  my %inst_series = ();
  my $inst = "";
  my $studyUID = "";
  foreach (@files) {
    if($_ =~ /.dcm/){
      print "Processing file: $_\n";
      $studyUID = getDICOMAttribute($logLevel,$_, $studyTag);
      $studies{$studyUID} = $_;
      $inst = getDICOMAttribute($logLevel,$_, $classTag).":".getDICOMAttribute($logLevel,$_, $instanceTag);
      $inst_series{$inst} = getDICOMAttribute($logLevel,$_, $seriesTag);
    }
  }

  my $size = keys(%studies);
  if($size != 1){
    foreach $key (keys (%studies)){
      print "     Key: $key    Value: $studies{$key}\n";
    }
    die "ERR: There are more than one ($size) studies.\n";
  }else{
    print IANFILE "0020 000D $studyUID\n";
    print IANFILE "0008 1115(\n";
    my @series = values(%inst_series);
    my @series_set = ();
    foreach $ser (@series){
       if(!evaluate_tfcte::arrayContains($ser,@series_set)){
         push(@series_set, $ser);
         print IANFILE "  0020 000E $ser\n";
         print IANFILE "  0008 1199\n";
         foreach $inst (keys(%inst_series)){
           if($inst_series{$inst} eq $ser){
	     @values = split(/:/, $inst);
	     print IANFILE "    (\n";
	     print IANFILE "    0008 1150 $values[0]\n";
	     print IANFILE "    0008 1155 $values[1]\n";
	     print IANFILE "    0008 0056 ONLINE\n";
	     print IANFILE "    0008 0054 $imgmgrAETitleRetrieve\n";
	     print IANFILE "    )\n";
	   }
         }
      }
    }
    print IANFILE "  )\n";
  }
  
  close IANFILE;
  
  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/ian.txt $outputDir/ian.crt";
  print "$x";
  print `$x`;

  die "Unable to create $outputDir/ian.dcm; runtime problem or permission error." if ($?);

  return 0;
}

sub send_ian_log
{
  my $logLevel = shift(@_);
  my $directoryName   = "$main::MESA_STORAGE/modality/" . shift(@_);
  my $sourceAE        = shift(@_);
  my $destAE   = shift(@_);
  my $destHost = shift(@_);
  my $destPort = shift(@_);

  open(MPPS_HANDLE, "< $directoryName/mpps_uid.txt") || die "Could not open MPPS UID File: $directoryName/mpps_uid.txt";

  $uid = <MPPS_HANDLE>;
  chomp $uid;

  #$x = "$main::MESA_TARGET/bin/ncreate -L $logLevel -a MODALITY1 -c $destAE " .
  $x = "$main::MESA_TARGET/bin/ncreate -L $logLevel -a $sourceAE -c $destAE " .
        " $destHost $destPort " .
        " 1.2.840.10008.5.1.4.33 $directoryName/ian.crt $uid ";
  print "$x \n";
  print `$x`;
  die "Could not send MPPS N-Create \n" if ($?);
}

sub testMESAEnvironment
{
  my $logLevel = shift(@_);
  my $rtnValue = 0;

  open (M_HANDLE, ">mesa_environment.log") || die "Could not open mesa_environment.log";

  # Test MESA_OS
  print M_HANDLE "Testing MESA_OS <$main::MESA_OS>\n" if ($logLevel >= 3);
  my $os = $main::MESA_OS;
  if (($os ne "WINDOWS_NT") && ($os ne "LINUX") && ($os ne "SOLARIX") && ($os ne "UNIX")) {
    $rtnValue = 1;
    print M_HANDLE "Unrecognized value for MESA_OS: $main::MESA_OS\n";
  }

  # Test MESA_TARGET
  print M_HANDLE "Testing MESA_TARGET <$main::MESA_TARGET>\n" if ($logLevel >= 3);
  if (! $main::MESA_TARGET) {
    print M_HANDLE "Undefined variable MESA_TARGET; this needs to be defined\n";
    $rtnValue = 1;
  } elsif ($main::MESA_TARGET eq "") {
    print M_HANDLE "MESA_TARGET has 0 length; please define properly\n";
    $rtnValue = 1;
  } elsif (! -e $main::MESA_TARGET) {
    print M_HANDLE "The MESA_TARGET directory $main::MESA_TARGET does not exist\n";
    $rtnValue = 1;
  }

  # Test MESA_STORAGE
  print M_HANDLE "Testing MESA_STORAGE <$main::MESA_STORAGE>\n" if ($logLevel >= 3);
  if (! $main::MESA_STORAGE) {
    print M_HANDLE "Undefined variable MESA_STORAGE; this needs to be defined\n";
    $rtnValue = 1;
  } elsif ($main::MESA_STORAGE eq "") {
    print M_HANDLE "MESA_STORAGE has 0 length; please define properly\n";
    $rtnValue = 1;
  } elsif (! -e $main::MESA_STORAGE) {
    print M_HANDLE "The MESA_STORAGE directory $main::MESA_STORAGE does not exist\n";
    $rtnValue = 1;
  } elsif (! -e "$main::MESA_STORAGE/modality/MR/MR1") {
    print M_HANDLE "The $main::MESA_STORAGE/modality/MR/MR1 does not exist\n";
    print M_HANDLE " This implies you have properly installed those storage files\n";
    $rtnValue = 1;
  }

  close (M_HANDLE);
  if ($rtnValue != 0) {
    print "Some problem in your environment variables or configuration\n";
    print "Look in the file: mesa_environment.log\n";
  }
  return $rtnValue;
}
1;
