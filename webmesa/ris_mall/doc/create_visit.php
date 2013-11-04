<?php 
	require "global.inc";
    $source = $_GET["source"];
    $printSource = $actor{$source};
    $actorLink = $actor_link{$source};
	$successLink = $create_visit_link{$source};
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: <a href=\"$actorLink\">$printSource</a>:: Create a Visit";
    $title_no_link = "MESA RIS Mall:: ". $printSource . " :: Create a Visit";
    $header = "MESA RIS Mall";

	$adtdb = "webadt";
    $opdb = "webop";
    $ofdb = "webof";
    require "common_functions.inc";

	if (!empty($_POST["cancel"])) {
        header("Location:$actorLink");
        }

    check_user_is_logged_in();
	global $patientList;
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
	$patientList = getPatientList($_POST["patient_key"], $adtdb);
    $submit = $_POST["submit"];
    if ($submit == "Create") {
        if (empty($_POST["patient_key"])) {
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
            list ($rows, $patientList) = getPatientListByLname($lName, $_POST["patient_key"], $adtdb);
            if ($rows == 0) {
                print_user_error($patientList);
                $patientList = getPatientList($_POST["patientList"], $adtdb);
            }
        }
    }

    if ($submit == "Create" && $process_form == "true") {
        $adt_db_connection = connectDB($adtdb);
        $op_db_connection = connectDB($opdb);
        $of_db_connection = connectDB($ofdb);

        $cmd = "$mesaTarget/bin/mesa_identifier $adtdb visit";
        $visnum = rtrim(`$cmd`);
        $visnum = $visnum . "^^^MESA";

        // Get the patid, issuer from the patient table -- 
        // we just have the unique key.
        $query = "SELECT patid, issuer FROM patient WHERE patient_key=" . 
            $_POST["patient_key"];

        $adt_result = pg_exec($adt_db_connection, $query) or 
                die("Error in query: $query" . 
                pg_errormessage($adt_db_connection));

        if (pg_numrows($adt_result) != 1) 
            die("Got $row rows for query: $query");

        $row = pg_fetch_array($adt_result, 0, PGSQL_ASSOC);
        $patid = rtrim($row['patid']);
        $issuer = rtrim($row['issuer']);

        $patcla = rtrim($_POST["patcla"]);
        $asspatloc = rtrim($_POST["asspatloc"]);
        $attdoc = rtrim($_POST["attdoc"]);
        $admdoc = rtrim($_POST["admdoc"]);
        $admdat = rtrim($_POST["admdat"]); 
        $admtim = rtrim($_POST["admtim"]); 
        $refdoc = rtrim($_POST["refdoc"]);

        $query = "INSERT INTO visit (visnum, patid, issuer, " .
            "patcla, asspatloc, attdoc, admdoc, admdat, admtim, refdoc) " .
            "VALUES ('$visnum', '$patid', '$issuer', '$patcla', " .
            "'$asspatloc', '$attdoc', '$admdoc', '$admdat', '$admtim', " .
            "'$refdoc')";

        if ($_POST["verbose"]) {
            echo "<pre>SQL Query:\n";
            echo "$query\n</pre>";
        }

        pg_exec($adt_db_connection, $query) or 
            die("Error in query: $query" . pg_errormessage($adt_db_connection));

        pg_exec($op_db_connection, $query) or 
            die("Error in query: $query" . pg_errormessage($op_db_connection));

        pg_exec($of_db_connection, $query) or 
            die("Error in query: $query" . pg_errormessage($of_db_connection));

        $viskey = getCurrentVisitKey($adt_db_connection);
        logCreateVisit($viskey, $adtdb, true);

        //print_success_message("Successfully added Visit Record");
		//$link = "Click <a href=\"create_order.php?source=$source\">here</a> to Create an Order.";
		print_success_message($title, "Successfully added Visit Record.", $successLink);
        pg_close($adt_db_connection);
        pg_close($op_db_connection);
        pg_close($of_db_connection);
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
            <td align="left">Visit Number</td>
			<td width="5">&nbsp;</td>
            <td align=left><b>Automatically Assigned</b></td>
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
            <td align="left" valign="top">Patient<br> (Name, DOB, PatID, Issuer)</td>
			<td width="5">&nbsp;</td>
            <td align=left>
				<?= $patientList ?>
			</td>
		</tr>
        <tr>
            <td align="left">Patient Class</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="patcla">
                <option value="I" <?=$_POST["patcla"]=="I"? 
                    "SELECTED" : "" ?>>Inpatient
                <option value="O" <?=$_POST["patcla"]=="O"? 
                    "SELECTED" : "" ?>>Outpatient
                </select>
			</td>
		</tr>
        <tr>
            <td align="left">Assigned Patient Location</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="asspatloc">
                <?php  
                    $fn = "../config/asspatloc.txt";
                    configFileOptions($fn, $_POST["asspatloc"]);
                ?>
                </select>
			</td>
		</tr>
        <tr>
            <td align="left">Attending Doctor</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="attdoc">
                <?php  
                    $fn = "../config/attdoc.txt";
                    configFileOptions($fn, $_POST["attdoc"]);
                ?>
                </select>
			</td>
		</tr>
        <tr>
            <td align="left">Admitting Doctor</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="admdoc">
                <?php  
                    $fn = "../config/admdoc.txt";
                    configFileOptions($fn, $_POST["admdoc"]);
                ?>
                </select>
			</td>
		</tr>
        <tr>
            <td align="left">Admit Date</td>
			<td width="5">&nbsp;</td>
            <td align=left><b><?php echo $admdat = 
                `perl ../bin/getMesaInfo.pl date`?></b>
            <!-- Post values of admdat, admtim secretly -->
            <input type="hidden" name="admdat" value="<?=$admdat?>">
			</td>
		</tr>
        <tr>
            <td align="left">Admit Time</td>
			<td width="5">&nbsp;</td>
            <td align=left><b><?php echo $admtim = 
                `perl ../bin/getMesaInfo.pl time`?></b>
            <input type="hidden" name="admtim" value="<?=$admtim?>">
			</td>
		</tr>
        <tr>
            <td align="left">Referring Doctor</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="refdoc">
                <?php  
                    $fn = "../config/refdoc.txt";
                    configFileOptions($fn, $_POST["refdoc"]);
                ?>
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
		<tr>
		    <td colspan=3 align=center>
			&nbsp;
			</td>
		</tr>
        <tr>
            <td align="left">&nbsp;</td>
			<td width="5">&nbsp;</td>
            <td> 
            <input type="submit" name="cancel" value="Cancel">&nbsp;&nbsp;&nbsp;<input type="reset" value="Reset">&nbsp;&nbsp;&nbsp;<input type=submit name="submit" value="Create">
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
