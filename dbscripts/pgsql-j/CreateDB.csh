#!/bin/csh
#
# CreateDB
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <DB Name>"
  echo " "
  exit
endif
createdb -E EUC_JP $1
