#!/usr/bin/perl
# Runs the Media Creator test 13515

use Env;

# Find hostname of this machine

sub x_13515_x {
  my ($logLevel, $mountPoint) = @_;
  my $error_count = 0;
  print LOG "CTX: XDM Media Creator, One Submission Set, Multi Part Doc\n" if ($logLevel >= 3);
  print LOG "CTX: Test 13515 examines a Submission Set containing one multi-part document,created by the Media Creator\n" if ($logLevel >= 3);

  print LOG "CTX: Checking for existence\n";
  print LOG "CTX: Checking for README.TXT, INDEX.HTM, IHE_XDM folder at root level\n";
  opendir TEST, $mountPoint or die "Can't read dir: $!\n";
  my @test_files = grep !/^\./, readdir TEST;
  closedir TEST;

  my $readme_txt_exist = grep {/^README.TXT$/} @test_files;
  if (!$readme_txt_exist) {
    $error_count++;
    print LOG "ERR: README.TXT: not present at root level\n";
  }

  my $index_htm_exist = grep {/^INDEX.HTM$/} @test_files;
  if (!$index_htm_exist) {
    $error_count++;
    print LOG "ERR: INDEX.HTM: not present at root level\n";
  }

  my $ihe_xdm_exist = grep {/^IHE_XDM$/} @test_files;
  if (!$ihe_xdm_exist) {
    $error_count++;
    print LOG "ERR: IHE_XDM: Folder does not exist at root level\n";
  }
  return $error_count;
}

sub x_13515_1 {
  my ($logLevel, $mountPoint) = @_;
  my $error_count = 0;

  print LOG "\nCTX: Checking for non-empty files\n";
  if (-z $mountPoint."/README.TXT") {
    $error_count++;
    print LOG "ERR: Empty README.TXT\n";
  }

  if (-z $mountPoint."/INDEX.HTM") {
    $error_count++;
    print LOG "ERR: Empty INDEX.HTM\n";
  }

  print LOG "\nCTX: To validate INDEX.HTM - use W3C' Markup Validation Service\n
       at http://validator.w3.org/file-upload.html
       \n";
  print LOG "CTX: On DocType drop-down pick \"XHTML Basic 1.0\"\n";
  print LOG "Upload and Validate your INDEX.HTM\n";
  print LOG "Do a screen capture of Markup Validation results page 
and email the screen capture to the Project Manager\n\n";

  #print LOG "CTX: Checking for subfolder(s) within IHE_XDM\n";
  my $IHE_XDM = $mountPoint."/IHE_XDM";
  opendir IHE_XDM , $IHE_XDM or die "Can't read dir: $IHE_XDM\n";
  my @xdm_files = grep !/^\./, readdir IHE_XDM;
  closedir IHE_XDM;

  #my @xdm = grep {/^SUBSET/} @xdm_files;
  #if (!scalar(@xdm)) {
  #  $error_count++;
  #  print LOG "ERR: Missing subfolder entry SUBSET...within IHE_XDM\n";
  #}

#print map { "$_\n" } sort  @xdm;
  print LOG "CTX: Submission set count:";
  foreach $folder (@xdm_files) {
    if (-d $IHE_XDM."/".$folder) {
      $submissionSetCount++;
    }
  }
  print LOG "$submissionSetCount\n";

  print LOG "\nCTX: Checking for existence of METADATA.XML\n";
  foreach $folder (@xdm_files) {
    undef($meta_xml_exist);
    my $FOLDER = $IHE_XDM."/".$folder;
    next if (!-d $FOLDER);
    opendir DIR,$FOLDER or die "Can't read dir: $FOLDER\n";
    my @files = grep !/^\./, readdir DIR;
    closedir DIR;

    my $meta_xml_exist = grep {/^METADATA.XML$/} @files;
    if (!$meta_xml_exist) {
      $error_count++;
      print LOG "ERR: METADATA.XML: not present at $FOLDER\n";
    }

    my $subFolderCount = 0;
    foreach $subfolder (@files) {
  #    print $subfolder.": ";
      if (-d $FOLDER."/".$subfolder) {
        $subFolderCount++;
        push(@multiFolder, $subfolder); 
      }
  #    print $FOLDER."/".$subfolder."\n";
    }
  #  print $subFolderCount."\n";
    
    if ($subFolderCount > 0) {
      foreach $multi (@multiFolder) {
        print LOG "\nCTX: Checking if Multi part folder <". $FOLDER."/".$multi. "> contain 2 or more documents\n";
        opendir SUBFOLDER, "$FOLDER/$subfolder" or die "Can't read dir: $FOLDER/$multi\n";
        my @multipartFiles = grep !/^\./, readdir SUBFOLDER;
        if (scalar(@multipartFiles) < 2) {
          $error_count++;
          print LOG "ERR: Multi part folder should contain 2 or more documents. Found <". scalar(@multipartFiles) ."> document.\n";
        } else {
          print LOG "CTX: Multi part folder contains <". scalar(@multipartFiles) ."> document.\n";
        }
      } 
    } else {
          print LOG "ERR: Missing multi part folder in submission set <".$FOLDER."/".$subfolder.">\n" if ($subFolderCount == 0);
          $error_count++;
    }
  }
  #print map { "$_\n" } sort  @files;
  return $error_count;
} 

## Main starts here

die "Usage: <log level: 1-4> <CD mount point>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$mountPoint = $ARGV[1];
open LOG, ">13515/grade_13515.txt" or die "?!";
$diff = 0;

$diff = x_13515_x ($logLevel, $mountPoint);
if ($diff != 0) {
 print LOG "Cannot run any other tests if you fail test 1\n";
 print "Cannot run any other tests if you fail test 1\n";
 print "Logs stored in 13515/grade_13515.txt \n";
 exit 1;
}

$diff = x_13515_1 ($logLevel, $mountPoint);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 13515/grade_13515.txt \n";

exit $diff;
