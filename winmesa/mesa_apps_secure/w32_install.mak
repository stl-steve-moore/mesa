install:
	cd "cecho_secure"
	$(MAKE) /f cecho_secure.mak CFG="cecho_secure - Win32 Release"
	copy Release\cecho_secure.exe $(MESA_TARGET)\bin
	copy Release\cecho_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_secure"
	$(MAKE) /f cfind_secure.mak CFG="cfind_secure - Win32 Release"
	copy Release\cfind_secure.exe $(MESA_TARGET)\bin
	copy Release\cfind_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cstore_secure"
	$(MAKE) /f cstore_secure.mak CFG="cstore_secure - Win32 Release"
	copy Release\cstore_secure.exe $(MESA_TARGET)\bin
	copy Release\cstore_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ds_dcm_secure"
	$(MAKE) /f ds_dcm_secure.mak CFG="ds_dcm_secure - Win32 Release"
	copy Release\ds_dcm_secure.exe $(MESA_TARGET)\bin
	copy Release\ds_dcm_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_rcvr_secure"
	$(MAKE) /f hl7_rcvr_secure.mak CFG="hl7_rcvr_secure - Win32 Release"
	copy Release\hl7_rcvr_secure.exe $(MESA_TARGET)\bin
	copy Release\hl7_rcvr_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "kill_hl7_secure"
	$(MAKE) /f kill_hl7_secure.mak CFG="kill_hl7_secure - Win32 Release"
	copy Release\kill_hl7_secure.exe $(MESA_TARGET)\bin
	copy Release\kill_hl7_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_storage_secure"
	$(MAKE) /f mesa_storage_secure.mak CFG="mesa_storage_secure - Win32 Release"
	copy Release\mesa_storage_secure.exe $(MESA_TARGET)\bin
	copy Release\mesa_storage_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mod_dcmps_secure"
	$(MAKE) /f mod_dcmps_secure.mak CFG="mod_dcmps_secure - Win32 Release"
	copy Release\mod_dcmps_secure.exe $(MESA_TARGET)\bin
	copy Release\mod_dcmps_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mwlquery_secure"
	$(MAKE) /f mwlquery_secure.mak CFG="mwlquery_secure - Win32 Release"
	copy Release\mwlquery_secure.exe $(MESA_TARGET)\bin
	copy Release\mwlquery_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "naction_secure"
	$(MAKE) /f naction_secure.mak CFG="naction_secure - Win32 Release"
	copy Release\naction_secure.exe $(MESA_TARGET)\bin
	copy Release\naction_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ncreate_secure"
	$(MAKE) /f ncreate_secure.mak CFG="ncreate_secure - Win32 Release"
	copy Release\ncreate_secure.exe $(MESA_TARGET)\bin
	copy Release\ncreate_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "nevent_secure"
	$(MAKE) /f nevent_secure.mak CFG="nevent_secure - Win32 Release"
	copy Release\nevent_secure.exe $(MESA_TARGET)\bin
	copy Release\nevent_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "nset_secure"
	$(MAKE) /f nset_secure.mak CFG="nset_secure - Win32 Release"
	copy Release\nset_secure.exe $(MESA_TARGET)\bin
	copy Release\nset_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "of_dcmps_secure"
	$(MAKE) /f of_dcmps_secure.mak CFG="of_dcmps_secure - Win32 Release"
	copy Release\of_dcmps_secure.exe $(MESA_TARGET)\bin
	copy Release\of_dcmps_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "open_assoc_secure"
	$(MAKE) /f open_assoc_secure.mak CFG="open_assoc_secure - Win32 Release"
	copy Release\open_assoc_secure.exe $(MESA_TARGET)\bin
	copy Release\open_assoc_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "send_hl7_secure"
	$(MAKE) /f send_hl7_secure.mak CFG="send_hl7_secure - Win32 Release"
	copy Release\send_hl7_secure.exe $(MESA_TARGET)\bin
	copy Release\send_hl7_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_client_secure"
	$(MAKE) /f syslog_client_secure.mak CFG="syslog_client_secure - Win32 Release"
	copy Release\syslog_client_secure.exe $(MESA_TARGET)\bin
	copy Release\syslog_client_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_server_secure"
	$(MAKE) /f syslog_server_secure.mak CFG="syslog_server_secure - Win32 Release"
	copy Release\syslog_server_secure.exe $(MESA_TARGET)\bin
	copy Release\syslog_server_secure.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "tls_client"
	$(MAKE) /f tls_client.mak CFG="tls_client - Win32 Release"
	copy Release\tls_client.exe $(MESA_TARGET)\bin
	copy Release\tls_client.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "tls_connect"
	$(MAKE) /f tls_connect.mak CFG="tls_connect - Win32 Release"
	copy Release\tls_connect.exe $(MESA_TARGET)\bin
	copy Release\tls_connect.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "tls_server"
	$(MAKE) /f tls_server.mak CFG="tls_server - Win32 Release"
	copy Release\tls_server.exe $(MESA_TARGET)\bin
	copy Release\tls_server.exe.manifest $(MESA_TARGET)\bin
	cd ".."

