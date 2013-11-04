static char rcsid[] = "$Id: MWrapperFactory.cpp,v 1.14 2006/08/03 21:44:18 drm Exp $";

#include "MESA.hpp"
#include "MWrapperFactory.hpp"
#include "MDICOMWrapper.hpp"
#include "MLogClient.hpp"
#include "MString.hpp"

#include <iomanip>
#include <strstream>

#ifdef _WIN32
#include <string.h>
#else
#include <strings.h>
#endif

MWrapperFactory::MWrapperFactory()
{
}
 
MWrapperFactory::MWrapperFactory(const MWrapperFactory& cpy)
{
}

MWrapperFactory::~MWrapperFactory()
{
}

void
MWrapperFactory::printOn(ostream& s) const
{
  s << "MWrapperFactory";
}

void
MWrapperFactory::streamIn(istream& s)
{
  //s >> this->member;
}

// Non boiler-plate methods below

int
MWrapperFactory::modifyWrapper(MDICOMWrapper& w,
			       const MString& fileName) const
{
  char buf[1024] = "";
  fileName.safeExport(buf, sizeof(buf));

  ifstream f(buf);
  if (f == 0)
    return -1;

  while (f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#' || buf[0] == '\n'))
      continue;

    this->processWrapperCommand(w, buf);
  }
  f.close();
  return 0;
}

/*
 * parse a "version 2" DICOM tag definition file that specifies the list of tags 
 * that are to be retained when filtering a DICOM object.
 *
 * The first non-comment non-empty line of the file must contain "version 2"
 *
 * the following illustrate the format of the remaining lines.
 * line1: version 2
 * line2: # comment lines begin with #
 * line3: 0010 0030 2 #  // Patient's Bday
 * line4: 0020 000D 1    // Study Instance UID
 * line5: 0010 0010 1 foo bar   // Patient's Name
 *
 * lines 3, 4 and 5 are defintion lines.
 * The portion of the line following the first '//' is comment.
 * Tokens are deliminated by 'space' and 'tabs'.
 * Empty tokens are ignored.
 * A definition line must have at least 3 tokens: group, element, and type.
 * The type token is currently ignored.
 * The fourth through nth token is the value assigned to the tag.
 * Line 3 has value "#".
 * Line 4 has value "". (empty string)
 * Line 5 has value "foo bar".
 *
 * see MWrapperFactory::retainTags(MDICOMWrapper& w, MTagStringMap& m) const
 * to see how these values are interpreted.
 */
int
MWrapperFactory::retainTags(MDICOMWrapper& w,
			       const MString& fileName) const
{
  MLogClient logClient;
  char buf[1024] = "";
  fileName.safeExport(buf, sizeof(buf));
  int rtnStatus = 0;

  ifstream f(buf);
  if (f == 0)
    return -1;

  MTagStringMap m;
  int group = 0, element = 0;
  char type[4] = "";
  char stringValue[512] = "";

  // the first non-comment or non-empty line must specify "version 2".
  while (f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#' || buf[0] == '\0')) {
 cout << "skip line: " << buf << endl;
      continue;
    }
    else if (::strcmp(buf, "version 2") != 0) {
 cout << "line: " << buf << endl;
        char msg[256] = "";
        ::strncat(msg, "MWrapperFactory::retainTags. Failed to find ", sizeof(msg));
        ::strncat(msg, " \"version 2\" tag definition file: ", sizeof(msg));
        ::strncat(msg, fileName.strData(), sizeof(msg));
        logClient.log(MLogClient::MLOG_ERROR, msg);
        return 1;
    }
    break;
  }

  while (f.getline(buf, sizeof(buf))) {
    if ((buf[0] == '#' || buf[0] == '\0'))
      continue;

    // truncate the line at first "//" to remove comment
    char *comment = ::strstr( buf, "//");
    if( comment != NULL) comment[0] = '\0';

    // the "//" comment is the whole line. skip it.
    if (buf[0] == '\0')
      continue;

    MStringVector tokenVec;
    MString::getTokens( tokenVec, " \t", buf, true);

    // expect at least three tokens per line. group, element and type.
    // type is ignored here.
    if( tokenVec.size() < 3) {
        char msg[256] = "";
        ::strncat(msg, "MWrapperFactory::retainTags. Too few tokens in line \"", 
                  sizeof(msg));
        ::strncat(msg, buf, sizeof(msg));
        ::strncat(msg, "\" in tag definition file ", sizeof(msg));
        ::strncat(msg, fileName.strData(), sizeof(msg));
        logClient.log(MLogClient::MLOG_ERROR, msg);
        return 1;
    }

    char token[16] = "";
    tokenVec[0].safeExport(token, sizeof(token));
    ::sscanf(token, "%x", &group);

    tokenVec[1].safeExport(token, sizeof(token));
    ::sscanf(token, "%x", &element);

    tokenVec[2].safeExport(token, sizeof(token));
    ::sscanf(token, "%s", &type);

    stringValue[0] = '\0';
    if( tokenVec.size() >= 4) {
        ::strncat( stringValue, tokenVec[3].strData(), sizeof(stringValue));
    }

    for( int i = 4; i < tokenVec.size(); i++) {
        ::strncat( stringValue, " ", sizeof(stringValue));
        ::strncat( stringValue, tokenVec[i].strData(), sizeof(stringValue));
    }

    DCM_TAG t = DCM_MAKETAG(group, element);
    m[t] = MString(stringValue);
  }
  f.close();
  if (this->retainTags(w, m) != 0) {
    logClient.log(MLogClient::MLOG_ERROR,
		    "MWrapperFactory::retainTags fails");
    rtnStatus = 1;
  }

  return rtnStatus;
}

