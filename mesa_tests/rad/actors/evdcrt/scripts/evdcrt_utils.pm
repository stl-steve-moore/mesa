#!/usr/local/bin/perl -w

sub produce_scheduled_images {
    my $mwlResultsDir = "1701/results/mwl";
    my $mwlDataDir = "1701/data/mwl";

    my ($modality, $modalityAE, $patientID, $procedureCode, $testName, $mwlAE,
            $mwlHost, $mwlPort, $scheduledCode, $performedCode, $inputDirectory) = @_; 
#    my $modalityAE = shift or die "Modality AE not supplied";
#    my $patientID = shift or die "Patient ID not supplied";
#    my $testName = shift or die "Test Name not supplied";
#    my $mwlAE = shift or die "Modality Worklist AE not supplied";
#    my $mwlHost = shift or die "Modality Worklist Host not supplied";
#    my $mwlPort = shift or die "Modality Worklist Port not supplied";

    my $outputDirectory = "$MESA_STORAGE/modality/$testName";

    print "Cleaning $outputDirectory\n" if $main::logLevel > 2;
    mesa::delete_directory(1, $outputDirectory);
    mesa::create_directory(1, $outputDirectory);

    print "Clear the $mwlResultsDir directory \n" if $main::logLevel > 2;
    mesa::delete_directory(1, "$mwlResultsDir");
    mesa::create_directory(1, "$mwlResultsDir");

    print "Creating MWL query to retrieve worklist \n" if $main::logLevel > 2;
    if (! (-e "$mwlDataDir/mwlquery.txt") ) {
        die "The file $mwlDataDir/mwlquery.txt does not exist.  Installation error. \n";
    }

    my $x = "$MESA_TARGET/bin/dcm_create_object -i $mwlDataDir/mwlquery.txt " .
        "$mwlResultsDir/mwlquery.dcm";
    if ($MESA_OS eq "WINDOWS_NT") {
        $x =~ s(\/)(\\)g;
    }
    print "$x \n";
    `$x`;
    if ($? != 0) {
        die "Unable to create $mwlResultsDir/mwlquery.dcm.  Permission or other problem. \n";
    }

    open PIDFILE, ">$mwlResultsDir/pid.txt" or 
        die "Could not open $mwlResultsDir/pid.txt to write patient ID \n";
    print PIDFILE "0010 0020 $patientID \n";
    close PIDFILE;

    open MWLOUTPUT, ">$mwlResultsDir/mwlquery.out";

    $x = "$MESA_TARGET/bin/mwlquery -a $modalityAE -c $mwlAE -d $mwlResultsDir/pid.txt " .
        " -f $mwlResultsDir/mwlquery.dcm -o $mwlResultsDir $mwlHost $mwlPort";

    if ($MESA_OS eq "WINDOWS_NT") {
        $x =~ s(\/)(\\)g;
    }
    print "$x";
    print MWLOUTPUT `$x`;
    if ($?) {
        die "Unable to obtain MWL from $mwlHost at port $mwlPort with AE title $mwlAE \n";
    }

    close MWLOUTPUT;

###
    my $xStatement = "$MESA_TARGET/bin/mod_generatestudy -m $modality -p $patientID " .
        " -s $scheduledCode -c $performedCode " .
        " -i $MESA_STORAGE/modality/$inputDirectory " .
        " -t $outputDirectory " .
       " -y $mwlResultsDir " .
        " -z \"IHE Protocol 1\" ";

    if ($MESA_OS eq "WINDOWS_NT") {
       $xStatement =~ s(\/)(\\)g;
  }
    print "$xStatement \n" if $main::logLevel > 2;

    open STUDYOUT, ">$mwlResultsDir/generatestudy.out";
    print STUDYOUT "$xStatement \n";
    print STUDYOUT `$xStatement`;

    if ($?) {
        die "Unable to create images/PPS from MWL.  ".
            "Look in $mwlResultsDir/generatestudy.out \n";
    }
}

#usage make_mpps_from_template(imageFile, template, outputFile[, verbose])
# This subroutine takes various tags from an image file and creates an mpps file
# out of them.  The tags to take are specified in the $template parameter (new-line 
# delimted); for more information on the format of this text, see the comments for
# mesa::create_object_from_template
sub make_mpps_from_template {
    my $imageFile = shift or die "Image filename not given.\n";
    my $template = shift or die "Template text not given.\n";
    my $outFile = shift or die "Output filename not given.\n";
    my $verbose;
    $verbose = shift or $verbose = 0;

    eval {
        $template = mesa::add_object_elements_to_template($template, $imageFile, $verbose);
        mesa::create_object_from_template($template, $outFile, $verbose);
    };
    warn $@ if $@;
}


# usage: add_elements_to_object(inputFile, outputFile, elements)
#
# add the elements specified by the scalar string elements to the inputFile, and 
# write the results to outputFile.
sub add_elements_to_object {
    my $inputFile = shift or die "input file not specified.\n";
    my $outputFile = shift or die "output file not specified.\n";
    my $elements = shift or die "elements not specified.\n";

    my $cmd = "$main::MESA_TARGET/bin/dcm_modify_object $inputFile $outputFile";
# dcm_modify_object will take input from STDIN
    open (MODIFY, "| $cmd ") or die "Cannot execute $cmd";

    print "INPUT INTO \"$cmd\":\n" if $verbose; 
    print MODIFY $elements; 
    close MODIFY or die "Error in dcm_modify_object: $!\n";
}

1;
