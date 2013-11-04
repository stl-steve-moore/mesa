#!/usr/local/bin/perl -w

# General DICOM package for MESA scripts.

use Env;

package mesa_dicom;

require Exporter;
@ISA = qw(Exporter);

# We do not wish to export any subroutines.
@EXPORT = qw(
);

sub create_storage_commitment {
  my ($logLevel, $selfTest, $verb, $inputDir, $outputDir) = @_;

  my @objectFiles = mesa_get::getDirectoryList($logLevel, $inputDir);
  if (scalar(@objectFiles) == 0) {
    print "mesa_dicom::create_storage_commitment found no DICOM files in $inputDir\n";
    return 1;
  }

  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_storage_commitment Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_storage_commitment Could not create output directory $outputDir\n";
    return 1;
  }
  open (SC_NACTION, ">$outputDir/naction.txt") or die
	"mesa_dicom::create_storage_commitment could not create output file: $outputDir/naction.txt";

  my $transactionUID = "1.2.3";
  print SC_NACTION "0008 1195 $transactionUID\t\t//Transaction UID\n";
  print SC_NACTION "0008 1199 \t\t//Referenced SOP Sequence\n";
  foreach $f(@objectFiles) {
    print SC_NACTION "(\n";
    $f = $inputDir . "/" . $f;
    ($x,$classUID) = mesa_get::getDICOMValue($logLevel, $f, "", "0008 0016", 1);
    ($x,$instUID)  = mesa_get::getDICOMValue($logLevel, $f, "", "0008 0018", 1);

    print SC_NACTION " 0008 1150 $classUID \t\t // Referenced SOP Class UID\n";
    print SC_NACTION " 0008 1155 $instUID \t\t // Referenced SOP Instance UID\n";
    print SC_NACTION ")\n";
  }
  close SC_NACTION;

  my $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/naction.txt $outputDir/naction.dcm";
  print "$x\n" if ($logLevel >= 3);
  `$x`;
  if ($?) {
    print "mesa_dicom::create_storage_commitment unable to execute:\n $x\n";
    return 1;
  }

  return 0;
}

sub create_mpps_messages {
  my ($logLevel, $inputDir, $outputDir, $performedAE, $retrieveAE) = @_;

  die "mesa_dicom::create_mpps_messages: No output directory specified.\n" unless (defined $outputDir);
  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_mpps_messages Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_mpps_messages Could not create output directory $outputDir\n";
    return 1;
  }

  open (MPPS_CRT, ">$outputDir/mpps_crt.txt") or die
	"mesa_dicom::create_mpps_messages could not create output file: $outputDir/mpps_crt.txt";

  @inputImages = mesa_get::getDirectoryList($logLevel, $inputDir);
  die "mesa_dicom::create_mpps_messages no input DICOM images found in $inputDir" if (scalar(@inputImages) == 0);

  my $x = scalar(@inputImages);
  print "mesa_dicom::create_mpps_messages file count: $x\n" if ($logLevel >= 3);

  my $sampleDICOM = "$inputDir/$inputImages[0]";
  ($status, $acc) = mesa_get::getDICOMValue($logLevel, $sampleDICOM, "", "0008 00050", 0);
  ($status, $modality) = mesa_get::getDICOMValue($logLevel, $sampleDICOM, "", "0008 00060", 0);
  ($status, $patientName) = mesa_get::getDICOMValue($logLevel, $sampleDICOM, "", "0010 0010", 0);
  ($status, $patientID) = mesa_get::getDICOMValue($logLevel, $sampleDICOM, "", "0010 0020", 0);
  ($status, $dob) = mesa_get::getDICOMValue($logLevel, $sampleDICOM, "", "0010 0030", 0);
  ($status, $sex) = mesa_get::getDICOMValue($logLevel, $sampleDICOM, "", "0010 0040", 0);
  ($status, $studyUID) = mesa_get::getDICOMValue($logLevel, $sampleDICOM, "", "0020 000d", 0);
  ($status, $studyID) = mesa_get::getDICOMValue($logLevel, $sampleDICOM, "", "0020 0010", 0);
  $patientName = "#" if ($patientName eq "");
  $patientID = "#" if ($patientID eq "");
  $dob = "#" if ($dob eq "");
  $sex = "#" if ($sex eq "");
  $studyID = "#" if ($studyID eq "");

  print MPPS_CRT "0008 0060 $modality\n";
  print MPPS_CRT "0008 1032 ####\n";
  print MPPS_CRT "0008 1032 ####	// Procedure Code Sequence\n";
  print MPPS_CRT "0008 1120 ####	// Referenced Patient Sequence\n";
  print MPPS_CRT "0010 0010 $patientName\n";
  print MPPS_CRT "0010 0020 $patientID\n";
  print MPPS_CRT "0010 0030 $dob\n";
  print MPPS_CRT "0010 0040 $sex\n";

  print MPPS_CRT "0020 0010 $studyID\n";

  print MPPS_CRT "0040 0241 $performedAE	// Performed Station AE Title\n";
  print MPPS_CRT "0040 0242 #		// Performed Station Name\n";
  print MPPS_CRT "0040 0243 #		// Performed Station Location\n";

  ($status, $date, $timeMin, $timeSec) = mesa_get::getDateTime($logLevel);
  print MPPS_CRT "0040 0244 $date		// PPS Start Date\n";
  print MPPS_CRT "0040 0245 $timeMin		// PPS Start Time\n";
  print MPPS_CRT "0040 0250 #		// PRC PPS End Date \n";
  print MPPS_CRT "0040 0251 #		// PRC PPS End Time \n";
  print MPPS_CRT "0040 0252 \"IN PROGRESS\" 	// MPPS Status \n";
  print MPPS_CRT "0040 0253 PPSID1028 	// PPSID \n";
  print MPPS_CRT "0040 0254 #		// PRC PPS Description \n";
  print MPPS_CRT "0040 0255 #		// PRC Perf Procedure Type Description \n";
  print MPPS_CRT "0040 0260 ####	// PRC Perf AI Sequence \n";
  print MPPS_CRT "0040 0270 (		// Scheduled Step Attr Seq\n";
  print MPPS_CRT " 0008 0050 $acc	// Accession Number\n";
  print MPPS_CRT " 0008 1110 (		// Referenced Study Sequence\n";
  print MPPS_CRT "  0008 1150 1.2.840.10008.3.1.2.3.1	// Ref SOP Class\n";
  print MPPS_CRT "  0008 1155 x.x.x.x.x0008.3.1.2.3.1	// Ref SOP Instance\n";
  print MPPS_CRT " )			// End of Referenced Study Seq\n";
  print MPPS_CRT " 0020 000d $studyUID	// Study Instance UID\n";
  print MPPS_CRT " 0032 1060 Descripton	// Requested Procedure Description\n";
  print MPPS_CRT " 0040 0007 Descripton	// Scheduled Step Description\n";
  print MPPS_CRT " 0040 0008 ####	// Scheduled Protocol Code Seq\n";
  print MPPS_CRT " 0040 0009 SPSID100	// SPS ID\n";
  print MPPS_CRT " 0040 1001 RPID100	// Requested Procedure ID\n";
  print MPPS_CRT ")			// End of Perf AI Seq\n";
  print MPPS_CRT "0040 0340 ####	// Performed Series Sequence\n";

  close MPPS_CRT;

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/mpps_crt.txt $outputDir/mpps.crt ";
  print "$x\n" if ($logLevel >= 3);

  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }
  return 1 if $?;

  # Now, process the MPPS N-Set message
  open (MPPS_SET, ">$outputDir/mpps_set.txt") or die
	"mesa_dicom::create_mpps_messages could not create output file: $outputDir/mpps_set.txt";

  print MPPS_SET "0040 0250 $date		// PPS End Date\n";
  print MPPS_SET "0040 0251 $timeMin		// PPS End Date\n";
  print MPPS_SET "0040 0252 COMPLETED	 	// MPPS Status \n";
  print MPPS_SET "0040 0260 ####	 	// Performed AI Sequence\n";
  print MPPS_SET "0040 0340 (		// Performed Series Sequence\n";
  print MPPS_SET " 0008 0054 $retrieveAE	// Retrieve AE Title\n";
  print MPPS_SET " 0008 103e SERIES_DES		// Series Description\n";
  print MPPS_SET " 0008 1050 PERFORMING		// Performing Physician\n";
  print MPPS_SET " 0008 1070 OPERATOR		// Operator Name\n";
  print MPPS_SET " 0008 1140 ####		// Referenced Image Sequence\n";
  print MPPS_SET ")			// End of Performed Series Sequence\n";
  close MPPS_SET;

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/mpps_set.txt $outputDir/mpps.set ";
  print "$x\n" if ($logLevel >= 3);

  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }

  ($status, $mppsUID) = mesa_get::getIdentifier($logLevel, "mod1", "pps_uid");
  if ($status != 0) {
    print "mesa_dicom::create_mpps_messages could not generate new MPPS UID\n";
    return 1;
  }
  open (MPPS_UID, ">$outputDir/mpps_uid.txt") or die
	"mesa_dicom::create_mpps_messages could not create output UID file: $outputDir/mpps_uid.txt";
  print MPPS_UID "$mppsUID\n";
  close MPPS_UID;

  return 1 if $?;

  return 0;
}

sub create_mpps_messages_mwl {
  my ($logLevel, $inputLabel, $outputLabel, $performedAE, $retrieveAE, $mwlQueryDirectory) = @_;

  my $status = 0;
  $status = create_mpps_messages_mwl_ncreate($logLevel, $inputLabel, $outputLabel, $performedAE, $retrieveAE, $mwlQueryDirectory);
  return 1 if ($status != 0);

  $status = create_mpps_messages_mwl_nset   ($logLevel, $inputLabel, $outputLabel, $performedAE, $retrieveAE, $mwlQueryDirectory, "");
  return 1 if ($status != 0);
  return 0 if ($status == 0);
}

sub create_mpps_messages_mwl_exception {
  my ($logLevel, $inputLabel, $outputLabel, $performedAE, $retrieveAE, $mwlQueryDirectory, $exceptionCode) = @_;

  print "x: $mwlQueryDirectory\n";

  my $status = 0;
  $status = create_mpps_messages_mwl_ncreate($logLevel, $inputLabel, $outputLabel, $performedAE, $retrieveAE, $mwlQueryDirectory);
  return 1 if ($status != 0);

  $status = create_mpps_messages_mwl_nset   ($logLevel, $inputLabel, $outputLabel, $performedAE, $retrieveAE, $mwlQueryDirectory, $exceptionCode);
  return 1 if ($status != 0);
  return 0 if ($status == 0);
}


