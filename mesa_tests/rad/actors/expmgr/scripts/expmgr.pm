#!/usr/local/bin/perl -w

# Package for Export Manager scripts.

use Env;

use lib "../../../rad/actors/common/scripts";
require mesa;

package expmgr;
require Exporter;
@ISA = qw(Exporter);

sub processTransaction53 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $expmgrAE) = @_;
  print "IHE Transaction RAD-53: \n";
  print "Before you send images or KONs, you need to deidentify the data\n\n";
  
  print("Export Manager($main::expMgrAE), please export your finished de-identified intances or KONs \n");
  print("for event ($event) to \n");
  print("Export Receiver($main::mesaExpRCRAE) running at host($main::host) and port($main::mesaExpRCRPortDICOM). \n");
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
    
  if($selfTest == 1){
    print("Test script will send de-idenfified instances in $inputDir\n");
    print("for event ($event) to \n");
    print("Export Receiver($main::mesaExpRCRAE) running at localhost:$main::mesaExpRCRPortDICOM \n");
    mesa::store_images($inputDir, "", $expmgrAE, $main::mesaExpRCRAE, "localhost", $main::mesaExpRCRPortDICOM, 0);
  }
      
  return 0;
}

sub processTransaction52 {
    my ($logLevel, $selfTest, $something) = @_;
    print "IHE Transaction RAD-52: \n";
    print "MESA will store additional teaching file information \n";
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    main::goodbye if ($x =~ /^q/);

	#do something
	return 0;
}

sub processTransaction51 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $expmgrAE, $wait) = @_;
  print "IHE Transaction RAD-51: \n";
  print "MESA will send Key Object Note (KON) from dir ($inputDir) for event ($event) to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);
  
  #if($selfTest == 0){
    mesa::store_images($inputDir, "", $expmgrAE, $main::expMgrAE, $main::expMgrHost, $main::expMgrPort, 0);
  #}
  
  if(!$wait){
    mesa::store_images($inputDir, "", $expmgrAE, $main::mesaExpMgrAE, "localhost", $main::mesaExpMgrPortDICOM, 1);
  }
  return 0;
}

sub processTransaction50 {
  my ($logLevel, $selfTest, $src, $dst, $event, $inputDir, $expmgrAE) = @_;
  print "IHE Transaction RAD-50: \n";
  print "MESA will send image instances from dir ($inputDir) for event ($event) to your $dst\n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye if ($x =~ /^q/);

  #if($selfTest == 0){
    mesa::store_images($inputDir, "", $expmgrAE, $main::expMgrAE, $main::expMgrHost, $main::expMgrPort, 0);
  #}
  mesa::store_images($inputDir, "", $expmgrAE, , $main::mesaExpMgrAE, "localhost", $main::mesaExpMgrPortDICOM, 1);
  return 0;
}

sub test_var_names {
  my %h = @_;
                                                                                                                             
  my $rtnVal = 0;
  my @names = (
    "TEST_EXPMGR_AE",
    "TEST_EXPMGR_HOST",
    "TEST_EXPMGR_PORT",
    
    "MESA_EXPMGR_HOST",
    "MESA_EXPMGR_DICOM_PORT",
    "MESA_EXPMGR_AE",

    "MESA_EXPRCR_HOST",
    "MESA_EXPRCR_DICOM_PORT",
    "MESA_EXPRCR_AE",
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
