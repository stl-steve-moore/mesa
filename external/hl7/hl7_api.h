
/* hl7_api.h */
/* Fundamental definition for HL7ImEx.
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
 */

/* Change history
 *
 *$Log: hl7_api.h,v $
 *Revision 1.6  2001/05/21 16:29:01  aeh
 *Update pSegRuleFind definition to take the segment name
 *as a const char*.
 *
 *Revision 1.5  2001/05/18 20:31:18  smm
 *Change some functions to take const char* inputs.
 *Makes other MESA methods able to call these functions
 *without resorting to tricks.
 *
 *Revision 1.4  2000/11/08 15:00:22  smm
 *Change the macro SIZE to HL7_SIZE to get around conflicts
 *with MSVC++ compiler/include files.
 *
 *Revision 1.3  1999/11/11 23:40:14  smm
 *Add a prototype for HL7ValidateFld.
 *
 *Revision 1.2  1999/06/30 20:11:13  smm
 *Put #ifdefs around the definitions of TRUE/FALSE.  These are
 *typically defined elsewhere.
 *
 *Revision 1.1  1999/06/22 14:45:44  dfs
 *
 *I added the hl7_api files needed to make the MESA programs.
 *
 *FDS
 *
 * Revision 3.a  1995 May 03		Allen Rueter
 * Allow for more than parse table!, for a simple HL-7 engine/converter
 * change pointers to segment, string constants.
 *
 * Revision 2.a  1994/04/03           Allen Rueter
 * Drop External Rule routines and coded constants for parse table built by 
 * HL7Init to support hl7 v2.1 and v2.2
 * Dropped lots of macros for debugging clarity
 *
 * Revision 1.3  1993/03/26  02:56:55  cherniz
 * HL7GetField ->HL7GetFld
 * add macro to convert HL7GetField ->HL7GetFld automatically
 *
 * Revision 1.2  1993/03/08  22:14:32  cherniz
 * make AIX XL C happy
 *
 * Revision 1.1  1993/03/01  21:51:54  cherniz
 * Initial revision
 */

/*                                                                        */

#ifndef HL7_API_IS_IN
#define  HL7_API_IS_IN

