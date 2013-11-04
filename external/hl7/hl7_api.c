/* hl7_api.c
 * Functions for HL7ImEx.
 *
 * Copyright (C) 1993 Igor Chernizer. Columbia University.
 * Columbia-Presbyterian Medical Center.
 *
 * This file is part of HL7ImEx 
 * 
 * Use and copying of this software and preparation of derivative works
 * based upon this software are permitted.  However, any distribution of
 * this software or derivative works must include the above copyright
 * notice.
 *
 * This  software  is  made  available  AS IS ,  and  neither  the 
 * Columbia-Presbyterian Medical Center or the Columbia University make 
 * any warranty about the software, its performance or its conformity to
 * any specification.
 *
 * Modified by Allen Rueter, Mallinckrodt Institute of Radiology,
 * Washingtion University Medical Center. May 1994
 */


/* Change history
 *
 *$Log: hl7_api.c,v $
 *Revision 1.7  2004/12/14 05:08:36  smm
 *Change code to accept messages of type XXX^YYY^XXX_YYY or some variation
 *of that.
 *
 *Revision 1.6  2004/11/05 23:30:11  smm
 *Cosmetic change in one line to help me when I debug.
 *Split if/then over two lines.
 *
 *Revision 1.5  2001/08/06 18:45:47  smm
 *In the write to spool function, don't send the error message
 *to stderr.  Let a higher level function print the error message.
 *
 *Revision 1.4  2001/05/18 20:31:18  smm
 *Change some functions to take const char* inputs.
 *Makes other MESA methods able to call these functions
 *without resorting to tricks.
 *
 *Revision 1.3  2001/03/02 16:43:26  smm
 *Update HL7ValidateFld so that it does not blow up when it runs
 *across an empty field.
 *
 *Revision 1.2  2000/11/08 15:00:22  smm
 *Change the macro SIZE to HL7_SIZE to get around conflicts
 *with MSVC++ compiler/include files.
 *
 *Revision 1.1  1999/06/22 14:45:43  dfs
 *
 *I added the hl7_api files needed to make the MESA programs.
 *
 *FDS
 *
 * Revision 1.3  1993/03/26  02:56:55  cherniz
 * add BSD implementation of memchr, because AIX optimize
 * code too much :-)
 * HL7GetField -> HL7GetFld
 *
 * Revision 1.1  1993/03/01  22:01:16  cherniz
 * Initial revision
 * Revision 2    1994 may              Allen Rueter
 * Added hl7init, and new structures to allow reading in segment definitions
   and rules. Replaced hard coded rules, with recursive routines. Replaced 
   HL7xYYY constant with pointer/function HL7pYYY that returns a pointer to a 
   structure defining the Segment.
 * Revision 2    1994 jun              Allen Rueter
 * Remove component seperator from msgRules. Allow msgrule reuse. Parse 
   segDefs better.
 * Return a seg mismatch. Update component seperators correctly. calloc 
   replaces a few malloc s.
 * Revision 2    1994 jul              Allen Rueter
 * Fix empty 1st component problem, by reordering if statments. Use len of 
   data, not strlen when calling PoolToWire.
 * Revision 2    1994 aug              Allen Rueter
 * changed msgRule fscanf, some sample code for machines with poor malloc 
   algorithms.
 * Fix type cast problem for SCO unix. (per ?? )
 * Revision 2    1994 sep	       Allen Rueter
 * fix skip over encoding chars ( per Mark Maden)
 * clear nmbrFlds (per Al Stone) for MVS.
 * fix dropping of last seg in message rule building if no trailing delimeter.
 * Revision 2    1994 dec	       Allen Rueter
 * add routines to encode/decode delemiters \F\ \S\ \R\ \E\ \T\
 * fixed hl7getcomp,hl7getrep,hl7getsub for MSH (per Kerry K)
 * Revision 2	 1995 feb		Tom Leith
 * add routine HL7Locate Seg, to locate segment by Name (instead of ptr)
 * Revsion 2	 1995 mar		Allen Rueter
 * support more than one hl7 table, should be thread safe now.
 * replace all HL7pXXX pointers with segments name eg "MSH"
 * dropped routine HL7Locate Seg, use HL7FindSegm
 * Revison 2	 1995 jul		Allen Rueter, Ray Ontko
 * fix ref to null componnet,subcomp (Ray)
 * fix a deep nesting error.
 * report wire overflow, not parse error (hl7writemsg).
 * allow comments in segdefs (#,!,/) (started by Fred Smith)
 * HL7ReadMesg replaces HL7ReadMsg (need length of message).
 * reverse calloc args to prevent alignment problems on RISC machines.
 */

#ifndef lint
static char rcsid[] =
"$Id: hl7_api.c,v 1.7 2004/12/14 05:08:36 smm Exp $";
#endif

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>	/* isalnum */
#ifndef VAX
#include <sys/types.h>
#else
#include <types.h>
#endif

	/* start AIX string fix */
#ifdef AIX
#ifdef __STR__
#undef __STR__
#endif
#endif
	/* end AIX string fix */

#include <string.h>
/*#include <unistd.h>*/

#define API 1 
#include "hl7_api.h"

#ifdef min
#undef min
#endif
#define min(A,B)        ((A)<(B)? (A):(B))

				/* is needed by aix, not VMS, Ultrix, Sun */
#ifdef AIX
#undef memchr
#define memchr Memchr
/* implementation of memchar to make AIX happy */
/* Copyright (c) 1990 The Regents of the University of California.
 * All rights reserved.
 *
 * This code is derived from software contributed to Berkeley by
 * Chris Torek.
 */ 

void * Memchr(void *s, int c, size_t n)
+{
  if (n != 0) {
    register const unsigned char *p = s;
    
    do {
      if (*p++ == c)
	return ((void *)(p - 1));
    } while (--n != 0);
  }
  return (NULL);
}

#endif

#ifdef DEBUG
#  undef NDEBUG				/* turn assertion on               */
#  define DB  if(1)
#else
#  define NDEBUG			/* disable assert                  */
#  define DB  if(0)
#endif
#  define DB1  if(0)

#include <assert.h>

static int UnmarshallSeg(HL7MSG *, HL7SegRule *, HL7_SIZE *);
static int UnmarshallSep(HL7MSG *, const char *);
static int UnmarshallRep(HL7MSG *, char *);
static int UnmarshallComp(HL7MSG *, char *);
static int UnmarshallSub(HL7MSG *, char *);
static int MarshallSeg (HL7MSG *, HL7SegRule *);
static int HL7Parse (HL7MSG *);
static int AppendToBuffer(HL7MSG *, char *);
static void MsgType2Ecode (HL7MSG *); 
static int PoolToWire(HL7MSG *, char *, HL7_SIZE);
				/* resolve segment name to ptr to rule/desc. */

HL7SegRule *pSegRuleFind( HL7MSG *pMsg, const char *segNm)
{				/* resolve a segment name ("MSH") to
					a ptr to rule   By Allen Rueter	*/
  HL7SegRule *pSR = pMsg->pFlvr->p1SegR;
  while ( strncmp( pSR->azNam, segNm, HL7_SEG_NAME_LEN) !=0) {
    pSR = pSR->nxt;
    if (pSR==0) {
      fprintf( stderr, "pSegRuleFind couldn't find %s\n",segNm);
      return(NULL);
    }
  }
  return pSR;
}

typedef struct _InitCntxt {		/* a parameter block to pass around */
  MSGrule *pCurRule;			/* stuff to HL7Init routines */
  MSGterm *pCurTerm;
  HL7FLVR *pFlvr;
  char *pocs;
  char ocstack[30];
} InitCntxt;


void HL7savLet( char *seg, int *segi, int c) {	/* by Allen Rueter	*/
  *(seg+(*segi)++) = c;			/* save letter, bump index */
  *(seg+*segi) = 0;			/* keep string terminated */
}


void HL7savSeg( char *seg, int *segNamI, InitCntxt *ic)
 {						/* Save a Segment def.
						   by Allen Rueter */
  MSGterm *pTmpTerm;
  HL7SegRule *pSR;
  DB printf("%s ", seg); 
  pTmpTerm = (MSGterm *)malloc( sizeof( MSGterm));
  pTmpTerm->typ = 0;			/* set type to seg (not []{}()<>) */

  pSR = ic->pFlvr->p1SegR;
  while ( strncmp( pSR->azNam, seg, HL7_SEG_NAME_LEN) !=0) {
    pSR = pSR->nxt;
    if (pSR==0) {
      fprintf( stderr, "HL7Init() SavSeg() couldn't find %s\n",seg);
      return ;
    }
  }

  pTmpTerm->pSegR = pSR;	/* point to type of segment	*/

  pTmpTerm->nxt = 0;			/* current end of rule		*/
  if ( ic->pCurRule->p1term == 0)	/* 1st rule?			*/
	ic->pCurRule->p1term = pTmpTerm; /* save start up rule list	*/
    else ic->pCurTerm->nxt = pTmpTerm;	/* add to end of rule list	*/
  ic->pCurTerm = pTmpTerm;
  *segNamI = 0;
}
   
void HL7savOpn( char opn, InitCntxt *ic) {	/* Save starting delem [{<(
					   By Allen Rueter	*/
  MSGterm *pTmpTerm;
  DB printf("%c", opn); 
  pTmpTerm = (MSGterm *)malloc( sizeof( MSGterm));
  pTmpTerm->typ = opn;
  pTmpTerm->pSegR = 0;
  pTmpTerm->nxt = 0;
  if ( ic->pCurRule->p1term == 0) ic->pCurRule->p1term = pTmpTerm;
    else ic->pCurTerm->nxt = pTmpTerm;
  ic->pCurTerm = pTmpTerm;
  *++(ic->pocs) = opn;			/* push open [{<( on to stack */
}

void HL7savCls( char cls, InitCntxt *ic) {	/* Save closing delem. ]}>)
					   By Allen Rueter	*/
  MSGterm *pTmpTerm; 
  pTmpTerm = (MSGterm *)malloc( sizeof( MSGterm));
  pTmpTerm->typ = cls;
  pTmpTerm->pSegR = 0;
  pTmpTerm->nxt = 0;
  if (ic->pCurRule->p1term == 0) ic->pCurRule->p1term = pTmpTerm;
    else ic->pCurTerm->nxt = pTmpTerm;
  ic->pCurTerm = pTmpTerm;
  DB printf( "%c", cls);
  if ( *ic->pocs == '{' && cls == '}') { ic->pocs--; return; }
  if ( *ic->pocs == '[' && cls == ']') { ic->pocs--; return; }
  if ( *ic->pocs == '<' && cls == '>') { ic->pocs--; return; }
  if ( *ic->pocs == '(' && cls == ')') { ic->pocs--; return; }
  fprintf( stderr, "HL7savCls ERROR %c doesn't match %c\n",*ic->pocs, cls);
  exit(-1);
}

