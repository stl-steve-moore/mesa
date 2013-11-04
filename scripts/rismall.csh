#!/bin/csh

@ a = 1
while ($a <= 10000)
 date
 start_ris_mall_servers.csh
 @ a += 1
 sleep 20
 echo Iteration $a Restart will happen automatically.
end
