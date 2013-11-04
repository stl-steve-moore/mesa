#!/bin/perl
use Env;

my $x = "perl 2220/eval_2220.pl 4 $MESA_STORAGE/modality/NM/gen_static/NMGS001";
print `$x`;

#$x = "perl 2221/eval_2221.pl 4 $MESA_STORAGE/modality/NM/gen_dynamic/NMGD001";
#print `$x`;

#$x = "perl 2222/eval_2222.pl 4 $MESA_STORAGE/modality/NM/gen_whole_body/NMGWB001";
#print `$x`;

$x = "perl 2223/eval_2223.pl 4 $MESA_STORAGE/modality/NM/gen_gated/NMGG001";
print `$x`;

#$x = "perl 2224/eval_2224.pl 4 $MESA_STORAGE/modality/NM/gen_tomo/NMGT001";
#print `$x`;

#$x = "perl 2225/eval_2225.pl 4 $MESA_STORAGE/modality/NM/gen_recon_tomo/NMGRT001";
#print `$x`;

$x = "perl 2230/eval_2230.pl 4 $MESA_STORAGE/modality/NM/card_tomo/NMCT001";
print `$x`;

$x = "perl 2231/eval_2231.pl 4 $MESA_STORAGE/modality/NM/card_recon_tomo/NMCRT001";
print `$x`;

$x = "perl 2232/eval_2232.pl 4 $MESA_STORAGE/modality/NM/card_gated_tomo/NMCGT001";
print `$x`;

#$x = "perl 2233/eval_2233.pl 4 $MESA_STORAGE/modality/NM/card_recon_gated_tomo/NMCRGT001";
#print `$x`;