clean:
	cd "cecho_secure"
	$(MAKE) /f cecho_secure.mak CFG="cecho_secure - Win32 Release" clean
	cd ".."

	cd "cfind_secure"
	$(MAKE) /f cfind_secure.mak CFG="cfind_secure - Win32 Release" clean
	cd ".."

	cd "cstore_secure"
	$(MAKE) /f cstore_secure.mak CFG="cstore_secure - Win32 Release" clean
	cd ".."

	cd "ds_dcm_secure"
	$(MAKE) /f ds_dcm_secure.mak CFG="ds_dcm_secure - Win32 Release" clean
	cd ".."

	cd "hl7_rcvr_secure"
	$(MAKE) /f hl7_rcvr_secure.mak CFG="hl7_rcvr_secure - Win32 Release" clean
	cd ".."

	cd "kill_hl7_secure"
	$(MAKE) /f kill_hl7_secure.mak CFG="kill_hl7_secure - Win32 Release" clean
	cd ".."

	cd "mesa_storage_secure"
	$(MAKE) /f mesa_storage_secure.mak CFG="mesa_storage_secure - Win32 Release" clean
	cd ".."

	cd "mod_dcmps_secure"
	$(MAKE) /f mod_dcmps_secure.mak CFG="mod_dcmps_secure - Win32 Release" clean
	cd ".."

	cd "mwlquery_secure"
	$(MAKE) /f mwlquery_secure.mak CFG="mwlquery_secure - Win32 Release" clean
	cd ".."


	cd "naction_secure"
	$(MAKE) /f naction_secure.mak CFG="naction_secure - Win32 Release" clean
	cd ".."

	cd "ncreate_secure"
	$(MAKE) /f ncreate_secure.mak CFG="ncreate_secure - Win32 Release" clean
	cd ".."

	cd "nevent_secure"
	$(MAKE) /f nevent_secure.mak CFG="nevent_secure - Win32 Release" clean
	cd ".."

	cd "nset_secure"
	$(MAKE) /f nset_secure.mak CFG="nset_secure - Win32 Release" clean
	cd ".."

	cd "of_dcmps_secure"
	$(MAKE) /f of_dcmps_secure.mak CFG="of_dcmps_secure - Win32 Release" clean
	cd ".."

	cd "open_assoc_secure"
	$(MAKE) /f open_assoc_secure.mak CFG="open_assoc_secure - Win32 Release" clean
	cd ".."

	cd "send_hl7_secure"
	$(MAKE) /f send_hl7_secure.mak CFG="send_hl7_secure - Win32 Release" clean
	cd ".."

	cd "syslog_client_secure"
	$(MAKE) /f syslog_client_secure.mak CFG="syslog_client_secure - Win32 Release" clean
	cd ".."

	cd "syslog_server_secure"
	$(MAKE) /f syslog_server_secure.mak CFG="syslog_server_secure - Win32 Release" clean
	cd ".."

	cd "tls_client"
	$(MAKE) /f tls_client.mak CFG="tls_client - Win32 Release" clean
	cd ".."

	cd "tls_connect"
	$(MAKE) /f tls_connect.mak CFG="tls_connect - Win32 Release" clean
	cd ".."

	cd "tls_server"
	$(MAKE) /f tls_server.mak CFG="tls_server - Win32 Release" clean
	cd ".."

