//
//        Copyright (C) 1999, 2000, HIMSS, RSNA and Washington University
//
//        The MESA test tools software and supporting documentation were
//        developed for the Integrating the Healthcare Enterprise (IHE)
//        initiative Year 1 (1999-2000), under the sponsorship of the
//        Healthcare Information and Management Systems Society (HIMSS)
//        and the Radiological Society of North America (RSNA) by:
//                Electronic Radiology Laboratory
//                Mallinckrodt Institute of Radiology
//                Washington University School of Medicine
//                510 S. Kingshighway Blvd.
//                St. Louis, MO 63110
//        
//        THIS SOFTWARE IS MADE AVAILABLE, AS IS, AND NEITHER HIMSS, RSNA NOR
//        WASHINGTON UNIVERSITY MAKE ANY WARRANTY ABOUT THE SOFTWARE, ITS
//        PERFORMANCE, ITS MERCHANTABILITY OR FITNESS FOR ANY PARTICULAR
//        USE, FREEDOM FROM ANY DEFECTS OR COMPUTER DISEASES OR ITS CONFORMITY 
//        TO ANY SPECIFICATION. THE ENTIRE RISK AS TO QUALITY AND PERFORMANCE OF
//        THE SOFTWARE IS WITH THE USER.
//
//        Copyright of the software and supporting documentation is
//        jointly owned by HIMSS, RSNA and Washington University, and free
//        access is hereby granted as a license to use this software, copy
//        this software and prepare derivative works based upon this software.
//        However, any distribution of this software source code or supporting
//        documentation or derivative works (source code and supporting
//        documentation) must include the three paragraphs of this copyright
//        notice.

#include "MESA.hpp"
#include "MDBInterface.hpp"
#include "MDomainObject.hpp"
#include "ctn_api.h"
#include "MLogClient.hpp"

MDBInterface::MDBInterface() :
       mDomainObjPtr(NULL),
       mCallback(NULL),
       mDBName("")
{
}

MDBInterface::MDBInterface(const MDBInterface& cpy) :
  mDomainObjPtr(cpy.mDomainObjPtr),
  mCallback(cpy.mCallback),
  mDBName(cpy.mDBName)
{
}

MDBInterface::~MDBInterface()
{
}

void
MDBInterface::printOn(ostream& s) const
{
  s << "Interface";
}

void
MDBInterface::streamIn(istream& s)
{
  //s >> this->member;
}

// Non-boilerplate methods follow

MDBInterface::MDBInterface(const MString& databaseName) :
       mDomainObjPtr(NULL),
       mCallback(NULL),
       mDBName(databaseName)
{
  this->open(databaseName);
  //cout << "Opening the database: " << databaseName << endl;
}

int
MDBInterface::initialize(const MString& databaseName)
{
  mDBName = databaseName;
  int status = this->open(mDBName);
  return status;
}

MDomainObject* MDBInterface::domainObjPtr()
{
  return mDomainObjPtr;
}

MDBINTERFACE_CALLBACK_FUNCTION* MDBInterface::callback()
{
  return mCallback;
}

void*
MDBInterface::callbackContext()
{
  return mCallbackContext;
}

void MDBInterface::domainObjPtr( MDomainObject* domainObjPtr )
{
  mDomainObjPtr = domainObjPtr;
}

void MDBInterface::callback( MDBINTERFACE_CALLBACK_FUNCTION* callback )
{
  mCallback = callback;
}

int
MDBInterface::insert(const MDomainObject& domainObject )
{
  // first check the integrity of the parameters
  if ( domainObject.mapEmpty() )
    return 0 ;

  TBL_FIELD *f = new TBL_FIELD[domainObject.mapSize()+1];
  const MDomainMap& m = domainObject.map();

  int i = 0;
  for (MDomainMap::const_iterator j = m.begin(); j != m.end(); j++) 
  {
     MString fld((*j).first), value((*j).second);

	     
	//   f[i].FieldName = ((*j).first).strData();
	     f[i].FieldName = fld.strData();
	     f[i].Value.Type = TBL_STRING;
	     f[i].Value.AllocatedSize = ((*j).second).length()+1;
	     f[i].Value.Size = ((*j).second).length()+1;
	     f[i].Value.IsNull = 0;
	//   f[i].Value.Value.String = ((*j).second).strData();
	     f[i].Value.Value.String = value.strData();
	     i++;

	     
  } // endfor
 
  f[i].FieldName = 0;
  f[i].Value.Type = TBL_STRING;
  f[i].Value.AllocatedSize = 0;
  f[i].Value.Size = 0;
  f[i].Value.IsNull = 0;
  f[i].Value.Value.String = 0;

//this->insertRow(f);
  int status = this->insertRow(f, domainObject.tableName());

  // clean up
  for (int j1 = 0; j1< i; j1++)
  {
    delete [] f[j1].FieldName;
    delete [] f[j1].Value.Value.String;
  } //endfor

  delete [] f;

  return status;
}

