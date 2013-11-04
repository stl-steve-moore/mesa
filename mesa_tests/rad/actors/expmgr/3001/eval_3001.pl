#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/common/scripts";
require evaluate_tfcte;
require mesa;

sub goodbye() {
  exit 1;
}

die "Usage <log level: 1-4> " if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">3001/grade_3001.txt" or die "Could not open output file: 3001/grade_3001.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$konClassUID = "1.2.840.10008.5.1.4.1.1.88.59";
$diff = 0;
$testNum = 1;
$actor = "Export Manager";
$testSenario = "3001";

#exprcr
# Search the database for the set of composite objects sent by the Export Manager under test
# to the MESA Export Receiver
my($status, @exprcr) = mesa::db_table_retrieval($logLevel,"exprcr", "sopins", "filnam");
my $z1 = @exprcr;
print LOG "CTX: During test $testSenario, MESA produced $z1 SOP instances.\n";

# Get the list of KON objects produced by the Export Manager
@rcr_kons = evaluate_tfcte::getKON($logLevel,$konClassUID, @exprcr);
evaluate_tfcte::displayList("rcr_kons",@rcr_kons) if($logLevel >= 3);

# Get the list of Image Objects deidentified/transmitted by the Export Manager.
@rcr_imgs = evaluate_tfcte::getIMG($logLevel,$konClassUID, @exprcr);
evaluate_tfcte::displayList("rcr_imgs",@rcr_imgs) if($logLevel >= 3);

print LOG "\n";
#$diff += evaluate_tfcte::eval_KON_structure($logLevel,"$actor $testSenario.$testNum", "3001", @rcr_kons);
#$testNum++;

$diff += evaluate_tfcte::eval_KON_attributes($logLevel,"$actor $testSenario.$testNum", "Testing KON Attribute - Title", "Title", @rcr_kons);
$testNum++;


$diff += evaluate_tfcte::eval_IMG_Referenced_By_KON($logLevel,"$actor $testSenario.$testNum", $rcr_kons[0], \@rcr_imgs, 1);
$testNum++;

$diff += evaluate_tfcte::eval_Deidentify_Data($logLevel,"$actor $testSenario.$testNum", "Evaluating deidentification of image instances", "3001", "deltaIM.txt", @rcr_imgs);
$testNum++;

$diff += evaluate_tfcte::eval_Deidentify_Data($logLevel,"$actor $testSenario.$testNum", "Evaluating deidentification of KON", "3001", "deltaKON.txt", @rcr_kons);
$testNum++;

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3001/grade_3001.txt \n";

exit $diff;