install_debug:
	cd "cecho_secure"
	$(MAKE) /f cecho_secure.mak CFG="cecho_secure - Win32 Debug"
	copy Debug\cecho_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_secure"
	$(MAKE) /f cfind_secure.mak CFG="cfind_secure - Win32 Debug"
	copy Debug\cfind_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cstore_secure"
	$(MAKE) /f cstore_secure.mak CFG="cstore_secure - Win32 Debug"
	copy Debug\cstore_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ds_dcm_secure"
	$(MAKE) /f ds_dcm_secure.mak CFG="ds_dcm_secure - Win32 Debug"
	copy Debug\ds_dcm_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_rcvr_secure"
	$(MAKE) /f hl7_rcvr_secure.mak CFG="hl7_rcvr_secure - Win32 Debug"
	copy Debug\hl7_rcvr_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "kill_hl7_secure"
	$(MAKE) /f kill_hl7_secure.mak CFG="kill_hl7_secure - Win32 Debug"
	copy Debug\kill_hl7_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_storage_secure"
	$(MAKE) /f mesa_storage_secure.mak CFG="mesa_storage_secure - Win32 Debug"
	copy Debug\mesa_storage_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mod_dcmps_secure"
	$(MAKE) /f mod_dcmps_secure.mak CFG="mod_dcmps_secure - Win32 Debug"
	copy Debug\mod_dcmps_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mwlquery_secure"
	$(MAKE) /f mwlquery_secure.mak CFG="mwlquery_secure - Win32 Debug"
	copy Debug\mwlquery_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "naction_secure"
	$(MAKE) /f naction_secure.mak CFG="naction_secure - Win32 Debug"
	copy Debug\naction_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ncreate_secure"
	$(MAKE) /f ncreate_secure.mak CFG="ncreate_secure - Win32 Debug"
	copy Debug\ncreate_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "nevent_secure"
	$(MAKE) /f nevent_secure.mak CFG="nevent_secure - Win32 Debug"
	copy Debug\nevent_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "nset_secure"
	$(MAKE) /f nset_secure.mak CFG="nset_secure - Win32 Debug"
	copy Debug\nset_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "of_dcmps_secure"
	$(MAKE) /f of_dcmps_secure.mak CFG="of_dcmps_secure - Win32 Debug"
	copy Debug\of_dcmps_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "open_assoc_secure"
	$(MAKE) /f open_assoc_secure.mak CFG="open_assoc_secure - Win32 Debug"
	copy Debug\open_assoc_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "send_hl7_secure"
	$(MAKE) /f send_hl7_secure.mak CFG="send_hl7_secure - Win32 Debug"
	copy Debug\send_hl7_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_client_secure"
	$(MAKE) /f syslog_client_secure.mak CFG="syslog_client_secure - Win32 Debug"
	copy Debug\syslog_client_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_server_secure"
	$(MAKE) /f syslog_server_secure.mak CFG="syslog_server_secure - Win32 Debug"
	copy Debug\syslog_server_secure.exe $(MESA_TARGET)\bin
	cd ".."

	cd "tls_client"
	$(MAKE) /f tls_client.mak CFG="tls_client - Win32 Debug"
	copy Debug\tls_client.exe $(MESA_TARGET)\bin
	cd ".."

	cd "tls_connect"
	$(MAKE) /f tls_connect.mak CFG="tls_connect - Win32 Debug"
	copy Debug\tls_connect.exe $(MESA_TARGET)\bin
	cd ".."

	cd "tls_server"
	$(MAKE) /f tls_server.mak CFG="tls_server - Win32 Debug"
	copy Debug\tls_server.exe $(MESA_TARGET)\bin
	cd ".."

