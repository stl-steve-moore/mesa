#!/usr/local/bin/perl -w

use Env;

#use lib "../../../rad/actors/common/scripts";
#require mesa;
use lib "../../../common/scripts";
require mesa_hl7_eval_support;
require mesa_get;

sub goodbye() {
  exit 1;
}

sub evaluate_IDCO_ORU_XML {
  my ($logLevel, $testHL7, $mesaHL7) = @_;
  my $errorCount = 0;
  print main::LOG "CTX: mesa::evaluate_IDCO_ORU_XML $testHL7\n" if ($logLevel >= 3);
  
  my @hl7_attributes = (
       #evalType, segment, segIndex, fieldNum,  comp, value, 			fieldName,
        "EQUAL",  "MSH",     1,        1,        0,   "|",    			"Field Seperator",
	"EQUAL",  "MSH",     1,        2,        0,   "^~\\&", 			"Encoding Characters",   
	"EXIST",  "MSH",     1,        3,        0,   "",     			"Sending Application",
	"EXIST",  "MSH",     1,        4,        0,   "",     			"Sending Facility",
	"EXIST",  "MSH",     1,        5,        0,   "",     			"Receiving Application",
	"EXIST",  "MSH",     1,        6,        0,   "",     			"Receiving Application",
	"EXIST",  "MSH",     1,        7,        0,   "",     			"Date/Time of Message",
	#"EXIST",  "MSH",     1,        8,        0,   "",     			"test not exist",
	"EQUAL",  "MSH",     1,        9,        1,   "ORU",    		"Message Type/Msg Code",
	"EQUAL",  "MSH",     1,        9,        2,   "R01",    		"Message Type/Msg Code",
	"EXIST",  "MSH",     1,        10,       0,   "",     			"Message Control ID",
	"EQUAL",  "MSH",     1,        11,       0,   "P",    			"Processing ID",
	"EQUAL",  "MSH",     1,        12,       0,   "2.5",    		"Version ID",
	
	"EQUAL",  "PID",     1,        3,        4,   "GDT",    		"Pat Id List/Assigning Authority",
	"EQUAL",  "PID",     1,        3,        5,   "MS",     		"Pat Id List/Identifier Type Code",
	"EXIST",  "PID",     1,        5,        0,   "",     			"Patient Name",
	
	"EXIST",  "PV1",     1,        1,        0,   "",     			"Set ID-PV1",
	"EXIST",  "PV1",     1,        2,        0,   "",     			"Patient Class",
	
	"EXIST",  "OBR",     1,        1,        0,   "",     			"Set ID - OBR",
	"EXIST",  "OBR",     1,        3,        0,   "",     			"Filler Order Number",
	"OR",     "OBR",     1,        4,        1,   "Implant^Follow-up",    	"Universal Service ID/Identifier",
	"EXIST",  "OBR",     1,        4,        2,   "",       		"Universal Service ID/Text",
	"EXIST",  "OBR",     1,        7,        0,   "",       		"Obs. Date/Time",
	"OR",     "OBR",     1,        25,       0,   "R^P^F^C",		"Result Status",
	"EXIST",  "OBR",     1,        7,        0,   "",       		"Obs. Date/Time",
	
	"EXIST",  "OBX",     1,        1,        0,   "",     			"Set ID - OBX",
	"EXIST",  "OBX",     1,        2,        0,   "",     			"Value Type",
	"EQUAL",  "OBX",     1,        3,        1,   "IDC",     		"Observation Identifier/Identifier",
	"EQUAL",  "OBX",     1,        3,        2,   "Implantable Cardiac Device Follow-up Observation",     "Observation Identifier/Text",
	"EQUAL",  "OBX",     1,        3,        3,   "99IHE",     		"Observation Identifier/Name of Coding System",
	"EQUAL",  "OBX",     1,        5,        2,   "Application", 		"Observation Value/Type of Data",
	"EQUAL",  "OBX",     1,        5,        3,   "XML",      		"Observation Value/Data Subtype",
	"EQUAL",  "OBX",     1,        5,        4,   "Base64",   		"Observation Value/Encoding",
	"EXIST",  "OBX",     1,        5,        5,   "",   			"Observation Value/Data",
	"EXIST",  "OBX",     1,       11,        0,   "",  		 	"Observation Result Status",
	"EXIST",  "OBX",     1,       17,        1,   "",   			"Observation Method/Identifier",
	"EXIST",  "OBX",     1,       17,        2,   "",   			"Observation Method/Text",
	"EQUAL",  "OBX",     1,       17,        3,   "IEEE P10731.1.3",   	"Observation Method/Name of Coding System",
	
  );
  $errorCount = mesa_hl7_eval_support::evalHL7FieldValueList($logLevel,$testHL7, $mesaHL7, "2.5",@hl7_attributes);
  $errorCount = eval_PID3_1($logLevel, $testHL7);
  return $errorCount;
}

sub eval_PID3_1{
   my ($logLevel, $hl7) = @_;
   my $errorCount = 0;
   my ($status, $testValue)  = mesa_get::getHL7FieldRepeatedSegment($logLevel, $hl7, "PID", 1, 3, 1, "Patient Identifier List/ID number", "2.5");
   if($logLevel >= 3){
      print main::LOG "CTX: Segment <PID> Field# <3> Filed Name <Patient Identifier List/ID number> ";
      print main::LOG "Component <1> ";
      print main::LOG "value retrieved: <$testValue>\n";
   }
   if($testValue =~ /^model:.+\/serial:.+\b/){
      print main::LOG "CTX: Segment <PID> Field# <3> Filed Name <Patient Identifier List/ID number> is valid format\n";
   }else{
      print main::LOG "ERR: Segment <PID> Field# <3> Filed Name <Patient Identifier List/ID number> is NOT valid format\n";
      $errorCount++;
   }
   #my @idComponents = split(/\//, $testValue);
   #my $size = scalar(@idComponents);
   #if($size != 2){
   #   print main::LOG "ERR: Segment <$segment> Field# <3> Filed Name <Patient Identifier List/ID number> ";
   #   print main::LOG "Component <1> ";
   #   print main::LOG "value is not deliminated by \/ TEST: <$testValue>\n";
   #   $errorCount++;
   #}elsif($idComponents[0] ~= ){
      
   #}
   return $errorCount;
}


### Main starts here
die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);

$logLevel     = $ARGV[0];
open LOG, ">20810/grade_20810.txt" or die "?!";
$diff = 0;

my $testHL7 = "$MESA_STORAGE/rpt_manager/hl7/1001.hl7";
my $mesaHL7 = "../../msgs/idco/20810/20810.102.r01.hl7";

if (! -e $testHL7){
   die "Could not find the HL7 to be tested: $testHL7\n";
}

if (! -e $mesaHL7){
  die "Could not find the MESA HL7 messgae: $testHL7\n";
}

$diff += evaluate_IDCO_ORU_XML($logLevel, $testHL7, $mesaHL7);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 20810/grade_20810.txt \n";
#print "OBX-5 Observation Value should include Study Instance UID as ISO OID in the OBX segment with DICOM Study Instance UID.\n";
#print "OBX-5 Observation Value should include an ISO OID for the report limited to 64 characters in the OBX segment with Encapsulated PDF.\n";
#print "Please check OBX-5 which is stored in 20501/grade_20501.txt \n";

exit $diff;