sub create_SPATIAL{
  my ($logLevel, $selfTest, $paramsFile, $superimposed, $underlying, $outputDir) = @_;
  #use File::Find;

  my @superimposedFiles = mesa_get::getDirectoryListFullPath($logLevel, $superimposed);
  if (scalar(@superimposedFiles) == 0) {
    print "mesa_dicom::create_SPATIAL found no DICOM files in $superimposed\n";
    return 1;
  }

  my @underlyingFiles = mesa_get::getDirectoryListFullPath($logLevel, $underlying);
  if (scalar(@underlyingFiles) == 0) {
    print "mesa_dicom::create_SPATIAL found no DICOM files in $underlying\n";
    return 1;
  }

  $xSuperimposed = scalar(@superimposedFiles);
  $xUnderlying = scalar(@underlyingFiles);
  print "Found $xSuperimposed superimposed files, $xUnderlying underlying files\n";

  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_SPATIAL Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_SPATIAL Could not create output directory $outputDir\n";
    return 1;
  }

  ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime($logLevel);

  my %spatialParams = mesa_utility::read_hash($logLevel, $paramsFile);
  my $instanceUnderlying = $spatialParams{"UNDERLYING"};
  my $instanceSuperimposed = $spatialParams{"SUPERIMPOSED"};
  my $contentLabel = $spatialParams{"CONTENT_LABEL"};
  my $contentDesc = $spatialParams{"CONTENT_DESC"};
  my $creatorsName = $spatialParams{"CREATORS_NAME"};

  my ($y, $superimposedFile) = mesa_get::getDICOMFileByTag($logLevel, "0020 0013",
	$instanceSuperimposed, @superimposedFiles);
  if ($x != 0) {
    print "Did not find a file in superimposed files for 0020 0013 $instanceSuperimposed\n";
    return 1;
  }

  if (mesa_utility::create_directory($logLevel, "$main::MESA_STORAGE/scratch") != 0) {
    print "mesa_dicom::create_SPATIAL Could not create scratch directory $main::MESA_STORAGE/scratch\n";
    return 1;
  }

  ($x, $sopInsUID) = mesa_get::getIdentifier($logLevel, "mod1", "sop_inst_uid");
  if ($x != 0) {
    print "mesa_dicom::create_SPATIAL could not get SOP Instance UID\n";
    return 1;
  }
  ($x, $seriesUID) = mesa_get::getIdentifier($logLevel, "mod1", "series_uid");
  ($x, $frameOfReferenceUID) = mesa_get::getIdentifier($logLevel, "mod1", "series_uid");

  my $spatialText = "$main::MESA_STORAGE/scratch/spatial.txt";
  open (SPATIAL, ">$spatialText") or die
	"mesa_dicom::create_SPATIAL could not create output file: $spatialText";

  my @copyAttributes = ("0008 0005",
	"0008 0020", "0008 0021",
	"0008 0030", "0008 0031",
	"0008 0050", "0008 0060",
	"0010 0010", "0010 0020", "0010 0030", "0010 0040",
	"0020 000D", "0020 000E",
  );

  foreach my $a (@copyAttributes) {
    my ($z, $v) = mesa_get::getDICOMValue($logLevel, $superimposedFile, "", $a, 0);
    my $count = ($v =~tr/ //);
    $v = "\"" . $v . "\"" if ($count > 0);
    $tag{$a} = $v;
  }
  print SPATIAL "0010 0010 $tag{'0010 0010'}\n";
  print SPATIAL "0010 0020 $tag{'0010 0020'}\n";
  print SPATIAL "0010 0030 $tag{'0010 0030'}\n";
  print SPATIAL "0010 0040 $tag{'0010 0040'}\n";
  print SPATIAL "0008 0060 REG\n";


  print SPATIAL "0008 0016 1.2.840.10008.5.1.4.1.1.66.1\n";
  print SPATIAL "0008 0018 $sopInsUID\n";
  print SPATIAL "0020 000D $tag{'0020 000D'}\n";
  print SPATIAL "0020 000E $seriesUID\n";
  print SPATIAL "0020 0011 1\n";		# Series Number
  print SPATIAL "0020 0013 1\n";		# Instance Number

    # Generate Creation Date/Time
  my ($sec, $min, $hours, $mday, $month, $year) = localtime;
  my $date = sprintf "%4d%02d%02d", (1900+$year, $month+1, $mday);
  my $time = sprintf "%02d%02d%02d", ($hours, $min, $sec);

  print SPATIAL "0008 0023 $date\n";
  print SPATIAL "0008 0033 $time\n";
  ## Spatial Registration module stuff
  print SPATIAL "0070 0080 $contentLabel\n";	# Content Label
  print SPATIAL "0070 0081 $contentDesc\n";	# Content Description
  print SPATIAL "0070 0082 $date\n";	# Presentation creation date
  print SPATIAL "0070 0083 $time\n";	# Presentation creation time
  print SPATIAL "0070 0084 $creatorsName\n";	# Presentation creator name

  print SPATIAL "// Registration Sequence \n";
  print SPATIAL "0070 0308 (	// Registration Sequence\n";
  print SPATIAL " 0020 0052 $frameOfReferenceUID\n";
  print SPATIAL " 0008 1140	// Referenced Image Sequence\n";

  %att = (
    "0008 0016" => "0008 1150",
    "0008 0018" => "0008 1155",
  );

  foreach (sort @superimposedFiles) {
    print SPATIAL "   (\n";    # Series Ins UID
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print SPATIAL "    $att{$key} $v\n";
    }
    print SPATIAL "   )\n";
  }
  print SPATIAL "  0070 0309 (\n"; ## Matrix Registration Sequence
  print SPATIAL "   0070 030D (		// Registration Type Code Sequence\n";
  print SPATIAL "    0008 0100	125024\n";
  print SPATIAL "    0008 0102	DCM\n";
  print SPATIAL "    0008 0104 \"Image Content-based Alignment\"\n";
  print SPATIAL "   )\n";
  print SPATIAL "   0070 030A (\n";	## Matrix Sequence
  print SPATIAL "   3006 00C6 1\\0\\0\\0\\0\\1\\0\\0\\0\\0\\1\\0\\0\\0\\0\\1\n";
  print SPATIAL "    0070 030C	RIGID\n";
  print SPATIAL "   )\n";
  print SPATIAL "  )\n";
  print SPATIAL ")\n";

  close SPATIAL;

  my $xx = "$main::MESA_TARGET/bin/dcm_create_object -i $spatialText $outputDir/spatial.dcm";
  print "$xx\n" if ($logLevel >= 4);
  `$xx`;
  if ($?) {
    print "Could not execute $xx\n";
    return 1;
  }
}

sub create_BSPS{
  my ($logLevel, $selfTest, $paramsFile, $superimposed, $underlying, $outputDir) = @_;
  #use File::Find;

  my @superimposedFiles = mesa_get::getDirectoryListFullPath($logLevel, $superimposed);
  if (scalar(@superimposedFiles) == 0) {
    print "mesa_dicom::create_BSPS found no DICOM files in $superimposed\n";
    return 1;
  }

  my @underlyingFiles = mesa_get::getDirectoryListFullPath($logLevel, $underlying);
  if (scalar(@underlyingFiles) == 0) {
    print "mesa_dicom::create_BSPS found no DICOM files in $underlying\n";
    return 1;
  }

  $xSuperimposed = scalar(@superimposedFiles);
  $xUnderlying = scalar(@underlyingFiles);
  print "Found $xSuperimposed superimposed files, $xUnderlying underlying files\n";

  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_BSPS Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_BSPS Could not create output directory $outputDir\n";
    return 1;
  }

  ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime($logLevel);

  my %bspsParams = mesa_utility::read_hash($logLevel, $paramsFile);
  my $opacity = $bspsParams{"OPACITY"};
  my $instanceUnderlying = $bspsParams{"UNDERLYING"};
  my $instanceSuperimposed = $bspsParams{"SUPERIMPOSED"};
  my $presentationLabel = $bspsParams{"PRESENTATION_LABEL"};
  my $creatorsName = $bspsParams{"CREATORS_NAME"};

  my ($x, $underlyingFile) = mesa_get::getDICOMFileByTag($logLevel, "0020 0013",
	$instanceUnderlying, @underlyingFiles);
  if ($x != 0) {
    print "Did not find a file in underlying files for 0020 0013 $instanceUnderlying\n";
    return 1;
  }

  my ($y, $superimposedFile) = mesa_get::getDICOMFileByTag($logLevel, "0020 0013",
	$instanceSuperimposed, @superimposedFiles);
  if ($y != 0) {
    print "Did not find a file in superimposed files for 0020 0013 $instanceSuperimposed\n";
    return 1;
  }

  print "Opacity $opacity\n";
  #print "$underlyingFile\n";
  #print "$superimposedFile\n";

  if (mesa_utility::create_directory($logLevel, "$main::MESA_STORAGE/scratch") != 0) {
    print "mesa_dicom::create_BSPS Could not create scratch directory $main::MESA_STORAGE/scratch\n";
    return 1;
  }

  ($x, $sopInsUID) = mesa_get::getIdentifier($logLevel, "mod1", "sop_inst_uid");
  if ($x != 0) {
    print "mesa_dicom::create_BSPS could not get SOP Instance UID\n";
    return 1;
  }
  ($x, $seriesUID) = mesa_get::getIdentifier($logLevel, "mod1", "series_uid");

  my $bspsText = "$main::MESA_STORAGE/scratch/bsps.txt";
  open (BSPS, ">$bspsText") or die
	"mesa_dicom::create_BSPS could not create output file: $bspsText";

  my @copyAttributes = ("0008 0005",
	"0008 0020", "0008 0021",
	"0008 0030", "0008 0031",
	"0008 0050", "0008 0060",
	"0010 0010", "0010 0020", "0010 0030", "0010 0040",
	"0020 000D", "0020 000E",
  );

  foreach my $a (@copyAttributes) {
    my ($z, $v) = mesa_get::getDICOMValue($logLevel, $superimposedFile, "", $a, 0);
    my $count = ($v =~tr/ //);
    $v = "\"" . $v . "\"" if ($count > 0);
	#unless ($a eq "0020 000D" || $a eq "0020 000E") {
    #  print BSPS "$a $v\n";
    #} 
    $tag{$a} = $v;
  }
  print BSPS "0010 0010 $tag{'0010 0010'}\n";
  print BSPS "0010 0020 $tag{'0010 0020'}\n";
  print BSPS "0010 0030 $tag{'0010 0030'}\n";
  print BSPS "0010 0040 $tag{'0010 0040'}\n";

  print BSPS "0008 0060 PR\n";
  print BSPS "0008 0016 1.2.840.10008.5.1.4.1.1.11.4\n";
  print BSPS "0008 0018 $sopInsUID\n";
  print BSPS "0020 000D $tag{'0020 000D'}\n";
  print BSPS "0020 000E $seriesUID\n";
  print BSPS "0020 0011 1\n";		# Series Number
  print BSPS "0020 0013 1\n";		# Instance Number

    # Generate Creation Date/Time
  my ($sec, $min, $hours, $mday, $month, $year) = localtime;
  my $date = sprintf "%4d%02d%02d", (1900+$year, $month+1, $mday);
  my $time = sprintf "%02d%02d%02d", ($hours, $min, $sec);

  print BSPS "0008 0023 $date\n";
  print BSPS "0008 0033 $time\n";
  ## Blending state identification module stuff
  print BSPS "0070 0080 Content_Label\n";	# Content Label
  print BSPS "0070 0081 Content_Desc\n";	# Content Description
  print BSPS "0070 0082 $date\n";	# Presentation creation date
  print BSPS "0070 0083 $time\n";	# Presentation creation time
  print BSPS "0070 0084 $creatorsName\n";	# Presentation creator name

  print BSPS "0070 0080 $presentationLabel\n" if ($presentationLabel);
  print BSPS "0070 0082 $date	// Pre Creation Date\n";
  print BSPS "0070 0083 $timeToMinute	// Pres Creation Time\n";
  print BSPS "0070 0084 $creatorsName\n" if ($creatorsName);
  print BSPS "0070 0403 $opacity\n";
  print BSPS "// Blending Sequence \n";
  print BSPS "0070 0402\n";

  
  buildPresentationStateBlendingMod("SUPERIMPOSED", $superimposedFile, \@superimposedFiles, $logLevel, \%bspsParams);
  buildPresentationStateBlendingMod("UNDERLYING", $underlyingFile, \@underlyingFiles, $logLevel, \%bspsParams);

   # print BSPS "( 0070 0405 UNDERLYING\n";
   # print BSPS ")\n";

  print BSPS "0070 0403 $opacity\n";
#  print BSPS "0028 2000 sRGB\n";	# ICC Profile
  close BSPS;

  my $xx = "$main::MESA_TARGET/bin/dcm_create_object -i $bspsText $outputDir/bsps.dcm";
  print "$xx\n" if ($logLevel >= 4);
  `$xx`;
  if ($?) {
    print "Could not execute $xx\n";
    return 1;
  }
#
#  my $transactionUID = "1.2.3";
#  print SC_NACTION "0008 1195 $transactionUID\t\t//Transaction UID\n";
#  print SC_NACTION "0008 1199 \t\t//Referenced SOP Sequence\n";
#  foreach $f(@objectFiles) {
#    print SC_NACTION "(\n";
#    $f = $inputDir . "/" . $f;
#    ($x,$classUID) = mesa_get::getDICOMValue($logLevel, $f, "", "0008 0016", 1);
#    ($x,$instUID)  = mesa_get::getDICOMValue($logLevel, $f, "", "0008 0018", 1);
#
#    print SC_NACTION " 0008 1150 $classUID \t\t // Referenced SOP Class UID\n";
#    print SC_NACTION " 0008 1155 $instUID \t\t // Referenced SOP Instance UID\n";
#    print SC_NACTION ")\n";
#  }
#  close SC_NACTION;
#
#  my $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/naction.txt $outputDir/naction.dcm";
#  print "$x\n" if ($logLevel >= 3);
#  `$x`;
#  if ($?) {
#    print "mesa_dicom::create_storage_commitment unable to execute:\n $x\n";
#    return 1;
#  }
#
#  return 0;
}

