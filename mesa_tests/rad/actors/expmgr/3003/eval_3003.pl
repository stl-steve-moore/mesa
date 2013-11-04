#!/usr/local/bin/perl -w

use Env;

use lib "../../../rad/actors/common/scripts";
require evaluate_tfcte;
require mesa;

#use lib "scripts";
#require expmgr;

require Exporter;
@ISA = qw(Exporter);

sub goodbye() {
  exit 1;
}

die "Usage <log level: 1-4> " if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];

open LOG, ">3003/grade_3003.txt" or die "Could not open output file: 3003/grade_3003.txt";
my $mesaVersion = mesa::getMESAVersion();
print LOG "CTX: $mesaVersion \n";

$diff = 0;
#$testNum = 1;
$actor = "Export Manager";
#$testSenario = "3003";

#exprcr
# Search the database for the set of composite objects sent by the Export Manager under test
# to the MESA Export Receiver
($status, @filnam) = mesa::db_table_retrieval($logLevel,"exprcr", "sopins", "filnam");
my $z1 = @filnam;
print LOG "CTX: During test 3003, the Export Manager under test produced $z1 SOP instances.\n";

#expmgr
# Search the database for the set of composite objects created/sent by MESA to the
# MESA Export Manager.
($status, @expmgr) = mesa::db_table_retrieval($logLevel,"expmgr", "sopins", "filnam");
my $z2 = @expmgr;
print LOG "CTX: During test 3003, MESA produced $z2 SOP instances.\n";

# define global varibles
$studyTag = "0020 000d";
$seriesTag = "0020 000e";
$instanceTag = "0008 0018";
$konClassUID = "1.2.840.10008.5.1.4.1.1.88.59";

# Get the list of KON objects produced by the Export Manager
@rcr_kons = evaluate_tfcte::getKON($logLevel,$konClassUID, @filnam);
evaluate_tfcte::displayList("rcr_kons",@rcr_kons) if($logLevel >= 3);
# Get the list of KON objects produced by MESA
@mgr_kons = evaluate_tfcte::getKON($logLevel, $konClassUID, @expmgr);
evaluate_tfcte::displayList("mgr_kons",@mgr_kons) if($logLevel >= 3);

# Get the list of Image Objects deidentified/transmitted by the Export Manager.
@rcr_imgs = evaluate_tfcte::getIMG($logLevel,$konClassUID, @filnam);
#evaluate_tfcte::displayList("rcr_imgs",@rcr_imgs) if($logLevel >= 3);

print LOG "\n";
my $expectedValue = 2;
$diff += evaluate_tfcte::check_KON_number($logLevel,"$actor 3003.1", $expectedValue, @rcr_kons);
#$testNum++;

#$diff += evaluate_tfcte::eval_KON_structure($logLevel,"$actor 3003.2", "3003", @rcr_kons);
#$testNum++;

$diff += evaluate_tfcte::eval_KON_attributes($logLevel,"$actor 3003.3", "Testing KON Attribute - Title", "Title", @rcr_kons);
#$testNum++;

$diff += evaluate_tfcte::eval_KON_Desc($logLevel,"$actor 3003.4", "Testing KON Attribute - Key Object Description", \@rcr_kons,);
#$testNum++;

$diff += evaluate_tfcte::eval_IMG_Referenced_By_KON($logLevel,"$actor 3003.5", $rcr_kons[0], \@rcr_imgs, 2);
#$testNum++;


$diff += evaluate_tfcte::eval_IMG_Referenced_By_KON($logLevel,"$actor 3003.6", $rcr_kons[1], \@rcr_imgs, 2);
#$testNum++;
#print LOG "diff = $diff\n";

$diff += evaluate_tfcte::eval_Deidentify_Data($logLevel,"$actor 3003.7", "Evaluating deidentification of image instances", "3003", "deltaIM.txt", @rcr_imgs);
#$testNum++;
#print LOG "diff = $diff\n";

$diff += evaluate_tfcte::eval_Deidentify_Data($logLevel,"$actor 3003.8", "Evaluating deidentification of KONs", "3003", "deltaKON.txt", @rcr_kons);
#$testNum++;
#print LOG "diff = $diff\n";

# These next 3 tests make sure the Export Manager under test has produced
# the correct number of objects: studies, series, instance.
# The routines compare the number of objects produced by the Export Manager with the number produced by MESA.
# It also check the UIDs are different, For expample, if there are 2 studies MESA, then it is 2 study UIDs are different from those study UIDs by Test System.

