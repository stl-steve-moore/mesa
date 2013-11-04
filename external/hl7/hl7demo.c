/* hl7demo.c
 *
 * Copyright (C) 1993 Igor Chernizer. Columbia University.
 * Columbia-Presbyterian Medical Center
 * Many additions and changes by Allen Rueter, MIR, Washington Univ.
 *******************************************************************
 *
 * Demonstration of HL7 Import/Export functions
 *
 * A. Builds ADT^A17 HL7 message - Swap Patients : msh-evn-{pid-pv1}
 *    
 *  1.  Start to create new structure
 *  2.  Insert and fill MSH
 *  3.  Insert and fill EVN
 *  4.  Insert and fill PV1
 *  5.  Insert and fill PID 
 *  6.  Try to build flat HL7 message
 *      Trap error
 *      Rebuild message correctly
 *  7.  Set current position on a first segment in the message
 *  8.  Find first occurence of PID
 *  9.  Print 2nd component from 5th field from current PID message
 *  10. Build HL7 message
 *  11. Traverse through message
 *  12. Free HL7 data structure
 *  13. Start to create new structure
 *  14. Encode HL7 message and put data in Data Structure
 *  15. Set up a read error (append PID)
 *  16. Try to decode wire and catch error
 *  17. Try to encode it and catch error message
 *********************************************************************
 *
 *
 */

#include <stdlib.h>
#include <stdio.h>
#ifndef VAX
#include <sys/types.h>
#else
#include <types.h>
#endif
#include <string.h>
/*#include "unistd.h"*/

#include "hl7_api.h"

static void PrtHL7Msg(char *, int);

