#!/bin/csh
#
# CreateImgMgrTables
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif


foreach x (createpatient createvisit createstudy createseries \
  createsopins createdicomapp createstoragecommit createpsview \
  createppwf createidentifiers load_id_rm )
  echo SQL script: $x.sql
  psql $1 < $x.sql
  if ($status != 0) exit 1
end

