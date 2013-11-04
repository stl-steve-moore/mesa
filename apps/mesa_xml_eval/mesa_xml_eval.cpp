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

static char rcsid[] = "$Revision: 1.7 $ $RCSfile: mesa_xml_eval.cpp,v $";


#include <iostream>
//#include <ostream>
#include <fstream>

#include "xercesc/util/PlatformUtils.hpp"
//#include "xercesc/util/XMLString.hpp"
//#include "xercesc/util/XMLUniDefs.hpp"
#include "xercesc/framework/XMLFormatter.hpp"
//#include "xercesc/util/TranscodingException.hpp"
//#include "xercesc/dom/DOM_DOMException.hpp"

#include "xercesc/dom/DOM.hpp"
#include "xercesc/parsers/XercesDOMParser.hpp"

#include "DOMTreeErrorReporter.hpp"

#include "ctn_os.h"

#include "MESA.hpp"
#include "ctn_api.h"
#include "MFileOperations.hpp"

#include "MESA.hpp"
#include "ctn_api.h"
#include "MFileOperations.hpp"

//using namespace std;

ostream& operator<< (ostream& target, const DOMString& s)
{
    char *p = s.transcode();
    target << p;
    delete [] p;
    return target;
}


static void usage()
{
  char msg[] =
"Usage: [-l level] [-s schema] [-v] file\n\
\n\
  -l      Level of detail for output (1-4); default is 1 \n\
  -s      Path name to schema definition \n\
           default is $MESA_TARGET/runtime/IHE-syslog-audit-message-4.xsd\n\
  -v      Verbose mode\n\
\n\
  file    Name of file to evaluate";

  cout << msg << endl;
  ::exit(1);
}


class DOMPrintFormatTarget : public XMLFormatTarget
{
public:
    DOMPrintFormatTarget()  {};
    ~DOMPrintFormatTarget() {};

    // -----------------------------------------------------------------------
    //  Implementations of the format target interface
    // -----------------------------------------------------------------------

    void writeChars(const   XMLByte* const  toWrite,
                    const   unsigned int    count,
                            XMLFormatter * const formatter)
    {
        // Surprisingly, Solaris was the only platform on which
        // required the char* cast to print out the string correctly.
        // Without the cast, it was printing the pointer value in hex.
        // Quite annoying, considering every other platform printed
        // the string with the explicit cast to char* below.
        cout.write((char *) toWrite, (int) count);
    };

private:
    // -----------------------------------------------------------------------
    //  Unimplemented methods.
    // -----------------------------------------------------------------------
    DOMPrintFormatTarget(const DOMPrintFormatTarget& other);
    void operator=(const DOMPrintFormatTarget& rhs);
};


int main(int argc, char **argv)
{
  bool verbose = false;
#if 0
  DOMParser::ValSchemes    gValScheme             = DOMParser::Val_Auto;
  bool                     gDoNamespaces          = true;
  bool                     gDoSchema              = true;
  bool                     gSchemaFullChecking    = false;
  bool                     gDoCreate              = false;
#endif

  MFileOperations f;
  char path[1024];

  f.expandPath(path, "MESA_TARGET", "runtime");
  ::strcat(path, "/IHE-syslog-audit-message-4.xsd");
  char* schemaDef = path;

  int detailLevel = 1;
  MString tmp;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'l':
      argc--; argv++;
      if (argc < 1)
	usage();
      tmp = *argv;
      detailLevel = tmp.intData();
      break;
    case 's':
      argc--; argv++;
      if (argc < 1)
	usage();
      schemaDef = *argv;
      break;
    case 'v':
      verbose = true;
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usage();

  // Initialize the XML4C2 system
  try {
    XMLPlatformUtils::Initialize();
  }
  catch (const XMLException& e) {
    cout << "Unable to initialize Xerces-c software"
	 << DOMString(e.getMessage()) << endl;
    return 1;
  }


  DOMParser *parser = new DOMParser;
  parser->setValidationScheme(DOMParser::Val_Auto);
  parser->setDoNamespaces(true);
  parser->setDoSchema(true);
  parser->setValidationSchemaFullChecking(true);
  if (schemaDef != "") {
    parser->setExternalNoNamespaceSchemaLocation(schemaDef);
  }

  DOMTreeErrorReporter *errReporter = new DOMTreeErrorReporter();
  parser->setErrorHandler(errReporter);
  parser->setCreateEntityReferenceNodes(false);
  parser->setToCreateXMLDeclTypeNode(true);

  bool errorFlag = false;

  try {
    parser->parse(*argv);
    int count = parser->getErrorCount();
    if (count > 0) {
      errorFlag = true;
      return 1;
    }
  }
  catch (const XMLException& e) {
    cout << "Parsing error: " << DOMString(e.getMessage()) << endl;
    return 1;
  }
  catch (const DOM_DOMException& e) {
   cout << "DOM Error: " << e.code << endl;
   return 1;
  }

  catch (...) {
    cout << "Unspecified error" << endl;
    return 1;
  }

  DOM_Document doc = parser->getDocument();

  unsigned int elementCount = doc.getElementsByTagName("*").getLength();

  cout << "element count: " << elementCount << endl;

  return 0;
}


