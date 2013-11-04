#!/usr/local/bin/perl -w

# General package for evaluating Teaching File/Clinical Trial Export.  This file contains all the announcments.
package evaluate_tfcte;
#use strict;

use Env;
use Date::Manip;
#require 5.001;

#package evaluate_tfcte;

require Exporter;
@ISA = qw(Exporter);

my $studyTag = "0020 000d";
my $seriesTag = "0020 000e";
my $instanceTag = "0008 0018";
my $konClassUID = "1.2.840.10008.5.1.4.1.1.88.59";
$attributes{"Title"} = ["TCE001", "IHERADTF", "For Teaching File Export", "KON Title"];
$attributes{"Title-Teaching-File"} = ["TCE001", "IHERADTF", "For Teaching File Export", "KON Title"];
$attributes{"Title-Clinical-Trial"} = ["TCE002", "IHERADTF", "For Clinical Trial Export", "KON Title"];
$attributes{"KONDesc"} = ["113012", "DCM", "Key Object Description", "KON Description"];
$attributes{"TitleModifier"} = ["113011", "DCM", "Document Title Modifier", "Title Modifier"];

sub evaluate_KON_TFCTE_Title {
  my ($logLevel, $path, $codeMESA, $designatorMESA, $textMESA) = @_;
  my $errorCount = 0;

  my ($s1, $codeTest) = mesa::getDICOMAttribute($logLevel, $path, "0008 0100", "0040 a043");
  if ($logLevel >= 3) {
    print main::LOG "CTX: KON Title, Code 0040 A043 0008 0100 MESA: ($codeMESA) Test: ($codeTest)\n";
  }
  if ($codeMESA ne $codeTest) {
    print main::LOG "ERR Coded value for KON Title does not match expected value\n";
    print main::LOG "ERR MESA value: ($codeMESA), Test value ($codeTest)\n";
    $errorCount += 1;
  }

  my ($s2, $designatorTest) = mesa::getDICOMAttribute($logLevel, $path, "0008 0102", "0040 a043");
  if ($logLevel >= 3) {
    print main::LOG "CTX: KON Title, Code Designator 0040 A043 0008 0102 MESA: ($designatorMESA) Test: ($designatorTest)\n";
  }
  if ($designatorTest ne $designatorMESA) {
    print main::LOG "ERR Code Designator value for KON Title does not match expected value\n";
    print main::LOG "ERR MESA value: ($designatorMESA), Test value ($designatorTest)\n";
    $errorCount += 1;
  }

  my ($s3, $textTest) = mesa::getDICOMAttribute($logLevel, $path, "0008 0104", "0040 a043");
  if ($logLevel >= 3) {
    print main::LOG "CTX: KON Title, Code Meaning 0040 A043 0008 0102 MESA: ($textMESA) Test: ($textTest)\n";
  }
  if ($textTest ne $textMESA) {
    print main::LOG "ERR Code Designator value for KON Code Meaning does not match expected value\n";
    print main::LOG "ERR MESA value: ($textMESA), Test value ($textTest)\n";
    $errorCount += 1;
  }

  return $errorCount;
}

sub eval_KON_structure {
  my($logLevel,$seqno, $testcase, @kons) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: Evaluating Teaching File/Clinical Trial KON structure\n";

  #my $count = 0;
  #my @tns = split(/\./, $seqno);
  #my $tmp = $tns[0];
  #my @tmp = split(/\s+/, $tmp);
  #my $size = @tmp;
  #my  $testcase = $tmp[$size-1];
  
  my $id = 1;
  foreach $p(@kons){
    print main::LOG "CTX: Path to KON $p\n" if ($logLevel >= 3);
    $count += mesa::evaluate_KON_TFCTE($logLevel,$p, $testcase, $id, "validation.ses");
    $id++;
  }
  
  #if($count == 0){
  #  print main::LOG "CTX: Succeeded in evaluating Teaching File/Clinical Trial KON structure\n";
  #}else{
  #  print main::LOG "ERR: Failed in evaluating Teaching File/Clinical Trial KON structure\n";
  #}
      
  print main::LOG "\n";
  #return eval_counting($count);
  return 0;
}

