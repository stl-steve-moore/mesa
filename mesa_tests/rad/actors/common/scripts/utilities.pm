#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains general utility scripts. 

use Env;

package mesa;
require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

# Subroutines found in this module

# delete_directory 
# create_directory 
# count_files_in_directory 
# get_config_params 
# get_config_param 
# rm_files 


sub delete_directory {
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

sub create_directory {
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


sub count_files_in_directory {
 my $dirName = shift(@_);

 opendir X, $dirName or die "directory: $dirName not found!";
 @fileNames = readdir X;
 closedir X;

 my $count = 0;
 F: foreach $f (@fileNames) {
  next F if ($f eq ".");
  next F if ($f eq "..");
  $count++;
 }
 return $count;

}

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
  $delimiter = "=";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = trim_whitespace(split($delimiter, $line));
    if ($varname eq "DELIMITER") {
      $delimiter = $varvalue;
    } else {
      $varnames{$varname} = $varvalue;
    }
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

# OS-neutral file delete.
sub rm_files {
   my $target = shift( @_);

   if( $MESA_OS eq "WINDOWS_NT") {
      $target =~ s(\/)(\\)g;
      $cmd = "del/Q $target";
   }
   else {
      $cmd = "rm -f $target";
   }
   print "$cmd\n";
   `$cmd`;
}    

sub dump_text_file {
  my $f = shift(@_);
  die "Error: No filename specified.\n" unless (defined $f);

  open (FILE, $f ) or die "Can't open $f .\n";
  while ($line = <FILE>) {
    print $line;
  }

  return 0;
}

# usage: elementExists(tag, filename)
# returns 1 if element exists, 0 if it does not in given filename.
# May die on error.
# tag description is as for getDICOMElements (eg. "0040.0001" or
# "0040.0220,0008.0100" for an element in a sequence)
sub elementExists {
    my $tag = shift or die "Tag not passed.";
    my $filename = shift or die "Filename not passed.";

    my ($errorCode, $value) = getDICOMElements($tag, $filename, 1);
    return 1 if $errorCode == 0;
    return 0 if $errorCode == 1;
    die "Other error ($errorCode) in reading element $tag in file $filename.\n";
}


# usage: elementIsEmpty(tag, filename)
# returns 1 if element is empty, 0 if it is not, and -1 if element does not exist 
# in given filename.  May die on error.  If element is sequence, returns true if
# the sequence contains no items.
# tag description is as for getDICOMElements (eg. "0040.0001" or
# "0040.0220,0008.0100" for an element in a sequence)
sub elementIsEmpty {
    my $tag = shift or die "Tag not passed.";
    my $filename = shift or die "Filename not passed.";

    my ($errorCode, $value) = getDICOMElements($tag, $filename);
    return -1 if $errorCode == 1;
    die "Other error ($errorCode) in reading element $tag in file $filename.\n"
        if ($errorCode != 0);

# strip off leading numbers, comments and leading and trailing spaces
    $value =~ s/^\s*[0-9a-f]{4} [0-9a-f]{4}//i;
    $value =~ s/\/\/.+$//;
    $value =~ s/^\s+//;
    $value =~ s/\s+$//;
    return 1 if ($value =~ /^#$/) or ($value =~ /^####$/);
    return 0;
}

# usage: ($group, $element) = getGroupElement($tag)
# returns the group and element values from a tag description like that passed
# to getDICOMElement (eg. "0040.0001" returns (0040, 0001)).  If a sequence
# specification is given (eg. "0040.0220,0008.0100"), the last element is returned
# (in this case, (0008, 0100)).
sub getGroupElement {
    my $tag = shift or die "Tag not passed.";
    $tag = (split /,/, $tag)[-1]; # get the last element
    $tag =~ s/:.+$//;    # remove everything after ":" -- if there is an item index
    return split /\./, $tag;
}

# usage: elementIsSequence($group, $element)
# returns 1 if element is a sequence, 0 if it is not, and -1 if element is illegal. 
sub elementIsSequence {
    my $vr = getElementVR(@_);
    return -1 if ($vr =~ /XG|XE/);
    return 1 if $vr =~ /SQ/;
    return 0;
}

# usage: elementIsValid(group, element)
# returns 1 if the element is valid (is in dictionary) and 0 if it is not.
sub elementIsValid {
    my $vr = getElementVR(@_);
    return 0 if ($vr =~ /XG|XE/);
    return 1;
}

# usage: getElementVR(group, element)
# returns the value representation of an element.  If the group is unknown, 
# returns "XG", and if the element is unknown, returns "XE".
sub getElementVR {
    my $group = shift or die "group value not passed";
    my $element = shift or die "element value not passed";

# we want to read and get the return value from mesa_dictionary
# discard error messages (get that info from error code)
    my $cmd = "$main::MESA_TARGET/bin/mesa_dictionary -r -D $group $element";
    my $pid = open(OUT, "$cmd 2>/dev/null |") or die "Error opening $cmd: $!\n";
    my $vr = <OUT>;
    close(OUT);

    my $errorCode = $? >> 8;
    return "XG" if ($errorCode == 4); # Unknown Group
    return "XE" if ($errorCode == 5); # Unknown Element 
    die "Unknown error $errorCode returned by $cmd.\n" if $errorCode != 0;
    chomp $vr;
    
    return $vr if ($errorCode == 0);  # no error
}

1;
