<?php
	include "user.inc";
	include "header.inc";
	include "db.inc";

	// Clear out the PHP Session
	session_start();
	$_SESSION = array();
	session_destroy();
	
	print_login_form();
	print "\n</body>\n</html>";
?>