sub check_KON_number {
  my($logLevel,$seqno, $expectedVal, @kons) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: Checking number of Teaching File/Clinical Trial KONs\n";
  
  my $count = 0;
  my $length = @kons;
  
  if($length != $expectedVal){
    $count = 1;
    print main::LOG "ERR: There should be $expectedVal Key Object Notes, but there is(are) $length KON(s).\n";
  }
  
  if ($logLevel >= 3){
    displayList("@kons", @kons);
  }
  
  if($count == 0 ){
    print main::LOG "CTX: Succeeded in checking number of Teaching File/Clinical Trial KONs.\n";
  }else{
    print main::LOG "ERR: Failed in checking number of Teaching File/Clinical Trial KONs.\n";
  }
  
  print main::LOG "\n";
  return $count;
}

sub eval_KON_attributes {
  my($logLevel,$seqno, $desc, $attrib, @kons) = @_;
  
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc\n";

  #print main::LOG "\$attrib: $attrib\n\n\n";
  #print main::LOG "\$attributes: ".@{$attributes{$attrib}}."\n\n\n";

  my $count = 0;
  foreach $kon(@kons){
    print main::LOG "CTX: Path to KON $kon\n" if ($logLevel >= 3);
    #print main::LOG "CTX: Evaluating ".${$attributes{$attrib}}[3]."\n" if ($logLevel >= 3);
    $count += mesa::evaluate_KON_TFCTE_Attributes($logLevel, $kon, @{$attributes{$attrib}});
	#print main::LOG "\n\n";
  }
  
  if($count == 0){
    print main::LOG "CTX: Succeeded in $desc\n";
  }else{
    print main::LOG "ERR: Failed in $desc\n";
  }

  print main::LOG "\n";
  
  return eval_counting($count);
}

#Check number of images in db is the same as referenced in KON and check each image UID is the same as being referenced in KON also
sub eval_IMG_Referenced_By_KON {
  my($logLevel,$seqno, $kon, $a1, $maxIdx) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: Evaluating reference list of KON: $kon\n";

  #my $count = 0; 
  my @imgs = @{$a1};
   
  #Check number of images is the same as referenced in KON and check each image UID is the same as in KON also.
  my($count,%hash)=mesa::getKONInstanceManifest($logLevel,$kon, $maxIdx);
    
  if($count == 0){
    my $c1 = keys( %hash );
    my $c2 = @imgs;
    if($c1!=$c2){
      print main::LOG "ERR: There are ".keys(%hash)." image(s) referenced in KON, but there are ".@imgs." actual image(s).\n";
      $count++;
    }else{
      #displayMap("", %hash) if($logLevel >= 3);
      foreach (@imgs){
        my($s1,$instanceUID)=mesa::getDICOMAttribute($logLevel, $_, "0008 0018");
        my($s2,$classUID)=mesa::getDICOMAttribute($logLevel, $_, "0008 0016");
        if($hash{$instanceUID} eq $classUID){
          delete $hash{$instanceUID};
          print main::LOG "InstanceUID $instanceUID with ClassUID $classUID referenced in KON has been found.\n" if($logLevel >=3);
        } 
      }
        
      if(keys(%hash) > 0){
        print main::LOG "ERR: There are still ".keys(%hash)." image(s) referenced in KON, but not found in image list as follow:\n";
	displayMap("",%hash);;
        $count++;
      }else{
	print main::LOG "CTX: Evidence Sequence has equal number of image references and each refers to the correct image.\n";
      }
    }
  }else{
     print main::LOG "ERR: Failed to retrieve evidence sequence from $kon.\n";
     $count++;
  }
    
  if($count == 0 ){
    print main::LOG "CTX: Succeeded in evaluating reference list of KON: $kon\n";
  }else{
    print main::LOG "ERR: Failed in evaluating reference list of KON: $kon\n";
  }
  
  print main::LOG "\n\n";
  return eval_counting($count);
}

sub arraySizeEqual{
  my ($logLevel, $a1, $a2) =  @_;
  #my @a1 =  @{$a1};
  #my @a2 =  @{$a2};
  my $z1 = @{$a1};
  my $z2 = @{$a2};
  if ($z1 == $z2){
    return 0;
  }else{
    return 1;
  }  
}

sub hashSizeEqual{
  my ($logLevel, $h1, $h2) =  @_;
  my %h1 = %{$h1};
  my %h2 = %{$h2};
  return arraySizeEqual(keys(%h1), keys(%h2));
}