HL7FLVR *HL7Init ( char *tblPath, char *tblVrsn )
{					/* read in parsing table(s) */
/* This function reads in two files, segDefs and msgRules. The tblPath arg.
   is a prefix to the filenames and tblVrsn is a suffix.
   side effects: files are opened and closed, memory is allocated.
   returns pointer to HL7FLVR.
   By Allen Rueter							*/

    FILE *stfd;				/* segment types file descriptor */
    char tmp[510], *pC;
    char *segDefs="segDefs";
    char *msgRules="msgRules", evnt[10], cln[2], rule[510], eol[2], c;
    char segNam[10];
    int sni;
    char filename[256];
    InitCntxt iC;
    char *opn = "[{<(";			/* delemiters */
    char *cls = "]}>)";
    char *wht = " ,\t";
    int i, state;
    char s;
    char segTypes[256], typ[10],ro[10],nr[20];
    int  sto=0, fldLen, n =0;
    HL7SegRule *pSegR,*pCurSegR;
    HL7FldRule *pFldR,*pCurFldR;
    HL7FLVR *pF;
    FILE *mrfd;				/* message rules file descriptor */
    MSGterm *pCurTerm, *pTmpTerm;
    MSGrule *pTmpRule, *pOldRule;

    strcpy( filename, tblPath);		/* build file name to open */
    strcat( filename, segDefs);
    strcat( filename, tblVrsn);
    stfd = fopen( filename,"r");
    if (stfd==0) { 
	fprintf( stderr, "HL7Init FAILED TO OPEN: %s\n",filename); 
	return (NULL);
    }
					/* set up a flavor */
    pF = (HL7FLVR *)malloc( sizeof( HL7FLVR));
    iC.pFlvr = pF;
    pF->p1Rule = 0;
					/* set up 1st (empty) segment rule */
    pCurSegR = (HL7SegRule *)malloc( sizeof( HL7SegRule));
    pF->p1SegR = pCurSegR;
    pCurSegR->azNam[0] = 0;
    pCurSegR->p1fld = 0;
    pCurSegR->nmbrFlds = 0;

    while ( n>=0) {		/* get field length, type, req/opt, #repeats */
 nxtSln:
      while ( (n=fscanf( stfd, "%d%s%s%s", &fldLen, typ, ro, nr)) > 0) {
        fgets( tmp, 509, stfd);		/* suck up comments */
        pFldR = (HL7FldRule *)malloc( sizeof( HL7FldRule));
				/* tack field rule on to seg or prev. field */
	if (pCurSegR->p1fld==0) pCurSegR->p1fld = pFldR;
	  else pCurFldR->nxt = pFldR;
	pCurFldR = pFldR;
	pCurFldR->nxt = 0;
	pCurSegR->nmbrFlds += 1;
	pFldR->len = fldLen;
	
	pC = strstr( sFldTypes, typ);	/* decode field type */
	if (pC==0) pFldR->typ = 0;
	  else pFldR->typ = 1+( pC-sFldTypes)/3;
					/* decode required / optional */
	if (ro[0]=='R' && ro[1]=='E') pFldR->reqOpt = 1;
        else if (ro[0]=='O' && ro[1]=='P') pFldR->reqOpt = 0;
	else pFldR->reqOpt = -1;
					/* decode repeat */
	if (nr[0]=='N' && nr[1]=='O') {
	  if (nr[3]=='M') pFldR->nmbrRep = 100;	/* NO_MAX (yeah, right) */
	  if (nr[3]=='R') pFldR->nmbrRep = 0;	/* NO_RPT	*/
	}
	else if (isdigit(nr[0])) pFldR->nmbrRep = atoi(nr);
	else { fprintf(stderr, "HL7Init BAD repeat specified %s\n", nr); 
		return (NULL);
	}

	DB printf("read: %d %d %s %s %s\n",n,fldLen,typ,ro,nr);
      }
      n = fscanf( stfd, "%s", &segTypes[sto]);
      if ( n>0 && (segTypes[sto]=='#' 	/* unix comment */
		|| segTypes[sto]=='/'	/* c/c++ comment */
		|| segTypes[sto]=='!')) { /* VMS comment */
	fgets( tmp, 509, stfd);		/* suck up rest of comment */
	goto nxtSln;			/* as macro pgmmr, i can't resit ;-) */
      }
      if ( n>=0) { 
	DB printf("segtype: %s\n", &segTypes[sto]); 
        memcpy( pCurSegR->azNam, &segTypes[sto], 4);
				/* save where MSH is defined */
	if (strcmp( "MSH",pCurSegR->azNam)==0) {
	  pF->HL7pMSH = pCurSegR;
	} else if(strcmp( "MSA",pCurSegR->azNam)==0) {
	  pF->HL7pMSA = pCurSegR;
	} else if(strcmp( "BHS",pCurSegR->azNam)==0) {
	 /* pF->HL7pBHS = pCurSegR; */
	} else if(strcmp( "FHS",pCurSegR->azNam)==0) {
	 /* pF->HL7pFHS = pCurSegR; */
	} 
        sto+=4;
	pSegR = (HL7SegRule *)malloc( sizeof( HL7SegRule));
	pCurSegR->nxt = pSegR;
	pCurSegR = pSegR;
	pCurSegR->azNam[0] = 0;
	pCurSegR->p1fld = 0;
	pCurSegR->nmbrFlds = 0;
      }
    }
    fclose( stfd);
	/* build a dummy Z seg in last seg def. */
    pCurSegR->nxt = 0;
    pF->HL7pZzz = pCurSegR;
    strcpy( pCurSegR->azNam, "Z**");
    pFldR = (HL7FldRule *)malloc( sizeof( HL7FldRule));
    pCurSegR->p1fld = pFldR;
    pCurFldR = pFldR;
    pFldR->nxt = 0;
    pFldR->len = fldLen;
    pFldR->typ = 1;
    pFldR->reqOpt = 0;
    pFldR->nmbrRep = 99;
    pCurSegR->nmbrFlds = 1;
    for ( i=1; i <50; i++) {
      pFldR = (HL7FldRule *)malloc( sizeof( HL7FldRule));
      pCurFldR->nxt = pFldR;
      pFldR->nxt = 0;
      pFldR->len = fldLen;
      pFldR->typ = 1;
      pFldR->reqOpt = 0;
      pFldR->nmbrRep = 99;
      pCurSegR->nmbrFlds += 1;
      pCurFldR = pFldR;
    }
	
    pCurSegR = pF->p1SegR;
    DB { printf("Segs:");
      /*while ( pCurSegR->azNam[0]!=0) {*/
      while ( pCurSegR!=0) {
	printf("%s ", pCurSegR->azNam);
	pCurSegR = pCurSegR->nxt;
      }
      printf("\n"); 
    }

				    /* read in Rules */
    strcpy( filename, tblPath);
    strcat( filename, msgRules);
    strcat( filename, tblVrsn);
    mrfd = fopen( filename,"r");
    if (mrfd==0) { 
	fprintf(stderr,"HL7Init FAILED TO OPEN: %s\n",filename); 
        return (NULL);
    }

    while ( !feof(mrfd) && !ferror(mrfd)) {
 nxtRln:
      evnt[0],cln[0],rule[0],eol[0] =0;
      s = fscanf( mrfd, "%[ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789]%[:;]%[^\n]%c", 
			evnt, 					cln, rule, eol);
      DB printf("\nevnt=%s rule=%s %d", evnt, rule,s);
      if ( s == 2 && evnt[0]==0 && cln[0]==0 ) {
	if ( rule[0]=='#' || rule[0]=='!' || rule[0]=='/') {
	  continue; 	/* re iterate while loop */
	}
      }
      if ( strlen(evnt) < (size_t)3 || strlen(rule) < (size_t)3) {
	fprintf( stderr,
	       "HL7Init msgRule ERROR will ignore EVNT=%s RULE=%s fscanf=%d\n",
				evnt, rule, s); 
	continue;
      }
      state=1;
      iC.pocs = &iC.ocstack[0];		/* setup stack to match open close */
      pTmpRule = (MSGrule *)malloc( sizeof( MSGrule));
      if (pF->p1Rule == 0) pF->p1Rule = iC.pCurRule = pTmpRule;	/* very 1st ? */
        else iC.pCurRule->nxt = pTmpRule;
      iC.pCurRule = pTmpRule;
      strcpy( iC.pCurRule->evnt, evnt);
      iC.pCurRule->p1term = 0;
      iC.pCurRule->nxt = 0;
      iC.pCurTerm = 0;
      if (cln[0] == ';') {			/* same as previous rule? */
	pOldRule = pF->p1Rule;
	while (strcmp( pOldRule->evnt, rule)!=0) {
	  pOldRule = pOldRule->nxt;
	  if (pOldRule==0) {
	    fprintf( stderr, "HL7Init Rule not found for %.7s\n", rule);
	    return ( NULL);
	  }
	}
foundOldRule:
	iC.pCurRule->p1term = pOldRule->p1term;
	iC.pCurRule->alias = 1;
      } else {
newRule:
        sni = 0; segNam[3]=0;
        for ( i=0; rule[i]!=0;i++) {
          s = (char)rule[i];
	  if (state==1) {				/* building Seg */
	      if ( isalnum(s) ) HL7savLet(segNam, &sni, s) ; 
	      else if ( strchr( opn,s)) { 
			HL7savSeg(segNam,&sni,&iC); HL7savOpn(s,&iC); state=2;}
	      else if ( strchr( cls,s)) { 
			HL7savSeg(segNam,&sni,&iC);HL7savCls(s,&iC); state=3;}
	      else if ( strchr( wht,s)) { 
			HL7savSeg(segNam,&sni,&iC); state=4;}
	      else { 
		fprintf( stderr, "HL7Init Bad char %c (%d)\n%s\n", s, s, rule);
		return (NULL);
		}
	  } else if (state==2) {			/* just got [{<( */
	      if ( isalnum(s) ) { HL7savLet(segNam, &sni, s) ; state=1; }
	      else if ( strchr( opn,s)) { HL7savOpn(s,&iC); state=2;}
	      else if ( strchr( cls,s)) { 
		fprintf(stderr,"HL7Init ERROR messing seg\n"); 
		return(NULL);
		}
	      else if ( strchr( wht,s)) state=4;
	      else { 
		fprintf( stderr, "HL7Init Bad char %c (%d)\n%s\n", s, s,rule);
		return(NULL);}
	  } else if (state==3) {			/* just got ]}>) */
	      if ( isalnum(s) ) { HL7savLet(segNam, &sni, s) ; state=1; }
	      else if ( strchr( opn,s)) { HL7savOpn(s,&iC); state=2;}
	      else if ( strchr( cls,s)) { HL7savCls(s,&iC); state=3;}
	      else if ( strchr( wht,s)) state=4;
	      else { 
		fprintf( stderr, "HL7Init Bad char %c (%d)\n%s\n", s, s,rule);
		return(NULL);
		}
	  } else if (state==4) {			/* just got white space */
	      if ( isalnum(s) ) { HL7savLet(segNam, &sni, s) ; state=1; }
	      else if ( strchr( opn,s)) { HL7savOpn(s,&iC); state=2;}
	      else if ( strchr( cls,s)) { HL7savCls(s,&iC); state=3;}
	      else if ( strchr( wht,s)) state=4;
	      else { 
		fprintf(stderr,"HL7Init Bad char %c (%d)\n%s\n", s, s,rule);
		return(NULL);
		}
	  } else { fprintf(stderr, "HL7Init Ugly state=%d\n",state); 
		return(NULL);
	  }
        }
        if ( iC.pocs != &iC.ocstack[0]) {
	  fprintf( stderr, "HL7Init unmatched paren. %c in %s\n", *iC.pocs,evnt);
	  return(NULL);
        }
	if ( state == 1) {		/* no trailing delimeter */
	  HL7savSeg( segNam, &sni,&iC);
	  state = 4;
	}
	iC.pCurRule->alias = 0;
      }
    }
    fclose( mrfd);
    return (pF);
}

HL7MSG * HL7Alloca( HL7FLVR *pF)
{
  HL7MSG    *pMsg;		        /* Allocate initial structure,     
					   and initialize it.              */
  DB {
    printf("\n Create message handle");
    fflush(stdout);
  }

  if ( pF == NULL) {
    fprintf( stderr, "HL7Alloc:Bad HL7 flavor pointer\n");
	return (NULL);	/* forgot to init? */
  }

  if ((pMsg = (HL7MSG *) calloc( 1, sizeof(HL7MSG))) == NULL) {
    fprintf( stderr, "HL7Alloc:No Memory?\n");
    return(NULL);        		/* no available memory             */
  }

  /* clean it up */
  pMsg->pFlvr = pF;
  pMsg->FldSep      = HL7FLDSEP;
  pMsg->CmpSep      = HL7CMPSEP;
  pMsg->RepSep      = HL7REPSEP;
  pMsg->EscSep      = HL7ESCSEP;
  pMsg->SubSep      = HL7SUBSEP;
  
  return(pMsg);		   	         /* pointer to handle               */
}

/* Sample code for those malloc's with poor heap management */
/*
static *pHL7freeRepL=NULL;		/-* put in hl7_api.h *-/
HL7REP *HL7allocRep() {			/-* reuse HL7REP structures *-/
  HL7REP *pRep;
  if (pHL7freeRepL==NULL) return (HL7REP *)malloc( sizeof( HL7REP));
  pRep = pHL7freeRepL;
  pHL7freeRepL = pRep->pRepNext;
  return pRep;  
}
void HL7freeRep( HL7REP *pRep) {	/-* save HL7REP struct for recycling *-/
  pRep->pRepNext = pHL7freeRepL;
  pHL7freeRepL = pRep;
}

replace
      if ((pRep = (HL7REP *) malloc(sizeof(HL7REP))) == 0)
with 
      if ( (pRep = HL7allocRep()) == NULL) 
and 
	    free(pRepT);			/-* free current repetition  *-/
with
	    HL7freeRep(pRepT);		/-* free current repetition  *-/

the same can be done for HL7COMP and HL7SUBCOMP

*/

int HL7InsSegm(HL7MSG *pMsg, const char *pInsSeg)
{
  HL7SEG *pL;			  /* insert new list item into structure */
  HL7SegRule *pInsSegR;
  if ( pMsg == NULL) return( HL7_NULL_ARG);
  pInsSegR = pSegRuleFind( pMsg, pInsSeg);
  if ( pInsSegR == NULL) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Null Argument.");
    return (HL7_NULL_ARG);
  }
  DB {
    printf("\n Insert new segment %s", pInsSegR->azNam);
    fflush(stdout);
  }
				/* alloc space for new seg		*/
  if (( pL = (HL7SEG *) calloc ( 1, sizeof(HL7SEG))) == 0) 
    return (HL7_NO_MEMORY);

  /* set list link     */
  if (pMsg->pCurrSeg == 0) {	        /* first segment-node               */
    if (pMsg->pSegList != 0) {
      sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
      sprintf( pMsg->ErrorMessage, "Internal error, no current seg.");
      return(HL7_NO_CURRENT_SEG);
    }
    pMsg->pSegList = pL;         	/* keep list head                   */
    pL->pNextSeg = 0;		        /* set list terminator              */
  } else {
    pL->pNextSeg = pMsg->pCurrSeg->pNextSeg;		       
    pMsg->pCurrSeg->pNextSeg = pL;	/* set link                         */
  }
  pMsg->pCurrSeg = pL;
  pMsg->pCurrSeg->pSegRul = pInsSegR;             /* put seg type in new node     */

    				/* Change current pointer to new one       */
  return (HL7_OK);
}


int HL7WriteMsg(HL7MSG *pMsg, char *pzWire , HL7_SIZE MaxWireLen, 
		HL7_SIZE *pWireLen)
{
  int i;				/* convert structure to wire	*/

  pMsg->fDirection = HL7_STRUCT_TO_WIRE;         /* global direction        */
  pMsg->pWire = pzWire;
  pMsg->pWireCursor = pzWire;                    /* global wire ptr, space  */

  pMsg->iCurrFldI0b=0;				/* iCurrFldI0b is zero based
						   not 1 like the segdefs   */

  if ((pMsg->pCurrSeg = pMsg->pSegList) == 0) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "No segments inserted.");
    return(HL7_EMPTY_STRUCT);
  }
  pMsg->MaxWireLen = MaxWireLen;                 /* max length of wire      */
  pMsg->WireLen = 0;			         /* set  wire len var       */

  if ((i = HL7Parse (pMsg)) != HL7_OK)
    return (i); /* do the parse          */
  
  *pWireLen = pMsg->WireLen;;
  return (HL7_OK);
}

int HL7Eat(HL7MSG *pMsg, HL7SegRule *pSegR)

