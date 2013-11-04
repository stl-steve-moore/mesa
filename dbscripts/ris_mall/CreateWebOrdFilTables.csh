#!/bin/csh
#
# CreateWebOrdFilTables
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif

psql $1 < createpatient.sql
if ($status != 0) exit 1

foreach x (createvisit.sql createplacerorder.sql createfillerorder.pgsql \
  createordr.sql createmwl.sql createactionitem.pgsql createschedule.pgsql \
  createidentifiers.pgsql createppwf.pgsql load_id_of.sql \
  createdestination.sql createpatientvisitorderview.sql )
  echo $x
  psql $1 < $x
  if ($status != 0) exit 1
end

perl fillProtocolItemInfo.pl -f protocolItemData.txt webof 

exit 0