$diff += evaluate_tfcte::compareCountAndUID($logLevel,"$actor 3003.9", "Export Manager compare studies", $studyTag, "studies", \@filnam, \@expmgr);
#$testNum++;

$diff += evaluate_tfcte::compareCountAndUID($logLevel,"$actor 3003.10", "Export Manager compare series", $seriesTag, "series", \@filnam, \@expmgr);
#$testNum++;

$diff += evaluate_tfcte::compareCountAndUID($logLevel,"$actor 3003.11", "Export Manager compare instances", $instanceTag, "instances", \@filnam, \@expmgr);
#$testNum++;
#print LOG "diff = $diff\n";

# Test two collections of objects have the same number of distinct tag1 value per tag 2 value
# example: In MESA images and Test System images, test if series count per Study are the same for the 2 collections

$diff += evaluate_tfcte::compare_Tag1Count_Per_Tag2($logLevel,"$actor 3003.12", "comparing series count per study", "series", $seriesTag, $studyTag, \@filnam, \@expmgr);
#$testNum++;

$diff += evaluate_tfcte::compare_Tag1Count_Per_Tag2($logLevel,"$actor 3003.13", "comparing instance count per series", "instances", $instanceTag,$seriesTag, \@filnam, \@expmgr);
#$testNum++;
#print LOG "diff = $diff\n";
# Test if the 2nd kon is the same content sequence structure as 1st kon.
# For example, one kon is from Export Manager, 2nd one is from MESA.
$diff += evaluate_tfcte::testContentSeqStructure($logLevel, "$actor 3003.14", "Testing Content Sequence Structure of KON: $rcr_kons[0]", $mgr_kons[1], $rcr_kons[0]);
#$testNum++;

$diff += evaluate_tfcte::testContentSeqStructure($logLevel, "$actor 3003.15", "Testing Content Sequence Structure of KON: $rcr_kons[1]", $mgr_kons[1], $rcr_kons[1]);
#$testNum++;
#print LOG "diff = $diff\n";
#Test content sequence images are the same for 2 kons from export manager
my @rcr_kon1_con_seq_imgs = evaluate_tfcte::getContentSeqImages($logLevel, $rcr_kons[0]);
my @rcr_kon2_con_seq_imgs = evaluate_tfcte::getContentSeqImages($logLevel, $rcr_kons[1]);
my %rcr_kon1_con_seq_imgs = @rcr_kon1_con_seq_imgs;
my %rcr_kon2_con_seq_imgs = @rcr_kon2_con_seq_imgs;
evaluate_tfcte::displayList("rcr_kon1_con_seq_imgs",@rcr_kon1_con_seq_imgs) if($logLevel >=3);
evaluate_tfcte::displayList("rcr_kon2_con_seq_imgs",@rcr_kon2_con_seq_imgs) if($logLevel >=3);
#evaluate_tfcte::displayMap("rcr_kon1_con_seq_imgs",%rcr_kon1_con_seq_imgs) if($logLevel >=3);
#evaluate_tfcte::displayMap("rcr_kon2_con_seq_imgs",%rcr_kon2_con_seq_imgs) if($logLevel >=3);

$diff += evaluate_tfcte::testArrayEqual($logLevel, "$actor 3003.16", "Testing Content Sequence Images are identical for 2 KONs from Export Manager", \@rcr_kon1_con_seq_imgs, \@rcr_kon2_con_seq_imgs);
#$testNum++;
#print LOG "diff = $diff\n";
#Test Content Sequence images and Evidence Sequence images are the same.
my ($s1,%rcr_kon1_evd_seq_imgs) =  mesa::getKONInstanceManifest($logLevel, $rcr_kons[0], 2);

$diff += evaluate_tfcte::testHashEqual($logLevel, "$actor 3003.17", "Testing Images are identical in Content Sequence Images and Current Requested Procedure Evidence Sequence for KON <$rcr_kons[0]> from Export Manager.", \%rcr_kon1_con_seq_imgs, \%rcr_kon1_evd_seq_imgs);
#$testNum++;

my ($s2,%rcr_kon2_evd_seq_imgs) =  mesa::getKONInstanceManifest($logLevel, $rcr_kons[1], 2);

$diff += evaluate_tfcte::testHashEqual($logLevel, "$actor 3003.18", "Testing Images are identical in Content Sequence Images and Current Requested Procedure Evidence Sequence for KON <$rcr_kons[1]> from Export Manager.", \%rcr_kon2_con_seq_imgs, \%rcr_kon2_evd_seq_imgs);
#$testNum++;
#print LOG "diff = $diff\n";

