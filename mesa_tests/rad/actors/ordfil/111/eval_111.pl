#!/usr/local/bin/perl -w

use Env;

use lib "scripts";
require ordfil;

sub goodbye() {
  exit 1;
}

print "Order Filler test 111 has no evaluation script. Please examine the\n";
print " GP PPS object that was created. Inform the Project Manager if this notification\n";
print " contained the data you expect/require.\n";

exit 0;
