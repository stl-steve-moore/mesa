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
            case "pdc_1":
                header("Location:create_patient.php?source=$source");
                break;
            case "pdc_2":
                header("Location:send_iti-8-a04.php?source=$source");
                break;
	    	default:
				header("Location:pdc_main.php");
        }
    }
?>
