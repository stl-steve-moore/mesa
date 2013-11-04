<?php
    require "global.inc";
	if (!empty($_POST["cancel"])) {
		header("Location:index.php");
	}
    if (!empty($_POST["ordfilSelection"])) {
		$source = $_POST["source"];
		$source = stripslashes($source);
        //echo $_POST["actor"];
        switch ($_POST["ordfilSelect"]) {
            case "ordfil_1":
                header("Location:create_order.php?source=$source");
                break;
            case "ordfil_2":
                header("Location:create_patient.php?source=$source");
                break;
            case "ordfil_3":
                header("Location:send_order.php?source=$source");
                break;
            case "ordfil_4":
                header("Location:create_visit.php?source=$source");
                break;
            case "ordfil_5":
                header("Location:send_admit.php?source=$source");
                break;
            case "ordfil_6":
                header("Location:send_discharge.php?source=$source");
                break;
            case "ordfil_7":
                header("Location:send_rename.php?source=$source");
                break;
            case "ordfil_8":
                header("Location:send_merge.php?source=$source");
                break;
	    	default:
				header("Location:ordfil_main.php");
        }
    }
?>
