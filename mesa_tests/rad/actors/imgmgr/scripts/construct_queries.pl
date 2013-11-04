#!/usr/local/bin/perl

use Env;

print "This script is now retired.  The individual test scripts \n " .
 " make their own queries.\n";
exit 1;


$cmd = "$MESA_TARGET/bin/dcm_create_object";

@queries = (#"q103a",
            #"q104a",
            #"q105a",
            #"q401a", "q401b", "q401c", "q401d", "q401e", "q401f",
            #"q402a", "q402b",
            "q404a", "q404b",
            "q411a", "q411b",
	);
            #"q412a", "q412b",

foreach $q (@queries) {
    # pull the dir name out of the query name.
    $dir = $q;
    if( $dir =~ /(\d+)/ ) { $dir = $1; }

    # build the command line.
    $x = "$cmd" . " -i ${dir}/${q}.txt ${dir}/${q}.dcm";

    # do separator substitution if we're on NT.
    if($MESA_OS eq "WINDOWS_NT") {
        $x =~ s(/)(\\)g;
    }

    # announce what we're doing then do it.
    print "$x\n";
    print `$x`;
}

