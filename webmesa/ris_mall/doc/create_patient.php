<?php 
    require "common_functions.inc";
    require "global.inc";
    $source = $_GET["source"];
    $printSource = $actor{$source};
    $actorLink = $actor_link{$source};
	$successLink = $create_patient_link{$source};
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: <a href=\"$actorLink\">$printSource</a>:: Create a Patient";
    $title_no_link = "MESA RIS Mall:: ". $printSource . " :: Create a Patient";
    $header = "MESA RIS Mall";
    $adtdb = "webadt";
    $opdb = "webop";
    $ofdb = "webof";

	if (!empty($_POST["cancel"])) {
    	header("Location:$actorLink");
        }

    check_user_is_logged_in();
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
    $submit = $_POST["submit"];
    if ($submit == "Create") {
        if (empty($_POST["lname"]) || empty($_POST["fname"]) || empty($_POST["addr"])) {
            print_user_error("Please fill the necessary fields.");
        } else {
            $process_form = true;
        }
    }

    //$submit = $_POST["submit"];
    if ($submit == "Create" && $process_form == "true") {
        $verbose = $_POST["verbose"];

        $adt_db_connection = connectDB($adtdb);
        $op_db_connection = connectDB($opdb);
        $of_db_connection = connectDB($ofdb);

        $cmd = "$mesaTarget/bin/mesa_identifier $adtdb pid 2>&1";
        $pid = execute_piped_command($cmd, $verbose, true);

        $cmd = "$mesaTarget/bin/mesa_identifier $adtdb account 2>&1";
        $pataccnum = execute_piped_command($cmd, $verbose, true);

        $nam = strtoupper($_POST["lname"]) ."^". strtoupper($_POST["fname"]);
        if (rtrim($_POST["mname"]) != "")
            $nam = $nam."^". strtoupper($_POST["mname"]);
        $dat = $_POST["year"] . $_POST["month"] . $_POST["day"];
        $sex = $_POST["sex"];
        $issuer = $_POST["issuer"];
        $addr = rtrim($_POST["addr"]);
        $patrac = rtrim($_POST["patrac"]);

        $query = "INSERT INTO patient " .
            "(patid, issuer, patid2, issuer2, nam, datbir, sex, addr, " .
            "pataccnum, patrac) VALUES ('$pid', '$issuer', '', '', '$nam', " .
            "'$dat', '$sex', '$addr', '$pataccnum', '$patrac')";

        if ($_POST["verbose"]) {
            echo "<pre>SQL Query:\n";
            echo "$query\n</pre>";
        }

        $adt_result = pg_exec($adt_db_connection, $query) or 
            die("Error in query: $query" . pg_errormessage($adt_db_connection));

        $op_result = pg_exec($op_db_connection, $query) or 
            die("Error in query: $query" . pg_errormessage($op_db_connection));

        $of_result = pg_exec($of_db_connection, $query) or 
            die("Error in query: $query" . pg_errormessage($of_db_connection));
        
        $new_patient_key = getCurrentPatientKey($adt_db_connection);
        logCreatePatient($new_patient_key, $adtdb, true);
        pg_close($adt_db_connection);
		
        $new_patient_key = getCurrentPatientKey($op_db_connection);
        logCreatePatient($new_patient_key, $opdb, true);
        pg_close($op_db_connection);

        $new_patient_key = getCurrentPatientKey($of_db_connection);
        logCreatePatient($new_patient_key, $ofdb, true);
        pg_close($of_db_connection);

	//$link = "Click <a href=\"create_visit.php?source=$source\">here</a> to Create a Visit.";
        print_success_message($title, "Successfully added Patient Record.", $successLink);
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
            <td align=left>Patient ID</td>
	    <td width="5">&nbsp;</td>
            <td align=left>Automatically Assigned</td>
	</tr>
        <tr>
            <td align=left>Issuer</td>
	        <td width="5">&nbsp;</td>
             <td align=left><select name="issuer">
                <?php
                    $fn = "../config/issuer.txt";
                    configFileOptions($fn, $_POST["issuer"]);
                ?>
                </select>
            </td>
	    </tr>
        <tr>
            <td align=left>Patient ID 2</td>
	    <td width="5">&nbsp;</td>
            <td align=left>&quot &quot</td>
	</tr>
        <tr>
            <td align=left>Issuer 2</td>
	    <td width="5">&nbsp;</td>
            <td align=left>&quot &quot</td>
	</tr>
        <tr>
            <td align=left>First Name</td>
	    <td width="5">&nbsp;</td>
            <td align=left><input type=text name="fname" 
                value="<?=$_POST["fname"]?>"></td>
	</tr>
        <tr>
            <td align=left>Middle Initial</td>
	    <td width="5">&nbsp;</td>
            <td align=left><input type=text name="mname" size=2 
                value="<?=$_POST["mname"]?>"></td>
	</tr>
        <tr>
            <td align=left>Last Name</td>
	    <td width="5">&nbsp;</td>
            <td align=left><input type=text name="lname" 
                value="<?=$_POST["lname"]?>"></td>
	</tr>
        <tr>
            <td align=left>Date of Birth<br><font size="-2"> (YYYY MM DD)</font></td>
	    <td width="5">&nbsp;</td>
            <td align=left valign="top">
                   <input type=text name="year" size=4 
                        value="<?=$_POST["year"]?>">
                   <input type=text name="month" size=2 
                        value="<?=$_POST["month"]?>">
                   <input type=text name="day" size=2 
                        value="<?=$_POST["day"]?>">
	    </td>
	</tr>
        <tr>
            <td align=left>Sex</td>
	    <td width="5">&nbsp;</td>
            <td align=left><select name="sex">
                <option <?=$_POST["sex"]=="M"? "SELECTED" : "" ?>>M
                <option <?=$_POST["sex"]=="F"? "SELECTED" : "" ?>>F
                </select>
	    </td>
	</tr>
        <tr>
            <td align=left>Patient Address</td>
	    <td width="5">&nbsp;</td>
            <td align=left><input type=text name="addr" size=60 
                value="<?=$_POST["addr"]?>">
	    </td>
	</tr>
        <tr>
            <td align=left>Patient Account Number</td>
	    <td width="5">&nbsp;</td>
            <td align=left>Automatically Assigned</td>
	</tr>
        <tr>
            <td align=left>Race</td>
	    <td width="5">&nbsp;</td>
            <td align=left><select name="patrac">
                <?php  
                    $fn = "../config/patrac.txt";
                    configFileOptions($fn, $_POST["patrac"]);
                ?>
                </select>
	    </td>
	</tr>
        <tr>
            <td align=left>Debugging Output</td>
	    <td width="5">&nbsp;</td>
            <td align=left><input type="checkbox" name="verbose" value="verbose"
                <?=$_POST["verbose"] ? "checked" : "" ?>>
	    </td>
	</tr>
        <tr>
            <td colspan=3 align=center>
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
