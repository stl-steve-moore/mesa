<?php
    require "global.inc";
    if (!empty($_POST["adtSelection"])) {
	$source = $_POST["source"];
	$source = stripslashes($source);
        //echo $_POST["actor"];
        switch ($_POST["adtSelect"]) {
            case "adt_1":
                header("Location:create_patient.php?source=$source");
                break;
            case "adt_2":
                header("Location:create_patient.php?source=$source");
                break;
            case "adt_3":
                header("Location:send_order.php?source=$source");
                break;
            case "adt_4":
                header("Location:create_visit.php?source=$source");
                break;
	    default:
		header("index.php");
        }
    }
?>
