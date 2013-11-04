<?php 
    $title = "ADT: Create a Visit";
    $nativedb = "webadt";
    require "common_functions.inc";
    check_user_is_logged_in();
?>

<html>
<head>
<title><?=$title?></title>
</head>
<body>

<?php 
    print_header($title);
    link_to_main();

# process_form tells us later if this form is ready to be processed.
# first confirm all the info is here.
    $process_form = false;
    $submit = $_POST["submit"];
    if ($submit == "Create") {
        if (empty($_POST["patient_key"])) {
            print_user_error("Please select patient."); 
        } else {
            $process_form = true;
        }
    }

    if ($process_form) {
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
        pg_close($db_connection);
    }

?>

<form action="<?php $PHP_SELF;?>" method="post">
    <table>
        <tr>
            <th align=right>Visit Number:
            <td align=left><b>Automatically Assigned</b>
        <tr>
            <th align=right>Patient (Name, DOB, PatID, Issuer):
            <td align=left><select name="patient_key" size=8>
                <? getPatientList($_POST["patient_key"], $nativedb) ?>
                </select>
        <tr>
            <th align=right>Patient Class:
            <td align=left><select name="patcla">
                <option value="I" <?=$_POST["patcla"]=="I"? 
                    "SELECTED" : "" ?>>Inpatient
                <option value="O" <?=$_POST["patcla"]=="O"? 
                    "SELECTED" : "" ?>>Outpatient
                </select>
        <tr>
            <th align=right>Assigned Patient Location:
            <td align=left><select name="asspatloc">
                <?php  
                    $fn = "../config/asspatloc.txt";
                    configFileOptions($fn, $_POST["asspatloc"]);
                ?>
                </select>
        <tr>
            <th align=right>Attending Doctor:
            <td align=left><select name="attdoc">
                <?php  
                    $fn = "../config/attdoc.txt";
                    configFileOptions($fn, $_POST["attdoc"]);
                ?>
                </select>
        <tr>
            <th align=right>Admitting Doctor:
            <td align=left><select name="admdoc">
                <?php  
                    $fn = "../config/admdoc.txt";
                    configFileOptions($fn, $_POST["admdoc"]);
                ?>
                </select>
        <tr>
            <th align=right>Admit Date:
            <td align=left><b><?php echo $admdat = 
                `perl ../bin/getMesaInfo.pl date`?></b>
            <!-- Post values of admdat, admtim secretly -->
            <input type="hidden" name="admdat" value="<?=$admdat?>">
        <tr>
            <th align=right>Admit Time:
            <td align=left><b><?php echo $admtim = 
                `perl ../bin/getMesaInfo.pl time`?></b>
            <input type="hidden" name="admtim" value="<?=$admtim?>">
        <tr>
            <th align=right>Referring Doctor:
            <td align=left><select name="refdoc">
                <?php  
                    $fn = "../config/refdoc.txt";
                    configFileOptions($fn, $_POST["refdoc"]);
                ?>
                </select>
        <tr>
            <th align=right>Debugging Output:
            <td align=left><input type="checkbox" name="verbose" value="verbose"
                <?=$_POST["verbose"] ? "checked" : "" ?>>
        <tr>
            <td colspan=2 align=center>
            <input type=submit name="submit" value="Create">
    </table>
</form>

<? include "footer.inc" ?>
</body>
</html>
