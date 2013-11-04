<?php
    require "global.inc";
    $source = $_GET["source"];
    $next = $_GET["next"];
    $printSource = $actor{$source};
    $actorLink = $actor_link{$source};
	if ($next == "mwl") {
    	$successLink = $send_order_link2{$source};
	} else {
    	$successLink = $send_order_link{$source};
	}
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: <a href=\"$actorLink\">$printSource</a>:: Send/Cancel an Order Message";
    $title_no_link = "MESA RIS Mall:: ". $printSource . " :: Send/Cancel an Order Message";
    $header = "MESA RIS Mall";

    $nativedb = "webop";
    require "common_functions.inc";

	if (!empty($_POST["cancel"])) {
        header("Location:$actorLink");
    }

    check_user_is_logged_in();
	global $orderList;
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
	$orderList = getOrderList($_POST["orduid"], $nativedb);
    $submit = $_POST["submit"];
    if ($submit == "Send Message" || $submit == "Cancel Order") {
	  if (empty($_POST["orduid"])) {
            print_user_error("Please select order."); 
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
            list ($rows, $orderList) = getOrderListByLname($lName, $_POST["orduid"], $nativedb);
            if ($rows == 0) {
                print_user_error($orderList);
                $orderList = getOrderList($_POST["orduid"], $nativedb);
            }
        }
    }

if ($process_form == "true" and $submit == "Send Message") {
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

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose, $title, $source, $successLink);

    logSendOrder($dest_id, $orduid, $nativedb, !$noSend);
}elseif ($process_form == "true" and $submit == "Cancel Order") {
# Button has been pressed. First, create the hl7 message
    $message = "o01-cancel";

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

    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose, $title, $source, $successLink);

    logSendOrder($dest_id, $orduid, $nativedb, !$noSend);
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
            <td colspan="3"><b><u>Search for Patients:</u></b></td>
        </tr>
        <tr>
            <td align="left" valign="top">Patient's lastname begins with </td>
            <td width="5">&nbsp;</td>
            <td align=left valign="top"><input type=text name="last_name" value="<?=$_POST["last_name"]?>">  </td>
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
            <td align="left" valign="top">Please select Order</td>
			<td width="5">&nbsp;</td>
            <td align=left>
                <?= $orderList ?>
			</td>
		</tr>
        <tr>
            <td align="left">Destination</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="dest_id">
                <? getDestinationList($_POST["dest_id"], $nativedb) ?>
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
		<!--
        <tr>
            <td align="left">Do Not Send Message</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type="checkbox" name="noSend" value="noSend"></td>
		</tr>
		-->
		<tr>
            <td colspan=3 align=center>
            <input type="submit" name="cancel" value="Cancel">&nbsp;&nbsp;&nbsp;<input type="reset" value="Reset">&nbsp;&nbsp;&nbsp;<input type=submit name="submit" value="Send Message">&nbsp;&nbsp;&nbsp;<input type=submit name="submit" value="Cancel Order">
            </td>
        </tr>
        <tr>
            <td colspan=3 align=center>
            &nbsp;
            </td>
        </tr>
    </table>
<?php } ?>
<? include "footer.inc" ?>

</body>
</html>
