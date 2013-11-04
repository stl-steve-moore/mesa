#!/usr/local/bin/perl -w
use strict;
$|++;

# Perl script constructs HL7 A01 message from
# a visit and patient record in a database.

use Env;
use Cwd;
use File::Temp qw/tempfile mktemp/;
use Getopt::Std;
use lib "$MESA_TARGET/mesa_tests/rad/actors/common/scripts";
use lib "$MESA_TARGET/bin";
require mesa;
use DBI;

sub goodbye{ }

# usage: newTempFile
# returns a file handle and name of a new temporary/scratch file
# uses a perl module to create the temporary file
# this file will be placed in the given (or current if not given) 
# directory and automatically deleted upon filehandle close or program exit.
sub newTempFile {
    my $dir = shift;
    my ($fh, $scratchName);
    if ($dir) {
        ($fh, $scratchName) = tempfile("A01_txt_XXXXXX", UNLINK => 1, DIR => $dir);
    } else {
        ($fh, $scratchName) = tempfile("A01_txt_XXXXXX", UNLINK => 1);
    }
    return ($fh, $scratchName);
}

# usage mapVisitToTextFile(message, dbName, idName, fh, $param)
# This function reads one row from the patient/visit view.
# It then uses that row to write out variable values that
# are required by a given HL7 template file. These variable
# values are of the form $VAR$ = VALUE (one space on each side of the =)
#
# Inputs
#  message  Message type
#  dbname	Database name
#  destid   Destination id in hl7_destination table (unique key)
#  fh		File handle for writing output
#  param    Additional parameters for certain messages.  A hash ref.
# dies on error

sub mapVisitToTextFile {
    my $message = shift or die "Message type not passed";
    my $dbname = shift or die "DB Name not passed";
    my $destid = shift or die "Destination ID not passed";
    my $fh = shift or die "Output filehandle not passed";
    my $param = shift or die "Additional parameters not passed";

# $message has message and input from short checkbox
	#if ($message =~ m/~~/) {
	  my @message = split(/~~/, $message);
#	  my $short = $message[1];
	  $message = $message[0];
#	  print "short: $short\n" if $main::verbose;
	  print "message: $message\n" if $main::verbose;
	#}

# each message has a script associated with it where the query and the
# HL7 text is defined.  We construct the script name, then call "require" and
# "import" to access its subroutines.

# The script name is mesa_def_(MESSAGE).pl.  The scripts will be found in the
# directories specified by "use lib" up top. 
    my $script_name = "mesa_def_".lc($message).".pl";
    print "Using message script $script_name\n" if $main::verbose;
    require $script_name;
    $script_name->import(qw(getQueries getDatatext));

# connect to db
    my $dbh = DBI->connect("dbi:Pg:dbname=$dbname", "", "", 
            {AutoCommit=>1, RaiseError=>0}) 
            or die "Error: Couldn't open connection: ".$DBI::errstr;

# Get the queries.
    my @queries = getQueries($param);;
# there may be any number of queries.  Perform them one by one, and write them
# into the $dbdata hashref.  It is up to the individual modules to make sure that
# the hash keys don't clash (by using "SELECT foo AS oldfoo..." for instance).
# (will warn if they do)
    my ($query, $queryResult, $k, $dbdata);
    foreach $query (@queries) {
        $queryResult = $dbh->selectrow_hashref($query) 
            or die "Error Performing Query (database $dbname): \n$query\n";
        foreach $k (keys %$queryResult) {
            warn "Key $k already exists.  Being overwritten.\n" if $dbdata->{$k};
            $dbdata->{$k} = $queryResult->{$k};
        }
    }
    
# Get destination information
    $query = "SELECT hostname, port, rec_fac_nam, rec_app, com_nam, actor_type " .
        "FROM hl7_destination WHERE dest_id = '$destid'";
    my $dest = $dbh->selectrow_hashref($query) 
        or die "Error Performing Query (database $dbname): \n$query\n";

    $dbh->disconnect;

# Set miscellaneous parameters -- all these are in $param hashref.
    if ($dbdata->{"patcla"}) {
        $param->{"hospital_service"} = $dbdata->{"patcla"} eq "I" ? "100" : "";
    }
    if ($dbdata->{"admdat"}) { 
        $param->{"admitDateTime"} = $dbdata->{"admdat"} . $dbdata->{"admtim"};
    }
    my $patid = $dbdata->{"patid"} or die("patid not selected in SQL query");
    $patid =~ s/\s+$//;
    my $issuer = $dbdata->{"issuer"} or die("issuer not selected in SQL query");

    if (defined($short)) {
	  my @issuers = split(/&/, $issuer);
	  $issuer = $issuers[0];
	  print "issuer: $issuer\n" if $main::verbose;
    }

    $issuer =~ s/\s+$//;
    $param->{"patidIssuer"} = "$patid^^^$issuer";

    if ($dbdata->{"old_patid"}) {
        my $old_patid = $dbdata->{"old_patid"};
        $old_patid =~ s/\s+$//;
        my $old_issuer = $dbdata->{"old_issuer"};
        $old_issuer =~ s/\s+$//;
        $param->{"oldPatidIssuer"} =  "$old_patid^^^$old_issuer";
    }

    if ($dbdata->{"act_codval"}) {
        my $uniserid = $dbdata->{"uniserid"} or 
            die("uniserid not selected in SQL query");
        my $codval = $dbdata->{"act_codval"} or 
            die("actionitem.codval not selected in SQL query");
        my $codmea = $dbdata->{"act_codmea"} or 
            die("actionitem.codmea not selected in SQL query");
        my $codschdes = $dbdata->{"act_codschdes"} or 
            die("actionitem.codschdes not selected in SQL query");
        $codval =~ s/^\s+//;
        $codval =~ s/\s+$//;
        $codmea =~ s/^\s+//;
        $codmea =~ s/\s+$//;
        $codschdes =~ s/^\s+//;
        $codschdes =~ s/\s+$//;
        $param->{"uniserid_composite"} = "$uniserid^$codval^$codmea^$codschdes"; 
    }

    my $msg_id = `$MESA_TARGET/bin/mesa_identifier $dbname mcid`;
    chomp $msg_id;
    $param->{"msg_id"} = $msg_id;
    $param->{"nowDateTime"} = mesa::dateDICOM() . mesa::timeDICOM();

    if ($dbname eq "webadt") {
        $param->{"sending_app"} = "MESA_ADT";
        $param->{"sending_fac"} = "XYZ_HOSPITAL";
    } elsif ($dbname eq "webop") {
        $param->{"sending_app"} = "MESA_IS";
        $param->{"sending_fac"} = "XYZ_HOSPITAL";
    } elsif ($dbname eq "webof") {
        $param->{"sending_app"} = "MESA_OF";
        $param->{"sending_fac"} = "XYZ_DEPARTMENT";
    } else {
        warn "Unknown DB $dbname: cannot do sending appliation and facility mapping.\n";
    }

# finally, get the HL7 data text.
    my $datatext = getDatatext($dest, $dbdata, $param);
    die "Error evaluating $script_name: \$datatext undefined" if not defined $datatext;

    print "\nHL7 DATA:\n$datatext\n\n" if $main::verbose;
    print $fh $datatext;
}