{
  int i;
  HL7_SIZE SegLen = 0;
  HL7SEG *pSeg = 0;
  HL7SEG *pPrevSeg = pMsg->pCurrSeg;	/* in case Eat fails, which happens
					when parsing nested []{}<>	*/
    
  switch (pMsg->fDirection) {
  case HL7_WIRE_TO_STRUCT:
    
    DB {
      printf("\n Allocate new segment - %s", pSegR->azNam);
      fflush(stdout);
    }
					/* allocate next segment entry   */
    if ((pSeg = (HL7SEG *) calloc ( 1, sizeof(HL7SEG))) == 0) 
      return (HL7_NO_MEMORY);

    if (pMsg->pSegList == 0) 		/* this is first segment         */
					/* should be MSH                 */
					/* or FHS			 */
      pMsg->pSegList = pSeg;		/* init segment list             */
    else 				/* append to segment list        */
      pMsg->pCurrSeg->pNextSeg = pSeg;	/* point from prev to new        */
    
    pMsg->pCurrSeg = pSeg;		/* make it current segment       */
    pMsg->pCurrSeg->pNextSeg = 0;	/* null terminator for last entry*/

    /* get segment name from table   */
    pMsg->pCurrSeg->pSegRul = pSegR; 
    
 reEat:		/* undefined Z segs evaporate */
    /* FLDAMT = 0 init number of fields         */
    pMsg->pCurrRep = 0;
    pMsg->pCurrCom=0;
    pMsg->pCurrSub=0;
    
    if ((i = UnmarshallSeg (pMsg, pSegR, &SegLen)) != HL7_OK) {
  /*    if (i != HL7_ZZZ) { */
        free(pSeg);
        if (pPrevSeg==0) pMsg->pSegList=0;
        else
          pPrevSeg->pNextSeg = 0;
        pMsg->pCurrSeg = pPrevSeg;
        return (i);
  /*    }
      else {
        pMsg->pWireCursor += SegLen; */ /* Move wire cursor forward */
  /*	goto reEat;	*/	/* an unknown Z segment, skip on by */
  /*    } */
    }
    pMsg->pWireCursor += SegLen; /* Move wire cursor forward */
    break;
    
  case HL7_STRUCT_TO_WIRE:
    
    DB {
      printf("\nFrom struct to wire segment -'%s'",pSegR->azNam);
      fflush(stdout);
    }    
    
    if (pSegR != pMsg->pFlvr->HL7pMSH
	/* && pSegR != pMsg->pFlvr->HL7pFHS
	   && pSegR != pMsg->pFlvr->HL7pBHS	*/
					) {
      if ((pSeg = pMsg->pCurrSeg->pNextSeg) == 0) {
	sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
	sprintf( pMsg->ErrorMessage, 
		"Unexpected End Of Segment List, after %.20s.",
		      		pMsg->pCurrSeg->pSegRul);
	return (HL7_MSG_INCOMPLETE);
      }
      if ( pMsg->pCurrSeg->pNextSeg->pSegRul != pSegR) {
	sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
	sprintf( pMsg->ErrorMessage, 
		"HL7Eat Seg out of order, found %.5s, expecting %.5s",
		      		pMsg->pCurrSeg->pNextSeg->pSegRul, pSegR);
	fprintf( stderr, "\n %s\n", pMsg->ErrorMessage);
	return HL7_SEG_OUTOF_ORDER;
      }
      pMsg->pCurrSeg = pSeg;
    }
    if ((i = MarshallSeg (pMsg, pSegR)) != HL7_OK)
      return (i);
    /* return (HL7_OK); */
    break;
  default:
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Internal error, bad direction.");
    return (HL7_BAD_DIRECTION);
    break;
  }
  return(HL7_OK);
}

