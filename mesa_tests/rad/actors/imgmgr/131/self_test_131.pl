#!/usr/local/bin/perl -w


# Self test for test 131.

use Env;
use lib "scripts";
require imgmgr;

use File::Copy;

$scDir = "$MESA_STORAGE/imgmgr/commit/MODALITY1";

%params = mesa::get_config_params("imgmgr_test.cfg");

opendir SC, $scDir or die "directory: $scDir not found!";
@scMsgs = readdir SC;
closedir SC;

foreach $scFile (@scMsgs) {
  if ($scFile =~ /.opn/) {
    print "$scFile \n";
    $x = "$MESA_TARGET/bin/im_sc_agent -a MANAGER -c MODALITY1 localhost $params{MESA_MODALITY_PORT} $scDir/$scFile";
    print "$x\n";
    print `$x`;
    if ($?) {
      print "Could not send N-Event response\n";
      exit(1);
    }
  }
}

