#!/usr/local/bin/perl -w

# Package for Image Display scripts.

use Env;

package rpt_reader;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
);

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

sub delete_directory {
  my $osName = $main::MESA_OS;
  my $dirName = shift(@_);

  if ($osName eq "WINDOWS_NT") {
    $dirName =~ s(/)(\\)g;
  }

  if (! (-d $dirName)) {
    return;
  }

  if ($osName eq "WINDOWS_NT") {
    `rmdir/q/s $dirName`;
  } else {
    `rm -rf $dirName`;
  } 
}

sub create_directory {
  my $dirName = shift(@_);

  if ($main::MESA_OS eq "WINDOWS_NT") {
    $dirName =~ s(/)(\\)g;
  }

  if (-d $dirName) {
    return;
  }

  `mkdir $dirName`;
}

sub send_images {
  my $dirName = shift(@_);
  my $deltaFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  my $cstore = "$main::MESA_TARGET/bin/cstore -a MESA "
      . " -c $imgMgrAE ";
  $cstore .= " -d $deltaFile " if ($deltaFile ne "");
  $cstore .= " $imgMgrHost $imgMgrPort";

  print "$dirName \n";

  $imageDir = "$main::MESA_STORAGE/modality/$dirName";

  my $cstoreExec = "$cstore $imageDir";
  print "$cstoreExec \n";
  print `$cstoreExec`;
  if ($?) {
    print "Could not send $dirName to Image Manager \n";
    print " Img Mgr params: $imgMgrAE:$imgMgrHost:$imgMgrPort \n";
    main::goodbye;
  }
}

sub cstore {
  my $fileName = shift(@_);
  my $deltaFile = shift(@_);
  my $mgrAE = shift(@_);
  my $mgrHost = shift(@_);
  my $mgrPort = shift(@_);

  my $cstore = "$main::MESA_TARGET/bin/cstore -a MESA "
      . " -c $mgrAE ";
  $cstore .= " -d $deltaFile " if ($deltaFile ne "");
  $cstore .= " $mgrHost $mgrPort";

  print "$fileName \n";

  if (! -e $fileName) {
    print "File/directory $fileName does not exist.\n";
    exit 1;
  }
  my $cstoreExec = "$cstore $fileName";
  print "$cstoreExec \n";
  print `$cstoreExec`;
  if ($?) {
    print "Could not send $fileName to storage manager \n";
    print " Params: $mgrAE:$mgrHost:$mgrPort \n";
    main::goodbye;
  }
}


sub send_cfind {
  my $cfindFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);
  my $outDir = shift(@_);

  $cfindString = "$main::MESA_TARGET/bin/cfind -a MESA -c $imgMgrAE -f $cfindFile -o $outDir -x STUDY $imgMgrHost $imgMgrPort ";

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
}

sub make_dcm_object {
  my $cfindTextFile = shift(@_);

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $cfindTextFile.txt $cfindTextFile.dcm";
  print "$x \n";
  print `$x`;

  if ($?) {
    print "Could not create DCM object from $cfindTextFile \n";
    exit 1;
  }
}

sub find_matching_query {
  my $verbose = shift(@_);
  my $queryDirectory = shift(@_);
  my $tagValue = shift(@_);
  my $attributeValue = shift(@_);

  print main::LOG
	"Searching for C-Find query $tagValue $attributeValue in $queryDirectory \n";

  opendir CFINDDIR, $queryDirectory or die "Could not open: $queryDirectory \n";
  @cfindMsgs = readdir CFINDDIR;
  closedir CFINDDIR;

  foreach $cfindFile (@cfindMsgs) {
    if ($cfindFile =~ /.qry/) {

      $v = `$main::MESA_TARGET/bin/dcm_print_element $tagValue $queryDirectory/$cfindFile`;
      chomp $v;
      print main::LOG " $queryDirectory/$cfindFile $v \n" if $verbose;

      if ($v eq $attributeValue) {
	return $cfindFile;
      }
    }
  }

  return "";
}

sub find_all_queries {
  my $verbose = shift(@_);
  my $queryDirectory = shift(@_);

  print main::LOG
        "Searching for all C-Find queries in $queryDirectory \n";

  opendir CFINDDIR, $queryDirectory or die "Could not open: $queryDirectory \n";
  @cfindMsgs = readdir CFINDDIR;
  closedir CFINDDIR;

  return @cfindMsgs;
}


1;
