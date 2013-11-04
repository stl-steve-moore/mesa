#!/usr/local/bin/perl -w

use Env;
use lib "scripts";
require imgmgr;

$SIG{INT} = \&goodbye;

sub goodbye () {
    print "Exiting...\n";

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
    my $att_array = shift(@_);
    my $test_rsp = shift(@_);
    my $mesa_rsp = shift(@_);
    ($name, $grp0, $elm0, $grp1, $elm1, $grp2, $elm2) = @$att_array;

    $msg = "Comparing $name.";
    report( "$msg\n");

    $cmdroot = "$MESA_TARGET/bin/dcm_print_element";
    if( ! $grp1 eq "") {
        if( ! $grp0 eq "") {
            $cmdroot .= " -z $grp0 $elm0 $grp1 $elm1";
        }
        else {
            $cmdroot .= " -s $grp1 $elm1";
        }
    }
    $cmdroot .= " $grp2 $elm2";

    $mesa_val = `$cmdroot $mesa_rsp`;
    chomp($mesa_val);
    if( ! $mesa_val) {
        $msg = "Error: Response from MESA ImgMgr ($mesa_rsp) does not contain $name attribute";
        report( "$msg\n");
        return 1;
    }

    $test_val = `$cmdroot $test_rsp`;
    chomp($test_val);
    if( ! $test_val) {
        $msg = "Error: Response from Test ImgMgr ($test_rsp) does not contain $name attribute";
        report( "$msg\n");
        return 1;
    }
  
    # we have a valid response, see if they match....
    if( ! match_responses( "$mesa_val", $test_val)) {
        $msg =  "Error: Response from MESA ImgMgr ($mesa_val) fails to match\n";
        $msg .= "response from Test ImgMgr ($test_val).\n";
        report( "$msg\n");
        return 1;
    }
    $msg =  "$name match\n";
    $msg .= "MESA IMGMGR: $mesa_val    TEST IMGMGR: $test_val\n";
    report("$msg\n");
    return 0;
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
#  my $test_att_name = shift(@_);
#  my $test_att_grp = shift(@_);
#  my $test_att_elm = shift(@_);
  my @test_att = @_;

  report("Evaluation of $rdir\n");

  opendir IM_DIR, "$rdir/imgmgr" or die "Unable to open directory: $rdir/imgmgr\n";
  @imfiles = readdir IM_DIR;
  close IM_DIR;

  opendir MS_DIR, "$rdir/mesa" or die "Unable to open directory: $rdir/mesa\n";
  @msfiles = readdir MS_DIR;
  close MS_DIR;

  $nAtt = @test_att;    # number of attributes to test per file.
  my $ndiff = 0;           # number of mismatches found.
  foreach $msfile (@msfiles) {
      if( $msfile =~ /.dcm/) {
          $mspath = "$rdir/mesa/$msfile";
          $sync_att = `$MESA_TARGET/bin/dcm_print_element $sync_att_grp $sync_att_elm $mspath`;
          chomp($sync_att);
          if( ! $sync_att) {
              $msg = "Error: Response from MESA ImgMgr ($mspath) does not contain $sync_att_name";
              report("$msg\n");
              $ndiff++;
              # return $ndiff;
          }
  
          foreach $imfile (@imfiles) {
              $im_att = "";
              if( $imfile =~ /.dcm/) {
                  $impath = "$rdir/imgmgr/$imfile";
                  $val = `$MESA_TARGET/bin/dcm_print_element $sync_att_grp $sync_att_elm $impath`;
                  chomp($val);
                  if( $val eq $sync_att) { 
                       $im_att = $val;
                       last;
                  }
              }
          }
          if( ! $im_att) {
              $msg = "Error: No response from Test ImgMgr contains $sync_att_name $sync_att";
              report( "$msg");
              $ndiff++;
              # return $ndiff;
          }
  
          # we should have a response with a valid sync attribute at this point.
          $msg = "\nResults for $sync_att_name: $sync_att";
          report( "$msg\n");
  
          # loop over all the test attributes.
          for( $i = 0; $i < $nAtt; $i++) {
              @test_atts = $test_att[$i];
              $ndiff += compare_attribute(@test_atts, $impath, $mspath);
          }

      }
  }
  return $ndiff;
}

# begin main....

$outfile = "1403/grade_1403.txt";
open REPORT, ">$outfile" or die "Can't open file: $outfile\n";

# The array of attributes to test in each matching dcm object.
@test_attributes = (
  ["SOP Class UID",                     "",    "",    "",    "","0008","0016"],
  ["Patient Name",                      "",    "",    "",    "","0010","0010"],
  ["Patient ID",                        "",    "",    "",    "","0010","0020"],
  ["Study Instance UID",                "",    "",    "",    "","0020","000D"],
  ["Accession Number",                  "",    "",    "",    "","0008","0050"],
  ["Content Date",                      "",    "",    "",    "","0008","0023"],
  ["Content Time",                      "",    "",    "",    "","0008","0033"],
  ["Concept Name Code Value",           "",    "","0040","A043","0008","0100"],
  ["Concept Name Coding Designator",    "",    "","0040","A043","0008","0102"],
# ["Concept Name Coding Vers",          "",    "","0040","A043","0008","0103"],
  ["Concept Name Code Meaning",         "",    "","0040","A043","0008","0104"],
# ["Content Template Identifier",       "",    "","0040","A504","0040","DB00"],
# ["Ref Req: Study Ins UID",            "",    "","0040","A370","0020","000D"],
# ["Ref Req: Acc. Num.",                "",    "","0040","A370","0008","0050"],
# ["Ref Req: Req Proc ID",              "",    "","0040","A370","0040","1000"],
# ["Ref Req: Req Proc Code Value",  "0040","A370","0032","1064","0008","0100"],
# ["Ref Req: Req Proc Code Desig",  "0040","A370","0032","1064","0008","0102"],
# ["Ref Req: Req Proc Code Vers",   "0040","A370","0032","1064","0008","0103"],
# ["Ref Req: Req Proc Code Meaning","0040","A370","0032","1064","0008","0104"],
);

$ndiff = compare_responses(
   "1403/results/a",
   "SOP Instance UID","0008","0018",
   @test_attributes);

if( $ndiff == 0) {
    report( "\nTest 1403 passed.\n");
}
else {
    report( "\nTest 1403 fails with $ndiff differences.\n");
}

