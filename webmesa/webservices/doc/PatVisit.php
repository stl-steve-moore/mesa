<?php 
    $title = "New Patient or Visit";
    $nativedb = "webadt";
    require "common_functions.inc";
    check_user_is_logged_in();
    ob_start();
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=windows-1252">
	<TITLE></TITLE>
	<META NAME="GENERATOR" CONTENT="StarOffice 7  (Win32)">
	<META NAME="AUTHOR" CONTENT="Robert Whitman">
	<META NAME="CREATED" CONTENT="20040119;21084073">
	<META NAME="CHANGEDBY" CONTENT="Robert Whitman">
	<META NAME="CHANGED" CONTENT="20040120;8495942">
	<STYLE>
	<!--
		@page { size: 8.5in 11in }
	-->
	</STYLE>
</HEAD>
<BODY LANG="en-US" DIR="LTR">

<?php 
    print_header($title);

    $process_form = false;
    $submit = $_POST["submit"];
    if ($submit == "Create Patient") {
        $verbose = $_POST["verbose"];

        $db_connection = connectDB($nativedb);
        $cmd = "$mesaTarget/bin/mesa_identifier $nativedb pid 2>&1";
        $pid = execute_piped_command($cmd, $verbose, true);

        $cmd = "$mesaTarget/bin/mesa_identifier $nativedb account 2>&1";
        $pataccnum = execute_piped_command($cmd, $verbose, true);

        $nam = strtoupper($_POST["lname"]) ."^". strtoupper($_POST["fname"]);
        if (rtrim($_POST["mname"]) != "")
            $nam = $nam."^". strtoupper($_POST["mname"]);
        $dat = $_POST["year"] . $_POST["month"] . $_POST["day"];
        $sex = $_POST["sex"];
        $addr = rtrim($_POST["saddress"]);
        $addr = $addr . rtrim($_POST["oaddress"]);
        $addr = $addr . rtrim($_POST["city"]);
        $addr = $addr . rtrim($_POST["state"]);
        $addr = $addr . rtrim($_POST["postalcode"]);
        $patrac = rtrim($_POST["patrac"]);

        $query = "INSERT INTO patient " .
            "(patid, issuer, patid2, issuer2, nam, datbir, sex, addr, " .
            "pataccnum, patrac) VALUES ('$pid', 'MESA', '', '', '$nam', " .
            "'$dat', '$sex', '$addr', '$pataccnum', '$patrac')";

        if ($_POST["verbose"]) {
            echo "<pre>SQL Query:\n";
            echo "$query\n</pre>";
        }

        $result = pg_exec($db_connection, $query) or 
            die("Error in query: $query" . pg_errormessage($db_connection));
        
        $new_patient_key = getCurrentPatientKey($db_connection);
        logCreatePatient($new_patient_key, $nativedb, true);
        pg_close($db_connection);

        print_success_message("Successfully added Patient Record");
    }
    if ($submit == "Name") {
        $verbose = $_POST["verbose"];
	$filter = $Namefilter;
    }
    if ($submit == "Patient ID") {
        $verbose = $_POST["verbose"];
	$filter = $PatIDfilter ;

    }
    if ($submit == "Date of Birth") {
        $verbose = $_POST["verbose"];
	$filter = $DOBfilter ;

    }
    $process_form = false;
    $submit = $_POST["submit"];
    if (($submit == "Create Visit/Send Registration") || 
        ($submit == "Create Visit/Don't Send Registration")) {
        if (empty($_POST["patient_key"])) {
            print_user_error("Please select patient.");
        } else {
            $process_form = true;
        }
    }
                                                                               
    if ($process_form) {
        $verbose = $_POST["verbose"];
        $db_connection = connectDB($nativedb);
        $cmd = "$mesaTarget/bin/mesa_identifier $nativedb visit";
        $visnum = rtrim(`$cmd`);
        $visnum = $visnum . "^^^MESA";
                                                                               
        // Get the patid, issuer from the patient table --
        // we just have the unique key.
        $query = "SELECT patid, issuer FROM patient WHERE patient_key=" .
            $_POST["patient_key"];
        $result = pg_exec($db_connection, $query) or
                die("Error in query: $query" .
                pg_errormessage($db_connection));
        if (pg_numrows($result) != 1)
            die("Got $row rows for query: $query");
                                                                               
        $row = pg_fetch_array($result, 0, PGSQL_ASSOC);
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
                                                                               
        pg_exec($db_connection, $query) or
            die("Error in query: $query" . pg_errormessage($db_connection));
        $viskey = getCurrentVisitKey($db_connection);
                                                                               
        logCreateVisit($viskey, $nativedb, true);
                                                                               
        print_success_message("Successfully added Visit Record");
        $process_form = false;
        pg_close($db_connection);
    }
    if ($submit == "Create Visit/Send Registration") {
    header('Location: http://'.$_SERVER[SERVER_NAME].substr_replace($_SERVER[SCRIPT_NAME],"",strrpos($_SERVER[SCRIPT_NAME],"/")).'/SendAdmit.php?viskey=' . $visnum);
    exit();

    }
    ob_end_flush();                                                                               
