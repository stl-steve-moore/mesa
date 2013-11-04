<?php 
    $title = "Order Placer: Send/Cancel an Order Message";
    $nativedb = "webop";
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
        if (empty($orduid)) {
            print_user_error("Please select order."); 
        } else {
            $process_form = true;
        }
    }
?>
<form action="<?php $PHP_SELF;?>" method="post">
    <table>
        <tr>
            <th align=right>Please select Order:
            <td align=left><select name="orduid" size=8>
                <? getOrderList($_POST["orduid"], $nativedb) ?>
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
    $message = "o01-order";

    $orduid = rtrim($_POST["orduid"]);
    $tmpdir = "$risMallRoot/tmp";
    $dest_id = rtrim($_POST["dest_id"]); 
    $template = "$mesaTarget/templates/hl7/$message.tpl";
    $outputFile = $tmpdir."/$message.hl7";
    $verbose = $_POST["verbose"];
    $vflag = $verbose ? "-v" : "";
    $noSend = !empty($_POST["noSend"]); 

    $bin = "$mesaTarget/bin/mesa_construct_hl7.pl";
    $cmd = "perl $bin $vflag -t $tmpdir -O $orduid " .
        "$message $template $nativedb $dest_id $outputFile";
    
    execute_piped_command($cmd, $verbose);

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose);

    logSendOrder($dest_id, $orduid, $nativedb, !$noSend);
}
?>
<? include "footer.inc" ?>

</body>
</html>
