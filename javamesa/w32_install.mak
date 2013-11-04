install: jar
	copy javamesa.jar $(JAR_DIRECTORY)

java_classes:
	cd "MESA"
	$(MAKE)/f w32_install.mak install
	cd ".."

jar:	java_classes
	copy ..\java_apps\gui\*.class .
	jar -c0vf javamesa.jar MESA\Visual\*class *class

clean:
	cd "MESA"
	$(MAKE)/f w32_install.mak clean
	cd ".."
