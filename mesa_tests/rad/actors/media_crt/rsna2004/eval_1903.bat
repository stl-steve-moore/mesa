@ echo off

if "%2" == "" (
 echo "eval_1903 loglevel directory"
) else (
 if NOT EXIST 1903 mkdir 1903
 mesa_pdi_eval -l 1 -r %1 %2 2 >  1903\grade_1903.txt
 mesa_pdi_eval -l 1 -r %1 %2 9 >> 1903\grade_1903.txt
)
