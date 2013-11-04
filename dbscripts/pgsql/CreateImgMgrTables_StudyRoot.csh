#!/bin/csh
#
# CreateImgMgrTables_StudyRoot
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif


psql $1 < createpsview_studyroot.pgsql
if ($status != 0) exit 1
psql $1 < createvisit.pgsql
if ($status != 0) exit 1
psql $1 < createseries.pgsql
if ($status != 0) exit 1
psql $1 < createsopins.pgsql
if ($status != 0) exit 1
psql $1 < createdicomapp.pgsql
if ($status != 0) exit 1
psql $1 < createstoragecommit.pgsql
if ($status != 0) exit 1
