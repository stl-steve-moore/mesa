#!/usr/bin/perl
use Env;
$dirName = "$MESA_STORAGE\\modality";
print("which image folder under modality?");
$study=<STDIN>;
chomp($study);
$processDir="$dirName\\$study";

print("What is the result file name?");
$resName = <STDIN>;
chomp($resName);
$resName = "$resName.res";
open(FILE, ">".$resName) || die ("can not open the file ".$resName.".res: $i");
processDirectory($processDir);
close(FILE);
chdir("tmp") || die("can not change directory");
unlink <*.*>;


sub processFile{
	my($f) = @_[0];
	#local($command) = "dvtcmd c:\\mesa\\validation\\validation.ses ".$f;
	local($command) = "dvtcmd validation.ses ".$f;
	$valRes = `$command`;
	print FILE ("############################################################################\n");
	print FILE ("##################Start validating $f ##################\n"."$valRes\n");
}

sub processDirectory{
	my($dirName) = @_[0];
	opendir(DIR, $dirName) || die("Cannot open directory $dirName!");
	local(@files) = readdir(DIR);
	closedir(DIR) || die("Cannot close directory $dirName!");
	foreach $f (@files) {
		unless(($f eq ".") || ($f eq "..")){
			if(-d $dirName."\\".$f){
				processDirectory($dirName."\\".$f);
			}else{
				if($f =~ /.dcm\b/){ 
					processFile($dirName."\\".$f);
				}
			}
		}
	}
}
