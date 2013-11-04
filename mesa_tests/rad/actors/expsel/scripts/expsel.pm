use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

package expsel;
require Exporter;
@ISA = qw(Exporter);

# Test Export Selector Actor

sub processTransaction50 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $selectorAE) = @_;
  print "Running Transaction 50\n";
  print "RAD-50: Store Instances\n";
  print "Your Export Selector should send the images produced by MESA to the MESA\n";
  print " Export Manager. The images are found in $main::MESA_STORAGE/modality/$inputDir\n";
  print " The parameters for the MESA Export Manager are: $main::mesaExpMgrTitle $main::mesaExpMgrPortDICOM\n";
  print " You need to obtain those images and send them now.\n";
  
#  print "Export Selector will send images from dir ($inputDir) for event ($event) to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  my $rtnValue = 0;
  if ($selfTest == 1) {
    $rtnValue = mesa::store_images($inputDir, "", $selectorAE, $main::mesaExpMgrTitle, "localhost", $main::mesaExpMgrPortDICOM, 0);
    mesa::xmit_error($msg) if ($rtnValue != 0);
    return $rtnValue;
  }
  return $rtnValue;
}

sub processTransaction51 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $selectorAE) = @_;
  print "Running Transaction 51\n";
  print "RAD-51: Store Export Selection\n";
  print "Your Export Selector should now construct and send the KON/Manifest to the MESA Export Manager.\n";
  print "The KON can be found in $main::MESA_STORAGE/modality/$inputDir\n";
  print " You should construct your own manifest and not just copy the MESA sample.\n";
  print " The parameters for the MESA Export Manager are: $main::mesaExpMgrTitle $main::mesaExpMgrPortDICOM\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  my $rtnValue = 0;
  if ($selfTest == 1) {
    $rtnValue = mesa::store_images($inputDir, "", $selectorAE, $main::mesaExpMgrTitle, "localhost", $main::mesaExpMgrPortDICOM, 0);
    mesa::xmit_error($msg) if ($rtnValue != 0);
    return $rtnValue;
  }
  return $rtnValue;
  }

sub processTransaction52 {
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $extraOrder) = @_;
  print "Running Transaction 52\n";
  print "RAD-52: Store Additional Teaching File Information\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  $x = 0;
  mesa::xmit_error($msg) if ($x != 0);
  }

sub processTransaction53 {
  print "Transaction RAD-53 not needed for Export Selector tests\n";
  return 0;
}

sub processInternalDeidentify {
  #print "Deidentification not needed for Export Selector tests\n";
  return 0;
}

sub test_var_names {
  my %h = @_;

  my $rtnVal = 0;
  my @names = (
    "MESA_EXPMGR_HOST",
    "MESA_EXPMGR_DICOM_PT",
    "MESA_EXPMGR_AE",
    "MESA_SELECTOR_AE",
  );

  foreach $n (@names) {
    my $v = $h{$n};
    if (! $v) {
      print "No value for $n \n";
      $rtnVal = 1;
    }
  }
  return $rtnVal;
}

1;