#ifdef __cplusplus
extern "C" {
#endif

#include <stdio.h>

typedef size_t   HL7_SIZE;

#define HL7_MSGTYPE_LEN           7                /* Len of MSG TYPE     */
						   /* ex: 'ADT^A01        */
#define HL7_MSGTYPE_LEFT          3                /* Len of left part of */
                                                   /*MSGTYPE ~'ADT'       */
#define HL7_MSGTYPE_RIGHT         3                /* Len of right part of*/
						   /*MSGTYPE ~'A01'       */
#define HL7_CODE_LEN              3                /* Len of CODE         */
#define HL7_SEG_NAME_LEN          3                /* Len of Segment Name */
#define HL7_FLD_TYPE_LEN          2                /* Len of Field type   */
#define HL7_ENCODE_FLD_LEN        4                /* Len of Encded Fld   */
#define HL7_SEG_SEP               0x0D             /* CR character  FIXED */
#define HL7_MAX_FLD_IN_SEG        64               /* Arbit Max # of Flds */
#define HL7_REP_MAX               50               /* Arbit Max # of occur*/
#define ERR_LEN                   80               /* max length of errmsg*/
#ifndef TRUE
#define TRUE                      1                /* Usual               */
#define FALSE                     0                /* Usual               */
#endif
#define STATIC                    0                /* static strategy mem */
                                                   /* allacation for segm.*/
#define DYNAMIC                   1                /*dynamic strategy     */

/* All HL7 Error Codes */

#define HL7_OK                    0x00000000

/* error codes need to be > 256 for the do*B routines */
/* Warnings, Messages, Return Values */
#define HL7_SEG_MISMATCH          0x00000101
#define HL7_END_OF_STRUCT         0x00000102
#define HL7_EMPTY_STRUCT          0x00000103
#define HL7_EMPTY_SEG_PTR         0x00000104
#define HL7_ZZZ                   0x00000105

/* Errors */
#define HL7_NO_CURRENT_SEG        0x00000205
#define HL7_BAD_FLDNUM            0x00000206
#define HL7_MSG_INCOMPLETE        0x00000207
#define HL7_WIRE_OVERFLOW         0x00000208
#define HL7_NULL_ARG              0x00000209

/* "System" Errors */
#define HL7_NO_MEMORY             0x00001001
#define HL7_EMPTY_SEG_DEF         0x00001002
#define HL7_BAD_DIRECTION         0x00001003

/* Parse Errors */
#define HL7_BAD_SEG_NAME          0x00002001
#define HL7_SEG_NAME_UNDEFINED	  0x00002002

#define HL7_SEG_TOO_LONG          0x00002102
#define HL7_SEG_TOO_SHORT         0x00002103
#define HL7_BAD_MSG_TYPE          0x00002104
#define HL7_BAD_FLD_SEP           0x00002106
#define HL7_PARSE_NESTING	  0x00002107
#define HL7_SEG_OUTOF_ORDER	  0x00002108
#define HL7_SEG_MISSING		  0x00002109
#define HL7_TOO_MANY_FIELDS	  0x0000210A

#define HL7_STR_TOO_SHORT         0x00002201
#define HL7_STR_TOO_LONG          0x00002202
#define HL7_BAD_STR               0x00002203

/* Field Errors  */    

#define HL7_FLD_TOO_LONG          0x00003101
#define HL7_FLD_TOO_SHORT         0x00003102
#define HL7_FLD_MISSING           0x00003103
#define HL7_BAD_NUM               0x00003105
#define HL7_BAD_STRING            0x00003107
#define HL7_BAD_TEXT              0x00003109
#define HL7_BAD_DATE              0x00003111
#define HL7_BAD_TIME              0x00003113
#define HL7_BAD_TSTAMP            0x00003115
#define HL7_BAD_PNAME             0x00003117
#define HL7_BAD_TELEPH            0x00003119
#define HL7_BAD_ID                0x00003121
#define HL7_BAD_SI                0x00003123
#define HL7_BAD_CM                0x00003125
#define HL7_BAD_TAG               0x00003200

/*
 * Field attributes
 *
 */

#define HL7_FLD_NO_MAX            0                /* no limit for field  */
                                                   /* occurences          */

#define HL7_STRUCT_TO_WIRE        0
#define HL7_WIRE_TO_STRUCT        1

#define EAT(A, B)      if ((s = HL7Eat(pMsg, A)) != HL7_OK) return (B)

/****      GLOBAL VARIABLES                                               */

/* Rules for each field                */

typedef struct _HL7FldRule{
  unsigned int	len;				/* Max Field length    */
  unsigned int	typ;				/* Type of Field       */
  unsigned int	reqOpt;				/* Required/Opt.       */
  unsigned int	nmbrRep;			/* Repetition          */
  struct _HL7FldRule *nxt;
} HL7FldRule;

/* Rules for segments				*/

typedef struct _HL7SegRule{
  char		azNam[HL7_SEG_NAME_LEN + 1];   /* Segment Name + null  */
  int		nmbrFlds;			/* Actual # of Flds      */
  HL7FldRule   *p1fld;				/* link to of Fld attrib.*/
  struct _HL7SegRule *nxt;			/* link to next Segment  */
} HL7SegRule;

typedef struct _MSGterm {
  int		typ;			/* 0=Seg, otherwise {[<()>]}	*/
  HL7SegRule	*pSegR;			/* ptr to Rule when typ=0	*/
  struct _MSGterm *pLpTrm;		/* ptr back for loops <{PID PV1}> */
  struct _MSGterm *nxt;
} MSGterm;

typedef struct _MSGrule {
  struct _MSGrule	*nxt;
  MSGterm	*p1term;
  char		evnt[HL7_MSGTYPE_LEN+1];	/* BAR^P01	*/
  char		alias;
} MSGrule;

typedef struct _HL7flvr {
  MSGrule *p1Rule;			/* pointer to 1st message rule of list*/
  HL7SegRule *p1SegR;			/* pointer to 1st seg def of list */
  HL7SegRule *HL7pMSH;			/* inited by HL7Init	*/
  HL7SegRule *HL7pMSA;			/* inited by HL7Init	*/
  HL7SegRule *HL7pBHS;			/* inited by HL7Init	*/
  HL7SegRule *HL7pFHS;			/* inited by HL7Init	*/
  HL7SegRule *HL7pZzz;			/* inited by HL7Init	*/
} HL7FLVR;


/*************************************************************************/

typedef struct _HL7SubComp {
     struct _HL7SubComp   *pSubNext;            /* next subcomp   on comp   */
     int  SubCompIndex;		                /* subcomp index            */
     HL7_SIZE SubLen;                           /* length of subcomponent   */
     char *pzDataStr;                           /* ptr on subcomponent =    */
						/* actual data -null  str   */
} HL7SUBCOMP;

typedef struct _HL7Comp {
     struct _HL7Comp      *pCompNext;           /* next component on field  */
     int                  CompIndex;            /* component index          */
     int                  SubCompNum;           /* number of subcomponents  */
     HL7SUBCOMP           *pSCompLst;           /* pointer to list of subcom*/
} HL7COMP;

/* list of repetitions. A field with single occurence is singular case of    */
/* repetition. ~ Number of repetition is 1.                                 */

typedef struct _HL7Rep {
     struct _HL7Rep *pRepNext;                  /* next occurences          */
     int RepNum;		                /* number of repetition (1) */
     int CompNum;		                /* amount of component (1)  */
     struct _HL7Comp *pComp;                    /* pointer to list of compon*/
} HL7REP;

typedef struct _HL7Seg {
     struct _HL7Seg   *pNextSeg;                /* next segment             */
     HL7SegRule	*pSegRul;	                /* ptr segment rule         */
     int       NumFld;                          /* number of fields         */
     HL7REP *pFldLst[HL7_MAX_FLD_IN_SEG];       /* p's to field lists       */
} HL7SEG;

typedef struct _HL7MsgH {		/* HL7 message handle               */
     HL7SEG     *pSegList;              /* point to first node in seg-list  */
     HL7SEG     *pCurrSeg;              /* current position in seg-list     */
     int        iCurrFldI0b;	        /* current field index (0 based ~1) */
     HL7FLVR	*pFlvr;			/* pointer to Flavor of HL7	    */
     HL7REP     *pCurrRep;    		/* curernt position in repetit-list */
     HL7COMP    *pCurrCom;    		/* curernt position in comp-list    */
     HL7SUBCOMP *pCurrSub;    		/* curernt position in subcomp-list */
     char	cMsgType[HL7_MSGTYPE_LEN+1];/* ADT^A01, BAR^P01, ...        */
     char       cMsgRcode[HL7_MSGTYPE_LEN]; /* Rule ADTA01,BARP01,ACK,...   */
     MSGrule	*pRule;			/* Rule to use			    */
     char       FldSep;			/* HL7 Field Separator              */
     char       CmpSep;			/* HL7 component sep.               */
     char       RepSep;			/* HL7 repetition sep.              */
     char       EscSep;			/* HL7 escape separator             */
     char       SubSep;			/* HL7 sub-comp. sep.               */
     int        fDirection;	        /* coding/decoding flag             */
     char       *pWire; 		/* wire user provided wire          */
     char       *pWireCursor;		/* current position in wire         */
     char       ErrorBuffer[ERR_LEN+15]; /* buffer for error output         */
     char	ErrorLevel[15];
     char       ErrorMessage[ERR_LEN+1]; /* buffer for error message        */
     HL7_SIZE   MaxWireLen;		/* max length for wire buffer       */
     HL7_SIZE   WireLen;		/* actual Wire Length               */
     char       *pGetBuffer;	        /* buffer for i/o operations        */
     HL7_SIZE   GetBufferSize;          /* size of buffer for i/o operat.   */
     int	bhsPresent;
     int	fhsPresent;
} HL7MSG;

/*
HL7REP *pHL7freeRepL=NULL;		/-* base pointers for optional *-/
HL7COMP *pHL7freeCompL=NULL;		/-* memory recycling *-/
HL7SUBCOMP *pHL7freeSubcL=NULL;
*/

#if 0
HL7SegRule *pSegRule( HL7MSG *, char *);	/* get seg ptr by name	*/
#endif
HL7SegRule *pSegRuleFind( HL7MSG *, const char *);	/* get seg ptr by name	*/

/* Default value for HL7 separators */

#define HL7CMPSEP          '^'          /* HL7 component sep.               */
#define HL7REPSEP          '~'		/* HL7 repetition sep.              */
#define HL7ESCSEP          '&'		/* HL7 escape separator             */
#define HL7SUBSEP          '\\'		/* HL7 sub-comp. sep.               */
#define HL7FLDSEP          '|'		/* HL7 Field Separator              */

#define HL7FLDMSK	1
#define HL7CMPMSK	2
#define HL7REPMSK	4
#define HL7ESCMSK	8
#define HL7SUBMSK	16

typedef struct _ErrMsgList {
     int       iErrIndex;		/* Error text index                 */
     char      *pcMsgText;		/* Text                             */
     unsigned  uSevLevel;		/* Level of severity                */
     unsigned  uObjMask;		/* Mask for error msg parameters    */
} ERRMSGLIST;

#define ERR_PREFIX "HL7ImExa (%c): "	/* HL7ImEx */
/* There are three classes of error messages :                              */
#define ERR_S      'S' 			/* fatal sytem error                */
#define ERR_E      'E'  		/* indicate HL7ImEx error           */
#define ERR_W      'W'	        	/* warnings : don't prevent from    */
					/* finishing                        */

/* Codes to add corresponding info to error message, when present           */

#define NIL_ERR (unsigned)0x00		/* no additional information        */
#define MSG_ERR	(unsigned)0x01		/* message name                     */
#define SEG_ERR	(unsigned)0x02		/* segment name                     */
#define FLD_ERR	(unsigned)0x04		/* field number                     */
#define REP_ERR	(unsigned)0x08		/* # ,if field with repetitions     */
#define COM_ERR	(unsigned)0x10		/* number if component              */
#define SUB_ERR	(unsigned)0x20		/* number of subcomponent           */

#ifdef API
char sFldTypes[] = "ST TX FT NM DT TM TS PN TN AD ID SI CM CK CN CQ CE ";
enum eFldTypes { ST=1, TX, FT, NM, DT, TM, TS, PN, TN, AD, 
		 ID, SI, CM, CK, CN, CQ, CE };

static ERRMSGLIST ErrMsgList[]= {
  { HL7_SEG_MISMATCH ,
      "type mismatch in message %s in segment %s",
      ERR_E, MSG_ERR | SEG_ERR},
  { HL7_END_OF_STRUCT,
      "End of message \"%s\"",
      ERR_W, MSG_ERR},
  { HL7_EMPTY_STRUCT ,"Bad HL7 message handle, nil?",
      ERR_E, NIL_ERR},
  { HL7_EMPTY_SEG_PTR,"In message %s segment %s is bad"
      ,ERR_E,MSG_ERR | SEG_ERR},
  { HL7_MSG_INCOMPLETE,"Mesage '%s' is incomplete."
      ,ERR_E,MSG_ERR | SEG_ERR},
  { HL7_NO_MEMORY    ,"Out of memory",
      ERR_E, NIL_ERR},
/*  { HL7_EMPTY_SEG_DEF,' ',' ',' '}, */
/*  { HL7_BAD_DIRECTION,' ',' ',' '}, */
  { HL7_BAD_SEG_NAME ,"In message %s segment %s is bad",
      ERR_E, MSG_ERR | SEG_ERR},
  { HL7_SEG_NAME_UNDEFINED, "Unable to insert undefined segment",
      ERR_E, 0},
  { HL7_SEG_TOO_LONG ,"In message %s length of segment %s exceed",
      ERR_E, MSG_ERR | SEG_ERR},
/*  { HL7_SEG_TOO_SHORT,' ',' ',' '}, */

  { HL7_BAD_MSG_TYPE ,
      "Current version of HL7ImEx doesn't support this message",
      ERR_E, NIL_ERR},
  { HL7_BAD_FLD_SEP  ,"Bad field separator in message %s",
      ERR_E, MSG_ERR},
  { HL7_PARSE_NESTING , "Incorrectly matched {},[],<> or()", ERR_E, MSG_ERR},
  { HL7_SEG_OUTOF_ORDER, "Segments in wrong order", ERR_E, MSG_ERR},
  { HL7_SEG_MISSING, "Segment missing", ERR_E, MSG_ERR},
/*  { HL7_STR_TOO_SHORT,' ',' ',' '},
  { HL7_STR_TOO_LONG ,' ',' ',' '},
  { HL7_BAD_STR      ,' ',' ',' '},
  { HL7_FLD_TOO_LONG ,' ',' ',' '},
  { HL7_FLD_MISSING  ,' ',' ',' '},

  { HL7_BAD_STRING   ,' ',' ',' '},
  { HL7_BAD_TEXT     ,' ',' ',' '},
  { HL7_BAD_DATE     ,' ',' ',' '},
  { HL7_BAD_TIME     ,' ',' ',' '},
  { HL7_BAD_TSTAMP   ,' ',' ',' '},
  { HL7_BAD_PNAME    ,' ',' ',' '},
  { HL7_BAD_TELEPH   ,' ',' ',' '},
  { HL7_BAD_ID       ,' ',' ',' '},
  { HL7_BAD_SI       ,' ',' ',' '},
  { HL7_BAD_CM       ,' ',' ',' '},
  {HL7_BAD_TAG       ,' ',' ',' '}
*/
  };

char *FatalError = "HL7ImEx (E): Fatal error";
#endif

/* length of list of errors */
#define ERR_List_Len  (sizeof(ErrMsgList)/sizeof(ERRMSGLIST))


/**************** Prototypes for application program   ********************/
/* API ImEx - Functions                                                   */
/*                                                                        */

HL7FLVR *HL7Init( char *, char *);
int HL7Drop( HL7FLVR *);
HL7MSG * HL7Alloca( HL7FLVR *);
int HL7Free(HL7MSG *);
int HL7ReadMesg(HL7MSG *, char *, HL7_SIZE);
int HL7FirstSegm(HL7MSG *, char **);
int HL7NextSegm(HL7MSG *, char **);
int HL7LastSegm(HL7MSG *, char **);
int HL7FindSegm(HL7MSG *, const char *);
int HL7GetNmbrOfFlds( HL7MSG *);
char * HL7GetFld(HL7MSG *pMsg, int);
char * HL7GetRep(HL7MSG *, int, int);
char * HL7GetComp(HL7MSG *, int, int, int);
char * HL7GetSub(HL7MSG *, int, int, int, int);

int HL7InsSegm(HL7MSG *, const char *);

/* define some HL-7 things for use with HL7Put... */
#define HL7NULL ""
#define HL7CLEAR "\"\""

int HL7PutFld(HL7MSG *, const char *, int);
int HL7PutRep(HL7MSG *, char *, int);
int HL7PutComp(HL7MSG *, char *, int);
int HL7PutCompN(HL7MSG *, char *, int, int);
int HL7PutSub(HL7MSG *, char *, int);
char *HL7EncodeEsc( HL7MSG *, char *, char *, int);
char *HL7DecodeEsc( HL7MSG *, char *, char *, int);
int HL7WriteMsg(HL7MSG *, char *, HL7_SIZE ,HL7_SIZE *);
int HL7fErrMsg(HL7MSG *, FILE*);
int HL7sErrMsg(HL7MSG *, char *);
char *HL7ErrTxt(HL7MSG *, int);

#define HL7GetField HL7GetFld

int HL7Eat(HL7MSG *, HL7SegRule *);
int HL7IsNextSeg (HL7MSG *, HL7SegRule *);
char * MsgCodeToType(int);

int HL7ValidateFld( HL7MSG *pMsg, int f);

#ifdef __cplusplus
}
#endif

#endif /*  HL7_API_IS_IN */