clean_debug:
	cd "cecho_secure"
	$(MAKE) /f cecho_secure.mak CFG="cecho_secure - Win32 Debug" clean
	cd ".."

	cd "cfind_secure"
	$(MAKE) /f cfind_secure.mak CFG="cfind_secure - Win32 Debug" clean
	cd ".."

	cd "cstore_secure"
	$(MAKE) /f cstore_secure.mak CFG="cstore_secure - Win32 Debug" clean
	cd ".."

	cd "ds_dcm_secure"
	$(MAKE) /f ds_dcm_secure.mak CFG="ds_dcm_secure - Win32 Debug" clean
	cd ".."

	cd "hl7_rcvr_secure"
	$(MAKE) /f hl7_rcvr_secure.mak CFG="hl7_rcvr_secure - Win32 Debug" clean
	cd ".."

	cd "kill_hl7_secure"
	$(MAKE) /f kill_hl7_secure.mak CFG="kill_hl7_secure - Win32 Debug" clean
	cd ".."

	cd "mesa_storage_secure"
	$(MAKE) /f mesa_storage_secure.mak CFG="mesa_storage_secure - Win32 Debug" clean
	cd ".."

	cd "mod_dcmps_secure"
	$(MAKE) /f mod_dcmps_secure.mak CFG="mod_dcmps_secure - Win32 Debug" clean
	cd ".."

	cd "mwlquery_secure"
	$(MAKE) /f mwlquery_secure.mak CFG="mwlquery_secure - Win32 Debug" clean
	cd ".."

	cd "naction_secure"
	$(MAKE) /f naction_secure.mak CFG="naction_secure - Win32 Debug" clean
	cd ".."

	cd "ncreate_secure"
	$(MAKE) /f ncreate_secure.mak CFG="ncreate_secure - Win32 Debug" clean
	cd ".."

	cd "nevent_secure"
	$(MAKE) /f nevent_secure.mak CFG="nevent_secure - Win32 Debug" clean
	cd ".."

	cd "nset_secure"
	$(MAKE) /f nset_secure.mak CFG="nset_secure - Win32 Debug" clean
	cd ".."

	cd "of_dcmps_secure"
	$(MAKE) /f of_dcmps_secure.mak CFG="of_dcmps_secure - Win32 Debug" clean
	cd ".."

	cd "open_assoc_secure"
	$(MAKE) /f open_assoc_secure.mak CFG="open_assoc_secure - Win32 Debug" clean
	cd ".."

	cd "send_hl7_secure"
	$(MAKE) /f send_hl7_secure.mak CFG="send_hl7_secure - Win32 Debug" clean
	cd ".."

	cd "syslog_client_secure"
	$(MAKE) /f syslog_client_secure.mak CFG="syslog_client_secure - Win32 Debug" clean
	cd ".."

	cd "syslog_server_secure"
	$(MAKE) /f syslog_server_secure.mak CFG="syslog_server_secure - Win32 Debug" clean
	cd ".."

	cd "tls_client"
	$(MAKE) /f tls_client.mak CFG="tls_client - Win32 Debug" clean
	cd ".."

	cd "tls_connect"
	$(MAKE) /f tls_connect.mak CFG="tls_connect - Win32 Debug" clean
	cd ".."

	cd "tls_server"
	$(MAKE) /f tls_server.mak CFG="tls_server - Win32 Debug" clean
	cd ".."
