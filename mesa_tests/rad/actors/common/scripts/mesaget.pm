#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains general utility scripts. 

use Env;

package mesa;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

sub getGPPPSUID {
  my ($logLevel, $gpppsDirectory) = @_;

  print "mesa::getGPPPSUID Dir: $gpppsDirectory\n" if ($logLevel >= 3);
  my $fileName = "$gpppsDirectory/gppps_uid.txt";
  open (TEXTFILE, "<$fileName") or die "Can't open $fileName.\n";

  my $sopuid = <TEXTFILE>;
  return (1, "") if ($?);
  chomp $sopuid;

  return (1, "") if ($sopuid eq "");

  return (0, $sopuid);
}


# Obtains the SOP Instance UID that is stored
# in a DCM file
sub getSOPInstanceUID {
  my $dicomObjectFile = shift(@_);
  $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0018 $dicomObjectFile";
  my $sopuid = `$x`;
  chomp $sopuid;
  return $sopuid;
}

# Obtains the Image Type that is stored in a DCM file
sub getImageType {
  my $dicomObjectFile = shift(@_);
  $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0008 $dicomObjectFile";
  my $imageType = `$x`;
  chomp $imageType;
  return $imageType;
}

# Find the one KON in a database. This assumes a test environment with
# a single KON.

sub locate_KON_singular {
  my ($logLevel, $dbName) = @_;

  print main::LOG "CTX mesa::locate_KON_singular\n" if ($logLevel >= 3);
  print main::LOG "CTX Database Name: $dbName\n" if ($logLevel >= 3);

  my $x = "$main::MESA_TARGET/bin/mesa_select_column -c clauid 1.2.840.10008.5.1.4.1.1.88.59 filnam sopins $dbName filename.txt";
  print main::LOG "CTX $x\n" if ($logLevel >= 3);
 
  if ($logLevel >= 3) {
    print main::LOG "CTX: ";
    print main::LOG `$x`;
  } else {
    `$x`;
  }
  return (1, "none") if $?;

  open (TEXTFILE, "<filename.txt") or die "Can't open filename.txt.\n";

  my $path = <TEXTFILE>;

  return (1, "none") if ($?);
  close TEXTFILE;
  chomp $path;

  return (0, $path);
}

sub locate_KON_array {
  my ($logLevel, $dbName) = @_;

  print main::LOG "CTX: mesa::locate_KON_array\n" if ($logLevel >= 3);
  print main::LOG "CTX: Database Name: $dbName\n" if ($logLevel >= 3);

  my $x = "$main::MESA_TARGET/bin/mesa_select_column -c clauid 1.2.840.10008.5.1.4.1.1.88.59 filnam sopins $dbName filename.txt";
  print main::LOG "CTX: $x\n" if ($logLevel >= 3);
 
  if ($logLevel >= 3) {
    print main::LOG "CTX: ";
    print main::LOG `$x`;
  } else {
    `$x`;
  }
  return (1, "none") if $?;

  open (TEXTFILE, "<filename.txt") or die "Can't open filename.txt.\n";

  my @path;
  my $idx = 0;
  
  while ($p = <TEXTFILE>) {
    chomp $p;
    $path[$idx] = $p;
    $idx++;
  }

  return (0, @path);
}

sub db_table_retrieval {
  my ($logLevel, $dbName, $table, $column, %conditions) = @_;
  
  print main::LOG "CTX: database_table_retrieval\n" if ($logLevel >= 3);
  if ($logLevel >= 3){
    print main::LOG "CTX: Database Name: $dbName\n";
    print main::LOG "CTX: table Name: $table\n";
    print main::LOG "CTX: column Name: $column\n";
    #foreach(%conditions){
    #  print main::LOG "CTX: Database Name: $column\n";
    #}
  }
  
  my $x = "$main::MESA_TARGET/bin/mesa_select_column $column $table $dbName filename.txt";
  print main::LOG "CTX: $x\n" if ($logLevel >= 3);
  
  if ($logLevel >= 3) {
    print main::LOG "CTX: ";
    print main::LOG `$x`;
  } else {
    `$x`;
  }
  return (1, "none") if $?;
  
  open (TEXTFILE, "<filename.txt") or die "Can't open filename.txt.\n";
 
  my @rows;
  my $idx = 0;
  
  while ($row = <TEXTFILE>) {
    chomp $row;
    $rows[$idx] = $row;
    $idx++;
  }
  
  return (0, @rows);
}

sub locate_instances_by_class {
  my ($logLevel, $dbName, $sopClass) = @_;

  print main::LOG "CTX mesa::locate_instances_by_class\n" if ($logLevel >= 3);
  print main::LOG "CTX Database Name: $dbName\n" if ($logLevel >= 3);

  my $x = "$main::MESA_TARGET/bin/mesa_select_column -c clauid $sopClass filnam sopins $dbName filename.txt";
  print main::LOG "CTX $x\n" if ($logLevel >= 3);
 
  if ($logLevel >= 3) {
    print main::LOG "CTX: ";
    print main::LOG `$x`;
  } else {
    `$x`;
  }
  return (1, "none") if $?;

  open (TEXTFILE, "<filename.txt") or die "Can't open filename.txt.\n";
  my @path;
  my $idx = 0;

  while ($p = <TEXTFILE>) {
    chomp $p;
    $path[$idx] = $p;
    $idx++;
  }

  return (0, @path);
}

1;
