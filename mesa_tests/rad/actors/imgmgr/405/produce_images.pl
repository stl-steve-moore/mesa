#!/usr/local/bin/perl -w

# Produces images and storage commitment data for Image Manager test 405.

use Env;

sub goodbye {
  print "Abnormal exit\n";
  exit 1;
}

sub produce_Px1_data {
  $x = "perl scripts/produce_unscheduled_images.pl";
  print "$x MR MESA_MOD M8085 P1 Px1 X1 MR/MR4/MR4S1 DOE_J4 \n";
  print `$x MR MESA_MOD M8085 P1 Px1 X1 MR/MR4/MR4S1 DOE_J4`;
  if ($?) {
    print "Could not produce P1 data.\n";
    goodbye;
  }
}

sub produce_Px2_data {
  $x = "perl scripts/produce_unscheduled_images.pl";
  print "$x MR MESA_MOD M8085 P2 P2 X2 MR/MR4/MR4S1 DOE_J4 \n";
  print `$x MR MESA_MOD M8085 P2 Px2 X2 MR/MR4/MR4S1 DOE_J4`;
  if ($?) {
    print "Could not produce P2 data.\n";
    goodbye;
  }
}

sub produce_Px6_data {
  $x = "perl scripts/produce_unscheduled_images.pl";
  print "$x MR MESA_MOD M8085 P6 P6 X6 MR/MR4/MR4S1 DOE_J4 \n";
  print `$x MR MESA_MOD M8085 P6 Px6 X6 MR/MR4/MR4S1 DOE_J4`;
  if ($?) {
    print "Could not produce P6 data.\n";
    goodbye;
  }
}

sub produce_Px7_data {
  $x = "perl scripts/produce_unscheduled_images.pl";
  print "$x MR MESA_MOD M8085 P7 P7 X7 MR/MR4/MR4S1 DOE_J4 \n";
  print `$x MR MESA_MOD M8085 P7 Px7 X7 MR/MR4/MR4S1 DOE_J4`;
  if ($?) {
    print "Could not produce P7 data.\n";
    goodbye;
  }
}

produce_Px1_data;
produce_Px2_data;
produce_Px6_data;
produce_Px7_data;

