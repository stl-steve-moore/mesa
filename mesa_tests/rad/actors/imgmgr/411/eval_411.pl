#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require imgmgr;

my $status = 0 ;
my $ostatus = 0 ;
$SIG{INT} = \&goodbye;

sub goodbye () {
    print "Exiting...\n";

    exit 1;
}

sub fail {
#    report( "\nTest 411 failed\n\n");
#    report( "Exiting...\n");
     $status = 1 ;
     $ostatus++ ;
#    exit 1;
}

sub report {
    my $msg = shift(@_);
    print "$msg\n";
    print REPORT "$msg\n";
}

sub match_responses {
    my ($name, $mesa_resp, $test_resp) = @_;

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
            print "\nTest $name failed \n";
            #print "\nTest response @ra2 fails to include modality $s1 from MESA response\n";
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
    $msg =  "$name match\n";
#    report("$msg") ;
    if( ! match_responses( "$name", "$mesa_val", $test_val)) {
        $msg =  "\nResponse from MESA ImgMgr ($mesa_val) fails to match\n";
        $msg .= "response from Test ImgMgr ($test_val).\n";
        report( "$msg\n");
        fail();
    }
    else
    {
        $status = 1 ;
        $msg .= "MESA IMGMGR: $mesa_val    TEST IMGMGR: $test_val\n";
        report("$msg\n");
    }
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
          $msg = "\n###############\nResults for $sync_att_name: $sync_att";
          report( "$msg\n");
  
          compare_attribute($test_att_name, $test_att_grp, $test_att_elm, $impath, $mspath);

      }
  }
  if($status == 0)
  {
      report("Test Passed: $test_att_name\n");
  }
}

# begin main....

$outfile = "411/grade_411.txt";
open REPORT, ">$outfile" or die "Can't open file: $outfile\n";

compare_responses("411/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Label","0070","0080");

compare_responses("411/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Description","0070","0081");

compare_responses("411/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Creation Date","0070","0082");

compare_responses("411/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Creation Time","0070","0083");

compare_responses("411/results/a",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Creators Name","0070","0084");

compare_responses("411/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Label","0070","0080");

compare_responses("411/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Description","0070","0081");

compare_responses("411/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Creation Date","0070","0082");

compare_responses("411/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Creation Time","0070","0083");

compare_responses("411/results/b",
                  "SOP Instance UID", "0008", "0018",
                  "Presentation Creators Name","0070","0084");

if($ostatus != 0)
{
  print "Test 411 had $ostatus failures\n" ;
}
else
{
  print "Test 411 Passed\n" ;
}