int
MDBInterface::update(const MDomainObject& domainObject,
                     const MCriteriaVector& updateCriteria,
                     const MUpdateVector& updateFields )
{
  // first check the integrity of the parameters
  if ( updateFields.empty() )
    return 0;

  // set up the criteria for selection
  TBL_CRITERIA *c = new TBL_CRITERIA[updateCriteria.size()+1];

  int i = 0;

  for (MCriteriaVector::const_iterator j = updateCriteria.begin();
       j != updateCriteria.end(); j++) 
  {
     c[i].FieldName = ((*j).attribute).strData();
     c[i].Operator = (*j).oper;
     c[i].Value.Type = TBL_STRING;
     c[i].Value.AllocatedSize = ((*j).value).length()+1;
     c[i].Value.Size = ((*j).value).length()+1;
     c[i].Value.IsNull = 0;
     c[i].Value.Value.String = ((*j).value).strData();
     i++;
  }
 
  c[i].FieldName = 0;
  c[i].Operator = TBL_NOP;
  c[i].Value.Type = TBL_STRING;
  c[i].Value.AllocatedSize = 0;
  c[i].Value.Size = 0;
  c[i].Value.IsNull = 0;
  c[i].Value.Value.String = 0;

  // now set up fields to update
  TBL_UPDATE *u = new TBL_UPDATE[updateFields.size()+1];

  int k = 0;

  for (MUpdateVector::const_iterator ji = updateFields.begin();
       ji != updateFields.end(); ji++) 
  {
     u[k].FieldName = ((*ji).attribute).strData();
     u[k].Function = (*ji).func;
     u[k].Value.Type = TBL_STRING;
     u[k].Value.AllocatedSize = ((*ji).value).length()+1;
     u[k].Value.Size = ((*ji).value).length()+1;
     u[k].Value.IsNull = 0;
     u[k].Value.Value.String = ((*ji).value).strData();
     k++;
  }
 
  u[k].FieldName = 0;
  u[k].Function = TBL_ZERO;
  u[k].Value.Type = TBL_STRING;
  u[k].Value.AllocatedSize = 0;
  u[k].Value.Size = 0;
  u[k].Value.IsNull = 0;
  u[k].Value.Value.String = 0;

  int status = this->updateRow(c, u, domainObject.tableName());

  // clean up the criteria list
  for (int j1 = 0; j1< i; j1++)
  {
    delete [] c[j1].FieldName;
    delete [] c[j1].Value.Value.String;
  } // endfor

  delete [] c;

  // now clean up the update list
  for (int j2 = 0; j2< k; j2++)
  {
    delete [] u[j2].FieldName;
    delete [] u[j2].Value.Value.String;
  } // endfor

  delete [] u;
  return status;
}

