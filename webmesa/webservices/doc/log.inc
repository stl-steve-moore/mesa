<?php

// This file contains functions and definitions related to logging of user actions
// The database used is currently ris_mall_test
// Currently the script which creates these tables is bin/fillLogTables.pl

$logDB = "ris_mall";

# Required fields for tasks:
# Create Patient:         PatKey, DBName, DBMod
# Create Visit:           VisKey, DBName, DBMod
# Send Admit/Register:    VisKey, DestID, DBName, MsgSnt
# Send Discharge:         VisKey, DestID, DBName, MsgSnt
# Send Rename:            PatKey, DestID, OldNam, DBName, DBMod, MsgSnt
# Send Merge:             PatKey, DestID, OldNam, DBName, DBMod, MsgSnt
# Create Order:           OrdUID, DBName, DBMod
# Send Order:             DestID, OrdUID, DBName, MsgSnt
# Schedule Req. Proc.:    MWLUID, DBName, DBMod
# Send Req. Proc.:        DestID, MWLUID, DBName, MsgSnt
# User Login:
# DB Admin:
#
# DBMod indicates if the database was successfully modified in this transaction.
# MsgSnt indicates if a message was successfully sent in this transaction.
# DBName is the name of the database the various keys (patkey, viskey, etc) refer
# to.

# This function returns the user name, the current timestamp and the IP
# address and hostname (if available) of the connecting host. Unpack as,
#   list($user_name, $timestamp, $ip, $hostname) = getLogInfo(); 
function getLogInfo() {
    if (!user_isloggedin()) 
        trigger_error("User not logged in! This shouldn't happen...", 
                E_USER_WARNING); 
    $user_name = $_SESSION["ris_user_name"];
# timestamp will be in ISO-8601 format: "1999-01-08 04:05:06"
    $timestamp = strftime("%Y-%m-%d %H:%M:%S");
    $ip = $_SERVER["REMOTE_ADDR"];
    $hostname = $_SERVER["REMOTE_HOST"];
    return array($user_name, $timestamp, $ip, $hostname);
}

# returns the id of a given task field.  Dies if fieldName is not known in TaskFields
# table.
function getFieldID($fieldName, $db_connection = "") {
    static $fieldhash;
    global $logDB;
    $passedDB = $db_connection != "";
    if (empty($fieldhash)) {
        if (!$passedDB)
            $db_connection = connectDB($logDB);
        $query = "SELECT task_field_id, field_name FROM TaskFields";
        $result = pg_exec($db_connection, $query) or die("Error in query (db='$db'):" .
               " $query" . pg_errormessage($db_connection));

        $rows = pg_numrows($result);
        for ($i=0; $i<$rows; $i++) {
            $row = pg_fetch_array($result, $i, PGSQL_ASSOC);
            $fieldhash[$row['field_name']] = $row['task_field_id'];
        }
        if (!$passedDB)
            pg_close($db_connection);
    }
    if (!isset($fieldhash[$fieldName]))
        die("Unknown field name: $fieldName"); // this is a config error.
    return $fieldhash[$fieldName];
}

# returns the id of a given task type.  Dies if taskType is not known in TaskTypes
# table.
function getTaskID($taskName, $db_connection = "") {
    static $taskhash;
    global $logDB;
    $passedDB = $db_connection != "";
    if (empty($taskhash)) {
        if (!$passedDB)
            $db_connection = connectDB($logDB);
        $query = "SELECT task_type_id, task_name FROM TaskTypes";
        $result = pg_exec($db_connection, $query) or die("Error in query (db='$logDB'): " .
                "$query" . pg_errormessage($db_connection));

        $rows = pg_numrows($result);
        for ($i=0; $i<$rows; $i++) {
            $row = pg_fetch_array($result, $i, PGSQL_ASSOC);
            $taskhash[$row['task_name']] = $row['task_type_id'];
        }
        if (!$passedDB)
            pg_close($db_connection);
    }
    if (!isset($taskhash[$taskName]))
        die("Unknown task name: $taskName"); // this is a config error.
    return $taskhash[$taskName];
}

