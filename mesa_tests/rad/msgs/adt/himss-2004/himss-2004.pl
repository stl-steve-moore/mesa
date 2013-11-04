#!/usr/local/bin/perl -w

use Env;

use lib "../../common";
require mesa_msgs;

# Generate HL7 messages for Modality Cases 2xx


#  mesa_msgs::create_text_file_2_var_files(
#	"211.102.a04.txt",		# The output file
#	"../templates/a04.tpl",		# Template for A04
#	"211.var",			# PID and PV1 information
#	"211.102.a04.var");		# ADT variable file
#  mesa_msgs::create_hl7("211.102.a04");
#
#  mesa_msgs::create_text_file_2_var_files(
#	"213.102.a04.txt",		# The output file
#	"../templates/a04.tpl",		# Template for A04
#	"213.var",			# PID and PV1 information
#	"213.102.a04.var");		# ADT variable file
#  mesa_msgs::create_hl7("213.102.a04");
#
#  mesa_msgs::create_text_file_2_var_files(
#	"221.102.a04.txt",		# The output file
#	"../templates/a04.tpl",		# Template for A04
#	"221.var",			# PID and PV1 information
#	"221.102.a04.var");		# ADT variable file
#  mesa_msgs::create_hl7("221.102.a04");
#
#  mesa_msgs::create_text_file_2_var_files(
#	"222.102.a04.txt",		# The output file
#	"../templates/a04.tpl",		# Template for A04
#	"222.var",			# PID and PV1 information
#	"222.102.a04.var");		# ADT variable file
#  mesa_msgs::create_hl7("222.102.a04");
#
#  mesa_msgs::create_text_file_2_var_files(
#	"231.102.a04.txt",		# The output file
#	"../templates/a04.tpl",		# Template for A04
#	"231.var",			# PID and PV1 information
#	"231.102.a04.var");		# ADT variable file
#  mesa_msgs::create_hl7("231.102.a04");
#
#  mesa_msgs::create_text_file_2_var_files(
#	"241.102.a04.txt",		# The output file
#	"../templates/a04.tpl",		# Template for A04
#	"241.var",			# PID and PV1 information
#	"241.102.a04.var");		# ADT variable file
#  mesa_msgs::create_hl7("241.102.a04");
#
#  mesa_msgs::create_text_file_2_var_files(
#	"242.102.a04.txt",		# The output file
#	"../templates/a04.tpl",		# Template for A04
#	"242.var",			# PID and PV1 information
#	"242.102.a04.var");		# ADT variable file
#  mesa_msgs::create_hl7("242.102.a04");
#

sub checkHeaderLine {
 my $txt = shift(@_);
 my @headers = ("Patient ID", "Name", "DOB", "Street Address", "City",
	"State", "Zip Code", "Participant ID", "Sex", "Race", "Referring");

 my @tokens = split '\t', $txt;

 my $index = 0;
 for ($index = 0; $index < scalar(@headers); $index++) {
  my $x = $tokens[$index];
  if ($x ne $headers[$index]) {
    print "Expected token at $index to be <$headers[$index]>, not <$x>\n";
    return 1;
  }
 }
 return 0;
}

sub processVariables {
 my $fileID = shift(@_);
 my @tokens = @_;

 print OUT "\$MESSAGE_CONTROL_ID\$ = $fileID\n";

 my $x;
 $x = $tokens[0];	# Patient ID
 print OUT "\$PATIENT_ID\$ = $x\n";
 print OUT "\$PATIENT_ACCOUNT_NUM\$ = $x\n";
 print OUT "\$VISIT_NUMBER\$ = VI$x\n";
 print OUT "\$VISIT_INDICATOR\$ = V\n";
 $x = $tokens[1];	# Patient Name
 print OUT "\$PATIENT_NAME\$ = $x\n";
 $x = $tokens[2];	# DOB
 print OUT "\$DATE_TIME_BIRTH\$ = $x\n";
 $x = $tokens[8];	# Sex
 print OUT "\$SEX\$ = $x\n";
 $x = $tokens[9];	# Race
 print OUT "\$RACE\$ = $x\n";
 $x = $tokens[10];	# Referring Phys
 print OUT "\$REFERRING_DOCTOR\$ = $x\n";

 $x = $tokens[3] . "^^" .	# Street Address
	$tokens[4] . "^" .	# City
	$tokens[5] . "^" .	# State
	$tokens[6];		# Zip Code
 print OUT "\$PATIENT_ADDRESS\$ = $x\n";

 my @headers = ("Patient ID", "Name", "DOB", "Street Address", "City",
	"State", "Zip Code", "Participant ID", "Sex", "Race");
 return 0;
}

sub processOneLine {
 my ($txt, $fileID) = @_;

 my @tokens = split '\t', $txt;

 print "$fileID \n";
# open ADT, "<adt-a04.var" or die "Could not open input text file adt-a04.var";
 open OUT, ">$fileID.var" or die "Could not open $fileID.var for output";

 my $line;
# while ($line = <ADT>) {
#  print OUT $line;
# }
 processVariables($fileID, @tokens);
 print OUT "\$PATIENT_CLASS\$ = O\n";
 print OUT "\$ADMIT_DATE_TIME\$ = ####\n";
# close ADT;
 close OUT;
 mesa_msgs::create_text_file_2_var_files(
	"$fileID.txt",		# The output file
	"../templates/a04.tpl",		# Template for A04
	"$fileID.var",			# PID and PV1 information
	"adt-a04.var");		# ADT variable file
  mesa_msgs::create_hl7("$fileID");

 return 0;
}


open DEMOG, "himss-2004.txt" or die "Could not open input text file himss-2004.txt";

$line = <DEMOG>;
chomp $line;

my $status = checkHeaderLine($line);
die "Could not process header line" if ($status != 0);

$index = 1001;
while ($line = <DEMOG>) {
 chomp $line;
 processOneLine($line, $index++);
}

exit 0;

