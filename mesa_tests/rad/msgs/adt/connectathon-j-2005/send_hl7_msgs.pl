#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
use lib "../../../actors/common/scripts";
require mesa;

# config parameters
$host = "localhost";
$port = "4100";

$SIG{INT} = \&goodbye;

sub goodbye () {
  print "Exiting...\n";

  exit 0;
}

opendir (DIR, "./jap") or die "Can not open dir:.\n";
while (defined($msg = readdir(DIR))) {
  next if ($msg =~ /^\.|^\.\.|\.txt$/);
#  print $msg."\n";
  $x = mesa::send_hl7("./jap", $msg, $host, $port);
  mesa::xmit_error($msg) if ($x != 0);
}
closedir(DIR);

goodbye;
