#!/usr/bin/perl
use File::Find;

my %modality = (
#        CR => "/opt/mesa/storage/modality/CR",
        CT => "/opt/mesa/storage/modality/CT",
#        MR => "/opt/mesa/storage/modality/MR",
#        NM => "/opt/mesa/storage/modality/NM",
);

# Change this accordingly 
$DELTA_DIR = "/home/ssurul01/REP/mesa/scripts/mesa_storage_repair/delta";

for my $key (sort keys %modality) {
        find(\&edits, $modality{$key});
}

sub edits() {
        return unless (-f and /\d+\.dcm$/);
		m/(.*)IM\d+\.dcm/;
		$deltaFileName = $DELTA_DIR."/"."delta_".$1.".txt";
		m/(.*)\.dcm/;
		$fixedDCMName = $1."_fixed.dcm";
		if (/CT1S1/) {
			#print $File::Find::name."\t".$deltaFileName."\n";
			die unless (-e $deltaFileName);
			print `/opt/mesa/bin/dcm_modify_object -i $deltaFileName $File::Find::name /tmp/x.dcm`
				or print "Couldn't run dcm_modify_object: $!\n";
			print `/opt/mesa/bin/dcm_rm_element 0020 0020 /tmp/x.dcm /tmp/y.dcm` 
				or print "Couldn't run dcm_rm_element: $!\n";
			print `/opt/mesa/bin/dcm_ctnto10 /tmp/y.dcm $fixedDCMName`
				or print "Couldn't run dcm_ctnto10: $!\n";
		}
}
