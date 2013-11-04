#!/usr/bin/perl

sub prompt_for_sql_server
{
  my $done = 0;
  my $folder = "";
  print "Default folder for SQL Server is C:\Program Files\Microsoft SQL Server";

  while ($done == 0) {
    print "Enter folder for SQL Server (enter for default) ";
    $folder = <STDIN>;
    if ($folder eq "" || $folder eq "\r" || $folder eq "\n") {
      $folder = "C:\\Program Files\\Microsoft SQL Server";
    }
    if (! -e $folder) {
      print "Folder does not exist: $folder \n\n";
      $done = 0;
    } else {
      $done = 1;
    }
  }
  return $folder;

}

sub processDB
{
  my ($folder, $db) = @_;

  print SQL "DROP DATABASE $db\nGO\n\n";

  print SQL "CREATE DATABASE $db ON (NAME = $db" . "_dat, FILENAME = " .
	"'$folder\\$db.mdf', SIZE=5, MAXSIZE=10, FILEGROWTH=5) \n" .
	"LOG ON (NAME='$db" . "_log', FILENAME=" .
	"'$folder\\$db.ldf', size=5MB, MAXSIZE=10MB, FILEGROWTH=5MB) \n" .
	"GO \n\n";
}

sub addDataFolder
{
  my ($f) = @_;

  $x = $f . "\\MSSQL\\DATA";
  if (-e $x) {
    return $x;
  }

  $x1 = $f . "\\MSSQL.1\\MSSQL\\DATA";
  if (-e $x1) {
    return $x1;
  }

  die "Could find $x nor $x1; this is a bug in our expectation of the SQL Server installation";
}


sub writeSQL
{
  my $folder = shift @_;

  open SQL, ">create_db.sql" or die "Could not open create_db.sql";
  print SQL "USE master\nGO\n";

  while ($db = shift @_) {
    print "$folder $db \n";
    processDB($folder, $db);
  }

  close SQL;
}


  my $serverFolder = prompt_for_sql_server();

  $serverFolder = addDataFolder($serverFolder);

  @dbNames = ("adt", "expmgr", "exprcr", "imgmgr", "info_src",
	"mod1", "mod2", "ordfil", "ordplc", "pd_supplier",
	"rpt_manager", "rpt_repos", "syslog", "wkstation", "xref_mgr");

  writeSQL($serverFolder, @dbNames);


