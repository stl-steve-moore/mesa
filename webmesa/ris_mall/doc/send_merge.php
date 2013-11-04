<?php
    require "global.inc";
    $source = $_GET["source"];
    $printSource = $actor{$source};
    $actorLink = $actor_link{$source};
	$successLink = $send_merge_link{$source};
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: <a href=\"$actorLink\">$printSource</a>:: Send Merge Message";
    $title_no_link = "MESA RIS Mall:: ". $printSource . " :: Send Merge Message";
    $header = "MESA RIS Mall";

    $nativedb = "webadt";
    require "common_functions.inc";

	if (!empty($_POST["cancel"])) {
        header("Location:$actorLink");
    }

    check_user_is_logged_in();
	global $dominantPatientList;
	global $secondaryPatientList;
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

	if ($_POST['list1Flag'] == 0) {
		$dominantPatientList = getPatientList2($_POST["dominant_patient"], $nativedb, "dominant_patient");
	} elseif ($_POST['list1Flag'] == 1) {
		list ($rows, $dominantPatientList) = getPatientListByLname2(strtoupper($_POST['lname1']), "dominant_patient", $nativedb);
	}

	if ($_POST['list2Flag'] == 0) {
		$secondaryPatientList = getPatientList2($_POST["secondary_patient"], $nativedb, "secondary_patient");
	} elseif ($_POST['list2Flag'] == 1) {
		list ($rows, $secondaryPatientList) = getPatientListByLname2(strtoupper($_POST['lname2']), "secondary_patient", $nativedb);
	}

    $submit = $_POST["submit"];
    if ($submit == "Send Message") {
        if (empty($_POST["dominant_patient"])) {
            print_user_error("Please select Dominant patient record."); 
        } elseif (empty($_POST["secondary_patient"])) {
            print_user_error("Please select Secondary patient record."); 
        } else {
            $process_form = true;
        }
    }

    if ($submit == "Search Dominant Patients") {
        $lNameDominant = $_POST["lname1"];
        if (empty($lNameDominant)) {
            print_user_error("Please enter few letters from Patient's last name.");
        } else {
            $lNameDominant = strtoupper($lNameDominant);
            list ($rows, $dominantPatientList) = getPatientListByLname2($lNameDominant, $_POST["dominant_patient"], $nativedb);
			$list1Flag = 1;
            if ($rows == 0) {
                print_user_error($dominantPatientList);
                $dominantPatientList = getPatientList2($_POST["dominant_patient"], $nativedb, "dominant_patient");
				$list1Flag = 0;
            }
        }
    }

    if ($submit == "Search Secondary Patients") {
        $lNameSecondary = $_POST["lname2"];
        if (empty($lNameSecondary)) {
            print_user_error("Please enter few letters from Patient's last name.");
        } else {
            $lNameSecondary = strtoupper($lNameSecondary);
            list ($rows, $secondaryPatientList) = getPatientListByLname2($lNameSecondary, $_POST["secondary_patient"], $nativedb);
			$list2Flag = 1;
            if ($rows == 0) {
                print_user_error($secondaryPatientList);
                $secondaryPatientList = getPatientList2($_POST["secondary_patient"], $nativedb, "secondary_patient");
				$list2Flag = 0;
            }
        }
    }
?>


<?php

if ($process_form) {
    $message = "a40";

    $dom_patient_key = rtrim($_POST["dominant_patient"]);
    $dom_patient = get_patient_by_key($dom_patient_key, $nativedb);
    $dom_patid = rtrim($dom_patient["patid"]);
    $dom_issuer = rtrim($dom_patient["issuer"]);

    $sec_patient_key = rtrim($_POST["secondary_patient"]);
    $sec_patient = get_patient_by_key($sec_patient_key, $nativedb);
    $sec_patid = rtrim($sec_patient["patid"]);
    $sec_issuer = rtrim($sec_patient["issuer"]);
    $sec_name = rtrim($sec_patient["nam"]);

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
    $cmd = "perl $bin $vflag -t $tmpdir -P $dom_patient_key " .
        "-p $sec_patient_key $message $template $nativedb $dest_id $outputFile";

    execute_piped_command($cmd, $verbose);

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose, $title, $source, $successLink);

# database stuff...
    $query1 = "UPDATE visit SET patid='$dom_patid', issuer='$dom_issuer' " .
        "WHERE patid='$sec_patid' AND issuer='$sec_issuer'";
    $query2 = "DELETE FROM patient WHERE patid='$sec_patid' AND " .
        "issuer='$sec_issuer'";
    if ($verbose) echo "<PRE>Queries:\n$query1\n$query2</PRE>";
    if ($noUpdateDB) {
        print_user_error("<em>Database not updated.</em>");
    } else {
        $db_connection = connectDB($nativedb);
        $result = pg_exec($db_connection, $query1) or 
                die("Error in query: $query1" .
                pg_errormessage($db_connection));
        $result = pg_exec($db_connection, $query2) or 
                die("Error in query: $query2" .
                pg_errormessage($db_connection));
        // close database connection
        pg_close($db_connection);
        print_success_message($title, "Database updated successfully.", $link);
    }
    logSendMerge($dom_patient_key, $dest_id, $sec_name, $nativedb, 
            !$noUpdateDB, !$noSend);
} else {
?>


<form action="<?php $PHP_SELF;?>" method="post">
	<input type="hidden" name="list1Flag" value="<?= $list1Flag ?>">
	<input type="hidden" name="list2Flag" value="<?= $list2Flag ?>">
    <table width="820" bgcolor="FFF8CE" border="0" cellspacing="2" cellpadding="2">
        <tr>
            <td bgcolor="#FFD557" colspan="3">
            <?php print_top_nav($title); ?>
            </td>
        </tr>
		<tr>
            <td colspan="3"><b><u>Search for Dominant Patients:</u></b></td>
        </tr>
        <tr>
            <td align="left">Dominant patient's<br>last name begins with </td>
            <td width="5">&nbsp;</td>
            <td align=left valign="top"><input type=text name="lname1" value="<?=$_POST["lname1"]?>">  </td>
        </tr>
        <tr>
            <td align="left">&nbsp;</td>
            <td width="5">&nbsp;</td>
            <td align=left><input type="submit" name="submit" value="Search Dominant Patients"></td>
        </tr>
        <tr>
            <td colspan="3">&nbsp;</td>
        </tr>
        <tr>
            <td align="left" valign="top">Please select dominant/surviving <br>patient record</td>
			<td width="5">&nbsp;</td>
            <td align=left>
                <?= $dominantPatientList ?>
                </td>
		</tr>
		<tr>
            <td colspan="3"><b><u>Search for Secondary Patients:</u></b></td>
        </tr>
        <tr>
            <td align="left">Secondary patient's<br>last name begins with </td>
            <td width="5">&nbsp;</td>
            <td align=left valign="top"><input type=text name="lname2" value="<?=$_POST["lname2"]?>">  </td>
        </tr>
        <tr>
            <td align="left">&nbsp;</td>
            <td width="5">&nbsp;</td>
            <td align=left><input type="submit" name="submit" value="Search Secondary Patients"></td>
        </tr>
        <tr>
            <td colspan="3">&nbsp;</td>
        </tr>
        <tr>
            <td align="left" valign="top">Please select old/secondary <br>patient record</td>
			<td width="5">&nbsp;</td>
            <td align=left>
                <?= $secondaryPatientList ?>
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
            <td align=left><select name="dest_id">
                <? getDestinationList($_POST["dest_id"], $nativedb) ?>
                </select></td>
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
