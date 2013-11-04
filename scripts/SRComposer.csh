#!/bin/csh

set x = $JAR_DIRECTORY/SRComposer.jar:$MESA_TARGET/lib/sfc.jar:$MESA_TARGET/lib/symtools.jar:$MESA_TARGET/lib/symbeans.jar:$MESA_TARGET/lib/javamesa.jar:$MESA_TARGET/lib/javactn.jar

$JDK_ROOT/bin/java -classpath $x -Dcodetable.base=$MESA_TARGET/runtime/codes -DMESA.runtime=$MESA_TARGET/runtime SRComposer
