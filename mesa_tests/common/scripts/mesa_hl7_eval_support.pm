#!/usr/local/bin/perl -w

# Supp ortpackage for MESA HL7 evaluation.

use Env;

package mesa_hl7_eval_support;

require mesa_evaluate;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

sub evalHL7FieldValueList {
   my ($logLevel, $testHL7, $mesaHL7, $version, @entries) = @_;
   my $idx = 0;
   my $errorCount = 0;
   while ($idx < scalar(@entries)) {
        my $evalType = $entries[$idx+0];
	my $segment = $entries[$idx+1];
	my $segIndex = $entries[$idx+2];
	my $fieldNum = $entries[$idx+3];
	my $comp = $entries[$idx+4];
	my $refValue = $entries[$idx+5];
	my $fieldName = $entries[$idx+6];
	
	my ($status, $testValue)  = mesa_get::getHL7FieldRepeatedSegment($logLevel, $testHL7, $segment, $segIndex, $fieldNum, $comp, $fieldName, $version);
	if($logLevel >= 3){
	   print main::LOG "CTX: Segment <$segment> Field# <$fieldNum> Filed Name <$fieldName> ";
	   print main::LOG "Component <$comp> " if ($comp != 0);
	   print main::LOG "value retrieved: <$testValue>\n" ;
	}

	#print "$comp\n";
	if($evalType eq "EQUAL"){
	   (my $refStatus, $refValue) =  mesa_get::getHL7FieldRepeatedSegment($logLevel, $mesaHL7, $segment, $segIndex, $fieldNum, $comp, $fieldName, $version); 
	   if ($testValue ne $refValue) {
      	      print main::LOG "ERR: Segment <$segment> Field# <$fieldNum> Filed Name <$fieldName> ";
	      print main::LOG "Component <$comp> " if ($comp != 0);
	      print main::LOG "value does NOT match REF: <$refValue> TEST: <$testValue>\n";
      	      $errorCount++;
           }else{
	      print main::LOG "CTX: Segment <$segment> Field# <$fieldNum> Filed Name <$fieldName> ";
	      print main::LOG "Component <$comp> " if ($comp != 0);
	      print main::LOG "value match REF: <$refValue> TEST: <$testValue>\n";
	   }
	}elsif($evalType eq "OR"){
	   my @refValues = split(/\^/, $refValue);
	   my $retValue = mesa_evaluate::arrayContains($testValue, @refValues);
	   if ($retValue != 1){
	      print main::LOG "ERR: Segment <$segment> Field# <$fieldNum> Filed Name <$fieldName> ";
	      print main::LOG "Component <$comp> " if ($comp != 0);
	      print main::LOG "value is NOT one of valid values: REF: <$refValue> TEST: <$testValue>\n";
	      $errorCount++;
	   }else{
	      print main::LOG "CTX: Segment <$segment> Field# <$fieldNum> Filed Name <$fieldName> ";
	      print main::LOG "Component <$comp> " if ($comp != 0);
	      print main::LOG "value is one of valid values: REF: <$refValue> TEST: <$testValue>\n";
	   }
	}elsif($evalType eq "EXIST"){
	   if ($status != 1 && $testValue ne ""){
	      print main::LOG "CTX: Segment <$segment> Field# <$fieldNum> Filed Name <$fieldName> ";
	      print main::LOG "Component <$comp> " if ($comp != 0);
	      print main::LOG "value exist.\n";
	   }else{
	      print main::LOG "ERR: Segment <$segment> Field# <$fieldNum> Filed Name <$fieldName> ";
	      print main::LOG "Component <$comp> " if ($comp != 0);
	      print main::LOG "value does NOT exist.\n";
	      $errorCount++;
	   }
	}else {
           die "Unsupported evaluation type: $evalType";
        }
	$idx += 7;
   }	

   return $errorCount;
}

1;