static int UnmarshallSeg (HL7MSG *pMsg, HL7SegRule *pSegRule, HL7_SIZE *pSegLen)
{
				/* break wire up into structure		*/
				/* segments are made up of fields	*/
  int fEOWire;				/* TRUE if EOF or End of Seg occur*/
  int fFldEnd;				/* TRUE if num of fiels = max     */

  HL7_SIZE  i;    
  HL7_SIZE  FldLen; 

  char *pc, *pcT;
  char aDelims[3];
  char msgtype[8];
  
  HL7SegRule zSegR;
  char zsegnam[4];

  int rs = HL7_OK;			/* normal return */
  pcT = pMsg->pWireCursor;
  *pSegLen = 0;

  if (strncmp(pcT, pSegRule->azNam, HL7_SEG_NAME_LEN) != 0) {
 /*   if (*pcT != 'Z') { */
      sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
      sprintf( pMsg->ErrorMessage, "Bad segment name %4.4s", pcT);
      return(HL7_BAD_SEG_NAME);
 /*   }
    else { */
      /* is it a known or unknown Z seg? */
 /*     memcpy( zsegnam, pcT, 3); zsegnam[3]=0;
      if ( pSegRuleFind( pMsg, zsegnam) != NULL ) return( HL7_BAD_SEG_NAME);
      pSegRule = pMsg->pFlvr->HL7pZzz;
      rs = HL7_ZZZ;
    } */
  }

  pcT += HL7_SEG_NAME_LEN;		/* bump curor over seg name */
  
  if (pSegRule == pMsg->pFlvr->HL7pMSH	/* MSH? */
   /* || pSegRule == pMsg->pFlvr->HL7pFHS
      || pSegRule == pMsg->pFlvr->HL7pBHS */
					) {
    pMsg->FldSep = *(pcT);		/* yes, pick up the encode chars */
    pMsg->CmpSep = *(pcT+1);			
    pMsg->RepSep = *(pcT+2);	
    pMsg->EscSep = *(pcT+3);	
    pMsg->SubSep = *(pcT+4); 	
  } else
    if (*pcT != pMsg->FldSep) {
      sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
      sprintf( pMsg->ErrorMessage, "Bad Field Seperator %4.4s", pcT-HL7_SEG_NAME_LEN);
      return(HL7_BAD_FLD_SEP);
    }  

  aDelims[0] = pMsg->FldSep;
  aDelims[1] = HL7_SEG_SEP;
  aDelims[2] = '\0'; 
    
  pcT++;
  pMsg->pWireCursor = pcT;
  fEOWire = FALSE;
  fFldEnd = FALSE;
  pMsg->iCurrFldI0b = 0;
  (pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = 0;
  
  if (pSegRule == pMsg->pFlvr->HL7pMSH
   /* || pSegRule == pMsg->pFlvr->HL7pBHS
      || pSegRule == pMsg->pFlvr->HL7pFHS */
					) { 
    pMsg->iCurrFldI0b++;	                /* MSH fix up 		*/
    if ((i = UnmarshallSep(pMsg, pMsg->pWireCursor)) != HL7_OK) /* first MSH field  */
      return (i);		                      
    pcT = pcT+5;
    pMsg->pWireCursor = pcT;
    pMsg->iCurrFldI0b++;	                /* change field numb to next  */
  }

  do { 
#if 0
    int idx1;
    char t1[100];
    strncpy(t1, pcT, 75);
    t1[75] = '\0';
    fprintf(stderr, "%x %x ", aDelims[0], aDelims[1]);
    for (idx1 = 0; idx1 < 60 && t1[idx1] != '\0'; idx1++) {
	if (isprint(t1[idx1])) {
	    fputc(t1[idx1], stderr);
	} else {
	    fputc('.', stderr);
	}
    }
    fprintf(stderr, "\n");
#endif

    /* till numbers of fields exceed over max or EndOfWire */
    if ((pc = strpbrk(pcT,aDelims)) == NULL) {
      sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
      sprintf( pMsg->ErrorMessage, "To many fields in Segment %.5s", pSegRule);
      return(HL7_SEG_TOO_LONG);		/* each segment should have  */
    }
    /* SEG_SEP as teminator      */

    (pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = 0;	/* init ptr to curent field    */
					/* value can be changed inside */
					/* UnmarshallRep */
    pMsg->pCurrCom=0;
    pMsg->pCurrSub=0;

    if (pSegRule != pMsg->pFlvr->HL7pMSH
    /* BHS
       FHS */
					)
      pMsg->pCurrRep = 0;
    if ((FldLen = (pc - pcT)) != 0) {    /* field is empty   */ 
      if ((i = UnmarshallRep(pMsg, pc)) != HL7_OK) return (i);
      if ( (pSegRule == pMsg->pFlvr->HL7pMSH) && (pMsg->iCurrFldI0b == 9-1)) {
	i = min(HL7_MSGTYPE_LEN,FldLen);	/* pick up & save ADT^A01 */
	strncpy(pMsg->cMsgType, pcT, i);
	pMsg->cMsgType[i]='\0';
	MsgType2Ecode( pMsg);      	
      }
    }
    if (*pc == HL7_SEG_SEP)
      fEOWire = TRUE;			/* end of segment            */
    else if (pMsg->iCurrFldI0b == pSegRule->nmbrFlds)
      fFldEnd = TRUE;		        /* CURRFLD == max              */
    else {
      pcT = pc +1;			/* move forward to next field*/
      pMsg->pWireCursor = pcT;
      pMsg->iCurrFldI0b++;			/* next field                */
    }
  } while (!fEOWire && !fFldEnd);
  
  /* if actual amount af fields more than max - ignore rest	     */
  if (fFldEnd) 	
    if ((pc = strchr(pcT, HL7_SEG_SEP)) == 0) 
      return(HL7_TOO_MANY_FIELDS);
  pMsg->pCurrSeg->NumFld = pMsg->iCurrFldI0b +1;
  *pSegLen = pc - pMsg->pWireCursor + 1;
  return ( rs);				/* HL7_OK or HL7_ZZZ */
}

static int UnmarshallRep(HL7MSG *pMsg, char *pRight) {
  HL7REP *pRep;
  char *pLeft;				/* first char in repetition  */
  char *pL, *pR;                        /* float left and right bounds*/
  char *pT;
  int i;
  
  pLeft = pMsg->pWireCursor;
  pL = pLeft;

  do { /* until repetition scanning is over */
    pMsg->pCurrCom=0;
    pMsg->pCurrSub=0;
    if ((pT = memchr(pL, pMsg->RepSep, (HL7_SIZE)(pRight-pL))) != NULL) 
      pR = pT;				/* set new right bound */
    else
      pR = pRight;      
    if ((pR - pL) != 0) {		/* non-empty rep */
      DB {
	printf("\n allocate new repetition ");
	fflush(stdout);
      }
      if ((pRep = (HL7REP *) malloc(sizeof(HL7REP))) == 0)
	return (HL7_NO_MEMORY);

      if ((pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] == 0) { /* first occur */
	(pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = pRep;
	pRep->RepNum = 1;
      } else {				/* last occur */
	pRep->RepNum = pMsg->pCurrRep->RepNum + 1; /* incr rep # */
	pMsg->pCurrRep->pRepNext = pRep; /* append to list     */
      }	
      pMsg->pCurrRep = pRep;		        /* make it current rep */
      pRep->pRepNext = 0;	        /* put end-of-list */
      pRep->CompNum = 0;
      pRep->pComp = 0;
      pMsg->pWireCursor = pL;			/* cursor points to left bound */
      DB {
	printf("\nUnmarshallRep field %d:",(pMsg->iCurrFldI0b)+1);
	for(i=0; i < (pR-pL); i++)
	  printf("%c",*(pL+i));
	fflush(stdout);
      }
      if ((i = UnmarshallComp(pMsg, pR)) != HL7_OK) return (i);
    }
    if (pT != 0) 
      pL= pT + 1;
  } while (pT);
  pMsg->pWireCursor = pRight;
  return(HL7_OK);
}


static int UnmarshallComp(HL7MSG *pMsg, char *pRight) {
  HL7COMP *pComp;
  char *pLeft;			/* first char in component  */
  char *pL, *pR;
  char *pT;
  int i;
  int CompCount;

  pLeft = pMsg->pWireCursor;
  pL = pLeft;
  CompCount = 0;

  do { /* until component scanning is over */
    pMsg->pCurrSub =0;

    if ((pT = memchr(pL, pMsg->CmpSep, (HL7_SIZE)(pRight-pL))) != NULL) 
      pR = pT;
    else
      pR = pRight;
    CompCount++;
    if ((pR - pL) != 0) {               /* non-empty component*/
    DB {
      printf("\n allocate new component");
      fflush(stdout);
    }
      if ((pComp = (HL7COMP *) malloc(sizeof(HL7COMP))) == 0)
	return (HL7_NO_MEMORY); 
      if (pMsg->pCurrCom == 0)	{		/* first entry in list */
	pMsg->pCurrRep->pComp = pComp;
	pMsg->pCurrRep->CompNum = 1;
      } else {				/* add to comp list    */
	pMsg->pCurrCom->pCompNext = pComp;	/* attach to list      */
	pMsg->pCurrRep->CompNum = CompCount;
      }
      pMsg->pCurrCom = pComp;
      pComp->pCompNext = 0;
      pComp->pSCompLst = 0;
      pComp->CompIndex = CompCount;     /* set index component index */

      pMsg->pWireCursor = pL;
      DB {
	printf("\nUnmarshallComp:");
	for(i=0; i < (pR-pL); i++)
	  printf("%c",*(pL+i));
	fflush(stdout);
      }
      if ((i = UnmarshallSub(pMsg, pR)) != HL7_OK) return (i);      
    }
    if (pT !=0)
      pL = pT +1;
  } while (pT);
  pMsg->pWireCursor = pRight;
  return(HL7_OK);
}

static int UnmarshallSub(HL7MSG *pMsg, char *pRight) {
  HL7SUBCOMP *pSub;
  char *pLeft;			/* first char in subcomponent  */
  char *pL, *pR;
  char *pT;
  char SubCount;
  int i;
  

  pLeft = pMsg->pWireCursor;
  pL = pLeft;
  SubCount = 0;

  do { /* until subcomponent scanning is over */
    if ((pT = memchr(pL, pMsg->SubSep, (HL7_SIZE)(pRight-pL))) != NULL)
      pR = pT;
    else
      pR = pRight;
    SubCount++;
    if ((pR - pL) != 0) {	        /* non-emty subcomponent */
      DB {
	printf("\n allocate new subcomponent");
	fflush(stdout);
      }
      if ((pSub = (HL7SUBCOMP *) malloc(sizeof(HL7SUBCOMP))) == 0)
	return (HL7_NO_MEMORY);
      if (pMsg->pCurrSub == 0) 		/* first subcomponent   */
	pMsg->pCurrCom->pSCompLst = pSub;
      else 
	pMsg->pCurrSub->pSubNext = pSub;
      pMsg->pCurrSub = pSub;
      pMsg->pCurrCom->SubCompNum = SubCount;
      pMsg->pCurrSub->SubCompIndex = SubCount;
      pMsg->pCurrSub->pSubNext = 0;
      pMsg->pWireCursor = pL;
      DB {
	printf("\n allocate new data");
	fflush(stdout);
      }
      if ((pSub->pzDataStr = (char *)malloc((HL7_SIZE)(pR-pL+1))) == NULL)
	return (HL7_NO_MEMORY);
      DB {
	printf("\nUnmarshallSub :");
	for(i=0; i < (pR-pL); i++)
	  printf("%c",*(pL+i));
	fflush(stdout);
      }
      strncpy(pSub->pzDataStr, pL, (HL7_SIZE)(pR-pL));
      pSub->SubLen = pR-pL;
      *(pSub->pzDataStr + pSub->SubLen) = '\0';
    }
    if (pT != 0)
      pL = pT +1;			/* goto to next subcomp */
  } while (pT);

  pMsg->pWireCursor = pRight;
  return(HL7_OK);
}

static int UnmarshallSep(HL7MSG *pMsg, const char *pString) {
  HL7REP *pRep;
  HL7COMP *pComp;
  HL7SUBCOMP *pSubComp;

  if ((pRep = (HL7REP *) malloc(sizeof(HL7REP))) == 0)
    return (HL7_NO_MEMORY);
  pMsg->pCurrRep = pRep;

  (pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = pRep;
  pRep->RepNum     = 1;
  pRep->CompNum    = 1;
  pRep->pRepNext   = 0;

  
  if ((pComp = (HL7COMP *) malloc(sizeof(HL7COMP))) == 0)
    return (HL7_NO_MEMORY);
  
  pMsg->pCurrCom = pComp;
  pRep->pComp    = pComp;
  pComp->CompIndex = 1;
  pComp->pCompNext = 0;

  if ((pSubComp = (HL7SUBCOMP *) malloc(sizeof(HL7SUBCOMP))) == 0)
    return (HL7_NO_MEMORY);
  pMsg->pCurrSub = pSubComp;  
  pComp->pSCompLst = pSubComp;
  pSubComp->SubLen = 4;	/* length (exclude null-terminator) */
  pSubComp->SubCompIndex = 1;
  pSubComp->pSubNext = 0;

  if ((pSubComp->pzDataStr = (char *) malloc(5)) == 0)
    return (HL7_NO_MEMORY);
  strncpy(pSubComp->pzDataStr, pString,4);
  *( (pSubComp->pzDataStr)+4) = 0;

  return(HL7_OK);
}

char * HL7GetSub(HL7MSG *pMsg, int FieldNum, int RepNum,
		 int CompNum, int SubNum)
{
				/* pick out a subcomponnet */
  HL7SEG      *pSegT;
  HL7REP      *pRepT;
  HL7COMP     *pCompT;
  HL7SUBCOMP  *pSubT;

  char        azFldDel[2];

  /* chech handle */
  if (pMsg == NULL) return(NULL);

  if (pMsg->pGetBuffer != 0) *pMsg->pGetBuffer = '\0';  

  /* check current segment */
  if ((pSegT = pMsg->pCurrSeg) == NULL) return(NULL);

  /* arguments validation */
  if ((FieldNum  < 1) || 
       (RepNum    < 1) ||
       (CompNum   < 1) ||
       (SubNum    < 1))    return(NULL);

  if (pSegT->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pSegT->pSegRul == pMsg->pFlvr->HL7pBHS
     || pSegT->pSegRul == pMsg->pFlvr->HL7pFHS */
						)
    if (FieldNum == 1) {
      if (pMsg->pGetBuffer != 0) *pMsg->pGetBuffer = '\0';
      azFldDel[0] = pMsg->FldSep;
      azFldDel[1] = '\0';      
      if (AppendToBuffer(pMsg, azFldDel) != HL7_OK)
	  return(NULL);
      return(pMsg->pGetBuffer);
    }

  if ((pRepT = pSegT->pFldLst[FieldNum-1]) == NULL) return(NULL);
  /* traverse reprtition list */
  do {
    if (pRepT->RepNum == RepNum) break;     
  } while (pRepT = pRepT->pRepNext);
  if (pRepT == 0) return(NULL);			/* Not that many repeats */
  if (pRepT->RepNum != RepNum) return(NULL);  
  
  if ((pCompT = pRepT->pComp) == NULL) return(NULL);
  /* traverse component list */
  do {
    if (pCompT->CompIndex == CompNum) break; 
  } while(pCompT = pCompT->pCompNext);
  if (pCompT == NULL) return(NULL);		/* null comp., thanks Ray */

  if ((pSubT = pCompT->pSCompLst) == NULL) return(NULL);
  /* traverse subcomponent list */
  do {
    if (pSubT->SubCompIndex == SubNum) break;
  } while (pSubT = pSubT->pSubNext);
  if (pSubT == NULL) return(NULL);		/* null subcomp, thanks Ray */

  if (pSubT->pzDataStr == NULL) return(NULL); /* no data                    */
  /* get data */
  AppendToBuffer(pMsg, pSubT->pzDataStr);

  return(pMsg->pGetBuffer);
}

char * HL7GetComp(HL7MSG *pMsg, int FieldNum, int RepNum,
		 int CompNum)
{
				/* pick out a componnet	*/
  HL7SEG      *pSegT;
  HL7REP      *pRepT;
  HL7COMP     *pCompT;
  HL7SUBCOMP  *pSubT;
  int         i,j;
  char        azSubDel[2];
  char        azFldDel[2];

  /* chech handle */
  if (pMsg == NULL) return(NULL);

  azSubDel[0] = pMsg->SubSep;
  azSubDel[1] = '\0';
  
  /* check current segment */
  if ((pSegT = pMsg->pCurrSeg) == NULL) return(NULL);
  
  /* arguments validation */
  if ((FieldNum  < 1) || 
      (RepNum    < 1) ||
      (CompNum   < 1))    return(NULL);
  
  if (pSegT->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pSegT->pSegRul == pMsg->pFlvr->HL7pBHS
     || pSegT->pSegRul == pMsg->pFlvr->HL7pFSH */
						)
    if (FieldNum == 1) {
      if (pMsg->pGetBuffer != 0) *pMsg->pGetBuffer = '\0';
      azFldDel[0] = pMsg->FldSep;
      azFldDel[1] = '\0';      
      if (AppendToBuffer(pMsg, azFldDel) != HL7_OK)
	  return(NULL);
      return(pMsg->pGetBuffer);
    }

  if ((pRepT = pSegT->pFldLst[FieldNum-1]) == NULL) return(NULL);
  /* traverse reprtition list */
  do {
    if (pRepT->RepNum == RepNum) break; 
  } while(pRepT = pRepT->pRepNext);
  if (pRepT == 0) return(NULL);			/* Not that many repeats */
  if (pRepT->RepNum != RepNum) return(NULL);  

    
  if ((pCompT = pRepT->pComp) == NULL) return(NULL);
  /* traverse component list */
  do {
    if (pCompT->CompIndex == CompNum) break; 
  } while(pCompT = pCompT->pCompNext);
    if (pCompT == NULL) return(NULL);	/* empty component, thanks Ray */
  
  /* build component from all existing subcomponents */
  /* write output in io buffer                       */
  
  if ((pSubT = pCompT->pSCompLst) == NULL) return(NULL);
  
  if (pMsg->pGetBuffer != 0)
    *pMsg->pGetBuffer = '\0';		/* prepare buffer */
  
 /* traverse subcomponent list */
  i=0;
  
  do {
    i++;			/* number of sub component */
    if (pSubT->pzDataStr != NULL) {
      if (i != 1)
	if (AppendToBuffer(pMsg, azSubDel) != HL7_OK)
	  return(NULL);
      if (pSubT->SubCompIndex > i) {
	for (j=0; j<(pSubT->SubCompIndex - i);j++) 
	  if (AppendToBuffer(pMsg, azSubDel) != HL7_OK)
	    return(NULL);
	i = pSubT->SubCompIndex;
      }
      
      if (AppendToBuffer(pMsg, pSubT->pzDataStr) != HL7_OK) 
	return(NULL);
    }      
  } while(pSubT=pSubT->pSubNext);
  return(pMsg->pGetBuffer);
}


char * HL7GetRep(HL7MSG *pMsg, int FieldNum, int RepNum)
{
			/* pick put a repeated field */
  HL7SEG      *pSegT;
  HL7REP      *pRepT;
  HL7COMP     *pCompT;
  HL7SUBCOMP  *pSubT;
  int         i,j,k;
  char        azCmpDel[2];
  char        azSubDel[2];
  char        azFldDel[2];

  /* chech handle */
  if (pMsg == NULL) return(NULL);

  azCmpDel[0] = pMsg->CmpSep;
  azCmpDel[1] = '\0';
  azSubDel[0] = pMsg->SubSep;
  azSubDel[1] = '\0';
  
  /* check current segment */
  if ((pSegT = pMsg->pCurrSeg) == NULL) return(NULL);
  
  /* arguments validation */
  if ((FieldNum  < 1) || 
      (RepNum    < 1)) return(NULL);

  if (pSegT->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pSegT->pSegRul == pMsg->pFlvr->HL7pBHS
     || pSegT->pSegRul == pMsg->pFlvr->HL7pFHS */
						)
    if (FieldNum == 1) {
      if (pMsg->pGetBuffer != 0) *pMsg->pGetBuffer = '\0';
      azFldDel[0] = pMsg->FldSep;
      azFldDel[1] = '\0';      
      if (AppendToBuffer(pMsg, azFldDel) != HL7_OK)
	  return(NULL);
      return(pMsg->pGetBuffer);
    }
  
  if ((pRepT = pSegT->pFldLst[FieldNum-1]) == NULL) return(NULL);
  /* traverse repetition list */
  for(i=1;(pRepT->pRepNext != NULL) && (i < RepNum); 
      pRepT=pRepT->pRepNext, i++);
  if (i != RepNum) return(NULL);
  
  if ((pCompT = pRepT->pComp) == NULL) return(NULL);
  if (pMsg->pGetBuffer != 0)
    *pMsg->pGetBuffer = '\0';		/* prepare buffer */

  /* traverse component list */
  k=0;				/* component counter */
  do {
    k++;
    if ((pSubT = pCompT->pSCompLst) != NULL) {
      if (k!=1)
	if (AppendToBuffer(pMsg, azCmpDel) != HL7_OK)
	  return(NULL);
      if (pCompT->CompIndex > k) {
	for (j=0; j<(pCompT->CompIndex - k);j++) 
	  if (AppendToBuffer(pMsg, azCmpDel) != HL7_OK)
	      return(NULL);
	k = pCompT->CompIndex;
      } 
      
      i=0;			/* subcomp counter   */
      do {
	i++;			/* number of sub component */
	if (pSubT->pzDataStr != NULL) {
	  if (i != 1)
	    if (AppendToBuffer(pMsg, azSubDel) != HL7_OK)
	      return(NULL);
	  if (pSubT->SubCompIndex > i) {
	    for (j=0; j<(pSubT->SubCompIndex - i);j++) 
	      if (AppendToBuffer(pMsg, azSubDel) != HL7_OK)
		return(NULL);
	    i = pSubT->SubCompIndex;
	  } 
	  
	  if (AppendToBuffer(pMsg, pSubT->pzDataStr) != HL7_OK) 
	    return(NULL);
	}      
      } while(pSubT=pSubT->pSubNext);
    }
	
  } while(pCompT=pCompT->pCompNext);
  
  return(pMsg->pGetBuffer);
}

char * HL7GetFld(HL7MSG *pMsg, int FieldNum)
{
			/* get a nonrepeated field */
  HL7SEG      *pSegT;
  HL7REP      *pRepT;
  HL7COMP     *pCompT;
  HL7SUBCOMP  *pSubT;
  int         i,j,k,l;
  char        azRepDel[2];
  char        azCmpDel[2];
  char        azSubDel[2];

  char        azFldDel[2];

  /* check handle */
  if (pMsg == NULL) return(NULL);

  azRepDel[0] = pMsg->RepSep;
  azRepDel[1] = '\0';
  azCmpDel[0] = pMsg->CmpSep;
  azCmpDel[1] = '\0';
  azSubDel[0] = pMsg->SubSep;
  azSubDel[1] = '\0';
  
  /* check current segment */
  if ((pSegT = pMsg->pCurrSeg) == NULL) return(NULL);
  
  /* arguments validation */
  if (FieldNum  < 1) return(NULL);
 
  if (pSegT->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pSegT->pSegRul == pMsg->pFlvr->HL7pBHS
     || pSegT->pSegRul == pMsg->pFlvr->HL7pFHS */
						)
    if (FieldNum == 1)  {
      if (pMsg->pGetBuffer != 0) *pMsg->pGetBuffer = '\0';
      azFldDel[0] = pMsg->FldSep;
      azFldDel[1] = '\0';      
      if (AppendToBuffer(pMsg, azFldDel) != HL7_OK)
	  return(NULL);
      return(pMsg->pGetBuffer);
    }

  if ((pRepT = pSegT->pFldLst[FieldNum-1]) == NULL) return(NULL);

  /* traverse repetition list */
  l=0;				/* repetition counter */
  if (pMsg->pGetBuffer != 0) 
    *pMsg->pGetBuffer = '\0'; 

  do {
    l++;
    if ((pCompT = pRepT->pComp) != NULL) {
      if (l!=1)
	if (AppendToBuffer(pMsg, azRepDel) != HL7_OK)
	  return(NULL);
      if (pRepT->RepNum >l) {
	for (j=0; j<(pRepT->RepNum - l);j++) 
	  if (AppendToBuffer(pMsg, azRepDel) != HL7_OK)
	    return(NULL);
	l = pRepT->RepNum;
      } 
      /* traverse component list */
      k=0;				/* component counter */
      do {
	k++;
	if ((pSubT = pCompT->pSCompLst) != NULL) {
	  if (k!=1)
	    if (AppendToBuffer(pMsg, azCmpDel) != HL7_OK)
	      return(NULL);
	  if (pCompT->CompIndex > k) {
	    for (j=0; j<(pCompT->CompIndex - k);j++) 
	      if (AppendToBuffer(pMsg, azCmpDel) != HL7_OK)
		return(NULL);
	    k = pCompT->CompIndex;
	  } 
	  i=0;			/* subcomp counter   */
	  do {
	    i++;			/* number of sub component */
	    if (pSubT->pzDataStr != NULL) {
	      if (i != 1)
		if (AppendToBuffer(pMsg, azSubDel) != HL7_OK)
		  return(NULL);
	      if (pSubT->SubCompIndex > i) {
		for (j=0; j<(pSubT->SubCompIndex - i);j++) 
		  if (AppendToBuffer(pMsg, azSubDel) != HL7_OK)
		    return(NULL);
		i = pSubT->SubCompIndex;
	      }
	      
	      if (AppendToBuffer(pMsg, pSubT->pzDataStr) != HL7_OK) 
		return(NULL);
	    }      
	  } while(pSubT=pSubT->pSubNext);
	}
      } while(pCompT=pCompT->pCompNext);
    }
    
  } while(pRepT=pRepT->pRepNext);

  return(pMsg->pGetBuffer);
}

static int AppendToBuffer(HL7MSG *pMsg, char *pSource) 
{
  HL7_SIZE Len, ExpLen;
  
  Len = strlen(pSource); /* + pMsg->pGetBuffer; expected string length */
  if (pMsg->pGetBuffer == 0) {		        /* init allocation     */
    if ((pMsg->pGetBuffer = malloc(Len +1)) == 0)
      return(HL7_NO_MEMORY);
    *pMsg->pGetBuffer = '\0';
    pMsg->GetBufferSize = Len +1;
  } else {
    ExpLen = strlen(pMsg->pGetBuffer)+Len+1;	/* expected size of buffer */
    if (ExpLen > pMsg->GetBufferSize) {		/* needs extentension      */
      if ((pMsg->pGetBuffer = realloc(pMsg->pGetBuffer,ExpLen)) == NULL)
	return(HL7_NO_MEMORY);
      pMsg->GetBufferSize = ExpLen;
    }
  }
  strcat(pMsg->pGetBuffer, pSource);
  return(HL7_OK);
}

int HL7ReadMesg( HL7MSG *pMsg, char *pzWire, HL7_SIZE wireLen)
{
  int i;
  DB printf("\n Read message");

  if (pMsg == NULL) return(HL7_NULL_ARG); /* HL7MSG was not allocated*/

  pMsg->fDirection = HL7_WIRE_TO_STRUCT; /* global flag         */
  
  pMsg->pWire = pzWire;
  pMsg->pWireCursor = pzWire;
  pMsg->WireLen = wireLen; /* an HL7 message is a record, thus it has length */

  if ((i = HL7Parse (pMsg)) != HL7_OK) return (i); /* do the parse        */
  DB printf("\n Parsing finish");  
  pMsg->pCurrSeg = pMsg->pSegList;
  return (HL7_OK);
}

int skipTo(char clsParen, MSGterm **pCurTerm) {
  int s;
  MSGterm *pLclTerm = *pCurTerm;	/* resolve/deref	*/
  while ( (pLclTerm = pLclTerm->nxt)) {	/* assumes no <> or {} */
    if (pLclTerm->typ == clsParen) {
      *pCurTerm = pLclTerm;
      return HL7_OK;
    }
    switch ( clsParen) {
      case ']' :
        if ( pLclTerm->typ == '[') {
	  s = skipTo( clsParen, &pLclTerm);
	}
        break;
      case '>' :
        if ( pLclTerm->typ == '<') {
	  s =skipTo( clsParen, &pLclTerm);
	}
        break;
      case '}' :
        if ( pLclTerm->typ == '{') {
	  s = skipTo( clsParen, &pLclTerm);
	}
        break;
      case ')' :
        if ( pLclTerm->typ == '(') return skipTo( clsParen, &pLclTerm);
        break;
    }
  } 
  return HL7_END_OF_STRUCT;
}

int doSquareB( HL7MSG *pMsg, MSGterm **pCurTerm) {	/* [ 0 or 1 ]	*/

/* This function parses thru a pair of [] we will be matching zero or one.
    returns number of matches or an error, errors are > 255.
    pCurTerm is left pointing at ]
    pMsg->pCurrSeg may change
    By Allen Rueter							*/

  int s, m, mtchd = 0;
  MSGterm *pLclTerm = *pCurTerm;	/* resolve/deref	*/
  pLclTerm = pLclTerm->nxt;		/* move past [			*/
  DB printf("\n In doSquareB");
 
  while (1) {
    if (pLclTerm->typ == 0) {		/* seg or loop ? */
      if (mtchd == 0) {			/* seg, no matches yet */
        if ((s=HL7IsNextSeg( pMsg, pLclTerm->pSegR))==HL7_OK) {	/* will it? */
	  if ((s = HL7Eat(pMsg, pLclTerm->pSegR)) !=HL7_OK) {	/* yes, eat */
	    skipTo( ']', &pLclTerm);				/* hmm, */
	    *pCurTerm = pLclTerm; 	/* step over & return	*/
	    return s;
	  }
	  mtchd=1;			/* have one match */
	} else { 			/* no matches, this is ok */
	    skipTo( ']', &pLclTerm);
	    *pCurTerm = pLclTerm; 	/* step over & return	*/
	    return 0;
        }
      } else EAT(pLclTerm->pSegR,s);	/* 1st matched, rest must match */
    } else {
	switch ( pLclTerm->typ) {	/* loop deeper */
	  case '[' : 
	    m=doSquareB( pMsg, &pLclTerm); break;
	  case '{' : 
	    m=doCurlyB( pMsg, &pLclTerm, 1); 
	    if (mtchd == 0 && m > 255) { /* [{ xxx }] is ok to not match */
	      skipTo( ']', &pLclTerm);
	      *pCurTerm = pLclTerm; 	/* step over & return	*/
	      return 0;
	    }
	    break;
	  case '<' : 
	    m=doAngleB( pMsg, &pLclTerm, 1); break;
	  case '(' : 
	    m=doParen( pMsg, &pLclTerm); break;
	  case ']' : 
	    *pCurTerm = pLclTerm;	/* return number of matches	*/
	    return mtchd; 
	  default : 
	    return HL7_PARSE_NESTING;
	}
	if (m>255) return m;
	if (m>0) mtchd = 1;
    }
    pLclTerm= pLclTerm->nxt;
  }
}

int doParen( HL7MSG *pMsg, MSGterm **pCurTerm) {	/* ( one of )	*/
/* This function parses thru a pair of () we will be matching one of them
    returns number of matches or an error, errors are > 255
    pCurTerm is left pointing at )
    pMsg->pCurrSeg may change
    By Allen Rueter							*/

  int s, m, mtchd = 0;
  MSGterm *pLclTerm = *pCurTerm;	/* resolve/deref	*/
  pLclTerm = pLclTerm->nxt;		/* move past (			*/
  DB printf("\n In doParen");

  while (1) {
    if (pLclTerm->typ == 0) {		/* seg or loop deeper ? */
      if (mtchd == 0) {
        if ((s=HL7IsNextSeg( pMsg, pLclTerm->pSegR))==HL7_OK) {
	  if ((s = HL7Eat( pMsg, pLclTerm->pSegR)) != HL7_OK) return s;
	  mtchd=1;
	}
      } else ;				/* matched 1, skip rest */
    } else {
	switch ( pLclTerm->typ) {
	  case '[' : 
	    m=doSquareB( pMsg, &pLclTerm); break;
	  case '{' : 
	    m=doCurlyB( pMsg, &pLclTerm, 1); break;
	  case '<' : 
	    m=doAngleB( pMsg, &pLclTerm, 1); break;
	  case '(' : 
	    m=doParen( pMsg, &pLclTerm); break;
	  case ')' : 
	    *pCurTerm = pLclTerm; /* return number of matches	*/
	    return mtchd; 
	  default : 
	    return HL7_PARSE_NESTING; 
	}
	if (m>255) return m;	/* error */
	if (m>0) mtchd = 1;
    }
    pLclTerm=pLclTerm->nxt;
  }
}

							/* { 1 or more } */
int doCurlyB( HL7MSG *pMsg, MSGterm **pCurTerm, int iter) {
/* This function parses thru a pair of {} we will be matching one or more.
    returns number of matches or an error, errors are > 255.
    pCurTerm is left pointing at }
    pMsg->pCurrSeg may change.
    By Allen Rueter							*/

  int s, m, mtchd = 0;
  MSGterm *pLclTerm = *pCurTerm;	/* resolve/deref	*/
  MSGterm *pMarkCT = *pCurTerm;		/* recursive loop back */
  pLclTerm = pLclTerm->nxt;		/* move past [			*/
  DB printf("\n In doCurlyB");

  while (1) {
    if (pLclTerm->typ == 0) {		/* seg or loop deeper */
      if (mtchd == 0) {			/* we need to find a match */
	if (iter == 1) {		/* 1st try ? */
	  if ((s = HL7Eat( pMsg, pLclTerm->pSegR)) != HL7_OK) {
	    skipTo( '}', &pLclTerm);	/* 1st failed, skip incase [{xxx}] */
	    *pCurTerm = pLclTerm;	
	    return s;
	  }
	  mtchd=1;
	} else if ((s=HL7IsNextSeg( pMsg, pLclTerm->pSegR))==HL7_OK) {
	  EAT(pLclTerm->pSegR,s);		/* mtch 1, match rest */
	  mtchd=1;
	} else if (s == HL7_SEG_MISMATCH) {
	    skipTo( '}', &pLclTerm);
	    *pCurTerm = pLclTerm;   
	    return 0;		/* nth interation, nomatch, rtn ok */
	}
      } else EAT(pLclTerm->pSegR,s);	/* 1st matched, rest must match */
    } else {
	switch ( pLclTerm->typ) {
	  case '[' : 
	    m=doSquareB( pMsg, &pLclTerm); break;
	  case '{' : 
	    m=doCurlyB( pMsg, &pLclTerm, 1); break;
	  case '<' : 
	    m=doAngleB( pMsg, &pLclTerm, 1); break;
	  case '(' : 
	    m=doParen( pMsg, &pLclTerm); break;
	  case '}' : 
	    if (mtchd) if ( (m=doCurlyB( pMsg, &pMarkCT, iter+1))>255) return m;
	    *pCurTerm = pLclTerm;	/* move up & return 	*/
	    return mtchd;
	    break;				
	  default : 
	    return HL7_PARSE_NESTING; break;
	}
	if (m>255) {
	  if (iter>1 && mtchd==0) m = 0;
	    else return m;	/* error */
	}
	if (m>0) mtchd = 1;
    }
    pLclTerm=pLclTerm->nxt;
  }
}

							/* < 0 or more > */
int doAngleB( HL7MSG *pMsg, MSGterm **pCurTerm, int iter) {
/* This function parses thru a pair of <> we will be matching zero or more
    returns number of matches or an error, errors are > 255
    pCurTerm is left pointing at >
    pMsg->pCurrSeg may change
    By Allen Rueter							*/

  int s, m, mtchd = 0;
  MSGterm *pLclTerm = *pCurTerm;	/* resolve/deref	*/
  MSGterm *pMarkCT = *pCurTerm;		/* recursive loop back */
  pLclTerm = pLclTerm->nxt;		/* move past <			*/
  DB printf("\n In doAngleB");
  while (1) {
    if (pLclTerm->typ == 0) {
      if (mtchd == 0) {
	if ((s=HL7IsNextSeg( pMsg, pLclTerm->pSegR))==HL7_OK) {
	  EAT(pLclTerm->pSegR,s);		/* mtch 1, match rest */
	  mtchd=1;
	} else if ( s==HL7_SEG_MISMATCH) {	/* HL7_END_OF_STRUCT? */
	    skipTo('>',&pLclTerm);
	    *pCurTerm = pLclTerm;
	    return 0;		/* nomatchs, return 	*/
	}
      } else 			/* 1st matched, rest must match */
	if (( s = HL7Eat( pMsg, pLclTerm->pSegR)) != HL7_OK) {
	  fprintf( stderr, "\n Looking for %.3s, found %.3s \n", 
			pLclTerm->pSegR->azNam, pMsg->pWireCursor);
	  return s;
	}
    } else {
	switch ( pLclTerm->typ) {
	  case '[' : 
	    m=doSquareB( pMsg, &pLclTerm); break;
	  case '{' : 
	    m=doCurlyB( pMsg, &pLclTerm, 1); break;
	  case '<' : 
	    m=doAngleB( pMsg, &pLclTerm, 1); break;
	  case '(' : 
	    m=doParen( pMsg, &pLclTerm); break;
	  case '>' : 
	    if (mtchd) if ( (s=doAngleB( pMsg, &pMarkCT, iter+1))>255) return s;
	    *pCurTerm = pLclTerm; /* move up & return	*/
	    return mtchd;
	  default : 
	    return HL7_PARSE_NESTING; break;
	}
	if (m>255) return m;	/* error */
	if (m>1) mtchd = 1;
    }
    pLclTerm=pLclTerm->nxt;
  }
}

static int HL7Parse (HL7MSG *pMsg)
{
  int i, m ;
  int s;				/* status for EAT  */
  MSGterm *pCurTerm;
  DB printf("\n HL7Parse start");
	/* MSH is always present in HL7, but maybe preceeded by BHS, FHS */  
 skipBHSFHS:
  if ((s=HL7IsNextSeg( pMsg, pMsg->pFlvr->HL7pMSH))!=HL7_OK) {
  /*
    if ( HL7IsNextSeg( pMsg, pMsg->pFlvr->HL7pBHS)==HL7_OK ) { 
  	EAT (pMsg->pFlvr->HL7pBHS, s);
	goto skipBHSFHS;
	}
    else if ( HL7IsNextSeg( pMsg, pMsg->pFlvr->HL7pFHS)==HL7_OK) { 
  	EAT (pMsg->pFlvr->HL7pFHS, s);
	goto skipBHSFHS;
	}
    else return HL7_SEG_MISMATCH;  */	
  }
  EAT (pMsg->pFlvr->HL7pMSH, s);       /* MSH is always present in HL7.     */
                                       /* Message Type decides parse rules, */
                                       /* & pMsg should point correctly     */
	           			/* init error message var */

  pMsg->pRule = pMsg->pFlvr->p1Rule;	/* find Rule			*/
  while (strcmp( pMsg->pRule->evnt, pMsg->cMsgRcode) !=0) {
    pMsg->pRule = pMsg->pRule->nxt;
    if (pMsg->pRule==0) {
      sprintf( pMsg->ErrorMessage,"HL7Parse: Rule not found for %.7s",
								pMsg->cMsgRcode);
      fprintf( stderr,"%s\n",pMsg->ErrorMessage);
      return (HL7_BAD_MSG_TYPE);
    }
  }
foundRule:				/* Found Rule, start validating	*/
  pCurTerm = pMsg->pRule->p1term;
  pCurTerm = pCurTerm->nxt;		/* skip over MSH term */

  while ( pCurTerm) {
    if (pCurTerm->typ==0) {			/* Seg def? */
      EAT(pCurTerm->pSegR,s);	
    } else {					/* new parse rule */
      switch ( pCurTerm->typ) {
	case '[' : 
	  m=doSquareB( pMsg, &pCurTerm); 
	  break;
	case '{' : 
	  m=doCurlyB( pMsg, &pCurTerm, 1);
	  if (m==0) return HL7_SEG_MISSING;
	  break;
	case '<' : 
	  m=doAngleB( pMsg, &pCurTerm, 1);
	  break;
	case '(' : 
	  m=doParen( pMsg, &pCurTerm); 
	  if (m!=1) return HL7_SEG_MISSING;
	  break;
	default : 
	  sprintf( pMsg->ErrorMessage, 
		"HL7Parse: Hmm Parse error, expecting [{< or (.");
	  fprintf( stderr, "\n %s\n", pMsg->ErrorMessage);
	  return HL7_PARSE_NESTING;
      }
      s=  (m>=1&&m<=255) ? 0 : m;
    }
    if (s==HL7_END_OF_STRUCT) if (pCurTerm==0) return HL7_OK;
    if (s!=HL7_OK) return s;
    pCurTerm = pCurTerm->nxt;
  }
  if (pMsg->pCurrSeg->pNextSeg!=0) return HL7_SEG_MISMATCH;
  if (pMsg->pWireCursor-pMsg->pWire != pMsg->WireLen) {
	sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
	sprintf( pMsg->ErrorMessage, 
	"Parse cursor did not end up at end of wire, differnce is %d",
	 pMsg->WireLen - (HL7_SIZE) (pMsg->pWireCursor-pMsg->pWire));
    return HL7_SEG_MISMATCH;
  }
  return HL7_OK;
}

static void MsgType2Ecode (HL7MSG *pmsg)
{
  int  i;
  i = strlen(pmsg->cMsgType);
  
  switch(i) {
    case HL7_MSGTYPE_LEFT:				/* case XXX	*/
    case HL7_MSGTYPE_LEFT+1:				/* case XXX^	*/
      strncpy( pmsg->cMsgRcode, pmsg->cMsgType, HL7_MSGTYPE_LEFT);
      pmsg->cMsgRcode[HL7_MSGTYPE_LEFT] = 0;
      break;
    case HL7_MSGTYPE_LEN:				/* case XXX^YNN	*/
    case HL7_MSGTYPE_LEN+8:				/* case XXX^YNN^XXX_YNN	*/
      strncpy( pmsg->cMsgRcode, &pmsg->cMsgType[0], HL7_MSGTYPE_LEFT);
							/* remove ^ 	*/
      strncpy( &pmsg->cMsgRcode[HL7_MSGTYPE_LEFT], 
		&pmsg->cMsgType[HL7_MSGTYPE_LEFT+1], HL7_MSGTYPE_RIGHT); 
      pmsg->cMsgRcode[HL7_MSGTYPE_LEFT+HL7_MSGTYPE_RIGHT]=0;
      break;
    default:                                           /* uknown type    */ 
      sprintf( pmsg->ErrorMessage, "MsgType2Ecode: Bad MsgType %.9s with length %d",
							 pmsg->cMsgType, i);
      fprintf( stderr, "%s\n", pmsg->ErrorMessage);
      exit(0);
  }
}

static int MarshallSeg (HL7MSG *pMsg, HL7SegRule *pSegR)
{
  int iResult;
  HL7SEG   *pSegT;
  HL7REP      *pRepT;
  HL7COMP     *pCompT;
  HL7SUBCOMP  *pSubT;
  int         i,j,k,l,f;
  int         FieldAmt;
  char azSegDel[2];

  azSegDel[0] = HL7_SEG_SEP;
  azSegDel[1] = '\0';

  pSegT = pMsg->pCurrSeg;
/*  printf("\n Marshall -%s", pSegR->azNam; fflush(stdout); */


  if ((iResult = PoolToWire(pMsg, pSegR->azNam, HL7_SEG_NAME_LEN)) != 
       HL7_OK) return (iResult);
  if ((iResult = PoolToWire(pMsg, &pMsg->FldSep, 1)) != 
       HL7_OK) return (iResult);

  FieldAmt = pSegR->nmbrFlds;
    
  for ( f= (pSegR!=pMsg->pFlvr->HL7pMSH) ? 0 : 1 ; f<FieldAmt; f++) {
	/* BHS FHS ? */
    if ((pRepT = pSegT->pFldLst[f]) != 0) {
      pMsg->iCurrFldI0b = f;
      /* traverse repetition list */
      l=0;				/* repetition counter */
      do {
	l++;
	if ((pCompT = pRepT->pComp) != NULL) {
	  if (l!=1)
	    if ((iResult=PoolToWire(pMsg,&pMsg->RepSep,1)) != HL7_OK)
	      return(iResult);
	  if (pRepT->RepNum >l) {
	    for (j=0; j<(pRepT->RepNum - l);j++) 
	      if ((iResult=PoolToWire(pMsg,&pMsg->RepSep,1)) != HL7_OK)
		return(iResult);
	    l = pRepT->RepNum;
	  } 
	  /* traverse component list */
	  k=0;				/* component counter */
	  do {
	    k++;
	    if ((pSubT = pCompT->pSCompLst) != NULL) {
	      if (k!=1)
		if ((iResult=PoolToWire(pMsg, &pMsg->CmpSep,1)) != HL7_OK)
		  return(iResult);
	      if (pCompT->CompIndex > k) {
		for (j=0; j<(pCompT->CompIndex - k);j++) 
		  if ((iResult=PoolToWire(pMsg, &pMsg->CmpSep,1)) != HL7_OK)
		    return(iResult);
		k = pCompT->CompIndex;
	      } 
	      
	      i=0;			/* subcomp counter   */
	      do {
		i++;			/* number of sub component */
		if (pSubT->pzDataStr != NULL) {
		  if (i != 1)
		    if ((iResult=PoolToWire(pMsg, &pMsg->SubSep,1)) != HL7_OK)
		      return(iResult);
		  if (pSubT->SubCompIndex > i) {
		    for (j=0; j<(pSubT->SubCompIndex - i);j++) 
		      if ((iResult=PoolToWire(pMsg, &pMsg->SubSep,1)) != HL7_OK)
			return(iResult);
		    i = pSubT->SubCompIndex;
		  }
		  if ((iResult=PoolToWire(pMsg, pSubT->pzDataStr, 
				 pSubT->SubLen)) != HL7_OK) 
		    return(iResult);
		}      
	      } while(pSubT = pSubT->pSubNext);
	    }
	  } while(pCompT = pCompT->pCompNext);
	}
      } while(pRepT = pRepT->pRepNext);
    }
    if (f < (FieldAmt - 1))             /* don't print field delimeter for */
					/* last field in segment           */
      if ((iResult = PoolToWire(pMsg, &pMsg->FldSep, 1)) != 
	  HL7_OK) return (iResult);
  }
  if ((iResult = PoolToWire(pMsg, azSegDel, 1)) != 
       HL7_OK) return (iResult);
  return(HL7_OK);
}   
      
static int PoolToWire(HL7MSG *pMsg, char *pChar, HL7_SIZE Len)
{
  if (pMsg->WireLen + Len + 1 > pMsg->MaxWireLen) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "PoolToWire: Wire over flow!");
    /*fprintf( stderr, "\n %s %s \n", pMsg->ErrorLevel, pMsg->ErrorMessage);*/
    return(HL7_WIRE_OVERFLOW);
  }
  strncpy(pMsg->pWireCursor, pChar, Len);
  pMsg->pWireCursor +=Len;
  *pMsg->pWireCursor = '\0';	/* always leave a trailing null */
  pMsg->WireLen += Len;
  return(HL7_OK);
}

int HL7IsNextSeg (HL7MSG *pMsg, HL7SegRule *pSegR)
{
  int iResult;
  HL7SEG *pSeg;

  switch (pMsg->fDirection) {
  case HL7_WIRE_TO_STRUCT:
    DB printf("\n Looking for %s, found %.3s", pSegR->azNam,pMsg->pWireCursor);
    iResult = strncmp (pMsg->pWireCursor, pSegR->azNam, HL7_SEG_NAME_LEN);
    break;
  case HL7_STRUCT_TO_WIRE:
    if (pMsg == NULL) return (HL7_NULL_ARG);
    if ((pSeg = pMsg->pCurrSeg->pNextSeg) == 0) return (HL7_END_OF_STRUCT);
    iResult = ((pSeg->pSegRul == pSegR) ? HL7_OK : !HL7_OK);
    break;
  default:
    return (HL7_BAD_DIRECTION);
    break;
  }
  if (iResult == 0) return (HL7_OK);
  else return (HL7_SEG_MISMATCH);
}

int HL7FirstSegm( HL7MSG *pMsg, char **azSegNam)
{

  if (pMsg == NULL) return (HL7_NULL_ARG);
  if (pMsg->pSegList == 0) return (HL7_EMPTY_STRUCT);

  pMsg->pCurrSeg = pMsg->pSegList;
  *azSegNam = pMsg->pCurrSeg->pSegRul->azNam; 
  return(HL7_OK);
  
}

int HL7LastSegm(HL7MSG *pMsg, char **azSegNam)
{

  if (pMsg == NULL) return (HL7_NULL_ARG);
  if (pMsg->pSegList == 0) return (HL7_EMPTY_STRUCT);

  for (pMsg->pCurrSeg = pMsg->pSegList; 
		pMsg->pCurrSeg->pNextSeg; 
				pMsg->pCurrSeg=pMsg->pCurrSeg->pNextSeg);
  *azSegNam = pMsg->pCurrSeg->pSegRul->azNam; 
  return(HL7_OK);
}

int HL7NextSegm( HL7MSG *pMsg, char **azSegNam)
{

  if (pMsg == NULL) return (HL7_NULL_ARG);
  if (pMsg->pSegList == 0) return (HL7_EMPTY_STRUCT);

  if (pMsg->pCurrSeg->pNextSeg == 0) return(HL7_END_OF_STRUCT);
  pMsg->pCurrSeg=pMsg->pCurrSeg->pNextSeg;
  *azSegNam = pMsg->pCurrSeg->pSegRul->azNam; 
  return(HL7_OK);
}

/*
//  Find a segment in an HL7 Message by its name.  Will find Z segments.
//  Does not wrap.  Sets the "current" segment for purposes of parsing.
*/
int HL7FindSegm
( 
  HL7MSG* pMsg		/* point at the tokenized HL7 msg 		*/
, const char* segName   /* the name of the segment to locate 	*/
)
{
  HL7SEG* pSegT;
						
  if (pMsg == NULL) return (HL7_NULL_ARG);
  if (pMsg->pSegList == 0) return (HL7_EMPTY_STRUCT);

  if (pMsg->pCurrSeg == 0)	/* No parsing context			*/
  {
    pSegT = pMsg->pSegList;	/* Start at the beginning	*/
  }
  else
  {
    pSegT = pMsg->pCurrSeg;	/* Otherwise, check this	*/ 
  }				/* segment first, but			*/

  if ( strcmp( pSegT->pSegRul->azNam , segName ) == 0 )		
  { 				     /* Don't locate this	  */
    if (pSegT->pNextSeg == NULL)     /* segment twice, but don't  */
        return (HL7_END_OF_STRUCT);  /* seek past the end of the  */
    pSegT = pSegT->pNextSeg;	     /* message either            */ 
  }

  
  do 
  {
    if ( strcmp( pSegT->pSegRul->azNam , segName ) == 0 )	
    { 				/* when found */
      pMsg->pCurrSeg = pSegT;	/* set parsing context		*/
      return(HL7_OK);		/*   and return			*/
    }
  } while(pSegT = pSegT->pNextSeg);

  return(HL7_END_OF_STRUCT);	 /* if not found don't			*/
				 /* change parsing context	*/
}

int HL7GetNmbrOfFlds( HL7MSG *pMsg)
{
  if (pMsg == NULL) return 0;		/* HL7_NULL_ARG */
  if (pMsg->pSegList == 0) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Empty Structure, need to Insert or Read 1st");
    return 0;	/* HL7_EMPTY_STRUCT */
  }
  return pMsg->pCurrSeg->NumFld;
}

int HL7Free(HL7MSG *pMsg)
{
  HL7SEG       *pSegT,  *pSegN;
  HL7REP       *pRepT,  *pRepN;
  HL7COMP      *pCompT, *pCompN;
  HL7SUBCOMP   *pSubT,  *pSubN;

  int i;

  if (pMsg == NULL) return( HL7_NULL_ARG);
  
  /* free buffers */
  if (pMsg->pGetBuffer != 0) free (pMsg->pGetBuffer);
  
  if ((pSegT = pMsg->pSegList) != 0) 	/* segment list exist list */
    do {
      for (i =0; i < HL7_MAX_FLD_IN_SEG; i++)     /* for each field     */
	if ((pRepT = pSegT->pFldLst[i]) != 0)
	  do {
	    if ((pCompT = pRepT->pComp) != 0)
	      do {
		if ((pSubT = pCompT->pSCompLst) != 0) 
		  do {
		    if (pSubT->pzDataStr != 0) 
		      free(pSubT->pzDataStr); /* free data */
		    pSubN = pSubT->pSubNext;
		    free(pSubT);
		  } while(pSubT = pSubN);
		pCompN = pCompT->pCompNext;
		free(pCompT);
	      } while(pCompT = pCompN);
	    pRepN = pRepT->pRepNext;	/* keep next repetition     */
	    free(pRepT);			/* free current repetition  */
	  } while(pRepT = pRepN);		/* till last repetition     */
      pSegN = pSegT->pNextSeg;		/* keep next segment        */
      free(pSegT);			/* free current segment     */
    } while (pSegT = pSegN);		/* till  last segment       */
  
  free(pMsg);
  return(HL7_OK);
}

int HL7Drop( HL7FLVR *pF)
{
	/* drop a flavor */
  
  MSGrule	*pCurRule, *pNxtRule;
  MSGterm	*pCurTerm, *pNxtTerm;

  HL7SegRule	*pCurSegR, *pNxtSegR;
  HL7FldRule	*pCurFldR, *pNxtFldR;

  if ( pF == NULL) return (HL7_NULL_ARG);

  pCurRule = pF->p1Rule;
  while ( pCurRule != NULL) {
    pCurTerm = pCurRule->p1term;
    while ( pCurTerm != NULL && pCurRule->alias==0) {
      pNxtTerm = pCurTerm->nxt;
      free( pCurTerm);
      pCurTerm = pNxtTerm;
    }
    pNxtRule = pCurRule->nxt;
    free( pCurRule);
    pCurRule = pNxtRule;
  }
  pCurSegR = pF->p1SegR;
  while ( pCurSegR != NULL) {
    pCurFldR = pCurSegR->p1fld;
    while ( pCurFldR != NULL) {
      pNxtFldR = pCurFldR->nxt;
      free( pCurFldR);
      pCurFldR = pNxtFldR;
    }
    pNxtSegR = pCurSegR->nxt;
    free( pCurSegR);
    pCurSegR = pNxtSegR;
  }

  free( pF);
}

int HL7PutFld(HL7MSG *pMsg, const char *pString, int FieldNum)
{
  HL7SEG       *pSegT;
  HL7REP       *pRepT,  *pRepN;
  HL7COMP      *pCompT, *pCompN;
  HL7SUBCOMP   *pSubT,  *pSubN;

  int i;

  if (pMsg == NULL) return( HL7_NULL_ARG);
  if ((pSegT = pMsg->pCurrSeg) == 0) return(HL7_NO_CURRENT_SEG);

  if (pString == 0) return( HL7_NULL_ARG);

  if ((FieldNum  < 1) || (FieldNum > pSegT->pSegRul->nmbrFlds)) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Bad field number %d, max is %d", FieldNum,
					pSegT->pSegRul->nmbrFlds);
    return(HL7_BAD_FLDNUM);
  }
  /* special MSH treatment */

  if (pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pBHS
     || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pFHS */
							) {
    if (FieldNum == 1) {
      /* this is just Field Separator - don't keep as a data */
      if (*pString == 0) return(HL7_FLD_TOO_SHORT);
      pMsg->FldSep = *pString;
      return(HL7_OK);
    } else if (FieldNum == 2) {
      if (*pString == 0) return(HL7_FLD_TOO_SHORT);
      strncpy( &pMsg->CmpSep, pString, 4);
      pMsg->iCurrFldI0b = FieldNum-1;
      if ((i = UnmarshallSep(pMsg, pString)) != HL7_OK) 
	return (i); 
      return(HL7_OK);
    }
  }

  if (pSegT->pFldLst[FieldNum-1] != 0) { /* field already exists, delete old */
    pRepT = pSegT->pFldLst[FieldNum-1];
    do {
      if ((pCompT = pRepT->pComp) != 0)
	do {
	  if ((pSubT = pCompT->pSCompLst) != 0) 
	    do {
	      if (pSubT->pzDataStr != 0) 
		free(pSubT->pzDataStr); /* free data */
	      pSubN = pSubT->pSubNext;
	      free(pSubT);
	    } while(pSubT = pSubN);
	  pCompN = pCompT->pCompNext;
	  free(pCompT);
	} while(pCompT = pCompN);
	pRepN = pRepT->pRepNext;	/* keep next repetition     */
      free(pRepT);			/* free current repetition  */
    } while(pRepT = pRepN);
  }
  pSegT->pFldLst[FieldNum-1] = 0;
  
  if (strcmp(pString, HL7NULL) && (strlen(pString) !=0)) { /* regular field */
    pMsg->pWireCursor = pString;
    pMsg->iCurrFldI0b = FieldNum -1;
    if ((i = UnmarshallRep(pMsg, pString + strlen(pString))) != HL7_OK)
      return (i);
  }

 /* update message type */

    if ((pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH) 
				&& (pMsg->iCurrFldI0b == 9-1)) {
    	strcpy(pMsg->cMsgType, HL7GetFld(pMsg, 9));      
        MsgType2Ecode( pMsg);
    }
  if (pMsg->pCurrSeg->NumFld < FieldNum)
    pMsg->pCurrSeg->NumFld = FieldNum;
  return(HL7_OK);
}

