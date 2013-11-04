<?php 
	require "global.inc";
    $header = "MESA RIS Mall"; 
    $title_no_link = "MESA RIS Mall:: Order Filler"; 
	$title = "<a href=\"index.php\">MESA RIS Mall</a>:: Order Filler";
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

<form action="ordfil.php" method="post">
    <input type="hidden" name="source" value="ordfil">
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
            <td><input type="radio" name="ordfilSelect" value="ordfil_3">
            Existing Order: Send existing order from database.</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="radio" name="ordfilSelect" value="ordfil_1">
            Existing Visit, new Order: Create and Send/Cancel Order</td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="radio" name="ordfilSelect" value="ordfil_5">
            Existing Visit: Send A01, A04 (Admit/Registration Message)</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="radio" name="ordfilSelect" value="ordfil_6">
            Existing Visit: Send A03 (Discharge Message)</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="radio" name="ordfilSelect" value="ordfil_7">
            Existing Patient: Send A08 (Rename Message)</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="radio" name="ordfilSelect" value="ordfil_8">
            Existing Patient: Send A40 (Merge Message)</td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="radio" name="ordfilSelect" value="ordfil_4">
            Existing Patient: Create Visit</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="radio" name="ordfilSelect" value="ordfil_2">
            New Patient: Create Patient</td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="submit" name="cancel" value="Cancel">&nbsp;&nbsp;&nbsp;<input type="submit" name="ordfilSelection" value="Submit"></td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
    </table>
</form>

<? include "footer.inc" ?>

</body>
</html>
