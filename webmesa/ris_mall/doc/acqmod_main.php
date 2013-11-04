<?php 
	require "global.inc";
    $header = "MESA RIS Mall"; 
    $title_no_link = "MESA RIS Mall:: Acquisition Modality"; 
	$title = "<a href=\"index.php\">MESA RIS Mall</a>:: Acquisition Modality";
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

<form action="acqmod.php" method="post">
    <input type="hidden" name="source" value="acqmod">
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
            <td width="8" align="center"><input type="radio" name="modSelect" value="acqmod_1"></td>
            <td width="5">&nbsp;</td>
            <td align=left>New Patient: Create Patient, and Visit</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="acqmod_7"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient: Create Visit, Order.</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="acqmod_2"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient, and Visit: Create Order.</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="acqmod_5"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient, and Order: Send/Cancel Order.</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="acqmod_6"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient, and Visit: Send ADT.</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="acqmod_3"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient, Visit, and Order: Send ADT and ORM to DSS (MESA/Vendor).&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="acqmod_4"></td>
            <td width="5">&nbsp;</td>
            <td align=left>Existing Patient, Visit, and Order: Schedule MWL on MESA system.</td>
        </tr>
        <tr>
            <td colspan="4">&nbsp;</td>
        </tr>
		<!--
        <tr>
            <td width="5">&nbsp;</td>
            <td width="8" align="center"><input type="radio" name="modSelect" value="acqmod_5"></td>
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
