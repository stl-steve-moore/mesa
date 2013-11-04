#!/usr/local/bin/perl -w

# General GET package for MESA scripts.

use Env;

package mesa_evaluate;

require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

sub eval_XML_start {
  my ($logLevel, $testNumber, $actor, $version, $date) = @_;

  my $hostname = `hostname`; chomp $hostname;

  if (mesa_evaluate::LXML) {
   print mesa_evaluate::LXML "<MESA_Result>\n";
   print mesa_evaluate::LXML " <Log>$logLevel</Log>\n";
   print mesa_evaluate::LXML " <Test>$testNumber</Test>\n";
   print mesa_evaluate::LXML " <Actor>$actor</Actor>\n";
   print mesa_evaluate::LXML " <Version>$version</Version>\n";
   print mesa_evaluate::LXML " <Date>$date</Date>\n";
   print mesa_evaluate::LXML " <Host>$hostname</Host>\n";
  } else {
   print main::LOG "<MESA_Result>\n";
   print main::LOG " <Log>$logLevel</Log>\n";
   print main::LOG " <Test>$testNumber</Test>\n";
   print main::LOG " <Actor>$actor</Actor>\n";
   print main::LOG " <Version>$version</Version>\n";
   print main::LOG " <Date>$date</Date>\n";
   print main::LOG " <Host>$hostname</Host>\n";
  }

  return 0;
}

sub outputComment {
  my ($logLevel, $comment) = @_;

  if ($comment ne "") {
    if (mesa_evaluate::LXML) {
      print mesa_evaluate::LXML " <Comment>$comment</Comment>\n";
    } else {
      print main::LOG " <Comment>$comment</Comment>\n";
    }
  }
  return 0;
}

sub startDetails {
  my ($logLevel) = @_;

  if (mesa_evaluate::LXML) {
   print mesa_evaluate::LXML " <Details> <![CDATA[\n";
  } else {
   print main::LOG " <Details> <![CDATA[\n";
  }
  return 0;
}

sub endDetails {
  my ($logLevel) = @_;

  if (mesa_evaluate::LXML) {
   print mesa_evaluate::LXML " ]]> </Details>\n";
  } else {
   print main::LOG " </Details> ]]>\n";
  }
  return 0;
}

sub endXML {
  my ($logLevel) = @_;

  if (mesa_evaluate::LXML) {
   print mesa_evaluate::LXML "</MESA_Result>\n";
  } else {
   print main::LOG "</MESA_Result>\n";
  }
  return 0;
}

sub outputCount {
  my ($logLevel, $errorCount) = @_;

  if (mesa_evaluate::LXML) {
   print mesa_evaluate::LXML " <ErrorCount>$errorCount</ErrorCount>\n";
  } else {
   print main::LOG " <ErrorCount>$errorCount</ErrorCount>\n";
  }
  return 0;
}

sub outputPassFail {
  my ($logLevel, $errorCount) = @_;

  my $result = "Pass";
  $result = "Fail" if ($errorCount != 0);
  $result = "Fail" if ($logLevel < 4);

  if (mesa_evaluate::LXML) {
   print mesa_evaluate::LXML " <Result>$result</Result>\n";
  } else {
   print main::LOG " <Result>$result</Result>\n";
  }

  return 0;
}

sub readErrorCount {
  my ($logLevel, $path) = @_;

  open LOG, "<$path" or die "Could not open $path to find error count\n";

  print "Reading error count from $path\n" if ($logLevel >= 3);

  my $count = 0;
  while ($l = <LOG>) {
   $count += 1 if ($l =~ /Error:/);
   $count += 1 if ($l =~ /ERR:/);
  }

  close LOG;
  return $count;
}

sub copyLogWithXML{
  my ($inputTxt, $outputXML, $logLevel, $testNumber, $actor, $numericVersion, $date, $errorCount) = @_;

  open LXML, ">$outputXML" or die "Could not open output: $outputXML\n";

  mesa_evaluate::eval_XML_start($logLevel, $testNumber, $actor, $numericVersion, $date);
  mesa_evaluate::outputCount($logLevel, $errorCount);
  mesa_evaluate::outputPassFail($logLevel, $errorCount);

  if ($logLevel < 4) {
    mesa_evaluate::outputComment($logLevel,
        "Log level for submission should be 4, not $logLevel. For results submission, this is considered a failure. Please rerun at log level 4.");
  }
  mesa_evaluate::startDetails($logLevel);

  open TMP, "<$inputTxt" or die "Could not open $inputTxt for input";
  while ($l = <TMP>) {
   print LXML $l;
  }
  close TMP;

  mesa_evaluate::endDetails($logLevel);
  mesa_evaluate::endXML($logLevel);
  close LOG;
}

1;
