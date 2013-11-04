NMAKE=nmake
install:
	cd "archive_agent"
	$(NMAKE)/f archive_agent.mak CFG="archive_agent - Win32 Release"
#	mt.exe -manifest Release\archive_agent.exe.manifest -outputresource:Release\archive_agent.exe;1
	copy Release\archive_agent.exe $(MESA_TARGET)\bin
#	copy Release\archive_agent.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "archive_cleaner"
	$(NMAKE)/f archive_cleaner.mak CFG="archive_cleaner - Win32 Release"
#	mt.exe -manifest Release\archive_cleaner.exe.manifest -outputresource:Release\archive_cleaner.exe;1
	copy Release\archive_cleaner.exe $(MESA_TARGET)\bin
#	copy Release\archive_cleaner.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "archive_server"
	$(NMAKE)/f archive_server.mak CFG="archive_server - Win32 Release"
#	mt.exe -manifest Release\archive_server.exe.manifest -outputresource:Release\archive_server.exe;1
	copy Release\archive_server.exe $(MESA_TARGET)\bin
#	copy Release\archive_server.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cfind"
	$(NMAKE)/f cfind.mak CFG="cfind - Win32 Release"
#	mt.exe -manifest Release\cfind.exe.manifest -outputresource:Release\cfind.exe;1
	copy Release\cfind.exe $(MESA_TARGET)\bin
#	copy Release\cfind.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_evaluate"
	$(NMAKE)/f cfind_evaluate.mak CFG="cfind_evaluate - Win32 Release"
#	mt.exe -manifest Release\cfind_evaluate.exe.manifest -outputresource:Release\cfind_evaluate.exe;1
	copy Release\cfind_evaluate.exe $(MESA_TARGET)\bin
#	copy Release\cfind_evaluate.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_gpsps_evaluate"
	$(NMAKE)/f cfind_gpsps_evaluate.mak CFG="cfind_gpsps_evaluate - Win32 Release"
#	mt.exe -manifest Release\cfind_gpsps_evaluate.exe.manifest -outputresource:Release\cfind_gpsps_evaluate.exe;1
	copy Release\cfind_gpsps_evaluate.exe $(MESA_TARGET)\bin
#	copy Release\cfind_gpsps_evaluate.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_image_avail"
	$(NMAKE)/f cfind_image_avail.mak CFG="cfind_image_avail - Win32 Release"
#	mt.exe -manifest Release\cfind_image_avail.exe.manifest -outputresource:Release\cfind_image_avail.exe;1
	copy Release\cfind_image_avail.exe $(MESA_TARGET)\bin
#	copy Release\cfind_image_avail.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_mwl_evaluate"
	$(NMAKE)/f cfind_mwl_evaluate.mak CFG="cfind_mwl_evaluate - Win32 Release"
#	mt.exe -manifest Release\cfind_mwl_evaluate.exe.manifest -outputresource:Release\cfind_mwl_evaluate.exe;1
	copy Release\cfind_mwl_evaluate.exe $(MESA_TARGET)\bin
#	copy Release\cfind_mwl_evaluate.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_resp_evaluate"
	$(NMAKE)/f cfind_resp_evaluate.mak CFG="cfind_resp_evaluate - Win32 Release"
#	mt.exe -manifest Release\cfind_resp_evaluate.exe.manifest -outputresource:Release\cfind_resp_evaluate.exe;1
	copy Release\cfind_resp_evaluate.exe $(MESA_TARGET)\bin
#	copy Release\cfind_resp_evaluate.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_study_probe"
	$(NMAKE)/f cfind_study_probe.mak CFG="cfind_study_probe - Win32 Release"
#	mt.exe -manifest Release\cfind_study_probe.exe.manifest -outputresource:Release\cfind_study_probe.exe;1
	copy Release\cfind_study_probe.exe $(MESA_TARGET)\bin
#	copy Release\cfind_study_probe.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cmove"
	$(NMAKE)/f cmove.mak CFG="cmove - Win32 Release"
#	mt.exe -manifest Release\cmove.exe.manifest -outputresource:Release\cmove.exe;1
	copy Release\cmove.exe $(MESA_TARGET)\bin
#	copy Release\cmove.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cmove_study"
	$(NMAKE)/f cmove_study.mak CFG="cmove_study - Win32 Release"
#	mt.exe -manifest Release\cmove_study.exe.manifest -outputresource:Release\cmove_study.exe;1
	copy Release\cmove_study.exe $(MESA_TARGET)\bin
#	copy Release\cmove_study.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "compare_dcm"
	$(NMAKE)/f compare_dcm.mak CFG="compare_dcm - Win32 Release"
#	mt.exe -manifest Release\compare_dcm.exe.manifest -outputresource:Release\compare_dcm.exe;1
	copy Release\compare_dcm.exe $(MESA_TARGET)\bin
#	copy Release\compare_dcm.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "compare_hl7"
	$(NMAKE)/f compare_hl7.mak CFG="compare_hl7 - Win32 Release"
#	mt.exe -manifest Release\compare_hl7.exe.manifest -outputresource:Release\compare_hl7.exe;1
	copy Release\compare_hl7.exe $(MESA_TARGET)\bin
#	copy Release\compare_hl7.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "cstore"
	$(NMAKE)/f cstore.mak CFG="cstore - Win32 Release"
#	mt.exe -manifest Release\cstore.exe.manifest -outputresource:Release\cstore.exe;1
	copy Release\cstore.exe $(MESA_TARGET)\bin
#	copy Release\cstore.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ctn_version"
	$(NMAKE)/f ctn_version.mak CFG="ctn_version - Win32 Release"
#	mt.exe -manifest Release\ctn_version.exe.manifest -outputresource:Release\ctn_version.exe;1
	copy Release\ctn_version.exe $(MESA_TARGET)\bin
#	copy Release\ctn_version.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_create_object"
	$(NMAKE)/f dcm_create_object.mak CFG="dcm_create_object - Win32 Release"
#	mt.exe -manifest Release\dcm_create_object.exe.manifest -outputresource:Release\dcm_create_object.exe;1
	copy Release\dcm_create_object.exe $(MESA_TARGET)\bin
#	copy Release\dcm_create_object.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_ctnto10"
	$(NMAKE)/f dcm_ctnto10.mak CFG="dcm_ctnto10 - Win32 Release"
#	mt.exe -manifest Release\dcm_ctnto10.exe.manifest -outputresource:Release\dcm_ctnto10.exe;1
	copy Release\dcm_ctnto10.exe $(MESA_TARGET)\bin
#	copy Release\dcm_ctnto10.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_diff"
	$(NMAKE)/f dcm_diff.mak CFG="dcm_diff - Win32 Release"
#	mt.exe -manifest Release\dcm_diff.exe.manifest -outputresource:Release\dcm_diff.exe;1
	copy Release\dcm_diff.exe $(MESA_TARGET)\bin
#	copy Release\dcm_diff.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_dump_compressed"
	$(NMAKE)/f dcm_dump_compressed.mak CFG="dcm_dump_compressed - Win32 Release"
#	mt.exe -manifest Release\dcm_dump_compressed.exe.manifest -outputresource:Release\dcm_dump_compressed.exe;1
	copy Release\dcm_dump_compressed.exe $(MESA_TARGET)\bin
#	copy Release\dcm_dump_compressed.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_dump_element"
	$(NMAKE)/f dcm_dump_element.mak CFG="dcm_dump_element - Win32 Release"
#	mt.exe -manifest Release\dcm_dump_element.exe.manifest -outputresource:Release\dcm_dump_element.exe;1
	copy Release\dcm_dump_element.exe $(MESA_TARGET)\bin
#	copy Release\dcm_dump_element.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_dump_file"
	$(NMAKE)/f dcm_dump_file.mak CFG="dcm_dump_file - Win32 Release"
#	mt.exe -manifest Release\dcm_dump_file.exe.manifest -outputresource:Release\dcm_dump_file.exe;1
	copy Release\dcm_dump_file.exe $(MESA_TARGET)\bin
#	copy Release\dcm_dump_file.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_get_elements"
	$(NMAKE)/f dcm_get_elements.mak CFG="dcm_get_elements - Win32 Release"
#	mt.exe -manifest Release\dcm_get_elements.exe.manifest -outputresource:Release\dcm_get_elements.exe;1
	copy Release\dcm_get_elements.exe $(MESA_TARGET)\bin
#	copy Release\dcm_get_elements.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_iterator"
	$(NMAKE)/f dcm_iterator.mak CFG="dcm_iterator - Win32 Release"
#	mt.exe -manifest Release\dcm_iterator.exe.manifest -outputresource:Release\dcm_iterator.exe;1
	copy Release\dcm_iterator.exe $(MESA_TARGET)\bin
#	copy Release\dcm_iterator.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_make_object"
	$(NMAKE)/f dcm_make_object.mak CFG="dcm_make_object - Win32 Release"
#	mt.exe -manifest Release\dcm_make_object.exe.manifest -outputresource:Release\dcm_make_object.exe;1
	copy Release\dcm_make_object.exe $(MESA_TARGET)\bin
#	copy Release\dcm_make_object.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_map_to_8"
	$(NMAKE)/f dcm_map_to_8.mak CFG="dcm_map_to_8 - Win32 Release"
#	mt.exe -manifest Release\dcm_map_to_8.exe.manifest -outputresource:Release\dcm_map_to_8.exe;1
	copy Release\dcm_map_to_8.exe $(MESA_TARGET)\bin
#	copy Release\dcm_map_to_8.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_mask_image"
	$(NMAKE)/f dcm_mask_image.mak CFG="dcm_mask_image - Win32 Release"
#	mt.exe -manifest Release\dcm_mask_image.exe.manifest -outputresource:Release\dcm_mask_image.exe;1
	copy Release\dcm_mask_image.exe $(MESA_TARGET)\bin
#	copy Release\dcm_mask_image.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_modify_elements"
	$(NMAKE)/f dcm_modify_elements.mak CFG="dcm_modify_elements - Win32 Release"
#	mt.exe -manifest Release\dcm_modify_elements.exe.manifest -outputresource:Release\dcm_modify_elements.exe;1
	copy Release\dcm_modify_elements.exe $(MESA_TARGET)\bin
#	copy Release\dcm_modify_elements.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_modify_object"
	$(NMAKE)/f dcm_modify_object.mak CFG="dcm_modify_object - Win32 Release"
#	mt.exe -manifest Release\dcm_modify_object.exe.manifest -outputresource:Release\dcm_modify_object.exe;1
	copy Release\dcm_modify_object.exe $(MESA_TARGET)\bin
#	copy Release\dcm_modify_object.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_print_dictionary"
	$(NMAKE)/f dcm_print_dictionary.mak CFG="dcm_print_dictionary - Win32 Release"
#	mt.exe -manifest Release\dcm_print_dictionary.exe.manifest -outputresource:Release\dcm_print_dictionary.exe;1
	copy Release\dcm_print_dictionary.exe $(MESA_TARGET)\bin
#	copy Release\dcm_print_dictionary.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_print_element"
	$(NMAKE)/f dcm_print_element.mak CFG="dcm_print_element - Win32 Release"
#	mt.exe -manifest Release\dcm_print_element.exe.manifest -outputresource:Release\dcm_print_element.exe;1
	copy Release\dcm_print_element.exe $(MESA_TARGET)\bin
#	copy Release\dcm_print_element.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_ref_sop_seq"
	$(NMAKE)/f dcm_ref_sop_seq.mak CFG="dcm_ref_sop_seq - Win32 Release"
#	mt.exe -manifest Release\dcm_ref_sop_seq.exe.manifest -outputresource:Release\dcm_ref_sop_seq.exe;1
	copy Release\dcm_ref_sop_seq.exe $(MESA_TARGET)\bin
#	copy Release\dcm_ref_sop_seq.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_replace_element"
	$(NMAKE)/f dcm_replace_element.mak CFG="dcm_replace_element - Win32 Release"
#	mt.exe -manifest Release\dcm_replace_element.exe.manifest -outputresource:Release\dcm_replace_element.exe;1
	copy Release\dcm_replace_element.exe $(MESA_TARGET)\bin
#	copy Release\dcm_replace_element.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_resize"
	$(NMAKE)/f dcm_resize.mak CFG="dcm_resize - Win32 Release"
#	mt.exe -manifest Release\dcm_resize.exe.manifest -outputresource:Release\dcm_resize.exe;1
	copy Release\dcm_resize.exe $(MESA_TARGET)\bin
#	copy Release\dcm_resize.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_rm_element"
	$(NMAKE)/f dcm_rm_element.mak CFG="dcm_rm_element - Win32 Release"
#	mt.exe -manifest Release\dcm_rm_element.exe.manifest -outputresource:Release\dcm_rm_element.exe;1
	copy Release\dcm_rm_element.exe $(MESA_TARGET)\bin
#	copy Release\dcm_rm_element.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_rm_group"
	$(NMAKE)/f dcm_rm_group.mak CFG="dcm_rm_group - Win32 Release"
#	mt.exe -manifest Release\dcm_rm_group.exe.manifest -outputresource:Release\dcm_rm_group.exe;1
	copy Release\dcm_rm_group.exe $(MESA_TARGET)\bin
#	copy Release\dcm_rm_group.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_strip_odd_groups"
	$(NMAKE)/f dcm_strip_odd_groups.mak CFG="dcm_strip_odd_groups - Win32 Release"
#	mt.exe -manifest Release\dcm_strip_odd_groups.exe.manifest -outputresource:Release\dcm_strip_odd_groups.exe;1
	copy Release\dcm_strip_odd_groups.exe $(MESA_TARGET)\bin
