#!/usr/local/bin/perl

# This script creates txt/html files for the table of coded values

use Env;
use Cwd;


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


@fileNames = (
	"hl7:ihe001",
	"hl7:ihe001",
	"hl7:ihe002",
	"hl7:ihe005",
	"hl7:ihe006",
	"hl7:ihe007",
	"hl7:ihe008",
	"hl7:ihe009",
	"hl7:ihe010",
	"hl7:ihe011",
	"hl7:ihe012",
	"hl7:ihe013",
	"hl7:ihe014",
	"hl7:ihe015",
	"hl7:ihe016",
	"hl7:ihe017",
	"hl7:ihe018",
	"hl7:ihe043",
	"hl7:ihe044",
	"hl7:ihe045",
	"hl7:ihe046",
	"identifier:ihe003",
	"identifier:ihe004",
	"mwl:ihe035",
	"mwl:ihe036",
	"mwl:ihe037",
	"mwl:ihe038",
	"mwl:ihe039",
	"mwl:ihe040",
	"order:ihe020",
	"order:ihe021",
	"order:ihe022",
	"order:ihe023",
	"order:ihe024",
	"order:ihe025",
	"order:ihe026",
	"order:ihe028",
	"order:ihe029",
	"order:ihe030",
	"order:ihe032",
	"order:ihe033",
	"order:ihe034",
	"people:ihe019",
	"pps:ihe041",
	"pps:ihe042",
	"pps:ihe047",
	"pps:ihe048",
	"pps:ihe049",
	"pps:ihe050",
	"pps:ihe051",
	"pps:ihe052",
	"pps:ihe053",
	"pps:ihe054",
	"pps:ihe055",
	"pps:ihe056",
	"schedule:ihe027",
	"xds:ihe057",
	"xds:ihe058",
);

foreach $f(@fileNames) {
  my ($folder, $file) = split /:/, $f;
  print "$folder $file\n";

  $status = xml_xsl("$folder/$file.xml", "HTML", "xsl/codes-to-html.xsl",
	"$folder/$file.html");
  die "Could not xform $f\n" if ($status != 0);

  $status = xml_xsl("$folder/$file.xml", "TEXT", "xsl/codes-to-csv.xsl",
	"$folder/$file.txt");
  die "Could not xform $f\n" if ($status != 0);
}
