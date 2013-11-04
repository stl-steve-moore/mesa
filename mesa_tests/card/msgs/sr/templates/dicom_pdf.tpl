//Patient Module
//0010 0010	WASHINGTON^GEORGE		//Patient Name
//0010 0020	401601				//Patient ID
0010 0030	#				//Patient's Birth Date
0010 0040	M				//Patient's Sex
//
//General Study Module
//0020 000D	1.113654.1.2001.10		//Study Instance UID
0008 0020	20050825			//Study Date
0008 0030	101315				//Study Time
0008 0090	MCFARLAND			//Referring Physician's Name
0020 0010	3				//Study ID
0008 0050	2001A10	 			//Accession Number
//
//Encapsulated Document Series
0008 0060	OT				//Modality
0020 000E	1.113654.1.2001.10.2.601	//Series Instance UID
0020 0011	1				//Series Number
//
//General Equipment
0008 0070	MIR			//Manufacturer
//
//SC Equipment
0008 0064	WSD			//Conversion Type
//
//Encapsulated Document
0020 0013	1			//Instance NUmber
0008 0023	20050826		//Content Date //type2
0008 0033	105400			//Content Time //type2
0008 002A	#			//Acquistion Datetime //type2
0028 0301	YES			//Burned In Annotation
0042 0010	"Some Title"		//Document Title
//0040 a043 (						//Concept Name Code Sequence
// 0008 0100	18745-0					//Code Value
// 0008 0102	LN					//Code Scheme Designator
// 0008 0104	"Cardiac Catheterization Report"	//Code Meaning
//)
0042 0012	application/pdf	//MIME Type of Encapsulated Document
//0040 A493	VERIFIED	//Verification Flag
//
//SOP Common Module
0008 0016	1.2.840.10008.5.1.4.1.1.104.1		// SOP Class: Encapsulated PDF
0008 0018	1.113654.1.2001.10.2.1			// SOP Instance UID	