#	copy Release\dcm_strip_odd_groups.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_to_html"
	$(NMAKE)/f dcm_to_html.mak CFG="dcm_to_html - Win32 Release"
#	mt.exe -manifest Release\dcm_to_html.exe.manifest -outputresource:Release\dcm_to_html.exe;1
	copy Release\dcm_to_html.exe $(MESA_TARGET)\bin
#	copy Release\dcm_to_html.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_to_text"
	$(NMAKE)/f dcm_to_text.mak CFG="dcm_to_text - Win32 Release"
#	mt.exe -manifest Release\dcm_to_text.exe.manifest -outputresource:Release\dcm_to_text.exe;1
	copy Release\dcm_to_text.exe $(MESA_TARGET)\bin
#	copy Release\dcm_to_text.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_to_xml"
	$(NMAKE)/f dcm_to_xml.mak CFG="dcm_to_xml - Win32 Release"
#	mt.exe -manifest Release\dcm_to_xml.exe.manifest -outputresource:Release\dcm_to_xml.exe;1
	copy Release\dcm_to_xml.exe $(MESA_TARGET)\bin
#	copy Release\dcm_to_xml.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_vr_patterns"
	$(NMAKE)/f dcm_vr_patterns.mak CFG="dcm_vr_patterns - Win32 Release"
#	mt.exe -manifest Release\dcm_vr_patterns.exe.manifest -outputresource:Release\dcm_vr_patterns.exe;1
	copy Release\dcm_vr_patterns.exe $(MESA_TARGET)\bin
#	copy Release\dcm_vr_patterns.exe.manifest $(MESA_TARGET)\bin
	cd ".."

#	cd "dcm_w_disp"
#	$(NMAKE)/f dcm_w_disp.mak CFG="dcm_w_disp - Win32 Release"
##	mt.exe -manifest Release\dcm_w_disp.exe.manifest -outputresource:Release\dcm_w_disp.exe;1
#	copy Release\dcm_w_disp.exe $(MESA_TARGET)\bin
##	copy Release\dcm_w_disp.exe.manifest $(MESA_TARGET)\bin
#	cd ".."

	cd "dicom_echo"
	$(NMAKE)/f dicom_echo.mak CFG="dicom_echo - Win32 Release"
#	mt.exe -manifest Release\dicom_echo.exe.manifest -outputresource:Release\dicom_echo.exe;1
	copy Release\dicom_echo.exe $(MESA_TARGET)\bin
#	copy Release\dicom_echo.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ds_dcm"
	$(NMAKE)/f ds_dcm.mak CFG="ds_dcm - Win32 Release"
#	mt.exe -manifest Release\ds_dcm.exe.manifest -outputresource:Release\ds_dcm.exe;1
	copy Release\ds_dcm.exe $(MESA_TARGET)\bin
#	copy Release\ds_dcm.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "dump_commit_requests"
	$(NMAKE)/f dump_commit_requests.mak CFG="dump_commit_requests - Win32 Release"
#	mt.exe -manifest Release\dump_commit_requests.exe.manifest -outputresource:Release\dump_commit_requests.exe;1
	copy Release\dump_commit_requests.exe $(MESA_TARGET)\bin
#	copy Release\dump_commit_requests.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_evaluate"
	$(NMAKE)/f hl7_evaluate.mak CFG="hl7_evaluate - Win32 Release"
#	mt.exe -manifest Release\hl7_evaluate.exe.manifest -outputresource:Release\hl7_evaluate.exe;1
	copy Release\hl7_evaluate.exe $(MESA_TARGET)\bin
#	copy Release\hl7_evaluate.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_rcvr"
	$(NMAKE)/f hl7_rcvr.mak CFG="hl7_rcvr - Win32 Release"
#	mt.exe -manifest Release\hl7_rcvr.exe.manifest -outputresource:Release\hl7_rcvr.exe;1
	copy Release\hl7_rcvr.exe $(MESA_TARGET)\bin
#	copy Release\hl7_rcvr.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "evaluate_gppps"
	$(NMAKE)/f evaluate_gppps.mak CFG="evaluate_gppps - Win32 Release"
#	mt.exe -manifest Release\evaluate_gppps.exe.manifest -outputresource:Release\evaluate_gppps.exe;1
	copy Release\evaluate_gppps.exe $(MESA_TARGET)\bin
#	copy Release\evaluate_gppps.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "evaluate_storage_commitment"
	$(NMAKE)/f evaluate_storage_commitment.mak CFG="evaluate_storage_commitment - Win32 Release"
#	mt.exe -manifest Release\evaluate_storage_commitment.exe.manifest -outputresource:Release\evaluate_storage_commitment.exe;1
	copy Release\evaluate_storage_commitment.exe $(MESA_TARGET)\bin
#	copy Release\evaluate_storage_commitment.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_get_value"
	$(NMAKE)/f hl7_get_value.mak CFG="hl7_get_value - Win32 Release"
#	mt.exe -manifest Release\hl7_get_value.exe.manifest -outputresource:Release\hl7_get_value.exe;1
	copy Release\hl7_get_value.exe $(MESA_TARGET)\bin
#	copy Release\hl7_get_value.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_set_value"
	$(NMAKE)/f hl7_set_value.mak CFG="hl7_set_value - Win32 Release"
#	mt.exe -manifest Release\hl7_set_value.exe.manifest -outputresource:Release\hl7_set_value.exe;1
	copy Release\hl7_set_value.exe $(MESA_TARGET)\bin
#	copy Release\hl7_set_value.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_to_txt"
	$(NMAKE)/f hl7_to_txt.mak CFG="hl7_to_txt - Win32 Release"
#	mt.exe -manifest Release\hl7_to_txt.exe.manifest -outputresource:Release\hl7_to_txt.exe;1
	copy Release\hl7_to_txt.exe $(MESA_TARGET)\bin
#	copy Release\hl7_to_txt.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ihe_audit_message"
	$(NMAKE)/f ihe_audit_message.mak CFG="ihe_audit_message - Win32 Release"
#	mt.exe -manifest Release\ihe_audit_message.exe.manifest -outputresource:Release\ihe_audit_message.exe;1
	copy Release\ihe_audit_message.exe $(MESA_TARGET)\bin
#	copy Release\ihe_audit_message.exe.manifest $(MESA_TARGET)\bin
	cd ".."

#	cd "im_hl7ps"
#	$(NMAKE)/f im_hl7ps.mak CFG="im_hl7ps - Win32 Release"
#	copy Release\im_hl7ps.exe $(MESA_TARGET)\bin
#	copy Release\im_hl7ps.exe.manifest $(MESA_TARGET)\bin
#	cd ".."

	cd "im_sc_agent"
	$(NMAKE)/f im_sc_agent.mak CFG="im_sc_agent - Win32 Release"
#	mt.exe -manifest Release\im_sc_agent.exe.manifest -outputresource:Release\im_sc_agent.exe;1
	copy Release\im_sc_agent.exe $(MESA_TARGET)\bin
#	copy Release\im_sc_agent.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "kill_hl7"
	$(NMAKE)/f kill_hl7.mak CFG="kill_hl7 - Win32 Release"
#	mt.exe -manifest Release\kill_hl7.exe.manifest -outputresource:Release\kill_hl7.exe;1
	copy Release\kill_hl7.exe $(MESA_TARGET)\bin
#	copy Release\kill_hl7.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "load_control"
	$(NMAKE)/f load_control.mak CFG="load_control - Win32 Release"
#	mt.exe -manifest Release\load_control.exe.manifest -outputresource:Release\load_control.exe;1
	copy Release\load_control.exe $(MESA_TARGET)\bin
#	copy Release\load_control.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_audit_eval"
	$(NMAKE)/f mesa_audit_eval.mak CFG="mesa_audit_eval - Win32 Release"
#	mt.exe -manifest Release\mesa_audit_eval.exe.manifest -outputresource:Release\mesa_audit_eval.exe;1
	copy Release\mesa_audit_eval.exe $(MESA_TARGET)\bin
#	copy Release\mesa_audit_eval.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_composite_eval"
	$(NMAKE)/f mesa_composite_eval.mak CFG="mesa_composite_eval - Win32 Release"
#	mt.exe -manifest Release\mesa_composite_eval.exe.manifest -outputresource:Release\mesa_composite_eval.exe;1
	copy Release\mesa_composite_eval.exe $(MESA_TARGET)\bin
#	copy Release\mesa_composite_eval.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_db_test"
	$(NMAKE)/f mesa_db_test.mak CFG="mesa_db_test - Win32 Release"
#	mt.exe -manifest Release\mesa_db_test.exe.manifest -outputresource:Release\mesa_db_test.exe;1
	copy Release\mesa_db_test.exe $(MESA_TARGET)\bin
#	copy Release\mesa_db_test.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_dump_dicomdir"
	$(NMAKE)/f mesa_dump_dicomdir.mak CFG="mesa_dump_dicomdir - Win32 Release"
#	mt.exe -manifest Release\mesa_dump_dicomdir.exe.manifest -outputresource:Release\mesa_dump_dicomdir.exe;1
	copy Release\mesa_dump_dicomdir.exe $(MESA_TARGET)\bin
#	copy Release\mesa_dump_dicomdir.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_dump_obj"
	$(NMAKE)/f mesa_dump_obj.mak CFG="mesa_dump_obj - Win32 Release"
#	mt.exe -manifest Release\mesa_dump_obj.exe.manifest -outputresource:Release\mesa_dump_obj.exe;1
	copy Release\mesa_dump_obj.exe $(MESA_TARGET)\bin
#	copy Release\mesa_dump_obj.exe.manifest $(MESA_TARGET)\bin
	cd ".."


	cd mesa_extract_nm_frames
	$(NMAKE)/f mesa_extract_nm_frames.mak CFG="mesa_extract_nm_frames - Win32 Release"
#	mt.exe -manifest Release\mesa_extract_nm_frames.exe.manifest -outputresource:Release\mesa_extract_nm_frames.exe;1
	copy Release\mesa_extract_nm_frames.exe $(MESA_TARGET)\bin
#	copy Release\mesa_extract_nm_frames.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_identifier"
	$(NMAKE)/f mesa_identifier.mak CFG="mesa_identifier - Win32 Release"
#	mt.exe -manifest Release\mesa_identifier.exe.manifest -outputresource:Release\mesa_identifier.exe;1
	copy Release\mesa_identifier.exe $(MESA_TARGET)\bin
#	copy Release\mesa_identifier.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_mwl_add_sps"
	$(NMAKE)/f mesa_mwl_add_sps.mak CFG="mesa_mwl_add_sps - Win32 Release"
#	mt.exe -manifest Release\mesa_mwl_add_sps.exe.manifest -outputresource:Release\mesa_mwl_add_sps.exe;1
	copy Release\mesa_mwl_add_sps.exe $(MESA_TARGET)\bin
#	copy Release\mesa_mwl_add_sps.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_mwl_sps_from_mpps"
	$(NMAKE)/f mesa_mwl_sps_from_mpps.mak CFG="mesa_mwl_sps_from_mpps - Win32 Release"
#	mt.exe -manifest Release\mesa_mwl_sps_from_mpps.exe.manifest -outputresource:Release\mesa_mwl_sps_from_mpps.exe;1
	copy Release\mesa_mwl_sps_from_mpps.exe $(MESA_TARGET)\bin
#	copy Release\mesa_mwl_sps_from_mpps.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_select_column"
	$(NMAKE)/f mesa_select_column.mak CFG="mesa_select_column - Win32 Release"
#	mt.exe -manifest Release\mesa_select_column.exe.manifest -outputresource:Release\mesa_select_column.exe;1
	copy Release\mesa_select_column.exe $(MESA_TARGET)\bin
#	copy Release\mesa_select_column.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_pdi_eval"
	$(NMAKE)/f mesa_pdi_eval.mak CFG="mesa_pdi_eval - Win32 Release"
#	mt.exe -manifest Release\mesa_pdi_eval.exe.manifest -outputresource:Release\mesa_pdi_eval.exe;1
	copy Release\mesa_pdi_eval.exe $(MESA_TARGET)\bin
#	copy Release\mesa_pdi_eval.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_sr_eval"
	$(NMAKE)/f mesa_sr_eval.mak CFG="mesa_sr_eval - Win32 Release"
#	mt.exe -manifest Release\mesa_sr_eval.exe.manifest -outputresource:Release\mesa_sr_eval.exe;1
	copy Release\mesa_sr_eval.exe $(MESA_TARGET)\bin
#	copy Release\mesa_sr_eval.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_strip_file"
	$(NMAKE)/f mesa_strip_file.mak CFG="mesa_strip_file - Win32 Release"
#	mt.exe -manifest Release\mesa_strip_file.exe.manifest -outputresource:Release\mesa_strip_file.exe;1
	copy Release\mesa_strip_file.exe $(MESA_TARGET)\bin
#	copy Release\mesa_strip_file.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_update_column"
	$(NMAKE)/f mesa_update_column.mak CFG="mesa_update_column - Win32 Release"
#	mt.exe -manifest Release\mesa_update_column.exe.manifest -outputresource:Release\mesa_update_column.exe;1
	copy Release\mesa_update_column.exe $(MESA_TARGET)\bin
#	copy Release\mesa_update_column.exe.manifest $(MESA_TARGET)\bin
	cd ".."

#	cd "mesa_xml_eval"
#	$(NMAKE)/f mesa_xml_eval.mak CFG="mesa_xml_eval - Win32 Release"
##	mt.exe -manifest Release\mesa_xml_eval.exe.manifest -outputresource:Release\mesa_xml_eval.exe;1
#	copy Release\mesa_xml_eval.exe $(MESA_TARGET)\bin
##	copy Release\mesa_xml_eval.exe.manifest $(MESA_TARGET)\bin
#	cd ".."

	cd "mesa_storage"
	$(NMAKE)/f mesa_storage.mak CFG="mesa_storage - Win32 Release"
