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

static char rcsid[] = "$Revision: 1.27 $ $RCSfile: compare_dcm.cpp,v $";

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#ifdef GCCSUNOS
#include <sys/types.h>
#endif
#include "MESA.hpp"
#include "ctn_api.h"
#include <iostream>
#include <fstream>

#include <map>
#include <set>

static CTNBOOLEAN verboseOutput = FALSE;

static void usageerror();

typedef map<DCM_TAG, DCM_TAG> tag_pair;
typedef set<DCM_TAG> tag_set;

static tag_set *mask;
static tag_pair *keys;

typedef struct {
  long* differences;
  char tag1[512];
  char tag2[512];
} CONTEXT_STRUCT;

static void
compareAttribute(const DCM_ELEMENT*, const DCM_ELEMENT*, CONTEXT_STRUCT* s,
		 int printFlag);


static void
compareTextAttribute(const DCM_ELEMENT * e1,
		     const DCM_ELEMENT * e2, CONTEXT_STRUCT* s,
		     int printFlag)
{
    const char *c1;
    const char *c2;

    c1 = e1->d.string;
    c2 = e2->d.string;

    while (*c1 == ' ')
	c1++;

    while (*c2 == ' ')
	c2++;

    char* buf1 = new char[e1->length + 40];

    if (e1->length == 0) {
      strcpy(buf1, "(zero length)");
    } else {
      memcpy(buf1, c1, e1->length);
      buf1[e1->length] = 0;
    }

    char* buf2 = new char[e2->length + 40];

    if (e2->length == 0) {
      strcpy(buf2, "(zero length)");
    } else {
      memcpy(buf2, c2, e2->length);
      buf2[e2->length] = 0;
    }

    int index;
    index = strlen(buf1) - 1;
    while (index >= 0) {
      if (buf1[index] == ' ')
	buf1[index--] = '\0';
      else
	break;
    }

    index = strlen(buf2) - 1;
    while (index >= 0) {
      if (buf2[index] == ' ' || buf2[index] == '^')
	buf2[index--] = '\0';
      else
	break;
    }

    if (verboseOutput) {
      cout << "   " << buf1 << endl;
      cout << "   " << buf2 << endl;

    }

    if (strcmp(buf1, buf2) == 0) {
	delete []buf1;
	delete []buf2;
	return;
    }

    if (printFlag) {
      char txt[1024];
      sprintf(txt, "  TEXT %04x %04x %32s\n        %s\n        %s",
	   DCM_TAG_GROUP(e1->tag),
	   DCM_TAG_ELEMENT(e2->tag),
	   e1->description,
	   buf1, buf2);
      cout << s->tag1 << txt << endl;
    }
    //(*(long *) ctx)++;
    (*s->differences)++;

    delete []buf1;
    delete []buf2;
}

static void
comparePNAttribute(const DCM_ELEMENT * e1,
		     const DCM_ELEMENT * e2, CONTEXT_STRUCT* s,
		     int printFlag)
{
    const char *c1;
    const char *c2;

    c1 = e1->d.string;
    c2 = e2->d.string;

    while (*c1 == ' ')
	c1++;

    while (*c2 == ' ')
	c2++;

    char* buf1 = new char[e1->length + 40];

    if (e1->length == 0) {
      strcpy(buf1, "(zero length)");
    } else {
      memcpy(buf1, c1, e1->length);
      buf1[e1->length] = 0;
    }

    char* buf2 = new char[e2->length + 40];

    if (e2->length == 0) {
      strcpy(buf2, "(zero length)");
    } else {
      memcpy(buf2, c2, e2->length);
      buf2[e2->length] = 0;
    }

    int index;
    index = strlen(buf1) - 1;
    while (index >= 0) {
      if (buf1[index] == ' ' || buf1[index] == '^')
	buf1[index--] = '\0';
      else
	break;
    }

    index = strlen(buf2) - 1;
    while (index >= 0) {
      if (buf2[index] == ' ' || buf2[index] == '^')
	buf2[index--] = '\0';
      else
	break;
    }

    if (verboseOutput) {
      cout << "   " << buf1 << endl;
      cout << "   " << buf2 << endl;

    }

    if (strcmp(buf1, buf2) == 0) {
	delete []buf1;
	delete []buf2;
	return;
    }

    if (printFlag) {
      char txt[1024];
      sprintf(txt, "  TEXT %04x %04x %32s\n        %s\n        %s",
	   DCM_TAG_GROUP(e1->tag),
	   DCM_TAG_ELEMENT(e2->tag),
	   e1->description,
	   buf1, buf2);
      cout << s->tag1 << txt << endl;
    }
    //(*(long *) ctx)++;
    (*s->differences)++;

    delete []buf1;
    delete []buf2;
}


