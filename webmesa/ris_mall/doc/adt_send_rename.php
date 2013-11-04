<?php 
    $title = "ADT Send Rename Message";
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
        if (empty($_POST["viskey"])) {
            print_user_error("Please select patient."); 
        } else {
            $process_form = true;
        }
    }
?>

<form action="<?php $PHP_SELF;?>" method="post">
    <table>
        <tr>
            <th align=right>Please select visit record:
            <td align=left><select name="viskey" size=8>
                <? getVisitList($_POST["viskey"], $nativedb) ?>
                </select>
        <tr>
            <th align=right>Destination:
            <td align=left><select name="dest_id">
                <? getDestinationList($_POST["dest_id"], $nativedb) ?>
                </select>
        <tr>
            <th align=right>First Name:
            <td align=left><input type=text name="fname" value="<?=$_POST["fname"]?>">
        <tr>
            <th align=right>Middle Initial:
            <td align=left><input type=text name="mname" size=2 value="<?=$_POST["mname"]?>">
        <tr>
            <th align=right>Last Name:
            <td align=left><input type=text name="lname" value="<?=$_POST["lname"]?>">
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

    $bin = "$mesaTarget/bin/mesa_construct_hl7.pl";
    $cmd = "perl $bin $vflag -t $tmpdir -V $viskey -N $nam " .
        "$message $template $nativedb $dest_id $outputFile";

    execute_piped_command($cmd, $verbose);

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose);

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
        print_success_message("Database updated successfully.");
    }

    logSendRename($patient_key, $dest_id, $old_name, $nativedb, 
            !$noUpdateDB, !$noSend);
}
?>

<? include "footer.inc" ?>
</body>
</html>