sub create_BLENDING_SPATIAL{
  my ($logLevel, $selfTest, $paramsFile, $superimposed, $underlying, $spatial, $outputDir) = @_;
  #use File::Find;

  my @superimposedFiles = mesa_get::getDirectoryListFullPath($logLevel, $superimposed);
  if (scalar(@superimposedFiles) == 0) {
    print "mesa_dicom::create_BLENDING_SPATIAL found no DICOM files in $superimposed\n";
    return 1;
  }

  my @underlyingFiles = mesa_get::getDirectoryListFullPath($logLevel, $underlying);
  if (scalar(@underlyingFiles) == 0) {
    print "mesa_dicom::create_BLENDING_SPATIAL found no DICOM files in $underlying\n";
    return 1;
  }

  my @spatialFiles = mesa_get::getDirectoryListFullPath($logLevel, $spatial);
  foreach (@spatialFiles) { print $_."\n"; }
  if (scalar(@spatialFiles) == 0) {
    print "mesa_dicom::create_BLENDING_SPATIAL found no DICOM files in $spatial\n";
    return 1;
  }

  $xSuperimposed = scalar(@superimposedFiles);
  $xUnderlying = scalar(@underlyingFiles);
  $xSpatial = scalar(@spatialFiles);
  print "Found $xSuperimposed superimposed files, $xUnderlying underlying files, $xSpatial spatial file.\n";

  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_BLENDING_SPATIAL Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_BLENDING_SPATIAL Could not create output directory $outputDir\n";
    return 1;
  }

  ($x, $date, $timeToMinute, $timeToSec) = mesa_get::getDateTime($logLevel);

  my %bspsParams = mesa_utility::read_hash($logLevel, $paramsFile);
  my $opacity = $bspsParams{"OPACITY"};
  my $instanceUnderlying = $bspsParams{"UNDERLYING"};
  my $instanceSuperimposed = $bspsParams{"SUPERIMPOSED"};
  my $presentationLabel = $bspsParams{"PRESENTATION_LABEL"};
  my $creatorsName = $bspsParams{"CREATORS_NAME"};

  my ($x, $underlyingFile) = mesa_get::getDICOMFileByTag($logLevel, "0020 0013",
	$instanceUnderlying, @underlyingFiles);
  if ($x != 0) {
    print "Did not find a file in underlying files for 0020 0013 $instanceUnderlying\n";
    return 1;
  }

  my ($y, $superimposedFile) = mesa_get::getDICOMFileByTag($logLevel, "0020 0013",
	$instanceSuperimposed, @superimposedFiles);
  if ($x != 0) {
    print "Did not find a file in superimposed files for 0020 0013 $instanceSuperimposed\n";
    return 1;
  }

  print "Opacity $opacity\n";
  #print "$underlyingFile\n";
  #print "$superimposedFile\n";

  if (mesa_utility::create_directory($logLevel, "$main::MESA_STORAGE/scratch") != 0) {
    print "mesa_dicom::create_BLENDING_SPATIAL Could not create scratch directory $main::MESA_STORAGE/scratch\n";
    return 1;
  }

  ($x, $sopInsUID) = mesa_get::getIdentifier($logLevel, "mod1", "sop_inst_uid");
  if ($x != 0) {
    print "mesa_dicom::create_BLENDING_SPATIAL could not get SOP Instance UID\n";
    return 1;
  }
  ($x, $seriesUID) = mesa_get::getIdentifier($logLevel, "mod1", "series_uid");

  my $bspsText = "$main::MESA_STORAGE/scratch/spatial_bsps.txt";
  open (BSPS, ">$bspsText") or die
	"mesa_dicom::create_BLENDING_SPATIAL could not create output file: $bspsText";

  my @copyAttributes = ("0008 0005",
	"0008 0020", "0008 0021",
	"0008 0030", "0008 0031",
	"0008 0050", "0008 0060",
	"0010 0010", "0010 0020", "0010 0030", "0010 0040",
	"0020 000D", "0020 000E",
  );

  foreach my $a (@copyAttributes) {
    my ($z, $v) = mesa_get::getDICOMValue($logLevel, $superimposedFile, "", $a, 0);
    my $count = ($v =~tr/ //);
    $v = "\"" . $v . "\"" if ($count > 0);
	#unless ($a eq "0020 000D" || $a eq "0020 000E") {
    #  print BSPS "$a $v\n";
    #} 
    $tag{$a} = $v;
  }
  print BSPS "0010 0010 $tag{'0010 0010'}\n";
  print BSPS "0010 0020 $tag{'0010 0020'}\n";
  print BSPS "0010 0030 $tag{'0010 0030'}\n";
  print BSPS "0010 0040 $tag{'0010 0040'}\n";

  print BSPS "0008 0060 REG\n";
  print BSPS "0008 0016 1.2.840.10008.5.1.4.1.1.11.4\n";
  print BSPS "0008 0018 $sopInsUID\n";
  print BSPS "0020 000D $tag{'0020 000D'}\n";
  print BSPS "0020 000E $seriesUID\n";
  print BSPS "0020 0011 1\n";		# Series Number
  print BSPS "0020 0013 1\n";		# Instance Number

    # Generate Creation Date/Time
  my ($sec, $min, $hours, $mday, $month, $year) = localtime;
  my $date = sprintf "%4d%02d%02d", (1900+$year, $month+1, $mday);
  my $time = sprintf "%02d%02d%02d", ($hours, $min, $sec);

  print BSPS "0008 0023 $date\n";
  print BSPS "0008 0033 $time\n";
  ## Blending state identification module stuff
  print BSPS "0070 0081 Content_Desc\n";	# Content Description
#  print BSPS "0070 0083 $time\n";	# Presentation creation time

  print BSPS "0070 0080 $presentationLabel\n" if ($presentationLabel);
  print BSPS "0070 0082 $date	// Pre Creation Date\n";
  print BSPS "0070 0083 $timeToMinute	// Pres Creation Time\n";
  print BSPS "0070 0084 $creatorsName\n" if ($creatorsName);
  print BSPS "// Blending Sequence \n";
  print BSPS "0070 0402\n";

  
  buildPresentationStateBlendingMod("SUPERIMPOSED", $superimposedFile, \@superimposedFiles, $logLevel, \%bspsParams);
  buildPresentationStateBlendingMod("UNDERLYING", $underlyingFile, \@underlyingFiles, $logLevel, \%bspsParams);

  print BSPS "0070 0403 $opacity\n";

  my @spatialAttributes = ("0020 000D", "0020 000E", "0008 0018");

  foreach my $a (@spatialAttributes) {
    my ($z, $v) = mesa_get::getDICOMValue($logLevel, $spatialFiles[0], "", $a, 0);
    my $count = ($v =~tr/ //);
    $v = "\"" . $v . "\"" if ($count > 0);
    $spatialTag{$a} = $v;
  }
  
  print BSPS "0070 0404\n";	## Spatial Registration Seq
  print BSPS "(  0020 000D $spatialTag{'0020 000D'}\n";
  print BSPS "   0008 1115\n"; ## Ref Series Seq
  print BSPS "   (  0020 000E $spatialTag{'0020 000E'}\n";
  print BSPS "      0008 1199\n";	## Ref SOP Seq
  print BSPS "		(  0008 1150 1.2.840.10008.5.1.4.1.1.66.1\n";
  print BSPS "		   0008 1155 $spatialTag{'0008 0018'}\n";
  print BSPS "      )\n";
  print BSPS "  )\n";
  print BSPS ")\n";

##  print BSPS "0028 2000 sRGB\n";	# ICC Profile
  close BSPS;

  my $xx = "$main::MESA_TARGET/bin/dcm_create_object -i $bspsText $outputDir/bsps.dcm";
  print "$xx\n" if ($logLevel >= 4);
  `$xx`;
  if ($?) {
    print "Could not execute $xx\n";
    return 1;
  }
}


sub buildPresentationStateBlendingMod {
  my ($blendingPosition, $fileName, $files, $logLevel, $refBSPSParams) = @_;

  #foreach my $key (sort keys %$refBSPSParams){print $key.": ".$patHash->{$key}."\n";}

  my @blendingAttributes = ( "0020 000D", "0020 000E");
  my $rescaleIntercept = $refBSPSParams->{"RescaleIntercept"};
  my $rescaleSlope = $refBSPSParams->{"RescaleSlope"};
  my $rescaleType = $refBSPSParams->{"RescaleType"};
  my $windowCenter = $refBSPSParams->{"WindowCenter"};
  my $windowWidth = $refBSPSParams->{"WindowWidth"};

  foreach my $b (@blendingAttributes) {
    my ($z, $v) = mesa_get::getDICOMValue($logLevel, $fileName, "", $b, 0);
    my $count = ($v =~tr/ //);
    $v = "\"" . $v . "\"" if ($count > 0);
    $tag{$b} = $v;
  }

  print BSPS "( 0070 0405 $blendingPosition\n";
  print BSPS "  0020 000D $tag{'0020 000D'}\n";	# Study Ins UID --> this will need to be extracted
  print BSPS "  0008 1115 (\n"; # Begin ref series sequence
  print BSPS "    0020 000E $tag{'0020 000E'}\n";	# Series Ins UID --> this will need to be extracted
  print BSPS "	  0008 1140\n";	# REference Img Sequence

  %att = (
    "0008 0016" => "0008 1150",
    "0008 0018" => "0008 1155",
  );

  foreach (sort @$files) {
    print BSPS "       (\n";    # Series Ins UID
    for my $key (sort keys %att ) {
      ($status, $v) = mesa::getDICOMAttribute($logLevel, $_, $key);
      print BSPS "    $att{$key} $v\n";
    }
    print BSPS "       )\n";
 }

 print BSPS "     )\n";
 print BSPS "  0028 1052 $rescaleIntercept\n";	# Rescale Intercept
 print BSPS "  0028 1053 $rescaleSlope\n";	# Rescale Slope
 print BSPS "  0028 1054 $rescaleType\n";	# Rescale Type
 print BSPS "  0028 3110 (\n";	# Softcopy VOI LUT Seq
 print BSPS "    0028 1050 $windowCenter\n";	# Window center
 print BSPS "    0028 1051 $windowWidth\n";	# Window width
 print BSPS "  )\n";

 print BSPS ")\n";
}

sub coerceImportDicomObjectAttributes {
  my ($logLevel, $inputLabel, $outputLabel, $mppsLabel, $mwlQueryDirectory) = @_;
  my $this = "coerceImportDicomObjectAttributes";
  my $inputDir  = $main::MESA_STORAGE . "/" . $inputLabel;
  my $outputDir = $main::MESA_STORAGE . "/" . $outputLabel;
  my $mppsDirectory = $main::MESA_STORAGE . "/" . $mppsLabel;
  my $scratchDir = $main::MESA_STORAGE . "/scratch";
  
  die "mesa_dicom::$this: No MWL Query directory specified.\n" unless (defined $mwlQueryDirectory);
  die "mesa_dicom::$this: No output directory specified.\n" unless (defined $outputDir);
  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::$this: Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::$this: Could not create output directory $outputDir\n";
    return 1;
  }
  
  if (mesa_utility::delete_directory($logLevel, $scratchDir) != 0) {
    print "mesa_dicom::$this: Could not remove scratch directory $scratchDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $scratchDir) != 0) {
    print "mesa_dicom::$this: Could not create scratch directory $scratchDir\n";
    return 1;
  }

  my $mpps_uid_txt = "$mppsDirectory/mpps_uid.txt";
  open (DELTA, ">$scratchDir/delta.txt") or die
	"mesa_dicom::$this could not create output file: delta.txt";
  open(MPPS_HANDLE, "< $mpps_uid_txt") || die "Could not open MPPS UID File: $$mpps_uid_txt";
  my $uid = <MPPS_HANDLE>;
  chomp $uid;
  my $mwlDCM = "$mwlQueryDirectory/msg1_result.dcm";

  my($status, $patientName) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0010");
  ($status, my $patientID) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0020");
  ($status, my $dob) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0010 0030");
  ($status, my $sex) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0010 0040");
  ($status, my $otherPatIdMWL) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 1000");
  ($status, my $accessionNum) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"",  "0008 0050");
  ($status, my $requestedProcedureID) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0040 1001");
  ($status, my $requestedProcedureDesc) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0032 1060");
  ($status, my $scheduledProcedureStepID) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"0040 0100", "0040 0009");  
  ($status, my $scheduledProcedureStepDesc) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"0040 0100", "0040 0007");
  #no my($status, $scheduledProtocolCodeSeq) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0040 0008");

  print DELTA "0010 0010 $patientName\n";
  print DELTA "0010 0020 $patientID\n";
  print DELTA "0010 0030 $dob\n";
  print DELTA "0010 0040 $sex\n";
  
  
  #Referenced Study Seq from MWL, will merge with Referneced Study Seq from DCM
  my $retValue = "";
  $retValue = getAllReferencedStudySeq($logLevel, $mwlDCM);
  print "Ref Study Seq: $retValue\n" if($logLevel > 3);
  print DELTA "$retValue";
  
  
  #accessionNum:
  if($accessionNum eq ""){
    $accessionNum = "#";
  }
  print DELTA "0008 0050 $accessionNum\n";
  
  #Procedure Code Seq: in Eval Req, should from MWL, but our MWL does not have (0009, 1032)???? But according to IRWF should be from 0032 1064??? 
  ($status, my $codeValue) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0100");
  ($status, my $codeSchemeDesg) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0102");
  ($status, my $codeMeaning) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0104");
  $codeMeaning = mesa_utility::addQuoteForStringWithBlankSpace($codeMeaning);
  print DELTA "0008 1032(	//Procedure Code Sequence\n";
  print DELTA "  0008 0100 $codeValue //Code Value\n";  
  print DELTA "  0008 0102 $codeSchemeDesg // Coding Scheme Designator\n";
  print DELTA "  0008 0104 $codeMeaning //Code Meaning\n";
  print DELTA ")\n";
  
  #Referenced PPS Sequence: 
  #In IRWF, no source. In Evaluation, check seq exist, and SOP Class equals "1.2.840.10008.3.1.2.3.3 and SOP Instance exist.
  print DELTA "0008 1111(	//Referenced PPS Sequence\n";
  print DELTA "  0008 1150 1.2.840.10008.3.1.2.3.3\n";  
  print DELTA "  0008 1155 $uid\n";
  print DELTA ")\n";  
  
  #Original Attributes Seq
  #($status, my $sorceOfPreviousValue) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"0040 0100", "0040 0007");
  #print DELTA "0400 0561(	//Original Attributes Sequence";
  #print DELTA "  0400 0564  #		//Source of Previous Values
  
    
  close DELTA;

  @inputImages = mesa_get::getDirectoryList($logLevel, $inputDir);
  die "mesa_dicom::$this no input DICOM images found in $inputDir" if (scalar(@inputImages) == 0);

  my $x = scalar(@inputImages);
  print "mesa_dicom::$this: file count: $x\n" if ($logLevel >= 3);

  my $num = 1001;
  foreach $image(@inputImages) {
    open (DELTA, "$scratchDir/delta.txt") or die "mesa_dicom::$this could not reopen output file: delta.txt";
    open (DELTAIMG, ">$scratchDir/delta$num.txt") or die "mesa_dicom::$this could not create output file: delta$num.txt";
    while ($line = <DELTA>) {
      print DELTAIMG "$line";
    }
    close DELTA;    
    
    $image =  "$inputDir/$image";
    #Other Patient Ids
    print "Processing: $image\n" if ($logLevel >= 3);
    ($status, my $otherPatIdDCM) = mesa_get::getDICOMValue($logLevel, $image,"", "0010 1000");
    my $otherPatId = "";
    if($otherPatIdMWL ne "" && $otherPatIdDCM ne ""){
       $otherPatId = "$otherPatIdMWL\\$otherPatIdDCM";
    }elsif($otherPatIdMWL ne ""){
       $otherPatId = $otherPatIdMWL;
    }elsif($otherPatIdDCM ne ""){
       $otherPatId = $otherPatIdDCM;
    }
   
    if($otherPatId ne ""){
      print DELTAIMG "0010 1000 $otherPatId\n";
    } 
    
    #Referenced Study Seq from DCM
    #As steve and Lynn instructed, no merge. so just get the seq from mwl, not from dcm anymore.
    #$retValue = "";
    #$retValue = getAllReferencedStudySeq($logLevel, $image);
    #print DELTAIMG "$retValue\n";
    
    ($status, my $mwl_SPSID) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0040 0100", "0040 0009");
    
    #Request Attributes Sequence
    print DELTAIMG "0040 0275(	//Request Attributes Sequence\n";
    print DELTAIMG "  0040 1001 $requestedProcedureID\n";
    print DELTAIMG "  0040 0009 $mwl_SPSID\n";
    #print DELTAIMG "  0032 1060 $requestedProcedureDesc\n";
    print DELTAIMG ")\n";
    
    #Performed Procedure Step ID: should from dcm. but our sample DCM does have it. check for existence. so give arbitrary value
    ($status, my $ppsId) = mesa_get::getDICOMValue($logLevel, $image, "", "0040 0253");
    if($ppsId eq ""){
        $ppsId = "PPSID1028";
    }
    $ppsId = mesa_utility::addQuoteForStringWithBlankSpace($ppsId);
    print DELTAIMG "0040 0253 $ppsId\n";
    
    #Performed Procedure Step Description: should from dcm, but our sample DCM does have it. Check check for existence. so give arbitrary value
    ($status, my $ppsDesc) = mesa_get::getDICOMValue($logLevel, $image,"", "0040 0254");
    $ppsDesc = mesa_utility::addQuoteForStringWithBlankSpace($ppsDesc);
    if($ppsDesc eq ""){
    	#$ppsDesc = "\\\"PPS Descripton\\\"" ;
        print DELTAIMG "0040 0254 \"PPS Descripton\"\n";
    }else{
    	print DELTAIMG "0040 0254 $ppsDesc\n";
    }
    
    #Original Attributes Seq
    ($status, my $sorceOfPreviousValue) = mesa_get::getDICOMValue($logLevel, $image,"", "0008 0080");
    $sorceOfPreviousValue = mesa_utility::addQuoteForStringWithBlankSpace($sorceOfPreviousValue);
    #if($sorceOfPreviousValue =~ /\s/){
    	#$sorceOfPreviousValue = "\"$sorceOfPreviousValue\"";
    #}
    # according to Lynn, just check existence, value does not matter:
    ($status, $date, $timeMin, $timeSec) = mesa_get::getDateTime($logLevel);
    #($status, my $attrModificationDatetime) = mesa_get::getDICOMValue($logLevel, $image,"", "0008 0032");
    ($status, my $dcm_accessionNum) = mesa_get::getDICOMValue($logLevel, $image,"",  "0008 0050");
    
    ($status, $origPatientName) = mesa_get::getDICOMValue($logLevel, $image, "", "0010 0010");
    ($status, $origOtherPatId) = mesa_get::getDICOMValue($logLevel, $image, "", "0010 1000");
    ($status, $origPatID) = mesa_get::getDICOMValue($logLevel, $image, "", "0010 0020");
    ($status, $origDOB) = mesa_get::getDICOMValue($logLevel, $image, "", "0010 0030");
    
    print DELTAIMG "0400 0561(					//Original Attributes Sequence\n";
    print DELTAIMG "  0400 0564  $sorceOfPreviousValue		//Source of Previous Values\n";
    print DELTAIMG "  0400 0562  $date				//Attribute Modification Datetime\n";
    print DELTAIMG "  0400 0563	 MESA_IMPORTER			//Modifying System\n";
    print DELTAIMG "  0400 0565  COERCE				//Reseaon for the attribute modification\n";
    print DELTAIMG "  0400 0550(				//Modified attribute sequence\n";
    if (! ($patientName eq $origPatientName)) {
      print DELTAIMG "    0010 0010  $origPatientName		//Original Patient Name\n";
    }
    #start: removed due to bug fix 135
    #if($origOtherPatId ne ""){
    #  print DELTAIMG "    0010 1000  $origOtherPatId		//Original Other Pat ID\n";
    #}else{
    #  print DELTAIMG "    0010 1000  #				//Original Other Pat ID\n";
    #}
    #end: removed due to bug fix 135
    print DELTAIMG "    0010 0020  $origPatID			//Original Pat ID\n";
    print DELTAIMG "    0010 0030  $origDOB			//Original BirthDate\n";
    if($dcm_accessionNum ne ""){
       print DELTAIMG "    0008 0050  $dcm_accessionNum		//Accession\n";
    }else{
       print DELTAIMG "    0008 0050  #		//Accession\n";
    }
    #start: removed due to bug fix 135
    #Ref Study Seq
    #print DELTAIMG "$retValue";
    #Procedure Code Sequence
    #($status, my $codeValue_dcm) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0100");
    #($status, my $codeSchemeDesg_dcm) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0102");
    #($status, my $codeMeaning_dcm) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0104");
    #$codeMeaning_dcm = mesa_utility::addQuoteForStringWithBlankSpace($codeMeaning_dcm);
    #print DELTAIMG "    0008 1032(				//Prcedure Code Seq\n";
    #print DELTAIMG "      0008 0100 $codeValue_dcm //Code Value\n";  
    #print DELTAIMG "      0008 0102 $codeSchemeDesg_dcm // Coding Scheme Designator\n";
    #print DELTAIMG "      0008 0104 $codeMeaning_dcm //Code Meaning\n";
    #print DELTAIMG "    )\n";    			
    #end: removed due to bug fix 135
    print DELTAIMG "  )\n"; #//end of 0400 0550
    print DELTAIMG ")\n"; #//end 0400 0561
    print DELTAIMG "0018 A001(				//Contributing Eqt Seq\n";
    print DELTAIMG "  0040 A170(				//Purpose of Ref Code Seq\n";
    print DELTAIMG "    0008 0100 MEDIM			//Code Value\n";
    print DELTAIMG "    0008 0102 DCM				//Coding Scheme Designator\n";
    print DELTAIMG "    0008 0104 \"Portable Media Importer Equipment\"	//Code meaning\n";
    print DELTAIMG "  )\n"; #//end  0040 A170
    print DELTAIMG "  0008 0070 Fakemanufactureer		//Manufacturer\n";
    print DELTAIMG "  0008 0080 MIR				//Institution Name\n";
    print DELTAIMG "  0008 1010 ERL				//Station Name\n";
    print DELTAIMG "  0018 A002 20060625			//Contr Datetime\n";
    print DELTAIMG ")	\n"; #//end 0018 A0001      
    close DELTAIMG;
    
    my $y = "$main::MESA_TARGET/bin/dcm_modify_object -t -T -i $scratchDir/delta$num.txt $image $outputDir/$num.dcm";
    print "$y\n" if ($logLevel >= 3);
    `$y`;
    die "mesa_dicom::$this could not coerce object" if ($?);
    $num += 1;
  }
  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/mpps_crt.txt $outputDir/mpps.crt ";
  return 0;
}

