include $(MESA_MAKE)

CFLAGS = $(C_OPTS)
CXX_FLAGS = $(C_OPTS)
L_FLAGS = $(L_OPTS)

APPS = ihe_audit_message

app:	$(APPS)

ihe_audit_message:	ihe_audit_message.o
	$(CXX) -o ihe_audit_message ihe_audit_message.o $(L_FLAGS) $(LIBS_MESA)

relink:
	$(CXX) -o ihe_audit_message ihe_audit_message.o $(L_FLAGS) $(LIBS_MESA)

install:	$(APPS)
	$(INSTALL) ihe_audit_message $(MESA_BIN)

clean:
	rm -rf $(APPS) core *.o *.?pp~

STARTUP:	ihe_audit_message
	./ihe_audit_message -t STARTUP startup.txt startup.xml
	mesa_xml_eval startup.xml

CONFIGURATION:	ihe_audit_message
	./ihe_audit_message -t CONFIGURATION configuration.txt configuration.xml
	mesa_xml_eval configuration.xml

USER_AUTH:	ihe_audit_message
	./ihe_audit_message -t USER_AUTHENTICATED user_auth.txt user_auth.xml
	mesa_xml_eval user_auth.xml

PATIENT_MODIFY:	ihe_audit_message
	./ihe_audit_message -t PATIENT_RECORD patient_modify.txt patient_modify.xml
	mesa_xml_eval patient_modify.xml

PROCEDURE_RECORD:	ihe_audit_message
	./ihe_audit_message -t PROCEDURE_RECORD procedure_record.txt procedure_record.xml
	mesa_xml_eval procedure_record.xml

MWL_PROVIDED:	ihe_audit_message
	./ihe_audit_message -t MWL_PROVIDED mwl_provided.txt mwl_provided.xml
	mesa_xml_eval mwl_provided.xml

STORING:	ihe_audit_message
	./ihe_audit_message -t BEGIN_STORING_INSTANCES storing_instances.txt storing_instances.xml
	mesa_xml_eval storing_instances.xml

DICOM_QUERY:	ihe_audit_message
	./ihe_audit_message -t DICOM_QUERY dicom_query.txt dicom_query.xml
	mesa_xml_eval dicom_query.xml

INSTANCES_USED:	ihe_audit_message
	./ihe_audit_message -t INSTANCES_USED instances_used.txt instances_used.xml
	mesa_xml_eval instances_used.xml

INSTANCES_SENT:	ihe_audit_message
	./ihe_audit_message -t INSTANCES_SENT instances_sent.txt instances_sent.xml
	mesa_xml_eval instances_sent.xml

INSTANCES_STORED:	ihe_audit_message
	./ihe_audit_message -t INSTANCES_STORED instances_stored.txt instances_stored.xml
	mesa_xml_eval instances_stored.xml

all:	STARTUP CONFIGURATION USER_AUTH PATIENT_MODIFY PROCEDURE_RECORD STORING DICOM_QUERY INSTANCES_USED INSTANCES_SENT INSTANCES_STORED


x:
	mesa_xml_eval x.xml