sub testHashKeyDistinct{
  my($logLevel,$seqno, $desc, $h1, $h2) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc\n";
  #print "$seqno\n";
  my %hash1 = %{$h1};
  my %hash2 = %{$h2};
  
  my $error = 0;

  if(hashSizeEqual($logLevel, \%hash1, \%hash2)){
    print main::LOG "ERR: The two hashes are of different size.\n";
    $error = 1;
  }
    
  my @keys1 = keys(%hash1);

  if(!$error){
    foreach $key(@keys1){
      my $value = $hash2{$key};
#      print "<$value>\n";
#      print main::LOG "CTX: Testing hash value <$value> of key $key in 2nd hash NOT equal to undef\n" if($logLevel >= 3);
      #if ($value ne undef){
      if (undef $value){
        $error = 1;
        last;
      }
    }
  }
  
  if ($error == 0){
    print main::LOG "CTX: Succeed in $desc\n";
  }else{
    print main::LOG "ERR: Failed in $desc\n";
  } 
  print main::LOG "\n";
  
  return $error;
}
#check the two kons are identical except Study uid, series uid, sop instance uid and identical document sequence are different.

sub  evalSyncronizedKONs{
  my ($logLevel, $seqno, $desc, $kon1, $kon2) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc\n";
  
  my $count = 0;
  my ($s1, $studyUID1) = mesa::getDICOMAttribute($logLevel, $kon1, $studyTag);
  my ($s2, $studyUID2) = mesa::getDICOMAttribute($logLevel, $kon2, $studyTag);
  if ($studyUID1 eq $studyUID2){
    print main::LOG "ERR: The two KONs are of the same study UID.\n";
    $count++;
  }else{
    print main::LOG "CTX: Study UIDs are different for the two KONs.\n" if ($logLevel >=3);
  }
  
  my ($s3, $seriesUID1) = mesa::getDICOMAttribute($logLevel, $kon1, $seriesTag);
  my ($s4, $seriesUID2) = mesa::getDICOMAttribute($logLevel, $kon2, $seriesTag);
  if ($seriesUID1 eq $seriesUID2){
    print main::LOG "ERR: The two KONs are of the same series UID.\n";
    $count++;
  }else{
    print main::LOG "CTX: Series UIDs are different for the two KONs.\n" if ($logLevel >=3);
  }
  
  my ($s5, $instanceUID1) = mesa::getDICOMAttribute($logLevel, $kon1, $instanceTag);
  my ($s6, $instanceUID2) = mesa::getDICOMAttribute($logLevel, $kon2, $instanceTag);
  if ($instanceUID1 eq $instanceUID2){
    print main::LOG "ERR: The two KONs are of the same SOP instance UID.\n";
    $count++;
  }else{
    print main::LOG "CTX: SOP instance UID are different for the two KONs.\n" if ($logLevel >=3);
  }
  
  my ($e1, @IDS_KON1) = getIndenticalDocSeqInfo($logLevel, $kon1);
  my ($e2, @IDS_KON2) = getIndenticalDocSeqInfo($logLevel, $kon2);

  my @INFO_KON1;
  @INFO_KON1 = (@INFO_KON1, $studyUID1);
  @INFO_KON1 = (@INFO_KON1, $seriesUID1);
  @INFO_KON1 = (@INFO_KON1, $instanceUID1);
  displayList("Info of KON $kon1:",@INFO_KON1) if ($logLevel >= 3);
  my @INFO_KON2;
  @INFO_KON2 = (@INFO_KON2, $studyUID2);
  @INFO_KON2 = (@INFO_KON2, $seriesUID2);
  @INFO_KON2 = (@INFO_KON2, $instanceUID2);
  displayList("Info of KON $kon2:",@INFO_KON2) if ($logLevel >= 3);
  
  #print main::LOG ("CTX: error code for e1=$e1, e2=$e2, count=$count\n") if ($logLevel >=3);
  if ($e1 ==0 && $e2 == 0){
    my $equal1 += arrayEqual($logLevel, \@IDS_KON1, \@INFO_KON2);
    if (!$equal1){
      print main::LOG "ERR: Failed in tesing Identical Document Sequence of KON $kon1 refer to $kon2\n";
      $count++;
    }else{
      print main::LOG "CTX: Succeeded in testing Identical Document Sequence of KON $kon1 refer to $kon2.\n";
    }
    
    my $equal2 += arrayEqual($logLevel, \@IDS_KON2, \@INFO_KON1);
    if (!$equal2){
      print main::LOG "ERR: Failed in tesing Identical Document Sequence of KON $kon2 refer to $kon1\n";
      $count++;
    }else{
      print main::LOG "CTX: Succeeded in testing Identical Document Sequence of KON $kon2 refer to $kon1.\n";
    }
  }else{
    $count++;
  }
  
  print("\n");
  return eval_counting($count);
}

