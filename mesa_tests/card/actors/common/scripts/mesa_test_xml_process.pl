#!/usr/local/bin/perl -w

# This script takes the XML file that describes a MESA test and performs
# XSL transformations to produce the following:
# - Text file that can be read by the test engines
# As of 2009.11.19, removed the code that produced
# - HTML file that gives the user readable information

use Env;

sub xml_xsl {
  my ($in, $xformType, $xsl, $out) = @_;

  my $cp = "$MESA_TARGET/lib/xalan.jar:$MESA_TARGET/lib/xercesImpl.jar:$MESA_TARGET/lib/xerces.jar:$MESA_TARGET/lib/serializer.jar";
  if ($MESA_OS eq "WINDOWS_NT") {
    $cp =~ s/:/;/g;
  }

  my $x = "java  -cp $cp org.apache.xalan.xslt.Process -$xformType -IN $in -XSL $xsl -OUT $out";
  print "$x\n";
  `$x`;

  if ($?) {
    print `$x`;
    return 1;
  }

  return 0;
}

#==========

 die "Usage: <test number> <Optional: output directory>" if (scalar(@ARGV) < 1);

 die "Set the environment variable JAVA_HOME to point to the right directory" if (! $JAVA_HOME);
 die "Set the environment variable MESA_OS (WINDOWS_NT, UNIX)" if (! $MESA_OS);
 die "Set the environment variable MESA_TARGET" if (! $MESA_TARGET);

 my $testNumber = $ARGV[0];

 if ($ARGV[1]) {
	$outHTML = "../../../docs/$ARGV[1]/$testNumber.html";
 } else {
	$outHTML = "$testNumber/$testNumber.html";
 } 

 my $in = "$testNumber/$testNumber.xml";
 my $outText = "$testNumber/$testNumber.txt";
# my $xslHTML = "../../../common/xml/mir-test-to-html.xsl";
 my $xslText = "../../../common/xml/mir-test-to-text.xsl";

# my $status = xml_xsl($in, "HTML", $xslHTML, $outHTML);
# die "Could not xform to HTML: $in $xslHTML $outHTML" if ($status != 0);

 $status = xml_xsl($in, "TEXT", $xslText, $outText);
 die "Could not xform to Text: $in $xslText $outText" if ($status != 0);

 exit(0);
