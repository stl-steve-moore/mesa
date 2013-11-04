#!/usr/local/bin/perl -w

use Env;


sub runTest {
  my ($testNumber, $file) = @_;

  my $x = "perl $testNumber/eval_$testNumber.pl 4 $file";
  print `$x`;
}

sub runTest2 {
  my ($testNumber, $file) = @_;
  my $x = "perl schematron/eval_schematron.pl $testNumber 4 $file";
  print "$x\n";
  print `$x`;
}

#runTest("40251", "../../msgs/pcc-gen/fsa-samples/40251.xml");

#runTest2("40312", "../../msgs/pcc-gen/apr-samples/40312.xml");
#runTest2("40313", "../../msgs/pcc-gen/apr-samples/40313.xml");
#runTest2("40315", "../../msgs/pcc-gen/apr-samples/40315.xml");
#runTest2("40316", "../../msgs/pcc-gen/apr-samples/40316.xml");
#runTest2("40317", "../../msgs/pcc-gen/apr-samples/40317.xml");
#runTest2("40318", "../../msgs/pcc-gen/apr-samples/40318.xml");
#runTest2("403xx-edd-1", "../../msgs/pcc-gen/apr-samples/403-edd-1.xml");
#runTest2("40325", "../../msgs/pcc-gen/apr-samples/40325.xml");
runTest2("40326", "../../msgs/pcc-gen/apr-samples/40326.xml");

