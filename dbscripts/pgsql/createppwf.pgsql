
/*
-- drop database ppwf

-- create database ppwf

-- use ppwf
*/

-- drop table gpworkitem;

create table gpworkitem (
	/*
	*
	* add patient as part of this table
	* add workitemcode as part of this table.
	*
	*/
	sopinsuid	char(64)	primary key,
	sopclassuid	char(64),	-- use this or custom string to
					-- indicate if this is sched or perf?
	status		char(64),
	inputavailflag	char(64),	-- boolean?
	priority	char(20),	-- int?,
	procstepid	char(16),	-- this is DICOM SH (short string)
	startdattim	char(20),
	enddattim	char(20),
	resultstuinsuid	char(64),	-- see multiple copy flag...
	inputstuinsuid	char(64),
	multcopyflag	char(20),	-- boolean?
	description	char(64),	-- pps only
	-- patient fields
	patientID	char(20),
	patientname	char(64),
	birthdate	char(20),
	sex		char(4),
	-- workitemcode fields
	-- either scheduled or performed based on sopclassuid of this gpworkitem
	workitemcodevalue	char(64),
	workitemcodescheme	char(64),
	workitemcodemeaning	char(64),
        -- from referenced request sequence
	reqProcID		char(64),
	reqProcDesc		char(64),
	reqProcCodeValue	char(64),
	reqProcCodeMeaning	char(64),
	reqProcCodeScheme	char(64),
	reqProcAccessionNum	char(64),
	requestingPhys		char(64),
	transactionUID		char(64)
);


-- drop table stationName;

create table stationName (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)   -- postgres 6.x doesn't have fkeys.
   	   -- foreign key references gpworkitem(sopinsuid)
);

-- drop table stationClass;

create table stationClass (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to workitem
   	   -- foreign key references gpworkitem(sopinsuid)
);

-- drop table stationLocation;

create table stationLocation (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to workitem
   	   -- foreign key references gpworkitem(sopinsuid)
);

-- drop table requestedProcedure;

create table requestedProcedure (

	-- reqProcID is not a primary key because multiple gpworkitems
	-- can refer to the same requested Procedure.
	reqProcID	char(64),
	accessionNum	char(64),
	resultStudyUID	char(64),
	description	char(64),
	codevalue	char(64),
	codescheme	char(64),
	codemeaning	char(64),
	requestingPhys	char(64),
	workitemkey	char(64)   -- postgres 6.x doesn't have fkeys.
   	   -- foreign key references gpworkitem
);

-- drop table gpppsworkitem;

create table gpppsworkitem (

	sopinsuid	char(64)	primary key,
	reqprocAccessionNum	char(64),
	reqprocID		char(64),
	reqprocDesc	char(64),
	reqprocCodevalue	char(64),
	reqprocCodemeaning	char(64),
	reqprocCodescheme	char(64),
	patientid	char(64),
	patientname	char(64),
	birthdate	char(64),
	sex		char(64),
	procstepid	char(64),
	status		char(64),
	startdate	char(64),
	starttime	char(64),
	enddate		char(64),
	endtime		char(64),
	description	char(64)
);

-- drop table acthumanperf;

create table acthumanperf (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table perfstationname;

create table perfstationname (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table perfstationclass;

create table perfstationclass (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table perfstationlocation;

create table perfstationlocation (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table perfprocapp;

create table perfprocapp (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table perfworkitem;

create table perfworkitem (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table reqsubsworkitem;

create table reqsubsworkitem (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table nondcmoutput;

create table nondcmoutput (

	codval		char(64),
	codschdes	char(64),
	codmea		char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table outputinfo;

create table outputinfo (

	studyinsuid	char(64),
	seriesinsuid	char(64),
	retrieveAEtitle	char(64),
	sopclassuid	char(64),
	sopinsuid	char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

-- drop table inputinfo;

create table inputinfo (

	studyinsuid	char(64),
	seriesinsuid	char(64),
	retrieveAEtitle	char(64),
	sopclassuid	char(64),
	sopinsuid	char(64),
	workitemkey	char(64)	-- fkey to gpworkitem (gpspsworkitem)
);

create table refGPSPS (

	sopclassuid	char(64),
	sopinstanceuid	char(64),
	transactionuid	char(64),
	workitemkey	char(64)	-- fkey to gpppsworkitem
);

