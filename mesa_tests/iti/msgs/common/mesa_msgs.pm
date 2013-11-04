# Package for MESA message common scripts.

use Env;

package mesa_msgs;
require Exporter;

# Arguments:
#	0	Output file
#	1	Template (input)
#	2	First input variable file
sub create_text_file {
  `perl $main::MESA_TARGET/bin/tpl_to_txt.pl $_[0] $_[1] $_[2]`;
}

# Arguments:
#	0	Output file
#	1	Template (input)
#	2	First input variable file
#	3	Second input variable file
sub create_text_file_2_var_files {
  print `perl $main::MESA_TARGET/bin/text_var_sub.pl $_[0] $_[1] $_[2] $_[3]`;
}

sub create_hl7 {
  my $x = "$main::MESA_TARGET/bin/txt_to_hl7 -d ihe-iti -b $main::MESA_TARGET/runtime ";
  print "$x < $_[0].txt > $_[0].hl7\n";
  `$x < $_[0].txt > $_[0].hl7`;
}

sub readParamsFromFile {
  my $f = shift(@_);
  open(TESTVARS, $f) or die "Can't open $f \n";
  while ($line = <TESTVARS>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
#    $varvalue = "" if ($varvalue =~ /####/);
    $main::varnames{$varname} = $varvalue;
  }
  close (TESTVARS);
}

sub getNewPID {
  my ($dbName) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName pid";
  my $y = `$x`;
  die "Could not execute mesa_identifier to get PID from $dbName database \n" if ($?);
  chomp $y;
  return $y;
}

sub getNewVisitNumber {
  my ($dbName) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName visit";
  my $y = `$x`;
  die "Could not execute mesa_identifier to get VISIT from $dbName database \n" if ($?);
  chomp $y;
  return $y;
}

sub getNewPlacerOrderNumber {
  my ($dbName) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName pon";
  my $y = `$x`;
  die "Could not execute mesa_identifier to get Placer Order Number from $dbName database \n" if ($?);
  chomp $y;
  return $y;
}

sub getNewFillerOrderNumber {
  my ($dbName) = @_;

  my $x = "$main::MESA_TARGET/bin/mesa_identifier $dbName fon";
  my $y = `$x`;
  die "Could not execute mesa_identifier to get Filler Order Number from $dbName database \n" if ($?);
  chomp $y;
  return $y;
}

