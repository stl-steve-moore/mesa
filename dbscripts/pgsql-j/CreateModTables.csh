#!/bin/csh
#
# CreateADTTables
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif

foreach s (createpatient createvisit createidentifiers load_id_mod)
  echo $s
  psql $1 < $s.sql
  if ($status != 0) exit 1
end