#	mt.exe -manifest Release\mesa_storage.exe.manifest -outputresource:Release\mesa_storage.exe;1
	copy Release\mesa_storage.exe $(MESA_TARGET)\bin
#	copy Release\mesa_storage.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mod_dcmps"
	$(NMAKE)/f mod_dcmps.mak CFG="mod_dcmps - Win32 Release"
#	mt.exe -manifest Release\mod_dcmps.exe.manifest -outputresource:Release\mod_dcmps.exe;1
	copy Release\mod_dcmps.exe $(MESA_TARGET)\bin
#	copy Release\mod_dcmps.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mod_generatestudy"
	$(NMAKE)/f mod_generatestudy.mak CFG="mod_generatestudy - Win32 Release"
#	mt.exe -manifest Release\mod_generatestudy.exe.manifest -outputresource:Release\mod_generatestudy.exe;1
	copy Release\mod_generatestudy.exe $(MESA_TARGET)\bin
#	copy Release\mod_generatestudy.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mpps_evaluate"
	$(NMAKE)/f mpps_evaluate.mak CFG="mpps_evaluate - Win32 Release"
#	mt.exe -manifest Release\mpps_evaluate.exe.manifest -outputresource:Release\mpps_evaluate.exe;1
	copy Release\mpps_evaluate.exe $(MESA_TARGET)\bin
#	copy Release\mpps_evaluate.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "mwlquery"
	$(NMAKE)/f mwlquery.mak CFG="mwlquery - Win32 Release"
#	mt.exe -manifest Release\mwlquery.exe.manifest -outputresource:Release\mwlquery.exe;1
	copy Release\mwlquery.exe $(MESA_TARGET)\bin
#	copy Release\mwlquery.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "naction"
	$(NMAKE)/f naction.mak CFG="naction - Win32 Release"
#	mt.exe -manifest Release\naction.exe.manifest -outputresource:Release\naction.exe;1
	copy Release\naction.exe $(MESA_TARGET)\bin
#	copy Release\naction.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ncreate"
	$(NMAKE)/f ncreate.mak CFG="ncreate - Win32 Release"
#	mt.exe -manifest Release\ncreate.exe.manifest -outputresource:Release\ncreate.exe;1
	copy Release\ncreate.exe $(MESA_TARGET)\bin
#	copy Release\ncreate.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "nevent"
	$(NMAKE)/f nevent.mak CFG="nevent - Win32 Release"
#	mt.exe -manifest Release\nevent.exe.manifest -outputresource:Release\nevent.exe;1
	copy Release\nevent.exe $(MESA_TARGET)\bin
#	copy Release\nevent.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "new_uids"
	$(NMAKE)/f new_uids.mak CFG="new_uids - Win32 Release"
#	mt.exe -manifest Release\new_uids.exe.manifest -outputresource:Release\new_uids.exe;1
	copy Release\new_uids.exe $(MESA_TARGET)\bin
#	copy Release\new_uids.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "nset"
	$(NMAKE)/f nset.mak CFG="nset - Win32 Release"
#	mt.exe -manifest Release\nset.exe.manifest -outputresource:Release\nset.exe;1
	copy Release\nset.exe $(MESA_TARGET)\bin
#	copy Release\nset.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "pp_dcmps"
	$(NMAKE)/f pp_dcmps.mak CFG="pp_dcmps - Win32 Release"
#	mt.exe -manifest Release\pp_dcmps.exe.manifest -outputresource:Release\pp_dcmps.exe;1
	copy Release\pp_dcmps.exe $(MESA_TARGET)\bin
#	copy Release\pp_dcmps.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ppm_sched_gppps"
	$(NMAKE)/f ppm_sched_gppps.mak CFG="ppm_sched_gppps - Win32 Release"
#	mt.exe -manifest Release\ppm_sched_gppps.exe.manifest -outputresource:Release\ppm_sched_gppps.exe;1
	copy Release\ppm_sched_gppps.exe $(MESA_TARGET)\bin
#	copy Release\ppm_sched_gppps.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ppm_sched_gpsps"
	$(NMAKE)/f ppm_sched_gpsps.mak CFG="ppm_sched_gpsps - Win32 Release"
#	mt.exe -manifest Release\ppm_sched_gpsps.exe.manifest -outputresource:Release\ppm_sched_gpsps.exe;1
	copy Release\ppm_sched_gpsps.exe $(MESA_TARGET)\bin
#	copy Release\ppm_sched_gpsps.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "of_dcmps"
	$(NMAKE)/f of_dcmps.mak CFG="of_dcmps - Win32 Release"
	copy Release\of_dcmps.exe $(MESA_TARGET)\bin
#	copy Release\of_dcmps.exe.manifest $(MESA_TARGET)\bin
	cd ".."

#	cd "of_hl7ps"
#	$(NMAKE)/f of_hl7ps.mak CFG="of_hl7ps - Win32 Release"
#	copy Release\of_hl7ps.exe $(MESA_TARGET)\bin
#	copy Release\of_hl7ps.exe.manifest $(MESA_TARGET)\bin
#	cd ".."

	cd "of_identifier"
	$(NMAKE)/f of_identifier.mak CFG="of_identifier - Win32 Release"
#	mt.exe -manifest Release\of_identifier.exe.manifest -outputresource:Release\of_identifier.exe;1
	copy Release\of_identifier.exe $(MESA_TARGET)\bin
#	copy Release\of_identifier.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "of_mwl_cancel"
	$(NMAKE)/f of_mwl_cancel.mak CFG="of_mwl_cancel - Win32 Release"
#	mt.exe -manifest Release\of_mwl_cancel.exe.manifest -outputresource:Release\of_mwl_cancel.exe;1
	copy Release\of_mwl_cancel.exe $(MESA_TARGET)\bin
#	copy Release\of_mwl_cancel.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "of_schedule"
	$(NMAKE)/f of_schedule.mak CFG="of_schedule - Win32 Release"
	copy Release\of_schedule.exe $(MESA_TARGET)\bin
#	copy Release\of_schedule.exe.manifest $(MESA_TARGET)\bin
	cd ".."

#	cd "op_hl7ps"
#	$(NMAKE)/f op_hl7ps.mak CFG="op_hl7ps - Win32 Release"
#	copy Release\op_hl7ps.exe $(MESA_TARGET)\bin
#	copy Release\op_hl7ps.exe.manifest $(MESA_TARGET)\bin
#	cd ".."

	cd "open_assoc"
	$(NMAKE)/f open_assoc.mak CFG="open_assoc - Win32 Release"
#	mt.exe -manifest Release\open_assoc.exe.manifest -outputresource:Release\open_assoc.exe;1
	copy Release\open_assoc.exe $(MESA_TARGET)\bin
#	copy Release\open_assoc.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "sc_scp_association"
	$(NMAKE)/f sc_scp_association.mak CFG="sc_scp_association - Win32 Release"
#	mt.exe -manifest Release\sc_scp_association.exe.manifest -outputresource:Release\sc_scp_association.exe;1
	copy Release\sc_scp_association.exe $(MESA_TARGET)\bin
#	copy Release\sc_scp_association.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "sc_scu_association"
	$(NMAKE)/f sc_scu_association.mak CFG="sc_scu_association - Win32 Release"
#	mt.exe -manifest Release\sc_scu_association.exe.manifest -outputresource:Release\sc_scu_association.exe;1
	copy Release\sc_scu_association.exe $(MESA_TARGET)\bin
#	copy Release\sc_scu_association.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "send_hl7"
	$(NMAKE)/f send_hl7.mak CFG="send_hl7 - Win32 Release"
#	mt.exe -manifest Release\send_hl7.exe.manifest -outputresource:Release\send_hl7.exe;1
	copy Release\send_hl7.exe $(MESA_TARGET)\bin
#	copy Release\send_hl7.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "send_image"
	$(NMAKE)/f send_image.mak CFG="send_image - Win32 Release"
#	mt.exe -manifest Release\send_image.exe.manifest -outputresource:Release\send_image.exe;1
	copy Release\send_image.exe $(MESA_TARGET)\bin
#	copy Release\send_image.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "simple_storage"
	$(NMAKE)/f simple_storage.mak CFG="simple_storage - Win32 Release"
#	mt.exe -manifest Release\simple_storage.exe.manifest -outputresource:Release\simple_storage.exe;1
	copy Release\simple_storage.exe $(MESA_TARGET)\bin
#	copy Release\simple_storage.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "sr_to_hl7"
	$(NMAKE)/f sr_to_hl7.mak CFG="sr_to_hl7 - Win32 Release"
#	mt.exe -manifest Release\sr_to_hl7.exe.manifest -outputresource:Release\sr_to_hl7.exe;1
	copy Release\sr_to_hl7.exe $(MESA_TARGET)\bin
#	copy Release\sr_to_hl7.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_client"
	$(NMAKE)/f syslog_client.mak CFG="syslog_client - Win32 Release"
#	mt.exe -manifest Release\syslog_client.exe.manifest -outputresource:Release\syslog_client.exe;1
	copy Release\syslog_client.exe $(MESA_TARGET)\bin
#	copy Release\syslog_client.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_extract"
	$(NMAKE)/f syslog_extract.mak CFG="syslog_extract - Win32 Release"
#	mt.exe -manifest Release\syslog_extract.exe.manifest -outputresource:Release\syslog_extract.exe;1
	copy Release\syslog_extract.exe $(MESA_TARGET)\bin
#	copy Release\syslog_extract.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_server"
	$(NMAKE)/f syslog_server.mak CFG="syslog_server - Win32 Release"
#	mt.exe -manifest Release\syslog_server.exe.manifest -outputresource:Release\syslog_server.exe;1
	copy Release\syslog_server.exe $(MESA_TARGET)\bin
#	copy Release\syslog_server.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "tcp_connect"
	$(NMAKE)/f tcp_connect.mak CFG="tcp_connect - Win32 Release"
#	mt.exe -manifest Release\tcp_connect.exe.manifest -outputresource:Release\tcp_connect.exe;1
	copy Release\tcp_connect.exe $(MESA_TARGET)\bin
#	copy Release\tcp_connect.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ttdelete"
	$(NMAKE)/f ttdelete.mak CFG="ttdelete - Win32 Release"
#	mt.exe -manifest Release\ttdelete.exe.manifest -outputresource:Release\ttdelete.exe;1
	copy Release\ttdelete.exe $(MESA_TARGET)\bin
#	copy Release\ttdelete.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ttinsert"
	$(NMAKE)/f ttinsert.mak CFG="ttinsert - Win32 Release"
#	mt.exe -manifest Release\ttinsert.exe.manifest -outputresource:Release\ttinsert.exe;1
	copy Release\ttinsert.exe $(MESA_TARGET)\bin
#	copy Release\ttinsert.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ttlayout"
	$(NMAKE)/f ttlayout.mak CFG="ttlayout - Win32 Release"
#	mt.exe -manifest Release\ttlayout.exe.manifest -outputresource:Release\ttlayout.exe;1
	copy Release\ttlayout.exe $(MESA_TARGET)\bin
#	copy Release\ttlayout.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ttselect"
	$(NMAKE)/f ttselect.mak CFG="ttselect - Win32 Release"
#	mt.exe -manifest Release\ttselect.exe.manifest -outputresource:Release\ttselect.exe;1
	copy Release\ttselect.exe $(MESA_TARGET)\bin
#	copy Release\ttselect.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ttunique"
	$(NMAKE)/f ttunique.mak CFG="ttunique - Win32 Release"
#	mt.exe -manifest Release\ttunique.exe.manifest -outputresource:Release\ttunique.exe;1
	copy Release\ttunique.exe $(MESA_TARGET)\bin
#	copy Release\ttunique.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "ttupdate"
	$(NMAKE)/f ttupdate.mak CFG="ttupdate - Win32 Release"
#	mt.exe -manifest Release\ttupdate.exe.manifest -outputresource:Release\ttupdate.exe;1
	copy Release\ttupdate.exe $(MESA_TARGET)\bin
#	copy Release\ttupdate.exe.manifest $(MESA_TARGET)\bin
	cd ".."

	cd "txt_to_hl7"
	$(NMAKE)/f txt_to_hl7.mak CFG="txt_to_hl7 - Win32 Release"
#	mt.exe -manifest Release\txt_to_hl7.exe.manifest -outputresource:Release\txt_to_hl7.exe;1
	copy Release\txt_to_hl7.exe $(MESA_TARGET)\bin
#	copy Release\txt_to_hl7.exe.manifest $(MESA_TARGET)\bin
	cd ".."

