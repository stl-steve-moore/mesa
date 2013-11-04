#!/usr/local/bin/perl -w

# General utility package for MESA scripts.

use Env;

package mesa_utility;

require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

sub delete_directory {
  my ($logLevel, $dirName) = @_;

  if (not defined($main::MESA_OS)) {
    die "mesa_utility::delete_directory No value defined for environment variable MESA_OS";
  }
  my $osName = $main::MESA_OS;

  if (! (-d $dirName)) {
    return 0;
  }

  my $rtnValue = 0;
  print "mesa::delete_directory about to delete $dirName\n" if ($logLevel >= 4);
  if ($osName eq "WINDOWS_NT") {
    $dirName =~ s(\/)(\\)g;
    my $x = "rmdir/Q/S $dirName ";
    `$x`;
    $rtnValue = 1 if ($?);
  } else {
    `rm -rf $dirName`;
    $rtnValue = 1 if ($?);
  }
  print "mesa_utility::delete_directory: unable to delete directory $dirName" if ($rtnValue == 1);
  return $rtnValue;
}

sub delete_file {
  my ($logLevel, $fileName) = @_;

#  if (not defined($main::MESA_OS)) {
#    die "mesa_utility::delete_file No value defined for environment variable MESA_OS";
#  }
#  my $osName = $main::MESA_OS;

  unlink ($fileName) if (-e $fileName);
  return 0;

#  if (! (-e $fileName)) {
#    return 0;
#  }
#
#
#
#  my $rtnValue = 0;
#  print "mesa::delete_file about to delete $fileName\n" if ($logLevel >= 4);
#  if ($osName eq "WINDOWS_NT") {
#    $fileName =~ s(\/)(\\)g;
#    my $x = "del $fileName ";
#    `$x`;
#    $rtnValue = 1 if ($?);
#  } else {
#    `rm  $fileName`;
#    $rtnValue = 1 if ($?);
#  }
#  print "mesa_utility::delete_file : unable to delete file $fileName" if ($rtnValue == 1);
#  return $rtnValue;
}

sub create_directory {
  my ($logLevel, $dirName) = @_;
  if (not defined($main::MESA_OS)) {
    die "mesa_utility::create_directory No value defined for environment variable MESA_OS";
  }

  if ( -d $dirName) {
    return 0;
  }

  print "mesa_utility::create_directory about to create $dirName\n" if ($logLevel >= 4);
  my $rtnValue = 0;

  if( $main::MESA_OS eq "WINDOWS_NT") {
     $dirName =~ s(\/)(\\)g;
     `mkdir $dirName`; 
     $rtnValue = 1 if ($?);
  } else {
     `mkdir -p $dirName`;
     $rtnValue = 1 if ($?);
  }
  if( $rtnValue != 0) {
     die "Failed to create directory: $dirName\n";
  }
  return $rtnValue;
}

sub fileSize {
  my ($logLevel, $fileName) = @_;

  ($dev, $ino, $node, $nlink, $uid, $sid, $rdev, $size,
	$atime, $mtime, $ctime, $blksize, $blocks) = stat($fileName);

  return (0, $size);
}

