#!/bin/csh
#
# CreateQueueMgrTables
#

if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif

psql $1 < createworkorders.pgsql
if ($status != 0) exit 1
psql $1 < createusers.pgsql
if ($status != 0) exit 1
psql $1 < createlastreq.pgsql
if ($status != 0) exit 1