static void
compareULAttribute(const DCM_ELEMENT * e1, const DCM_ELEMENT * e2,
		   CONTEXT_STRUCT* s, int printFlag)
{
  const U32 *p1,
    *p2;
  U32 l1;
  char txt[1024];

  p1 = e1->d.ul;
  p2 = e2->d.ul;
  if (e1->length != e2->length) {
    sprintf(txt, "  LENGTH %04x %04x %32s %d %d",
	    DCM_TAG_GROUP(e1->tag),
	    DCM_TAG_ELEMENT(e2->tag),
	    e1->description,
	    e1->length, e2->length);
    cout << s->tag1 << txt << endl;

    (*s->differences)++;
    return;
  }
  l1 = e1->length;

  while (l1 > 0) {
    if (*p1 != *p2) {
      if (printFlag) {
	sprintf(txt, "  BINARY %04x %04x %32s %d %d",
		DCM_TAG_GROUP(e1->tag),
		DCM_TAG_ELEMENT(e2->tag),
		e1->description,
		*p1, *p2);
	cout << s->tag1 << txt << endl;
      }
      (*s->differences)++;
      return;
    }
    p1++;
    p2++;
    l1 -= sizeof(U32);
  }
}

static void
compareSLAttribute(const DCM_ELEMENT * e1, const DCM_ELEMENT * e2,
		   CONTEXT_STRUCT* s, int printFlag)
{
  const S32 *p1,
    *p2;
  U32 l1;
  char txt[1024];

  p1 = e1->d.sl;
  p2 = e2->d.sl;
  if (e1->length != e2->length) {
    if (printFlag) {
      sprintf(txt, "  LENGTH %04x %04x %32s %d %d",
	      DCM_TAG_GROUP(e1->tag),
	      DCM_TAG_ELEMENT(e2->tag),
	      e1->description,
	      e1->length, e2->length);
      cout << s->tag1 << txt << endl;
    }
    (*s->differences)++;
    return;
  }
  l1 = e1->length;

  while (l1 > 0) {
    if (*p1 != *p2) {
      if (printFlag) {
	sprintf(txt, "  BINARY %04x %04x %32s %d %d",
		DCM_TAG_GROUP(e1->tag),
		DCM_TAG_ELEMENT(e2->tag),
		e1->description,
		*p1, *p2);
	cout << s->tag1 << txt << endl;
      }
      (*s->differences)++;
      return;
    }
    p1++;
    p2++;
    l1 -= sizeof(S32);
  }
}

static void
compareUSAttribute(const DCM_ELEMENT * e1, const DCM_ELEMENT * e2,
		   CONTEXT_STRUCT* s, int printFlag)
{
  const U16 *p1,
    *p2;
  U32 l1;
  char txt[1024];

  p1 = e1->d.us;
  p2 = e2->d.us;
  if (e1->length != e2->length) {
    if (printFlag) {
      sprintf(txt, "  LENGTH %04x %04x %32s %d %d",
	      DCM_TAG_GROUP(e1->tag),
	      DCM_TAG_ELEMENT(e2->tag),
	      e1->description,
	      e1->length, e2->length);
      cout << s->tag1 << txt << endl;
    }
    (*s->differences)++;
    return;
  }
  l1 = e1->length;

  while (l1 > 0) {
    if (*p1 != *p2) {
      if (printFlag) {
	sprintf(txt, "  BINARY %04x %04x %32s %d %d",
		DCM_TAG_GROUP(e1->tag),
		DCM_TAG_ELEMENT(e2->tag),
		e1->description,
		*p1, *p2);
	cout << s->tag1 << txt << endl;
      }
      (*s->differences)++;
      return;
    }
    p1++;
    p2++;
    l1 -= sizeof(U16);
  }
}

