@ echo off

if "%2" == "" (
 echo "eval_1911 loglevel directory"
) else (
 if NOT EXIST 1911 mkdir 1911
 mesa_pdi_eval -l 1 -r %1 %2 13 >  1911\grade_1911.txt
)
