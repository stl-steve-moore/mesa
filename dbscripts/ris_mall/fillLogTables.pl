#!/usr/bin/perl -w
use strict;

use DBI;  #see perldoc DBI, DBD::Pg
use Getopt::Std;

# this script creates and populates the log definition tables.
# We also describe the log schema for us humans.

# there are currently 12 different tasks which the log can keep track
# of, each with zero or more tasks fields which are mandatory for that
# task.  Below are the tasks, and the task fields which are mandatory:

# 1. Create Patient:    PatKey, DBName, DBMod
# 2. Create Visit:      VisKey, DBName, DBMod
# 3. Admit/Reg:         VisKey, DestID, DBName, MsgSnt
# 4. Discharge:         VisKey, DestID, DBName, MsgSnt
# 5. Rename:            PatKey, DestID, OldNam, DBName, DBMod, MsgSnt
# 6. Merge:             PatKey, DestID, OldNam, DBName, DBMod, MsgSnt
# 7. Create Order:      OrdUID, DBName, DBMod
# 8. Send Order:        DestID, OrdUID, DBName, MsgSnt
# 9. Schedule Req Proc: MWLUID, DBName, DBMod
# 10. Send Req Proc:    DestID, MWLUID*, DBName, MsgSnt
# 11. User Login:       
# 12. DB Admin:
#
# Note that all of the fields are single-valued, with the exception of
# the MWLUID field for the Send Req Proc task; in that case, there may be
# one or more MWLUID entries.

# A log entry is produced every time one of the above tasks takes place.  Each
# log entry has the following fields:
#
# LogEntry table:
#   1. LogID
#   2. User Name
#   3. Date and time task takes place
#   4. IP of originating machine
#   5. Hostname of originating machine
#   6. Task Type ID
#   
# The TaskTypes table lists the various tasks (Rename, DB Admin, etc.), as
# indexed by the taskTypeID key.
#
# The various fields (DestID, DBName, etc.) are listed in the TaskFields table,
# accessed by the taskFieldID; the type is also given.
#
# The RequiredTaskFields table makes the many:many association between the 
# various tasks and the fields they are required to carry.
#
# Finally, the LogData table carries the data for a given log entry (logID) and
# a given field (taskFieldID).  While the values have different types, they
# are all written here as character strings.

sub dropTables {
    $main::dbh->do("DROP TABLE LogEntry") or warn $main::dbh->errstr;
    $main::dbh->do("DROP SEQUENCE logentry_log_id_seq") or warn $main::dbh->errstr;
    $main::dbh->do("DROP TABLE LogData") or warn $main::dbh->errstr;
    $main::dbh->do("DROP TABLE TaskTypes") or warn $main::dbh->errstr;
    $main::dbh->do("DROP SEQUENCE tasktypes_task_type_id_seq") or warn $main::dbh->errstr;
    $main::dbh->do("DROP TABLE RequiredTaskFields") or warn $main::dbh->errstr;
    $main::dbh->do("DROP TABLE TaskFields") or warn $main::dbh->errstr;
    $main::dbh->do("DROP SEQUENCE taskfields_task_field_id_seq") or warn $main::dbh->errstr;
    $main::dbh->do("DROP VIEW LogEntryView") or warn $main::dbh->errstr;
    $main::dbh->do("DROP VIEW LogDataView") or warn $main::dbh->errstr;
}

sub createTables {

    my $TaskTypes = <<SQL;
CREATE TABLE TaskTypes (
        task_type_id  SERIAL PRIMARY KEY,
        task_name    varchar(32)
        );
SQL

    my $TaskFields = <<SQL;
CREATE TABLE TaskFields (
        task_field_id SERIAL PRIMARY KEY,
        field_name   varchar(16),
        data_type    varchar(16)
        );
SQL

    my $LogEntry = <<SQL;
CREATE TABLE LogEntry (
        log_id      SERIAL PRIMARY KEY,
        user_name   varchar(64),
        timestamp   timestamp,
        host        varchar(64),
        ip          inet,
        task_type_id  int REFERENCES TaskTypes
        );

CREATE INDEX LogEntry_log_id_index on LogEntry (log_id);
SQL

    my $RequiredTaskFields = <<SQL;
CREATE TABLE RequiredTaskFields (
        task_type_id  int REFERENCES TaskTypes,
        task_field_id int REFERENCES TaskFields
        );
SQL

    my $LogData = <<SQL;
CREATE TABLE LogData (
        log_id       int REFERENCES LogEntry,
        task_field_id int REFERENCES TaskFields,
        field_value  varchar(64)
        );

CREATE INDEX LogData_log_id_index on LogData (log_id);
SQL

    my $LogView = <<SQL;
CREATE VIEW LogDataView AS
SELECT 
    LogEntry.log_id, 
    task_name, 
    user_name, 
    timestamp, 
    host, 
    ip, 
    field_name, 
    field_value 
FROM 
    LogEntry,
    LogData, 
    TaskFields, 
    TaskTypes 
WHERE 
    LogEntry.task_type_id = TaskTypes.task_type_id
    AND LogData.log_id = LogEntry.log_id
    AND TaskFields.task_field_id = LogData.task_field_id
ORDER BY log_id ASC;

CREATE VIEW LogEntryView AS
SELECT 
    LogEntry.log_id, 
    task_name, 
    user_name, 
    timestamp, 
    host, 
    ip 
FROM 
    LogEntry,
    TaskTypes 
WHERE 
    LogEntry.task_type_id = TaskTypes.task_type_id
ORDER BY log_id ASC;
SQL


    $main::dbh->do($TaskTypes) or die $main::dbh->errstr;
    $main::dbh->do($TaskFields ) or die $main::dbh->errstr;
    $main::dbh->do($LogEntry) or die $main::dbh->errstr;
    $main::dbh->do($RequiredTaskFields ) or die $main::dbh->errstr;
    $main::dbh->do($LogData) or die $main::dbh->errstr;
    $main::dbh->do($LogView) or die $main::dbh->errstr;
}