long MDBInterface::select(MDomainObject& domainObject,
                       const MCriteriaVector& selectCriteria,
		       MDBINTERFACE_CALLBACK_FUNCTION* callback )
{
  MLogClient logClient;
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		  "MDBInterface::select enter method");

  // first check the integrity of the parameters
  if ( !domainObject.numAttributes() )
    return 0;

  TBL_CRITERIA *c = new TBL_CRITERIA[selectCriteria.size()+1];

  int i = 0;

  for (MCriteriaVector::const_iterator j = selectCriteria.begin();
       j != selectCriteria.end(); j++) 
  {
     c[i].FieldName = ((*j).attribute).strData();
     c[i].Operator = (*j).oper;
     c[i].Value.Type = TBL_STRING;
     c[i].Value.AllocatedSize = ((*j).value).length()+1;
     c[i].Value.Size = ((*j).value).length()+1;
     c[i].Value.IsNull = 0;
     c[i].Value.Value.String = ((*j).value).strData();
     i++;
  }
 
  c[i].FieldName = 0;
  c[i].Operator = TBL_NOP;
  c[i].Value.Type = TBL_STRING;
  c[i].Value.AllocatedSize = 0;
  c[i].Value.Size = 0;
  c[i].Value.IsNull = 0;
  c[i].Value.Value.String = 0;

  TBL_FIELD *f = new TBL_FIELD[domainObject.numAttributes()+1];
  MDBAttributes& attrib = domainObject.dbAttributes();

  int k = 0;

  for (MDBAttributes::iterator ji = attrib.begin(); ji != attrib.end(); ji++) {
    MString fld(*ji);
    MString attrType = domainObject.attributeType(fld);
    if (attrType == "string") {
      f[k].FieldName = fld.strData();
      f[k].Value.Type = TBL_STRING;
      f[k].Value.AllocatedSize = 1000;
      f[k].Value.Size = 1000;
      f[k].Value.IsNull = 1;
      f[k].Value.Value.String = new char[1000];
    } else if (attrType == "integer") {
      f[k].FieldName = fld.strData();
      f[k].Value.Type = TBL_SIGNED4;
      f[k].Value.AllocatedSize = 4;
      f[k].Value.Size = 4;
      f[k].Value.IsNull = 1;
      f[k].Value.Value.Signed4 = new int[2];
    } else {
      cout << "MDBInterface not ready for attribute of type: " << attrType << endl;
      ::exit(1);
    }
    k++;
  }
 
  f[k].FieldName = 0;
  f[k].Value.Type = TBL_STRING;
  f[k].Value.AllocatedSize = 0;
  f[k].Value.Size = 0;
  f[k].Value.IsNull = 0;
  f[k].Value.Value.String = 0;

  mDomainObjPtr = &domainObject;
  mCallback = callback;
  mCallbackContext = 0;
  long numRows;
  int status;
  status = this->selectRow(c, f, processRow, this, domainObject.tableName(), &numRows);

  // cleanup criteria matrix
  for (int j1 = 0; j1< i; j1++)
  {
    delete [] c[j1].FieldName;
    delete [] c[j1].Value.Value.String;
  } // endfor

  // now cleanup the field matrix
  for (int j2 = 0; j2< k; j2++)
  {
    delete [] f[j2].FieldName;
    delete [] f[j2].Value.Value.String;
  } // endfor

  delete [] c;
  delete [] f;

  if (status != 0) {
    logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		    "MDBInterface::select exit method, error status");
    return -1;
  }
  logClient.logTimeStamp(MLogClient::MLOG_VERBOSE,
		  "MDBInterface::select exit method");
  return numRows;
}

long
MDBInterface::select(MDomainObject& domainObject,
                     const MCriteriaVector& selectCriteria,
		     MDBINTERFACE_CALLBACK_FUNCTION* callback,
		     void* callbackCtx)
{
  // first check the integrity of the parameters
  if ( !domainObject.numAttributes() )
    return 0;

  TBL_CRITERIA *c = new TBL_CRITERIA[selectCriteria.size()+1];

  int i = 0;

  for (MCriteriaVector::const_iterator j = selectCriteria.begin();
       j != selectCriteria.end(); j++) 
  {
     c[i].FieldName = ((*j).attribute).strData();
     c[i].Operator = (*j).oper;
     c[i].Value.Type = TBL_STRING;
     c[i].Value.AllocatedSize = ((*j).value).length()+1;
     c[i].Value.Size = ((*j).value).length()+1;
     c[i].Value.IsNull = 0;
     c[i].Value.Value.String = ((*j).value).strData();
     i++;
  }
 
  c[i].FieldName = 0;
  c[i].Operator = TBL_NOP;
  c[i].Value.Type = TBL_STRING;
  c[i].Value.AllocatedSize = 0;
  c[i].Value.Size = 0;
  c[i].Value.IsNull = 0;
  c[i].Value.Value.String = 0;

  TBL_FIELD *f = new TBL_FIELD[domainObject.numAttributes()+1];
  MDBAttributes& attrib = domainObject.dbAttributes();

  int k = 0;

  for (MDBAttributes::iterator ji = attrib.begin(); ji != attrib.end(); ji++) 
  {
     MString fld(*ji);
//   f[k].FieldName = (*ji).strData();
     f[k].FieldName = fld.strData();
     f[k].Value.Type = TBL_STRING;
     f[k].Value.AllocatedSize = 1000;
     f[k].Value.Size = 1000;
     f[k].Value.IsNull = 1;
     f[k].Value.Value.String = new char[1000];
     f[k].Value.Value.String[0] = '\0';
     k++;
  }
 
  f[k].FieldName = 0;
  f[k].Value.Type = TBL_STRING;
  f[k].Value.AllocatedSize = 0;
  f[k].Value.Size = 0;
  f[k].Value.IsNull = 0;
  f[k].Value.Value.String = 0;

  mDomainObjPtr = &domainObject;
  mCallback = callback;
  mCallbackContext = callbackCtx;
  long numRows;
  this->selectRow(c, f, processRow, this, domainObject.tableName(), &numRows);

  // cleanup criteria matrix
  for (int j1 = 0; j1< i; j1++)
  {
    delete [] c[j1].FieldName;
    delete [] c[j1].Value.Value.String;
  } // endfor

  // now cleanup the field matrix
  for (int j2 = 0; j2< k; j2++)
  {
    delete [] f[j2].FieldName;
    delete [] f[j2].Value.Value.String;
  } // endfor

  delete [] c;
  delete [] f;

  return numRows;
}

