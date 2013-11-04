#!/usr/local/bin/perl -w

# Package for Report scripts.

use Env;

package report;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
);


# Send HL7 message to a server.  Arguments:
# 1 - Directory with messages
# 2 - Message to send
# 3 - Host name of target
# 4 - Port number of target

sub send_hl7 {
  my $hl7Dir = shift(@_);
  my $msg = shift(@_);
  my $target = shift(@_);
  my $port   = shift(@_);

  my $send_hl7 = "$main::MESA_TARGET/bin/send_hl7 -d ihe ";
  print "$send_hl7 $target $port $hl7Dir/$msg \n";
  print `$send_hl7 $target $port $hl7Dir/$msg`;

  return 0 if $?;

  return 1;
}


sub read_config_params {
  open (CONFIGFILE, "enterprise_repos_test.cfg") or die "Can't open enterprise_repos_test.cfg.\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    $varnames{$varname} = $varvalue;
  }

  my $reposPort = $varnames{"TEST_HL7_PORT"};
  my $reposHost = $varnames{"TEST_HL7_HOST"};

  return ($reposHost, $reposPort);
}

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

sub convert_sr_to_hl7 {
  my $srDICOM = shift(@_);
  my $hl7Report = shift(@_);
  my $mshFile = shift(@_);

  $x = "$main::MESA_TARGET/bin/sr_to_hl7 -t $mshFile $srDICOM $hl7Report";
  print "$x \n";
  print `$x`;
  if ($?) {
    print "Could not convert DICOM SR to HL7 report \n";
    exit 1;
  }
}

sub add_universal_service_id
{
  my $inputReport  = shift(@_);
  my $uniServiceID = shift(@_);


  $x = "$main::MESA_TARGET/bin/hl7_set_value -f $inputReport " .
	" OBR 4 0 \"$uniServiceID\" ";

  print "$x \n";
  print `$x`;
}

1;
