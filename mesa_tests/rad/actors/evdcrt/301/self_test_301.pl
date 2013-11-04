#!/usr/local/bin/perl -w

# Creates MWL and comparison data for Modality 2xx tests.

use Env;
use File::Copy;
use lib "../../../common/scripts";
require mesa_common;

 my $x = mesa_dicom::create_storage_commitment(1, 1, "VERB",
	"$MESA_STORAGE/modality/CR/CR1/CR1S1",
	"$MESA_STORAGE/modality/T301");

 die "Could not create Storage Commitment file\n" if ($x != 0);

 $x = mesa_xmit::sendCStoreDirectory(1, "",
	"$MESA_STORAGE/modality/CR/CR1/CR1S1",
	"MESA_SCU", "MESA_SCP", "localhost", 2350, 0);

 die "Could not send Image file\n" if ($x != 0);

 $x = mesa_xmit::sendStorageCommitNAction(1,
	"$MESA_STORAGE/modality/T301/naction.dcm",
	"MESA_SCU", "MESA_SCP", "localhost", 2350);

 die "Could not send Storage Commitment file\n" if ($x != 0);


 print "x\n";
