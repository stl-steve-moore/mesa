#!/usr/local/bin/perl

# This script sends storage commitment N-events
# to a modality

use Env;
use lib "scripts";
require mod;

sub read_open_events {
  my $title = shift(@_);
# chop off trailing whitespace
  $title =~ s/\s+$//;
  my $scDir = "$MESA_STORAGE/imgmgr/commit/$title";
  opendir SCDIR, $scDir or die "directory: $scDir not found!\n";
  @scFiles = readdir SCDIR;
  closedir SCDIR;

  undef @rtnFiles;
  my $idx = 0;
  foreach $sc(@scFiles) {
    if ($sc =~ /.opn/) {
      @rtnFiles[$idx] = $sc;
      $idx++;
    }
  }
  return @rtnFiles;
}

### Main starts here

($modality, $modalityAE, $modalityHost, $modalityPort,
 $modalityStationName) =
  mod::read_config_params("mod_test.cfg");

die "Illegal modality in configuration file \n" if ($modality eq "");
die "Illegal modality station name in configuration file \n" if ($modalityStationName eq "");

opendir SCDIR, "$MESA_STORAGE/imgmgr/commit/$modalityAE" or die "Did not find storage commit requests in $MESA_STORAGE/imgmgr/commit/$modalityAE; is your storage commitment AE title $modalityAE?\n";
print "found it...\n";
@fileNames = read_open_events($modalityAE);

$count = scalar(@fileNames);
print "Found $count open Storage Commitment requests\n";

foreach $scEvent(@fileNames) {
  print "$scEvent \n";
  $x = "$MESA_TARGET/bin/im_sc_agent -a MESA_IMG_MGR -c $modalityAE $modalityHost " .
	" $modalityPort $MESA_STORAGE/imgmgr/commit/$modalityAE/$scEvent";
  print "$x\n";
  print `$x`;
  die "Could not send N-Event report for $scEvent\n" if ($?);
}

exit 0;