sub getAllReferencedStudySeq{
    my ($logLevel, $path) = @_;
    my $done = 0;
    my $idx = 1;
    my $value = "";
    while (! $done) {
      my ($s1, $instanceUID) = mesa_get::getDICOMValue($logLevel, $path, "0008 1110", "0008 1155",  $idx);
      my ($s2, $classUID) = mesa_get::getDICOMValue($logLevel, $path, "0008 1110", "0008 1150",  $idx);
      if ($instanceUID eq "") {
        $done = 1;
      } else {
        $value = $value."0008 1110( 	//Referenced Study Sequence\n";
	$value = $value."  0008 1150  $classUID	//Referenced SOP Class UID\n";
	$value = $value."  0008 1155  $instanceUID	//Referenced SOP Instance UID\n";
	$value = $value.")\n";
        $idx++;
      }
    }
    return $value;
}


sub coerceObjectsADT {
  my ($logLevel, $adtMessage, $inputDir, $outputDir) = @_;

  die "mesa_dicom::coerceObjectsADT: No output directory specified.\n" unless (defined $outputDir);
  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::coerceObjectsADT: Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::coerceObjectsADT: Could not create output directory $outputDir\n";
    return 1;
  }

  open (DELTA, ">delta.txt") or die
	"mesa_dicom::coerceObjectsADT could not create output file: delta.txt";

  ($status, $patientName) = mesa_get::getHL7Field($logLevel,
	"../../msgs/$adtMessage", "PID", "5", "0", "Patient Name", "2.3.1");
  ($status, $patientID) = mesa_get::getHL7Field($logLevel,
	"../../msgs/$adtMessage", "PID", "3", "1", "Patient ID", "2.3.1");
  ($status, $dob) = mesa_get::getHL7Field($logLevel,
	"../../msgs/$adtMessage", "PID", "7", "0", "DOB", "2.3.1");
  ($status, $sex) = mesa_get::getHL7Field($logLevel,
	"../../msgs/$adtMessage", "PID", "8", "0", "Sex", "2.3.1");

  print DELTA "0010 0010 $patientName\n";
  print DELTA "0010 0020 $patientID\n";
  print DELTA "0010 0030 $dob\n";
  print DELTA "0010 0040 $sex\n";

  close DELTA;

  @inputImages = mesa_get::getDirectoryList($logLevel, $inputDir);
  die "mesa_dicom::coerceObjectsADT no input DICOM images found in $inputDir" if (scalar(@inputImages) == 0);

  my $x = scalar(@inputImages);
  print "mesa_dicom::coerceObjectsADT: file count: $x\n" if ($logLevel >= 3);

  my $num = 1001;
  foreach $image(@inputImages) {
    my $y = "$main::MESA_TARGET/bin/dcm_modify_object -i delta.txt $inputDir/$image $outputDir/$num.dcm";
    $num += 1;
    print "$y\n" if ($logLevel >= 3);
    `$y`;
    die "mesa_dicom::coerceObjectsADT could not coerce object" if ($?);
  }

