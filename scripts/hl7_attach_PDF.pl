#!/usr/local/bin/perl -w
use MIME::Base64;
use File::Copy;
#use MIME::Base64 qw(encode_base64);
#use MIME::Base64 qw(decode_base64);

if ($#ARGV != 3) {
  print "Usage: <in_output file> <place holder> <attachment file directory> <attachment file>\n";
  exit;
}

open(TESTTEXT, "<$ARGV[0]") or die "Can't open $ARGV[2]/$ARGV[0]: $!\n";
open(TEMP, ">tmp.txt");

open(FILE, "$ARGV[2]/$ARGV[3]") or die "$!: $ARGV[2]/$ARGV[3]";
binmode FILE;

my $encoded = "";
while (read(FILE, $buf, 60*57)) {
   $encoded = $encoded.encode_base64($buf);
}

#open (OUT, ">result.pdf");
#binmode OUT;
#my $decoded = decode_base64($encoded);
#print OUT "$decoded";


while($line = <TESTTEXT>){
      if ($line =~ /$ARGV[1]/){                      #find the place holder.   
	#print "debug: Find the place holder.\n";
	#print "replace with attachment: $encoded \n";
        $line =~ s/$ARGV[1]/$encoded/eg;
      }
      print TEMP "$line";
}
close(TESTTEXT);
close(TEMP);


#`mv tmp.txt $ARGV[2]/$ARGV[0]`;
my $moveTo = "$ARGV[2]/$ARGV[0]";
move("tmp.txt", $moveTo);
1;
