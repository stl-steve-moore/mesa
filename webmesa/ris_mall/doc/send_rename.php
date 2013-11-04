<?php
    require "global.inc";
    $source = $_GET["source"];
    $printSource = $actor{$source};
    $actorLink = $actor_link{$source};
	$successLink = $send_rename_link{$source};
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: <a href=\"$actorLink\">$printSource</a>:: Send Rename Message";
    $title_no_link = "MESA RIS Mall:: ". $printSource . " :: Send Rename Message";
    $header = "MESA RIS Mall";

    $nativedb = "webadt";
    require "common_functions.inc";

	if (!empty($_POST["cancel"])) {
        header("Location:$actorLink");
    }

    check_user_is_logged_in();
	global $visitList;
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
	$visitList = getVisitList($_POST["viskey"], $nativedb);
    $submit = $_POST["submit"];
    if ($submit == "Send Message") {
        if (empty($_POST["viskey"])) {
            print_user_error("Please select patient."); 
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
            list ($rows, $visitList) = getVisitListByLname($lName, $_POST["viskey"], $nativedb);
            if ($rows == 0) {
                print_user_error($visitList);
                $visitList = getVisitList($_POST["viskey"], $nativedb);
            }
        }
    }
?>

<?php

if ($process_form) {
    $message = "a08";

    $nam = strtoupper($_POST["lname"]) ."^". strtoupper($_POST["fname"]);
    if (rtrim($_POST["mname"]) != "")
        $nam = $nam."^". strtoupper($_POST["mname"]);

    $viskey = rtrim($_POST["viskey"]);
    $visit = get_patient_visit_by_viskey($viskey, $nativedb);
    $old_name = $visit["nam"];
    $patient_key = $visit["patient_key"];

    $tmpdir = "$risMallRoot/tmp";
    $dest_id = rtrim($_POST["dest_id"]); 
    $template = "$mesaTarget/templates/hl7/$message.tpl";
    $outputFile = $tmpdir."/$message.hl7";
    $verbose = $_POST["verbose"];
    $vflag = $verbose ? "-v" : "";
    $noSend = !empty($_POST["noSend"]); 
    $noUpdateDB = !empty($_POST["noUpdateDB"]);
	$short = $_POST["short"];

    #Append $short to $message with ~~ delimiter
    if ($short) {
      $message .= "~~".$short;
    }
#echo "<p>\$message: ". $message ."<p>";

    $bin = "$mesaTarget/bin/mesa_construct_hl7.pl";
    $cmd = "perl $bin $vflag -t $tmpdir -V $viskey -N $nam " .
        "$message $template $nativedb $dest_id $outputFile";

    execute_piped_command($cmd, $verbose);

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose, $title, $source, $successLink);

# database stuff...
    $query = "UPDATE patient SET nam='$nam' WHERE patient_key='$patient_key'";
    if ($verbose) echo "<PRE>Query:\n$query</PRE>";
    if ($noUpdateDB) {
        print_user_error("Database not updated.");
    } else {
        $db_connection = connectDB($nativedb);
        $result = pg_exec($db_connection, $query) or 
                die("Error in query: $query" .
                pg_errormessage($db_connection));
        // close database connection
        pg_close($db_connection);
        //print_success_message("Database updated successfully.");
    }

    logSendRename($patient_key, $dest_id, $old_name, $nativedb, 
            !$noUpdateDB, !$noSend);
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
            <td align="left">Patient's lastname begins with </td>
            <td width="5">&nbsp;</td>
            <td align=left><input type=text name="last_name" value="<?=$_POST["last_name"]?>">  </td>
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
            <td align="left" valign="top">Please select visit record</td>
			<td width="5">&nbsp;</td>
            <td align=left>
				<?= $visitList ?>
			</td>
		</tr>
<!--
        <tr>
            <td align="left">Send short version of issuer</td>
            <td width="5">&nbsp;</td>
            <td align=left><input type="checkbox" name="short" value="short"
                <?=$_POST["short"] ? "checked" : "" ?>>
            </td>
        </tr>
-->
        <tr>
            <td align="left">Destination</td>
			<td width="5">&nbsp;</td>
            <td align=left>
				<select name="dest_id">
                <? getDestinationList($_POST["dest_id"], $nativedb) ?>
                </select></td>
		</tr>
        <tr>
            <td align="left">First Name</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type=text name="fname" value="<?=$_POST["fname"]?>"></td>
		</tr>
        <tr>
            <td align="left">Middle Initial</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type=text name="mname" size=2 value="<?=$_POST["mname"]?>"></td>
		</tr>
        <tr>
            <td align="left">Last Name</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type=text name="lname" value="<?=$_POST["lname"]?>">	</td>
		</tr>
        <tr>
            <td align="left">Debugging Output</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type="checkbox" name="verbose" value="verbose"
                <?=$_POST["verbose"] ? "checked" : "" ?>></td>
		</tr>
        <tr>
            <td align="left">Do Not Update Database</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type="checkbox" name="noUpdateDB"></td>
		</tr>
		<!--
        <tr>
            <td align="left">Do Not Send Message</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type="checkbox" name="noSend"></td>
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

<?php } ?>
<? include "footer.inc" ?>
</body>
</html>