sub testMESAEnvironment
{
  my $logLevel = shift(@_);
  my $rtnValue = 0;

  open (M_HANDLE, ">mesa_environment.log") || die "Could not open mesa_environment.log";
  print M_HANDLE "This file will contain error messages if we detect errors in MESA configuration\n";

  # Test MESA_OS
  print M_HANDLE "Testing MESA_OS <$main::MESA_OS>\n" if ($logLevel >= 3);
  my $os = $main::MESA_OS;
  if (($os ne "WINDOWS_NT") && ($os ne "LINUX") && ($os ne "SOLARIS") && ($os ne "UNIX")) {
    $rtnValue = 1;
    print M_HANDLE "ERR: Unrecognized value for MESA_OS: $main::MESA_OS\n";
    print M_HANDLE "ERR: MESA_OS should be WINDOWS_NT, LINUX or SOLARIS\n";
  }

  # Test MESA_TARGET
  print M_HANDLE "Testing MESA_TARGET <$main::MESA_TARGET>\n" if ($logLevel >= 3);

  if (! $main::MESA_TARGET) {
    print M_HANDLE "ERR: Undefined variable MESA_TARGET; this needs to be defined\n";    $rtnValue = 1;
  } elsif ($main::MESA_TARGET eq "") {
    print M_HANDLE "ERR: MESA_TARGET has 0 length; please define properly\n";
    $rtnValue = 1;
  } elsif (! -e $main::MESA_TARGET) {
    print M_HANDLE "ERR: The MESA_TARGET directory $main::MESA_TARGET does not exist\n";
    $rtnValue = 1;
  }
  # Test MESA_STORAGE
  print M_HANDLE "Testing MESA_STORAGE <$main::MESA_STORAGE>\n" if ($logLevel >= 3);
  print M_HANDLE "Testing MESA_STORAGE <$main::MESA_STORAGE/MR/MR1>\n" if ($logLevel >= 3);
  print M_HANDLE "Testing MESA_STORAGE <$main::MESA_STORAGE/IRWF/3725>\n" if ($logLevel >= 3);
  if (! $main::MESA_STORAGE) {
    print M_HANDLE "ERR: Undefined variable MESA_STORAGE; this needs to be defined\n";
    $rtnValue = 1;
  } elsif ($main::MESA_STORAGE eq "") {
    print M_HANDLE "ERR: MESA_STORAGE has 0 length; please define properly\n";
    $rtnValue = 1;
  } elsif (! -e $main::MESA_STORAGE) {
    print M_HANDLE "ERR: The MESA_STORAGE directory $main::MESA_STORAGE does not exist\n";
    $rtnValue = 1;
  } elsif (! -e "$main::MESA_STORAGE/modality/MR/MR1") {
    print M_HANDLE "ERR: The $main::MESA_STORAGE/modality/MR/MR1 does not exist\n";
    print M_HANDLE "ERR:  This implies you have NOT properly installed those storage files\n";
    $rtnValue = 1;
  } elsif (! -e "$main::MESA_STORAGE/IRWF/3725") {
    print M_HANDLE "ERR: The $main::MESA_STORAGE/IRWF/3725 does not exist\n";
    print M_HANDLE "ERR:  This implies you have NOT properly installed those storage files\n";
    $rtnValue = 1;
  }

  # Test JAVA_HOME
  print M_HANDLE "Testing JAVA_HOME <$main::JAVA_HOME>\n" if ($logLevel >= 3);
  if (! $main::JAVA_HOME) {
    print M_HANDLE "WARN: No defined value for env variable JAVA_HOME\n";
    print M_HANDLE "WARN: Java is required for some, but not all tests\n";
  } elsif (! -e $main::JAVA_HOME) {
    print M_HANDLE "WARN: The JAVA_HOME directory $main::JAVA_HOME does not exist\n";
  }

  # Look for Windows Specific environment variables
  if ($os eq "WINDOWS_NT") {
    print M_HANDLE "Looking for Windows specific environment variables\n";
    if (! $main::MESA_SQL_LOGIN) {
      print M_HANDLE "ERR: No value set for MESA_SQL_LOGIN\n";
    }
    if (! $main::MESA_SQL_PASSWORD) {
      print M_HANDLE "ERR: No value set for MESA_SQL_PASSWORD\n";
    }
    if (! $main::MESA_SQL_SERVER_NAME) {
      print M_HANDLE "ERR: No value set for MESA_SQL_SERVER_NAME\n";
    }
    if (! $main::SQL_ACCESS) {
      print M_HANDLE "ERR: No value set for SQL_ACCESS\n";
    }
  }
  close (M_HANDLE);
  if ($rtnValue != 0) {
    print "Some problem in your environment variables or configuration\n";
    print "Look in the file: mesa_environment.log\n";
  }
  return $rtnValue;
}

sub addQuoteForStringWithBlankSpace
{
  my ($input) = @_;
  if($input =~ /\s/){
    $input = "\"$input\"";
  }
  return $input;
}

sub checkInput
{
  my($logLevel,$input) = @_;
  if($input eq ""){
    return #;
  }
  my $ret = addQuoteForStringWithBlankSpace($input);
  return $ret;
}

sub read_hash
{
  my ($logLevel, $paramsFile) = @_;

  open(H, "<$paramsFile") or die "mesa_utility::read_hash could not read $paramsFile\n";

  my %h;
  while ($l = <H>) {
    chomp $l;
    next if $l eq "#";
    my @tokens = split /\s+/, $l;
    print "  Key: <$tokens[0]> Value: <$tokens[1]>\n" if ($logLevel >= 3);
    $h{$tokens[0]} = $tokens[1];
  }
  close H;
  return %h;
} 

1;

