0040 0270 (			// Scheduled Step Attribute Sequence
 0020 000D $STUDY_INSTANCE_UID$		// Study Instance UID
 0008 1110 ####			// Referenced Study Sequence

 0040 0008 ####			// Scheduled Action Item Code Sequence

)
0010 0010 $PATIENT_NAME$	// Patient Name
0010 0020 $PATIENT_ID$		// Patient ID
0010 0030 $PATIENT_BIRTH_DATE$		// Birth Date
0010 0040 $PATIENT_SEX$			// Patient Sex
0008 1120 ####			// Referenced Patient Sequence


0040 0253 $PERFORMED_PROCEDURE_STEP_ID$		// Performed Procedure Step ID
0040 0241 $PERFORMED_STATION_AE_TITLE$		// Performed Station AE title
0040 0242 $PERFORMED_STATION_NAME$
0040 0243 $PERFORMED_LOCATION$		// Performed Location
0040 0244 $PERFORMED_PROCEDURE_STEP_START_DATE$	// PPS Start Date
0040 0245 $PERFORMED_PROCEDURE_STEP_START_TIME$	// PPS Start Time
0040 0252 $PERFORMED_PROCEDURE_STEP_STATUS$	// PPS Status
0040 0254 $PERFORMED_PROCEDURE_STEP_DESCRIPTION$	// PPS Description
0040 0255 $PERFORMED_PROCEDURE_TYPE_DESCRIPTION$	// Performed Procedure Type Description

0008 1032 ####			// Procedure code sequence

0040 0250 #			// PPS End Date
0040 0251 #			// PPS End Time

0008 0060 $MODALITY$			// Modality
0020 0010 $STUDY_ID$		// Study ID

0040 0260 ####			// Performed Action Item Code Seq

0040 0340 ####			// Performed Series Sequence

