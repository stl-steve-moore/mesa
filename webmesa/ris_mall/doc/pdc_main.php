<?php 
	require "global.inc";
    $header = "MESA RIS Mall"; 
    $title_no_link = "MESA RIS Mall:: Patient Demographics Consumer"; 
	$title = "<a href=\"index.php\">MESA RIS Mall</a>:: Patient Demographics Consumer";
    require "common_functions.inc";
    check_user_is_logged_in();
?>

<html>
<head>
  <title><?=$title_no_link?></title>
  <link href="include/general.css" type="text/css" rel="Stylesheet" rev="Stylesheet" media="all">
</head>
<body>

<?php 
    print_header($header);
?>

<form action="pdc.php" method="post">
    <input type="hidden" name="source" value="pdc">
    <table width="820" bgcolor="FFF8CE" border="0">
		<tr>
            <td bgcolor="#FFD557" colspan="4">
            <?php print_top_nav($title); ?>
            </td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td colspan="3">
			<br>
			Please select a task below and click the Submit button.
	    </td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="pdc_1"></td>
            <td width="5">&nbsp;</td>
            <td align=left>New Patient: Create Patient</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="pdc_2"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient: Send ITI-8-A04 message.</td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
		<!--
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="pdc_5"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Delete worklist entry.</td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
		-->
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8">&nbsp;</td>
            <td colspan="2"><input type="submit" name="cancel" value="Cancel">&nbsp;&nbsp;&nbsp;<input type="submit" name="modSelection" value="Submit"></td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
    </table>
</form>

<? include "footer.inc" ?>

</body>
</html>
