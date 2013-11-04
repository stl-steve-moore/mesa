<?php 
    $header = "MESA RIS Mall"; 
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: Actors"; 
    $title_no_link = "MESA RIS Mall:: Actors"; 
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

<form action="actors.php" method="post">
    <table width="820" bgcolor="FFF8CE" border="0">
        <tr>
			<td bgcolor="#FFD557" colspan="2">
			<?php print_top_nav($title); ?>
			</td>
        </tr>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td>
			<br>You should enter the Mall as if you are testing one of the IHE actors below.<br>
			That will tailor your selections.
	    	</td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td align="left"><input type="radio" name="actor" value="acqmod">Acquisition Modality</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td align="left"><input type="radio" name="actor" value="imgmgr">Image/Report Manager</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td align="left"><input type="radio" name="actor" value="ordfil">Order Filler</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td align="left"><input type="radio" name="actor" value="ordplc">Order Placer</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td align="left"><input type="radio" name="actor" value="pdc">Patient Demographics Consumer</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td align="left"><input type="radio" name="actor" value="old">Unspecified</td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
            <td width="5">&nbsp;</td>
            <td><input type="submit" name="actorName" value="Submit"></td>
        </tr>
        <tr>
            <td colspan="2">&nbsp;</td>
        </tr>
    </table>
</form>
<? include "footer.inc" ?>
</body>
</html>