static void
compareSSAttribute(const DCM_ELEMENT * e1, const DCM_ELEMENT * e2,
		   CONTEXT_STRUCT* s, int printFlag)
{
  const S16 *p1,
    *p2;
  S32 l1;
  char txt[1024];

  p1 = e1->d.ss;
  p2 = e2->d.ss;
  if (e1->length != e2->length) {
    if (printFlag) {
      sprintf(txt, "\n  LENGTH %04x %04x %32s %d %d",
	      DCM_TAG_GROUP(e1->tag),
	      DCM_TAG_ELEMENT(e2->tag),
	      e1->description,
	      e1->length, e2->length);
      cout << s->tag1 << txt << endl;
    }
    (*s->differences)++;
    return;
  }
  l1 = e1->length;

  while (l1 > 0) {
    if (*p1 != *p2) {
      if (printFlag) {
	sprintf(txt, "  BINARY %04x %04x %32s %d %d",
		DCM_TAG_GROUP(e1->tag),
		DCM_TAG_ELEMENT(e2->tag),
		e1->description,
		*p1, *p2);
	cout << s->tag1 << txt << endl;
      }
      (*s->differences)++;
      return;
    }
    p1++;
    p2++;
    l1 -= sizeof(S16);
  }
}


static void
compareCallback(const DCM_ELEMENT * e1, const DCM_ELEMENT * e2,
		void* sParam)
{
  CONTEXT_STRUCT* s = (CONTEXT_STRUCT*) sParam;
  char txt[1024];

  if (mask->empty()) {   // No mask file
    if (e1 == NULL) {
      sprintf(txt, "  INPUT %04x %04x %32s", DCM_TAG_GROUP(e2->tag),
	       DCM_TAG_ELEMENT(e2->tag), e2->description);
      cout << s->tag1 << txt << endl;
      (*s->differences)++;
      //(*(long *) ctx)++;
    } else if (e2 == NULL) {
      sprintf(txt, "  MASTER %04x %04x %32s", DCM_TAG_GROUP(e1->tag),
	      DCM_TAG_ELEMENT(e1->tag), e1->description);
      cout << s->tag1 << txt << endl;
      (*s->differences)++;
      //(*(long *) ctx)++;
    } else {
      compareAttribute(e1, e2, s, 1);
    }
  } else {                 // Use mask file
    if (e1 == NULL) {
      //cout << "  Compared attribute not found in master, moving on..." << endl;
    } else if (e2 == NULL) {
      if (mask->find(e1->tag) != mask->end()) {
	cout << "  Compared attribute missing." << endl;
	char txt[1024];
	sprintf(txt, " MASTER %04x %04x %32s", DCM_TAG_GROUP(e1->tag),
	       DCM_TAG_ELEMENT(e1->tag), e1->description);
	cout << txt << endl;
	(*s->differences)++;
	//(*(long *) ctx)++;
      }
    } else {

      // If attribute defined in mask file, compute difference
      if (mask->find(e2->tag) != mask->end()) {
	//long count = *(long *) ctx;
	compareAttribute(e1, e2, s, 1);
	//if ((count != *(long *) ctx) && (e1->representation != DCM_SQ))
	//cout << "  Compared attribute differs from Master" << endl;
      }
    }                      // end if mask file   
  }
}