?>

<?php 
add_navigation();
?>
    
<FORM action="<?php $PHP_SELF;?>" method="post">
<table WIDTH=611 BORDER=0 CELLPADDING=0 CELLSPACING=0>
<tr>
<td align=right>Patient ID: </td>
<td align=left><b>Automatically Assigned</b> </td>
<tr>
<td align=right>Issuer: </td>
<td align=left><b>MESA</b> </td>
<tr>
<td align=right>First Name </td> <td align=left> <INPUT TYPE=TEXT NAME="fname" size=20 value="<?=$_POST["fname"]?>"> </td>
<tr>
<td align=right>Middle Initial </td> <td align=left> <INPUT TYPE=TEXT NAME="mname" size=20 value="<?=$_POST["mname"]?>"> </td>
<tr>
<td align=right>Last Name </td> <td align=left> <INPUT TYPE=TEXT NAME="lname" size=20 value="<?=$_POST["lname"]?>"> </td>
<tr>
		<td align=right>Date of birth </td> <td align=left> 
                   <input type=text name="year" size=4 
                        value="<?=$_POST["year"]?>">
                   <input type=text name="month" size=2 
                        value="<?=$_POST["month"]?>">
                   <input type=text name="day" size=2 
                        value="<?=$_POST["day"]?>"> </td>

	<tr>
		<td align=right> Sex </td>  <td> <select name="sex">
                <option <?=$_POST["sex"]=="M"? "SELECTED" : "" ?>>M
                <option <?=$_POST["sex"]=="F"? "SELECTED" : "" ?>>F
                </select> </td>

	<tr>
		<td align=right>Patient Street Address:</td> <td><INPUT TYPE=TEXT NAME="saddress" SIZE=30> </td>
	</tr> <tr>
		<td align=right>Patient Other Address Designation:</td> <td><INPUT TYPE=TEXT NAME="oaddress" SIZE=30> </td>
	</tr> <tr>
		<td align=right>Patient City:</td> <td><INPUT TYPE=TEXT NAME="city" SIZE=30> </td>
	</tr> <tr>
		<td align=right>Patient State:</td> <td><INPUT TYPE=TEXT NAME="state" SIZE=30> </td>
	</tr> <tr>
		<td align=right>Patient Postal Code:</td> <td><INPUT TYPE=TEXT NAME="postalcode" SIZE=30> </td>
	</tr> <tr>
		<td align=right>Patient Country ID:</td> <td>
		<SELECT NAME="Country" SIZE=1>
                <option <?=$_POST["Country"]=="a"? "SELECTED" : "" ?>>a
                <option <?=$_POST["Country"]=="b"? "SELECTED" : "" ?>>b
		</OPTION>
		</SELECT> </td> </tr>
	<tr>
		<td align=right>Race </td> <td>
		<SELECT NAME="Race" SIZE=1>
                <option <?=$_POST["race"]=="a"? "SELECTED" : "" ?>>a
                <option <?=$_POST["race"]=="b"? "SELECTED" : "" ?>>b
		</OPTION>
		</SELECT> </td>
