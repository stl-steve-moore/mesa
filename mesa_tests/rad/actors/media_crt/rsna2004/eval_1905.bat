@ echo off

if "%2" == "" (
 echo "eval_1905 loglevel directory"
) else (
 if NOT EXIST 1905 mkdir 1905
 mesa_pdi_eval -l 1 -r %1 %2 8 > 1905\grade_1905.txt
)
