#!/usr/local/bin/perl -w

# Grades the Storage Commitment part of the Image Manager test.

use Env;
use lib "scripts";
require imgmgr;

sub report {
    my $msg = shift(@_);
    print "$msg\n";
    print REPORT "$msg\n";
}

sub create_vendor_hash() {
  $vendorDir = "$MESA_STORAGE/modality/st_comm/$titleSC";

  opendir VENDOR, $vendorDir or die "directory: $vendorDir not found!";
  @vendorMsgs = readdir VENDOR;

  MESSAGE: foreach $message (@vendorMsgs) {
    next MESSAGE if ($message eq ".");
    next MESSAGE if ($message eq "..");

    $x = `$MESA_TARGET/bin/dcm_print_element 0008 1195 $vendorDir/$message`;
    chomp $x;
    next MESSAGE if ($x eq "");

    $vendor{$x} = "$vendorDir/$message";
  }
}

#sub read_mesa_messages() {
#  $scDir = "$MESA_STORAGE/modality/st_comm/MESA";
#
#  opendir SC, $scDir or die "directory: $scDir not found";
#  @scMsgs = readdir SC;
#  closedir SC;
#}
#
#sub grade_messages () {
#  MESSAGE: foreach $message (@scMsgs) {
#    next MESSAGE if ($message eq ".");
#    next MESSAGE if ($message eq "..");
#
#    $mesa = "$scDir/$message";
#
#    report( "$mesa");
#    #print LOG "$mesa \n";
#
#    $uid = `$MESA_TARGET/bin/dcm_print_element 0008 1195 $mesa`;
#    chomp $uid;
#    if ($uid eq "") {
#      report( "Could not get transaction UID for $mesa \n");
#      exit 1;
#    }
#
#    #print LOG "$uid \n";
#    report( "$uid \n");
#
#    $vendorFile = $vendor{$uid};
#    if ($vendorFile eq "") {
#      report( "No matching vendor file for $uid \n");
#      $grade = 1;
#      next MESSAGE;
#    }
#
#    report( "$vendorFile \n");
#
#    report( `$MESA_TARGET/bin/evaluate_storage_commitment -v $mesa $vendorFile`);
#    if ($? != 0) {
#      $grade = 1;
#    }
#  }
#}

sub grade_one_message {
  my $mesaMessage = shift(@_);

  report( "$mesaMessage");

  $uid = `$MESA_TARGET/bin/dcm_print_element 0008 1195 $mesaMessage`;
  chomp $uid;
  if ($uid eq "") {
    report( "Could not get transaction UID for $mesaMessage \n");
    exit 1;
  }

  report( "$uid \n");

  $vendorFile = $vendor{$uid};
  if ($vendorFile eq "") {
    report( "No matching vendor file for $uid \n");
    return 1;
  }

  report( "$vendorFile \n");

  $x = "$MESA_TARGET/bin/evaluate_storage_commitment ";
  $x .= " -v " if $verbose;
  $x .= " $mesaMessage $vendorFile";
  print REPORT `$x`;
  if ($? != 0) {
     return 1;
  }
 return 0;
}

sub eval_405_1
{
  $rtnValue = grade_one_message("$MESA_STORAGE/modality/Px1/sc.xxx");

  return $rtnValue;
}

sub eval_405_2
{
  $rtnValue = grade_one_message("$MESA_STORAGE/modality/Px2/sc.xxx");

  return $rtnValue;
}

sub eval_405_3
{
  $rtnValue = grade_one_message("$MESA_STORAGE/modality/Px6/sc.xxx");

  return $rtnValue;
}

sub eval_405_4
{
  $rtnValue = grade_one_message("$MESA_STORAGE/modality/Px7/sc.xxx");

  return $rtnValue;
}

#==========
# Main starts here

if (scalar(@ARGV) < 1) {
  print "This script requires one argument: \n" .
        "    <AE Title of your Storage Commitment SCP\n";
  exit 1;
}
$verbose = grep /^-v/, @ARGV;

$titleSC = $ARGV[0];


open REPORT, ">405/grade_405a.txt";

#%parms = imgmgr::read_config_params_hash();

create_vendor_hash;

#read_mesa_messages;

$grade = 0;

$grade += eval_405_1;
$grade += eval_405_2;
$grade += eval_405_3;
$grade += eval_405_4;

#grade_messages;

if ($grade == 0) {
  report( "Image Manager Storage Commitment Test passed\n");
  print "Report is in file 405/grade_405a.txt\n";
} else {
  report( "Image Manager Storage Commitment Test failed\n");
  print "Report is in file 405/grade_405a.txt\n";
}

exit $grade;
