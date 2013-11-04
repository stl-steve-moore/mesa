<?php 
	require "global.inc";
    $header = "MESA RIS Mall"; 
    $title_no_link = "MESA RIS Mall:: Order Placer"; 
	$title = "<a href=\"index.php\">MESA RIS Mall</a>:: Order Placer";
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

<form action="ordplc.php" method="post">
    <input type="hidden" name="source" value="ordplc">
    <table width="820" bgcolor="FFF8CE" border="0">
        <tr>
            <td bgcolor="#FFD557" colspan="4">
            <?php print_top_nav($title); ?>
            </td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td colspan="3">
		<br>Please select a task from the action list below and click the Submit button.<br>
	    </td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="ordplcSelect" value="ordplc_5"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Visit: Send A01, A04 (Admit/Registration Message)&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="ordplcSelect" value="ordplc_6"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Visit: Send A03 (Discharge Message)</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="ordplcSelect" value="ordplc_7"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient: Send A08 (Rename Message)</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="ordplcSelect" value="ordplc_8"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient: Send A40 (Merge Message)</td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="ordplcSelect" value="ordplc_4"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient: Create Visit</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="ordplcSelect" value="ordplc_2"></td>
            <td width="5">&nbsp;</td>
            <td align=left>New Patient: Create Patient</td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8">&nbsp;</td>
            <td colspan="2"><input type="submit" name="cancel" value="Cancel">&nbsp;&nbsp;&nbsp;<input type="submit" name="ordplcSelection" value="Submit"></td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
    </table>
</form>

<? include "footer.inc" ?>

</body>
</html>
