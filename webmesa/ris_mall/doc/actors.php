<?php
    if (!empty($_POST["actorName"])) {
        //echo $_POST["actor"];
        switch ($_POST["actor"]) {
            case "adt":
                header("Location:adt_main.php");
                break;
            case "acqmod":
                header("Location:acqmod_main.php");
                break;
            case "imgmgr":
                header("Location:imgmgr_main.php");
                break;
            case "ordfil":
                header("Location:ordfil_main.php");
                break;
            case "ordplc":
                header("Location:ordplc_main.php");
                break;
            case "pdc":
                header("Location:pdc_main.php");
                break;
            case "old":
                header("Location:unspecified.php");
                break;
			default:
                header("Location:index.php");
        }
    }
?>
