<?php

// The image dir, a document (server) path, is x/doc/images, where
// x may vary by installation.
$pathElements = explode("/", $_SERVER{"SCRIPT_NAME"});
$imageDir = "/" . $pathElements[1] . "/doc/images";

function print_header($title) {
    global $imageDir;
?>
<table width="100%">
<tr><td>
    <img src="<?=$imageDir?>/IHE.jpg" width="150" height="114" border="0"></td>
<td>
<h1><?=$title?></h1>
</td>
<td align="right"><img src="<?=$imageDir?>/MIR.jpg" alt="MIR"></td></tr>
</table>
<?php
}

function link_to_main() {
?>
<table width=100%>
<tr><br></tr>
<tr>
    <td align=center>
    <h5><a HREF="index.php">Return to Main Menu</a></h5>
    </td>
</tr>
</table>
<?
}
?>