#
#  print MPPS_CRT "0020 0010 $studyID\n";
#
#  print MPPS_CRT "0040 0241 $performedAE	// Performed Station AE Title\n";
#  print MPPS_CRT "0040 0242 #		// Performed Station Name\n";
#  print MPPS_CRT "0040 0243 #		// Performed Station Location\n";
#
#  ($status, $date, $timeMin, $timeSec) = mesa_get::getDateTime($logLevel);
#  print MPPS_CRT "0040 0244 $date		// PPS Start Date\n";
#  print MPPS_CRT "0040 0245 $timeMin		// PPS Start Date\n";
#  print MPPS_CRT "0040 0250 #		// PRC PPS End Date \n";
#  print MPPS_CRT "0040 0251 #		// PRC PPS End Time \n";
#  print MPPS_CRT "0040 0252 \"IN PROGRESS\" 	// MPPS Status \n";
#  print MPPS_CRT "0040 0253 PPSID1028 	// PPSID \n";
#  print MPPS_CRT "0040 0254 #		// PRC PPS Description \n";
#  print MPPS_CRT "0040 0255 #		// PRC Perf Procedure Type Description \n";
#  print MPPS_CRT "0040 0260 ####	// PRC Perf AI Sequence \n";
#  print MPPS_CRT "0040 0270 (		// Scheduled Step Attr Seq\n";
#  print MPPS_CRT " 0008 0050 $acc	// Accession Number\n";
#  print MPPS_CRT " 0008 1110 (		// Referenced Study Sequence\n";
#  print MPPS_CRT "  0008 1150 1.2.840.10008.3.1.2.3.1	// Ref SOP Class\n";
#  print MPPS_CRT "  0008 1155 x.x.x.x.x0008.3.1.2.3.1	// Ref SOP Instance\n";
#  print MPPS_CRT " )			// End of Referenced Study Seq\n";
#  print MPPS_CRT " 0020 000d $studyUID	// Study Instance UID\n";
#  print MPPS_CRT " 0032 1060 Descripton	// Requested Procedure Description\n";
#  print MPPS_CRT " 0040 0007 Descripton	// Scheduled Step Description\n";
#  print MPPS_CRT " 0040 0008 ####	// Scheduled Protocol Code Seq\n";
#  print MPPS_CRT " 0040 0009 SPSID100	// SPS ID\n";
#  print MPPS_CRT " 0040 1001 RPID100	// Requested Procedure ID\n";
#  print MPPS_CRT ")			// End of Perf AI Seq\n";
#  print MPPS_CRT "0040 0340 ####	// Performed Series Sequence\n";
#
#  close MPPS_CRT;
#
  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/mpps_crt.txt $outputDir/mpps.crt ";
#  print "$x\n" if ($logLevel >= 3);
#
#  if ($logLevel >= 3) {
#    print `$x`;
#  } else {
#    `$x`;
#  }
#  return 1 if $?;
#
  return 0;
}

sub edits() {
    ##-d and print "$_\n";
    return unless (-f and /\.dcm$/);
    #print "File: $File::Find::name\n";
    push @files, $File::Find::name;
}

sub constructCFindQuery {
  my ($logLevel, $event, $param, $inputDir, $outputDir) = @_;
  my $outputPath = "";
  my $status = 1;

  if ($event eq "QUERY-INSTANCE-SOP-CLASS") {
    my $path = $main::MESA_STORAGE . "/" . $param;
    ($status, $outputPath) = mesa_dicom::constructCFindSOPClass(
		$logLevel, $path, $inputDir, $outputDir);
  } elsif ($event eq "QUERY-STUDY_UID") {
    ($status, $outputPath) = mesa_dicom::constructCFindStudyUID(
		$logLevel, $param, $inputDir, $outputDir);
  } else {
    print "\nmesa_dicom::constructCFindQuery unrecognized event: <$event>\n";
    return 1;
  }
  return ($status, $outputPath);
}

sub constructCFindSOPClass {
  my ($logLevel, $path, $inputDir, $outputDir) = @_;
  my $outputPath = "";
  my $status = 1;
  @fileList = mesa_get::getDirectoryListFullPathByExtension(
	$logLevel, ".dcm", $path);
  if (scalar(@fileList) == 0) {
    print "mesa_dicom::constructCFindSOPClass did not find a dcm file in $path\n";
    return 1;
  }
  ($x, $studyUID) = mesa_get::getDICOMValue($logLevel, $fileList[0], "", "0020 000D", 0);
  return (1, "") if ($x != 0);
  ($x, $seriesUID) = mesa_get::getDICOMValue($logLevel, $fileList[0], "", "0020 000E", 0);
  return (1, "") if ($x != 0);
  ($x, $classUID) = mesa_get::getDICOMValue($logLevel, $fileList[0], "", "0008 0016", 0);
  return (1, "") if ($x != 0);

  my $txtFile = "$main::MESA_STORAGE/tmp/cfind.txt";

  open TXT, ">$txtFile" or die "mesa_dicom::constructCFindSOPClass Could not open $txtFile\n";
  print TXT "0008 0016 $classUID	// SOP Class UID\n";
  print TXT "0008 0018 #	// SOP Instance UID\n";
  print TXT "0008 0052 IMAGE	// Query Level\n";
  print TXT "0020 000D $studyUID	// Study Instance UID\n";
  print TXT "0020 000E $seriesUID	// Series Instance UID\n";

  # If BSPS class, then add return keys at the Image Level
  if ($classUID eq "1.2.840.10008.5.1.4.1.1.11.4") {
    print TXT "0070 0080 #	// Presentation Label\n";
    print TXT "0070 0082 #	// Presentation Creation Date\n";
    print TXT "0070 0083 #	// Presentation Creation Time\n";
    print TXT "0070 0084 #	// Presentation Creators Name\n";
  }
  close TXT;

  my $cfindFile = "$main::MESA_STORAGE/tmp/cfind.dcm";
  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $txtFile $cfindFile";
  print "$x\n" if ($logLevel >= 3);
  `$x`;
  if ($?) {
    print "Could not execute: $x\n";
    return (1, "");
  }

  return (0, $cfindFile);
}

sub constructCFindStudyUID{
  my ($logLevel, $studyUID, $inputDir, $outputDir) = @_;
  my $outputPath = "";
  my $status = 1;

  my $txtFile = "$main::MESA_STORAGE/tmp/cfind.txt";

  open TXT, ">$txtFile" or die "mesa_dicom::constructCFindStudyUID Could not open $txtFile\n";
  print TXT "0008 0052 STUDY	// Query Level\n";
  print TXT "0010 0010 #	// Patient Name\n";
  print TXT "0010 0020 #	// Patient ID\n";
  print TXT "0020 000D $studyUID	// Study Instance UID\n";

  close TXT;

  my $cfindFile = "$main::MESA_STORAGE/tmp/cfind.dcm";
  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $txtFile $cfindFile";
  print "$x\n" if ($logLevel >= 3);
  `$x`;
  if ($?) {
    print "Could not execute: $x\n";
    return (1, "");
  }

  return (0, $cfindFile);
}


