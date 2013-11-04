<?php
	$logged_in = false;
	$hash_salt = "Try these bath salts to relax";
	$userdb = "ris_mall"; 
	$require_pw = false;    # disables passwords
// This file contains functions and definitions related to handling user logins.
// The database used is currently ris_mall, and the user table is taken from
// the webtool application.
// With thanks to Eric Poiseau

function print_login_form(){
	$title = "RIS Mall::Login";
    global $require_pw;

    $db_connection = connectDB("ris_mall");
    $query = "SELECT user_name from user_table " .
        "ORDER BY user_name";
    $result = pg_exec($db_connection, $query) or
         die("Error in query (db='$db'): $query" .
            pg_errormessage($db_connection));

    $rows = pg_numrows($result);

    if ($rows > 0) {
        $userList = "<select name=\"form_user_name\" size=1>\n";
        $userList .= "<option value=\" \">Select user\n";

        for ($i=0; $i<$rows; $i++) {
            $row = pg_fetch_array($result, $i, PGSQL_ASSOC);
            $name = rtrim($row['user_name']);
            $userList .= "<option value=$name>$name\n";
        }
        $userList .= "</select>\n";
    }

    // close database connection
    pg_close($db_connection);
?>

<html>
<head>
  <title><?=$title?></title>
  <link href="include/general.css" type="text/css" rel="Stylesheet" rev="Stylesheet" media="all">
</head>
<body>

<?php print_header($header); ?>

<form action="index.php" method="post">
<!-- <form action="<?=$PHP_SELF?>" method="post"> -->
<!-- <P><a id="login"></a> -->
<table width="820" bgcolor="FFF8CE" border="0" cellspacing="2" cellpadding="2">
<tr>
	<th bgcolor="FFD557" colspan="3"><?= $title; ?></th>
</tr>
<tr>
    <td colspan=3 align=center>
    &nbsp;
    </td>
</tr>
<tr>
	<td width="340" align="right" valign="top">
		<b>Login</b>
	</td>
	<td width="5">&nbsp;</td>
	<td align="left">
	<?= $userList ?>
	</td>
</tr>
	<? if ($require_pw) { ?>
<tr>
	<td align="right"><b>Password</b></td>
	<td width="5">&nbsp;</td>
	<td>
    <input type="password" NAME="password" VALUE="" SIZE="10" MAXLENGTH="15">
	</td>
</tr>
<? } ?>
<tr>
	<td colspan=3 align=center>
	&nbsp;
	</td>
</tr>
<tr>
	<td width="340" align="right">
		&nbsp;
	</td>
	<td width="5">&nbsp;</td>
	<td align="left">
		<input type="submit" name="submit" value="Login" tabindex="0">
	</td>
</tr>
<tr>
	<td colspan=3 align=center>
	&nbsp;
	</td>
</tr>
</table>
</form>
<?
} 

// This function checks if the user has logged in already.  It does so by
// seeing if the $ris_user_name session variable is set, and if so, if it
// is valid.  If both are true, then the user is logged in.
// Validity is checked by comparing the $ris_user_hash variable the user has
// with the value it ought to have; this hash is created by concatenating the
// user's name with a hash salt variable the user does not know.  If the 
// calculated hash and the user's hash compare, the user must have gotten the
// hash from us previously.
function user_isloggedin() {
    global $logged_in, $hash_salt;

    // If performed the check already, don't do it again.
    if ($logged_in == true) {
        return true;
    }

    $user_name = $_SESSION["ris_user_name"];
    $user_hash = $_SESSION["ris_user_hash"];

    if ($user_name && $user_hash) {
        $hash=md5($user_name.$hash_salt);
        if (strcmp($hash, $user_hash)) {
            $logged_in = true;
            return true;
        } 
    }
    return false;
}

// This is a top-level function typically called at the beginning of a page
// which needs to have the user logged in.  The value of the $submit 
// action variable is passed.
// This function returns only if the user is validated and logged in and exits 
// otherwise.  The flow goes as,
// 1. Check if the user is already logged in by checking session variables.  If
//    the user is logged in, exit this function and continue with the page.
// 2. If the user is not logged in, the login page will be displayed.
// 3. If the login page has been displayed and the user has filled it in, 
//      a) confirm that all fields filled in
//      b) check the user's name and md5(password) against values in database
//      c) if they match, set the session variables to indicate that user is
//         logged in.  These will be used to indicate that user is logged in
//         in the future.
//      d) if they do not match, indicate error and exit.
//
// Please note that common_functions.inc needs to be imported, and 
// session_start() needs to be called before this function is called.
function check_user_is_logged_in() {
    global $userdb, $logged_in, $require_pw;
    if (!session_is_registered("ris_user_name")) {
        session_register('ris_user_name');
        session_register('ris_user_hash');
    } 

    if (user_isloggedin()) return;

    // If this is not the result of a POST, exit here and allow the user 
    // to log in.
    if (empty($_POST["submit"])) {
        print_login_form();
		print "\n</body>\n</html>";
        exit;
    }

    // check the login.
    $user_name = $_POST["form_user_name"];
    $password = $_POST["password"];
    if ($require_pw) {
        if (!$user_name || !$password) {
            print_login_form();
            print_user_error("Missing user name or password");
			print "\n</body>\n</html>";
            exit;
        }
    } else {
        if (!$user_name) {
            print_login_form();
            print_user_error("Please select a user from the drop-down list");
			print "\n</body>\n</html>";
            exit;
        }
    }
    if (!confirm_user_name_password($userdb, $user_name, $password, 
                $require_pw)) {
        if ($require_pw)
            print_user_error("Unknown user name or password");
        else
        	print_login_form();
            print_user_error("Please select a user from the drop-down list");
			print "\n</body>\n</html>";
        exit;
    }

    $user_hash=md5($ris_user_name.$hash_salt);

    $_SESSION["ris_user_name"] = $user_name;
    $_SESSION["ris_user_hash"] = $user_hash;
    $logged_in = true;
    logUserLogin();
}
?>
