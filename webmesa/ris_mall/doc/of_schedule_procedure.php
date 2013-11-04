<?php 
    $title = "Order Filler: Schedule a Requested Procedure";
    $nativedb = "webof";
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
        if (empty($_POST["orduid"])) {
            print_user_error("Please select Procedure."); 
        } else {
            $process_form = true;
        }
    }
?>

<form action="<?php $PHP_SELF;?>" method="post">
    <table>
        <tr>
            <th align=right>Please select a Requested Procedure:
            <td align=left><select name="orduid" size=8>
            <!-- Need: patid, name, birthdate, sex, race -->
                <? getOrderList($_POST["orduid"], $nativedb) ?>
                </select>
        <tr>
            <th align=right>Scheduled System Name (AE Title):
            <td align=left><select name="ScheduledSystemAET"> 
            <?php  
                $fn = "../config/schaet.txt";
                configFileOptions($fn, $_POST["ScheduledSystemAET"]);
            ?>
            </select>  
        <tr>
            <th align=right>SPS Start Date:
            <td align=left><input type=text name="spsstadat"
                value="<? echo `perl ../bin/getMesaInfo.pl date`?>">
        <tr>
            <th align=right>SPS Start Time:
            <td align=left><input type=text name="spsstatim"
                value="<? echo `perl ../bin/getMesaInfo.pl time`?>">
        <tr>
            <th align=right>Modality:
            <td align=left><select name="mod"> 
            <?php  
                $fn = "../config/mod.txt";
                configFileOptions($fn, $_POST["mod"]);
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
<?php
if ($process_form) {

    $orduid = rtrim($_POST["orduid"]); 
    $ScheduledSystemAET = rtrim($_POST["ScheduledSystemAET"]); 
    // The above is of form, System Name (AET).  Extract these.
    preg_match("/(.+) \((.+)\)/", $ScheduledSystemAET, $s);
    $schstanam = $s[1];
    $schaet = $s[2];
    $mod = rtrim($_POST["mod"]);

# need to fill patient account number and race because mesa_schedule_mwl doesn't.
    $pvo = get_patient_visit_order_by_key($orduid, $nativedb);
    $pataccnum = rtrim($pvo["pataccnum"]);
    $patrac = rtrim($pvo["patrac"]);
    $add_fields = "-D pataccnum $pataccnum -D patrac $patrac";

    $verbose = $_POST["verbose"];
    $vflag = $verbose ? "-v" : "";

    $bin = "$mesaTarget/bin/mesa_schedule_mwl";
    $cmd = "$bin $vflag -m $mod -s \"$schstanam\" -t \"$schaet\" " .
        "-D spsstadat $spsstadat -D spsstatim $spsstatim $add_fields " .
        "-c orduid $orduid $nativedb 2>&1"; 

    execute_piped_command($cmd, $verbose);
    $mwluid = getRecentMWLUID($nativedb);
    logScheduleProcedure($mwluid, $nativedb, 1);
    print_success_message("Successfully Scheduled Requested Procedure.");
}

include "footer.inc" ?>
</body>
</html>
