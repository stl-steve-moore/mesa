<?php
    require "global.inc";
	if (!empty($_POST["cancel"])) {
        header("Location:index.php");
    }
    if (!empty($_POST["modSelection"])) {
	$source = $_POST["source"];
	$source = stripslashes($source);
        //echo $_POST["actor"];
        switch ($_POST["modSelect"]) {
            case "acqmod_1":
                header("Location:create_patient.php?source=$source");
                break;
            case "acqmod_7":
                header("Location:create_visit.php?source=$source");
                break;
            case "acqmod_2":
                header("Location:create_order.php?source=$source");
                break;
            case "acqmod_3":
                header("Location:send_admit.php?source=$source");
                break;
            case "acqmod_4":
                header("Location:schedule_procedure.php?source=$source");
                break;
            case "acqmod_5":
                header("Location:send_order.php?source=$source");
                break;
            case "acqmod_6":
                header("Location:send_admit.php?source=$source&next=acqmod");
                break;
	    	default:
				header("Location:acqmod_main.php");
        }
    }
?>
