#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/common/scripts";
use lib "../../../common/scripts";
require evaluate_tfcte;
require mesa;
require mesa_common;
require mesa_evaluate;
#require expsel;

sub goodbye() {
  exit 1;
}

sub dummy {}

sub placatePERLInterpreter {
}

die "Usage <log level: 1-4> <TF | CT> \n where TF is for Teaching File and CT for Clinical Trial" if (scalar(@ARGV) < 2);

$logLevel     = $ARGV[0];
my $title = "Title-Teaching-File";
if ($ARGV[1] eq "CT") { $title = "Title-Clinical-Trial";}

open LOG, ">3001/grade_3001.txt" or die "Could not open output file: 3001/grade_3001.txt";
my $version = mesa_get::getMESANumericVersion();
my $numericVersion = mesa_get::getMESANumericVersion();
($x, $date, $timeMin, $timeToSec) = mesa_get::getDateTime(0);
dummy($x); dummy($timeMin); dummy($timeToSec);

print LOG "CTX: Test:    3001\n";
print LOG "CTX: Actor:   EXPORT_SELECTOR\n";
print LOG "CTX: Version: $numericVersion\n";
print LOG "CTX: Date:    $date\n";

$diff = 0;

#expmgr
# Search the database for the set of composite objects sent to MESA Export Manager by Test Export Slector.
($status, @filnam) = mesa::db_table_retrieval($logLevel,"expmgr", "sopins", "filnam");
my $z1 = @filnam;
print LOG "CTX: During test 3001, the Test Export Selector has sent $z1 SOP instances.\n";
print LOG "ERR: During test 3001, DB retrieval error\n" if ($status != 0);

$count = scalar(@filnam);
if ($count == 0) {
  print LOG "ERR: Zero images were sent to MESA Export Manager. That is a failure\n";
  print LOG "ERR: Look in the database: expmgr. The sopins table is supposed to have entries\n";
  $diff += 1;
}

# define global varibles
$studyTag = "0020 000d";
$seriesTag = "0020 000e";
$instanceTag = "0008 0018";

$classUID = "1.2.840.10008.5.1.4.1.1.88.59";

# Get the list of KON objects
@mgr_kons = evaluate_tfcte::getKON($logLevel,$classUID, @filnam);

$count = scalar(@mgr_kons);
if ($count == 0) {
  print LOG "ERR: Zero KON manifests were sent to MESA Export Manager. That is a failure\n";
  print LOG "ERR: Look in the database: expmgr. The sopins table is supposed to have entries\n";
  $diff += 1;
}

# Get the list of Image Objects sent to MESA Export Manager.
@mgr_imgs = evaluate_tfcte::getIMG($logLevel, $classUID, @filnam);
#displayList("mgr_imgs",@mgr_imgs) if($logLevel >= 3);

print LOG "\n";
#$diff += evaluate_tfcte::eval_KON_structure($logLevel,"Export Selector 3001.1", @mgr_kons);
$diff += evaluate_tfcte::eval_KON_attributes($logLevel,"Export Selector 3001.2", "Testing KON Attribute - Title",, $title, @mgr_kons);
#$diff += evaluate_tfcte::eval_IMG_Referenced_By_KON($logLevel,"Export Selector 3001.3", \@mgr_kons, \@mgr_imgs);

placatePERLInterpreter($studyTag, $seriesTag, $instanceTag, @mgr_imgs);

if ($logLevel != 4) {
  $diff += 1;
  print LOG "ERR: Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.\n";
}

close LOG;

mesa_evaluate::copyLogWithXML("3001/grade_3001.txt", "3001/mir_mesa_3001.xml",
        $logLevel, "3001", "EXPORT_SELECTOR", $numericVersion, $date, $diff);

if ($diff == 0) {
  print "\nThis test completed with zero errors; that means successful test\n";
} else {
  print "Test detected $diff errors; this implies a failure\n";
  print " Please consult 3001/grade_3001.txt and 3001/mir_mesa_3001.xml\n";
}

print "If you are submitting a result file to Kudu, submit 3001/mir_mesa_3001.xml\n\n";

