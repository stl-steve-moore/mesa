<?php 
    $title = "ADT Send Admit/Registration Message";
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
        if (empty($viskey)) {
            print_user_error("Please select visit."); 
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
            <th align=right>Debugging Output:
            <td align=left><input type="checkbox" name="verbose" value="verbose"
                <?=$_POST["verbose"] ? "checked" : "" ?>>
        <tr>
            <th align=right>Do Not Send Message:
            <td align=left><input type="checkbox" name="noSend" value="noSend">
        <tr>
            <td colspan=2 align=center>
            <input type=submit name="submit" value="Send Message">
    </table>
</form>

<?php
if ($process_form) {
# Button has been pressed. First, create the hl7 message
# "Usage: perl mesa_construct_hl7.pl [-h] [-v] [-t tmpdir] \n";
# "\t[-T templateFile | -D templateDir] [-N newName] [-n oldName]\n";
# "\tmessage database visitID destID outputFile\n";

    $viskey = $_POST["viskey"]; 
# first, need to get patient class.  Lookup by the visit number.  This 
# determines what message type we send.
    $visit = get_patient_visit_by_viskey($viskey, $nativedb);
    $patcla = rtrim($visit["patcla"]);
    switch ($patcla) {
        case "I": $message = "a01"; break;
        case "O": $message = "a04"; break;
        default: die ("Unknown Patient Class \"$patcla\" for viskey=$viskey");
    }

    $tmpdir = "$risMallRoot/tmp";
    $dest_id = rtrim($_POST["dest_id"]); 
    $template = "$mesaTarget/templates/hl7/$message.tpl";
    $outputFile = $tmpdir."/$message.hl7";
    $verbose = $_POST["verbose"];
    $vflag = $verbose ? "-v" : "";
    $noSend = !empty($_POST["noSend"]); // if _POST[.] = "noSend", NOT empty  


    $bin = "$mesaTarget/bin/mesa_construct_hl7.pl";
    $cmd = "perl $bin $vflag -t $tmpdir -V $viskey " .
        "$message $template $nativedb $dest_id $outputFile";
    
    execute_piped_command($cmd, $verbose);

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose);

    logSendAdmit($viskey, $dest_id, $nativedb, !$noSend);
}
?>
<? include "footer.inc" ?>
</body>
</html>
