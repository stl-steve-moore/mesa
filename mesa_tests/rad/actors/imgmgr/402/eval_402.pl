#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
    print "Exiting...\n";

    exit 1;
}

sub fail {
    report( "\nTest failed\n\n");
    report( "Exiting...\n");

    exit 1;
}

sub report {
    my $msg = shift(@_);
    print "$msg\n";
    print REPORT "$msg\n";
}

sub match_responses {
  my ($mesa_resp, $test_resp, $attribute_name) = @_;

  @ra1 = split /\\/, $mesa_resp;
#    $test_resp = "XXX\\YY";
  @ra2 = split /\\/, $test_resp;
  $n1 = @ra1;
  $n2 = @ra2;
  if( $n1 ne $n2) {
    print "\nResponses differ in VM of response\n";
    print "MESA Response: $mesa_resp, test reponse: $test_resp\n";
    return 0;
  }
  foreach $s1 (@ra1) {
#    print "s1 = $s1\n";
    $match = 0;
    foreach $s2 (@ra2) {
      if( $s1 eq $s2) {
	$match = 1;
	last;
      }
    }
    if( ! $match) {
      print "\nTest response @ra2 fails to match $s1 from MESA response, attribute is $attribute_name\n";
      return 0;
    }
  }
  return 1;
}

sub compare_attribute {
    my $name = shift(@_);
    my $grp = shift(@_);
    my $elm = shift(@_);
    my $test_rsp = shift(@_);
    my $mesa_rsp = shift(@_);


    $mesa_val = `$MESA_TARGET/bin/dcm_print_element $grp $elm $mesa_rsp`;
    chomp($mesa_val);
    if( ! $mesa_val) {
        $msg = "Response from MESA ImgMgr ($mesa_rsp) does not contain $name attribute";
        report( "$msg\n");
        fail();
    }

    $test_val = `$MESA_TARGET/bin/dcm_print_element $grp $elm $test_rsp`;
    chomp($test_val);
    if( ! $test_val) {
        $msg = "Response from Test ImgMgr ($test_rsp) does not contain $name attribute";
        report( "$msg\n");
        fail();
    }
  
    # we have a valid response, see if they match....
    if( ! match_responses( "$mesa_val", $test_val, $name)) {
        $msg =  "Response from MESA ImgMgr ($mesa_val) fails to match\n";
        $msg .= "response from Test ImgMgr ($test_val).\n";
        report( "$msg\n");
        fail();
    }
    $msg =  "$name match\n";
    $msg .= "MESA IMGMGR: $mesa_val    TEST IMGMGR: $test_val\n";
    report("$msg\n");
}

# compare_responses
#
# for each mesa response, find a test response whose sync attribute matches
# that attribute from the mesa response.
# Compare the test attribute from each of these matching responses to see 
# if they match.
#
sub compare_responses {
  my $rdir = shift(@_);
  my $sync_att_name = shift(@_);
  my $sync_att_grp = shift(@_);
  my $sync_att_elm = shift(@_);
  my $test_att_name = shift(@_);
  my $test_att_grp = shift(@_);
  my $test_att_elm = shift(@_);

  report("Evaluation of $rdir\n");

  opendir IM_DIR, "$rdir/imgmgr" or die "Unable to open directory: $rdir/imgmgr\n";
  @imfiles = readdir IM_DIR;
  close IM_DIR;

  opendir MS_DIR, "$rdir/mesa" or die "Unable to open directory: $rdir/mesa\n";
  @msfiles = readdir MS_DIR;
  close MS_DIR;

  foreach $msfile (@msfiles) {
      if( $msfile =~ /.dcm/) {
          $mspath = "$rdir/mesa/$msfile";
          $sync_att = `$MESA_TARGET/bin/dcm_print_element $sync_att_grp $sync_att_elm $mspath`;
          chomp($sync_att);
          if( ! $sync_att) {
              $msg = "Response from MESA ImgMgr ($mspath) does not contain $sync_att_name";
              report("$msg\n");
              fail();
          }
  
          foreach $imfile (@imfiles) {
              $test_att = "";
              if( $imfile =~ /.dcm/) {
                  $impath = "$rdir/imgmgr/$imfile";
                  $val = `$MESA_TARGET/bin/dcm_print_element $sync_att_grp $sync_att_elm $impath`;
                  chomp($val);
                  if( $val eq $sync_att) { 
                       $test_att = $val;
                       last
                  }
              }
          }
          if( ! $test_att) {
              $msg = "No response from Test ImgMgr contains $sync_att_name $sync_att";
              report( "$msg");
              fail();
          }
  
          # we should have a response with a valid sync attribute at this point.
          $msg = "\nResults for $sync_att_name: $sync_att";
          report( "$msg\n");
  
          compare_attribute($test_att_name, $test_att_grp, $test_att_elm, $impath, $mspath);

      }
  }
  report("Test Passed: $test_att_name\n");
}

# begin main....

$outfile = "402/grade_402.txt";
open REPORT, ">$outfile" or die "Can't open file: $outfile\n";

compare_responses("402/results/a",
                  "Study Instance UID", "0020", "000D",
                  "Number of Study Related Series","0020","1206");

compare_responses("402/results/a",
                  "Study Instance UID", "0020", "000D",
                  "Number of Study Related Instances","0020","1208");

compare_responses("402/results/b",
                  "Series Instance UID", "0020", "000E",
                  "Number of Series Related Instances","0020","1209");

report( "\nTest 402 passed.\n");

