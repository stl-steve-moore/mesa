@ echo off

if "%2" == "" (
 echo "eval_1910 loglevel directory"
) else (
 if NOT EXIST 1910 mkdir 1910
 mesa_pdi_eval -l 1 -r %1 %2 10 >  1910\grade_1910.txt
 mesa_pdi_eval -l 1 -r %1 %2 11 >> 1910\grade_1910.txt
 mesa_pdi_eval -l 1 -r %1 %2 12 >> 1910\grade_1910.txt
)
