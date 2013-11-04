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
// $Id: MESA.hpp,v 1.10 2006/06/06 15:39:00 smm Exp $ $Author: smm $ $Revision: 1.10 $ $Date: 2006/06/06 15:39:00 $ $State: Exp $
//
// ====================
//  = FILENAME
//	MESA.hpp
//
//  = AUTHOR
//	Steve Moore
//
//  = COPYRIGHT
//	Copyright HIMSS, RSNA, Washington University: 1999, 2000
//
// ====================
//
//  = VERSION
//	$Revision: 1.10 $
//
//  = DATE RELEASED
//	$Date: 2006/06/06 15:39:00 $
//
//  = COMMENTS
//	This is the system-wide include file for the MESA tools.
//	It should be included first by any library of application module.

#ifndef MESAIN
#define MESAIN

#ifdef SOLARIS

#ifndef _REENTRANT
#define _REENTRANT
#endif

#define BIG_ENDIAN_ARCHITECTURE
#define USLEEP
#define LONGSIZE 32
#define INTSIZE 32
#define SHORTSIZE 16
#endif

//#ifdef LINUX
//#define LITTLE_ENDIAN_ARCHITECTURE
//#define USLEEP
//#define LONGSIZE 32
//#define INTSIZE 32
//#define SHORTSIZE 16
//#endif

#ifdef LINUX64
#define LITTLE_ENDIAN_ARCHITECTURE
#define USLEEP
#define LONGSIZE 64
#define INTSIZE 32
#define SHORTSIZE 16
#else
#ifdef LINUX
#define LITTLE_ENDIAN_ARCHITECTURE
#define USLEEP
#define LONGSIZE 32
#define INTSIZE 32
#define SHORTSIZE 16
#endif
#endif

#define MASSERT ( EXPR ) ;

#if 0
{ if (! ( EXPR )) { \
    cerr << "MESA Assertion failed in file " << __FILE__ \
	 << " at line " << __LINE__ \
	 << endl; \
    exit(1); \
  }
}
#endif

#ifdef _WIN32
#pragma warning (disable:4786)
#endif

//using namespace std;

#include "MString.hpp"

#endif
