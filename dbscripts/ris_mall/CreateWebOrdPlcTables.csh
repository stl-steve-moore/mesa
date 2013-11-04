#!/bin/csh
#
# CreateWebOrdPlcTables
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif


foreach s (createpatient.sql createvisit.sql createplacerorder.sql \
  createfillerorder.pgsql createordr.sql createidentifiers.pgsql \
  load_id_op.sql createdestination.sql createpatientvisitview.sql \
  createpatientvisitorderview.sql )

  echo $s
  psql $1 < $s
  if ($status != 0) exit 1
end

