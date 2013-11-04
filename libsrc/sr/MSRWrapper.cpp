#include "MESA.hpp"
#include "MSRWrapper.hpp"

static char rcsid[] = "$Id: MSRWrapper.cpp,v 1.3 2001/07/10 20:08:29 smm Exp $";

MSRWrapper::MSRWrapper()
{
}

MSRWrapper::MSRWrapper(const MSRWrapper& cpy) :
  MDICOMWrapper(cpy)
{
}

MSRWrapper::~MSRWrapper()
{
}

void
MSRWrapper::printOn(ostream& s) const
{
  s << "MSRWrapper" << endl;
  s << " Title: " << mDocumentTitle << endl;
  MSRContentItemVector::const_iterator i = mContentItemVector.begin();
  while (i != mContentItemVector.end()) {
    s << (*i) << endl;
    i++;
  }
}

void
MSRWrapper::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boilerplate methods follow below

MSRWrapper::MSRWrapper(const MString& fileName) :
  MDICOMWrapper(fileName)
{

}

int
MSRWrapper::expandSRTree( )
{
  int v = 0;

  MString docValueType = this->getString(DCM_PRCVALUETYPE);  // 0040 A040
  if (docValueType != "CONTAINER")
    return 1;

  MString s = this->getString(DCM_PRCCONCEPTNAMECODESEQ,
			      DCM_IDCODEVALUE, 1);
  mDocumentTitle.codeValue(s);

  s = this->getString(DCM_PRCCONCEPTNAMECODESEQ,
			      DCM_IDCODINGSCHEMEDESIGNATOR, 1);
  mDocumentTitle.codeMeaning(s);

  s = this->getString(DCM_PRCCONCEPTNAMECODESEQ,
			      DCM_IDCODEMEANING, 1);
  mDocumentTitle.codeSchemeDesignator(s);

  v = this->readContentVector(1, &mObj, mContentItemVector);
  return v;
}

MSRContentItemVector&
MSRWrapper::contentItemVector( )
{
  return mContentItemVector;
}

// Private methods below

int MSRWrapper::readContentVector(int nestLevel, DCM_OBJECT** obj,
				  MSRContentItemVector& v )
{
  LST_HEAD* l = 0;
  CONDITION cond;

  cond = ::DCM_GetSequenceList(obj, DCM_PRCCONTENTSEQ, &l);
  if (cond != DCM_NORMAL)
    return 1;

  DCM_SEQUENCE_ITEM* seqItem;

  seqItem = (DCM_SEQUENCE_ITEM*)::LST_Head(&l);
  ::LST_Position(&l, seqItem);
  while (seqItem != 0) {
    MDICOMWrapper w(seqItem->object);
    MSRContentItem contentItem;
    MString s = w.getString(DCM_PRCRELATIONSHIPTYPE);
    contentItem.relationshipType(s);
    s = w.getString(DCM_PRCVALUETYPE);
    contentItem.valueType(s);
    contentItem.nestLevel(nestLevel);
    contentItem.objectReference(seqItem->object);

    if (w.attributePresent(DCM_PRCCONTENTSEQ)) {
      MSRContentItemVector& v2 = contentItem.contentItemVector( );
      this->readContentVector(nestLevel+1, &seqItem->object, v2);
    }

    v.push_back(contentItem);

    seqItem = (DCM_SEQUENCE_ITEM*)::LST_Next(&l);
  }
  return 0;
}
