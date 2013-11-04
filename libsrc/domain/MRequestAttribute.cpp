#include "MRequestAttribute.hpp"

MRequestAttribute::MRequestAttribute()
{
  tableName("series_reqattseq");
  insert("serinsuid");
  insert("reqproid");
  insert("schprosteid");
}

MRequestAttribute::MRequestAttribute(const MRequestAttribute& cpy) :
  mSeriesInstanceUID(cpy.mSeriesInstanceUID),
  mRequestedProcedureID(cpy.mRequestedProcedureID),
  mScheduledProcedureStepID(cpy.mScheduledProcedureStepID)
{
  tableName("series_reqattseq");
  insert("serinsuid", cpy.mSeriesInstanceUID);
  insert("reqproid", cpy.mRequestedProcedureID);
  insert("schprosteid", cpy.mScheduledProcedureStepID);
}

MRequestAttribute::~MRequestAttribute()
{
}

void
MRequestAttribute::printOn(ostream& s) const
{
  s << "(Series) Request Attributes:"
    << mSeriesInstanceUID << ":"
    << mRequestedProcedureID << ":"
    << mScheduledProcedureStepID;
}

void
MRequestAttribute::streamIn(istream& s)
{
  s >> mSeriesInstanceUID;
}

MRequestAttribute::MRequestAttribute(
		 const MString& seriesInstanceUID,
                 const MString& requestedProcedureID,
                 const MString& scheduledProcedureStepID) :
  mSeriesInstanceUID(seriesInstanceUID),
  mRequestedProcedureID(requestedProcedureID),
  mScheduledProcedureStepID(scheduledProcedureStepID)
{
  tableName("series_reqattseq");
  insert("serinsuid", mSeriesInstanceUID);
  insert("reqproid", mRequestedProcedureID);
  insert("schprosteid", mScheduledProcedureStepID);
}

MString
MRequestAttribute::seriesInstanceUID() const
{
  return mSeriesInstanceUID;
}

MString
MRequestAttribute::requestedProcedureID() const
{
  return mRequestedProcedureID;
}

MString
MRequestAttribute::scheduledProcedureStepID() const
{
  return mScheduledProcedureStepID;
}


void
MRequestAttribute::seriesInstanceUID(const MString& s)
{
  mSeriesInstanceUID = s;
  insert("serinsuid", s);
}

void
MRequestAttribute::requestedProcedureID(const MString& s)
{
  mRequestedProcedureID = s;
  insert("reqproid", s);
}

void
MRequestAttribute::scheduledProcedureStepID(const MString& s)
{
  mScheduledProcedureStepID = s;
  insert("schprosteid", s);
}


void
MRequestAttribute::import(const MDomainObject& o)
{
  seriesInstanceUID(o.value("serinsuid"));
  requestedProcedureID(o.value("reqproid"));
  scheduledProcedureStepID(o.value("schprosteid"));
}
