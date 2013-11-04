#!/usr/local/bin/perl -w

# General package for MESA scripts.  This file contains common transaction scripts. 

use Env;
package mesa;

# Subroutines found in this module
# createT20MPPS 


# usage: createT20MPPS(imageFile, EDFile, templateFile, mppsFile[, verbose])
# creates an mpps appropriate for transaction 20 (NCreate) from data in imageFile
# and EDFile, as defined in the templateFile.  MPPS object written to
# mppsFile.  Verbose is a boolean flag (1 or 0) which can be used to debug
# the creation of the objects from templates.
sub createT20MPPS {
    my $imageFile = shift or die "Image File not specified.";
    my $EDFile = shift or die "SR File not specified.";
    my $templateFile = shift or die "Template File not specified.";
    my $mppsFile = shift or die "MPPS output file not specified.";
    my $verbose = shift or $verbose = 0;

# get the current time and date.
# -- this is no longer done -- these come from the study time, which is read
# from the image.  Change reflected in T20MPPS.txt
#    my ($sec, $min, $hours, $mday, $month, $year) = localtime;
#    my $startDate = sprintf "%4d%02d%02d", (1900+$year, $month+1, $mday);
#    my $startTime = sprintf "%02d%02d%02d", ($hours, $min, $sec);
#
#    my @elements = split "\n", <<ELEMENTS;
#0040 0244, $startDate                    // Performed Procedure Step Start Date
#0040 0245, $startTime                    // Performed Procedure Step Start Time
#ELEMENTS

# The template file needs to be modified before it can be processed.  Tag values 
# from two different objects -- the image and the report -- need to be added to it.
# The template identifies which elements need to come from which object.  We will
# modify these templates to make them recognizable to the mesa::add_object_elements_to_template
# subroutine and call it once for the image and once for the report.

    my $template = mesa::read_template($templateFile);
# There are two types of tags which need to be replaced: <IMG ...> and <SR ...>.
# These are replaced by values in the image and report files, respectively.
# The first step is to change all the <IMG ...> tags to <...>, and the <SR ...>
# to {SR ...} so they are not touched.
    $template =~ s/<IMG (.+)>/<$1>/g;
    $template =~ s/<SR (.+)>/\{SR $1\}/g;
    die "$imageFile not found\n" if not -e $imageFile;
# fill in tags from imageFile
    $template = mesa::add_object_elements_to_template($template, $imageFile, $verbose);

# Now change the tags of the form {SR ...} to <...>
    $template =~ s/\{SR (.+)\}/<$1>/g;
    die "$EDFile not found\n" if not -e $EDFile;
# fill in tags from SR file
    $template = mesa::add_object_elements_to_template($template, $EDFile, $verbose);

# Finally, add the elements in the @elements array to the template
    $template = mesa::template_add_elements($template, @elements); 

    mesa::create_object_from_template($template, $mppsFile, $verbose);
}

# usage: createT21MPPS(templateFile, mppsFile[, verbose])
# creates an mpps appropriate for transaction 21 (NSet) 
# as defined in the templateFile.  MPPS object written to
# mppsFile.  Verbose is a boolean flag (1 or 0) which can be used to debug
# the creation of the objects from templates.
sub createT21MPPS {
    my $templateFile = shift or die "Template File not specified.";
    my $mppsFile = shift or die "MPPS output file not specified.";
    my $verbose = shift or $verbose = 0;

    my ($sec, $min, $hours, $mday, $month, $year) = localtime;
    my $endDate = sprintf "%4d%02d%02d", (1900+$year, $month+1, $mday);
    my $endTime = sprintf "%02d%02d%02d", ($hours, $min, $sec);

    my @elements = split "\n", <<ELEMENTS;
0040 0250, $endDate                      // Performed Procedure Step End Date
0040 0251, $endTime                      // Performed Procedure Step End Time
ELEMENTS

    my $template = mesa::read_template($templateFile);

# Add the elements in the @elements array to the template
    $template = mesa::template_add_elements($template, @elements); 

    mesa::create_object_from_template($template, $mppsFile, $verbose);
}

