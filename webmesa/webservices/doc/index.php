<?php 
    $title = "MESA Web Services"; 
    require "common_functions.inc";
    check_user_is_logged_in();
?>

<html>
<head>
<title><?=$title?></title>
</head>
<body>

<?php 
    print_header($title);
    add_navigation($title);
?>

<p><b>Documentation</b>
<ul>
<li> <a href="RIS_Mall_Users_Guide.pdf"> RIS Mall Users Guide</a> 
</ul>
<!--
<p><b>Administrator Use Only</b>
<ul>
<li> <a href="secure/PhpPgAdmin_stub.php">Administer DB</a>
<li> <a href="secure/add_user.php">Add/Change User</a>
</ul>
--!>
<?php end_navigation?>
</body>
</html>