sub getIndenticalDocSeqInfo{
  my ($logLevel, $kon) = @_;
  
  mesa::create_directory($logLevel, "$main::MESA_STORAGE/tmp");
  
  my $error = 0;
  my $x = "$main::MESA_TARGET/bin/dcm_dump_element 0040 A525 $kon $main::MESA_STORAGE/tmp/idenDocSeq.dcm";
  print main::LOG "CTX: $x\n" if ($logLevel >= 3);
  `$x`;
  if ($?){
    print main::LOG "ERR: Failed to retrieve identical Document Sequence from $kon.\n";
    $error++;
  }  
  
  if(!$error){
    my $y = "$main::MESA_TARGET/bin/dcm_dump_element 0008 1115 $main::MESA_STORAGE/tmp/idenDocSeq.dcm $main::MESA_STORAGE/tmp/idenDocSeqSer.dcm";
    print main::LOG "CTX: $y\n" if ($logLevel >= 3);
    `$y`;
    if ($?){
      print main::LOG "ERR: Failed to retrieve identical Document Sequence from $kon.\n";
      $error++;
    }
  }
  
  my @tmp;
  if(!$error){
    my $idx = 1;
    my ($s1, $refStudyUID) = mesa::getDICOMAttribute($logLevel, "$main::MESA_STORAGE/tmp/idenDocSeq.dcm", "0020 000d");
    my ($s2, $refSeriesUID) = mesa::getDICOMAttribute($logLevel, "$main::MESA_STORAGE/tmp/idenDocSeqSer.dcm", "0020 000e");
    my ($s3, $refInstanceUID) = mesa::getDICOMAttribute($logLevel, "$main::MESA_STORAGE/tmp/idenDocSeqSer.dcm", "0008 1155", "0008 1199", $idx);
    @tmp = (@tmp, $refStudyUID);
    @tmp = (@tmp, $refSeriesUID);
    @tmp = (@tmp, $refInstanceUID);
    displayList(": Identical Document Sequence from KON: $kon", @tmp) if ($logLevel >=3);
  }
  return ($error, @tmp); 
}

sub hashMerge{
  my ($logLevel, $h1, $h2) = @_;
  my %h1 = %{$h1};
  my %h2 = %{$h2};
  my $z1 = keys(%h1);
  my $z2 = keys(%h2);
  print main::LOG "CTX: hashMerge - 1st hash size = $z1, and hash size = $z2\n" if ($logLevel >=3);
  my %tmp = %h1;
  while( ($key, $value) = each(%h2)){
    $tarrayEqualmp{$key} = $value;
  }
  return %tmp;
}

#evaluate deidentification of images or KON
sub eval_Deidentify_Data {
  my($logLevel,$seqno, $desc, $deltaDir, $deltaFile,@a) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc\n";

  my $count = 0; 
  if ($logLevel >= 4){
    displayList("", @a);
  }
  $count += mesa::evaluate_deidentification($logLevel,$deltaDir, $deltaFile, @a);
  
  if ($count == 0){
    print main::LOG "CTX: Succeeded in $desc.\n";
  }else{
    print main::LOG "ERR: Failed in $desc.\n";
  }
  print main::LOG "\n";
  return eval_counting($count);
}

sub testHashEqual{
  my($logLevel,$seqno, $desc, $h1, $h2) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc.\n";  
  #print "$seqno\n";
  my $retVal = hashEqual($logLevel, $h1, $h2);
  my $count = 0;
    
  if ($retVal == 0){
    $count = 1;
    print main::LOG "ERR: Failed in $desc\n";
  }else{
    print main::LOG "CTX: Succeed in $desc\n";
  } 
  print main::LOG "\n";
  return $count;
}

