#!/bin/csh
#
# CreateOrdPlcTables
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif

foreach s(createpatient createvisit createplacerorder createfillerorder \
  createordr createidentifiers load_id_op)
 echo SQL script: $s
 psql $1 < $s.sql
 if ($status != 0) exit 1
end