long
MDBInterface::selectAll(MDomainObject& domainObject,
		     MDBINTERFACE_CALLBACK_FUNCTION* callback,
		     void* callbackCtx)
{
  // first check the integrity of the parameters
  if ( !domainObject.numAttributes() )
    return 0;

  TBL_FIELD *f = new TBL_FIELD[domainObject.numAttributes()+1];
  MDBAttributes& attrib = domainObject.dbAttributes();

  int k = 0;

  for (MDBAttributes::iterator j = attrib.begin(); j != attrib.end(); j++) 
  {
     MString fld(*j);
//   f[k].FieldName = (*j).strData();
     f[k].FieldName = fld.strData();
     f[k].Value.Type = TBL_STRING;
     f[k].Value.AllocatedSize = 1000;
     f[k].Value.Size = 1000;
     f[k].Value.IsNull = 1;
     f[k].Value.Value.String = new char[1000];
     k++;
  }
 
  f[k].FieldName = 0;
  f[k].Value.Type = TBL_STRING;
  f[k].Value.AllocatedSize = 0;
  f[k].Value.Size = 0;
  f[k].Value.IsNull = 0;
  f[k].Value.Value.String = 0;

  mDomainObjPtr = &domainObject;
  mCallback = callback;
  mCallbackContext = callbackCtx;
  long numRows;
  this->selectRow(NULL, f, processRow, this, domainObject.tableName(), &numRows);

  // now cleanup the field matrix
  for (int j3 = 0; j3< k; j3++)
  {
    delete [] f[j3].FieldName;
    delete [] f[j3].Value.Value.String;
  } // endfor

  delete [] f;

  return numRows;
}

int
MDBInterface::remove(const MDomainObject& domainObject,
                       const MCriteriaVector& deleteCriteria )
{

  TBL_CRITERIA *c = new TBL_CRITERIA[deleteCriteria.size()+1];

  int i = 0;

  for (MCriteriaVector::const_iterator j = deleteCriteria.begin();
       j != deleteCriteria.end(); j++) 
  {
     c[i].FieldName = ((*j).attribute).strData();
     c[i].Operator = (*j).oper;
     c[i].Value.Type = TBL_STRING;
     c[i].Value.AllocatedSize = ((*j).value).length()+1;
     c[i].Value.Size = ((*j).value).length()+1;
     c[i].Value.IsNull = 0;
     c[i].Value.Value.String = ((*j).value).strData();
     i++;
  }
 
  c[i].FieldName = 0;
  c[i].Operator = TBL_NOP;
  c[i].Value.Type = TBL_STRING;
  c[i].Value.AllocatedSize = 0;
  c[i].Value.Size = 0;
  c[i].Value.IsNull = 0;
  c[i].Value.Value.String = 0;

  this->deleteRow(c, domainObject.tableName());

  // clean up
  for (int j1 = 0; j1< i; j1++)
  {
    delete [] c[j1].FieldName;
    delete [] c[j1].Value.Value.String;
  } // endfor

  delete [] c;

  return 0;
}

CONDITION processRow( TBL_FIELD* fieldList, long count, void *dbInterface )
{
  MDBInterface& dbi = *(MDBInterface *)dbInterface;
  MDomainObject& o = *(dbi.domainObjPtr());
  MDBINTERFACE_CALLBACK_FUNCTION *callback = dbi.callback();
  void* callbackCtx = dbi.callbackContext();

  if ( (count == 1) || (callback) )
  {
    int i = 0;
    while ( fieldList[i].FieldName )
    {
      MString fieldName = fieldList[i].FieldName;
      if (fieldList[i].Value.Type == TBL_STRING) {
	MString v = fieldList[i].Value.Value.String;
	o.insert(fieldName, v); 
      } else if (fieldList[i].Value.Type == TBL_SIGNED4) {
	o.insert(fieldName, fieldList[i].Value.Value.Signed4[0]); 
      } else {
      }
      i++;
    } // endwhile

    if ( callback )
      callback( o, callbackCtx );
  }  // endif

  return TBL_NORMAL;
}
