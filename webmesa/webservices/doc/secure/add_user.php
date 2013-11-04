<?php 
    $title = "Add/Modify user";
    $nativedb = "ris_mall";

    chdir('..') or die("cannot cd ..");
    require "common_functions.inc";
?>

<html>
<head>
<title><?=$title?></title>
</head>
<body>

<?php 
    print_header($title);
    link_to_main();

    $submit = $_POST["submit"];
    if ($submit == "Create/Modify") {
        $db_connection = connectDB($nativedb);
        $user_name = $_POST["user_name"];
        $real_name = $_POST["real_name"];
        $newpwd = $_POST["newpwd"];
        $pwmd5 = md5($newpwd);
        $verbose = $_POST["verbose"];

        // first, check to see if existing user_name exists.  If
        // it does, change the password.  If it does not, add this 
        // record.
        $query = "SELECT * FROM user_table WHERE user_name = '$user_name'";
        $result = pg_exec($db_connection, $query) or 
                die("Error in query (db='$db'): $query" .
                pg_errormessage($db_connection));
        $rows = pg_numrows($result);

        if ($verbose)
            print "<pre>Query: \n$query\nYielded $rows results.\n";

        if ($rows == 0) {
            $query = "INSERT INTO user_table " .
                "(user_name, real_name, password) VALUES " . 
                "('$user_name', '$real_name', '$pwmd5')";
        } else {
            $query = "UPDATE user_table SET user_name = '$user_name', " . 
                "real_name = '$real_name', password = '$pwmd5' WHERE " .
                "user_name = '$user_name'";
        }

        if ($verbose) {
            echo "Query:\n";
            echo "$query\n</pre>";
        }

        $result = pg_exec($db_connection, $query) or 
            die("Error in query (db = $nativedb): $query" . 
                    pg_errormessage($db_connection));
        
        pg_close($db_connection);

        print_success_message("Successfully added User Record");
    }
?>
    
<form action="<?php $PHP_SELF;?>" method="post">
    <table>
        <tr>
            <th align=right>User Name:
            <td align=left><input type=text name="user_name" 
                value="<?=$_POST["user_name"]?>">
        <tr>
            <th align=right>Real Name:
            <td align=left><input type=text name="real_name" 
                value="<?=$_POST["real_name"]?>">
        <tr>
            <th align=right>Password:
            <td align=left><input type=password name="newpwd" value="">
        <tr>
            <th align=right>Debugging Output:
            <td align=left><input type="checkbox" name="verbose" value="verbose"
                <?=$_POST["verbose"] ? "checked" : "" ?>>
        <tr>
            <td colspan=2 align=center>
            <input type=submit name="submit" value="Create/Modify">
    </table>
</form>

<? include "footer.inc" ?>

</body>
</html>
