#include "MESA.hpp"
#include "MDBImageManagerStudy.hpp" 


MDBImageManagerStudy :: ~MDBImageManagerStudy () { }

int
MDBImageManagerStudy :: enterSOPInstance(const MPatient& patient,
					 const MStudy& study,
					 const MSeries& series,
					 const MSOPInstance& sopInstance)
{

  if (mDBInterface == 0)
    return 0;
  
  MPatientStudy patientStudy (patient, study); 
  
  this->enter(patientStudy); 
   
  this->enter(series, patientStudy); 

  this->enter(sopInstance, patientStudy, series); 

  return 0;

}

void
MDBImageManagerStudy :: updateRecord (const MPatientStudy& patStudy)
{
  if (mDBInterface == 0)
    return;

  MCriteriaVector cv;
  MUpdateVector   uv;

  setCriteria(patStudy, cv);
  MDBImageManager::setCriteria(patStudy, uv);

  mDBInterface->update(patStudy, cv, uv);
}

void
MDBImageManagerStudy :: setCriteria (const MPatientStudy& patStudy, MCriteriaVector& cv)
{
  MCriteria c;
  
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = patStudy.studyInstanceUID();
  cv.push_back(c);
}


int
MDBImageManagerStudy :: enter (const MPatientStudy& patStudy)
{
       // first do sanity check
  if (!mDBInterface)
    return 0;

  if (patStudy.mapEmpty())
    return 0;

  // check if study already exists
  MCriteriaVector cv;
  MCriteria c;

  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = patStudy.studyInstanceUID();
  cv.push_back(c);


  MPatientStudy s;
  if (mDBInterface->select(s, cv, NULL)) {  // Study is already present
    ;
  } else { // add a new study
    mDBInterface->insert(patStudy);
  }
}


int
MDBImageManagerStudy :: enter (const MSeries& series, const MPatientStudy& patStudy)
{
  // first do sanity check
  if (!mDBInterface)
    return 0;

  if (series.mapEmpty())
    return 0;

  // check if series already exists
  MCriteriaVector cv;
  MCriteria c;
  
  c.attribute = "serinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = series.seriesInstanceUID();
  cv.push_back(c);

  MSeries s;
  if (mDBInterface->select(s, cv, NULL)) {  // Series is already present
    ;
  } else { // add a new series
    mDBInterface->insert(series);
    this->incrementSeriesCount(patStudy);
    MString modality = series.modality();
    this->updateModalitiesInStudy(patStudy, modality);
  }
}


int
MDBImageManagerStudy :: enter (const MSOPInstance& sopInstance,
			       const MPatientStudy& patStudy,
			       const MSeries& series)
{
  // first do sanity check
  if (!mDBInterface)
    return 0;

  if (sopInstance.mapEmpty())
    return 0;

  // check if sopInstance already exists
  MCriteriaVector cv;
  MCriteria c;
  
  c.attribute = "insuid";
  c.oper      = TBL_EQUAL;
  c.value     = sopInstance.instanceUID();
  cv.push_back(c);

  MSOPInstance s;
  if (mDBInterface->select(s, cv, NULL)) {  // SOP Instance is already present
    ;
  }   else { // add a new SOP Instance
    mDBInterface->insert(sopInstance);
    this->incrementSOPInstanceCount(patStudy);
    this->MDBImageManager::incrementSOPInstanceCount(series);
  }
}

void
MDBImageManagerStudy :: incrementSeriesCount (const MPatientStudy& patStudy) {
  MCriteria c;
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = patStudy.studyInstanceUID();

  MCriteriaVector cv;
  cv.push_back(c);

  MUpdateVector updateVector;
  MUpdate u;

  u.attribute = "numser";
  u.func      = TBL_INCREMENT;
  u.value     = "";
  updateVector.push_back(u);

  mDBInterface->update(patStudy, cv, updateVector);
}


void
MDBImageManagerStudy :: incrementSOPInstanceCount (const MPatientStudy& patStudy) {
  MCriteria c;
  c.attribute = "stuinsuid";
  c.oper      = TBL_EQUAL;
  c.value     = patStudy.studyInstanceUID();

  MCriteriaVector cv;
  cv.push_back(c);

  MUpdateVector updateVector;
  MUpdate u;

  u.attribute = "numins";
  u.func      = TBL_INCREMENT;
  u.value     = "";
  updateVector.push_back(u);

  mDBInterface->update(patStudy, cv, updateVector);
}


void
MDBImageManagerStudy :: updateModalitiesInStudy (const MPatientStudy& patStudy,
						 const MString& modality)
{
  MPatientStudyVector v;

  MString uid = patStudy.studyInstanceUID();
  MPatientStudy tempStudy;
  tempStudy.studyInstanceUID(uid);
  MPatientStudyVector::iterator studyStart = mPatientStudyVector.begin();
  MPatientStudyVector::iterator studyEnd = mPatientStudyVector.end();
  mPatientStudyVector.erase(studyStart, studyEnd);



  //const MDomainMap& map = patientStudy.map();
  //MDomainMap::const_iterator iDomain = map.find("patid");
  //MString st = (*iDomain).second;
  //cout << "test: " << st << endl;



  this->fillPatientStudyVector(tempStudy, v);

  if (v.size() != 1) {
    cerr << "Error when trying to select one MPatientStudy object " << endl;
    cerr << "Study UID = " << uid << endl;
    cerr << "Count = " << v.size() << endl;
    return;
  }

  tempStudy = v[0];

  MString x = tempStudy.modalitiesInStudy();
  bool done = false;
  bool found = false;
  int index = 0;
  for (index = 0; !done; index++) {
    if (!x.tokenExists('+', index))
      break;
    MString s = x.getToken('+', index);
    if (s == modality) {
      found = true;
      done = true;
    }
  }
  if (!found) {
    if (x == "") {
      x = modality;
    } else {
      x = x + "+" + modality;
    }

    tempStudy.modalitiesInStudy(x);
    updateRecord(tempStudy);
  }
}





