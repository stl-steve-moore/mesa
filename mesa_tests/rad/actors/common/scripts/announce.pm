#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains all the announcments.

use Env;

package mesa;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

# Subroutines found here.

# announce_a03
# announce_cfind
# announce_a04 
# announce_order 
# announce_sched 
# announce_p01 
# announce_p03 


sub announce_a03{
  my $patientName = shift(@_);
  my $hostHL7 = shift(@_);
  my $portHL7 = shift(@_);

  print "\n" .
  "The MESA ADT will send an ADT^A03 to the MESA Order Filler to discharge\n" .
  " $patientName.  The Order Filler will send an A03 message to your\n" .
  " Image Manager at $hostHL7:$portHL7 with the same information.\n" .
  " Press <enter> when ready or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}


sub announce_cfind{
  my $patientName = shift(@_);
  my $cfindAE = shift(@_);
  my $cfindHost = shift(@_);
  my $cfindPort = shift(@_);

  print "\n" .
  "The MESA Image Display will send one or more DICOM C-Find requests \n" .
  " to your Image Manager. The current patient is $patientName \n" .
  " Your Image Mgr C-Find parameters are ($cfindAE:$cfindHost:$cfindPort) \n" .
  " \nPress <enter> when ready or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_a04 {
  my $patientName = shift(@_);
  my $hostHL7 = shift(@_);
  my $portHL7 = shift(@_);
  my $waitForUser = shift(@_);


  print "\n" .
  "The MESA ADT will send an ADT^A04 to the MESA Order Filler to register\n" .
  " $patientName. \n";

  return if ($waitForUser ne "y" && $waitForUser ne "Y");

  print " Press <enter> when ready or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_order {
  my $procedureInfo = shift(@_);
  my $hostHL7 = shift(@_);
  my $portHL7 = shift(@_);
  my $waitForUser = shift(@_);

  print "\n" .
  "Procedure for $procedureInfo will be ordered by MESA Order Filler \n" .
  " or MESA Order Placer.\n";

  return if ($waitForUser ne "y" && $waitForUser ne "Y");

  print " Press <enter> when ready or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_sched {
  my $schedulingInfo = shift(@_);
  my $hostHL7 = shift(@_);
  my $portHL7 = shift(@_);
  my $waitForUser = shift(@_);

  print "\n" .
  "MESA Order Filler sends schduling ORM ($schedulingInfo) to your Img Mgr\n" .
  " at $hostHL7 : $portHL7 \n";

  return if ($waitForUser ne "y" && $waitForUser ne "Y");

  print " Press <enter> when ready or <q> to quit: ";
  my $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}
sub announce_p01 {
  my $patientName = shift(@_);
  print "\n" .
"The ADT system will send a P01 to create an account for $patientName \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}

sub announce_p03 {
  my $patientName = shift(@_);
  my $chargeType = shift(@_);

  print "\n" .
"The Order Filler will send a P03 to post a charge.\n" .
" The patient is:     $patientName \n" .
" The charge type is: $chargeType \n" .
" Press <enter> when ready or <q> to quit: ";
  $response = <STDIN>;
  main::goodbye if ($response =~ /^q/);
}
1;
