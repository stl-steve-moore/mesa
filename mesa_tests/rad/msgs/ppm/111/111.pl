#!/usr/local/bin/perl -w

use Env;

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


create_dcm_object( "111.126.gpppsncreate.txt",  "111.126.gpppsncreate.dcm");
create_dcm_object( "111.134.gpppsnset.txt",  "111.134.gpppsnset.dcm");
#create_dcm_object( "spsclaim.txt",  "spsclaim.dcm");
#create_dcm_object( "ppscreate.txt",  "ppscreate.dcm");
#create_dcm_object( "ppsset.txt",  "ppsset.dcm");
#create_dcm_object( "spscomplete.txt",  "spscomplete.dcm");