static void
compareSequence(const DCM_ELEMENT *e1, const DCM_ELEMENT *e2,
		CONTEXT_STRUCT* s, int printFlag)
{
  char sequence[100];
  sprintf (sequence, "  In sequence: %04x %04x %32s\n\n",
	  DCM_TAG_GROUP(e1->tag), DCM_TAG_ELEMENT(e1->tag),
	  e1->description);

  LST_HEAD *head1 = e1->d.sq;
  DCM_SEQUENCE_ITEM* item1 = (DCM_SEQUENCE_ITEM *)::LST_Head(&head1);
  (void)::LST_Position(&head1, item1);
 
  LST_HEAD *head2 = e2->d.sq;
  DCM_SEQUENCE_ITEM* item2 = (DCM_SEQUENCE_ITEM *)::LST_Head(&head2);
  (void)::LST_Position(&head2, item2);

  char txt[512];
  sprintf(txt, " (%04x %04x)",
	  DCM_TAG_GROUP(e1->tag), DCM_TAG_ELEMENT(e1->tag));
  CONTEXT_STRUCT localStruct = *s;
  strcat(localStruct.tag1, txt);
  strcat(localStruct.tag2, txt);

  int itemNumber = 1;
  while (item1 != 0) {
    DCM_OBJECT *obj1 = item1->object;
    DCM_OBJECT *obj2;

    tag_pair::const_iterator i = keys->find(e1->tag);
    
    // If there is no key for this sequence, use the correspondingly
    // numbered sequence item.
    if (i == keys->end()) {
      if (item2 != 0) {
	obj2 = item2->object;
	item2 = (DCM_SEQUENCE_ITEM *)::LST_Next(&head2);
	DCM_CompareAttributes(&obj1, &obj2, compareCallback, &localStruct);
      } else {
	// The obj2 sequence is empty, so we do not match.
	if (printFlag) {
	  cout << "Sequence item missing in file under test" << endl;
	  cout << "Sequence is " << txt << endl;
	  cout << "Item in the sequence is " << itemNumber << endl;
	}
	(*s->differences)++;
	//( *(long *)ctx)++;
      }
    }

    // Otherwise, search for the correct sequence item, based on a key.
    else {

      DCM_ELEMENT keyElement;
      CONDITION cond = ::DCM_GetElement(&obj1, (*i).second, &keyElement);
      keyElement.d.ot = malloc(keyElement.length);
      U32 rtnLength;
      U32 getctx = 0;
      cond = ::DCM_GetElementValue(&obj1, &keyElement, &rtnLength, (void **) &getctx);

      item2 = (DCM_SEQUENCE_ITEM *)::LST_Head(&head2);
      (void)::LST_Position(&head2, item2);
      
      // Find corresponding element in the sequence
      bool found = false;
      DCM_ELEMENT tempElement;
      while (item2 != 0 && !found) {
	obj2 = item2->object;
	::DCM_GetElement(&obj2, (*i).second, &tempElement);
	tempElement.d.ot = malloc(tempElement.length);
	getctx = 0;
	cond = ::DCM_GetElementValue(&obj2, &tempElement, &rtnLength, (void **) &getctx);
	
	// Check for match (found = true, if match)
	long check = -999;
	long ck = *s->differences;
	long saveDifferences = *s->differences;

	//compareAttribute(&keyElement, &tempElement, &check);
	compareAttribute(&keyElement, &tempElement, &localStruct, 0);
	//found = (check == -999);
	found = (ck == *s->differences);

	free (tempElement.d.ot);
	item2 = (DCM_SEQUENCE_ITEM *)::LST_Next(&head2);
	*s->differences = saveDifferences;
      }
      
      free (keyElement.d.ot);
      if (found) {
	//long oldCount = *(long *)ctx;
	long oldCount = *s->differences;
        DCM_CompareAttributes(&obj1, &obj2, compareCallback, &localStruct);
	if (*s->differences != oldCount)
	  cout << sequence << endl;
      }
      else {
	char* buf = new char[keyElement.length + 1];
	memcpy(buf, keyElement.d.string, keyElement.length);
	buf[keyElement.length] = 0;
	char txt[128];
	::sprintf(txt, "  Tag of the key element is: %04x %04x",
		  DCM_TAG_GROUP(keyElement.tag),
		  DCM_TAG_ELEMENT(keyElement.tag));

	cout << "  No corresponding element for the key value: " << buf << endl;
	cout << txt << endl;
	cout << "  Sequence item differs.\n";
	cout << sequence << endl;
	//( *(long *)ctx)++;
	(*s->differences)++;

	delete []buf;
      }
    }
  
    // Continue iteration through the sequence
    item1 = (DCM_SEQUENCE_ITEM *)::LST_Next(&head1);

    itemNumber++;
  }  // end while (through sequence)
  
}


