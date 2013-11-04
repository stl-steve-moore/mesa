#!/bin/csh

echo "" > dumps/irwf.dumps.txt
foreach i (*/*/000000)
 echo $i
 echo $i >> dumps/irwf.dumps.txt
 dcm_dump_file -f -t $i >> dumps/irwf.dumps.txt
 echo "" >> dumps/irwf.dumps.txt
end