<tr>
<td align=right><INPUT TYPE=submit NAME="submit" size=20 VALUE="Create Patient"></td> <td align=left> <INPUT TYPE=CHECKBOX NAME="verbose" VALUE="verbose"  <?=$_POST["verbose"] ? "checked" : "" ?>>Debug? </P>
</td></tr>
</table>
<br>
<table WIDTH=611 BORDER=0 CELLPADDING=0 CELLSPACING=0>
			<THEAD>
				<Th WIDTH=1>
				</Th>
				<Th WIDTH=299>
					Sort:<INPUT TYPE=submit NAME="submit" VALUE="Name"> <br> Filter:<INPUT TYPE=TEXT NAME="Namefilter" value="" SIZE=9 >
				</Th>
				<Th WIDTH=30>
					<P><INPUT TYPE=submit NAME="submit" VALUE="Patient ID"><INPUT TYPE=TEXT NAME="PatIDfilter" SIZE=27></P>
				</Th>
				<Th WIDTH=30>
					<P><INPUT TYPE=submit NAME="submit" VALUE="Date of Birth"><INPUT TYPE=TEXT NAME="DOBfilter" SIZE=15></P>
				</Th>
				<Th WIDTH=1>
					<P><BR>
					</P>
				</th>
			</thead>
			<TR VALIGN=TOP>
				 <? NEWgetPatientList($_POST["patient_key"], $nativedb, $submit, $filter) ?>
			</TR>
</table>
<br>
<table WIDTH=611 BORDER=0 CELLPADDING=0 CELLSPACING=0>
<tr><td align=right> Patient Class: </td>
           <td align=left><select name="patcla">
               <option value="I" <?=$_POST["patcla"]=="I"?
                   "SELECTED" : "" ?>>Inpatient
               <option value="O" <?=$_POST["patcla"]=="O"?
                   "SELECTED" : "" ?>>Outpatient
               </select> </td> </tr>
       <tr>
            <td align=right>Assigned Patient Location: </td>
            <td align=left><select name="asspatloc">
                <?php
                    $fn = "../config/asspatloc.txt";
                    configFileOptions($fn, $_POST["asspatloc"]);
                ?>
                </select> </td> </tr>
        <tr>
            <td align=right>Attending Doctor: </td>
            <td align=left><select name="attdoc">
                <?php
                    $fn = "../config/attdoc.txt";
                    configFileOptions($fn, $_POST["attdoc"]);
                ?>
                </select> </td> </tr>
        <tr>
            <td align=right>Admitting Doctor: </td>
            <td align=left><select name="admdoc">
                <?php
                    $fn = "../config/admdoc.txt";
                    configFileOptions($fn, $_POST["admdoc"]);
                ?>
                </select> </td> </tr>
        <tr>
            <td align=right>Admit Date: </td>
            <td align=left><b><?php echo $admdat = date("Ymd") ?></b> </td> </tr>
            <!-- Post values of admdat, admtim secretly -->
            <input type="hidden" name="admdat" value="<?=$admdat?>">
        <tr>
            <td align=right>Admit Time: </td>
            <td align=left><b><?php echo $admtim = date("H:i") ?></b> </td> </tr>
            <input type="hidden" name="admtim" value="<?=$admtim?>">
        <tr>
            <td align=right>Referring Doctor: </td>
            <td align=left><select name="refdoc">
                <?php
                    $fn = "../config/refdoc.txt";
                    configFileOptions($fn, $_POST["refdoc"]);
                ?>
       </select> </td> </tr>
<tr> <td align=right> <INPUT TYPE=BUTTON NAME="submit" SIZE=20  VALUE="Create Visit/Don't Send"></td> <td align=left> <INPUT TYPE=CHECKBOX NAME="verbose" VALUE="verbose"<?=$_POST["verbose"] ? "checked" : "" ?>>Debug? </td> </tr>
<tr> <td align=right> <INPUT TYPE=submit NAME="submit"  SIZE=20 VALUE="Create Visit/Send Registration"></td> <td align=left> <INPUT TYPE=CHECKBOX NAME="verbose" VALUE="verbose"              <?=$_POST["verbose"] ? "checked" : "" ?>>Debug? </td> </tr>
        </table	>
</FORM>

<? include "footer.inc" ?>
<?php   end_navigation(); ?>


</BODY>
</HTML>
