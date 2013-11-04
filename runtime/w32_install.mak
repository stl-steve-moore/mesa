install:
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\codes
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\expmgr
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\exprcr
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\imgmgr
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\mesa_storage
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\rpt_manager
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\rpt_repos
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\wkstation
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\certificates
	..\scripts\createdirectory.bat $(MESA_TARGET)\runtime\certs-ca-signed

	copy segDefs.ihe $(MESA_TARGET)\runtime
	copy msgRules.ihe $(MESA_TARGET)\runtime
	copy segDefs.ihe-iti $(MESA_TARGET)\runtime
	copy msgRules.ihe-iti $(MESA_TARGET)\runtime
	copy version.txt $(MESA_TARGET)\runtime
	copy IHE-syslog-audit-message-4.xsd $(MESA_TARGET)\runtime
	copy IHE-ATNA-syslog-audit-message.xsd $(MESA_TARGET)\runtime
	copy MESA-ATNA.xsl $(MESA_TARGET)\runtime
	xcopy/E/Y codes $(MESA_TARGET)\runtime\codes
	xcopy/E/Y expmgr $(MESA_TARGET)\runtime\expmgr
	xcopy/E/Y exprcr $(MESA_TARGET)\runtime\exprcr
	xcopy/E/Y imgmgr $(MESA_TARGET)\runtime\imgmgr
	xcopy/E/Y mesa_storage $(MESA_TARGET)\runtime\mesa_storage
	xcopy/E/Y rpt_manager $(MESA_TARGET)\runtime\rpt_manager
	xcopy/E/Y rpt_repos $(MESA_TARGET)\runtime\rpt_repos
	xcopy/E/Y wkstation $(MESA_TARGET)\runtime\wkstation
	xcopy/E/Y certificates $(MESA_TARGET)\runtime\certificates
	xcopy/E/Y certs-ca-signed $(MESA_TARGET)\runtime\certs-ca-signed

clean:


