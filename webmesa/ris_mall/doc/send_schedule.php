<?php
    require "global.inc";
    $source = $_GET["source"];
    $next = $_GET["next"];
    $printSource = $actor{$source};
    $actorLink = $actor_link{$source};
    $successLink = $send_schedule_link{$source};
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: <a href=\"$actorLink\">$printSource</a>:: Send a Scheduling Message";
    $title_no_link = "MESA RIS Mall:: ". $printSource . " :: Send a Scheduling Message";
    $header = "MESA RIS Mall";

    $nativedb = "webof";
    require "common_functions.inc";

    if (!empty($_POST["cancel"])) {
        header("Location:$actorLink");
    }

    check_user_is_logged_in();
    global $mwlList;
?>

<html>
<head>
  <title><?=$title_no_link?></title>
  <link href="include/general.css" type="text/css" rel="Stylesheet" rev="Stylesheet" media="all">
</head>
<body>

<?php 
    print_header($header);

# process_form tells us later if this form is ready to be processed.
# first confirm all the info is here.
    $process_form = false;
	$mwlList = getMWLList($_POST["mwl_key"], $nativedb);
    $submit = $_POST["submit"];
    if ($submit == "Send Message") {
        if (empty($_POST["mwl_key"])) {
            print_user_error("Please select SPS."); 
        } else {
            $process_form = true;
        }
    }

	if ($submit == "Search Patients") {
        $lName = $_POST["last_name"];
        if (empty($lName)) {
            print_user_error("Please enter few letters from Patient's last name.");
        } else {
            $lName = strtoupper($lName);
            list ($rows, $mwlList) = getMWLListByLname($lName, $_POST["mwl_key"], $nativedb);
            if ($rows == 0) {
                print_user_error($mwlList);
                $mwlList = getMWLList($_POST["mwl_key"], $nativedb);
            }
        }
    }

if ($process_form) {
    $message = "o01-sched";

    $mwl_key = rtrim($_POST["mwl_key"]);
    $tmpdir = "$risMallRoot/tmp";
    $dest_id = rtrim($_POST["dest_id"]); 
    $template = "$mesaTarget/templates/hl7/$message.tpl";
    $outputFile = $tmpdir."/$message.hl7";
    $verbose = $_POST["verbose"];
    $vflag = $verbose ? "-v" : "";
    $noSend = !empty($_POST["noSend"]); 

    $bin = "$mesaTarget/bin/mesa_construct_hl7.pl";
    $cmd = "perl $bin $vflag -t $tmpdir -M $mwl_key " .
        "$message $template $nativedb $dest_id $outputFile";
    
    execute_piped_command($cmd, $verbose);

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose, $title, $source, $successLink);

    logSendSchedule($dest_id, $mwl_key, $nativedb, !$noSend);
} else {

?>

<form action="<?php $PHP_SELF;?>" method="post">
    <table width="820" bgcolor="FFF8CE" border="0" cellspacing="2" cellpadding="2">
        <tr>
            <td bgcolor="#FFD557" colspan="3">
            <?php print_top_nav($title); ?>
            </td>
        </tr>
		<tr>
            <td colspan="3"><b><u>Search for Patients:</u></b></td>
        </tr>
        <tr>
            <td align="left" valign="top">Patient's lastname begins with </td>
            <td width="5">&nbsp;</td>
            <td align=left valign="top"><input type=text name="last_name" value="<?=$_POST["last_name"]?>">  </td>
        </tr>
        <tr>
            <td align="left">&nbsp;</td>
            <td width="5">&nbsp;</td>
            <td align=left><input type="submit" name="submit" value="Search Patients"></td>
        </tr>
        <tr>
            <td colspan="3">&nbsp;</td>
        </tr>
        <tr>
            <td align="left" valign="top">Please select SPS</td>
			<td width="5">&nbsp;</td>
            <td align=left>
			<?= $mwlList ?>
			</td>
		</tr>
        <tr>
            <td align="left">Destination</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="dest_id">
				<?php if ($source == "acqmod") { ?>
                    <? getDestinationListMod($_POST["dest_id"], $nativedb) ?>
                <?php } else { ?>
                    <? getDestinationList($_POST["dest_id"], $nativedb) ?>
				<?php } ?>
                </select>
			</td>
		</tr>
        <tr>
            <td align="left">Debugging Output</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type="checkbox" name="verbose" value="verbose"
                <?=$_POST["verbose"] ? "checked" : "" ?>>
			</td>
		</tr>
		<!--
        <tr>
            <td align="left">Do Not Send Message</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type="checkbox" name="noSend" value="noSend"></td>
		</tr>
		-->
		<tr>
            <td colspan=3 align=center>
            <input type="submit" name="cancel" value="Cancel">&nbsp;&nbsp;&nbsp;<input type="reset" value="Reset">&nbsp;&nbsp;&nbsp;<input type=submit name="submit" value="Send Message">
            </td>
        </tr>
        <tr>
            <td colspan=3 align=center>
            &nbsp;
            </td>
        </tr>
    </table>
</form>

<?php
}

include "footer.inc";

?>
</body>
</html>