# Hash same size, sorted keys are equal, and each value are the same.
sub hashEqual{
  my ($logLevel, $h1, $h2) = @_;
  
  my %h1 = %{$h1};
  my %h2 = %{$h2};
  my @key1 = sort (keys(%h1));
  my @key2 = sort (keys(%h2));
  my $z1 = @key1;
  my $z2 = @key2;
  my $equal = 1;
  
  if($z1 != $z2){
    print main::LOG "ERR: Hash sizes are different.\n" if ($logLevel >=3);
    $equal = 0;
  }else{
    if(!arrayEqual($logLevel, \@key1, \@key2)){
      print main::LOG "ERR: Hash keys are different.\n" if ($logLevel >=3);
      $equal = 0;
    }else{
      foreach(@key1){
        if($h1{$_} ne $h2{$_}){
	  print main::LOG "ERR: Hash values for key($_) are different in the 2 hashes: $h1{$_} and $h2{$_}\n" if ($logLevel >=3);
	  $equal = 0;
	  last;
	}
      }
    }
  }
  return $equal;
}

#Test 2 arrays with same size and same content at the same order.
sub testArrayEqual{
  my($logLevel,$seqno, $desc, $a1, $a2) = @_;
  print main::LOG "CTX: $seqno\n";
  #print main::LOG "CTX: Testing Content Sequence Images are identical for KON.\n";
  print main::LOG "CTX: $desc.\n";  
  #print "$seqno\n";
  #my @a1 = %{$h1};
  #my @a2 = %{$h2};
  #my $retVal = arrayEqual($logLevel, \@a1, \@a2);
  
  my $retVal = arrayEqual($logLevel, $a1, $a2);
  my $count = 0;
    
  if ($retVal == 0){
    $count = 1;
    print main::LOG "ERR: Failed in $desc\n";
  }else{
    print main::LOG "CTX: Succeeded in $desc\n";
  }  
  print main::LOG "\n";
  return $count;
}

# array of same size and every item at the same index is the same.
sub arrayEqual{
  my ($logLevel, $a1, $a2) = @_;
  print main::LOG "CTX: arrayEqual start:\n" if($logLevel >=3);
  my $z1 = @{$a1};
  my $z2 = @{$a2};
  my $equal = 1;
  
  if($z1 != $z2){
    print main::LOG "ERR: In arrayEqual meothod, the two arrays are of different size.\n";
    $equal = 0;
  }
  
  for ($i = 0; $i<$z1 && $equal; $i++){
    print main::LOG "CTX: Comparing <@{$a1}[$i]> and <@{$a2}[$i]>\n";
    if(@{$a1}[$i] ne @{$a2}[$i]){
      print main::LOG "ERR: In arrayEqual meothod, <@{$a1}[$i]> ne <@{$a2}[$i]>\n";
      $equal = 0;
      last;
    }
  }
  print main::LOG "CTX: arrayEqual end:\n" if($logLevel >=3);  
  return $equal ;
}

sub getContentSeqImages{
  my ($logLevel, $obj) = @_;
  mesa::delete_directory($logLevel, "$main::MESA_STORAGE/tmp");
  mesa::create_directory($logLevel, "$main::MESA_STORAGE/tmp");
  my $dumpOutput = "$main::MESA_STORAGE/tmp/contenceSeqItem.dcm";
  
  my $idx = 1;
  #my %tmp_imgs;
  my @tmp_imgs;
  my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $idx 0040 A730 $obj $dumpOutput";
  print main::LOG "CTX: $x\n" if ($logLevel >= 3);
  `$x`;
  my $done = $?;
    
  while(!$done){
    my ($s1, $relType) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0040 A010");
    my ($s2, $valType) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0040 A040");
    #print main::LOG "CTX: relType=<$relType> valType=<$valType>";
    if($relType eq "CONTAINS" && $valType eq "IMAGE"){
      my ($s3, $classUID) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0008 1150", "0008 1199");
      my ($s4, $instUID) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0008 1155", "0008 1199");
      print main::LOG "CTX: Content Sequence $idx $relType $valType: $instUID => $classUID\n" if ($logLevel >= 3);
      #$tmp_imgs{$instUID} = $classUID;
      push(@tmp_imgs, $instUID);
      push(@tmp_imgs, $classUID);
    }else{
      print main::LOG "CTX: Content Sequence $idx $relType $valType.\n" if ($logLevel >= 3);
    }
    $idx++;
    my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $idx 0040 A730 $obj $dumpOutput";
    print main::LOG "CTX: $x\n" if ($logLevel >= 3);
    `$x`;
    $done = $?;
  }
  print main::LOG "\n";
  return @tmp_imgs;
}

