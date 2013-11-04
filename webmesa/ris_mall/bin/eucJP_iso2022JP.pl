#!/usr/bin/perl -w

use Encode 'from_to';
use Encode::JP;

sub fromTo {
	$euc_jp_nam = shift;
	from_to($euc_jp_nam, 'euc_jp', 'iso-2022-jp');
	print $euc_jp_nam;
	#return ($euc_jp_nam);
}

## Main starts here
$euc_jp_nam = $ARGV[0];
fromTo($euc_jp_nam);
exit;
