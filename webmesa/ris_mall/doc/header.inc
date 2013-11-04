<?php

// The image dir, a document (server) path, is x/doc/images, where
// x may vary by installation.
$pathElements = explode("/", $_SERVER{"SCRIPT_NAME"});
$imageDir = "/" . $pathElements[1] . "/doc/images";

function print_header($header) {
    global $imageDir;
?>
<table border="0" width="820">
<tr>
    <td align="left" valign="middle">
       <img src="<?=$imageDir?>/MIR.jpg" alt="MIR">
    <!-- <img src="<?=$imageDir?>/IHE.jpg" width="150" height="114" border="0"></td> -->
    </td>
    <td align="center">
       <!-- <h2><?=$header?></h2> -->
       &nbsp;
    </td>
    <td align="right">
       <img src="<?=$imageDir?>/IHE_logo.gif" width="60" height="42" border="0">
    </td>
</tr>
</table>
<?php
}

function link_to_main() {
?>
<table width="820" border="0">
<tr>
    <td align="center">
	
    <h5><a HREF="RIS_Mall_Users_Guide.pdf">RIS MALL Users Guide</a></h5>

    </td>
</tr>
</table>
<?
}
?>
