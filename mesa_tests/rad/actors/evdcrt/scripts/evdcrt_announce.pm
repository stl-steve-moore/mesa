#!/usr/local/bin/perl -w

sub hit_enter_when_ready {
    print "Hit <ENTER> when ready (q to quit) --> ";
    my $x = <STDIN>;
    goodbye if ($x =~ /^q/);
}

sub announce_T8 {
    my ($src, $dst, $event, $inputDir) = @_;

    print "IHE Transaction 8: \n";
    if ($main::selfTest) {
        print "MESA will send images from dir ($inputDir) for event ($event) to your $dst\n";
    } else {
        print "Production Test Message\n";
    }

    hit_enter_when_ready();
}

sub announce_T10 {
    my ($src, $dst, $event, $inputDir) = @_;

    print "IHE Transaction 10: \n";
    if ($main::selfTest) {
        print "MESA will send storage commitment\n";
    } else {
        print "Production Test Message\n";
    }

    hit_enter_when_ready();
}

sub announce_T14 {
# writes the cfind response to the directory given by $outDir.  
# NOTE!  the $outDir is hard-coded below!!!
    my ($src, $dst, $event, $inputParam, $inDir, $outDir) = @_;

    print "IHE Transaction 14: \n";
    if ($main::selfTest) {
        print "MESA will send CFIND message for event $event to your $dst\n";
    } else {
        print "Production Test Message\n";
    }

    hit_enter_when_ready();
}

sub announce_T16 {
    my ($src, $dst, $event, $inputParam, $inDir, $outDir) = @_;

    print "IHE Transaction 16: \n";
    if ($main::selfTest) {
        print "MESA will send CMOVE message for event $event to your $dst\n";
    } else {
        print "Production Test Message\n";
    }

    hit_enter_when_ready();
}

sub announce_T20 {
    my ($src, $dst, $event, $inputDir) = @_;

    print "IHE Transaction 20: \n";
    if ($main::selfTest) {
        print "MESA will send MPPS message from dir ($inputDir) for event ($event) to your ($dst)\n";
    } else {
        print "Production Test Message\n";
    }

    hit_enter_when_ready();
}

sub announce_T21 {
    my ($src, $dst, $event, $inputDir) = @_;

    print "IHE Transaction 21: \n";
    if ($main::selfTest) {
        print "MESA will send MPPS message from dir ($inputDir) for event " .
            "($event) to your ($dst)\n";
    } else {
        print "Production Test Message\n";
    }

    hit_enter_when_ready();
}

sub announce_T43 {
    my ($src, $dst, $event, $inputParam, $srFile, $outDir) = @_;

    print "IHE Transaction 43: \n";
    if ($main::selfTest) {
        print "MESA will store evidence document $srFile \n";
    } else {
        print "Production Test Message\n";
    }

    hit_enter_when_ready();
}

1;
