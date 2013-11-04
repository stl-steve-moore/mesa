#!/usr/local/bin/perl -w

# Package for Report Creator scripts.

use Env;

package rpt_repos;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(
);


sub read_config_params {
  my $f = shift(@_);
  open (CONFIGFILE, $f) or die "Can't open $f.\n";
  while ($line = <CONFIGFILE>) {
    chomp($line);
    next if $line =~ /^#/;
    next unless $line =~ /\S/;
    ($varname, $varvalue) = split(" = ", $line);
    $varnames{$varname} = $varvalue;
  }

  $rptMgrHost = $varnames{"TEST_REPOSITORY_HOST"};
  $rptMgrPort = $varnames{"TEST_REPOSITORY_PORT"};
  $rptMgrAE= $varnames{"TEST_REPOSITORY_AE"};

  return ( $rptMgrHost, $rptMgrPort, $rptMgrAE);
}

sub xmit_error {
  my $f = shift(@_);

  print "Unable to send message: $f \n";
  exit 1;
}

sub delete_directory {
  my $osName = $main::MESA_OS;
  my $dirName = shift(@_);

  if (! (-d $dirName)) {
    return;
  }

  if ($osName eq "WINDOWS_NT") {
    $dirName =~ s(/)(\\)g;
    `rmdir/q/s $dirName`;
  } else {
    `rm -rf $dirName`;
  } 
}

sub create_directory {
  my $dirName = shift(@_);

  if ( -d $dirName) {
    return;
  }
  if( $main::MESA_OS eq "WINDOWS_NT") {
     $dirName =~ s(/)(\\)g;
     `mkdir $dirName`;
  }
  else {
     `mkdir -p $dirName`;
  }
  if( $? != 0) {
     die "Failed to create directory: $dirName\n";
  }
}