main() {
  HL7MSG *pMsg=0;
  HL7MSG *pMsg2=0;
  HL7FLVR *pF,*pF22;
  SIZE Len;
  char *pSegName;			/* segment type                  */
  int iResult, f, nof;
  char *pFld,*pComp;
  char wire[10000];			/* buffer for HL7 message        */
  char eb[1000];			/* encode/decode buffer		*/
  char stdinJnk[89],*pC;
  FILE *dtmfd;
  
/* portablity things */
short int si;
int ii;
long int li;
float sf;
double df;
int *pI;

union {
  short int usi;
  char uc[2];
} u;
u.uc[0] = 1;
u.uc[1] = 0;

  printf("\n0.  portablity assumptions ");
  if (u.usi == 1) printf( "little endian machine.\n");
	   else   printf( "big endian machine.\n");

  printf("short int is %d bytes\n",sizeof(si));
  printf("      int is %d bytes\n",sizeof(ii));
  printf(" long int is %d bytes\n",sizeof(li));
  printf("   single is %d bytes\n",sizeof(sf));
  printf("   double is %d bytes\n",sizeof(df));
  printf("pointers are %d bytes\n",sizeof(pI));

  pF = HL7Init( "", ".v21");		/* read in and build tables */
  if ( pF == NULL) {
    fprintf( stderr, "HL7Init failed!\a\n");
    exit( 0);
  }
  printf("\n1.  Start to create new structure");
  fflush(stdout);
  pMsg = HL7Alloca( pF);

  printf("\n2.  Insert and fill MSH");  
  fflush(stdout);
  HL7InsSegm(pMsg, "MSH");

  /* fill out MSH */
  HL7PutFld(pMsg, "|", 1);
  HL7PutFld(pMsg, "^~\\+", 2);
  HL7PutFld(pMsg, "PM", 3);
  HL7PutFld(pMsg, "CIS", 4);
  HL7PutFld(pMsg, "19911030140014865", 7);
  HL7PutFld(pMsg, "ADT", 9);
  HL7PutComp(pMsg, "A17", 9);		/* add new component */
  HL7PutFld(pMsg, "14001U090", 10);
  HL7PutFld(pMsg, "P", 11);
  HL7PutFld(pMsg, "2.1", 12);


  printf("\n3.  Insert and fill EVN");
  fflush(stdout);
  HL7InsSegm(pMsg, "EVN");

  /* fill out EVN */
  HL7PutFld(pMsg, "A17", 1);
  HL7PutFld(pMsg, "19911030140014865", 2);
  HL7PutFld(pMsg, "003", 4);


  printf("\n4.  Insert and fill PV1");
  fflush(stdout);
  HL7InsSegm(pMsg, "PV1");

  /* fill out PV1 */
  HL7PutFld(pMsg,"1",  1);
  HL7PutFld(pMsg,"7777^AttendLst^Frst^M^^^MD", 7); /* check fix of ^^, not ^ */
  HL7PutFld(pMsg,"^Ref^^^^^MD", 8);	/* check fix of ^Ref.., not ^^Ref.. */
  HL7PutFld(pMsg,"9991^Cons^^^DR^^", 9);
  HL7PutRep(pMsg,"9992^Cons^^^^^MD", 9);
  HL7PutFld(pMsg,"10", 13);
  HL7PutFld(pMsg,"12", 32);
  HL7PutFld(pMsg,"13", 33);
  HL7PutFld(pMsg,"15", 47);
  HL7PutFld(pMsg,"16", 48);
  HL7PutFld(pMsg,"17", 49);
  HL7PutFld(pMsg,"13", 50);

  printf("\n5.  Insert and fill PID");
  fflush(stdout);
  HL7InsSegm(pMsg, "PID");

  /* fill out PID */ 
  HL7PutFld(pMsg, "1", 1);
  HL7PutFld(pMsg, "2596690", 3);
  HL7PutFld(pMsg, "379112", 4);
  HL7PutFld(pMsg, "MORALES^MARIANA", 5);
  HL7PutFld(pMsg, "19440704", 6);
  HL7PutFld(pMsg, "F", 7);
  HL7PutFld(pMsg, "U", 9);
  HL7PutFld(pMsg, "95 LUCUS & HUNT ^^St. Louis^MO^63118", 10);

  printf("\n6.  Catch error Building Wire ");
  fflush(stdout);
  if ((iResult = HL7WriteMsg(pMsg, wire, 10000, &Len)) == HL7_OK) {
	fprintf( stderr,"\n MISSED ERROR !\n press return to continue");
	gets( stdinJnk);
  } else {
	printf("\n trapped error, %s", HL7ErrTxt(pMsg, iResult));
  }
  HL7Free(pMsg);
  
  printf("\n rebuilding message (correctly).");
  pMsg = HL7Alloca( pF);

  HL7InsSegm(pMsg, "MSH");			  /* fill out MSH */
  HL7PutFld(pMsg, "|", 1);
  HL7PutFld(pMsg, "^~\\&", 2);
  HL7PutFld(pMsg, "PM", 3);
  HL7PutFld(pMsg, "CIS", 4);
  HL7PutFld(pMsg, "19911030140014865", 7);
  HL7PutFld(pMsg, "ADT", 9);
  HL7PutComp(pMsg, "A17", 9);		/* add new component */
  HL7PutFld(pMsg, "14001U090", 10);
  HL7PutFld(pMsg, "P", 11);
  HL7PutFld(pMsg, "2.1", 12);

  HL7InsSegm(pMsg, "EVN");			/* fill out EVN */
  HL7PutFld(pMsg, "A17", 1);
  if ((iResult=HL7ValidateFld( pMsg, 1)) != HL7_OK) {
    printf("\n Failed to validate field 1 of EVN \n press return to continue");
    gets (stdinJnk);
  }
  HL7PutFld(pMsg, "19911030140014865", 2);
  HL7PutFld(pMsg, "003", 4);

  HL7InsSegm(pMsg, "PID");			/* fill out PID */ 
  HL7PutFld(pMsg, "1", 1);
  HL7PutFld(pMsg, "2596690", 3);
  HL7PutFld(pMsg, "379112", 4);
  HL7PutFld(pMsg, "MORALES^MARIANA", 5);
  HL7PutFld(pMsg, "19440704", 6);
  HL7PutFld(pMsg, "F", 7);
  HL7PutFld(pMsg, "U", 9);
  HL7PutFld(pMsg, 
     HL7EncodeEsc( pMsg, "95 LUCUS & HUNT ^^St. Louis^MO^63118", eb, HL7SUBMSK)
	, 10);

  HL7InsSegm(pMsg, "PV1");			/* fill out PV1 */
  HL7PutFld(pMsg,"1",  1);
  HL7PutFld(pMsg,"7777^AttendLst^Frst^M^^^MD", 7);
  HL7PutFld(pMsg,"^Ref^^^^^MD", 8);
  HL7PutFld(pMsg,"9991^Cons^^^DR^^", 9);
  HL7PutRep(pMsg,"9992^Cons^^^^^MD", 9);
  if ((iResult=HL7ValidateFld( pMsg, 9)) != HL7_OK) {
    printf("\n Failed to validate field 9 of PV1 \n press return to continue");
    gets (stdinJnk);
  }
  HL7PutFld(pMsg,"10", 13);
  HL7PutFld(pMsg,"12", 32);
  HL7PutFld(pMsg,"13", 33);
  HL7PutFld(pMsg,"15", 47);
  HL7PutFld(pMsg,"16", 48);
  HL7PutFld(pMsg,"17", 49);
  HL7PutFld(pMsg,"13", 50);


  if ((iResult = HL7WriteMsg(pMsg, wire, 10000, &Len)) != HL7_OK) {
    printf("\n unexpected ERROR, %s \n press return to conitinue", 
						HL7ErrTxt(pMsg, iResult));
    gets( stdinJnk);
  }

  PrtHL7Msg(wire, strlen(wire));	/* print message       */
  
  /* 7.  Set current position on a first segment in the message */

  printf("\n7.  position to 1st Segment ");
  fflush(stdout);
  HL7FirstSegm(pMsg, &pSegName);		/* posit first segment */
  pFld = HL7GetFld( pMsg, 1);
  printf("\n The field seperator is %s,", pFld);
  pFld = HL7GetFld( pMsg, 2);
  printf(" other sperators are %s ", pFld);
  printf("\n Snd App %s",HL7GetFld( pMsg, 3));
  /* HL7PutFld(pMsg, "^~\\+", 2);		change seperators */
  printf("\n Msg Type %s, ", HL7GetFld( pMsg, 9));
  printf("event type %s", HL7GetComp( pMsg, 9, 1, 2));
  printf("\n8.  Find PID ");
  fflush(stdout);
  HL7FindSegm(pMsg, "PID");		/* find first PID      */

  printf("\n field #4 from PID - '%s'",HL7GetFld(pMsg, 4));
  printf("\n9. component #2 from field #5 from PID - '%s'",
	 HL7GetComp(pMsg, 5, 1, 2));
  printf("\n field #10 from PID - '%s'", HL7DecodeEsc(pMsg, HL7GetFld(pMsg, 10),
		eb, HL7SUBMSK));
  fflush(stdout);

  HL7FindSegm(pMsg, "PV1");		/* find first PV1      */
  printf("\n field 7 from PV1 should have 2 empty components:\n '%s'", 
			HL7GetFld(pMsg, 7));
  printf("\n field 8 from PV1 should have leading empty component:\n '%s' ", 
			HL7GetFld(pMsg, 8));
  HL7GetComp( pMsg, 8, 1, 5);

  printf("\n field 9 from PV1 should have two repititions:\n '%s' ",
			HL7GetFld(pMsg, 9));
  printf("\n field 13, component 2 from PV1 doesn't exist.");
	 HL7GetComp(pMsg, 13, 1, 2);

  /*  11. Traverse through message */
  printf("\n11.  Traverse message ");
  fflush(stdout);
  HL7FirstSegm(pMsg, &pSegName);		/* posit first segment */
  do {
    printf("\n message-'%s'", pSegName);
  } while (HL7NextSegm(pMsg, &pSegName)!= HL7_END_OF_STRUCT);
  
  if ((iResult = HL7WriteMsg(pMsg, wire, 10000, &Len)) != HL7_OK) {
    printf("\n unexpected ERROR, %s \n press return to conitinue", 
						HL7ErrTxt(pMsg, iResult));
    gets( stdinJnk);
  }

  PrtHL7Msg(wire, Len);	/* print message       */
  
  /*  12. Free HL7 data structure  */
  printf("\n12.  Free HL7 structure ");
  fflush(stdout);
  HL7Free(pMsg);
  
  /*  13. Start to create new structure */
  printf("\n13.  Start a new structure ");
  fflush(stdout);
  pMsg = HL7Alloca( pF);
  
  /*  14. Encode HL7 message and put data in Data Structure */
  printf("\n14.  Encode HL7 message from wire ");
  fflush(stdout);
  if ((iResult = HL7ReadMesg(pMsg, wire, Len)) != HL7_OK) {
	fprintf( stderr,"\n Unexpected error reading HL7 message! \n press return to continue");;
	gets( stdinJnk);
  }  
  
  pFld = HL7GetFld( pMsg, 1);
  printf("\n The field seperator is %s,", pFld);
  pFld = HL7GetFld( pMsg, 2);
  printf(" other sperators are %s ", pFld);

  HL7Free( pMsg);

  /*  15. Now set up a read error */
  printf("\n15.  Now set up a read error. ");
  fflush(stdout);
  strcat( wire, "PID||||||\r");
  pMsg = HL7Alloca( pF);

  /*  16. */
  printf("\n16.  Try to decode wire and catch error. ");
  fflush(stdout);
  
  if ((iResult = HL7ReadMesg(pMsg, wire, strlen(wire))) == HL7_OK) {
    printf("\n MISSED ERROR! \n press return to continue");
    gets( stdinJnk);
  }
  printf("\n17. Caught error, %s", HL7ErrTxt(pMsg, iResult));
  HL7Free(pMsg);

  printf("\n18. Build an ack, and reset a field");
  pMsg = HL7Alloca( pF);
  HL7InsSegm( pMsg, "MSH");

  /* fill out MSH */
  HL7PutFld(pMsg, "|", 1);
  HL7PutFld(pMsg, "^~\\+", 2);
  HL7PutFld(pMsg, "SndApp", 3);
  HL7PutFld(pMsg, "SndFac", 4);
  HL7PutFld(pMsg, "RcvApp", 5);
  HL7PutFld(pMsg, "RcvFac", 6);
  HL7PutFld(pMsg, "19951030140014865", 7);
  HL7PutFld(pMsg, "ACK", 9);
  HL7PutFld(pMsg, "14001U090", 10);
  HL7PutFld(pMsg, "P", 11);
  HL7PutFld(pMsg, "2.1", 12);

  HL7InsSegm( pMsg, "MSA");
  HL7PutFld(pMsg, "AA", 1);
  HL7PutFld(pMsg, "field2", 2);
  if ((iResult = HL7WriteMsg(pMsg, wire, 10000, &Len)) != HL7_OK) 
	printf("\n ERROR, FAILED TO build ACK! \n");

  PrtHL7Msg(wire, strlen(wire));	/* print message       */

  HL7FirstSegm( pMsg, &pSegName);	/* position to first segment */
  HL7NextSegm( pMsg, &pSegName);
  HL7PutFld(pMsg, HL7NULL, 2);		/* reset field */
  if ((iResult = HL7WriteMsg(pMsg, wire, 10000, &Len)) != HL7_OK) 
	printf("\n ERROR, FAILED TO build ACK! \n");

  PrtHL7Msg(wire, strlen(wire));	/* print message       */

  HL7Free( pMsg);
  
  printf("\n19. Encode a bunch of test messages from demotst.msgs\n");
  dtmfd = fopen( "demotst.msgs","r");
  if (dtmfd==0) { fprintf(stderr,"\nFailed to open demotst.msgs\n"); exit(0);}
  while( fgets( wire, 9999, dtmfd)) {
    pMsg = HL7Alloca( pF);
    while ( wire[ strlen(wire)-1] != 13) wire[ strlen(wire)-1] =0; /* trim */
    if (( iResult = HL7ReadMesg(pMsg, wire, strlen(wire))) == HL7_OK) {
      HL7FirstSegm( pMsg, &pSegName); printf(" %s ", pSegName);
      while (HL7NextSegm( pMsg, &pSegName)==HL7_OK) {
	printf(" %s ", pSegName);
	if (strcmp(pSegName, "OBR") == 0) 
		if ( (pC= HL7GetFld( pMsg, 1)) ) printf(":%s", pC);
      }	
      printf("\n");
    } else {
	printf("Failed on msg:%.7s %.60s\n", pMsg->cMsgType, wire);
	HL7fErrMsg( pMsg, stdout);
        printf( "\n");
    }
    HL7Free(pMsg);
  }
  close( dtmfd);

  printf("\n\n Now for a simple HL7 converter");
  pF22 = HL7Init( "", ".v22c236");	/* read in and build output tables */
  if ( pF22 == NULL) {
    fprintf( stderr, "HL7Init failed for v22!\a\n");
    exit(0);
  }

  printf("\n20. Convert a bunch of test messages from demotst.msgs\n");
  dtmfd = fopen( "demotst.msgs","r");
  if (dtmfd==0) { fprintf(stderr,"\nFailed to open demotst.msgs\n"); exit(0);}
  while( fgets( wire, 9999, dtmfd)) {
    pMsg = HL7Alloca( pF);
    while ( wire[ strlen(wire)-1] != 13) wire[ strlen(wire)-1] =0; /* trim */
    if (( iResult = HL7ReadMesg(pMsg, wire, strlen(wire))) == HL7_OK) {
      HL7FirstSegm( pMsg, &pSegName); printf(" %s ", pSegName);
      pMsg2 = HL7Alloca( pF22);
      HL7InsSegm( pMsg2, pSegName);		/* Seg to new flavor */
      nof = HL7GetNmbrOfFlds( pMsg);		/* How many fields are there? */
      for( f=1; f<=nof; f++) {
	pFld = HL7GetFld( pMsg, f);
	if (pFld != NULL) 			/* move only live ones */
		HL7PutFld( pMsg2, pFld, f);	
	if (f==9) {
	  strcpy( eb, pFld);
	  pComp = HL7GetComp( pMsg, f, 1, 2); /* special test ! */
	  if ( pComp != NULL) printf("msg group:%s  event %s\n", eb, pComp);
	}
      }
      while (HL7NextSegm( pMsg, &pSegName)==HL7_OK) {
	printf(" %s ", pSegName);
	HL7InsSegm( pMsg2, pSegName);
	nof = HL7GetNmbrOfFlds( pMsg);
	for( f=1; f<=nof; f++) {
	  pFld = HL7GetFld( pMsg, f);
	  if (pFld != NULL) HL7PutFld( pMsg2, pFld, f);
	}
      }	
      if ((iResult = HL7WriteMsg(pMsg2, wire, 10000, &Len)) != HL7_OK) 
	printf("\n ERROR, FAILED TO CONVERT! \n");
      HL7Free( pMsg2);
      printf("\n");
    } else printf("Failed on:%.7s %.60s\n", pMsg->cMsgType, wire);
    HL7Free(pMsg);
  }

  close(dtmfd);
  printf("\n");fflush(stdout);
  HL7Drop( pF22);
  HL7Drop( pF);
  exit(0);

/* now for some z seg and parse tests. */
  printf("\n21. Play around with some Z segs and strange parses \n");

  pF = HL7Init( "", ".v21z");		/* read in and build tables */
  if ( pF == NULL) {
    fprintf( stderr, "HL7Init failed!\a\n");
    if (pF) HL7Drop( pF);
    exit( 0);
  }
  dtmfd = fopen( "demoz.msgs","r");
  if (dtmfd==0) { fprintf( stderr, "\nFailed to open demoz.msgs\n"); exit(0);}
  while ( fgets( wire, 9999, dtmfd)) {
    pMsg = HL7Alloca( pF);
    while ( wire[ strlen(wire)-1] != 13) wire[ strlen(wire)-1] = 0; /* trim */
    if (( iResult = HL7ReadMesg( pMsg, wire, strlen(wire))) == HL7_OK) {
      HL7FirstSegm( pMsg, &pSegName); printf(" %s ", pSegName);
      while ( HL7NextSegm( pMsg, &pSegName) == HL7_OK) {
	printf( " %s ", pSegName);
      }
      printf("\n");
    } else {
	printf("Failed on msg:%.7s %.60s\n", pMsg->cMsgType, wire);
	HL7fErrMsg( pMsg, stdout);
        printf( "\n");
    }
    HL7Free(pMsg);
  }
  close( dtmfd);
  HL7Drop( pF);
}

static void PrtHL7Msg(char *string, int iStringLen)
{
   int i;
   printf("\n\n"); 
   fflush(stdout);
   for (i=0; (i <iStringLen) && (*(string+i) !='\0'); i++) {
     if (*(string+i) == HL7_SEG_SEP) {      /* segment separator */
          printf("\n");
	  fflush(stdout);
       } else {
          printf ("%c", *(string+i));
	  fflush(stdout);
	}
   }
   /*printf ("%c", cEndChar);*/
   fflush(stdout);
} 