sub testContentSeqStructure{
  my($logLevel,$seqno, $desc, $kon_mesa, $kon_vendor) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc: $kon_vendor\n";

  my $count = 0;
  my $x = "$MESA_TARGET/bin/mesa_sr_eval -r 3003/3003_content_items.txt -t 2010:DCMR -v -p $kon_mesa $kon_vendor";
  if ($logLevel > 2) {
    print "CTX: $x\n";
    print   `$x`;
  } else {
    `$x`;
  }
  
  if ($? >= 1){
    print main::LOG "ERR: Failed in $desc $kon_vendor\n";
    $count = 1;
  }else{
    print main::LOG "CTX: Succeed in $desc $kon_vendor\n";
    $count = 0; 
  }
  
  print main::LOG "\n";
  return $count;
}

#use the 2nd attribute as key, the value is number of objects.  
sub compare_Tag1Count_Per_Tag2{
  my($logLevel,$seqno, $desc, $tag1desc, $tag1, $tag2, $a1, $a2) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc: \n";

  my @col1 = @{$a1};
  my @col2 = @{$a2};
  my %tmp1 = getCount($logLevel,$tag1, $tag2, @col1);
  my @a1 = sort(values(%tmp1));
  my $z1 = @a1;
  
  my %tmp2 = getCount($logLevel,$tag1, $tag2, @col2);
  my @a2 = sort(values(%tmp2));
  my $z2 = @a2;
  
  my $count = 0;
  if($z1 != $z2){
    print main::LOG "ERR: The MESA tool sent $z2 $tag1desc, you sent $z1 $tag1desc. They should be the same.\n";
    $count = 1;
  }
  
  for($c=0;$c<$z1 && $count==0;$c++){
    if($a1[$c] != $a2[$c]){
      $count = 1;
    }
  }
  
  if ($count == 0){
    print main::LOG "CTX: Succeeded in $desc. The count are equal for Test System and MESA system\n";
  }else{
    print main::LOG "ERR: Failed in $desc. The count are NOT equal. $z1 $tag1desc from Test System and $z2 $tag1desc from MESA system\n";
  }
  print main::LOG "\n";
  return $count;
}


#retrun a hash: keys are distinct 2st tag attributes in the collection.
#               values are count of objcts in the collection.
#               1st tag attribute is used as grouping condition.   
sub getCount{
  my($logLevel, $tag1, $tag2, @input) = @_;

  #retrieve a hash of series to studie
  #my %ser_stu_map = getAttriuteMap($seriesTag,$studyTag,@input);
  my %tag1_2_map = getAttriuteMap($logLevel, $tag1,$tag2,@input);
  displayMap("$tag1 TO $tag2 MAP:", %tag1_2_map) if ($logLevel > 3);
  
  #retrieve a list of studies
  #my @studies = getDistinctAttrList($studyTag, @input);
  my @tag2_list = getDistinctAttrList($logLevel, $tag2, @input);
  displayList("$tag2",@tag2_list) if ($logLevel > 3);
  
  my %count_map;
  foreach(@tag2_list){
    $count_map{$_} = 0;
  }
  my $v;
  foreach $key (keys(%tag1_2_map)){
    $v = $tag1_2_map{$key};
    $count_map{$v}++ ;
  }
  displayMap("result of $tag2 Count MAP", %count_map) if ($logLevel > 3);
  return %count_map;
}


# Compare two collections has the same number of certain attribute UIDs but UIDs are exclusive.
# For example, number of series UIDs in MESA tool and Test System. Both has 2 series UIDs and these 2 groups of UIDs are exclusive. Order is not important.
sub compareCountAndUID{
  my($logLevel,$seqno, $desc, $tag,$name, $a1, $a2) = @_;
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc:\n";

  my @tmpA1 =  @{$a1};
  my @tmpA2 =  @{$a2};
  
  my @a1 = getDistinctAttrList($logLevel, $tag, @tmpA1);
  my $z1 = @a1;
  print main::LOG "CTX: There are total of $z1 $name in Test System: @a1\n" if($logLevel >=3);

  my @a2 = getDistinctAttrList($logLevel, $tag, @tmpA2);
  my $z2 = @a2;
  print main::LOG "CTX: There are total of $z2 $name in MESA tool: @a2\n" if($logLevel >=3);
  
  my $count = 0;
  if($z1 != $z2){
    $count = 1;
    print main::LOG "ERR: MESA tool produced $z2 $name, Test System produced $z1 $name.\n";
  }else{
    print main::LOG "CTX: There are equal number of $name in MESA tool and Test System.\n";
  }
  
  my $equal = 0;
  if ($count == 0){
    foreach(@a1){
      if(arrayContains($_,@a2)){
	$equal = 1;
        print main::LOG "ERR: Deidentified data contains a UID that matches a UID from the original MESA test data.\n";
        print main::LOG "Object type: $name, UID: $_\n";
        last;
      }
    }
  }
    
  print main::LOG "CTX: The $name UIDs are properly deidentified.\n" if($equal == 0 && $count == 0);
  
  print main::LOG "\n";
  return ($count || $equal);
}

