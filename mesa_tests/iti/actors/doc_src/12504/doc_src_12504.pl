#!/usr/local/bin/perl -w

use Env;
use lib "../common/scripts";
require mesa;

sub promptForFile()
{
  print "Please enter full path to document \n" .
        " --> ";
  $response = <STDIN>;
  chomp $response;
  exit(1) if ($response eq "");
  return $response;
}

sub x_12504_1 {
  print "CTX: XDS-MS 12504.1\n";
  print "CTX: Transforming XML file to HTML file\n";

  my ($file) = @_;

  $x = "java org.apache.xalan.xslt.Process -IN $file -XSL 12504/IMPL_CDAR2.xsl -OUT 12504/12504.html";
  print `$x`;

  return 1 if $?;
  return 0;
}

# Main starts here

 #die "Usage: perl 12504/doc_src_12504.pl FILE" if (scalar(@ARGV) < 1);
 my $fileName;

 if (scalar(@ARGV) == 1) {
  $fileName = $ARGV[0];
 } else {
  $fileName = promptForFile();
 }
 
 x_12504_1($fileName);
 
 print "Transformed HTML file can be found at 12504/12504.html\n";
 print "View the HTML file to determine if it looks \"reasonable\"\n";
 print "Rename the HTML file to SYSTEM_12504.html and submit the HTML file to the Project Manager for evaluation\n";
 exit 0;

