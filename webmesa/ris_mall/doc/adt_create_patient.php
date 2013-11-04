<?php 
    $title = "ADT: Create a Patient";
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

    $submit = $_POST["submit"];
    if ($submit == "Create") {
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
        $addr = rtrim($_POST["addr"]);
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
?>
    
<form action="<?php $PHP_SELF;?>" method="post">
    <table>
        <tr>
            <th align=right>Patient ID:
            <td align=left><b>Automatically Assigned</b>
        <tr>
            <th align=right>Issuer:
            <td align=left><b>MESA</b>
        <tr>
            <th align=right>Patient ID 2:
            <td align=left><b>&quot &quot</b>
        <tr>
            <th align=right>Issuer 2:
            <td align=left><b>&quot &quot</b>
        <tr>
            <th align=right>First Name:
            <td align=left><input type=text name="fname" 
                value="<?=$_POST["fname"]?>">
        <tr>
            <th align=right>Middle Initial:
            <td align=left><input type=text name="mname" size=2 
                value="<?=$_POST["mname"]?>">
        <tr>
            <th align=right>Last Name:
            <td align=left><input type=text name="lname" 
                value="<?=$_POST["lname"]?>">
        <tr>
            <th align=right>Date of Birth (YYYY MM DD):
            <td align=left>
                   <input type=text name="year" size=4 
                        value="<?=$_POST["year"]?>">
                   <input type=text name="month" size=2 
                        value="<?=$_POST["month"]?>">
                   <input type=text name="day" size=2 
                        value="<?=$_POST["day"]?>">
        <tr>
            <th align=right>Sex:
            <td align=left><select name="sex">
                <option <?=$_POST["sex"]=="M"? "SELECTED" : "" ?>>M
                <option <?=$_POST["sex"]=="F"? "SELECTED" : "" ?>>F
                </select>
        <tr>
            <th align=right>Patient Address:
            <td align=left><input type=text name="addr" size=60 
                value="<?=$_POST["addr"]?>">
        <tr>
            <th align=right>Patient Account Number:
            <td align=left><b>Automatically Assigned</b>
        <tr>
            <th align=right>Race
            <td align=left><select name="patrac">
                <?php  
                    $fn = "../config/patrac.txt";
                    configFileOptions($fn, $_POST["patrac"]);
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