sub displayList{
  my($listName,@list)=@_;
  my $size = @list;
  print main::LOG "CTX: There are total of $size entries in the list $listName:\n";
  foreach(@list){
    print main::LOG "     $_\n";
  }
}

sub displayMap{
  my($mapName,%map)=@_;
  my $size = keys(%map);
  print main::LOG "CTX: There are total of $size entries in the map $mapName:\n";
  #foreach(($key, $value) = each(%map)){
  foreach $key (keys (%map)){
    print main::LOG "     Key: $key    Value: $map{$key}\n";
    #print main::LOG "     Key: $key  /opt/mesa/storage/exprcr/instances/MESAEXPRCR/1.113654.5.13.1370/1.113654.5.14.1226/1.113654.5.15.2962  Value: $value\n";
  }
}

# retrieve MAP of attirbutes pair of a list of objects:
#     key: attr of 1st tag, attr of 2nd tag.
sub getAttriuteMap{
  my($logLevel, $tag1, $tag2, @input) = @_;
  my %tmp;
  foreach(@input){
    my($s1,$v1)=mesa::getDICOMAttribute($logLevel, $_, $tag1);
    my($s2,$v2)=mesa::getDICOMAttribute($logLevel, $_, $tag2);
    $tmp{$v1} = $v2;
  }
  return %tmp;
}

#get a list of distinct attributes from a list of objects
sub getDistinctAttrList{
  my ($logLevel, $tag, @input) = @_;
  my @tmp;
  
  foreach(@input){
    #Get REL Study Instance UID
    my($s,$v)=mesa::getDICOMAttribute($logLevel, $_, $tag);
    if(arrayContains($v, @tmp) == 0){
      push(@tmp, $v);
    }
  }
  return @tmp;
}

sub arrayContains{
  my ($study, @studies) = @_;
  foreach (@studies){
#print main::LOG "CTX: $_ is in the array\n";
    if($_ eq $study){
      return 1;
    }
  }
  return 0;   
}

sub getKON{
   my ($logLevel, $classUID, @filnam) = @_;
   my @tmp;
   foreach(@filnam){
     #Get SOP instance ClassUID
     my($s,$class)=mesa::getDICOMAttribute($logLevel, $_, "0008 0016");
       if ($class eq $classUID){
         push(@tmp, $_);
       }
   }
   return @tmp;
}

sub getIMG{
   my ($logLevel, $classUID, @filnam) = @_;
   my @tmp;
   foreach(@filnam){
     #Get SOP instance ClassUID
     my($s,$class)=mesa::getDICOMAttribute($logLevel, $_, "0008 0016");
       print main::LOG "CTX: $_ SOP class UID is <$class>\n" if ($logLevel >= 3);
       if ($class ne $classUID){
         push(@tmp, $_);
       }
   }
   return @tmp; 
}

# when evaluate, $count maybe more than 1, but we just count 1 error for each subroutine.
sub eval_counting{
  my($count)=@_;
  if($count == 0){
    return 0;
  }elsif($count >= 1){
    return 1;
  }else{
    print LOG "CTX: Error count is less than 0, coding error.\n";
    return 1;
  }
}