sub coerceDigitizedDicomObjectAttributes {
  my ($logLevel, $inputLabel, $outputLabel, $mppsLabel, $mwlQueryDirectory) = @_;
  my $this = "coerceImportDicomObjectAttributes";
  my $inputDir  = $main::MESA_STORAGE . "/" . $inputLabel;
  my $outputDir = $main::MESA_STORAGE . "/" . $outputLabel;
  my $mppsDirectory = $main::MESA_STORAGE . "/" . $mppsLabel;
  my $scratchDir = $main::MESA_STORAGE . "/scratch";

  die "mesa_dicom::$this: No MWL Query directory specified.\n" unless (defined $mwlQueryDirectory);
  die "mesa_dicom::$this: No output directory specified.\n" unless (defined $outputDir);
  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::$this: Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::$this: Could not create output directory $outputDir\n";
    return 1;
  }

  if (mesa_utility::delete_directory($logLevel, $scratchDir) != 0) {
    print "mesa_dicom::$this: Could not remove scratch directory $scratchDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $scratchDir) != 0) {
    print "mesa_dicom::$this: Could not create scratch directory $scratchDir\n";
    return 1;
  }

  my $mpps_uid_txt = "$mppsDirectory/mpps_uid.txt";
  open (DELTA, ">$scratchDir/digitized_delta.txt") or die
        "mesa_dicom::$this could not create output file: digitized_delta.txt";
  open(MPPS_HANDLE, "< $mpps_uid_txt") || die "Could not open MPPS UID File: $$mpps_uid_txt";
  my $uid = <MPPS_HANDLE>;
  chomp $uid;
  my $mwlDCM = "$mwlQueryDirectory/msg1_result.dcm";

  my($status, $patientName) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0010");
  ($status, my $patientID) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0020");
  ($status, my $dob) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0010 0030");
  ($status, my $sex) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0010 0040");
  ($status, my $otherPatIdMWL) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 1000");
  ($status, my $accessionNum) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"",  "0008 0050");
  ($status, my $requestedProcedureID) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0040 1001");
  ($status, my $requestedProcedureDesc) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0032 1060");
  ($status, my $scheduledProcedureStepID) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"0040 0100", "0040 0009");
  ($status, my $scheduledProcedureStepDesc) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"0040 0100", "0040 0007");
  #3726: Lynn said it is from mwl, but specification said it is dcm[mwl].
  ($status, my $studyInstUID) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0020 000D");

  print DELTA "0010 0010 $patientName\n";
  print DELTA "0010 0020 $patientID\n";
  print DELTA "0010 0030 $dob\n";
  print DELTA "0010 0040 $sex\n";
  print DELTA "0020 000D $studyInstUID\n"; 

  #Referenced Study Seq from MWL, will merge with Referneced Study Seq from DCM
  my $retValue = "";
  $retValue = getAllReferencedStudySeq($logLevel, $mwlDCM);
  print "Ref Study Seq: $retValue\n" if($logLevel > 3);
  print DELTA "$retValue";


  #accessionNum:
  if($accessionNum eq ""){
    $accessionNum = "#";
  }
  print DELTA "0008 0050 $accessionNum\n";

  #Procedure Code Seq: in Eval Req, should from MWL, but our MWL does not have (0009, 1032)???? But according to IRWF should be from 0032 1064???
  ($status, my $codeValue) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0100");
  ($status, my $codeSchemeDesg) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0102");
  ($status, my $codeMeaning) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0104");
  $codeMeaning = mesa_utility::addQuoteForStringWithBlankSpace($codeMeaning);
  print DELTA "0008 1032(       //Procedure Code Sequence\n";
  print DELTA "  0008 0100 $codeValue //Code Value\n";
  print DELTA "  0008 0102 $codeSchemeDesg // Coding Scheme Designator\n";
  print DELTA "  0008 0104 $codeMeaning //Code Meaning\n";
  print DELTA ")\n";

  #Referenced PPS Sequence:
  #In IRWF, no source. In Evaluation, check seq exist, and SOP Class equals "1.2.840.10008.3.1.2.3.3 and SOP Instance exist.
  print DELTA "0008 1111(       //Referenced PPS Sequence\n";
  print DELTA "  0008 1150 1.2.840.10008.3.1.2.3.3\n";
  print DELTA "  0008 1155 $uid\n";
  print DELTA ")\n";

  close DELTA;

  @inputImages = mesa_get::getDirectoryList($logLevel, $inputDir);
  die "mesa_dicom::$this no input DICOM images found in $inputDir" if (scalar(@inputImages) == 0);

  my $x = scalar(@inputImages);
  print "mesa_dicom::$this: file count: $x\n" if ($logLevel >= 3);

  my $num = 1001;
  foreach $image(@inputImages) {
    open (DELTA, "$scratchDir/digitized_delta.txt") or die "mesa_dicom::$this could not reopen output file: digitized_delta.txt";
    open (DELTAIMG, ">$scratchDir/digitized_delta$num.txt") or die "mesa_dicom::$this could not create output file: digitized_delta$num.txt";
    while ($line = <DELTA>) {
      print DELTAIMG "$line";
    }
    close DELTA;

    $image =  "$inputDir/$image";
    #Other Patient Ids
    print "Processing: $image\n" if ($logLevel >= 3);
    ($status, my $otherPatIdDCM) = mesa_get::getDICOMValue($logLevel, $image,"", "0010 1000");
    my $otherPatId = "";
    if($otherPatIdMWL ne "" && $otherPatIdDCM ne ""){
       $otherPatId = "$otherPatIdMWL\\$otherPatIdDCM";
    }elsif($otherPatIdMWL ne ""){
       $otherPatId = $otherPatIdMWL;
    }elsif($otherPatIdDCM ne ""){
       $otherPatId = $otherPatIdDCM;
    }

    #3726:
    #print "Please use $otherPatIdDCM as other patient id from digitized document in this test case.\n";

    if($otherPatId ne ""){
      print DELTAIMG "0010 1000 $otherPatId\n";
    }else{
       print DELTAIMG "0010 1000 #\n";
    }

    #Referenced Study Seq from DCM
    #As steve and Lynn instructed, no merge. so just get the seq from mwl, not from dcm anymore.
    #$retValue = "";
    #$retValue = getAllReferencedStudySeq($logLevel, $image);
    #print DELTAIMG "$retValue\n";

    ($status, my $mwl_SPSID) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0040 0100", "0040 0009");

    #Request Attributes Sequence. Check for existence only
    print DELTAIMG "0040 0275(  //Request Attributes Sequence\n";
    print DELTAIMG "  0040 1001 $requestedProcedureID\n";
    print DELTAIMG "  0040 0009 $mwl_SPSID\n";
    print DELTAIMG ")\n";

    #3726: Performed Procedure Step ID: Check for existence. so give arbitrary value and do not have to give vendor the value
    ($status, my $ppsId) = mesa_get::getDICOMValue($logLevel, $image, "", "0040 0253");
    if($ppsId eq ""){
        $ppsId = "PPSID1028";
    }
    print DELTAIMG "0040 0253 $ppsId\n";

    #Performed Procedure Step Description: should from dcm, but our sample DCM does have it. Check check for existence. so give arbitrary value
    #($status, my $ppsDesc) = mesa_get::getDICOMValue($logLevel, $image,"", "0040 0254");
    #if($ppsDesc eq ""){
    #    #$ppsDesc = "\\\"PPS Descripton\\\"" ;
    #    print DELTAIMG "0040 0254 \"PPS Description\"\n";
    #}else{
    #    print DELTAIMG "0040 0254 $ppsDesc\n";
    #}

    #Original Attributes Seq
    ($status, my $sorceOfPreviousValue) = mesa_get::getDICOMValue($logLevel, $image,"", "0008 0080");
    $sorceOfPreviousValue = mesa_utility::addQuoteForStringWithBlankSpace($sorceOfPreviousValue);
    
    # according to Lynn, just check existence, value does not matter:
    ($status, $date, $timeMin, $timeSec) = mesa_get::getDateTime($logLevel);
    ($status, my $dcm_accessionNum) = mesa_get::getDICOMValue($logLevel, $image,"",  "0008 0050");
    ($status, $origPatientName) = mesa_get::getDICOMValue($logLevel, $image, "", "0010 0010");
    ($status, $origOtherPatId) = mesa_get::getDICOMValue($logLevel, $image, "", "0010 1000");
    ($status, $origPatID) = mesa_get::getDICOMValue($logLevel, $image, "", "0010 0020");
    ($status, $origDOB) = mesa_get::getDICOMValue($logLevel, $image, "", "0010 0030");

    print DELTAIMG "0400 0561(                                  //Original Attributes Sequence\n";
    print DELTAIMG "  0400 0564  $sorceOfPreviousValue          //Source of Previous Values\n";
    print DELTAIMG "  0400 0562  $date                          //Attribute Modification Datetime\n";
    print DELTAIMG "  0400 0563  MESA_DIGITIZER                  //Modifying System\n";
    print DELTAIMG "  0400 0565  COERCE                         //Reason for the attribute modification\n";
    print DELTAIMG "  0400 0550(                                //Modified attribute sequence\n";
    print DELTAIMG "    0010 0010  $origPatientName             //Original Patient Name\n";
    #3726: check for equal:
    #print "Please use $origPatientName as patient name for the original digitized document\n"; 
    #no requirement to check the following:
    #if($origOtherPatId ne ""){
    #  print DELTAIMG "    0010 1000  $origOtherPatId            //Original Other Pat ID\n";
    #}else{
    #  print DELTAIMG "    0010 1000  #                          //Original Other Pat ID\n";
    #}
    #print DELTAIMG "    0010 0020  $origPatID                   //Original Pat ID\n";
    #print DELTAIMG "    0010 0030  $origDOB                     //Original BirthDate\n";
    #print DELTAIMG "    0008 0050  $dcm_accessionNum            //Accession\n";
    ##Ref Study Seq
    #print DELTAIMG "$retValue";
    
    ##Procedure Code Sequence
    #($status, my $codeValue_dcm) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0100");
    #($status, my $codeSchemeDesg_dcm) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0102");
    #($status, my $codeMeaning_dcm) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0104");
    #print DELTAIMG "    0008 1032(                              //Procedure Code Seq\n";
    #print DELTAIMG "      0008 0100 $codeValue_dcm //Code Value\n";
    #print DELTAIMG "      0008 0102 $codeSchemeDesg_dcm // Coding Scheme Designator\n";
    #print DELTAIMG "      0008 0104 $codeMeaning_dcm //Code Meaning\n";
    #print DELTAIMG "    )\n";
    print DELTAIMG "  )\n"; #//end of 0400 0550
    print DELTAIMG ")\n"; #//end 0400 0561
    
    print DELTAIMG "0018 A001(                          //Contributing Eqt Seq\n";
    print DELTAIMG "  0040 A170(                        //Purpose of Ref Code Seq\n";
    #3726: use DOCD or FILMD?
    print DELTAIMG "    0008 0100 DOCD                 			//Code Value\n";
    print DELTAIMG "    0008 0102 DCM                           	//Coding Scheme Designator\n";
    print DELTAIMG "    0008 0104 \"Document Digitizer Equipment\" 	//Code meaning\n";
    print DELTAIMG "  )\n"; #//end  0040 A170
    print DELTAIMG "  0008 0070 Fakemanufactureer               //Manufacturer\n";
    print DELTAIMG "  0008 0080 MIR                             //Institution Name\n";
    print DELTAIMG "  0008 1010 ERL                             //Station Name\n";
    print DELTAIMG "  0018 A002 20060625                        //Contr Datetime\n";
    print DELTAIMG ")   \n"; #//end 0018 A0001
    close DELTAIMG;

    my $y = "$main::MESA_TARGET/bin/dcm_modify_object -t -T -i $scratchDir/digitized_delta$num.txt $image $outputDir/$num.dcm";
    print "$y\n" if ($logLevel >= 3);
    `$y`;
    die "mesa_dicom::$this could not coerce object" if ($?);
    $num += 1;
  }
  
  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/mpps_crt.txt $outputDir/mpps.crt ";
  
  return 0;
}

## Private functions that are designed to be called only from the
## public functions above.

