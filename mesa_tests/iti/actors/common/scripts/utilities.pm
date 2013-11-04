#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains general utility scripts. 

use Env;

package mesa;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

# This subroutine courtesy of Perl Cookbook, ch. 1.14.  Strips whitespace from beginning and ends
# of strings in scalar or array context.
#   $str = trim_whitespace($str);
#   @many = trim_whitespace(@many);
sub trim_whitespace {
  my @out = @_;
  for (@out) {
    s/^\s+//;
    s/\s+$//;
  }
  return wantarray ? @out : $out[0];
}


sub get_config_params {
  my $f = shift(@_);
  die "Error: No config filename specified.\n" unless (defined $f);

  my ($line, $varname, $varvalue);

  open (CONFIGFILE, $f ) or die "Can't open $f .\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = trim_whitespace(split("=", $line));

    $varnames{$varname} = $varvalue;
  }

  return %varnames;
}

sub get_config_param {
  my ($fname, $pname) = @_;
  open (CONFIGFILE, $fname) or die "Can't open $fname .\n";

  my $line;
  while ($line = <CONFIGFILE>) {
    next if $line =~ /^#/;
    next if $line !~ /$pname/;
    my @r = trim_whitespace(split("=", $line));
    return $r[1];
  }
  die "Parameter $pname not found in file $fname.\n";
}

# usage: delete_directory(log level, directory name)
# directory name uses Unix convention for delimiters (/)
# returns 0 on success, 1 on failure

sub delete_directory {
  die "You need to define the environment variable for MESA_OS.\n Please read installation instructions.\n For example, all flavors of Windows require 'WINDOWS_NT'.\n" if (! $main::MESA_OS );
  my $osName = $main::MESA_OS;
  my ($logLevel, $dirName) = @_;

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
  print "mesa::delete_directory: unable to delete directory $dirName" if ($rtnValue == 1);
  return $rtnValue;
}

# usage: create_directory(log level, directory name)
# directory name uses Unix convention for delimiters (/)
# returns 0 on success, 1 on failure

sub create_directory {
  die "You need to define the environment variable for MESA_OS.\n Please read installation instructions.\n For example, all flavors of Windows require 'WINDOWS_NT'.\n" if (! $main::MESA_OS );
  my ($logLevel, $dirName) = @_;

  if ( -d $dirName) {
    return 0;
  }

  print "mesa::create_directory about to create $dirName\n" if ($logLevel >= 4);
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

# OS-neutral file delete.
sub rm_files {
  die "You need to define the environment variable for MESA_OS.\n Please read installation instructions.\n For example, all flavors of Windows require 'WINDOWS_NT'.\n" if (! $main::MESA_OS );
   my $target = shift( @_);

   unlink ($target) if (-e $target);

#   if( $MESA_OS eq "WINDOWS_NT") {
#      $target =~ s(\/)(\\)g;
#      $cmd = "del/Q $target";
#   }
#   else {
#      $cmd = "rm -f $target";
#   }
#   print "$cmd\n";
#   `$cmd`;
}

1;