# usage: createT43EvDoc(edFile, imageFile, mpps_uid, newEdFile)
# creates an Evidence Document based on a given evidence document (edFile),
# with information from a given image (imageFile).  The mpps UID which was
# used in Transaction 20 (and later, in Transaction 21) must be passed
# The new Evidence Document is written to newEdFile.
sub createT43EvDoc {
    my $edFile = shift or die "Existing Evidence Document file not specified.";
    my $imageFile = shift or die "Image file not specified.";
    my $mpps_uid = shift or die "MPPS UID not specified.";
    my $newEdFile = shift or die "New Evidence Docuement filename not specified.";

# modify the evidence document object so it contains the 1) study instance UID from images,
# 2) SOP Class UID and 3) SOP Instance UID from the MPPS.  Also add demographic info
# from the image and a unique Study UID
    my $MPPS_SOPClassUID = "1.2.840.10008.3.1.2.3.3";
    my $BasicTextSR_SOPClassUID = "1.2.840.10008.5.1.4.1.1.88.11";
    my $cmd = "$main::MESA_TARGET/bin/mesa_identifier mod1 sop_inst_uid";
    my $SR_SOPInstanceUID =  `$cmd`;
    die "Could not obtain SOP Instance UID.  The following failed:\n\t$cmd\n" if ($?);

    $cmd = "$main::MESA_TARGET/bin/mesa_identifier mod1 series_uid";
    my $seriesUID = `$cmd`;
    die "Could not obtain Series UID.  The following failed:\n\t$cmd\n" if ($?);

    my $elements = <<ELEMENTS;
0008 0016 $BasicTextSR_SOPClassUID        // SOP Class UID
0008 0018 $SR_SOPInstanceUID              // SOP Instance UID
0020 000D <0020.000D>
0020 000E $seriesUID
0008 1111 (
  0008 1150 $MPPS_SOPClassUID             // Referenced SOP Class UID
  0008 1155 $mpps_uid                     // Referenced SOP Instance UID
)
0010 0010 <0010.0010>
0010 0020 <0010.0020>
0010 0030 <0010.0030>
0010 0040 <0010.0040>
ELEMENTS

    $elements = mesa::add_object_elements_to_template($elements, $imageFile);
    mesa::add_elements_to_object($edFile, $newEdFile, $elements);
}

# creates NAction and NEvent objects for use in Transaction 10
# usage: createT10Objects(EDFile, NActionFilename, NEventFilename[, verbose])
#
# EDFile is the evidence document file created in T43 which has been stored
# NActionFilename is the file to which the NAction object will be written
# NEventFilename is the file to which the NEvent object will be written
# The optional parameter verbose will turn on verbosity if != 0
sub createT10Objects {
    my $EDFile = shift or die "Evidence Document not specified";
    my $NActionFilename = shift or die "NAction filename not specified";
    my $NEventFilename = shift or die "NEvent filename not specified";
    my $verbose = shift or $verbose = 0;

    my $cmd = "$main::MESA_TARGET/bin/mesa_identifier mod1 transact_uid";
    my $TransactionUID = `$cmd`;
    die "Could not obtain Transaction Instance UID.  The following failed:\n\t$cmd\n" if ($?);

# See PS 3.4-2001 J.4 for reference
# NACTION Dataset
    my $template = <<TEMPLATE;
0008 1195 $TransactionUID           // Transaction UID
0008 0054 <0008.0054 T2>            // Retrieve AE Title
0008 1199 (                         // Referenced SOP Sequence
   0008 1150 <0008.0016>            // Referenced SOP Class UID
   0008 1155 <0008.0018>            // Referenced SOP Instance UID
)
TEMPLATE

# The following elements are type 1C for the NACTION object.  In order to
# make NAction be the same as NEvent, they are removed.  Currently, the
# same Dataset can be used for NAction and NEvent.
#0008 1111 (                         // Referenced Study Component Sequence
#   0008 1150 <0008.0016>            // Referenced SOP Class UID
#   0008 1155 <0008.0016>            // Referenced SOP Instance UID
#)

    $template = mesa::add_object_elements_to_template($template, $EDFile, $verbose);
    mesa::create_object_from_template($template, $NActionFilename, $verbose);

# Now construct the response (PS 3.4 J.4.3)
# The Transaction UID is the same as above.

# NEVENT Dataset
    $template = <<TEMPLATE;
0008 1195 $TransactionUID           // Transaction UID
0008 0054 <0008.0054 T3>            // Retrieve AE Title
0008 1199 (                         // Referenced SOP Sequence
   0008 1150 <0008.0016>            // Referenced SOP Class UID
   0008 1155 <0008.0018>            // Referenced SOP Instance UID
)
TEMPLATE
    $template = mesa::add_object_elements_to_template($template, $EDFile, $verbose);
    mesa::create_object_from_template($template, $NEventFilename, $verbose);
}



