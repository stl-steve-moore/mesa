#!/usr/local/bin/perl -w

if ($#ARGV < 2) {
  print "Usage: <output> <text> <variables> [..<variables>]\n";
  exit;
}

$count = $#ARGV - 1;
$index = 0;
while ($index < $count) {
#  print "Var file: $ARGV[$index + 2] \n";

  open(TESTVARS, $ARGV[$index + 2]) or die "Can't open $ARGV[$index + 2]: $!\n";
  while($line = <TESTVARS>){
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    if ($varvalue =~ /####/) {
      $varvalue = "";
    }
    $varnames{$varname} = $varvalue;
  }
  close(TESTVARS);
  $index++;
}

open(TESTTEXT, "<$ARGV[1]") or die "Can't open $ARGV[1]: $!\n";
open(TEMP, ">$ARGV[0]");
while($line = <TESTTEXT>){
      next if $line =~ /^#/;              #this allows for commenting   
      foreach $varname (keys %varnames){
         $W = $varname;
         $W =~ s:\$:\\\$:g;
         $line =~ s/$W/$varnames{$varname}/eg;
      }
      print TEMP $line;
}
close(TESTTEXT);
close(TEMP);

#-e "$ARGV[2]" and print "modifications made in file '$ARGV[2]' at\n";
#print scalar localtime, "\n";