// Private methods below
int
MWrapperFactory::processWrapperCommand(MDICOMWrapper& w, char* buf) const
{
  char* tok1;
  char* tok2;

  tok1 = ::strtok(buf, " \t");
  if (tok1 == 0)
    return -1;

  tok2 = ::strtok(0, "\n");

  MString s(tok1);
  int v = 0;

  if (s == "AA") {
    v = this->addAttribute(w, tok2);
  } else if (s == "AS") {
    v = this->addSequence(w, tok2);
  } else if (s == "AI") {
    v = this->addSequenceItem(w, tok2);
  } else if (s == "PG") {
    v = this->removePrivateGroups(w, tok2);
  } else if (s == "RA") {
    v = this->removeAttribute(w, tok2);
  } else if (s == "RG") {
    v = this->removeGroup(w, tok2);
  }

  return v;
}

int
MWrapperFactory::addAttribute(MDICOMWrapper& w, char* buf) const
{
  int group = 0, element = 0;
  char txt[1024];
  int tokens;

  tokens = sscanf(buf, "%x %x %[^\n]", &group, &element, txt);
  if (tokens == 2) {
    strcpy(txt, "");
  } else if (tokens != 3) {
    return -1;
  }

  DCM_TAG t = DCM_MAKETAG(group, element);

  w.setString(t, txt);

  return 0;
}

int
MWrapperFactory::addSequence(MDICOMWrapper& w, char* buf) const
{
  int group = 0, element = 0;

  if (sscanf(buf, "%x %x", &group, &element) != 2)
    return -1;

  DCM_TAG t = DCM_MAKETAG(group, element);

  w.createSequence(t);

  return 0;
}

int
MWrapperFactory::addSequenceItem(MDICOMWrapper& w, char* buf) const
{
  int g1 = 0, e1 = 0;
  int g2 = 0, e2 = 0;
  char txt[1024];

  if (sscanf(buf, "%x %x %x %x %[^\n]", &g1, &e1, &g2, &e2, txt) != 5)
    return -1;

  DCM_TAG t1 = DCM_MAKETAG(g1, e1);
  DCM_TAG t2 = DCM_MAKETAG(g2, e2);

  w.setString(t1, t2, txt, 1);

  return 0;
}

int
MWrapperFactory::removeAttribute(MDICOMWrapper& w, char* buf) const
{
  int group = 0, element = 0;
  int tokens;

  tokens = ::sscanf(buf, "%x %x ", &group, &element);
  if (tokens != 2) {
    return -1;
  }
  DCM_TAG t = DCM_MAKETAG(group, element);

  w.removeElement(t);

  return 0;
}

int
MWrapperFactory::removeGroup(MDICOMWrapper& w, char* buf) const
{
  int group = 0;
  int tokens;

  tokens = ::sscanf(buf, "%x", &group);
  if (tokens != 1) {
    return -1;
  }
  U16 g = (U16)group;

  w.removeGroup(g);

  return 0;
}

int
MWrapperFactory::removePrivateGroups(MDICOMWrapper& w, char* buf) const
{
  w.removePrivateGroups();
  return 0;
}

int
MWrapperFactory::retainTags(MDICOMWrapper& w, MTagStringMap& m) const
{
  DCM_ELEMENT *e;
  CONDITION cond = 0;
  MTagVector deleteVector;
  char logTxt[512] = "";
  MLogClient logClient;
  int rtnStatus = 0;
  U16 group;
  U16 element;

  logClient.log(MLogClient::MLOG_VERBOSE,
		  "MWrapperFactory::retainTags(MDICOMWrapper&, MStringTagMap&) enter method");

  DCM_OBJECT* obj = w.getNativeObject();
  cond = DCM_GetFirstElement(&obj, &e);
  while (cond == DCM_NORMAL) {
    group = DCM_TAG_GROUP(e->tag);
    element = DCM_TAG_ELEMENT(e->tag);

    MTagStringMap::iterator it = m.find(e->tag);
    if (it == m.end()) {
      deleteVector.push_back(e->tag);
    }

    cond = DCM_GetNextElement(&obj, &e);
  }

  MTagVector::iterator vIterator = deleteVector.begin();
  for (;  vIterator != deleteVector.end(); vIterator++) {
    DCM_TAG t = *vIterator;
    group = DCM_TAG_GROUP(t);
    element = DCM_TAG_ELEMENT(t);
    strstream x1(logTxt, sizeof(logTxt));
    x1	<< "Deleting attribute from DICOM object: "
	<< hex << setw(4) << setfill('0') << group << " "
	<< hex << setw(4) << setfill('0') << element << '\0';
    logClient.log(MLogClient::MLOG_VERBOSE, logTxt);

    if (w.removeElement(t) != 0) {
      strstream x1(logTxt, sizeof(logTxt));
      x1 << "Unable to delete attribute with tag: "
	 << hex << setw(4) << setfill('0') << group << " "
	 << hex << setw(4) << setfill('0') << element << '\0';
      logClient.log(MLogClient::MLOG_ERROR, logTxt);
      rtnStatus = 1;
    }
  }
  // Now, go through the list of keepers and set the string values
  // of the non-zero length keys
  MTagStringMap::iterator itStringMap = m.begin();
  for (; itStringMap != m.end(); itStringMap++) {
    DCM_TAG t = (*itStringMap).first;
    MString s = (*itStringMap).second;
    if (s == "") {
      // empty value means pass the existing value.
      continue;
    }
    if( s == "#") {
        // a value of # means blank out the existing value.
        w.setString(t, "");
    } else {
        // replace the existing value with specified value.
        w.setString(t, s);
    }
  }

  logClient.log(MLogClient::MLOG_VERBOSE,
		  "MWrapperFactory::retainTags(MDICOMWrapper&, MTagStringMap&) exit method");
  return rtnStatus;
}
