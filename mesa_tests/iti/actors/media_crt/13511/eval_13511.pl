#!/usr/bin/perl
# Runs the Media Creator test 13511

use Env;

# Find hostname of this machine

sub x_13511_x {
  my ($logLevel, $mountPoint) = @_;
  my $error_count = 0;
  print LOG "CTX: XDM Media Creator File Conventions\n" if ($logLevel >= 3);
  print LOG "CTX: Test 13511 examines the file names and folder structure of media created by the Media Creator\n" if ($logLevel >= 3);

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

sub x_13511_1 {
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

#print map { "$_\n" } sort  @xdm_files;

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

    foreach $subfolder (@files) {
      if (-d $FOLDER."/".$subfolder) {
	print LOG "\nCTX: Checking if Multi part folder contain 2 or more documents\n";
        opendir SUBFOLDER, "$FOLDER/$subfolder" or die "Can't read dir: $FOLDER/$subfolder\n";
    	my @multipartFiles = grep !/^\./, readdir SUBFOLDER;
        if (scalar(@multipartFiles) < 2) {
          $error_count++;
      	  print LOG "ERR: Multi part folder should contain 2 or more documents. Found <". scalar(@multipartFiles) ."> document.\n";
        }
      }
    }
  }
  #print map { "$_\n" } sort  @files;
  return $error_count;
}

## Main starts here

die "Usage: <log level: 1-4> <CD mount point>" if (scalar(@ARGV) < 2);

$logLevel = $ARGV[0];
$mountPoint = $ARGV[1];
open LOG, ">13511/grade_13511.txt" or die "?!";
$diff = 0;

$diff = x_13511_x ($logLevel, $mountPoint);
if ($diff != 0) {
 print LOG "Cannot run any other tests if you fail test 1\n";
 print "Cannot run any other tests if you fail test 1\n";
 print "Logs stored in 13511/grade_13511.txt \n";
 exit 1;
}

$diff = x_13511_1 ($logLevel, $mountPoint);

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 13511/grade_13511.txt \n";

exit $diff;
