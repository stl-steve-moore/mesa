#!/usr/local/bin/perl -w

#Runs the Order Placer 102 exam.
use Env;
use lib "scripts";
require ordplc;
use lib "../common/scripts";
require mesa;


$host = `hostname`; chomp $host;
$debug = grep /^-.*d/, @ARGV;
$verbose = grep /^-.*v/, @ARGV  if not $debug;

$SIG{INT} = \&goodbye;


sub goodbye () {
  print "Exiting...\n";
  exit 0;
}


sub announce_test {
  print
"\n" .
"This is Order Placer test 102: subject is BROWN.\n";
}

sub update_P21_placer_order_number {
  if (! -e "$MESA_STORAGE/ordfil/1002.hl7") {
    print "The file $MESA_STORAGE/ordfil/1002.hl7 is expected to contain your ORM for P21\n";
    print " That file does not exist; this script exits.\n";
    exit(1);
  }
  my $placerOrderNum = mesa::getField("$MESA_STORAGE/ordfil/1002.hl7", "ORC", 2, 0, "Placer Order Number");
  print "Placer order number: $placerOrderNum \n";
  my $x = "perl scripts/change_hl7_field.pl ../../msgs/order/102/102.126.o01x.hl7 " .
	" ORC 2 $placerOrderNum 1";
  print "$x\n";
  print`$x`;
  die "Could not update ../../msgs/order/102/102.126.o01x.hl7" if ($?);
}

sub announce_P21_cancel {
  print "\n" .
"The Order Filler will cancel procedure P21.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_P22 {
  print "\n" .
"The Order Filler will request P22 by sending you an ORM.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub request_P22_orr {
  print "\n" .
"We now request that you send an ORR with the Placer Order Number for\n" .
" the P22 procedure requested by the Order Filler.\n\n" .
" Press <enter> when done or <q> to quit: ";
  $response = <STDIN>;
  goodbye if ($response =~ /^q/);
}

sub announce_end {
  print
"\nThat marks the end of all transactions for Order Placer test 102. \n" .
" You may evaluate your messages as follows: perl 102/eval_102.pl [-v] \n";
}

# Erase old Order Filler log files

sub clear_mesa {
  print "Clearing old messages from prior runs. \n";
  print `perl scripts/reset_servers.pl`;
}

# Main starts here

die "Order Placer test 102 is retired as of May, 2003.\n";

print "\n------------ Starting ORDPLC exam ---------------\n";
print "(Running in verbose mode)\n" if $verbose;
print "(Running in debug mode)\n" if $debug;

($ofPort, $opHost, $opPort) = ordplc::read_config_params("ordplc_test.cfg");

clear_mesa;

announce_test;

ordplc::announce_a05("BROWN", $opHost, $opPort);

$x = ordplc::send_hl7("../../msgs/adt/102", "102.102.a05.hl7", $opHost, $opPort);
ordplc::xmit_error("102.102.a05.hl7") if ($x == 0);

ordplc::request_procedure("P1", "BROWN", "102.104.o01.hl7", $host, $ofPort);

ordplc::announce_a01("BROWN", $opHost, $opPort);
$x = ordplc::send_hl7("../../msgs/adt/102", "102.108.a01.hl7", $opHost, $opPort);
ordplc::xmit_error("101.108.a01.hl7") if ($x == 0);

ordplc::request_procedure("P21", "BROWN", "102.122.o01.hl7", $host, $ofPort);

announce_P21_cancel;
update_P21_placer_order_number();
$x = ordplc::send_hl7("../../msgs/order/102", "102.126.o01x.hl7", $opHost, $opPort);
ordplc::xmit_error("101.126.o01x.hl7") if ($x == 0);

announce_P22;
$x = ordplc::send_hl7("../../msgs/order/102", "102.130.o01.hl7", $opHost, $opPort);
ordplc::xmit_error("101.130.o01.hl7") if ($x == 0);

request_P22_orr;

ordplc::announce_a03("BROWN", $opHost, $opPort);
$x = ordplc::send_hl7("../../msgs/adt/102", "102.136.a03.hl7", $opHost, $opPort);
ordplc::xmit_error("101.136.a03.hl7") if ($x == 0);

announce_end;

goodbye;
