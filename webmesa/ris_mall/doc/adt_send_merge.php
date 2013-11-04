<?php 
    $title = "ADT Send Merge Message";
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
    if ($submit == "Send Message") {
        if (empty($_POST["dominant_patient"])) {
            print_user_error("Please select Dominant patient record."); 
        } elseif (empty($_POST["secondary_patient"])) {
            print_user_error("Please select Secondary patient record."); 
        } else {
            $process_form = true;
        }
    }
?>

<form action="<?php $PHP_SELF;?>" method="post">
    <table>
        <tr>
            <th align=right>Please select dominant/surviving patient record:
            <td align=left><select name="dominant_patient" size=6>
                <? getPatientList($_POST["dominant_patient"], $nativedb) ?>
                </select>
        <tr>
            <th align=right>Please select old/secondary patient record:
            <td align=left><select name="secondary_patient" size=6>
                <? getPatientList($_POST["secondary_patient"], $nativedb) ?>
                </select>
        <tr>
            <th align=right>Destination:
            <td align=left><select name="dest_id">
                <? getDestinationList($_POST["dest_id"], $nativedb) ?>
                </select>
        <tr>
            <th align=right>Debugging Output:
            <td align=left><input type="checkbox" name="verbose" value="verbose"
                <?=$_POST["verbose"] ? "checked" : "" ?>>
        <tr>
            <th align=right>Do Not Update Database:
            <td align=left><input type="checkbox" name="noUpdateDB">
        <tr>
            <th align=right>Do Not Send Message:
            <td align=left><input type="checkbox" name="noSend">
        <tr>
            <td align=center>
            <input type=submit name="submit" value="Send Message">
    </table>
</form>

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

    $bin = "$mesaTarget/bin/mesa_construct_hl7.pl";
    $cmd = "perl $bin $vflag -t $tmpdir -P $dom_patient_key " .
        "-p $sec_patient_key $message $template $nativedb $dest_id $outputFile";

    execute_piped_command($cmd, $verbose);

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose);

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
        print_success_message("Database updated successfully.");
    }
    logSendMerge($dom_patient_key, $dest_id, $sec_name, $nativedb, 
            !$noUpdateDB, !$noSend);
}
?>

<? include "footer.inc" ?>
</body>
</html>