clean:
	cd "archive_agent"
	$(NMAKE)/f archive_agent.mak CFG="archive_agent - Win32 Release" clean
	cd ".."

	cd "archive_cleaner"
	$(NMAKE)/f archive_cleaner.mak CFG="archive_cleaner - Win32 Release" clean
	cd ".."

	cd "archive_server"
	$(NMAKE)/f archive_server.mak CFG="archive_server - Win32 Release" clean
	cd ".."

	cd "cfind"
	$(NMAKE)/f cfind.mak CFG="cfind - Win32 Release" clean
	cd ".."

	cd "cfind_evaluate"
	$(NMAKE)/f cfind_evaluate.mak CFG="cfind_evaluate - Win32 Release" clean
	cd ".."

	cd "cfind_gpsps_evaluate"
	$(NMAKE)/f cfind_gpsps_evaluate.mak CFG="cfind_gpsps_evaluate - Win32 Release" clean
	cd ".."

	cd "cfind_image_avail"
	$(NMAKE)/f cfind_image_avail.mak CFG="cfind_image_avail - Win32 Release" clean
	cd ".."

	cd "cfind_mwl_evaluate"
	$(NMAKE)/f cfind_mwl_evaluate.mak CFG="cfind_mwl_evaluate - Win32 Release" clean
	cd ".."

	cd "cfind_resp_evaluate"
	$(NMAKE)/f cfind_resp_evaluate.mak CFG="cfind_resp_evaluate - Win32 Release" clean
	cd ".."

	cd "cfind_study_probe"
	$(NMAKE)/f cfind_study_probe.mak CFG="cfind_study_probe - Win32 Release" clean
	cd ".."

	cd "cmove"
	$(NMAKE)/f cmove.mak CFG="cmove - Win32 Release" clean
	cd ".."

	cd "cmove_study"
	$(NMAKE)/f cmove_study.mak CFG="cmove_study - Win32 Release" clean
	cd ".."

	cd "compare_dcm"
	$(NMAKE)/f compare_dcm.mak CFG="compare_dcm - Win32 Release" clean
	cd ".."

	cd "compare_hl7"
	$(NMAKE)/f compare_hl7.mak CFG="compare_hl7 - Win32 Release" clean
	cd ".."

	cd "cstore"
	$(NMAKE)/f cstore.mak CFG="cstore - Win32 Release" clean
	cd ".."

	cd "ctn_version"
	$(NMAKE)/f ctn_version.mak CFG="ctn_version - Win32 Release" clean
	cd ".."

	cd "dcm_create_object"
	$(NMAKE)/f dcm_create_object.mak CFG="dcm_create_object - Win32 Release" clean
	cd ".."

	cd "dcm_ctnto10"
	$(NMAKE)/f dcm_ctnto10.mak CFG="dcm_ctnto10 - Win32 Release" clean
	cd ".."

	cd "dcm_diff"
	$(NMAKE)/f dcm_diff.mak CFG="dcm_diff - Win32 Release" clean
	cd ".."

	cd "dcm_dump_compressed"
	$(NMAKE)/f dcm_dump_compressed.mak CFG="dcm_dump_compressed - Win32 Release" clean
	cd ".."

	cd "dcm_dump_element"
	$(NMAKE)/f dcm_dump_element.mak CFG="dcm_dump_element - Win32 Release" clean
	cd ".."

	cd "dcm_dump_file"
	$(NMAKE)/f dcm_dump_file.mak CFG="dcm_dump_file - Win32 Release" clean
	cd ".."

	cd "dcm_get_elements"
	$(NMAKE)/f dcm_get_elements.mak CFG="dcm_get_elements - Win32 Release" clean
	cd ".."

	cd "dcm_iterator"
	$(NMAKE)/f dcm_iterator.mak CFG="dcm_iterator - Win32 Release" clean
	cd ".."

	cd "dcm_make_object"
	$(NMAKE)/f dcm_make_object.mak CFG="dcm_make_object - Win32 Release" clean
	cd ".."

	cd "dcm_map_to_8"
	$(NMAKE)/f dcm_map_to_8.mak CFG="dcm_map_to_8 - Win32 Release" clean
	cd ".."

	cd "dcm_mask_image"
	$(NMAKE)/f dcm_mask_image.mak CFG="dcm_mask_image - Win32 Release" clean
	cd ".."

	cd "dcm_modify_elements"
	$(NMAKE)/f dcm_modify_elements.mak CFG="dcm_modify_elements - Win32 Release" clean
	cd ".."

	cd "dcm_modify_object"
	$(NMAKE)/f dcm_modify_object.mak CFG="dcm_modify_object - Win32 Release" clean
	cd ".."

	cd "dcm_print_dictionary"
	$(NMAKE)/f dcm_print_dictionary.mak CFG="dcm_print_dictionary - Win32 Release" clean
	cd ".."

	cd "dcm_print_element"
	$(NMAKE)/f dcm_print_element.mak CFG="dcm_print_element - Win32 Release" clean
	cd ".."

	cd "dcm_ref_sop_seq"
	$(NMAKE)/f dcm_ref_sop_seq.mak CFG="dcm_ref_sop_seq - Win32 Release" clean
	cd ".."

	cd "dcm_replace_element"
	$(NMAKE)/f dcm_replace_element.mak CFG="dcm_replace_element - Win32 Release" clean
	cd ".."

	cd "dcm_resize"
	$(NMAKE)/f dcm_resize.mak CFG="dcm_resize - Win32 Release" clean
	cd ".."

	cd "dcm_rm_element"
	$(NMAKE)/f dcm_rm_element.mak CFG="dcm_rm_element - Win32 Release" clean
	cd ".."

	cd "dcm_rm_group"
	$(NMAKE)/f dcm_rm_group.mak CFG="dcm_rm_group - Win32 Release" clean
	cd ".."

	cd "dcm_strip_odd_groups"
	$(NMAKE)/f dcm_strip_odd_groups.mak CFG="dcm_strip_odd_groups - Win32 Release" clean
	cd ".."

	cd "dcm_to_html"
	$(NMAKE)/f dcm_to_html.mak CFG="dcm_to_html - Win32 Release" clean
	cd ".."

	cd "dcm_to_text"
	$(NMAKE)/f dcm_to_text.mak CFG="dcm_to_text - Win32 Release" clean
	cd ".."

	cd "dcm_to_xml"
	$(NMAKE)/f dcm_to_xml.mak CFG="dcm_to_xml - Win32 Release" clean
	cd ".."

	cd "dcm_vr_patterns"
	$(NMAKE)/f dcm_vr_patterns.mak CFG="dcm_vr_patterns - Win32 Release" clean
	cd ".."

	cd "dcm_w_disp"
	$(NMAKE)/f dcm_w_disp.mak CFG="dcm_w_disp - Win32 Release" clean
	cd ".."

	cd "dicom_echo"
	$(NMAKE)/f dicom_echo.mak CFG="dicom_echo - Win32 Release" clean
	cd ".."

	cd "ds_dcm"
	$(NMAKE)/f ds_dcm.mak CFG="ds_dcm - Win32 Release" clean
	cd ".."

	cd "dump_commit_requests"
	$(NMAKE)/f dump_commit_requests.mak CFG="dump_commit_requests - Win32 Release" clean
	cd ".."

	cd "hl7_get_value"
	$(NMAKE)/f hl7_get_value.mak CFG="hl7_get_value - Win32 Release" clean
	cd ".."

	cd "hl7_evaluate"
	$(NMAKE)/f hl7_evaluate.mak CFG="hl7_evaluate - Win32 Release" clean
	cd ".."

	cd "hl7_rcvr"
	$(NMAKE)/f hl7_rcvr.mak CFG="hl7_rcvr - Win32 Release" clean
	cd ".."

	cd "evaluate_gppps"
	$(NMAKE)/f evaluate_gppps.mak CFG="evaluate_gppps - Win32 Release" clean
	cd ".."

	cd "evaluate_storage_commitment"
	$(NMAKE)/f evaluate_storage_commitment.mak CFG="evaluate_storage_commitment - Win32 Release" clean
	cd ".."

	cd "hl7_set_value"
	$(NMAKE)/f hl7_set_value.mak CFG="hl7_set_value - Win32 Release" clean
	cd ".."

	cd "hl7_to_txt"
	$(NMAKE)/f hl7_to_txt.mak CFG="hl7_to_txt - Win32 Release" clean
	cd ".."

	cd "ihe_audit_message"
	$(NMAKE)/f ihe_audit_message.mak CFG="ihe_audit_message - Win32 Release" clean
	cd ".."

#	cd "im_hl7ps"
#	$(NMAKE)/f im_hl7ps.mak CFG="im_hl7ps - Win32 Release" clean
#	cd ".."

	cd "im_sc_agent"
	$(NMAKE)/f im_sc_agent.mak CFG="im_sc_agent - Win32 Release" clean
	cd ".."

	cd "kill_hl7"
	$(NMAKE)/f kill_hl7.mak CFG="kill_hl7 - Win32 Release" clean
	cd ".."

	cd "load_control"
	$(NMAKE)/f load_control.mak CFG="load_control - Win32 Release" clean
	cd ".."

	cd "mesa_audit_eval"
	$(NMAKE)/f mesa_audit_eval.mak CFG="mesa_audit_eval - Win32 Release" clean
	cd ".."

	cd "mesa_composite_eval"
	$(NMAKE)/f mesa_composite_eval.mak CFG="mesa_composite_eval - Win32 Release" clean
	cd ".."

	cd "mesa_db_test"
	$(NMAKE)/f mesa_db_test.mak CFG="mesa_db_test - Win32 Release" clean
	cd ".."

	cd "mesa_dump_dicomdir"
	$(NMAKE)/f mesa_dump_dicomdir.mak CFG="mesa_dump_dicomdir - Win32 Release" clean
	cd ".."

	cd "mesa_dump_obj"
	$(NMAKE)/f mesa_dump_obj.mak CFG="mesa_dump_obj - Win32 Release" clean
	cd ".."


	cd "mesa_extract_nm_frames"
	$(NMAKE)/f mesa_extract_nm_frames.mak CFG="mesa_extract_nm_frames - Win32 Release" clean
	cd "..

	cd "mesa_identifier"
	$(NMAKE)/f mesa_identifier.mak CFG="mesa_identifier - Win32 Release" clean
	cd ".."

	cd "mesa_mwl_add_sps"
	$(NMAKE)/f mesa_mwl_add_sps.mak CFG="mesa_mwl_add_sps - Win32 Release" clean
	cd ".."

	cd "mesa_mwl_sps_from_mpps"
	$(NMAKE)/f mesa_mwl_sps_from_mpps.mak CFG="mesa_mwl_sps_from_mpps - Win32 Release" clean
	cd ".."

	cd "mesa_select_column"
	$(NMAKE)/f mesa_select_column.mak CFG="mesa_select_column - Win32 Release" clean
	cd ".."

	cd "mesa_pdi_eval"
	$(NMAKE)/f mesa_pdi_eval.mak CFG="mesa_pdi_eval - Win32 Release" clean
	cd ".."

	cd "mesa_sr_eval"
	$(NMAKE)/f mesa_sr_eval.mak CFG="mesa_sr_eval - Win32 Release" clean
	cd ".."

	cd "mesa_strip_file"
	$(NMAKE)/f mesa_strip_file.mak CFG="mesa_strip_file - Win32 Release" clean
	cd ".."
	cd "mesa_update_column"
	$(NMAKE)/f mesa_update_column.mak CFG="mesa_update_column - Win32 Release" clean
	cd ".."

	cd "mesa_xml_eval"
	$(NMAKE)/f mesa_xml_eval.mak CFG="mesa_xml_eval - Win32 Release" clean
	cd ".."

	cd "mesa_storage"
	$(NMAKE)/f mesa_storage.mak CFG="mesa_storage - Win32 Release" clean
	cd ".."

	cd "mod_dcmps"
	$(NMAKE)/f mod_dcmps.mak CFG="mod_dcmps - Win32 Release" clean
	cd ".."

	cd "mod_generatestudy"
	$(NMAKE)/f mod_generatestudy.mak CFG="mod_generatestudy - Win32 Release" clean
	cd ".."

	cd "mpps_evaluate"
	$(NMAKE)/f mpps_evaluate.mak CFG="mpps_evaluate - Win32 Release" clean
	cd ".."

	cd "mwlquery"
	$(NMAKE)/f mwlquery.mak CFG="mwlquery - Win32 Release" clean
	cd ".."

	cd "naction"
	$(NMAKE)/f naction.mak CFG="naction - Win32 Release" clean
	cd ".."

	cd "ncreate"
	$(NMAKE)/f ncreate.mak CFG="ncreate - Win32 Release" clean
	cd ".."

	cd "nevent"
	$(NMAKE)/f nevent.mak CFG="nevent - Win32 Release" clean
	cd ".."

	cd "new_uids"
	$(NMAKE)/f new_uids.mak CFG="new_uids - Win32 Release" clean
	cd ".."

	cd "nset"
	$(NMAKE)/f nset.mak CFG="nset - Win32 Release" clean
	cd ".."

	cd "pp_dcmps"
	$(NMAKE)/f pp_dcmps.mak CFG="pp_dcmps - Win32 Release" clean
	cd ".."

	cd "ppm_sched_gppps"
	$(NMAKE)/f ppm_sched_gppps.mak CFG="ppm_sched_gppps - Win32 Release" clean
	cd ".."

	cd "ppm_sched_gpsps"
	$(NMAKE)/f ppm_sched_gpsps.mak CFG="ppm_sched_gpsps - Win32 Release" clean
	cd ".."

	cd "of_dcmps"
	$(NMAKE)/f of_dcmps.mak CFG="of_dcmps - Win32 Release" clean
	cd ".."

#	cd "of_hl7ps"
#	$(NMAKE)/f of_hl7ps.mak CFG="of_hl7ps - Win32 Release" clean
#	cd ".."

	cd "of_identifier"
	$(NMAKE)/f of_identifier.mak CFG="of_identifier - Win32 Release" clean
	cd ".."

	cd "of_mwl_cancel"
	$(NMAKE)/f of_mwl_cancel.mak CFG="of_mwl_cancel - Win32 Release" clean
	cd ".."

	cd "of_schedule"
	$(NMAKE)/f of_schedule.mak CFG="of_schedule - Win32 Release" clean
	cd ".."

