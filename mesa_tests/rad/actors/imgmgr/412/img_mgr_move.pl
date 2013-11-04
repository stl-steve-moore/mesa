#!/usr/local/bin/perl -w

# Sends a C-Move request to an Image Manager.

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";

  exit 1;
}


sub send_cmove {

  foreach $query(@_) {
    print "$query \n";

    $cmove = "$MESA_TARGET/bin/cmove  -v -a WKSTATION"
		    . " -c $imCMoveAE -f $query -x STUDY"
                    . " $imCMoveHost $imCMovePort WORKSTATION1";

    print "$cmove \n";
    print `$cmove`;
    if ($? != 0) {
      print "Could not send query $query to your Manager\n";
      goodbye;
    }
  }
}

# End of subroutines, beginning of the main code

%parms = imgmgr::read_config_params_hash();

$imCMoveHost = $parms{"TEST_CMOVE_HOST"};
$imCMovePort = $parms{"TEST_CMOVE_PORT"};
$imCMoveAE= $parms{"TEST_CMOVE_AE"};

$query = $ARGV[0];
print "Query = $query \n";
send_cmove("$query");

goodbye;
