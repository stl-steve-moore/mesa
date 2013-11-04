<?php 
    $title = "MESA RIS Mall"; 
    $header = "MESA RIS Mall:: ADT"; 
    require "common_functions.inc";
    check_user_is_logged_in();
?>

<html>
<head>
  <title><?=$title?></title>
  <link href="include/general.css" type="text/css" rel="Stylesheet" rev="Stylesheet" media="all">
</head>
<body>

<?php 
    print_header($title);
?>

<form action="adt.php" method="post">
    <input type="hidden" name="source" value="adt">
    <table width="720" bgcolor="FFF8CE" border="0">
        <tr>
            <th bgcolor="FFD557" colspan="4"><?= $header; ?></th>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td colspan="3">
		blurb...blurb...blurb...<br>
		blurb...blurb...blurb...<br>
		blurb...blurb...blurb...<br>
	    </td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="adtSelect" value="adt_1" checked></td>
            <td width="5">&nbsp;</td>
            <td align=left>Create a Patient</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="adtSelect" value="adt_2"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Create</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="adtSelect" value="adt_3"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Create</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="adtSelect" value="adt_4"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Create</td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8">&nbsp;</td>
            <td colspan="2"><input type="submit" name="adtSelection" value="Submit"></td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
    </table>
</form>

<? include "footer.inc" ?>

</body>
</html>