#	cd "op_hl7ps"
#	$(NMAKE)/f op_hl7ps.mak CFG="op_hl7ps - Win32 Release" clean
#	cd ".."

	cd "open_assoc"
	$(NMAKE)/f open_assoc.mak CFG="open_assoc - Win32 Release" clean
	cd ".."

	cd "sc_scp_association"
	$(NMAKE)/f sc_scp_association.mak CFG="sc_scp_association - Win32 Release" clean
	cd ".."

	cd "sc_scu_association"
	$(NMAKE)/f sc_scu_association.mak CFG="sc_scu_association - Win32 Release" clean
	cd ".."

	cd "send_hl7"
	$(NMAKE)/f send_hl7.mak CFG="send_hl7 - Win32 Release" clean
	cd ".."

	cd "send_image"
	$(NMAKE)/f send_image.mak CFG="send_image - Win32 Release" clean
	cd ".."

	cd "simple_storage"
	$(NMAKE)/f simple_storage.mak CFG="simple_storage - Win32 Release" clean
	cd ".."

	cd "sr_to_hl7"
	$(NMAKE)/f sr_to_hl7.mak CFG="sr_to_hl7 - Win32 Release" clean
	cd ".."

	cd "syslog_client"
	$(NMAKE)/f syslog_client.mak CFG="syslog_client - Win32 Release" clean
	cd ".."

	cd "syslog_extract"
	$(NMAKE)/f syslog_extract.mak CFG="syslog_extract - Win32 Release" clean
	cd ".."

	cd "syslog_server"
	$(NMAKE)/f syslog_server.mak CFG="syslog_server - Win32 Release" clean
	cd ".."

	cd "tcp_connect"
	$(NMAKE)/f tcp_connect.mak CFG="tcp_connect - Win32 Release" clean
	cd ".."

	cd "ttdelete"
	$(NMAKE)/f ttdelete.mak CFG="ttdelete - Win32 Release" clean
	cd ".."

	cd "ttinsert"
	$(NMAKE)/f ttinsert.mak CFG="ttinsert - Win32 Release" clean
	cd ".."

	cd "ttlayout"
	$(NMAKE)/f ttlayout.mak CFG="ttlayout - Win32 Release" clean
	cd ".."

	cd "ttselect"
	$(NMAKE)/f ttselect.mak CFG="ttselect - Win32 Release" clean
	cd ".."

	cd "ttunique"
	$(NMAKE)/f ttunique.mak CFG="ttunique - Win32 Release" clean
	cd ".."

	cd "ttupdate"
	$(NMAKE)/f ttupdate.mak CFG="ttupdate - Win32 Release" clean
	cd ".."

	cd "txt_to_hl7"
	$(NMAKE)/f txt_to_hl7.mak CFG="txt_to_hl7 - Win32 Release" clean
	cd ".."

install_debug:
	cd "archive_agent"
	$(NMAKE)/f archive_agent.mak CFG="archive_agent - Win32 Debug"
	copy Debug\archive_agent.exe $(MESA_TARGET)\bin
	cd ".."

	cd "archive_cleaner"
	$(NMAKE)/f archive_cleaner.mak CFG="archive_cleaner - Win32 Debug"
	copy Debug\archive_cleaner.exe $(MESA_TARGET)\bin
	cd ".."

	cd "archive_server"
	$(NMAKE)/f archive_server.mak CFG="archive_server - Win32 Debug"
	copy Debug\archive_server.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cfind"
	$(NMAKE)/f cfind.mak CFG="cfind - Win32 Debug"
	copy Debug\cfind.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_evaluate"
	$(NMAKE)/f cfind_evaluate.mak CFG="cfind_evaluate - Win32 Debug"
	copy Debug\cfind_evaluate.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_gpsps_evaluate"
	$(NMAKE)/f cfind_gpsps_evaluate.mak CFG="cfind_gpsps_evaluate - Win32 Debug"
	copy Debug\cfind_gpsps_evaluate.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_image_avail"
	$(NMAKE)/f cfind_image_avail.mak CFG="cfind_image_avail - Win32 Debug"
	copy Debug\cfind_image_avail.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_mwl_evaluate"
	$(NMAKE)/f cfind_mwl_evaluate.mak CFG="cfind_mwl_evaluate - Win32 Debug"
	copy Debug\cfind_mwl_evaluate.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_resp_evaluate"
	$(NMAKE)/f cfind_resp_evaluate.mak CFG="cfind_resp_evaluate - Win32 Debug"
	copy Debug\cfind_resp_evaluate.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cfind_study_probe"
	$(NMAKE)/f cfind_study_probe.mak CFG="cfind_study_probe - Win32 Debug"
	copy Debug\cfind_study_probe.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cmove"
	$(NMAKE)/f cmove.mak CFG="cmove - Win32 Debug"
	copy Debug\cmove.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cmove_study"
	$(NMAKE)/f cmove_study.mak CFG="cmove_study - Win32 Debug"
	copy Debug\cmove_study.exe $(MESA_TARGET)\bin
	cd ".."

	cd "compare_dcm"
	$(NMAKE)/f compare_dcm.mak CFG="compare_dcm - Win32 Debug"
	copy Debug\compare_dcm.exe $(MESA_TARGET)\bin
	cd ".."

	cd "compare_hl7"
	$(NMAKE)/f compare_hl7.mak CFG="compare_hl7 - Win32 Debug"
	copy Debug\compare_hl7.exe $(MESA_TARGET)\bin
	cd ".."

	cd "cstore"
	$(NMAKE)/f cstore.mak CFG="cstore - Win32 Debug"
	copy Debug\cstore.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ctn_version"
	$(NMAKE)/f ctn_version.mak CFG="ctn_version - Win32 Debug"
	copy Debug\ctn_version.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_create_object"
	$(NMAKE)/f dcm_create_object.mak CFG="dcm_create_object - Win32 Debug"
	copy Debug\dcm_create_object.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_ctnto10"
	$(NMAKE)/f dcm_ctnto10.mak CFG="dcm_ctnto10 - Win32 Debug"
	copy Debug\dcm_ctnto10.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_diff"
	$(NMAKE)/f dcm_diff.mak CFG="dcm_diff - Win32 Debug"
	copy Debug\dcm_diff.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_dump_compressed"
	$(NMAKE)/f dcm_dump_compressed.mak CFG="dcm_dump_compressed - Win32 Debug"
	copy Debug\dcm_dump_compressed.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_dump_element"
	$(NMAKE)/f dcm_dump_element.mak CFG="dcm_dump_element - Win32 Debug"
	copy Debug\dcm_dump_element.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_dump_file"
	$(NMAKE)/f dcm_dump_file.mak CFG="dcm_dump_file - Win32 Debug"
	copy Debug\dcm_dump_file.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_get_elements"
	$(NMAKE)/f dcm_get_elements.mak CFG="dcm_get_elements - Win32 Debug"
	copy Debug\dcm_get_elements.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_iterator"
	$(NMAKE)/f dcm_iterator.mak CFG="dcm_iterator - Win32 Debug"
	copy Debug\dcm_iterator.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_make_object"
	$(NMAKE)/f dcm_make_object.mak CFG="dcm_make_object - Win32 Debug"
	copy Debug\dcm_make_object.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_map_to_8"
	$(NMAKE)/f dcm_map_to_8.mak CFG="dcm_map_to_8 - Win32 Debug"
	copy Debug\dcm_map_to_8.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_modify_elements"
	$(NMAKE)/f dcm_modify_elements.mak CFG="dcm_modify_elements - Win32 Debug"
	copy Debug\dcm_modify_elements.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_modify_object"
	$(NMAKE)/f dcm_modify_object.mak CFG="dcm_modify_object - Win32 Debug"
	copy Debug\dcm_modify_object.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_print_dictionary"
	$(NMAKE)/f dcm_print_dictionary.mak CFG="dcm_print_dictionary - Win32 Debug"
	copy Debug\dcm_print_dictionary.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_print_element"
	$(NMAKE)/f dcm_print_element.mak CFG="dcm_print_element - Win32 Debug"
	copy Debug\dcm_print_element.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_ref_sop_seq"
	$(NMAKE)/f dcm_ref_sop_seq.mak CFG="dcm_ref_sop_seq - Win32 Debug"
	copy Debug\dcm_ref_sop_seq.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_replace_element"
	$(NMAKE)/f dcm_replace_element.mak CFG="dcm_replace_element - Win32 Debug"
	copy Debug\dcm_replace_element.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_resize"
	$(NMAKE)/f dcm_resize.mak CFG="dcm_resize - Win32 Debug"
	copy Debug\dcm_resize.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_rm_element"
	$(NMAKE)/f dcm_rm_element.mak CFG="dcm_rm_element - Win32 Debug"
	copy Debug\dcm_rm_element.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_rm_group"
	$(NMAKE)/f dcm_rm_group.mak CFG="dcm_rm_group - Win32 Debug"
	copy Debug\dcm_rm_group.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_strip_odd_groups"
	$(NMAKE)/f dcm_strip_odd_groups.mak CFG="dcm_strip_odd_groups - Win32 Debug"
	copy Debug\dcm_strip_odd_groups.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_to_html"
	$(NMAKE)/f dcm_to_html.mak CFG="dcm_to_html - Win32 Debug"
	copy Debug\dcm_to_html.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_to_text"
	$(NMAKE)/f dcm_to_text.mak CFG="dcm_to_text - Win32 Debug"
	copy Debug\dcm_to_text.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_to_xml"
	$(NMAKE)/f dcm_to_xml.mak CFG="dcm_to_xml - Win32 Debug"
	copy Debug\dcm_to_xml.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_vr_patterns"
	$(NMAKE)/f dcm_vr_patterns.mak CFG="dcm_vr_patterns - Win32 Debug"
	copy Debug\dcm_vr_patterns.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dcm_w_disp"
	$(NMAKE)/f dcm_w_disp.mak CFG="dcm_w_disp - Win32 Debug"
	copy Debug\dcm_w_disp.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dicom_echo"
	$(NMAKE)/f dicom_echo.mak CFG="dicom_echo - Win32 Debug"
	copy Debug\dicom_echo.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ds_dcm"
	$(NMAKE)/f ds_dcm.mak CFG="ds_dcm - Win32 Debug"
	copy Debug\ds_dcm.exe $(MESA_TARGET)\bin
	cd ".."

	cd "dump_commit_requests"
	$(NMAKE)/f dump_commit_requests.mak CFG="dump_commit_requests - Win32 Debug"
	copy Debug\dump_commit_requests.exe $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_evaluate"
	$(NMAKE)/f hl7_evaluate.mak CFG="hl7_evaluate - Win32 Debug"
	copy Debug\hl7_evaluate.exe $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_rcvr"
	$(NMAKE)/f hl7_rcvr.mak CFG="hl7_rcvr - Win32 Debug"
	copy Debug\hl7_rcvr.exe $(MESA_TARGET)\bin
	cd ".."

	cd "evaluate_gppps"
	$(NMAKE)/f evaluate_gppps.mak CFG="evaluate_gppps - Win32 Debug"
	copy Debug\evaluate_gppps.exe $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_get_value"
	$(NMAKE)/f hl7_get_value.mak CFG="hl7_get_value - Win32 Debug"
	copy Debug\hl7_get_value.exe $(MESA_TARGET)\bin
	cd ".."

	cd "hl7_set_value"
	$(NMAKE)/f hl7_set_value.mak CFG="hl7_set_value - Win32 Debug"
	copy Debug\hl7_set_value.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ihe_audit_message"
	$(NMAKE)/f ihe_audit_message.mak CFG="ihe_audit_message - Win32 Debug"
	copy Debug\ihe_audit_message.exe $(MESA_TARGET)\bin
	cd ".."

