<?php
    require "global.inc";
    require "common_functions.inc";
    $nativedb = "webof";
    $source = $_GET["source"];
    $printSource = $actor{$source};
    $actorLink = $actor_link{$source};
    $successLink = $schedule_procedure_link{$source};
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: <a href=\"$actorLink\">$printSource</a>:: Schedule a Requested Procedure";
    $title_no_link = "MESA RIS Mall:: ". $printSource . " :: Schedule a Requested Procedure";
    $header = "MESA RIS Mall";
	
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
    if ($submit == "Create") {
        if (empty($_POST["orduid"])) {
            print_user_error("Please select Procedure."); 
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

if ($process_form == "true" and $submit == "Create") {

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
    $spsstadat = rtrim($_POST["spsstadat"]);
    $spsstatim = rtrim($_POST["spsstatim"]);
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
    print_success_message($title, "Successfully Scheduled Requested Procedure.", $successLink);
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
            <td align="left" valign="top">Please select a Requested Procedure</td>
			<td width="5">&nbsp;</td>
            <td align=left>
				<?= $orderList ?>
			</td>
		</tr>
        <tr>
            <td align="left">Scheduled System Name (AE Title)</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="ScheduledSystemAET"> 
            <?php  
                $fn = "../config/schaet.txt";
                configFileOptions($fn, $_POST["ScheduledSystemAET"]);
            ?>
            </select>  
			</td>
		</tr>
        <tr>
            <td align="left">SPS Start Date</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type=text name="spsstadat"
                value="<? echo `perl ../bin/getMesaInfo.pl date`?>">
			</td>
		</tr>
        <tr>
            <td align="left">SPS Start Time</td>
			<td width="5">&nbsp;</td>
            <td align=left><input type=text name="spsstatim"
                value="<? echo `perl ../bin/getMesaInfo.pl time`?>">
			</td>
		</tr>
        <tr>
            <td align="left">Modality</td>
			<td width="5">&nbsp;</td>
            <td align=left><select name="mod"> 
            <?php  
                $fn = "../config/mod.txt";
                configFileOptions($fn, $_POST["mod"]);
            ?>
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
		<tr>
            <td colspan="3" align=center>
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
<?php
	}

include "footer.inc" ?>
</body>
</html>