int HL7PutRep(HL7MSG *pMsg, char *pString, int FieldNum)
{
  HL7SEG       *pSegT;
  HL7REP       *pRepT,  *pRepN;

  int i;

  if (pMsg == NULL) return( HL7_NULL_ARG);
  if ((pSegT = pMsg->pCurrSeg) == 0) return(HL7_NO_CURRENT_SEG);
  
  if ((FieldNum  < 1) || (FieldNum > pSegT->pSegRul->nmbrFlds)) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Bad field number %d, max is %d", FieldNum,
					pSegT->pSegRul->nmbrFlds);
    return(HL7_BAD_FLDNUM);
  }
  if (pString == NULL) return (HL7_NULL_ARG);
  if (strlen(pString) == 0) return (HL7_OK); /* clone a HL7PutRepN for empty
					      repatitions (see HL7PutCompN) */

  if (pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pBHS
     || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pFHS */
							) 
    if (FieldNum == 1) {
      /* this is just Field Separator - don't keep as a data */
      pMsg->FldSep = *pString;
      return(HL7_OK);
    }
  
  pMsg->iCurrFldI0b = FieldNum-1;
  pMsg->pCurrCom=0;
  pMsg->pCurrSub=0; 
  /* allocate new repetition*/
  
  if ((pRepN = (HL7REP *) malloc(sizeof(HL7REP))) == 0)	
	return (HL7_NO_MEMORY);
  
  
  if ((pRepT = pSegT->pFldLst[FieldNum-1]) != 0) { 
    /* field already exists */
    /* traverse to last repetition */
    for (;pRepT->pRepNext;pRepT=pRepT->pRepNext);
    pRepN->RepNum = pRepT->RepNum + 1;
    pRepT->pRepNext = pRepN; 	        /* append to list */
  } else {
    (pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = pRepN;
    pRepN->RepNum = 1;
  }
  pMsg->pCurrRep = pRepN;
  pRepN->pRepNext = 0;
  pMsg->pWireCursor=pString;
  if ((i = UnmarshallComp(pMsg, pString +strlen(pString))) != HL7_OK) 
    return (i);
  return(HL7_OK);
}

