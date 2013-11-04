#!/usr/bin/perl
use File::Find;

my $file_to_write = "dciodvfy.txt";

my %modality = (
	CR => "/opt/mesa/storage/modality/CR",
	CT => "/opt/mesa/storage/modality/CT",
	MR => "/opt/mesa/storage/modality/MR",
	NM => "/opt/mesa/storage/modality/NM",
);

for my $key (sort keys %modality) {
	find(\&edits, $modality{$key});
}

sub edits() {
	#-d and print "$_\n";
	return unless (-f and /\.dcm$/);
	#print "File: $File::Find::name\n";
	push @files, $File::Find::name;
}

foreach (sort @files) { 
	print "$_\n";
	$length = length($_);
	for ($i=1; $i<=$length; $i++) { print "="; }
	print "\n";
	print `/usr/local/bin/dciodvfy $_`;
	for ($i=1; $i<=$length; $i++) { print "^v"; }
	print "\n\n";
} 
