#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains general utility scripts. 

use Env;

package mesa_xml;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

sub performXSLTransform {
  my ($logLevel, $outFile, $inXML, $inXSL, $runtimeFlags) = @_;

  my $Z = ":";
  $Z = ";" if ($main::MESA_OS eq "WINDOWS_NT");

  my $cp = "$main::MESA_TARGET/lib/xalan.jar"   . "$Z" .
        "$main::MESA_TARGET/lib/xercesImpl.jar" . "$Z" .
        "$main::MESA_TARGET/lib/xerces.jar"     . "$Z" .
        "$main::MESA_TARGET/lib/serializer.jar";


  my $x = "$main::JAVA_HOME/bin/java -cp $cp org.apache.xalan.xslt.Process  -IN $inXML -XSL $inXSL -OUT $outFile $runtimeFlags";

  print "$x\n";
  print `$x`;
  return 0;
}

1;