#Test content sequence images UIDs are distinct among the 4 kons: 2 from MESA, 2 from Test System.
my %mgr_kon1_con_seq_imgs = evaluate_tfcte::getContentSeqImages($logLevel, $mgr_kons[0]);
my %mgr_kon2_con_seq_imgs = evaluate_tfcte::getContentSeqImages($logLevel, $mgr_kons[1]);

$diff += evaluate_tfcte::testHashKeyDistinct($logLevel, "$actor 3003.19", "Checking content sequence images UIDs are distinct between Test System KON1 <$rcr_kons[0]> and MESA tool KON1 <$mgr_kons[0]>",\%rcr_kon1_con_seq_imgs, \%mgr_kon1_con_seq_imgs);
#$testNum++;

#Not need to test: $diff += evaluate_tfcte::testHashKeyDistinct($logLevel, "Export Manager 3003.18", "Checking content sequence images UIDs are distinct between Test System KON2 <$rcr_kons[1]> and MESA tool KON1 <$mgr_kons[0]>",\%rcr_kon2_con_seq_imgs, \%mgr_kon1_con_seq_imgs);

$diff += evaluate_tfcte::testHashKeyDistinct($logLevel, "$actor 3003.20", "Checking content sequence images UIDs are distinct between Test System KON1 <$rcr_kons[0]> and MESA tool KON2 <$mgr_kons[1]>",\%rcr_kon1_con_seq_imgs, \%mgr_kon2_con_seq_imgs);
#$testNum++;
#print LOG "diff = $diff\n";
#Not need to test: $diff += evaluate_tfcte::testHashKeyDistinct($logLevel, "Export Manager 3003.20", "Checking content sequence images UIDs are distinct between Test System KON2 <$rcr_kons[1]> and MESA tool KON2 <$mgr_kons[1]>",\%rcr_kon2_con_seq_imgs, \%mgr_kon2_con_seq_imgs);

#Test evidence Sequence image UIDSs are distinct among the 4 kons:  2 from MESA, 2 from Test System.
my ($s3,%mgr_kon1_evd_seq_imgs) =  mesa::getKONInstanceManifest($logLevel, $mgr_kons[0], 2);
my ($s4,%mgr_kon2_evd_seq_imgs) =  mesa::getKONInstanceManifest($logLevel, $mgr_kons[1], 2);

$diff += evaluate_tfcte::testHashKeyDistinct($logLevel, "$actor 3003.21", "Checking evidence sequence images UIDs are distinct between Test System KON1 <$rcr_kons[0]> and MESA tool KON1 <$mgr_kons[0]>",\%rcr_kon1_evd_seq_imgs, \%mgr_kon1_evd_seq_imgs);
#$testNum++;
#print LOG "diff = $diff\n";
#Not need to test: $diff += evaluate_tfcte::testHashKeyDistinct($logLevel, "Export Manager 3003.18", "Checking evidence sequence images UIDs are distinct between Test System KON2 <$rcr_kons[1]> and MESA tool KON1 <$mgr_kons[0]>",\%rcr_kon2_evd_seq_imgs, \%mgr_kon1_evd_seq_imgs);

$diff += evaluate_tfcte::testHashKeyDistinct($logLevel, "$actor 3003.22", "Checking evidence sequence images UIDs are distinct between Test System KON1 <$rcr_kons[0]> and MESA tool KON2 <$mgr_kons[1]>",\%rcr_kon1_evd_seq_imgs, \%mgr_kon2_evd_seq_imgs);
#$testNum++;
#print LOG "diff = $diff\n";
#Not need to test: $diff += evaluate_tfcte::testHashKeyDistinct($logLevel, "Export Manager 3003.20", "Checking evidence sequence images UIDs are distinct between Test System KON2 <$rcr_kons[1]> and MESA tool KON2 <$mgr_kons[1]>",\%rcr_kon2_evd_seq_imgs, \%mgr_kon2_evd_seq_imgs);

#Test two kons are identical except Study uid, series uid, sop instance uid are different and identical document sequence refer to each other.

$diff += evaluate_tfcte::evalSyncronizedKONs($logLevel, "$actor 3003.23", "Testing two KONs are syncronized.", $rcr_kons[0], $rcr_kons[1]);
#$testNum++;
#print LOG "diff = $diff\n";


print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 3003/grade_3003.txt \n";

exit $diff;
