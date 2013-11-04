#!/usr/local/bin/perl -w

use Env;

# Generate RWF messages common to multiple tests

sub create_text_file_2_var_files {
  `perl $MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  `$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $_[0].txt > $_[0
].hl7`;
}

sub create_dcm_object {
  my $txtfile = shift(@_);
  my $dcmfile = shift(@_);

  $x = "$MESA_TARGET/bin/dcm_create_object -i $txtfile $dcmfile";
  if( $MESA_OS eq "WINDOWS_NT") {
     $x =~ s(/)(\\)g;
  }
  # print "$x\n";
  # print `$x`;
  `$x`;
}


create_dcm_object( "gppps_tmplt.txt",  "gppps_tmplt.dcm");