sub create_mpps_messages_mwl_ncreate {
  my ($logLevel, $inputLabel, $outputLabel, $performedAE, $retrieveAE, $mwlQueryDirectory) = @_;
  my $outputDir = $main::MESA_STORAGE . "/" . $outputLabel;
  my $inputDir  = $main::MESA_STORAGE . "/" . $inputLabel;

  die "mesa_dicom::create_mpps_messages_mwl_ncreate: No MWL Query directory specified.\n" unless (defined $mwlQueryDirectory);
  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_mpps_messages_mwl Could not remove output directory $outputDir\n";
    return 1;
  }

  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::create_mpps_messages_mwl Could not create output directory $outputDir\n";
    return 1;
  }

  open (MPPS_CRT, ">$outputDir/mpps_crt.txt") or die
	"mesa_dicom::create_mpps_messages_mwl could not create output file: $outputDir/mpps_crt.txt";

  @inputImages = mesa_get::getDirectoryList($logLevel, $inputDir);
  die "mesa_dicom::create_mpps_messages_mwl no input DICOM images found in $inputDir" if (scalar(@inputImages) == 0);

  my $x = scalar(@inputImages);
  print "mesa_dicom::create_mpps_messages_mwl file count: $x\n" if ($logLevel >= 3);
  
  my $image = "$inputDir/$inputImages[0]";
  my $mwlDCM = "$mwlQueryDirectory/msg1_result.dcm";
  
  ($status, $patientName) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0010", 0);
  ($status, $patientID) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0020", 0);
  ($status, $dob) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0030", 0);
  ($status, $sex) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0040", 0);
  $patientName = "#" if ($patientName eq "");
  $patientID = "#" if ($patientID eq "");
  $dob = "#" if ($dob eq "");
  $sex = "#" if ($sex eq "");
  print MPPS_CRT "0010 0010 $patientName\n";
  print MPPS_CRT "0010 0020 $patientID\n";
  print MPPS_CRT "0010 0030 $dob\n";
  print MPPS_CRT "0010 0040 $sex\n";
  
  ($status, $acc) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0008 0050", 0);
  ($status, $modality) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "0040 0100", "0008 0060", 0);
  ($status, $studyUID) = mesa_get::getDICOMValue($logLevel, $image, "", "0020 000d", 0);
  
  #get Referenced Study Seqence from MWL.
  ($status, $refStudySeqSopClassUID) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "0008 1110", "0008 1150", 0);
  ($status, $refStudySeqSopInstUID) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "0008 1110", "0008 1155", 0);
  
  ($status, $refStudyID) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0040 1001", 0); 
  $refStudyID = "#" if ($refStudyID eq "");
  
  ($status, my $performedProcedureStepID)   = mesa_get::getIdentifier($logLevel, "mod1", "pps");
  ($status, my $requestedProcedureID)       = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0040 1001");
  ($status, my $requestedProcedureDesc)     = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0032 1060");
  
  ($status, my $scheduledProcedureStepID)   = mesa_get::getDICOMValue($logLevel, $mwlDCM,"0040 0100", "0040 0009");  
  ($status, my $scheduledProcedureStepDesc) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"0040 0100", "0040 0007");
  $scheduledProcedureStepID = "SPSID100" if ($scheduledProcedureStepID eq "");
  $scheduledProcedureStepDesc = "Description" if ($scheduledProcedureStepDesc eq "");
  $scheduledProcedureStepDesc = "\"".$scheduledProcedureStepDesc."\"" if($scheduledProcedureStepDesc =~ /\s+/);
  
  $requestedProcedureDesc = "\"$requestedProcedureDesc\"" if ($requestedProcedureDesc =~ /\s+/);
  
  #Scheduled Protocol Code Sequence
  my $x1 = "$main::MESA_TARGET/bin/dcm_dump_element 0040 0100 $mwlDCM $main::MESA_STORAGE/tmp/mwlDCM_0040_0100.dcm";
  print "Dumping 0040 0100 sequence: $x1\n" if ($logLevel >= 3);
  `$x1`;
  die if $?;
  
  ($status, my $codeValue2) = mesa_get::getDICOMValue($logLevel, "$main::MESA_STORAGE/tmp/mwlDCM_0040_0100.dcm", "0040 0008", "0008 0100");
  ($status, my $codeSchemeDesg2) = mesa_get::getDICOMValue($logLevel, "$main::MESA_STORAGE/tmp/mwlDCM_0040_0100.dcm", "0040 0008", "0008 0102");
  ($status, my $codeMeaning2) = mesa_get::getDICOMValue($logLevel, "$main::MESA_STORAGE/tmp/mwlDCM_0040_0100.dcm", "0040 0008", "0008 0104");
  $codeMeaning2 = "\"".$codeMeaning2."\"" if($codeMeaning2 =~ /\s+/);
  
  #Procedure Code Seq: in Eval Req, should from MWL, but our MWL does not have (0009, 1032)???? But according to IRWF should be from 0032 1064??? 
  ($status, my $codeValue) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0100");
  ($status, my $codeSchemeDesg) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0102");
  ($status, my $codeMeaning) = mesa_get::getDICOMValue($logLevel, $mwlDCM , "0032 1064", "0008 0104");
  #$codeMeaning = "\"".$codeMeaning."\"" if($codeMeaning =~ /\s+/);
  $codeMeaning = mesa_utility::addQuoteForStringWithBlankSpace($codeMeaning);
  print MPPS_CRT "0008 1032(			// Procedure Code Sequence\n";
  print MPPS_CRT "  0008 0100 $codeValue 	// Code Value\n";  
  print MPPS_CRT "  0008 0102 $codeSchemeDesg 	// Coding Scheme Designator\n";
  print MPPS_CRT "  0008 0104 $codeMeaning	// Code Meaning\n";
  print MPPS_CRT ")\n";
  
  print MPPS_CRT "0008 0060 $modality\n";
  #print MPPS_CRT "0008 1120 ####	// Referenced Patient Sequence\n";


  print MPPS_CRT "0020 0010 $refStudyID\n";

  print MPPS_CRT "0040 0241 $performedAE	// Performed Station AE Title\n";
  print MPPS_CRT "0040 0242 #		// Performed Station Name\n";
  print MPPS_CRT "0040 0243 #		// Performed Station Location\n";

  ($status, $date, $timeMin, $timeSec) = mesa_get::getDateTime($logLevel);
  print MPPS_CRT "0040 0244 $date			// PPS Start Date\n";
  print MPPS_CRT "0040 0245 $timeMin			// PPS Start Time\n";
  print MPPS_CRT "0040 0250 #				// PRC PPS End Date \n";
  print MPPS_CRT "0040 0251 #				// PRC PPS End Time \n";
  print MPPS_CRT "0040 0252 \"IN PROGRESS\" 		// MPPS Status \n";
  print MPPS_CRT "0040 0253 $performedProcedureStepID	// PPSID \n";
  print MPPS_CRT "0040 0254 \"PPS Descripton\"		// PRC PPS Description \n";
  print MPPS_CRT "0040 0255 #				// PRC Perf Procedure Type Description \n";
  print MPPS_CRT "0040 0260 (				// Performed Protocol Code Sequence \n";
  print MPPS_CRT "  0008 0100 $codeValue2		// Code Value\n";
  print MPPS_CRT "  0008 0102 $codeSchemeDesg2		// Code Scheme Designator\n";
  print MPPS_CRT "  0008 0104 $codeMeaning2		// Code Meaning\n";
  print MPPS_CRT " )\n";
  print MPPS_CRT "0040 0270 (				// Scheduled Step Attr Seq\n";
  print MPPS_CRT " 0008 0050 $acc			// Accession Number\n";
  print MPPS_CRT " 0008 1110 (				// Referenced Study Sequence\n";
  print MPPS_CRT "  0008 1150 	$refStudySeqSopClassUID // Ref SOP Class\n";
  print MPPS_CRT "  0008 1155 	$refStudySeqSopInstUID  // Ref SOP Instance\n";
  #print MPPS_CRT "  0008 1150 1.2.840.10008.3.1.2.3.1	// Ref SOP Class\n";
  #print MPPS_CRT "  0008 1155 x.x.x.x.x0008.3.1.2.3.1	// Ref SOP Instance\n";
  print MPPS_CRT " )					// End of Referenced Study Seq\n";
  my $retValue = "";
  $retValue = getAllReferencedStudySeq($logLevel, $mwlDCM);
  print MPPS_CRT "$retValue";
  print MPPS_CRT " 0020 000d $studyUID			// Study Instance UID\n";
  print MPPS_CRT " 0032 1060 $requestedProcedureDesc	// Requested Procedure Description\n";
  print MPPS_CRT " 0040 0007 $scheduledProcedureStepDesc	// Scheduled Step Description\n";
  
  #print MPPS_CRT " 0040 0008 ####			// Scheduled Protocol Code Seq\n";
  print MPPS_CRT " 0040 0008(				//Scheduled Protocol Code Seq\n";
  print MPPS_CRT "  0008 0100 $codeValue2 		//Code Value\n";  
  print MPPS_CRT "  0008 0102 $codeSchemeDesg2 		//Coding Scheme Designator\n";
  print MPPS_CRT "  0008 0104 $codeMeaning2 		//Code Meaning\n";
  print MPPS_CRT " )					//End of Scheduled Protocol Code Seq\n";
  
  print MPPS_CRT " 0040 0009 $scheduledProcedureStepID	// SPS ID\n";
  print MPPS_CRT " 0040 1001 $requestedProcedureID	// Requested Procedure ID\n";
  print MPPS_CRT ")					// End of Perf AI Seq\n";
  print MPPS_CRT "0040 0340 ####			// Performed Series Sequence\n";
  #removed because do not know which sequence it should be in.
  #print MPPS_CRT "0008 1150 1.2.840.10008.3.1.2.3.3	// Referenced SOP Class UID\n";
  #print MPPS_CRT "0008 1155 x.x.x.x.x0008.3.1.2.3.2	// Referenced SOP Instance UID\n";
  print MPPS_CRT "0008 1120 ####			// Referenced Patient Sequence\n";
  print MPPS_CRT "0040 0281 ####			// PPS Discontinuation Sequence\n";
  close MPPS_CRT;

  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/mpps_crt.txt $outputDir/mpps.crt ";
  print "$x\n" if ($logLevel >= 3);

  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }
  return 1 if $?;
  return 0;
}

sub create_mpps_messages_mwl_nset {
  my ($logLevel, $inputLabel, $outputLabel, $performedAE, $retrieveAE, $mwlQueryDirectory,
	$exceptionCode) = @_;
  my $outputDir = $main::MESA_STORAGE . "/" . $outputLabel;
  my $inputDir  = $main::MESA_STORAGE . "/" . $inputLabel;

  die "mesa_dicom::create_mpps_messages_mwl_nset: No MWL Query directory specified.\n" unless (defined $mwlQueryDirectory);

  @inputImages = mesa_get::getDirectoryList($logLevel, $inputDir);
  die "mesa_dicom::create_mpps_messages_mwl_nset no input DICOM images found in $inputDir" if (scalar(@inputImages) == 0);

  my $x = scalar(@inputImages);
  print "mesa_dicom::create_mpps_messages_mwl_nset file count: $x\n" if ($logLevel >= 3);
  
  my $image = "$inputDir/$inputImages[0]";
  my $mwlDCM = "$mwlQueryDirectory/msg1_result.dcm";

  # Now, process the MPPS N-Set message
  open (MPPS_SET, ">$outputDir/mpps_set.txt") or die
	"mesa_dicom::create_mpps_messages_mwl_nset could not create output file: $outputDir/mpps_set.txt";
  
  my $image0 = "$inputDir/$inputImages[0]";
  ($status, $seriesInstUID) = mesa_get::getDICOMValue($logLevel, $image0, "", "0020 000e",0);
  
  ($status, $date, $timeMin, $timeSec) = mesa_get::getDateTime($logLevel);
  print MPPS_SET "0040 0250 $date		// PPS End Date\n";
  print MPPS_SET "0040 0251 $timeMin		// PPS End Date\n";
  if ($exceptionCode eq "") {
    print MPPS_SET "0040 0252 COMPLETED	 	// MPPS Status \n";
  } else {
    my $codeMeaning = translateDICOMCode($exceptionCode);
    print MPPS_SET "0040 0252 DISCONTINUED 	// MPPS Status \n";
    print MPPS_SET "0040 0281 (			// PPS Discontinuation Sequence\n";
    print MPPS_SET " 0008 0100 $exceptionCode	// COde Value\n";
    print MPPS_SET " 0008 0102 DCM		// Coding Scheme Designator\n";
    print MPPS_SET " 0008 0104 \"$codeMeaning\"	// Code Meaning\n";
    print MPPS_SET ")\n";
    if ($exceptionCode eq "110514"){
       print MPPS_SET "0040 0254 Importation 	// MPPS Description \n";
    }
  }
  print MPPS_SET "0040 0340 (		// Performed Series Sequence\n";
  print MPPS_SET "  0008 1050 PERFORMING		// Performing Physician\n";
  print MPPS_SET "  0018 1030 IRWF-200		// Protocol Name\n";
  print MPPS_SET "  0008 1070 OPERATOR		// Operator Name\n";
  print MPPS_SET "  0020 000e $seriesInstUID	// Series Instance UID\n";
  print MPPS_SET "  0008 103e SERIES_DES		// Series Description\n";
  print MPPS_SET "  0008 0054 $retrieveAE	// Retrieve AE Title\n";
  my $first = 1;
  foreach $img (@inputImages){ 
    $img = "$inputDir/$img";
    ($status, my $sopClassUID) = mesa_get::getDICOMValue($logLevel, $img, "", "0008 0016");
    ($status, my $sopInstUID) = mesa_get::getDICOMValue($logLevel, $img, "", "0008 0018");
    if($first == 1){
      print MPPS_SET "  0008 1140 (		// Referenced Image Sequence\n";
      $first = 0;
    }else{
      print MPPS_SET "  (		// Referenced Image Sequence\n";
    }
    print MPPS_SET "    0008 1150 $sopClassUID	//Referenced SOP Class UID\n";
    print MPPS_SET "    0008 1155 $sopInstUID	//Referenced SOP Instance UID\n";
    print MPPS_SET "  )\n";
  }
  
  print MPPS_SET ")			// End of Performed Series Sequence\n";
  
  close MPPS_SET;
  
  $x = "$main::MESA_TARGET/bin/dcm_create_object -i $outputDir/mpps_set.txt $outputDir/mpps.set ";
  print "$x\n" if ($logLevel >= 3);

  if ($logLevel >= 3) {
    print `$x`;
  } else {
    `$x`;
  }

  ($status, $mppsUID) = mesa_get::getIdentifier($logLevel, "mod1", "pps_uid");
  if ($status != 0) {
    print "mesa_dicom::create_mpps_messages could not generate new MPPS UID\n";
    return 1;
  }
  open (MPPS_UID, ">$outputDir/mpps_uid.txt") or die
	"mesa_dicom::create_mpps_messages could not create output UID file: $outputDir/mpps_uid.txt";
  print MPPS_UID "$mppsUID\n";
  close MPPS_UID;

  return 1 if $?;

  return 0;
}

sub translateDICOMCode {
  my ($exceptionCode) = @_;

  return "Object Set Incomplete" if ($exceptionCode eq "110523");
  return "Incorrect worklist entry selected" if ($exceptionCode eq "110514");
  return "Unknown code: $exceptionCode";
}