# usage constructHL7(tplFile, varFile, outputFile, tmpdir)
# This function takes an input HL7 template file, an
# input variable file, merges these two files together
# and creates an output HL7 file.
# Inputs
#  tplFile	HL7 message template file
#  varFile	File of variable values ($XYZ$ = abc)
#  outputFile	Output base. We will add .txt for intermediate file
#		and .hl7 for binary output file
#  tmpdir   Directory where a temporary file will be created. Optional
#       argument.

sub constructHL7
{
  my $tplFile = shift or die "Template Filename not passed.";
  my $varFile = shift or die "Variables Filename not passed.";
  my $outputFile = shift or die "Output Filename not passed.";
  my $tmpdir = shift;
  if (defined $tmpdir) {
      $tmpdir .= "/";  # make sure it ends with a "/"
  } else {
      $tmpdir = "";
  }

# get a temporary name, but do not open it.
  my $tmpname = mktemp($tmpdir . "hl7_XXXXXX");

  my $cmd = "perl $MESA_TARGET/bin/tpl_to_txt.pl $varFile $tplFile $tmpname";
  print "$cmd\n\n" if $main::verbose;
  my $out = `$cmd`;
  print $out if $main::verbose;
  die "Error executing:\n$cmd\n" if ($?);

  $cmd = "$MESA_TARGET/bin/txt_to_hl7 -d ihe -b $MESA_TARGET/runtime < $tmpname > $outputFile";
  print "$cmd\n\n" if $main::verbose;
  $out = `$cmd`;
  print $out if $main::verbose;
  die "Error executing:\n$cmd\n" if ($?);

  unlink($tmpname) or die "Error deleting $tmpname\n";
}