int HL7PutComp(HL7MSG *pMsg, char *pString, int FieldNum)
{
  HL7SEG       *pSegT;
  HL7REP       *pRepT;
  HL7COMP      *pCompT, *pCompN;

  int i;

  if (pMsg == NULL) return( HL7_NULL_ARG);
  if ((pSegT = pMsg->pCurrSeg) == 0) return(HL7_NO_CURRENT_SEG);
  
  if ((FieldNum  < 1) || (FieldNum > pSegT->pSegRul->nmbrFlds)) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Bad field number %d, max is %d", FieldNum,
					pSegT->pSegRul->nmbrFlds);
    return(HL7_BAD_FLDNUM);
  }
  if (pString == NULL) return (HL7_NULL_ARG);
  if (strlen(pString) == 0) return (HL7_OK); /* use HL7PutCompN to skip out to
						next non-empty comp. */

  if (pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pBHS
     || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pFHS */
							) 
    if (FieldNum == 1) {
      /* this is just Field Separator - don't keep as a data */
      pMsg->FldSep = *pString;
      return(HL7_OK);
    }

  pMsg->iCurrFldI0b = FieldNum-1;
  pMsg->pCurrSub=0; 
  /* allocate new repetition*/
  
  
   
  if ((pRepT = pSegT->pFldLst[FieldNum-1]) != 0) { 
    /* field already exists */
    /* traverse to last repetition */
    for (;pRepT->pRepNext;pRepT=pRepT->pRepNext);
  } else {
    if ((pRepT = (HL7REP *) calloc( 1, sizeof(HL7REP))) == 0)	
      return (HL7_NO_MEMORY);
    (pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = pRepT;
    pRepT->RepNum = 1;
    pRepT->pRepNext = 0;
  }
  pMsg->pCurrRep = pRepT;

  if ((pCompN = (HL7COMP *) malloc(sizeof(HL7COMP))) == 0)
      return (HL7_NO_MEMORY);

  if ((pCompT = pRepT->pComp) == 0) {
    pMsg->pCurrRep->pComp = pCompN;
    pMsg->pCurrRep->CompNum = 1;
    pCompN->CompIndex = 1;
  } else {
    /* traverse component list */
    for(;pCompT->pCompNext;pCompT=pCompT->pCompNext);
    pCompT->pCompNext = pCompN;
    pCompN->CompIndex = pCompT->CompIndex +1;
    pMsg->pCurrRep->CompNum  =pCompN->CompIndex;
  }
  pMsg->pCurrCom = pCompN;
  pCompN->pCompNext = 0;
  pCompN->pSCompLst = 0;
  
  pMsg->pWireCursor=pString;
  if ((i = UnmarshallSub(pMsg, pString +strlen(pString))) != HL7_OK) 
    return (i);

 /* update message type */

  if ((pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH) 
					&& (pMsg->iCurrFldI0b == 9-1)) {
    strcpy( pMsg->cMsgType, HL7GetFld( pMsg, 9));
    MsgType2Ecode( pMsg );      
  }
  return(HL7_OK);
}