sub acquire12LeadECGWaveform{
  my ($logLevel, $outputLabel,  $mwlQueryDirectory) = @_;
  my $this = "acquire12LeadECGWaveform";
  my $outputDir = $main::MESA_STORAGE . "/" . $outputLabel;
  my $scratchDir = $main::MESA_STORAGE . "/scratch";

  print "Output: $outputDir\n" if ($logLevel >= 3);
  die "mesa_dicom::$this: No output directory specified.\n" unless (defined $outputDir);
  if (mesa_utility::delete_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::$this: Could not remove output directory $outputDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $outputDir) != 0) {
    print "mesa_dicom::$this: Could not create output directory $outputDir\n";
    return 1;
  }

  if (mesa_utility::delete_directory($logLevel, $scratchDir) != 0) {
    print "mesa_dicom::$this: Could not remove scratch directory $scratchDir\n";
    return 1;
  }
  if (mesa_utility::create_directory($logLevel, $scratchDir) != 0) {
    print "mesa_dicom::$this: Could not create scratch directory $scratchDir\n";
    return 1;
  }

  my $mwlDCM = "$mwlQueryDirectory/msg1_result.dcm";
  my($status, $patientName) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0010");
  ($status, my $patientID) = mesa_get::getDICOMValue($logLevel, $mwlDCM, "", "0010 0020");
  ($status, my $dob) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0010 0030");
  ($status, my $sex) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0010 0040");

  ($status, my $accessionNum) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"",  "0008 0050");
  $accessionNum = mesa_utility::checkInput($logLevel,$accessionNum);
  
  ($status, my $studyInstUID) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"", "0020 000d");
  if($studyInstUID eq ""){
    die "mesa_dicom::$this Study Instance UID is empty from MWL\n";
  }
  
  ($status, my $refPhysician) = mesa_get::getDICOMValue($logLevel, $mwlDCM,"",  "0008 0090");
  $refPhysician = mesa_utility::checkInput($logLevel,$refPhysician);  

  ($status, $date, $timeMin, $timeSec) = mesa_get::getDateTime($logLevel);
  
  # Generate Series Instance UID
  my $dbname = "mod1";
  my $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname series_uid";
  my $seriesInstUID= `$x`;

  my %stages = (
    "1", "F-01604\\\"Resting State\"",
    "2", "F-01602\\\"Baseline State\"",
    "3", "F-01606\\\"Exercise State\"",
    "4", "F-01608\\\"Post-exercise State\"",
  );
  my $stage = 1;
  while($stage < 5){
    open (DELTA, ">$scratchDir/delta$stage.txt") or die "mesa_dicom::$this could not create output file: delta$stage.txt";
    print DELTA "//Patient Module\n";
    print DELTA "0010 0010 $patientName\n";
    print DELTA "0010 0020 $patientID\n";
    print DELTA "0010 0030 $dob\n";
    print DELTA "0010 0040 $sex\n";

    print DELTA "//General Study Module\n";
    print DELTA "0020 000D $studyInstUID		//Study Instance UID\n";
    print DELTA "0008 0020 $date			//Study Date\n";
    print DELTA "0008 0030 $timeSec			//Study Time\n";
    print DELTA "0008 0090 $refPhysician		//Referring Physician's Name\n";
    print DELTA "0020 0010 #				//Study ID\n";
    print DELTA "0008 0050 $accessionNum		//Accession Number\n";

    print DELTA "//General Series Module\n";
    print DELTA "0008 0060 ECG			//Modality\n";
    print DELTA "0020 000E $seriesInstUID	//Series Instance UID\n";
    print DELTA "0020 0011 511			//Series Number\n";
    print DELTA "0008 1111 ####			//Referenced Study Component Sequence\n";
    print DELTA "0018 1030 \"User-defined description of the conditions\"            //Protocol Name\n";
    print DELTA "0040 0254 \"PPS description\"	//Performed Procedure Step Description\n";
    print DELTA "0040 0260 (			//Performed Protocol Code Sequence\n";
    print DELTA "  0008 0100 P2-7131C               //Code Value\n";
    print DELTA "  0008 0102 SRT                    //Code Scheme Designator\n";
    print DELTA "  0008 0104 \"Balke Protocol\"          //Code Meaning\n";
    print DELTA ")\n";

    print DELTA "//General Equipment Module\n";
    print DELTA "0008 0070 MIR			//Manufacturer\n";

    print DELTA "//Waveform Identification Module\n";
    print DELTA "0020 0013 $stage		//Instance Number\n";
    print DELTA "0008 0023 $date		//Content Date\n";
    print DELTA "0008 0033 $timeSec		//Content Time\n";
#??    print DELTA "0008 002A $date$timeSec	//Acquisition Datetime\n";
    
    print DELTA "//Waveform Module\n";

    print DELTA "//Acquisition Context Module\n";
    my $curStage = $stages{$stage};
    my @curStage = split /\\/, $curStage;
    print DELTA "0040 0555(\n";
    print DELTA "  0040 A040 CODE		//Value Type\n";
    print DELTA "  0040 A043 (			//Concept Name Code Seq\n";
    print DELTA "    0008 0100 109054		//Code Value\n";
    print DELTA "    0008 0102 DCM		//Code Scheme Designator\n";
    print DELTA "    0008 0104 \"Patient State\"	//Code Meaning\n";
    print DELTA "  )\n";
    print DELTA "  0040 A160 (			//Concept Code Seq\n";
    print DELTA "    0008 0100 $curStage[0]	//Code Value\n";
    print DELTA "    0008 0102 SRT		//Code Scheme Designator\n";
    print DELTA "    0008 0104 $curStage[1]	//Code Meaning\n";
    print DELTA "  )\n";
    print DELTA ")\n";
    print DELTA "(\n";
    print DELTA "  0040 A040 NUMERIC		//Value Type\n";
    print DELTA "  0040 A043 (			//Concept Name Code Seq\n";
    print DELTA "    0008 0100 109055		//Code Value\n";
    print DELTA "    0008 0102 DCM		//Code Scheme Designator\n";
    print DELTA "    0008 0104 \"Protocol Stage\"	//Code Meaning\n";
    print DELTA "  )\n";
    print DELTA "  0040 A30A $stage		//Numeric Value\n";
    print DELTA "  0040 08EA(			//Measurement Units Code Seq\n";
    print DELTA "    0008 0100 stage		//Code Value\n";
    print DELTA "    0008 0102 UCUM		//Code Scheme Designator\n";
    print DELTA "    0008 0104 stage		//Code Meaning\n";
    print DELTA "  )\n";
    print DELTA ")\n";
    
    print DELTA "//SOP Common Module\n";
    # Generate SOP Instance UID
    $dbname = "mod1";
    $x = "$mesa::MESA_TARGET/bin/mesa_identifier $dbname sop_inst_uid";
    my $sopInstUID= `$x`;

    print DELTA "0008 0016 1.2.840.10008.5.1.4.1.1.9.1.1	// SOP Class: 12-Lead ECG Waveform Storage\n";
    print DELTA "0008 0018 $sopInstUID			// SOP Instance UID\n";
    
    close DELTA;
    
    $x = "$main::MESA_TARGET/bin/dcm_create_object -i $scratchDir/delta$stage.txt $outputDir/x$stage.dcm";
    print "$x\n" if ($logLevel >= 3);
    `$x`;
    die "mesa_dicom::$this could not create object" if ($?);
    $stage += 1;
    
  }#end while loop
}

sub processInternalSchedulingRequest{
  my ($logLevel, $selfTest, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $universalServiceID = mesa::getField($hl7Msg, "OBR", "4", "0", "Universal Service ID");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");
  print "This is the MESA scheduling prelude to transaction Rad-4\n";
  print "The MESA tools will now perform scheduling to place SPS on the MESA MWL\n";
  print " The Universal Service ID is $universalServiceID\n";
  print " The Procedure Code  is $procedureCode\n";
  print " The modality should be $modality\n";
  print " The SPS Location should be $SPSLocation\n";
  print " PID: $pid Name: $patientName Code: $procedureCode \n";
  print "Hit <ENTER> when ready (q to quit) --> ";
  my $x = <STDIN>;
  main::goodbye() if ($x =~ /^q/);

  if ($modality ne "MR" && 
      $modality ne "CT" &&
      $modality ne "RT" &&
      $modality ne "HD" &&
      $modality ne "MG" &&
      $modality ne "OP" &&
      $modality ne "US" &&
      $modality ne "ECG") {
    die "Unrecognized modality type for local scheduling: $modality \n";
  }

  $x = "$main::MESA_TARGET/bin/of_schedule -l $SPSLocation -t $scheduledAET -m $modality -s STATION1 ordfil";

  if ($logLevel >= 3) {
    print "$x\n";
    print `$x`;
  } else {
    `$x`;
  }
  if ($?) {
    print "Could not schedule $modality SPS with command: $x\n";
    return 1;
  }
  return 0;
}

sub generateSOPInstances {
  my ($logLevel, $selfTest, $mwlAE, $mwlHost, $mwlPort, $src, $dst, $event, $msg, $outputDir, $inputDir, $SPSCode, $PPSCode, $SPSLocation, $scheduledAET)  = @_;
  print "mesa::generateSOPInstances\n" if ($logLevel >= 3);

  my $hl7Msg = "../../msgs/" . $msg;
  my $pid           = mesa::getField($hl7Msg, "PID", "3", "1", "Patient ID");
  my $patientName   = mesa::getField($hl7Msg, "PID", "5", "0", "Patient Name");
  my $procedureCode = mesa::getField($hl7Msg, "OBR", "4", "1", "Procedure Code");
  my $modality      = mesa::getField($hl7Msg, "OBR", "24", "1", "Service Sector ID");

  my $rtnValue = 0;
  $outputDir = "$main::MESA_STORAGE/modality/$outputDir";

  print "$pid $patientName $procedureCode $modality $outputDir\n" if ($logLevel >= 3);
  print "$mwlAE  $mwlHost  $mwlPort\n" if ($logLevel >= 3);

  print "Removing previous data (if any) in $outputDir\n" if ($logLevel >= 3);
  mesa::delete_directory($logLevel, $outputDir);
  print "Now, create an empty output directory\n" if ($logLevel >= 3);
  mesa::create_directory($logLevel, $outputDir);
  mesa::delete_directory($logLevel, "mwl/results");
  mesa::create_directory($logLevel, "mwl/results");

  if (! (-e "mwl/mwlquery.txt") ) {
    print "The file mwl/mwlquery.txt does not exist; MESA distribution error\n";
    die   "Please log a bug report.";
  }
  `$main::MESA_TARGET/bin/dcm_create_object -i mwl/mwlquery.txt mwl/mwlquery.dcm`;
  die "Unable to create mwl/mwlquery.dcm; runtime problem or permission error." if ($?);

  open PIDFILE, ">pid.txt" or die "Could not open pid.txt to write patient ID";
  print PIDFILE "0010 0020 $pid\n";
  close PIDFILE;

  open MWLOUTPUT, ">mwlquery.out";
  my $x = "$main::MESA_TARGET/bin/mwlquery -a $scheduledAET -c $mwlAE -d pid.txt -f mwl/mwlquery.dcm -o mwl/results $mwlHost $mwlPort";
  print "$x\n" if ($logLevel >= 3);
  print MWLOUTPUT `$x`;
  die "Unable to obtain MWL from $mwlHost at port $mwlPort with AE title $mwlAE" if ($?);

  my $modName = "MESA_MOD";
  $x = "$main::MESA_TARGET/bin/mod_generatestudy -m $modality  -p $pid " .
	" -s $SPSCode -c $PPSCode " .
	" -i $main::MESA_STORAGE/$inputDir -t $outputDir " .
	" -y mwl/results " .
	" -z \"IHE Protocol 1\" ";

  open  STUDYOUT, ">generatestudy.out";
  print STUDYOUT "$x\n";
  print STUDYOUT `$x`;

  if ($?) {
    print "Unable to produce scheduled images.\n";
    print "This is a configuration problem or MESA bug\n";
    print "Please log a bug report; \n";
    print " Run this test with log level 4, capture all output; capture the\n";
    print " file generatestudy.out and include this information in the bug report.\n";
    die;
  }
  return 0;
}

1;