sub usage {
    my $msg = shift;
    print "Error: $msg\n\n" if $msg;
    print "Usage: \n";
    print "perl mesa_construct_hl7.pl [OPTIONS] [MSG_PARAMS] \n";
    print "\tmessage template database destID outputFile\n";
    print "Constructs an HL7 message.\n";
    print "OPTIONS:\n";
    print " -h -- Prints this help message.\n";
    print " -v -- Print verbose output.\n";
    print " -t -- tmpdir Set temporary file directory.  Default is /tmp.\n\n";
    print "MSG_PARAMS -- Mandatory message-specific parameters:\n";
    print "   For A01, A03, A04:\n    -V visitKey\n ";
    print "   For A08:\n    -V visitKey -N name\n";
    print "   For A40:\n    -P patientKey -p oldPatientKey\n";
    print "   For O01_order:\n    -O orderNum\n\n";
    print "   For O01_sched:\n    -M MWLKey\n\n";
    print " -V -- visitKey The unique ID of the visit.  \n";
    print " -P -- patientKey The unique ID of the patient.\n";
    print " -p -- oldPatientKey The old unique ID of the patient.\n";
    print " -N -- name The new patient name.  \n";
    print " -O -- orderNum The unique ID of the order.\n\n";
    print " -M -- MWLKey The unique ID of the Modality Worklist entry.\n\n";
    print " templateFile -- Set template filename.  \n";
    print " message -- The name of the message.  Must be one of: \n";
    print "     A01, A03, A04, A08, A40, O01-order, O01-sched (case insensitive)\n";
    print " templateFile -- Set template filename.  \n";
    print " database -- The database.\n";
    print " destID -- The unique ID of the destination to which \n";
    print "           the HL7 message will be sent.\n";
    print " outputFile -- The HL7 output file.\n";
    exit 1;
}

##### Main starts here
use vars qw($opt_h $opt_v $opt_t $opt_N $opt_V $opt_P $opt_p $opt_O $opt_M);
usage("Unknown or bad parameter") if not getopts("hvt:N:n:V:P:p:O:M:");
usage() if $opt_h;
$main::verbose = $opt_v;
my $tmpdir;
$tmpdir = $opt_t ? $opt_t : "/tmp";

my $message = shift or usage("Message not specified");
my $tplFile = shift or usage("Template file not specified");
my $dbname = shift or usage("Database name not specified");
my $destid = shift or usage("Destination ID not specified");
my $outFile = shift or usage("Output file not specified");

my %additionalParams;

# Check mandatory parameters
if ($message =~ /A04__ITI8/i) {
    usage("Must specify patient key (\"-V patientKey\")") if not $opt_V;
    $additionalParams{"patient_key"} = $opt_V;
}elsif ($message =~ /A01|A03|A04/i) {
    usage("Must specify visit key (\"-V visitKey\")") if not $opt_V;
    $additionalParams{"viskey"} = $opt_V;
} elsif ($message =~ /A08/i) {
    usage("Must specify new patient name (\"-N name\")") if not $opt_N;
    $additionalParams{"newPatientName"} = $opt_N;
#    usage("Must specify patient ID (\"-P patID\")") if not $opt_P;
#    $additionalParams{"patient_key"} = $opt_P;
    usage("Must specify visit key (\"-V visitKey\")") if not $opt_V;
    $additionalParams{"viskey"} = $opt_V;
} elsif ($message =~ /A40/i) {
    usage("Must specify new patient ID (\"-P patientKey\")") if not $opt_P;
    $additionalParams{"patient_key"} = $opt_P;
    usage("Must specify old patient ID (\"-p oldPatientKey\")") if not $opt_p;
    $additionalParams{"old_patient_key"} = $opt_p;
} elsif ($message =~ /O01-order/i) {
    usage("Must specify Order Number (\"-O orderNumber\")") if not $opt_O;
    $additionalParams{"orduid"} = $opt_O;
} elsif ($message =~ /O01-cancel/i) {
    usage("Must specify Order Number (\"-O orderNumber\")") if not $opt_O;
    $additionalParams{"orduid"} = $opt_O;
} elsif ($message =~ /O01-sched/i) {
    usage("Must specify MWL Key (\"-M MWLKew\")") if not $opt_M;
    $additionalParams{"mwl_key"} = $opt_M;
} else {
    usage("Invalid Message type: $message");
}

if ($main::verbose) {
    print "Input Parameters:\n";
    print "Message Type:  $message\n";
    print "DB Name:  $dbname\n";
    print "Destnation ID:  $destid\n";
    print "Output File: $outFile\n";
    print "Temp Dir: $tmpdir\n";
    print "Template file: $tplFile\n";
    print "Additional parameters:\n";
    foreach my $k (keys %additionalParams) {
        print "\t$k = $additionalParams{$k}\n";
    }
}

my ($varFH, $varFN) = newTempFile($tmpdir);
print "Temp Variables file: $varFN\n" if $main::verbose;

mapVisitToTextFile($message, $dbname, $destid, $varFH, \%additionalParams);
close $varFH or die "Error closing $varFN: $!\n";
constructHL7($tplFile, $varFN, $outFile, $tmpdir);

exit 0;
