<?php
    require "global.inc";
	if (!empty($_POST["cancel"])) {
        header("Location:index.php");
    }
    if (!empty($_POST["imgmgrSelection"])) {
	$source = $_POST["source"];
	$source = stripslashes($source);
        //echo $_POST["actor"];
        switch ($_POST["imgmgrSelect"]) {
            case "imgmgr_1":
                header("Location:send_schedule.php?source=$source");
                break;
            case "imgmgr_2":
                header("Location:create_patient.php?source=$source");
                break;
            case "imgmgr_3":
                header("Location:create_visit.php?source=$source");
                break;
            case "imgmgr_4":
                header("Location:send_admit.php?source=$source");
                break;
            case "imgmgr_5":
                header("Location:schedule_procedure.php?source=$source");
                break;
            case "imgmgr_6":
                header("Location:send_rename.php?source=$source");
                break;
            case "imgmgr_7":
                header("Location:send_merge.php?source=$source");
                break;
            case "imgmgr_8":
                header("Location:send_admit.php?source=$source&next=imgmgr");
                break;
	    	default:
				header("Location:imgmgr_main.php");
        }
    }
?>
