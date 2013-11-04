#!/usr/bin/perl

sub prompt_for_sql_server
{
  my $done = 0;
  my $folder = "C:\\Program Files\\Microsoft SQL Server";
  print "Default folder for SQL Server is $folder \n";
  if (-e $folder) { print "Default folder does exist \n"; }
  else { print "Default folder DOES NOT exist \n";}   
  

  while ($done == 0) {
    print "Enter folder for SQL Server (just hit ENTER for default) ";
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

  # First, look to see if any of the SQL server data folders exist
  my @allFolders = ( $f . "\\MSSQL10.SQLEXPRESS2008\\MSSQL\\DATA",
  	$f . "\\MSSQL.1\\MSQL\\DATA",
  	$f . "\\MSQL\\DATA" );

  print "\nNow looking for data folders in $f\n";
  my $idx = 0;
  my @existingFolders;
  foreach $folder(@allFolders) {
    if (-e $folder) {
      $existingFolders[$idx] = $folder;
      $idx++;
      print "$idx $folder \n"; }
  }

  # Show the user folders we found and ask if any of these are to be used
  if ($idx != 0) {
    my $idxChoice = -1;
    while ($idxChoice > $idx || $idxChoice < 0) {
      print "\nWe have found one or more folders for SQL Server Data\n";
      print "Select one of the folders (1, 2, ...)\n   or enter 0 to enter a different name -> ";
      $idxChoice = <STDIN>;
      if ($idxChoice eq "" || $idxChoice eq "\r" || $idxChoice eq "\n") { $idxChoice = -1; }
    }
    if ($idxChoice != 0) {
      print "Selected: $existingFolders[$idxChoice-1]\n";
      return $existingFolders[$idxChoice-1];
    }
  }


  # Either no folders were found, or the user wants to select a different one
  my $newFolder = "XX";
  while (! -e $newFolder) {
    print "Enter path to data folder for SQL Server Data \n --> ";
    $newFolder = <STDIN>;
    chomp $newFolder;
  }
  return $newFolder;
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


