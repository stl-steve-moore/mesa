@ echo off

if "%2" == "" (
 echo "eval_1901 loglevel directory"
) else (
 if NOT EXIST 1901 mkdir 1901
 mesa_pdi_eval -l 1 -r %1 %2 1 > 1901\grade_1901.txt
)
