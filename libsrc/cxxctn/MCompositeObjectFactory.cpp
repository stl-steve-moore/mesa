static char rcsid[] = "$Id: MCompositeObjectFactory.cpp,v 1.2 2001/07/12 22:52:05 smm Exp $";

#include "MESA.hpp"
#include "MCompositeObjectFactory.hpp"
#include "MDICOMWrapper.hpp"

#ifdef _WIN32
#include <string.h>
#else
#include <strings.h>
#endif

MCompositeObjectFactory::MCompositeObjectFactory()
{
}

MCompositeObjectFactory::MCompositeObjectFactory(const MCompositeObjectFactory& cpy)
{
}

MCompositeObjectFactory::~MCompositeObjectFactory()
{
}

void
MCompositeObjectFactory::printOn(ostream& s) const
{
  s << "MCompositeObjectFactory";
}

void
MCompositeObjectFactory::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

int
MCompositeObjectFactory::copyPatient(MDICOMWrapper& target,
			       MDICOMWrapper& src)
{
  DCM_TAG t[] = {
	0x00100010,	// Patient Name
	0x00100020,	// Patient ID
	0x00100030,	// DOB
	0x00100040	// Sex
  };
  int len = (int)DIM_OF(t);

  int rslt = this->copyAttributes(target, src, t, len);

  return rslt;
}

int
MCompositeObjectFactory::copyGeneralStudy(MDICOMWrapper& target,
			       MDICOMWrapper& src)
{
  DCM_TAG t[] = {
	0x0020000D,	// Study Instance UID
	0x00080020,	// Study Date
	0x00080030,	// Study Time
	0x00080090,	// Patient's referring physician
	0x00200010,	// Study ID
	0x00080050	// Accession Number
  };
  int len = (int)DIM_OF(t);

  int rslt = this->copyAttributes(target, src, t, len);

  return rslt;
}

int
MCompositeObjectFactory::copyPatientStudy(MDICOMWrapper& target,
			       MDICOMWrapper& src)
{
  return 0;
}

int
MCompositeObjectFactory::copyGeneralEquipment(MDICOMWrapper& target,
			       MDICOMWrapper& src
)
{
  DCM_TAG t[] = {
	0x00080070	// Manufacturer
  };
  int len = (int)DIM_OF(t);

  int rslt = this->copyAttributes(target, src, t, len);

  return rslt;
}

int
MCompositeObjectFactory::setSOPCommon(MDICOMWrapper& target, 
        const MString& classUID, const MString& instanceUID,
        const MString& charSet, const MString& creationDate,
        const MString& creationTime, const MString& creatorUID)
{
  target.setString(0x00080016, classUID);
  target.setString(0x00080018, instanceUID);
  if (charSet != "")
    target.setString(0x00080005, charSet);
  if (creationDate != "")
    target.setString(0x00080012, charSet);
  if (creationTime != "")
    target.setString(0x00080013, creationTime);
  if (creatorUID != "")
    target.setString(0x00080014, creatorUID);

  return 0;
}

int
MCompositeObjectFactory::setPresentationState(MDICOMWrapper& target,
        const MString& instanceNumber, const MString& presentationLabel,
        const MString& presentationDescription, const MString& creatorsName,
        const MStringVector& imageFiles)
{
  char buf[128];

  target.setString(0x00200013, instanceNumber);
  target.setString(0x00700080, presentationLabel);
  target.setString(0x00700081, presentationDescription);
  ::UTL_GetDicomDate(buf);
  target.setString(0x00700082, buf);			// Presentation Creation Date
  ::UTL_GetDicomTime(buf);
  target.setString(0x00700083, buf);			// Presentation Creation Time
  target.setString(0x00700084, creatorsName);

  this->addReferencedSeriesSequence(target, imageFiles);
  return 0;
}

int
MCompositeObjectFactory::addReferencedSeriesSequence(MDICOMWrapper& target,
        const MStringVector& imageFiles)
{
  target.createSequence(0x00081115);	// Referenced Series Sequence

  MStringVector::const_iterator it = imageFiles.begin();
  for (; it != imageFiles.end(); it++) {
    MString f = *it;
    MString sopClass;
    MString sopInstance;
    MString seriesUID;
    {
      MDICOMWrapper w;
      if (w.open(f) != 0) {
	cout << "MCompositeObjectFactory::addReferencedSeriesSequence Unable to open DICOM Image: "
	     << f << endl;
	return 1;
      }
      sopClass = w.getString(0x00080016);
      sopInstance = w.getString(0x00080018);
      seriesUID = w.getString(0x0020000E);
    }
    int idx = 1;
    MString s = target.getString(0x00081115, 0x0020000E, idx);
    while (s != "" && s != seriesUID) {
      idx++;
      s = target.getString(0x00081115, 0x0020000E, idx);
    }
    if (s == "") {
      target.setString(0x00081115, 0x0020000E, seriesUID, idx);
    }
    this->addReferencedImage(target, seriesUID, sopClass, sopInstance);
  }
  return 0;
}

// Private methods below
int
MCompositeObjectFactory::copyAttributes(MDICOMWrapper& target,
		MDICOMWrapper& src, DCM_TAG* tags, int count)
{
  int idx;
  MString s;
  for (idx = 0; idx < count; idx++) {
    s = src.getString(tags[idx]);
    target.setString(tags[idx], s);
  }

  return 0;
}

int
MCompositeObjectFactory::addReferencedImage(MDICOMWrapper& target,
  const MString& seriesUID, const MString& sopClass,
  const MString& sopInstance)
{
  CONDITION cond;
  DCM_OBJECT* o = target.getNativeObject();

  LST_HEAD* l = 0;
  cond = ::DCM_GetSequenceList(&o, 0x00081115, &l);
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    return 1;
  }
  DCM_SEQUENCE_ITEM* item = 0;
  item = (DCM_SEQUENCE_ITEM*) ::LST_Head(&l);
  (void) ::LST_Position(&l, item);
  while (item != NULL) {
    MDICOMWrapper w(item->object);
    MString s = w.getString(0x0020000E);
    if (s == seriesUID) {
      int idx = 1;
      MString uid = w.getString(0x00081140, 0x00081150, idx);
      while (uid != "" ) {
	idx++;
	uid = w.getString(0x00081140, 0x00081150, idx);
      }
      w.setString(0x00081140, 0x00081150, sopClass, idx);
      w.setString(0x00081140, 0x00081155, sopInstance, idx);
      break;
    }
  }
  return 0;
}
