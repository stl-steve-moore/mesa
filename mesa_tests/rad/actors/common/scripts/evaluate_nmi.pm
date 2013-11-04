#!/usr/local/bin/perl -w

# General package for evaluating NMI data.
package evaluate_tfcte;
#use strict;

use Env;
#require 5.001;

package evaluate_nmi;

sub eval_Cardiac_TOMO {
  my ($logLevel, $path) = @_;

  print main::LOG "CTX: evaluate_nmi::eval_Cardiac_TOMO $path, \n" if ($logLevel >= 3);

  my @attributesNMI = (
	"0054 0022", 1, "0020 0037", "FORMAT", "Detector Info Seq/Image Orientation",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributesNMI)) {
    $errorCount += mesa_evaluate::eval_dicom_att($logLevel, $path, $path,
	$attributesNMI[$idx+0], $attributesNMI[$idx+1], $attributesNMI[$idx+2],
	$attributesNMI[$idx+3], $attributesNMI[$idx+4]);
    $idx += 5;
  }

  my @attributesNMINestedSequence = (
	"0040 0555", "0040 A043", "0008 0100", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0102", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0104", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A168", "0008 0100", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0102", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0104", "FORMAT", "Acq Context Seq/Concept Code Seq",
  );
  $idx = 0;
  while ($idx < scalar(@attributesNMINestedSequence)) {
    $errorCount += mesa_evaluate::eval_dicom_att_sequence($logLevel, $path, $path,
	$attributesNMINestedSequence[$idx+0],
	$attributesNMINestedSequence[$idx+1],
	$attributesNMINestedSequence[$idx+2],
	$attributesNMINestedSequence[$idx+3],
	$attributesNMINestedSequence[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub eval_General_Whole_Body {
  my ($logLevel, $path) = @_;

  print main::LOG "CTX: evaluate_nmi::eval_Whole Body $path, \n" if ($logLevel >= 3);

  my @attributesNMI = (
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributesNMI)) {
    $errorCount += mesa_evaluate::eval_dicom_att($logLevel, $path, $path,
	$attributesNMI[$idx+0], $attributesNMI[$idx+1], $attributesNMI[$idx+2],
	$attributesNMI[$idx+3], $attributesNMI[$idx+4]);
    $idx += 5;
  }

  my @attributesNMINestedSequence = (
	"0054 0022", "0054 0220", "0008 0100", "FORMAT", "Detector Info Seq/View Code Seq",
	"0054 0022", "0054 0220", "0008 0102", "FORMAT", "Detector Info Seq/View Code Seq",
  );
  $idx = 0;
  while ($idx < scalar(@attributesNMINestedSequence)) {
    $errorCount += mesa_evaluate::eval_dicom_att_sequence($logLevel, $path, $path,
	$attributesNMINestedSequence[$idx+0],
	$attributesNMINestedSequence[$idx+1],
	$attributesNMINestedSequence[$idx+2],
	$attributesNMINestedSequence[$idx+3],
	$attributesNMINestedSequence[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub eval_General_TOMO {
  my ($logLevel, $path) = @_;

  print main::LOG "CTX: evaluate_nmi::eval_General_TOMO $path, \n" if ($logLevel >= 3);

  my @attributesNMI = (
	"0054 0022", 1, "0020 0037", "FORMAT", "Image Orientation",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributesNMI)) {
    $errorCount += mesa_evaluate::eval_dicom_att($logLevel, $path, $path,
	$attributesNMI[$idx+0], $attributesNMI[$idx+1], $attributesNMI[$idx+2],
	$attributesNMI[$idx+3], $attributesNMI[$idx+4]);
    $idx += 5;
  }

  my @attributesNMINestedSequence = (
  );
  $idx = 0;
  while ($idx < scalar(@attributesNMINestedSequence)) {
    $errorCount += mesa_evaluate::eval_dicom_att_sequence($logLevel, $path, $path,
	$attributesNMINestedSequence[$idx+0],
	$attributesNMINestedSequence[$idx+1],
	$attributesNMINestedSequence[$idx+2],
	$attributesNMINestedSequence[$idx+3],
	$attributesNMINestedSequence[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub eval_General_Recon_TOMO {
  my ($logLevel, $path) = @_;

  print main::LOG "CTX: evaluate_nmi::eval_General_Recon_TOMO $path, \n" if ($logLevel >= 3);

  my @attributesNMI = (
	"0054 0022", 1, "0020 0032", "FORMAT", "Detector Info Seq/Image Position",
	"0054 0022", 1, "0020 0037", "FORMAT", "Detector Info Seq/Image Orientation",
	"0054 0500", 1, "0010 0008", "FORMAT", "Slice Progression Direction",
	"0018 0088", 1, "0010 0008", "FORMAT", "Spacing Between Slices",
	"0040 0555", "0040 A043", "0008 0100", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0102", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0104", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A168", "0008 0100", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0102", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0104", "FORMAT", "Acq Context Seq/Concept Code Seq",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributesNMI)) {
    $errorCount += mesa_evaluate::eval_dicom_att($logLevel, $path, $path,
	$attributesNMI[$idx+0], $attributesNMI[$idx+1], $attributesNMI[$idx+2],
	$attributesNMI[$idx+3], $attributesNMI[$idx+4]);
    $idx += 5;
  }

  my @attributesNMINestedSequence = (
	"0054 0022", "0054 0220", "0008 0100", "FORMAT", "Detector Info Seq/View Code Seq",
	"0054 0022", "0054 0220", "0008 0102", "FORMAT", "Detector Info Seq/View Code Seq",
  );
  $idx = 0;
  while ($idx < scalar(@attributesNMINestedSequence)) {
    $errorCount += mesa_evaluate::eval_dicom_att_sequence($logLevel, $path, $path,
	$attributesNMINestedSequence[$idx+0],
	$attributesNMINestedSequence[$idx+1],
	$attributesNMINestedSequence[$idx+2],
	$attributesNMINestedSequence[$idx+3],
	$attributesNMINestedSequence[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub eval_Cardiac_Recon_TOMO {
  my ($logLevel, $path) = @_;

  print main::LOG "CTX: evaluate_nmi::eval_Cardiac_Recon_TOMO $path, \n" if ($logLevel >= 3);

  my @attributesNMI = (
	"0054 0022", 1, "0020 0032", "FORMAT", "Detector Info Seq/Image Position",
	"0054 0022", 1, "0020 0037", "FORMAT", "Detector Info Seq/Image Orientation",
	"0054 0500", 1, "9999 9999", "FORMAT", "Slice Progression Seq",
	"",          0, "0018 0088", "FORMAT", "Spacing Between Slices",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributesNMI)) {
    $errorCount += mesa_evaluate::eval_dicom_att($logLevel, $path, $path,
	$attributesNMI[$idx+0], $attributesNMI[$idx+1], $attributesNMI[$idx+2],
	$attributesNMI[$idx+3], $attributesNMI[$idx+4]);
    $idx += 5;
  }

  my @attributesNMINestedSequence = (
	"0054 0022", "0054 0220", "0008 0100", "FORMAT", "Detector Info Seq/View Code Seq",
	"0054 0022", "0054 0220", "0008 0102", "FORMAT", "Detector Info Seq/View Code Seq",
	"0040 0555", "0040 A043", "0008 0100", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0102", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0104", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A168", "0008 0100", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0102", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0104", "FORMAT", "Acq Context Seq/Concept Code Seq",
  );
  $idx = 0;
  while ($idx < scalar(@attributesNMINestedSequence)) {
    $errorCount += mesa_evaluate::eval_dicom_att_sequence($logLevel, $path, $path,
	$attributesNMINestedSequence[$idx+0],
	$attributesNMINestedSequence[$idx+1],
	$attributesNMINestedSequence[$idx+2],
	$attributesNMINestedSequence[$idx+3],
	$attributesNMINestedSequence[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub eval_Cardiac_Gated_TOMO {
  my ($logLevel, $path) = @_;

  print main::LOG "CTX: evaluate_nmi::eval_Cardiac_Gated_TOMO $path, \n" if ($logLevel >= 3);

  my @attributesNMI = (
	"0054 0022", 1, "0020 0037", "FORMAT", "Detector Info Seq/Image Orientation",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributesNMI)) {
    $errorCount += mesa_evaluate::eval_dicom_att($logLevel, $path, $path,
	$attributesNMI[$idx+0], $attributesNMI[$idx+1], $attributesNMI[$idx+2],
	$attributesNMI[$idx+3], $attributesNMI[$idx+4]);
    $idx += 5;
  }

  my @attributesNMINestedSequence = (
	"0040 0555", "0040 A043", "0008 0100", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0102", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0104", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A168", "0008 0100", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0102", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0104", "FORMAT", "Acq Context Seq/Concept Code Seq",
  );
  $idx = 0;
  while ($idx < scalar(@attributesNMINestedSequence)) {
    $errorCount += mesa_evaluate::eval_dicom_att_sequence($logLevel, $path, $path,
	$attributesNMINestedSequence[$idx+0],
	$attributesNMINestedSequence[$idx+1],
	$attributesNMINestedSequence[$idx+2],
	$attributesNMINestedSequence[$idx+3],
	$attributesNMINestedSequence[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}

sub eval_Cardiac_Recon_Gated_TOMO {
  my ($logLevel, $path) = @_;

  print main::LOG "CTX: evaluate_nmi::eval_Cardiac_Recon_Gated_TOMO $path, \n" if ($logLevel >= 3);

  my @attributesNMI = (
	"0054 0022", 1, "0020 0032", "FORMAT", "Detector Info Seq/Image Position",
	"0054 0022", 1, "0020 0037", "FORMAT", "Detector Info Seq/Image Orientation",
	"",          0, "0054 0500", "FORMAT", "Slice Progression Direction",
	"",          0, "0018 0088", "FORMAT", "Spacing Between Slices",
  );

  my $idx = 0;
  my $errorCount = 0;
  while ($idx < scalar(@attributesNMI)) {
    $errorCount += mesa_evaluate::eval_dicom_att($logLevel, $path, $path,
	$attributesNMI[$idx+0], $attributesNMI[$idx+1], $attributesNMI[$idx+2],
	$attributesNMI[$idx+3], $attributesNMI[$idx+4]);
    $idx += 5;
  }

  my @attributesNMINestedSequence = (
	"0054 0222", "0054 0220", "0008 0100", "FORMAT", "Acq Context Seq/View Code Seq",
	"0054 0222", "0054 0220", "0008 0102", "FORMAT", "Acq Context Seq/View Code Seq",
	"0040 0555", "0040 A043", "0008 0100", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0102", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A043", "0008 0104", "FORMAT", "Acq Context Seq/Concept Name Code Seq",
	"0040 0555", "0040 A168", "0008 0100", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0102", "FORMAT", "Acq Context Seq/Concept Code Seq",
	"0040 0555", "0040 A168", "0008 0104", "FORMAT", "Acq Context Seq/Concept Code Seq",
  );
  $idx = 0;
  while ($idx < scalar(@attributesNMINestedSequence)) {
    $errorCount += mesa_evaluate::eval_dicom_att_sequence($logLevel, $path, $path,
	$attributesNMINestedSequence[$idx+0],
	$attributesNMINestedSequence[$idx+1],
	$attributesNMINestedSequence[$idx+2],
	$attributesNMINestedSequence[$idx+3],
	$attributesNMINestedSequence[$idx+4]);
    $idx += 5;
  }
  return $errorCount;
}


1;
