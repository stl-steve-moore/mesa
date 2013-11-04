#!/usr/local/bin/perl -w

# Self test for Report Creator test 601.

use Env;
use Cwd;
use lib "../../../common/scripts";
require mesa_xmit;

die "Usage: <log level: 1-4>" if (scalar(@ARGV) < 1);
my $logLevel     = $ARGV[0];
my $version = "2.5";
#if ($MESA_OS eq "WINDOWS_NT") {
#  $storageDirectory = "$MESA_STORAGE\\rpt_manager\\hl7";
#} else {
#  $storageDirectory = "$MESA_STORAGE/rpt_manager/hl7";
#}

#rpt_crt::delete_directory(1,$storageDirectory);
#rpt_crt::create_directory(1,$storageDirectory);

#$dir = cwd();
#chdir ("$MESA_TARGET/db");
#print "Clearing Report Manager database \n";
#print `perl ClearImgMgrTables.pl rpt_manager`;
#chdir ($dir);
`perl  scripts/reset_obs_repository.pl`;
mesa_xmit::send_hl7($logLevel, "../../msgs/idco/20810/20810.102.r01.hl7", "localhost", 2750, $version);

#rpt_crt::cstore("../../msgs/tmp/20501/20501.102.r01.hl7", "", "MESA_RPT_MGR", "localhost", "2700");
#rpt_crt::cstore("../../msgs/tmp/20501/dicom_pdf.dcm", "", "MESA_RPT_MGR", "localhost", "2700");