#	cd "im_hl7ps"
#	$(NMAKE)/f im_hl7ps.mak CFG="im_hl7ps - Win32 Debug"
#	copy Debug\im_hl7ps.exe $(MESA_TARGET)\bin
#	cd ".."

	cd "kill_hl7"
	$(NMAKE)/f kill_hl7.mak CFG="kill_hl7 - Win32 Debug"
	copy Debug\kill_hl7.exe $(MESA_TARGET)\bin
	cd ".."

	cd "load_control"
	$(NMAKE)/f load_control.mak CFG="load_control - Win32 Debug"
	copy Debug\load_control.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_audit_eval"
	$(NMAKE)/f mesa_audit_eval.mak CFG="mesa_audit_eval - Win32 Debug"
	copy Debug\mesa_audit_eval.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_composite_eval"
	$(NMAKE)/f mesa_composite_eval.mak CFG="mesa_composite_eval - Win32 Debug"
	copy Debug\mesa_composite_eval.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_db_test"
	$(NMAKE)/f mesa_db_test.mak CFG="mesa_db_test - Win32 Debug"
	copy Debug\mesa_db_test.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_dump_dicomdir"
	$(NMAKE)/f mesa_dump_dicomdir.mak CFG="mesa_dump_dicomdir - Win32 Debug"
	copy Debug\mesa_dump_dicomdir.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_dump_obj"
	$(NMAKE)/f mesa_dump_obj.mak CFG="mesa_dump_obj - Win32 Debug"
	copy Debug\mesa_dump_obj.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_extract_nm_frames"
	$(NMAKE)/f mesa_extract_nm_frames.mak CFG="mesa_extract_nm_frames - Win32 Debug"
	copy Debug\mesa_extract_nm_frames.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_identifier"
	$(NMAKE)/f mesa_identifier.mak CFG="mesa_identifier - Win32 Debug"
	copy Debug\mesa_identifier.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_mwl_add_sps"
	$(NMAKE)/f mesa_mwl_add_sps.mak CFG="mesa_mwl_add_sps - Win32 Debug"
	copy Debug\mesa_mwl_add_sps.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_mwl_sps_from_mpps"
	$(NMAKE)/f mesa_mwl_sps_from_mpps.mak CFG="mesa_mwl_sps_from_mpps - Win32 Debug"
	copy Debug\mesa_mwl_sps_from_mpps.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_select_column"
	$(NMAKE)/f mesa_select_column.mak CFG="mesa_select_column - Win32 Debug"
	copy Debug\mesa_select_column.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_pdi_eval"
	$(NMAKE)/f mesa_pdi_eval.mak CFG="mesa_pdi_eval - Win32 Debug"
	copy Debug\mesa_pdi_eval.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_sr_eval"
	$(NMAKE)/f mesa_sr_eval.mak CFG="mesa_sr_eval - Win32 Debug"
	copy Debug\mesa_sr_eval.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_strip_file"
	$(NMAKE)/f mesa_strip_file.mak CFG="mesa_strip_file - Win32 Debug"
	copy Debug\mesa_strip_file.exe $(MESA_TARGET)\bin
	cd ".."
	cd "mesa_update_column"
	$(NMAKE)/f mesa_update_column.mak CFG="mesa_update_column - Win32 Debug"
	copy Debug\mesa_update_column.exe $(MESA_TARGET)\bin
	cd ".."


	cd "mesa_xml_eval"
	$(NMAKE)/f mesa_xml_eval.mak CFG="mesa_xml_eval - Win32 Debug"
	copy Debug\mesa_xml_eval.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mesa_storage"
	$(NMAKE)/f mesa_storage.mak CFG="mesa_storage - Win32 Debug"
	copy Debug\mesa_storage.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mod_dcmps"
	$(NMAKE)/f mod_dcmps.mak CFG="mod_dcmps - Win32 Debug"
	copy Debug\mod_dcmps.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mod_generatestudy"
	$(NMAKE)/f mod_generatestudy.mak CFG="mod_generatestudy - Win32 Debug"
	copy Debug\mod_generatestudy.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mpps_evaluate"
	$(NMAKE)/f mpps_evaluate.mak CFG="mpps_evaluate - Win32 Debug"
	copy Debug\mpps_evaluate.exe $(MESA_TARGET)\bin
	cd ".."

	cd "mwlquery"
	$(NMAKE)/f mwlquery.mak CFG="mwlquery - Win32 Debug"
	copy Debug\mwlquery.exe $(MESA_TARGET)\bin
	cd ".."

	cd "naction"
	$(NMAKE)/f naction.mak CFG="naction - Win32 Debug"
	copy Debug\naction.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ncreate"
	$(NMAKE)/f ncreate.mak CFG="ncreate - Win32 Debug"
	copy Debug\ncreate.exe $(MESA_TARGET)\bin
	cd ".."

	cd "nevent"
	$(NMAKE)/f nevent.mak CFG="nevent - Win32 Debug"
	copy Debug\nevent.exe $(MESA_TARGET)\bin
	cd ".."

	cd "new_uids"
	$(NMAKE)/f new_uids.mak CFG="new_uids - Win32 Debug"
	copy Debug\new_uids.exe $(MESA_TARGET)\bin
	cd ".."

	cd "nset"
	$(NMAKE)/f nset.mak CFG="nset - Win32 Debug"
	copy Debug\nset.exe $(MESA_TARGET)\bin
	cd ".."

	cd "pp_dcmps"
	$(NMAKE)/f pp_dcmps.mak CFG="pp_dcmps - Win32 Debug"
	copy Debug\pp_dcmps.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ppm_sched_gppps"
	$(NMAKE)/f ppm_sched_gppps.mak CFG="ppm_sched_gppps - Win32 Debug"
	copy Debug\ppm_sched_gppps.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ppm_sched_gpsps"
	$(NMAKE)/f ppm_sched_gpsps.mak CFG="ppm_sched_gpsps - Win32 Debug"
	copy Debug\ppm_sched_gpsps.exe $(MESA_TARGET)\bin
	cd ".."

	cd "of_dcmps"
	$(NMAKE)/f of_dcmps.mak CFG="of_dcmps - Win32 Debug"
	copy Debug\of_dcmps.exe $(MESA_TARGET)\bin
	cd ".."

#	cd "of_hl7ps"
#	$(NMAKE)/f of_hl7ps.mak CFG="of_hl7ps - Win32 Debug"
#	copy Debug\of_hl7ps.exe $(MESA_TARGET)\bin
#	cd ".."

	cd "of_identifier"
	$(NMAKE)/f of_identifier.mak CFG="of_identifier - Win32 Debug"
	copy Debug\of_identifier.exe $(MESA_TARGET)\bin
	cd ".."

	cd "of_mwl_cancel"
	$(NMAKE)/f of_mwl_cancel.mak CFG="of_mwl_cancel - Win32 Debug"
	copy Debug\of_mwl_cancel.exe $(MESA_TARGET)\bin
	cd ".."

	cd "of_schedule"
	$(NMAKE)/f of_schedule.mak CFG="of_schedule - Win32 Debug"
	copy Debug\of_schedule.exe $(MESA_TARGET)\bin
	cd ".."

#	cd "op_hl7ps"
#	$(NMAKE)/f op_hl7ps.mak CFG="op_hl7ps - Win32 Debug"
#	copy Debug\op_hl7ps.exe $(MESA_TARGET)\bin
#	cd ".."

	cd "open_assoc"
	$(NMAKE)/f open_assoc.mak CFG="open_assoc - Win32 Debug"
	copy Debug\open_assoc.exe $(MESA_TARGET)\bin
	cd ".."

	cd "sc_scp_association"
	$(NMAKE)/f sc_scp_association.mak CFG="sc_scp_association - Win32 Debug"
	copy Debug\sc_scp_association.exe $(MESA_TARGET)\bin
	cd ".."

	cd "sc_scu_association"
	$(NMAKE)/f sc_scu_association.mak CFG="sc_scu_association - Win32 Debug"
	copy Debug\sc_scu_association.exe $(MESA_TARGET)\bin
	cd ".."

	cd "send_hl7"
	$(NMAKE)/f send_hl7.mak CFG="send_hl7 - Win32 Debug"
	copy Debug\send_hl7.exe $(MESA_TARGET)\bin
	cd ".."

	cd "send_image"
	$(NMAKE)/f send_image.mak CFG="send_image - Win32 Debug"
	copy Debug\send_image.exe $(MESA_TARGET)\bin
	cd ".."

	cd "simple_storage"
	$(NMAKE)/f simple_storage.mak CFG="simple_storage - Win32 Debug"
	copy Debug\simple_storage.exe $(MESA_TARGET)\bin
	cd ".."

	cd "sr_to_hl7"
	$(NMAKE)/f sr_to_hl7.mak CFG="sr_to_hl7 - Win32 Debug"
	copy Debug\sr_to_hl7.exe $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_client"
	$(NMAKE)/f syslog_client.mak CFG="syslog_client - Win32 Debug"
	copy Debug\syslog_client.exe $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_extract"
	$(NMAKE)/f syslog_extract.mak CFG="syslog_extract - Win32 Debug"
	copy Debug\syslog_extract.exe $(MESA_TARGET)\bin
	cd ".."

	cd "syslog_server"
	$(NMAKE)/f syslog_server.mak CFG="syslog_server - Win32 Debug"
	copy Debug\syslog_server.exe $(MESA_TARGET)\bin
	cd ".."

	cd "tcp_connect"
	$(NMAKE)/f tcp_connect.mak CFG="tcp_connect - Win32 Debug"
	copy Debug\tcp_connect.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ttdelete"
	$(NMAKE)/f ttdelete.mak CFG="ttdelete - Win32 Debug"
	copy Debug\ttdelete.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ttinsert"
	$(NMAKE)/f ttinsert.mak CFG="ttinsert - Win32 Debug"
	copy Debug\ttinsert.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ttlayout"
	$(NMAKE)/f ttlayout.mak CFG="ttlayout - Win32 Debug"
	copy Debug\ttlayout.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ttselect"
	$(NMAKE)/f ttselect.mak CFG="ttselect - Win32 Debug"
	copy Debug\ttselect.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ttunique"
	$(NMAKE)/f ttunique.mak CFG="ttunique - Win32 Debug"
	copy Debug\ttunique.exe $(MESA_TARGET)\bin
	cd ".."

	cd "ttupdate"
	$(NMAKE)/f ttupdate.mak CFG="ttupdate - Win32 Debug"
	copy Debug\ttupdate.exe $(MESA_TARGET)\bin
	cd ".."

	cd "txt_to_hl7"
	$(NMAKE)/f txt_to_hl7.mak CFG="txt_to_hl7 - Win32 Debug"
	copy Debug\txt_to_hl7.exe $(MESA_TARGET)\bin
	cd ".."

clean_debug:
	cd "archive_agent"
	$(NMAKE)/f archive_agent.mak CFG="archive_agent - Win32 Debug" clean
	cd ".."

	cd "archive_cleaner"
	$(NMAKE)/f archive_cleaner.mak CFG="archive_cleaner - Win32 Debug" clean
	cd ".."

	cd "archive_server"
	$(NMAKE)/f archive_server.mak CFG="archive_server - Win32 Debug" clean
	cd ".."

	cd "cfind"
	$(NMAKE)/f cfind.mak CFG="cfind - Win32 Debug" clean
	cd ".."

	cd "cfind_evaluate"
	$(NMAKE)/f cfind_evaluate.mak CFG="cfind_evaluate - Win32 Debug" clean
	cd ".."

	cd "cfind_gpsps_evaluate"
	$(NMAKE)/f cfind_gpsps_evaluate.mak CFG="cfind_gpsps_evaluate - Win32 Debug" clean
	cd ".."

	cd "cfind_image_avail"
	$(NMAKE)/f cfind_image_avail.mak CFG="cfind_image_avail - Win32 Debug" clean
	cd ".."

	cd "cfind_mwl_evaluate"
	$(NMAKE)/f cfind_mwl_evaluate.mak CFG="cfind_mwl_evaluate - Win32 Debug" clean
	cd ".."

	cd "cfind_resp_evaluate"
	$(NMAKE)/f cfind_resp_evaluate.mak CFG="cfind_resp_evaluate - Win32 Debug" clean
	cd ".."

	cd "cfind_study_probe"
	$(NMAKE)/f cfind_study_probe.mak CFG="cfind_study_probe - Win32 Debug" clean
	cd ".."

	cd "cmove"
	$(NMAKE)/f cmove.mak CFG="cmove - Win32 Debug" clean
	cd ".."

	cd "cmove_study"
	$(NMAKE)/f cmove_study.mak CFG="cmove_study - Win32 Debug" clean
	cd ".."

	cd "compare_dcm"
	$(NMAKE)/f compare_dcm.mak CFG="compare_dcm - Win32 Debug" clean
	cd ".."

	cd "compare_hl7"
	$(NMAKE)/f compare_hl7.mak CFG="compare_hl7 - Win32 Debug" clean
	cd ".."

	cd "cstore"
	$(NMAKE)/f cstore.mak CFG="cstore - Win32 Debug" clean
	cd ".."

	cd "ctn_version"
	$(NMAKE)/f ctn_version.mak CFG="ctn_version - Win32 Debug" clean
	cd ".."

	cd "dcm_create_object"
	$(NMAKE)/f dcm_create_object.mak CFG="dcm_create_object - Win32 Debug" clean
	cd ".."

	cd "dcm_ctnto10"
	$(NMAKE)/f dcm_ctnto10.mak CFG="dcm_ctnto10 - Win32 Debug" clean
	cd ".."

	cd "dcm_diff"
	$(NMAKE)/f dcm_diff.mak CFG="dcm_diff - Win32 Debug" clean
	cd ".."

	cd "dcm_dump_compressed"
	$(NMAKE)/f dcm_dump_compressed.mak CFG="dcm_dump_compressed - Win32 Debug" clean
	cd ".."

	cd "dcm_dump_element"
	$(NMAKE)/f dcm_dump_element.mak CFG="dcm_dump_element - Win32 Debug" clean
	cd ".."

	cd "dcm_dump_file"
	$(NMAKE)/f dcm_dump_file.mak CFG="dcm_dump_file - Win32 Debug" clean
	cd ".."

	cd "dcm_get_elements"
	$(NMAKE)/f dcm_get_elements.mak CFG="dcm_get_elements - Win32 Debug" clean
	cd ".."

	cd "dcm_iterator"
	$(NMAKE)/f dcm_iterator.mak CFG="dcm_iterator - Win32 Debug" clean
	cd ".."
	cd "dcm_make_object"
	$(NMAKE)/f dcm_make_object.mak CFG="dcm_make_object - Win32 Debug" clean
	cd ".."

	cd "dcm_map_to_8"
	$(NMAKE)/f dcm_map_to_8.mak CFG="dcm_map_to_8 - Win32 Debug" clean
	cd ".."

	cd "dcm_modify_elements"
	$(NMAKE)/f dcm_modify_elements.mak CFG="dcm_modify_elements - Win32 Debug" clean
	cd ".."

	cd "dcm_modify_object"
	$(NMAKE)/f dcm_modify_object.mak CFG="dcm_modify_object - Win32 Debug" clean
	cd ".."

	cd "dcm_print_dictionary"
	$(NMAKE)/f dcm_print_dictionary.mak CFG="dcm_print_dictionary - Win32 Debug" clean
	cd ".."

	cd "dcm_print_element"
	$(NMAKE)/f dcm_print_element.mak CFG="dcm_print_element - Win32 Debug" clean
	cd ".."

	cd "dcm_ref_sop_seq"
	$(NMAKE)/f dcm_ref_sop_seq.mak CFG="dcm_ref_sop_seq - Win32 Debug" clean
	cd ".."

	cd "dcm_replace_element"
	$(NMAKE)/f dcm_replace_element.mak CFG="dcm_replace_element - Win32 Debug" clean
	cd ".."

	cd "dcm_resize"
	$(NMAKE)/f dcm_resize.mak CFG="dcm_resize - Win32 Debug" clean
	cd ".."

	cd "dcm_rm_element"
	$(NMAKE)/f dcm_rm_element.mak CFG="dcm_rm_element - Win32 Debug" clean
	cd ".."

	cd "dcm_rm_group"
	$(NMAKE)/f dcm_rm_group.mak CFG="dcm_rm_group - Win32 Debug" clean
	cd ".."

	cd "dcm_strip_odd_groups"
	$(NMAKE)/f dcm_strip_odd_groups.mak CFG="dcm_strip_odd_groups - Win32 Debug" clean
	cd ".."

	cd "dcm_to_html"
	$(NMAKE)/f dcm_to_html.mak CFG="dcm_to_html - Win32 Debug" clean
	cd ".."

	cd "dcm_to_text"
	$(NMAKE)/f dcm_to_text.mak CFG="dcm_to_text - Win32 Debug" clean
	cd ".."

	cd "dcm_to_xml"
	$(NMAKE)/f dcm_to_xml.mak CFG="dcm_to_xml - Win32 Debug" clean
	cd ".."

	cd "dcm_vr_patterns"
	$(NMAKE)/f dcm_vr_patterns.mak CFG="dcm_vr_patterns - Win32 Debug" clean
	cd ".."

	cd "dcm_w_disp"
	$(NMAKE)/f dcm_w_disp.mak CFG="dcm_w_disp - Win32 Debug" clean
	cd ".."

	cd "dicom_echo"
	$(NMAKE)/f dicom_echo.mak CFG="dicom_echo - Win32 Debug" clean
	cd ".."

	cd "ds_dcm"
	$(NMAKE)/f ds_dcm.mak CFG="ds_dcm - Win32 Debug" clean
	cd ".."

	cd "dump_commit_requests"
	$(NMAKE)/f dump_commit_requests.mak CFG="dump_commit_requests - Win32 Debug" clean
	cd ".."

	cd "hl7_get_value"
	$(NMAKE)/f hl7_get_value.mak CFG="hl7_get_value - Win32 Debug" clean
	cd ".."

	cd "hl7_evaluate"
	$(NMAKE)/f hl7_evaluate.mak CFG="hl7_evaluate - Win32 Debug" clean
	cd ".."

	cd "hl7_rcvr"
	$(NMAKE)/f hl7_rcvr.mak CFG="hl7_rcvr - Win32 Debug" clean
	cd ".."

	cd "evaluate_gppps"
	$(NMAKE)/f evaluate_gppps.mak CFG="evaluate_gppps - Win32 Debug" clean
	cd ".."

	cd "hl7_set_value"
	$(NMAKE)/f hl7_set_value.mak CFG="hl7_set_value - Win32 Debug" clean
	cd ".."

	cd "ihe_audit_message"
	$(NMAKE)/f ihe_audit_message.mak CFG="ihe_audit_message - Win32 Debug" clean
	cd ".."

