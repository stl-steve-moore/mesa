#!/usr/local/bin/perl

# This script creates txt/html files for IHE RAD tests

use Env;
use Cwd;

@fileNames = (
	"103:swf",
	"105:swf",
	"107:swf",
	"109:swf",
	"110:swf",
	"131:swf",
	"132:swf",
	"133:swf",
	"141:swf",
	"142:swf",
	"151:swf",
	"152:swf",
	"153:swf",
	"1301:swf",
	"1302:swf",
	"1303:swf",
	"1305:swf",
	"1601:swf",
	"3001:tfcte",
	"3003:tfcte",
	"3512:fusion",
	"3514:fusion",
	"3540:fusion",
	"3541:fusion",
	"3550:fusion",
#	"3720:irwf",
#	"3721:irwf",
	"3725:irwf",
	"3726:irwf",
#	"3739:irwf",
	"3740:irwf",
	"3742:irwf",
	"3900:mammo",
	"3905:mammo",
	"3915:mammo",
	"4404:rem",
	);

$dir = cwd();

foreach $file (@fileNames) {
  my ($case, $profile) = split /:/, $file;
  print `perl $dir/scripts/mesa_test_xml_process.pl $case rad/$profile/test_cases/html` or die "Could not execute script to generate txt/html files \n";
}

@eyecareNames = (
	"50000:eyecare",
	"50001:eyecare",
	"50002:eyecare",
	"50004:eyecare",
	"313:eced",
);

foreach $file (@eyecareNames) {
  my ($case, $profile) = split /:/, $file;
  print `perl $dir/scripts/mesa_test_xml_process.pl $case eyecare/$profile/test_cases/html` or die "Could not execute script to generate txt/html files \n";
}
