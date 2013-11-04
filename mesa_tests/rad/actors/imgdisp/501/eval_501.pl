#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require imgdisp;

sub goodbye() {
  exit 1;
}

# Search for a query response for a specific attribute and value

sub x_501 {
  my $tag = shift(@_);
  my $val = shift(@_);
  print LOG "Image Display 501 \n";
  print LOG " Tag = $tag, val = $val \n";

  if ($MESA_OS eq "WINDOWS_NT") {
    $cfindDir = "$MESA_STORAGE\\imgmgr\\queries";
  } else {
    $cfindDir = "$MESA_STORAGE/imgmgr/queries";
  }

 $cfindFile = imgdisp::find_matching_query($verbose, $cfindDir, $tag, $val);

 if ($cfindFile eq "") {
   print LOG "Unable to locate C-Find query for $tag $val\n";
   $diff += 1;
 }

 print LOG "\n";
}


$verbose = grep /^-v/, @ARGV;

open LOG, ">501/grade_501.txt" or die "?!";
$diff = 0;

x_501("0008 0020", "19950126");
x_501("0008 0050", "2001B20");
x_501("0010 0010", "CRTHREE*");
x_501("0010 0020", "CR3");
x_501("0008 0061", "MR");
#x_501("0008 0061", "CT");

print LOG "\nTotal Differences: $diff \n";
print "\nTotal Differences: $diff \n";

print "Logs stored in 501/grade_501.txt \n";

exit $diff;
