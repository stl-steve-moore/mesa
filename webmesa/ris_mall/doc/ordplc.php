<?php
    require "global.inc";
	if (!empty($_POST["cancel"])) {
		header("Location:index.php");
	}
    if (!empty($_POST["ordplcSelection"])) {
		$source = $_POST["source"];
		$source = stripslashes($source);
        //echo $_POST["actor"];
        switch ($_POST["ordplcSelect"]) {
            case "ordplc_2":
                header("Location:create_patient.php?source=$source");
                break;
            case "ordplc_4":
                header("Location:create_visit.php?source=$source");
                break;
            case "ordplc_5":
                header("Location:send_admit.php?source=$source");
                break;
            case "ordplc_6":
                header("Location:send_discharge.php?source=$source");
                break;
            case "ordplc_7":
                header("Location:send_rename.php?source=$source");
                break;
            case "ordplc_8":
                header("Location:send_merge.php?source=$source");
                break;
	    	default:
				header("Location:ordplc_main.php");
        }
    }
?>