#	cd "im_hl7ps"
#	$(NMAKE)/f im_hl7ps.mak CFG="im_hl7ps - Win32 Debug" clean
#	cd ".."

	cd "kill_hl7"
	$(NMAKE)/f kill_hl7.mak CFG="kill_hl7 - Win32 Debug" clean
	cd ".."

	cd "load_control"
	$(NMAKE)/f load_control.mak CFG="load_control - Win32 Debug" clean
	cd ".."

	cd "mesa_audit_eval"
	$(NMAKE)/f mesa_audit_eval.mak CFG="mesa_audit_eval - Win32 Debug" clean
	cd ".."

	cd "mesa_composite_eval"
	$(NMAKE)/f mesa_composite_eval.mak CFG="mesa_composite_eval - Win32 Debug" clean
	cd ".."

	cd "mesa_db_test"
	$(NMAKE)/f mesa_db_test.mak CFG="mesa_db_test - Win32 Debug" clean
	cd ".."

	cd "mesa_dump_dicomdir"
	$(NMAKE)/f mesa_dump_dicomdir.mak CFG="mesa_dump_dicomdir - Win32 Debug" clean
	cd ".."

	cd "mesa_dump_obj"
	$(NMAKE)/f mesa_dump_obj.mak CFG="mesa_dump_obj - Win32 Debug" clean
	cd ".."

	cd "mesa_extract_nm_frames"
	$(NMAKE)/f mesa_extract_nm_frames.mak CFG="mesa_extract_nm_frames - Win32 Debug" clean
	cd ".."

	cd "mesa_identifier"
	$(NMAKE)/f mesa_identifier.mak CFG="mesa_identifier - Win32 Debug" clean
	cd ".."

	cd "mesa_mwl_add_sps"
	$(NMAKE)/f mesa_mwl_add_sps.mak CFG="mesa_mwl_add_sps - Win32 Debug" clean
	cd ".."

	cd "mesa_mwl_sps_from_mpps"
	$(NMAKE)/f mesa_mwl_sps_from_mpps.mak CFG="mesa_mwl_sps_from_mpps - Win32 Debug" clean
	cd ".."

	cd "mesa_select_column"
	$(NMAKE)/f mesa_select_column.mak CFG="mesa_select_column - Win32 Debug" clean
	cd ".."

	cd "mesa_pdi_eval"
	$(NMAKE)/f mesa_pdi_eval.mak CFG="mesa_pdi_eval - Win32 Debug" clean
	cd ".."

	cd "mesa_sr_eval"
	$(NMAKE)/f mesa_sr_eval.mak CFG="mesa_sr_eval - Win32 Debug" clean
	cd ".."

	cd "mesa_strip_file"
	$(NMAKE)/f mesa_strip_file.mak CFG="mesa_strip_file - Win32 Debug" clean
	cd ".."
	cd "mesa_update_column"
	$(NMAKE)/f mesa_update_column.mak CFG="mesa_update_column - Win32 Debug" clean
	cd ".."

	cd "mesa_xml_eval"
	$(NMAKE)/f mesa_xml_eval.mak CFG="mesa_xml_eval - Win32 Debug" clean
	cd ".."

	cd "mesa_storage"
	$(NMAKE)/f mesa_storage.mak CFG="mesa_storage - Win32 Debug" clean
	cd ".."

	cd "mod_dcmps"
	$(NMAKE)/f mod_dcmps.mak CFG="mod_dcmps - Win32 Debug" clean
	cd ".."

	cd "mod_generatestudy"
	$(NMAKE)/f mod_generatestudy.mak CFG="mod_generatestudy - Win32 Debug" clean
	cd ".."

	cd "mpps_evaluate"
	$(NMAKE)/f mpps_evaluate.mak CFG="mpps_evaluate - Win32 Debug" clean
	cd ".."

	cd "mwlquery"
	$(NMAKE)/f mwlquery.mak CFG="mwlquery - Win32 Debug" clean
	cd ".."

	cd "naction"
	$(NMAKE)/f naction.mak CFG="naction - Win32 Debug" clean
	cd ".."

	cd "ncreate"
	$(NMAKE)/f ncreate.mak CFG="ncreate - Win32 Debug" clean
	cd ".."

	cd "nevent"
	$(NMAKE)/f nevent.mak CFG="nevent - Win32 Debug" clean
	cd ".."

	cd "new_uids"
	$(NMAKE)/f new_uids.mak CFG="new_uids - Win32 Debug" clean
	cd ".."

	cd "nset"
	$(NMAKE)/f nset.mak CFG="nset - Win32 Debug" clean
	cd ".."

	cd "pp_dcmps"
	$(NMAKE)/f pp_dcmps.mak CFG="pp_dcmps - Win32 Debug" clean
	cd ".."

	cd "ppm_sched_gppps"
	$(NMAKE)/f ppm_sched_gppps.mak CFG="ppm_sched_gppps - Win32 Debug" clean
	cd ".."

	cd "ppm_sched_gpsps"
	$(NMAKE)/f ppm_sched_gpsps.mak CFG="ppm_sched_gpsps - Win32 Debug" clean
	cd ".."

	cd "of_dcmps"
	$(NMAKE)/f of_dcmps.mak CFG="of_dcmps - Win32 Debug" clean
	cd ".."

#	cd "of_hl7ps"
#	$(NMAKE)/f of_hl7ps.mak CFG="of_hl7ps - Win32 Debug" clean
#	cd ".."

	cd "of_identifier"
	$(NMAKE)/f of_identifier.mak CFG="of_identifier - Win32 Debug" clean
	cd ".."

	cd "of_mwl_cancel"
	$(NMAKE)/f of_mwl_cancel.mak CFG="of_mwl_cancel - Win32 Debug" clean
	cd ".."

	cd "of_schedule"
	$(NMAKE)/f of_schedule.mak CFG="of_schedule - Win32 Debug" clean
	cd ".."

#	cd "op_hl7ps"
#	$(NMAKE)/f op_hl7ps.mak CFG="op_hl7ps - Win32 Debug" clean
#	cd ".."

	cd "open_assoc"
	$(NMAKE)/f open_assoc.mak CFG="open_assoc - Win32 Debug" clean
	cd ".."

	cd "sc_scp_association"
	$(NMAKE)/f sc_scp_association.mak CFG="sc_scp_association - Win32 Debug" clean
	cd ".."

	cd "sc_scu_association"
	$(NMAKE)/f sc_scu_association.mak CFG="sc_scu_association - Win32 Debug" clean
	cd ".."

	cd "send_hl7"
	$(NMAKE)/f send_hl7.mak CFG="send_hl7 - Win32 Debug" clean
	cd ".."

	cd "send_image"
	$(NMAKE)/f send_image.mak CFG="send_image - Win32 Debug" clean
	cd ".."

	cd "simple_storage"
	$(NMAKE)/f simple_storage.mak CFG="simple_storage - Win32 Debug" clean
	cd ".."

	cd "sr_to_hl7"
	$(NMAKE)/f sr_to_hl7.mak CFG="sr_to_hl7 - Win32 Debug" clean
	cd ".."

	cd "syslog_client"
	$(NMAKE)/f syslog_client.mak CFG="syslog_client - Win32 Debug" clean
	cd ".."

	cd "syslog_extract"
	$(NMAKE)/f syslog_extract.mak CFG="syslog_extract - Win32 Debug" clean
	cd ".."

	cd "syslog_server"
	$(NMAKE)/f syslog_server.mak CFG="syslog_server - Win32 Debug" clean
	cd ".."

	cd "tcp_connect"
	$(NMAKE)/f tcp_connect.mak CFG="tcp_connect - Win32 Debug" clean
	cd ".."

	cd "ttdelete"
	$(NMAKE)/f ttdelete.mak CFG="ttdelete - Win32 Debug" clean
	cd ".."

	cd "ttinsert"
	$(NMAKE)/f ttinsert.mak CFG="ttinsert - Win32 Debug" clean
	cd ".."

	cd "ttlayout"
	$(NMAKE)/f ttlayout.mak CFG="ttlayout - Win32 Debug" clean
	cd ".."

	cd "ttselect"
	$(NMAKE)/f ttselect.mak CFG="ttselect - Win32 Debug" clean
	cd ".."

	cd "ttunique"
	$(NMAKE)/f ttunique.mak CFG="ttunique - Win32 Debug" clean
	cd ".."

	cd "ttupdate"
	$(NMAKE)/f ttupdate.mak CFG="ttupdate - Win32 Debug" clean
	cd ".."

	cd "txt_to_hl7"
	$(NMAKE)/f txt_to_hl7.mak CFG="txt_to_hl7 - Win32 Debug" clean
	cd ".."




