#!/usr/local/bin/perl -w

use Env;

# Generate RWF messages for Test 1601

sub create_dcm_object {
  my $txtfile = shift(@_);
  my $dcmfile = shift(@_);

  $x = "$MESA_TARGET/bin/dcm_create_object -i $txtfile $dcmfile";
  `$x`;
  if ($?) {
    print "Could not create DCM file from $txtfile\n";
    exit 1;
  }
}


create_dcm_object( "gpspsquery_washington.txt",  "gpspsquery_washington.dcm");
create_dcm_object( "spsclaim.txt",  "spsclaim.dcm");
create_dcm_object( "spscomplete.txt",  "spscomplete.dcm");
create_dcm_object( "ppscreate_interp.txt",  "ppscreate_interp.dcm");
create_dcm_object( "ppsset_interp.txt",  "ppsset_interp.dcm");
create_dcm_object( "ppscreate_trans.txt",  "ppscreate_trans.dcm");
create_dcm_object( "ppsset_trans.txt",  "ppsset_trans.dcm");
create_dcm_object( "ppscreate_verified.txt",  "ppscreate_verified.dcm");
create_dcm_object( "ppsset_verified.txt",  "ppsset_verified.dcm");
# create_dcm_object( "spsrelease.txt",  "spsrelease.dcm");

