#!/usr/local/bin/perl -w

# General package for evaluating BSPS
package evaluate_fusion;

use Env;
require Exporter;
@ISA = qw(Exporter);
require mesa;

# Find one BSPS object reference in a database.

sub locateBSPS {
  my ($logLevel, $dbName) = @_;

  print main::LOG "CTX mesa::locateBSPS\n" if ($logLevel >= 3);
  print main::LOG "CTX Database Name: $dbName\n" if ($logLevel >= 3);

  my $x = "$main::MESA_TARGET/bin/mesa_select_column -c clauid 1.2.840.10008.5.1.4.1.1.11.4 filnam sopins $dbName filename.txt";
  print main::LOG "CTX $x\n" if ($logLevel >= 3);

  if ($logLevel >= 3) {
    print main::LOG "CTX: ";
    print main::LOG `$x`;
  } else {
    `$x`;
  }
  return (1, "none") if $?;

  open (TEXTFILE, "<filename.txt") or die "Can't open filename.txt.\n";

  my $path = <TEXTFILE>;

  return (1, "none") if ($?);
  close TEXTFILE;
  chomp $path;

  return (0, $path);
}

sub getImgInstanceFromBSPS {
  my ($logLevel, $path, $maxIndexi, $dir) = @_;
  my %imgRefhash;

  my $tmpDir = "$main::MESA_STORAGE/tmp/$dir";
  mesa::delete_directory($logLevel, $tmpDir);
  mesa::create_directory($logLevel, $tmpDir);

  my $error = 0;
  if(!$maxIndex){
    $maxIndex = 2;
  }

  for($i = $maxIndex; $i >=1; $i--){
    my $error = 0;

    my $outputDir = $tmpDir."/".$i;
    mesa::delete_directory($logLevel, $outputDir);
    mesa::create_directory($logLevel, $outputDir);

    my $x = "$main::MESA_TARGET/bin/dcm_dump_element -i $i 0070 0402 $path $outputDir/blending.dcm";
    print main::LOG "CTX: $x\n" if ($logLevel >= 3);
    `$x`;
    $error++ if $?;

    if(!$error){
      my $seriesPath = "$outputDir/blending.dcm";
      my $y = "$main::MESA_TARGET/bin/dcm_dump_element 0008 1115 $seriesPath $outputDir/series.dcm";
      print main::LOG "CTX: $y\n" if ($logLevel >= 3);
      `$y`;
      $error++ if $?;
    }

    if(!$error){
      my $idx = 1;
      my $done = 0;
      my $imgRefPath = "$outputDir/series.dcm";
      while (! $done) {
        my ($s1, $instanceUID) = mesa::getDICOMAttribute($logLevel, $imgRefPath, "0008 1155", "0008 1140", $idx);
        my ($s2, $classUID) = mesa::getDICOMAttribute($logLevel, $imgRefPath, "0008 1150", "0008 1140", $idx);
        #print "$idx $s1 $s2 <$classUID> $instanceUID\n";
        if ($s1 != 0) {
          print main::LOG "ERR: In $i item of evidence sequence, could not get instance UID value for index $idx\n";
          #return (1, %imgRefhash);
        }
        if ($instanceUID eq "") {
          $done = 1;
        } else {
            #print "<$classUID> $instanceUID\n";
            # Add instance UID and class UID to a imgRefhash
            $imgRefhash{$instanceUID} = $classUID;
            $idx++;
        }
      }
    }

  }

  print main::LOG "\n";
  if($error){
    return (1, \%imgRefhash);
  }else{
    # return status and imgRefhash
    return (0, \%imgRefhash);
  }
}

sub testHashEqual{
  my($logLevel, $h1, $h2) = @_;
  my $retVal = mesa_evaluate::hashEqual($logLevel, $h1, $h2);
  my $count = 0;
    
  if ($retVal == 0){
    $count = 1;
    #print main::LOG "ERR: Failed in $desc\n";
  }else{ 
    #print main::LOG "CTX: Succeed in $desc\n";
  }
  print main::LOG "\n";
  return $count;
} 
  
1;
