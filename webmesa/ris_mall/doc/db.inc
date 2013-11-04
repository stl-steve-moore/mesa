<?php
$dbuser = "postgres";

function connectDB($db, $host="localhost", $user="", $pass="") {
    global $dbuser;
    if ($user=="") $user = $dbuser;
    if ($pass=="")
        $connect_string = "host=$host user=$user dbname=$db";
    else
        $connect_string = "host=$host user=$user password=$pass dbname=$db";

    $db_connection = pg_connect($connect_string);
    if (!$db_connection) {
        die ("Cannot connect to db='$db' <br>(connect string: $connect_string)");
    }
    return $db_connection;
}
?>