sub fillTables {

    my $taskTypes = <<SQL;
Create Patient
Create Visit
Send Admit/Register
Send Discharge
Send Rename
Send Merge
Create Order
Send Order
Schedule Req. Proc.
Send Req. Proc.
User Login
DB Admin
SQL

    my $taskFields = <<SQL;
PatKey,     int
VisKey,     int
DestID,     int
OldNam,     varchar(64)
OrdUID,     int
MWLUID,     int
DBName,     varchar(32)
DBMod,      bool
MsgSnt,     bool
MWLUID2,    int
MWLUID3,    int
MWLUID4,    int
MWLUID5,    int
MWLUID6,    int
MWLUID7,    int
MWLUID8,    int
MWLUID9,    int
SQL

    my $requiredTaskFields = <<SQL;
Create Patient:         PatKey, DBName, DBMod
Create Visit:           VisKey, DBName, DBMod
Send Admit/Register:    VisKey, DestID, DBName, MsgSnt
Send Discharge:         VisKey, DestID, DBName, MsgSnt
Send Rename:            PatKey, DestID, OldNam, DBName, DBMod, MsgSnt
Send Merge:             PatKey, DestID, OldNam, DBName, DBMod, MsgSnt
Create Order:           OrdUID, DBName, DBMod
Send Order:             DestID, OrdUID, DBName, MsgSnt
Schedule Req. Proc.:    MWLUID, DBName, DBMod
Send Req. Proc.:        DestID, MWLUID, DBName, MsgSnt
User Login:
DB Admin:
SQL

    my $sth = $main::dbh->prepare("INSERT INTO TaskTypes (task_name) values (?)");
    foreach my $l (split /\n/, $taskTypes) {
        $sth->execute($l);
    }
        
    $sth = $main::dbh->prepare("INSERT INTO TaskFields (field_name, data_type) " .
            "values (?, ?)");
    foreach my $l (split /\n/, $taskFields) {
        # take out the whitespace from each element...
        my @t = split /,/, $l;
        foreach my $e (@t) {
            $e =~ s/^\s+//;  # remove leading space
            $e =~ s/\s+$//;  # remove trailing space
        }
        $sth->execute(@t);
    }

    $sth = $main::dbh->prepare("INSERT INTO RequiredTaskFields " .
            "(task_type_id, task_field_id) values (?, ?)");
    foreach my $l (split /\n/, $requiredTaskFields) {
        my ($task, $fields) = split /:/, $l;
        my $taskID = getTaskID($task);

        foreach my $f (split /,/, $fields) {
            $f =~ s/^\s+//;  # remove leading space
            $f =~ s/\s+$//;  # remove trailing space
            my $fieldID = getFieldID($f);
            $sth->execute($taskID, $fieldID);
        }
    }
}

    
# get the taskTypeID for a given taskName
sub getTaskID {
    my $taskName = shift;
    my $sth = $main::dbh->prepare("SELECT task_type_id FROM TaskTypes WHERE task_name = ?");
    $sth->execute($taskName);
    die ("Found ".$sth->rows." for task $taskName.") if $sth->rows != 1;
    my $id = $sth->fetchrow_array;
    return $id;
}

# get the taskFieldID for a given fieldName
sub getFieldID {
    my $fieldName = shift;
    my $sth = $main::dbh->prepare("SELECT task_field_id FROM TaskFields WHERE field_name = ?");
    $sth->execute($fieldName);
    die ("Found ".$sth->rows." for field $fieldName") if $sth->rows != 1;
    my $id = $sth->fetchrow_array;
    return $id;
}

sub usage {
    print "Usage: perl fillLogTables.pl [-h] [-d] database\n";
    print " -h Prints this help message.\n";
    print " -d Do not drop the tables before creating them.\n";
    print " database The database which contains tables to be created and filled.\n";
    exit;
}

use vars qw($opt_h $opt_d);
usage() if not getopts("hd");
usage() if $opt_h;

# Config settings
#
my $dbname = shift or usage();

# Connect to database
#
$main::dbh = DBI->connect("dbi:Pg:dbname=$dbname", "", "", {AutoCommit=>1, RaiseError=>0}) 
        or die "Error: Couldn't open connection: ".$DBI::errstr;

dropTables() unless $opt_d;
createTables();
fillTables();

$main::dbh->disconnect;
exit;
