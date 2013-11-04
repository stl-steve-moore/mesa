#!/bin/csh
#
# CreateInfoSrcTables.csh
#
if ($1 == "") then
  echo " "
  echo Usage: "$0 <Database Name>"
  echo " "
  exit 1
endif

foreach script (createpatient.sql createvisit.sql createinfosrcreports.sql \
	createinfosrcreportview.sql \
	createdoc_reference.sql load_rid_data.sql load_doc_reference.sql)
 echo $script
 psql $1 < $script
 if ($status != 0) then
  echo Failed in CreateInfoSrcTables.csh on script $script
  exit 1
 endif
end

