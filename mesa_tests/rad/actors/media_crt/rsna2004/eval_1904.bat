@ echo off

if "%2" == "" (
 echo "eval_1904 loglevel directory"
) else (
 if NOT EXIST 1904 mkdir 1904
 mesa_pdi_eval -l 1 -r %1 %2 3 >  1904\grade_1904.txt
 mesa_pdi_eval -l 1 -r %1 %2 4 >> 1904\grade_1904.txt
 mesa_pdi_eval -l 1 -r %1 %2 5 >> 1904\grade_1904.txt
 mesa_pdi_eval -l 1 -r %1 %2 6 >> 1904\grade_1904.txt
 mesa_pdi_eval -l 1 -r %1 %2 7 >> 1904\grade_1904.txt
)