int HL7PutCompN(HL7MSG *pMsg, char *pString, int FieldNum, int CompNum)
{
  HL7SEG       *pSegT;
  HL7REP       *pRepT;
  HL7COMP      *pCompT, *pCompN;

  int i;

  if (pMsg == NULL) return( HL7_NULL_ARG);
  if ((pSegT = pMsg->pCurrSeg) == 0) return(HL7_NO_CURRENT_SEG);
  
  if ((FieldNum  < 1) || (FieldNum > pSegT->pSegRul->nmbrFlds)) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Bad field number %d, max is %d", FieldNum,
					pSegT->pSegRul->nmbrFlds);
    return(HL7_BAD_FLDNUM);
  }  
  if (pString == NULL) return (HL7_NULL_ARG);
  if (strlen(pString) == 0) return (HL7_OK);

  if (pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pBHS
     || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pFHS */
							) 
    if (FieldNum == 1) {
      /* this is just Field Separator - don't keep as a data */
      pMsg->FldSep = *pString;
      return(HL7_OK);
    }

  pMsg->iCurrFldI0b = FieldNum-1;
  pMsg->pCurrSub=0; 
  /* allocate new repetition*/
  
  
   
  if ((pRepT = pSegT->pFldLst[FieldNum-1]) != 0) { 
    /* field already exists */
    /* traverse to last repetition */
    for (;pRepT->pRepNext;pRepT=pRepT->pRepNext);
  } else {
    if ((pRepT = (HL7REP *) calloc( 1, sizeof(HL7REP))) == 0)	
      return (HL7_NO_MEMORY);
    (pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = pRepT;
    pRepT->RepNum = 1;
    pRepT->pRepNext = 0;
  }
  pMsg->pCurrRep = pRepT;

  if ((pCompN = (HL7COMP *) malloc(sizeof(HL7COMP))) == 0)
      return (HL7_NO_MEMORY);

  if ((pCompT = pRepT->pComp) == 0) {
    pMsg->pCurrRep->pComp = pCompN;
    pMsg->pCurrRep->CompNum = CompNum;
    pCompN->CompIndex = CompNum;
  } else {
    /* traverse component list */
    for(;pCompT->pCompNext;pCompT=pCompT->pCompNext);
    pCompT->pCompNext = pCompN;
    pCompN->CompIndex = CompNum;
    pMsg->pCurrRep->CompNum  =pCompN->CompIndex;
  }
  pMsg->pCurrCom = pCompN;
  pCompN->pCompNext = 0;
  pCompN->pSCompLst = 0;
  
  pMsg->pWireCursor=pString;
  if ((i = UnmarshallSub(pMsg, pString +strlen(pString))) != HL7_OK) 
    return (i);

 /* update message type */

  if ((pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH) 
				&& (pMsg->iCurrFldI0b == 9-1)) {
    strcpy( pMsg->cMsgType, HL7GetFld( pMsg, 9));
    MsgType2Ecode( pMsg );      
  }
  return(HL7_OK);
}

int HL7PutSub(HL7MSG *pMsg, char *pString, int FieldNum)
{
  HL7SEG       *pSegT;
  HL7REP       *pRepT;
  HL7COMP      *pCompT;
  HL7SUBCOMP   *pSubT,  *pSubN;


  if (pMsg == NULL) return(HL7_NULL_ARG);
  if ((pSegT = pMsg->pCurrSeg) == 0) return(HL7_NO_CURRENT_SEG);
  
  if ((FieldNum  < 1) || (FieldNum > pSegT->pSegRul->nmbrFlds)) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Bad field number %d, max is %d", FieldNum,
					pSegT->pSegRul->nmbrFlds);
    return(HL7_BAD_FLDNUM);
  }  
  if (pString == NULL) return (HL7_NULL_ARG);
  if (strlen(pString) == 0) return (HL7_OK); /* clone a HL7PutSubN for empty
					     subcomp. (see HL7PutCompN) */ 

  if (pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pBHS
     || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pFHS */
							) 
    if (FieldNum == 1) {
      /* this is just Field Separator - don't keep as a data */
      pMsg->FldSep = *pString;
      return(HL7_OK);
    } 

  pMsg->iCurrFldI0b = FieldNum-1;

   
  if ((pRepT = pSegT->pFldLst[FieldNum-1]) != 0) { 
    /* field already exists */
    /* traverse to last repetition */
    for (;pRepT->pRepNext;pRepT=pRepT->pRepNext);
  } else {
    if ((pRepT = (HL7REP *) malloc(sizeof(HL7REP))) == 0)	
      return (HL7_NO_MEMORY);
    (pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = pRepT;
    pRepT->RepNum = 1;
    pRepT->pRepNext = 0;
  }
  pMsg->pCurrRep = pRepT;

  if ((pCompT = pRepT->pComp) == 0) {
    if ((pCompT = (HL7COMP *) malloc(sizeof(HL7COMP))) == 0)
      return (HL7_NO_MEMORY);
    pMsg->pCurrRep->pComp = pCompT;
    pMsg->pCurrRep->CompNum = 1;
    pCompT->CompIndex = 1;
    pCompT->pCompNext = 0;
    pCompT->pSCompLst = 0;
  } else {
    /* traverse component list */
    for(;pCompT->pCompNext;pCompT=pCompT->pCompNext);
  }
  pMsg->pCurrCom = pCompT;

  
  if ((pSubN = (HL7SUBCOMP *) malloc(sizeof(HL7SUBCOMP))) == 0)
    return (HL7_NO_MEMORY);

  if ((pSubT = pCompT->pSCompLst) == 0) {
    pMsg->pCurrCom->pSCompLst = pSubN;
    pCompT->pSCompLst=pSubT;
    pCompT->SubCompNum = 1;
    pSubN->SubCompIndex = 1;
  } else {
    /* traverse subcomponent list */
    for (;pSubT->pSubNext;pSubT=pSubT->pSubNext);
    pSubT->pSubNext = pSubN;
    pSubN->SubCompIndex = pSubT->SubCompIndex +1;
    pCompT->SubCompNum = pSubN->SubCompIndex;
  }

  pMsg->pCurrSub = pSubN;
  pMsg->pCurrSub->pSubNext = 0;
    
  if ((pSubN->pzDataStr = (char *)malloc(strlen(pString)+1)) == NULL)
    return (HL7_NO_MEMORY);
  strncpy(pSubN->pzDataStr, pString, strlen(pString));
  pSubN->SubLen = strlen(pString);;
  *(pSubN->pzDataStr + pSubN->SubLen) = '\0';
  if (pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH) {
  /*  if (pMsg->iCurrFldIndex == 9-1) 
      pMsg->cMsgEcode = MsgEvn2code(pMsg, pSubN->pzDataStr);
  */
    if (pMsg->iCurrFldI0b == 0) { 
      pMsg->CmpSep = *(pString);			
      pMsg->RepSep = *(pString+1);	
      pMsg->EscSep = *(pString+2);	
      pMsg->SubSep = *(pString+3); 	
    }
  }
  return(HL7_OK);
}