real_clean:
	cd "archive_agent"
	del/s/q Release Debug
	cd ".."

	cd "archive_cleaner"
	del/s/q Release Debug
	cd ".."

	cd "archive_server"
	del/s/q Release Debug
	cd ".."

	cd "cfind"
	del/s/q Release Debug
	cd ".."

	cd "cfind_evaluate"
	del/s/q Release Debug
	cd ".."

	cd "cfind_gpsps_evaluate"
	del/s/q Release Debug
	cd ".."

	cd "cfind_image_avail"
	del/s/q Release Debug
	cd ".."

	cd "cfind_mwl_evaluate"
	del/s/q Release Debug
	cd ".."

	cd "cfind_resp_evaluate"
	del/s/q Release Debug
	cd ".."

	cd "cfind_study_probe"
	del/s/q Release Debug
	cd ".."

	cd "cmove"
	del/s/q Release Debug
	cd ".."

	cd "cmove_study"
	del/s/q Release Debug
	cd ".."

	cd "compare_dcm"
	del/s/q Release Debug
	cd ".."

	cd "compare_hl7"
	del/s/q Release Debug
	cd ".."

	cd "cstore"
	del/s/q Release Debug
	cd ".."

	cd "ctn_version"
	del/s/q Release Debug
	cd ".."

	cd "dcm_create_object"
	del/s/q Release Debug
	cd ".."

	cd "dcm_ctnto10"
	del/s/q Release Debug
	cd ".."

	cd "dcm_diff"
	del/s/q Release Debug
	cd ".."

	cd "dcm_dump_compressed"
	del/s/q Release Debug
	cd ".."

	cd "dcm_dump_element"
	del/s/q Release Debug
	cd ".."

	cd "dcm_dump_file"
	del/s/q Release Debug
	cd ".."

	cd "dcm_get_elements"
	$(NMAKE)/f dcm_get_elements.mak CFG="dcm_get_elements - Win32 Release" clean
	cd ".."

	cd "dcm_iterator"
	$(NMAKE)/f dcm_iterator.mak CFG="dcm_iterator - Win32 Release" clean
	cd ".."

	cd "dcm_make_object"
	$(NMAKE)/f dcm_make_object.mak CFG="dcm_make_object - Win32 Release" clean
	cd ".."

	cd "dcm_map_to_8"
	$(NMAKE)/f dcm_map_to_8.mak CFG="dcm_map_to_8 - Win32 Release" clean
	cd ".."

	cd "dcm_mask_image"
	$(NMAKE)/f dcm_mask_image.mak CFG="dcm_mask_image - Win32 Release" clean
	cd ".."

	cd "dcm_modify_elements"
	$(NMAKE)/f dcm_modify_elements.mak CFG="dcm_modify_elements - Win32 Release" clean
	cd ".."

	cd "dcm_modify_object"
	$(NMAKE)/f dcm_modify_object.mak CFG="dcm_modify_object - Win32 Release" clean
	cd ".."

	cd "dcm_print_dictionary"
	$(NMAKE)/f dcm_print_dictionary.mak CFG="dcm_print_dictionary - Win32 Release" clean
	cd ".."

	cd "dcm_print_element"
	$(NMAKE)/f dcm_print_element.mak CFG="dcm_print_element - Win32 Release" clean
	cd ".."

	cd "dcm_ref_sop_seq"
	$(NMAKE)/f dcm_ref_sop_seq.mak CFG="dcm_ref_sop_seq - Win32 Release" clean
	cd ".."

	cd "dcm_replace_element"
	$(NMAKE)/f dcm_replace_element.mak CFG="dcm_replace_element - Win32 Release" clean
	cd ".."

	cd "dcm_resize"
	$(NMAKE)/f dcm_resize.mak CFG="dcm_resize - Win32 Release" clean
	cd ".."

	cd "dcm_rm_element"
	$(NMAKE)/f dcm_rm_element.mak CFG="dcm_rm_element - Win32 Release" clean
	cd ".."

	cd "dcm_rm_group"
	$(NMAKE)/f dcm_rm_group.mak CFG="dcm_rm_group - Win32 Release" clean
	cd ".."

	cd "dcm_strip_odd_groups"
	$(NMAKE)/f dcm_strip_odd_groups.mak CFG="dcm_strip_odd_groups - Win32 Release" clean

	cd ".."
	cd "dcm_to_html"
	$(NMAKE)/f dcm_to_html.mak CFG="dcm_to_html - Win32 Release" clean
	cd ".."

	cd "dcm_to_text"
	$(NMAKE)/f dcm_to_text.mak CFG="dcm_to_text - Win32 Release" clean
	cd ".."

	cd "dcm_to_xml"
	$(NMAKE)/f dcm_to_xml.mak CFG="dcm_to_xml - Win32 Release" clean
	cd ".."

	cd "dcm_vr_patterns"
	$(NMAKE)/f dcm_vr_patterns.mak CFG="dcm_vr_patterns - Win32 Release" clean
	cd ".."

	cd "dcm_w_disp"
	$(NMAKE)/f dcm_w_disp.mak CFG="dcm_w_disp - Win32 Release" clean
	cd ".."

	cd "dicom_echo"
	$(NMAKE)/f dicom_echo.mak CFG="dicom_echo - Win32 Release" clean
	cd ".."

	cd "ds_dcm"
	$(NMAKE)/f ds_dcm.mak CFG="ds_dcm - Win32 Release" clean
	cd ".."

	cd "dump_commit_requests"
	$(NMAKE)/f dump_commit_requests.mak CFG="dump_commit_requests - Win32 Release" clean
	cd ".."

	cd "hl7_get_value"
	$(NMAKE)/f hl7_get_value.mak CFG="hl7_get_value - Win32 Release" clean
	cd ".."

	cd "hl7_evaluate"
	$(NMAKE)/f hl7_evaluate.mak CFG="hl7_evaluate - Win32 Release" clean
	cd ".."

	cd "hl7_rcvr"
	$(NMAKE)/f hl7_rcvr.mak CFG="hl7_rcvr - Win32 Release" clean
	cd ".."

	cd "evaluate_gppps"
	$(NMAKE)/f evaluate_gppps.mak CFG="evaluate_gppps - Win32 Release" clean
	cd ".."

	cd "evaluate_storage_commitment"
	$(NMAKE)/f evaluate_storage_commitment.mak CFG="evaluate_storage_commitment - Win32 Release" clean
	cd ".."

	cd "hl7_set_value"
	$(NMAKE)/f hl7_set_value.mak CFG="hl7_set_value - Win32 Release" clean
	cd ".."

	cd "hl7_to_txt"
	$(NMAKE)/f hl7_to_txt.mak CFG="hl7_to_txt - Win32 Release" clean
	cd ".."

	cd "ihe_audit_message"
	$(NMAKE)/f ihe_audit_message.mak CFG="ihe_audit_message - Win32 Release" clean
	cd ".."

#	cd "im_hl7ps"
#	$(NMAKE)/f im_hl7ps.mak CFG="im_hl7ps - Win32 Release" clean
#	cd ".."

	cd "im_sc_agent"
	$(NMAKE)/f im_sc_agent.mak CFG="im_sc_agent - Win32 Release" clean
	cd ".."

	cd "kill_hl7"
	$(NMAKE)/f kill_hl7.mak CFG="kill_hl7 - Win32 Release" clean
	cd ".."

	cd "load_control"
	$(NMAKE)/f load_control.mak CFG="load_control - Win32 Release" clean
	cd ".."

	cd "mesa_audit_eval"
	$(NMAKE)/f mesa_audit_eval.mak CFG="mesa_audit_eval - Win32 Release" clean
	cd ".."

	cd "mesa_composite_eval"
	$(NMAKE)/f mesa_composite_eval.mak CFG="mesa_composite_eval - Win32 Release" clean
	cd ".."

	cd "mesa_db_test"
	$(NMAKE)/f mesa_db_test.mak CFG="mesa_db_test - Win32 Release" clean
	cd ".."

	cd "mesa_dump_dicomdir"
	$(NMAKE)/f mesa_dump_dicomdir.mak CFG="mesa_dump_dicomdir - Win32 Release" clean
	cd ".."

	cd "mesa_dump_obj"
	$(NMAKE)/f mesa_dump_obj.mak CFG="mesa_dump_obj - Win32 Release" clean
	cd ".."

	cd "mesa_extract_nm_frames"
	$(NMAKE)/f mesa_extract_nm_frames.mak CFG="mesa_extract_nm_frames - Win32 Release" clean
	cd ".."

	cd "mesa_identifier"
	$(NMAKE)/f mesa_identifier.mak CFG="mesa_identifier - Win32 Release" clean
	cd ".."

	cd "mesa_mwl_add_sps"
	$(NMAKE)/f mesa_mwl_add_sps.mak CFG="mesa_mwl_add_sps - Win32 Release" clean
	cd ".."

	cd "mesa_mwl_sps_from_mpps"
	$(NMAKE)/f mesa_mwl_sps_from_mpps.mak CFG="mesa_mwl_sps_from_mpps - Win32 Release" clean
	cd ".."

	cd "mesa_select_column"
	$(NMAKE)/f mesa_select_column.mak CFG="mesa_select_column - Win32 Release" clean
	cd ".."

	cd "mesa_pdi_eval"
	$(NMAKE)/f mesa_pdi_eval.mak CFG="mesa_pdi_eval - Win32 Release" clean
	cd ".."

	cd "mesa_sr_eval"
	$(NMAKE)/f mesa_sr_eval.mak CFG="mesa_sr_eval - Win32 Release" clean
	cd ".."

	cd "mesa_strip_file"
	$(NMAKE)/f mesa_strip_file.mak CFG="mesa_strip_file - Win32 Release" clean
	cd ".."
	cd "mesa_update_column"
	$(NMAKE)/f mesa_update_column.mak CFG="mesa_update_column - Win32 Release" clean
	cd ".."

	cd "mesa_xml_eval"
	$(NMAKE)/f mesa_xml_eval.mak CFG="mesa_xml_eval - Win32 Release" clean
	cd ".."

	cd "mesa_storage"
	$(NMAKE)/f mesa_storage.mak CFG="mesa_storage - Win32 Release" clean
	cd ".."

	cd "mod_dcmps"
	$(NMAKE)/f mod_dcmps.mak CFG="mod_dcmps - Win32 Release" clean
	cd ".."

	cd "mod_generatestudy"
	$(NMAKE)/f mod_generatestudy.mak CFG="mod_generatestudy - Win32 Release" clean
	cd ".."

	cd "mpps_evaluate"
	$(NMAKE)/f mpps_evaluate.mak CFG="mpps_evaluate - Win32 Release" clean
	cd ".."

	cd "mwlquery"
	$(NMAKE)/f mwlquery.mak CFG="mwlquery - Win32 Release" clean
	cd ".."

	cd "naction"
	$(NMAKE)/f naction.mak CFG="naction - Win32 Release" clean
	cd ".."

	cd "ncreate"
	$(NMAKE)/f ncreate.mak CFG="ncreate - Win32 Release" clean
	cd ".."

	cd "nevent"
	$(NMAKE)/f nevent.mak CFG="nevent - Win32 Release" clean
	cd ".."

	cd "new_uids"
	$(NMAKE)/f new_uids.mak CFG="new_uids - Win32 Release" clean
	cd ".."

	cd "nset"
	$(NMAKE)/f nset.mak CFG="nset - Win32 Release" clean
	cd ".."

	cd "pp_dcmps"
	$(NMAKE)/f pp_dcmps.mak CFG="pp_dcmps - Win32 Release" clean
	cd ".."

	cd "ppm_sched_gppps"
	$(NMAKE)/f ppm_sched_gppps.mak CFG="ppm_sched_gppps - Win32 Release" clean
	cd ".."

	cd "ppm_sched_gpsps"
	$(NMAKE)/f ppm_sched_gpsps.mak CFG="ppm_sched_gpsps - Win32 Release" clean
	cd ".."

	cd "of_dcmps"
	$(NMAKE)/f of_dcmps.mak CFG="of_dcmps - Win32 Release" clean
	cd ".."

#	cd "of_hl7ps"
#	$(NMAKE)/f of_hl7ps.mak CFG="of_hl7ps - Win32 Release" clean
#	cd ".."

	cd "of_identifier"
	$(NMAKE)/f of_identifier.mak CFG="of_identifier - Win32 Release" clean
	cd ".."

	cd "of_mwl_cancel"
	$(NMAKE)/f of_mwl_cancel.mak CFG="of_mwl_cancel - Win32 Release" clean
	cd ".."

	cd "of_schedule"
	$(NMAKE)/f of_schedule.mak CFG="of_schedule - Win32 Release" clean
	cd ".."

#	cd "op_hl7ps"
#	$(NMAKE)/f op_hl7ps.mak CFG="op_hl7ps - Win32 Release" clean
#	cd ".."

	cd "open_assoc"
	$(NMAKE)/f open_assoc.mak CFG="open_assoc - Win32 Release" clean
	cd ".."

	cd "sc_scp_association"
	$(NMAKE)/f sc_scp_association.mak CFG="sc_scp_association - Win32 Release" clean
	cd ".."

	cd "sc_scu_association"
	$(NMAKE)/f sc_scu_association.mak CFG="sc_scu_association - Win32 Release" clean
	cd ".."

	cd "send_hl7"
	$(NMAKE)/f send_hl7.mak CFG="send_hl7 - Win32 Release" clean
	cd ".."

	cd "send_image"
	$(NMAKE)/f send_image.mak CFG="send_image - Win32 Release" clean
	cd ".."

	cd "simple_storage"
	$(NMAKE)/f simple_storage.mak CFG="simple_storage - Win32 Release" clean
	cd ".."

	cd "sr_to_hl7"
	$(NMAKE)/f sr_to_hl7.mak CFG="sr_to_hl7 - Win32 Release" clean
	cd ".."

	cd "syslog_client"
	$(NMAKE)/f syslog_client.mak CFG="syslog_client - Win32 Release" clean
	cd ".."

	cd "syslog_extract"
	$(NMAKE)/f syslog_extract.mak CFG="syslog_extract - Win32 Release" clean
	cd ".."

	cd "syslog_server"
	$(NMAKE)/f syslog_server.mak CFG="syslog_server - Win32 Release" clean
	cd ".."

	cd "tcp_connect"
	$(NMAKE)/f tcp_connect.mak CFG="tcp_connect - Win32 Release" clean
	cd ".."

	cd "ttdelete"
	$(NMAKE)/f ttdelete.mak CFG="ttdelete - Win32 Release" clean
	cd ".."

	cd "ttinsert"
	$(NMAKE)/f ttinsert.mak CFG="ttinsert - Win32 Release" clean
	cd ".."

	cd "ttlayout"
	$(NMAKE)/f ttlayout.mak CFG="ttlayout - Win32 Release" clean
	cd ".."

	cd "ttselect"
	$(NMAKE)/f ttselect.mak CFG="ttselect - Win32 Release" clean
	cd ".."

	cd "ttunique"
	$(NMAKE)/f ttunique.mak CFG="ttunique - Win32 Release" clean
	cd ".."

	cd "ttupdate"
	$(NMAKE)/f ttupdate.mak CFG="ttupdate - Win32 Release" clean
	cd ".."

	cd "txt_to_hl7"
	$(NMAKE)/f txt_to_hl7.mak CFG="txt_to_hl7 - Win32 Release" clean
	cd ".."


