#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require rpt_reader;

sub goodbye() {
  exit 1;
}

# Search for a query response for a specific attribute and value

sub x_901 {
  my $tag = shift(@_);
  my $val = shift(@_);
  print LOG "Image Display 901-j \n";
  print LOG " Tag = $tag, val = $val \n";

  if ($MESA_OS eq "WINDOWS_NT") {
    $cfindDir = "$MESA_STORAGE\\rpt_repos\\queries";
  } else {
    $cfindDir = "$MESA_STORAGE/rpt_repos/queries";
  }

 $cfindFile = rpt_reader::find_matching_query($verbose, $cfindDir, $tag, $val);

 my $rtnValue = 1;
 if ($cfindFile eq "") {
   print LOG "Unable to locate C-Find query for $tag $val\n";
   $rtnValue = 0;
 }

 print LOG "\n";

 return $rtnValue;
}


$verbose = grep /^-v/, @ARGV;

open LOG, ">901-j/grade_901.txt" or die "?!";
$diff = 0;

$successCount = 0;
$successCount += x_901("0008 0020", "19950126");
$successCount += x_901("0008 0020", "19950126-19950126");
$successCount += x_901("0008 0050", "2001B20");
$successCount += x_901("0008 0050", "2001B20*");
$successCount += x_901("0010 0010", "CRTHREE*");
$successCount += x_901("0010 0010", "CRTHREE**");
$successCount += x_901("0010 0020", "CR3");
$successCount += x_901("0008 0061", "MR");
#x_901("0008 0061", "CT");

print LOG "\nTotal successes should be at least 5\n";
print LOG "You have registered $successCount successful queries\n";
print LOG "If this count is less than 5, you need to repeat this test\n";

print "\nTotal successes should be at least 5\n";
print "You have registered $successCount successful queries\n";
print "If this count is less than 5, you need to repeat this test\n";

print "Logs stored in 901-j/grade_901.txt \n";

exit $diff;