static void
compareAttribute(const DCM_ELEMENT * e1, const DCM_ELEMENT * e2,
		 CONTEXT_STRUCT* s, int printFlag)
{
  char txt[1024];

    if ((*s->differences) >= 0) {
    //if ( *(long *)ctx >= 0) {
      if (verboseOutput) {
	sprintf(txt, " %04x %04x %32s", DCM_TAG_GROUP(e1->tag),
	       DCM_TAG_ELEMENT(e1->tag), e1->description);
	cout << s->tag1 << txt << endl;
      }
      if (e1->representation != e2->representation) {
	if (printFlag) {
	  sprintf(txt, " VR    %04x %04x %32s\n",
		  DCM_TAG_GROUP(e1->tag),
		  DCM_TAG_ELEMENT(e1->tag), e1->description);
	  cout << txt << endl;
	}
	return;
      }
    }
    switch (e1->representation) {
    case DCM_AE:		// Application Entity
    case DCM_AS:		// Age string
	compareTextAttribute(e1, e2, s, printFlag);
	break;
    case DCM_AT:		// Attribute tag
	break;
    case DCM_CS:		// Control string
    case DCM_DA:		// Date
	compareTextAttribute(e1, e2, s, printFlag);
	break;
    case DCM_DD:		// Data set
	break;
    case DCM_DS:		// Decimal string
	compareTextAttribute(e1, e2, s, printFlag);
	break;
    case DCM_FD:		// Floating double
    case DCM_FL:		// Float
	break;
    case DCM_IS:		// Integer string
    case DCM_LO:		// Long string
    case DCM_LT:		// Long text
	compareTextAttribute(e1, e2, s, printFlag);
	break;
    case DCM_OT:		// Other binary value
	break;
    case DCM_SH:		// Short string
	compareTextAttribute(e1, e2, s, printFlag);
	break;
    case DCM_SL:		// Signed long
	compareSLAttribute(e1, e2, s, printFlag);
	break;
    case DCM_SQ:		// Sequence of items
	compareSequence(e1, e2, s, printFlag);
	break;
    case DCM_SS:		// Signed short
	compareSSAttribute(e1, e2, s, printFlag);
	break;
    case DCM_ST:		// Short text
    case DCM_TM:		// Time
    case DCM_UI:		// Unique identifier (UID)
	compareTextAttribute(e1, e2, s, printFlag);
	break;
    case DCM_UL:		// Unsigned long
	compareULAttribute(e1, e2, s, printFlag);
	break;
    case DCM_US:		// Unsigned short
	compareUSAttribute(e1, e2, s, printFlag);
	break;
    case DCM_UN:		// Unknown
    case DCM_RET:		// Retired
    case DCM_CTX:		// Context sensitive (non-standard)
	break;
    case DCM_PN:		// Person Name
	comparePNAttribute(e1, e2, s, printFlag);
	break;
    case DCM_OB:		// Other, byte
    case DCM_OW:		// Other, word
	break;
    case DCM_DT:		// Date/Time
	compareTextAttribute(e1, e2, s, printFlag);
	break;
    case DCM_DLM:
	break;
    }
}

static void
loadMaskFile(char* filename) {
  if (*filename == '\0')
    cout << "No mask file." << endl;
  else {
    cout << "Using mask file: " << filename << endl;
    ifstream in(filename);
    char c;
    char groupStr[20];
    char elementStr[20];
    int group, element;
    DCM_TAG tag, sequenceTag;

    // Read in Dicom Tags from file in the format "(group element)"
    while (in) {
      in >> c;
      
      switch (c) {
      // Ignore lines beginning with # or / to allow for comments
      case '#':
      case '/': 
	while (in && c != '\n')
	  in.get(c);
	break;

      // Sequence
      case '(':
	sequenceTag = tag;
	break;
      case ')':
	sequenceTag = 0;
	break;

      case 'K':
	// Key value, use previous tag if valid
	if (sequenceTag && tag)
	  keys->insert(tag_pair::value_type(sequenceTag, tag));
	break;
      
      default:
	in.putback(c);
	in >> groupStr;
	in >> elementStr;
	group = (int) strtol(groupStr, NULL, 16);
	element = (int) strtol(elementStr, NULL, 16);

	// If all went well, add the tag to the mask set.
	if (in && group && element) {
	  tag = DCM_MAKETAG(group, element);
	  mask->insert(tag);
	  //cout << "tag: (" << groupStr << " "
	  //     << elementStr << ")  -  " << tag << endl;
	}
	else if (!in.eof()) {
	  cout << "Illegal format of mask file!" << endl;
	  mask->clear();
	  in.clear(ios::badbit);
	}

      } // end switch
    } // end while

    tag_pair::const_iterator i;
    for (i = keys->begin(); i != keys->end(); i++) {
      DCM_TAG sequence = (*i).first;
      DCM_TAG key = (*i).second;
      //printf("Using %04x %04x as a key for sequence %04x %04x\n",
      //     DCM_TAG_GROUP(key), DCM_TAG_ELEMENT(key),
      //     DCM_TAG_GROUP(sequence), DCM_TAG_ELEMENT(sequence));
    }
  }  // end if
}

