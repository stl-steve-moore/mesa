#ifndef MDBImageManagerStudyISIN
#define MDBImageManagerStudyISIN

#include "MDBImageManager.hpp"


class MDBImageManagerStudy : public MDBImageManager

{
public:

  virtual ~MDBImageManagerStudy();

  virtual int enterSOPInstance(const MPatient& patient, const MStudy& study,
		       const MSeries& series, const MSOPInstance& sopInstance);
  ///< A new SOP Instance is inserted into the database.  
  /**< Check for existing objects in the database and only insert values into
   tables that need them. */


private:
  MPatientStudyVector mPatientStudyVector;

  void updateRecord(const MPatientStudy& patStudy);
  void setCriteria(const MPatientStudy& patStudy, MCriteriaVector& cv);
  int enter(const MPatientStudy& patStudy);
  int enter(const MSeries& series,
	    const MPatientStudy& patStudy);
  int enter(const MSOPInstance& sopInstance,
	    const MPatientStudy& patStudy,
	    const MSeries& series);
  void incrementSeriesCount(const MPatientStudy& patStudy);
  void incrementSOPInstanceCount(const MPatientStudy& patStudy);
  void updateModalitiesInStudy(const MPatientStudy& patStudy, const MString& modality);

};

#endif /* MDBImageManagerStudyISIN */ 