sub send_images {
  my $dirName = shift(@_);
  my $deltaFile = shift(@_);
  my $imgMgrAE = shift(@_);
  my $imgMgrHost = shift(@_);
  my $imgMgrPort = shift(@_);

  my $cstore = "$main::MESA_TARGET/bin/cstore -a MODALITY1 "
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

sub evaluate_cfind_resp {
  my $verbose = shift(@_);
  my $group  = shift(@_);
  my $element  = shift(@_);
  my $maskFile = shift(@_);
  my $tstDir = shift(@_);
  my $stdDir = shift(@_);
  if (! -e($tstDir)) {
    print main::LOG "Evaluation of C-Find responses failed.\n";
    print main::LOG "Directory with test messages: $tstDir does not exist.\n";
    return 1;
  }
  if (! -e($tstDir)) {
    print main::LOG "Evaluation of C-Find responses failed.\n";
    print main::LOG "Directory with standard messages: $sdtDir does not exist.\n
";
    return 1;
  }
  $evalString = "$main::MESA_TARGET/bin/cfind_resp_evaluate ";
  $evalString .= " -v " if ($verbose);
  $evalString .= "$group $element $maskFile $tstDir $stdDir";

  print main::LOG "$evalString \n";

  print main::LOG `$evalString`;

  return 1 if ($?);

  return 0;
}

sub send_cmove_study_uid {
  my ($cmoveFile, $reposAE,$reposHost,$reposPort, $studyUID, $wkstationAE) = @_;
  open UIDFILE, ">uid.txt" or die "Could not open uid.txt to write Study Instance UID\n";
  print UIDFILE "AA 0020 000D $studyUID\n";
  close UIDFILE;

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $cmoveFile.txt $cmoveFile.dcm";
  `$x`;

  $cmoveString = "$main::MESA_TARGET/bin/cmove -a MESA -c $reposAE " .
	" -d uid.txt " .
	" -f $cmoveFile.dcm -x STUDY $reposHost $reposPort $wkstationAE";

  print "$cmoveString \n";
  print `$cmoveString`;

  die "Could not send C-Move request \n" if ($?);

  return 0;
}

sub evaluate_cmove_object {
  my ($verbose, $patternFile, $requirements) = @_;

  $x = "$main::MESA_TARGET/bin/dcm_print_element 0008 0018 $patternFile";
  $sop_ins_uid = `$x`; chomp $sop_ins_uid;

  if (sop_ins_uid eq "") {
    print LOG "Failed to grab the SOP Instance UID from ../../msgs/sr/601/sr_601ct.dcm \n" ;
    print LOG " This is a failure of the test software/installation \n";
    return 1;
  }

  print main::LOG "SOP Instance UID: $sop_ins_uid \n" if $verbose;

  @fileNames = lookup_filname_by_sopins_uid($verbose, $sop_ins_uid);

  $x = scalar(@fileNames);
  if ($x == 0) {
    print main::LOG "No SR objects were found with SOP Ins UID $sop_ins_uid \n";
    print main::LOG " That is a failure\n";
    return 1;
  }
  if ($x != 1) {
    print main::LOG "Found $x SR objects with SOP Ins UID $sop_ins_uid \n";
    print main::LOG " That indicates a failure of the MESA tools \n";
    return 1;
  }

  $f = $fileNames[0];

  print main::LOG "\nEvaluating $f\n";
  $x = "$main::MESA_TARGET/bin/mesa_sr_eval ";
  $x .= " -v " if $verbose;
  $x .= " -r $requirements ";
  $x .= " -p $patternFile $f";

  print main::LOG "$x \n";
  print main::LOG `$x`;
  if ($? != 0) {
    print LOG "SR object $f does not pass SR evaluation.\n";
    return 1;
  }

  return 0;
}

sub lookup_filname_by_sopins_uid {
  my $verbose = shift(@_);
  my $uid = shift(@_);

  $x = "$main::MESA_TARGET/bin/mesa_select_column -c insuid $uid " .
        " filnam sopins wkstation tmp/filename.txt";

  print main::LOG "$x \n" if $verbose;
  print `$x`;
  if ($?) {
    print "Could not select File Name from Image Manager table \n";
    exit 1;
  }

  open (NAMES, "tmp/filename.txt") or die
        "Could not open tmp/filename.txt (output of mesa_select_column) \n";

  $idx = 0;
  undef @rtnFileNames;

  while (<NAMES>) {
    $f = $_;
    chomp $f;
    $rtnFileNames[$idx] = $f;
    $idx++;
  }
  return @rtnFileNames;
}


sub send_cfind_secure {
  my $cfindFile = shift(@_);
  my $mgrAE = shift(@_);
  my $mgrHost = shift(@_);
  my $mgrPort = shift(@_);
  my $outDir = shift(@_);

# Security parameters

  my $randomsFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers = shift(@_);


  $cfindString = "$main::MESA_TARGET/bin/cfind_secure " .
	" -c $mgrAE "		.
	" -R $randomsFile "	.
	" -K $keyFile "		.
	" -C $certificateFile " .
	" -P $peerList "	.
	" -Z $ciphers "	 	.
	" -a MESA -c $mgrAE -f $cfindFile -o $outDir -x STUDY $mgrHost $mgrPort ";

  print "$cfindString \n";
  print `$cfindString`;

  return 0;
}

sub cstore_secure {
  my $fileName = shift(@_);
  my $deltaFile = shift(@_);
  my $mgrAE = shift(@_);
  my $mgrHost = shift(@_);
  my $mgrPort = shift(@_);

# Security parameters

  my $randomsFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $keyFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $certificateFile = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $peerList = "$main::MESA_TARGET/runtime/certificates/" . shift(@_);
  my $ciphers = shift(@_);

  my $cstore = "$main::MESA_TARGET/bin/cstore_secure -a MESA " .
	" -c $mgrAE "		.
	" -R $randomsFile "	.
	" -K $keyFile "		.
	" -C $certificateFile "	.
	" -P $peerList "	.
	" -Z $ciphers ";

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

1;

