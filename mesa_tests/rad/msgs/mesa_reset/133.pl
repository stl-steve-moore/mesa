#!/usr/local/bin/perl

# This script updates the HL7 messages for test 133

use Env;
use Cwd;
use File::Copy;
use lib "common";
require mesa_msgs;

sub getVariable {
  my $varName = shift(@_);
  my $defValue= shift(@_);

  my $resp = <STDIN>;
  chomp $resp;
  if ($resp eq "") { $resp = $defValue };
  $varnames{$varName} = $resp;
}

sub readParamsFromStdin {
  print "To enter a <blank> response, enter ####\n";
  print "To keep the default value, enter <Enter> or <Return>\n\n";

  print "Please enter name for INDIGO^IVAN [INDIGO^IVAN] ->";
  getVariable("\$INDIGO_NAME\$", "INDIGO^IVAN");
  my $y = "\$INDIGO_NAME\$";
  print "Please enter race for $varnames{$y} [WH] ->";
  getVariable("\$INDIGO_RACE\$", "WH");

  print "Please enter name for DOE^J133 [DOE^J133] ->";
  getVariable("\$DOE_NAME\$", "DOE^J133");
}

sub get_new_identifiers()
{
  my $pidIndigo = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_INDIGO\$"} = $pidIndigo . "^^^ADT1";

  my $visitIndigo = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_INDIGO\$"} = $visitIndigo . "^^^ADT1";

  my $pidDoe = mesa_msgs::getNewPID("adt");
  $varnames{"\$PID_DOE\$"} = $pidDoe . "^^^ADT1";

  my $visitDoe = mesa_msgs::getNewVisitNumber("adt");
  $varnames{"\$VISIT_DOE\$"} = $visitIndigo . "^^^ADT1";

  my $placerOrderNumber = mesa_msgs::getNewPlacerOrderNumber("ordplc");
  $varnames{"\$PLACER_ORDER_NUMBER\$"} = $placerOrderNumber . "^MESA_ORDPLC";

  my $fillerOrderNumber = mesa_msgs::getNewFillerOrderNumber("ordfil");
  $varnames{"\$FILLER_ORDER_NUMBER\$"} = $fillerOrderNumber . "^MESA_ORDFIL";

  my $placerOrderNumberP1 = mesa_msgs::getNewPlacerOrderNumber("ordplc");
  $varnames{"\$PLACER_ORDER_NUMBER_P1\$"} = $placerOrderNumberP1 . "^MESA_ORDPLC";

  my $fillerOrderNumberP1 = mesa_msgs::getNewFillerOrderNumber("ordfil");
  $varnames{"\$FILLER_ORDER_NUMBER_P1\$"} = $fillerOrderNumberP1 . "^MESA_ORDFIL";
}

sub process_indigo {

  # ADT messages for 133.102, 133.103
  copy ("adt/133/indigo.var", "adt/133/indigo.txt");
  open INDIGO, ">>adt/133/indigo.txt" or die
	"Could not open adt/133/indigo.txt for output\n";
  $x = "\$INDIGO_NAME\$";
  print INDIGO "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$INDIGO_RACE\$";
  print INDIGO "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_INDIGO\$";
  print INDIGO "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_INDIGO\$";
  print INDIGO "\$VISIT_NUMBER\$ = $varnames{$x}\n";

  # Add the stuff for the prior values
  $x = "\$DOE_NAME\$";
  print INDIGO "\$PRIOR_PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$PID_DOE\$";
  print INDIGO "\$PRIOR_PATIENT_ID\$ = $varnames{$x}\n";
  print INDIGO "\$PRIOR_PATIENT_ID_LIST\$ = $varnames{$x}\n";
  close INDIGO;
}

