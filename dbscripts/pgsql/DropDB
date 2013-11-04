#!/bin/csh
#
# DropDB
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit
endif

# Use the following line for postres 6.x
#destroydb $1

# Use the following line for postres 7.x
dropdb $1