function insertLogEntry($db_connection, $task) {
    $task_type_id = getTaskID($task, $db_connection);
    list($user_name, $timestamp, $ip, $hostname) = getLogInfo(); 

    $query = "INSERT INTO LogEntry (user_name, timestamp, ip, host, task_type_id) " .
        "values ('$user_name', '$timestamp', '$ip', '$hostname', '$task_type_id')";
    pg_exec($db_connection, $query) or die("Error in query (db='" .
            pg_dbname($db_connection) . "'): $query " .
            pg_errormessage($db_connection));
}

function insertLogData($db_connection, $log_id, $task_field_name, $field_value) {
    $task_field_id = getFieldID($task_field_name, $db_connection);
    $query = "INSERT INTO LogData (log_id, task_field_id, field_value) " .
        "values ('$log_id', '$task_field_id', '$field_value')";
    pg_exec($db_connection, $query) or die("Error in query (db='" .
            pg_dbname($db_connection) . "'): $query " .
            pg_errormessage($db_connection));
}

function logCreatePatient($patkey, $dbname, $dbmod) { 
    global $logDB;
    $task = "Create Patient";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "PatKey", $patkey);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "DBMod", $dbmod ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logCreateVisit($viskey, $dbname, $dbmod) {
    global $logDB;
    $task = "Create Visit";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "VisKey", $viskey);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "DBMod", $dbmod ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logSendAdmit($viskey, $destid, $dbname, $msgsnt) {
    global $logDB;
    $task = "Send Admit/Register";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "VisKey", $viskey);
    insertLogData($db_connection, $log_id, "DestID", $destid);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "MsgSnt", $msgsnt ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logSendDischarge($viskey, $destid, $dbname, $msgsnt) {
    global $logDB;
    $task = "Send Discharge";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "VisKey", $viskey);
    insertLogData($db_connection, $log_id, "DestID", $destid);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "MsgSnt", $msgsnt ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logSendRename($patkey, $destid, $oldnam, $dbname, $dbmod, $msgsnt) {
    global $logDB;
    $task = "Send Rename";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "PatKey", $patkey);
    insertLogData($db_connection, $log_id, "DestID", $destid);
    insertLogData($db_connection, $log_id, "OldNam", $oldnam);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "DBMod", $dbmod ? "TRUE" : "FALSE");
    insertLogData($db_connection, $log_id, "MsgSnt", $msgsnt ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logSendMerge($patkey, $destid, $oldnam, $dbname, $dbmod, $msgsnt) {
    global $logDB;
    $task = "Send Merge";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "PatKey", $patkey);
    insertLogData($db_connection, $log_id, "DestID", $destid);
    insertLogData($db_connection, $log_id, "OldNam", $oldnam);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "DBMod", $dbmod ? "TRUE" : "FALSE");
    insertLogData($db_connection, $log_id, "MsgSnt", $msgsnt ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logCreateOrder($orduid, $dbname, $dbmod) {
    global $logDB;
    $task = "Create Order";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "OrdUID", $orduid);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "DBMod", $dbmod ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logSendOrder($destid, $orduid, $dbname, $msgsnt) {
    global $logDB;
    $task = "Send Order";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "DestID", $destid);
    insertLogData($db_connection, $log_id, "OrdUID", $orduid);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "MsgSnt", $msgsnt ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logScheduleProcedure($mwluid, $dbname, $dbmod) {
    global $logDB;
    $task = "Schedule Req. Proc.";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "MWLUID", $mwluid);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "DBMod", $dbmod ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

# only allows one mwl for now...
function logSendSchedule($destid, $mwluid, $dbname, $msgsnt) {
    global $logDB;
    $task = "Send Req. Proc.";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    insertLogData($db_connection, $log_id, "DestID", $destid);
    insertLogData($db_connection, $log_id, "MWLUID", $mwluid);
    insertLogData($db_connection, $log_id, "DBName", $dbname);
    insertLogData($db_connection, $log_id, "MsgSnt", $msgsnt ? "TRUE" : "FALSE");
    pg_close($db_connection);
}

function logUserLogin() {
    global $logDB;
    $task = "User Login";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    pg_close($db_connection);
}

function logDbAdmin() {
    global $logDB;
    $task = "DB Admin";
    $db_connection = connectDB($logDB);

    insertLogEntry($db_connection, $task);
    $log_id = getCurrentLogID($db_connection);

    pg_close($db_connection);
}

?>
