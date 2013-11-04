<?php
    $header = "MESA RIS Mall";
    $title = "<a href=\"index.php\">MESA RIS Mall</a>:: Actions";
    $title_no_link = "MESA RIS Mall:: Actions";
    require "common_functions.inc";
    check_user_is_logged_in();
?>

<html>
<head>
  <title><?= $title_no_link ?></title>
  <link href="include/general.css" type="text/css" rel="Stylesheet" rev="Stylesheet" media="all">
</head>
<body>

<?php 
    print_header($header);
?>

<table width="820" bgcolor="FFF8CE" border="0">
<tr>
	<td bgcolor="#FFD557" colspan="2">
	<?php print_top_nav($title); ?>
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
<tr>
	<td>
<p><b>ADT</b>
<ul>
<li> <a href="create_patient.php?source=unspecified">Create a Patient</a></li>
<li> <a href="create_visit.php?source=unspecified">Create a Visit</a>
<li> <a href="send_admit.php?source=unspecified">Send Admit/Registration Message</a>
<li> <a href="send_discharge.php?source=unspecified">Send Discharge Message</a>
<li> <a href="send_rename.php?source=unspecified">Send Rename Message</a>
<li> <a href="send_merge.php?source=unspecified">Send Merge Message</a>
</ul>

<p><b>Order Placer</b>
<ul>
<li> <a href="create_order.php?source=unspecified">Create an Order</a>
<li> <a href="send_order.php?source=unspecified">Send/Cancel an Order Message</a>
</ul>

<p><b>Order Filler</b>
<ul>
<li> <a href="schedule_procedure.php?source=unspecified">Schedule a Requested Procedure</a>
<li> <a href="send_schedule.php?source=unspecified">Send a Scheduling Message</a>
</ul>

<!--
<p><b>Administrator Use Only</b>
<ul>
<li> <a href="secure/PhpPgAdmin_stub.php">Administer DB</a>
<li> <a href="secure/add_user.php">Add/Change User</a>
</ul>
-->
	</td>
</tr>
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</body>
</html>