int main(int argc, char **argv)
{
  mask = new tag_set;
  keys = new tag_pair;

  DCM_OBJECT *obj1,
    *obj2;
  CONDITION cond;
  unsigned long
    options = DCM_ORDERLITTLEENDIAN;
  long differences = 0;
  char* maskFile = "";

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'g':
      options &= ~DCM_GROUPLENGTHMASK;
      options |= DCM_NOGROUPLENGTH;
      break;
    case 'm':
      argc--;
      argv++;
      maskFile = *argv;
      break;
    case 'o':
      verboseOutput = TRUE;
      break;
    case 't':
      options &= ~DCM_FILEFORMATMASK;
      options |= DCM_PART10FILE;
      break;

    case 'v':
      verboseOutput = TRUE;
      break;
    case 'z':
      options |= DCM_FORMATCONVERSION;
      break;
    default:
      break;
    }
  }

  if (argc != 2)
    usageerror();

  loadMaskFile(maskFile);

  ::THR_Init();

  ::printf("Master File: %s\n", *argv);
  cond = ::DCM_OpenFile(*argv, options, &obj1);
  if (cond != DCM_NORMAL && ((options & DCM_PART10FILE) == 0)) {
    //::COND_DumpConditions();
    (void) ::DCM_CloseObject(&obj1);
    (void) ::COND_PopCondition(TRUE);
    //::fprintf(stderr, "Could not open %s as expected.  Trying Part 10 format.\n", *argv);
    cond = ::DCM_OpenFile(*argv, options | DCM_PART10FILE, &obj1);
  }
  if (cond != DCM_NORMAL) {
    ::fprintf(stderr, "Could not open file as DCM or Part 10 file: %s\n", *argv);
    ::COND_DumpConditions();
    ::THR_Shutdown();
    ::exit(1);
  }

  argv++;
  ::printf("Comparing File: %s\n", *argv);
  cond = ::DCM_OpenFile(*argv, options, &obj2);
  if (cond != DCM_NORMAL && ((options & DCM_PART10FILE) == 0)) {
    ::COND_DumpConditions();
    (void) ::DCM_CloseObject(&obj2);
    (void) ::COND_PopCondition(TRUE);
    ::fprintf(stderr, "Could not open %s as expected.  Trying Part 10 format.\n", *argv);
    cond = ::DCM_OpenFile(*argv, options | DCM_PART10FILE, &obj2);
  }
  if (cond != DCM_NORMAL) {
    ::COND_DumpConditions();
    ::THR_Shutdown();
    ::exit(1);
  }

  CONTEXT_STRUCT context = { &differences, "", "" };

  ::DCM_CompareAttributes(&obj1, &obj2, compareCallback, &context);

  ::printf("Differences encountered: %5d\n\n", differences);

  (void) ::DCM_CloseObject(&obj1);
  (void) ::DCM_CloseObject(&obj2);

  ::THR_Shutdown();

  if (differences > 0)
    return 1;
  else
    return 0;
}

/* usageerror
**
** Purpose:
**	Print the usage string for this application and exit.
**
** Parameter Dictionary:
**	None
**
** Return Values:
**	None
**
** Algorithm:
**	Description of the algorithm (optional) and any other notes.
*/

static void
usageerror()
{
    char msg[] = "\
Usage: compare_dcm [-g] [-m maskfile] [-o] [-t] [-v] [-z] <master file> <test file> \n\
\n\
    -g        Remove group length elements\n\
    -m        Use a mask file to determine important attributes to compare\n\
    -o        Place output in verbose mode\n\
    -t        Part 10 file\n\
    -v        Place DCM facility in verbose mode\n\
    -z        Perform format conversion (verification) on data in files\n\
\n\
    <master file> <test file> \n";

    fprintf(stderr, msg);
    exit(1);
}