int HL7PutSubN( HL7MSG *pMsg, char *pString, int FieldNum, int SubNum)
{
  HL7SEG       *pSegT;
  HL7REP       *pRepT;
  HL7COMP      *pCompT;
  HL7SUBCOMP   *pSubT,  *pSubN;


  if (pMsg == NULL) return( HL7_NULL_ARG);
  if ((pSegT = pMsg->pCurrSeg) == 0) return(HL7_NO_CURRENT_SEG);
  
  if ((FieldNum  < 1) || (FieldNum > pSegT->pSegRul->nmbrFlds)) {
    sprintf( pMsg->ErrorLevel, ERR_PREFIX, ERR_E);
    sprintf( pMsg->ErrorMessage, "Bad field number %d, max is %d", FieldNum,
					pSegT->pSegRul->nmbrFlds);
    return(HL7_BAD_FLDNUM);
  }  
  if (pString == NULL) return (HL7_NULL_ARG);
  if (strlen(pString) == 0) return (HL7_OK); /* clone a HL7PutSubN for empty
					     subcomp. (see HL7PutCompN) */ 

  if (pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH
  /* || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pBHS
     || pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pFHS */
							) 
    if (FieldNum == 1) {
      /* this is just Field Separator - don't keep as a data */
      pMsg->FldSep = *pString;
      return(HL7_OK);
    } 

  pMsg->iCurrFldI0b = FieldNum-1;

   
  if ((pRepT = pSegT->pFldLst[FieldNum-1]) != 0) { 
    /* field already exists */
    /* traverse to last repetition */
    for (;pRepT->pRepNext;pRepT=pRepT->pRepNext);
  } else {
    if ((pRepT = (HL7REP *) malloc(sizeof(HL7REP))) == 0)	
      return (HL7_NO_MEMORY);
    (pMsg->pCurrSeg)->pFldLst[pMsg->iCurrFldI0b] = pRepT;
    pRepT->RepNum = 1;
    pRepT->pRepNext = 0;
  }
  pMsg->pCurrRep = pRepT;

  if ((pCompT = pRepT->pComp) == 0) {
    if ((pCompT = (HL7COMP *) malloc(sizeof(HL7COMP))) == 0)
      return (HL7_NO_MEMORY);
    pMsg->pCurrRep->pComp = pCompT;
    pMsg->pCurrRep->CompNum = 1;
    pCompT->CompIndex = 1;
    pCompT->pCompNext = 0;
    pCompT->pSCompLst = 0;
  } else {
    /* traverse component list */
    for(;pCompT->pCompNext;pCompT=pCompT->pCompNext);
  }
  pMsg->pCurrCom = pCompT;

  
  if ((pSubN = (HL7SUBCOMP *) malloc(sizeof(HL7SUBCOMP))) == 0)
    return (HL7_NO_MEMORY);

  if ((pSubT = pCompT->pSCompLst) == 0) {
    pMsg->pCurrCom->pSCompLst = pSubN;
    pCompT->pSCompLst=pSubT;
    pCompT->SubCompNum = SubNum;
    pSubN->SubCompIndex = SubNum;
  } else {
    /* traverse subcomponent list */
    for (;pSubT->pSubNext;pSubT=pSubT->pSubNext);
    pSubT->pSubNext = pSubN;
    pSubN->SubCompIndex = SubNum; 
    pCompT->SubCompNum = pSubN->SubCompIndex;
  }

  pMsg->pCurrSub = pSubN;
  pMsg->pCurrSub->pSubNext = 0;
    
  if ((pSubN->pzDataStr = (char *)malloc(strlen(pString)+1)) == NULL)
    return (HL7_NO_MEMORY);
  strncpy(pSubN->pzDataStr, pString, strlen(pString));
  pSubN->SubLen = strlen(pString);;
  *(pSubN->pzDataStr + pSubN->SubLen) = '\0';
  if (pMsg->pCurrSeg->pSegRul == pMsg->pFlvr->HL7pMSH) {
  /*  if (pMsg->iCurrFldIndex == 9-1) 
      pMsg->cMsgEcode = MsgEvn2code(pMsg, pSubN->pzDataStr);
  */
    if (pMsg->iCurrFldI0b == 0) { 
      pMsg->CmpSep = *(pString);			
      pMsg->RepSep = *(pString+1);	
      pMsg->EscSep = *(pString+2);	
      pMsg->SubSep = *(pString+3); 	
    }
  }
  return(HL7_OK);
}

	/* validate a field in the current segment */
int HL7ValidateFld( HL7MSG *pMsg, int f)
{
  int r, i, l, fldPresent = 0;
  char *pC;
  HL7SEG *pCurSeg;
  HL7REP *pCurRep;
  HL7SegRule *pCurSegRul;
  HL7FldRule *pCurFldRul;

  if ( pMsg == NULL) return (HL7_NULL_ARG);
  if ( f < 1) return (HL7_FLD_MISSING);	/* for now */

  pCurSeg = pMsg->pCurrSeg;		/* looking at the field in the current seg */
  pCurSegRul = pCurSeg->pSegRul;	/* rules for this segment */
  if ( f > pCurSegRul->nmbrFlds) return (HL7_TOO_MANY_FIELDS);
  pCurFldRul = pCurSegRul->p1fld;	/* 1st field rule, count thru list */
					/* chain down to the correct field */
  for (i=1; i<f; i++) pCurFldRul = pCurFldRul->nxt;

  r = 1;

  /* pCurRep = pCurSeg->pFldLst[f-1] */
  /* get field (each rep) check length */
  pC = HL7GetRep( pMsg, f, r);
  if (pC != NULL) {
    l = strlen( pC);
  } else {
    l = 0;
  }

  if ( l > pCurFldRul->len) return (!HL7_OK);
  if ( l > 0) fldPresent =1;

  /* switch (pCurFldRul->typ ) {
     case ST :
     default : 
     } ; */

  /* number of reps ok */
  

  /* required?, was it present */
  if ( pCurFldRul->reqOpt == 1 && fldPresent == 0) return (!HL7_OK);

  return ( HL7_OK);
}

char *HL7EncodeEsc( HL7MSG *pMsg, char *pStrIn, char *pStrOut, int em) 
/* Encode special character, (field, comp, repetition, escape and sub-comp
   seperators
	em is the ecoding mask. 1 field, 2 comp, 4 rep, 8 esc, 16 sub_comp 
				32 hex */
{
  char *rtn = pStrOut;
  int hex;
  if (( pStrOut != 0) && ( pStrIn != pStrOut)) *pStrOut = 0;
  if (pStrIn == 0) return (rtn);	/* did they try to pass a null string?*/

  for (; *pStrIn != 0; pStrIn++) {
    if ( *pStrIn == pMsg->FldSep && (em & 1)) {
      *pStrOut++ = pMsg->EscSep;
      *pStrOut++ = 'F';
      *pStrOut++ = pMsg->EscSep;
    }
    else if ( *pStrIn == pMsg->CmpSep && (em & 2)) {
      *pStrOut++ = pMsg->EscSep;
      *pStrOut++ = 'S';
      *pStrOut++ = pMsg->EscSep;
    }
    else if ( *pStrIn == pMsg->RepSep && (em & 4)) {
      *pStrOut++ = pMsg->EscSep;
      *pStrOut++ = 'R';
      *pStrOut++ = pMsg->EscSep;
    }
    else if ( *pStrIn == pMsg->EscSep && (em & 8)) {
      *pStrOut++ = pMsg->EscSep;
      *pStrOut++ = 'E';
      *pStrOut++ = pMsg->EscSep;
    }
    else if ( *pStrIn == pMsg->SubSep && (em & 16)) {
      *pStrOut++ = pMsg->EscSep;
      *pStrOut++ = 'T';
      *pStrOut++ = pMsg->EscSep;
    }
    else if ( (*pStrIn < 20 || *pStrIn >126) && (em & 32)) {
      *pStrOut++ = pMsg->EscSep;
      *pStrOut++ = 'X';
      hex = *pStrIn;
      sprintf( pStrOut, "%2.2x", hex); pStrOut++; pStrOut++;
      *pStrOut++ = pMsg->EscSep;
    }
    else *pStrOut++ = *pStrIn;
  }
  *pStrOut = 0;
  return (rtn);
}

char *HL7DecodeEsc( HL7MSG *pMsg, char *pStrIn, char *pStrOut, int em) 
/* Decode special character, (field, comp, repetition, escape and sub-comp
   seperators
	em is the decoding mask. 1 field, 2 comp, 4 rep, 8 esc, 16 sub_comp */
{
  char *rtn = pStrOut;
  if (( pStrOut !=0) && ( pStrIn != pStrOut )) *pStrOut = 0;	/* in case null */
			/* decodes can be done in place, encodes can't */
  if (pStrIn == 0) return (rtn);	/* any real work ? */

  for (; *pStrIn != 0; pStrIn++) {
    if ( *pStrIn == pMsg->EscSep && *(pStrIn+2) == pMsg->EscSep) {
      if ( (em & 1) && *(pStrIn+1) == 'F') {
	*pStrOut++ = pMsg->FldSep;
	pStrIn += 2;
      }
      else if (  (em & 2) && *(pStrIn+1) =='S') {
        *pStrOut++ = pMsg->CmpSep;
        pStrIn += 2;
      }
      else if ( (em & 4) && *(pStrIn+1) == 'R') {
	*pStrOut++ = pMsg->RepSep;
	pStrIn += 2;
      }
      else if ( (em & 8) && *(pStrIn+1) == 'E') {
	*pStrOut++ = pMsg->EscSep;
	pStrIn += 2;
      }
      else if ( (em & 16) && *(pStrIn+1) == 'T') {
	*pStrOut++ = pMsg->SubSep;
	pStrIn += 2;
      }
      else { *pStrOut++ = *pStrIn++; 	/* pass thru Highlighting/normal */
	*pStrOut++ = *pStrIn++;
	*pStrOut++ = *pStrIn;
      }
    }
    else *pStrOut++ = *pStrIn;
  }
  *pStrOut = 0;
  return (rtn);
}

void hl7dmprule( HL7MSG *pMsg ) {
  MSGterm *dmpTerm;
  dmpTerm = pMsg->pRule->p1term;
  while ( dmpTerm != NULL) {
    if (dmpTerm->typ == 0) {	/* display Seg */
      printf( "%s %d  ", dmpTerm->pSegR->azNam, dmpTerm);
    }
    else {
      printf( "%c %d", dmpTerm->typ);
      if (dmpTerm->typ==']' || dmpTerm->typ=='}' || dmpTerm->typ=='>')
	printf( "\n");
    }
    dmpTerm = dmpTerm->nxt;
  } 
}

int HL7sErrMsg(HL7MSG *pMsg, char *space)
{
  return sprintf( space, "%s %s", pMsg->ErrorLevel, pMsg->ErrorMessage);
}

int HL7fErrMsg( HL7MSG *pMsg, FILE* fd )
{
  return fprintf( fd, "%s %s", pMsg->ErrorLevel, pMsg->ErrorMessage);
}

char *HL7ErrTxt(HL7MSG *pMsg, int iHL7ErrNo)
{

  int low,high,mid;
  char *pMsgName;
  
  /* perform binary search in Error messages list */
  low = 0;
  high = ERR_List_Len - 1;
  while (low <= high) {
    mid = (low + high)/2;
    if (iHL7ErrNo < ErrMsgList[mid].iErrIndex)
      high = mid -1;
    else if (iHL7ErrNo > ErrMsgList[mid].iErrIndex)
           low = mid +1;
         else
	   goto found;		        /* found message in list            */
  }
  
  return(FatalError);

found:
  switch (ErrMsgList[mid].uSevLevel) {
  case ERR_S:
    sprintf(pMsg->ErrorBuffer,ERR_PREFIX, ERR_S); break; 	
  case ERR_E:
    sprintf(pMsg->ErrorBuffer,ERR_PREFIX, ERR_E); break;
  case ERR_W:
    sprintf(pMsg->ErrorBuffer,ERR_PREFIX, ERR_W); break;	
  default:
    sprintf(pMsg->ErrorBuffer,ERR_PREFIX, ERR_E); break;
  }

  /* */
  pMsgName = (pMsg->cMsgRcode);
  pMsgName = (*pMsgName) ? (pMsgName) : "";
  if ( ErrMsgList[mid].uObjMask == (MSG_ERR) )   /*  */
    sprintf(pMsg->ErrorBuffer + strlen(pMsg->ErrorBuffer),
	    ErrMsgList[mid].pcMsgText);
  else if (ErrMsgList[mid].uObjMask == (MSG_ERR|SEG_ERR)) 
	   sprintf(pMsg->ErrorBuffer + strlen(pMsg->ErrorBuffer),
		   ErrMsgList[mid].pcMsgText,
		   pMsgName, pMsg->pCurrSeg->pSegRul);
  else if ( ErrMsgList[mid].uObjMask == (MSG_ERR|SEG_ERR|FLD_ERR) )
	   sprintf(pMsg->ErrorBuffer + strlen(pMsg->ErrorBuffer),
		   ErrMsgList[mid].pcMsgText,
		   pMsgName,
		   pMsg->pCurrSeg->pSegRul);
  else if ( ErrMsgList[mid].uObjMask == (MSG_ERR |SEG_ERR|FLD_ERR|
					  REP_ERR) )
	   sprintf(pMsg->ErrorBuffer + strlen(pMsg->ErrorBuffer),
		   ErrMsgList[mid].pcMsgText,
		   pMsgName,
		   pMsg->pCurrSeg->pSegRul,
		   pMsg->iCurrFldI0b);
  else if ( ErrMsgList[mid].uObjMask == (MSG_ERR |SEG_ERR|FLD_ERR|
					  REP_ERR|COM_ERR) )
	   sprintf(pMsg->ErrorBuffer + strlen(pMsg->ErrorBuffer),
		   ErrMsgList[mid].pcMsgText,
		   pMsgName,
		   pMsg->pCurrSeg->pSegRul,
		   pMsg->iCurrFldI0b,
		   pMsg->pCurrRep->RepNum);	
  else if ( ErrMsgList[mid].uObjMask == (MSG_ERR |SEG_ERR|FLD_ERR|
					  REP_ERR|COM_ERR|SUB_ERR) ) 
	   sprintf(pMsg->ErrorBuffer + strlen(pMsg->ErrorBuffer),
		   ErrMsgList[mid].pcMsgText,
		   pMsgName,
		   pMsg->pCurrSeg->pSegRul,
		   pMsg->iCurrFldI0b,
		   pMsg->pCurrRep->RepNum,
		   pMsg->pCurrCom->CompIndex);
  else
    if ( pMsg != 0)
      if (pMsg->pCurrSeg !=0)
	   sprintf(pMsg->ErrorBuffer + strlen(pMsg->ErrorBuffer),
		   ErrMsgList[mid].pcMsgText,
		   pMsg->pCurrSeg->pSegRul,
		   pMsg->pWireCursor);	

	   return(pMsg->ErrorBuffer);	
}