sub groupKONs {
  my (@kons) = @_;

  my $logLevel = 0;
  mesa::delete_directory($logLevel, "$main::MESA_STORAGE/tmp");
  mesa::create_directory($logLevel, "$main::MESA_STORAGE/tmp");
  my $dumpOutput = "$main::MESA_STORAGE/tmp/contenceSeqItem.dcm";

  foreach $kon (@kons){
    #print main::LOG $kon."\n";
    my $idx = 1;
    my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $idx 0040 A730 $kon $dumpOutput";
    #print main::LOG "CTX: $x\n\n";
  	`$x`;

    my ($s1, $code) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0008 0100", "0040 A043", 1);
    #print main::LOG "CTX: code=<$code>\n";
    if($code eq "113011"){
		#print main::LOG "Debug: Path to KON with Delay Modifier --> $kon\n";
        push (@delayKON, $kon);
    } else {
		#print main::LOG "Debug: Path to KON with Identical Sequence --> $kon\n";
        push (@identicalSeqKONs, $kon);
    }
  }
  return \@delayKON, \@identicalSeqKONs;
}

sub eval_KON_Title_Modifier {
  my ($logLevel, $seqno, $desc, $kon ) = @_;
  
  mesa::delete_directory($logLevel, "$main::MESA_STORAGE/tmp");
  mesa::create_directory($logLevel, "$main::MESA_STORAGE/tmp");
  my $dumpOutput = "$main::MESA_STORAGE/tmp/contenceSeqItem.dcm";
  
  my $idx = 1;
  my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $idx 0040 A730 $kon $dumpOutput";
  #print main::LOG "CTX: $x\n\n";
  `$x`;
    
  my ($s1, $code) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0008 0100", "0040 A043", 1);
  return eval_KON_attributes($logLevel, $seqno, $desc, "TitleModifier", $dumpOutput);
}

sub eval_KON_Desc {
  my ($logLevel, $seqno, $desc, $refKon ) = @_;
  
  print main::LOG "CTX: $seqno\n";
  print main::LOG "CTX: $desc\n";

  mesa::delete_directory($logLevel, "$main::MESA_STORAGE/tmp");
  mesa::create_directory($logLevel, "$main::MESA_STORAGE/tmp");
  my $dumpOutput = "$main::MESA_STORAGE/tmp/contenceSeqItem.dcm";
  my $found = 0;
  foreach $kon (@$refKon){
    #print main::LOG $kon."\n";
    print main::LOG "CTX: Path to KON $kon\n" if ($logLevel >= 3);
    my $idx = 1;
    my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $idx 0040 A730 $kon $dumpOutput";
    #print main::LOG "CTX: $x\n\n";
    `$x`;
    my $done = $?;
    #$attributes{"KONDesc"} = ["113012", "DCM", "Key Object Description", "KON Description"];
    $found = 0;
    while(!$done){

      my ($s1, $relType) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0040 A010");
      my ($s2, $valType) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0040 A040");
      #print main::LOG "CTX: relType=<$relType> valType=<$valType>";

      if ($relType eq "CONTAINS" && $valType eq "TEXT"){
        $found = 1;
        my ($s3, $code) = mesa::getDICOMAttribute($logLevel, $dumpOutput, "0008 0100", "0040 A043", 1);
        #$errorCount = eval_KON_attributes($logLevel, $seqno, $desc, "KONDesc", $dumpOutput);
        $errorCount += mesa::evaluate_KON_TFCTE_Attributes($logLevel, $dumpOutput, @{$attributes{"KONDesc"}});
      
        my ($s4,$codeValue)=mesa::getDICOMAttribute($logLevel, $dumpOutput,  "0040 a160");
        unless($codeValue =~ m/Dr.Jost teaching file/i ){
          print main::LOG "ERR: Code Value under test does not equal MESA value \n";
          print main::LOG "ERR: Test value: $codeValue\n";
          print main::LOG "ERR: MESA value: Dr. Jost teaching file\n";
          $errorCount++;
        } else {
          print main::LOG "INFO: Code Value under test equals MESA value: $codeValue \n" if($logLevel >=3);
        }

        last;
      } else {
        #print main::LOG "CTX: Content Sequence $idx $relType $valType.\n" if ($logLevel >= 3);
      }
    
      $idx++;
      $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $idx 0040 A730 $kon $dumpOutput";
      print main::LOG "CTX: $x\n" if ($logLevel >= 3);
      `$x`;
      $done = $?;
    }
    
    if($found == 0){
      print main::LOG "ERR: Failed to find Key Object Description in $kon.\n";
      $errorCount++;
    }
  }
  
  print main::LOG "\n";
  return eval_counting($errorCount);
}