sub process_doe {

  # ADT messages for 133.102, 133.103
  copy ("adt/133/doe.var", "adt/133/doe.txt");
  open DOE, ">>adt/133/doe.txt" or die
	"Could not open adt/133/doe.txt for output\n";
  $x = "\$DOE_NAME\$";
  print DOE "\$PATIENT_NAME\$ = $varnames{$x}\n";
  $x = "\$INDIGO_RACE\$";		# Yes, use the same race
  print DOE "\$RACE\$ = $varnames{$x}\n";
  $x = "\$PID_DOE\$";
  print DOE "\$PATIENT_ID\$ = $varnames{$x}\n";
  $x = "\$VISIT_DOE\$";
  print DOE "\$VISIT_NUMBER\$ = $varnames{$x}\n";
  close DOE;

  # Order message, 133.144
  copy ("order/133/133.144.o01.var", "order/133/133.144.o01.xxx");
  open DOE , ">>order/133/133.144.o01.xxx" or die
	"Could not open order/133/133.144.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;

  # Order message, 133.146
  copy ("order/133/133.146.o02.var", "order/133/133.146.o02.xxx");
  open DOE , ">>order/133/133.146.o02.xxx" or die
	"Could not open order/133/133.146.o02.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print DOE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;

  copy ("order/133/133.147.o01.var", "order/133/133.147.o01.xxx");
  open DOE , ">>order/133/133.147.o01.xxx" or die
	"Could not open order/133/133.147.o01.xxx for output\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print DOE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;

  # Scheduling message, 133.148
  copy ("sched/133/133.148.o01.var", "sched/133/133.148.o01.xxx");
  open DOE , ">>sched/133/133.148.o01.xxx" or die
	"Could not open sched/133/133.148.o01.xxx for output\n";
  $x = "\$PLACER_ORDER_NUMBER\$";
  print DOE "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
  $x = "\$FILLER_ORDER_NUMBER\$";
  print DOE "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
  close DOE;
}

#
#
#  # Cancel message, 132.110
#  copy ("order/132/132.110.o01x.var", "order/132/132.110.o01x.xxx");
#  open WISTERIA, ">>order/132/132.110.o01x.xxx" or die
#	"Could not open order/132/132.110.o01x.xxx for output\n";
#  $x = "\$PLACER_ORDER_NUMBER_P22\$";
#  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  $x = "\$FILLER_ORDER_NUMBER_P22\$";
#  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  close WISTERIA;
#
#  # Cancel message, 132.112
#  copy ("sched/132/132.112.o01.var", "sched/132/132.112.o01.xxx");
#  open WISTERIA, ">>sched/132/132.112.o01.xxx" or die
#	"Could not open sched/132/132.112.o01.xxx for output\n";
#  $x = "\$PLACER_ORDER_NUMBER_P22\$";
#  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  $x = "\$FILLER_ORDER_NUMBER_P22\$";
#  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  close WISTERIA;
#
#  # Order message, 132.116
#  copy ("order/132/132.116.o01.var", "order/132/132.116.o01.xxx");
#  open WISTERIA, ">>order/132/132.116.o01.xxx" or die
#	"Could not open order/132/132.116.o01.xxx for output\n";
#  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = ####\n";
#  $x = "\$FILLER_ORDER_NUMBER_P1\$";
#  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  close WISTERIA;
#
#  # Order message, 132.118
#  copy ("order/132/132.118.o02.var", "order/132/132.118.o02.xxx");
#  open WISTERIA, ">>order/132/132.118.o02.xxx" or die
#	"Could not open order/132/132.118.o02.xxx for output\n";
#  $x = "\$PLACER_ORDER_NUMBER_P1\$";
#  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  $x = "\$FILLER_ORDER_NUMBER_P1\$";
#  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  close WISTERIA;
#
#  # Order message, 132.119 (is an extra MESA message that we need)
#  copy ("order/132/132.119.o01.var", "order/132/132.119.o01.xxx");
#  open WISTERIA, ">>order/132/132.119.o01.xxx" or die
#	"Could not open order/132/132.119.o01.xxx for output\n";
#  $x = "\$PLACER_ORDER_NUMBER_P1\$";
#  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  $x = "\$FILLER_ORDER_NUMBER_P1\$";
#  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  close WISTERIA;
#
#  # Scheduling message, 132.120
#  copy ("sched/132/132.120.o01.var", "sched/132/132.120.o01.xxx");
#  open WISTERIA, ">>sched/132/132.120.o01.xxx" or die
#	"Could not open sched/132/132.120.o01.xxx for output\n";
#  $x = "\$PLACER_ORDER_NUMBER_P1\$";
#  print WISTERIA "\$PLACER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  $x = "\$FILLER_ORDER_NUMBER_P1\$";
#  print WISTERIA "\$FILLER_ORDER_NUMBER\$ = $varnames{$x}\n";
#  close WISTERIA;

if (scalar(@ARGV) == 0) {
 readParamsFromStdin();
} else {
 mesa_msgs::readParamsFromFile($ARGV[0]);
}

get_new_identifiers();

process_indigo();
process_doe();

$dir = cwd();
chdir("adt/133");
print `perl 133.pl X`;
chdir($dir);

chdir("order/133");
print `perl 133.pl X`;
chdir($dir);

chdir("sched/133");
print `perl 133.pl X`;
chdir($dir);
