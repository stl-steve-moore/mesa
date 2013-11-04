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
    my ($mesa_resp, $test_resp) = @_;

    @ra1 = split /\\/, $mesa_resp;
    @ra2 = split /\\/, $test_resp;
    $n1 = @ra1;
    $n2 = @ra2;
    if( $n1 ne $n2) {
        print "\nResponses differ in number of modalities\n";
        return 0;
    }
    foreach $s1 (@ra1) {
        $match = 0;
        foreach $s2 (@ra2) {
            if( $s1 eq $s2) {
                $match = 1;
                last;
            }
        }
        if( ! $match) {
            print "\nTest response @ra2 fails to include modality $s1 from MESA response\n";
            return 0;
        }
    }
    return 1;
}

# for this test it is not an error for the attribute Number of Frames to be
# missing, so comment out the fail() here.  But still fail if its not missing
# from both.
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
        #fail();
    }

    $test_val = `$MESA_TARGET/bin/dcm_print_element $grp $elm $test_rsp`;
    chomp($test_val);
    if( ! $test_val) {
        $msg = "Response from Test ImgMgr ($test_rsp) does not contain $name attribute";
        report( "$msg\n");
        #fail();
    }
  
    # we have a valid response, see if they match....
    if( ! match_responses( "$mesa_val", $test_val)) {
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

$outfile = "404/grade_404.txt";
open REPORT, ">$outfile" or die "Can't open file: $outfile\n";

compare_responses("404/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "SOP Class UID","0008","0016");

compare_responses("404/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "Rows","0028","0010");

compare_responses("404/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "Columns","0028","0011");

compare_responses("404/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "Bits Allocated","0028","0100");

#compare_responses("404/results/a",
#                  "SOP Instance UID", "0008", "0018",
#                  "Number of Frames","0028","0008");

compare_responses("404/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "SOP Class UID","0008","0016");

compare_responses("404/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "Rows","0028","0010");

compare_responses("404/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "Columns","0028","0011");

compare_responses("404/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "Bits Allocated","0028","0100");

#compare_responses("404/results/b",
#                  "SOP Instance UID", "0008", "0018",
#                  "Number of Frames","0028","0008");

report( "\nTest 404 passed.\n");

