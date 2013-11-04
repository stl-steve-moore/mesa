#!/usr/local/bin/perl -w

# Self test for test 1503.

use Env;
use File::Copy;
use lib "scripts";
use lib "../common/scripts";
require imgmgr;
require mesa;

$scDir = "$MESA_STORAGE/imgmgr/commit/MESA_MOD";

opendir SC, $scDir or die "directory: $scDir not found!";
@scMsgs = readdir SC;
closedir SC;

foreach $scFile (@scMsgs) {
  if ($scFile =~ /.opn/) {
    print "$scFile \n";
    $x = "$MESA_TARGET/bin/im_sc_agent -a MANAGER -c MESA_MOD localhost 2400 $scDir/$scFile";
    print "$x\n";
    print `$x`;
    if ($?) {
      print "Could not send N-Event response\n";
      exit(1);
    }
  }
}

$syslogPortMESA = 4000;

mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1503/1503.020", "INSTANCES_STORED");

mesa::create_send_audit("localhost", $syslogPortMESA,
	"../../msgs/audit/1503/1503.030", "DICOM_QUERY");