# the following functions are utility functions used above for reading 
# and manipulating template files.
# Please note that the template_add_elements file requires a comma-delimited
# list of tag, value pairs, whereas the add_elements_to_object does
# not have the commas (output as to dcm_create_object)

# usage: template_add_elements($templateText, @elements)
# adds given elements to template text.  Template text is text as input to
# dcm_create_object with newlines delimiting lines.
# @elements is an array of element objects, each of form "TAG, VALUE"
# Lines in $templateText which match the TAG are replaced with VALUE.
# If no matching tags exist, they are added.
# Modified template text is returned.
sub template_add_elements {
    my $templateText = (shift @_) . "\n";
    my @elements = @_;

# Change the elements we want to change or add them if they don't exist.
    foreach my $e (@elements) {
        my ($tag, $value) = split ",", $e;
        $value =~ s/^\s+//;  # remove preceding spaces
        if ($templateText =~ /$tag/) {
# Replacing existing element
            $templateText =~ s/$tag.*\n/$tag $value\n/;
        } else {
# Adding new element
            $templateText = $templateText . "$tag\t$value\n";
        }
    }
    return $templateText;
}

# usage read_template(templateFilename)
# reads an entire template (or any other text file) in its entirety
# and returns it.  Dies on error.
sub read_template {
    my $filename = shift or die "Filename not supplied.";
    my $saveDelim = $/;
    undef $/;
    open (TEMPLATE, "< $filename") or die "Cannot open $filename: $!\n";
    $template = <TEMPLATE>;
    close TEMPLATE;
    $/ = $saveDelim;
    return $template;
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


# usage create_dcm(templateFile, outDir, outFile, @elements)
# elements must be of form, "TAG, VALUE"
# the outDir will be cleaned and created if necessary 
# if templateFile = "", no template will be used.
sub create_dcm {
    my ($templateFile, $outDir, $outFile, @elements) = @_;

    mesa::delete_directory($main::logLevel, $outDir);
    mesa::create_directory($main::logLevel, $outDir);

# read in the entire template file
    my $template = "";
    if (not $templateFile eq "") {
        $template = mesa::read_template($templateFile); 
    }
    print "create_dcm: template = $template\n" if $main::logLevel >= 3;
    print "create_dcm: elements = @elements\n" if $main::logLevel >= 3;
    $template = mesa::template_add_elements($template, @elements); 

    print "Writing object to $outFile: \n$template" if $main::logLevel >= 2;

    my $cmd = "$main::MESA_TARGET/bin/dcm_create_object";
# dcm_create_object will take input from STDIN
    open (CREATE, "| $cmd $outDir/$outFile");

    print CREATE $template; 
    close CREATE;
}

1;
