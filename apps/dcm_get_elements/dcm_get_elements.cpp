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

#include "dcm_get_elements.hpp"

static void extended_usage_error()
{
    char msg[] = "\
dcm_get_elements [-h] [-v] [-e group.element[:item][,group.element[:item]...] | \n\
        -] [-s] [-o] [-i] file [file2 file3 ...]\n\
Print the value of a given element, or of a number of elements in the given \n\
        DICOM file.\n\n\
    -h print extended help\n\
    -v verbose output\n\
    -e specifies the element to parse, optionally with a item number.\n\
       If the element is a non-sequence, the value will be returned.  If\n\
       the element is a sequence, see below.\n\
       Elements to parse may be recursively nested in the case of nested\n\
       sequences.\n\
       In the case of two or more nested elements, the item numbers of the \n\
       non-last elements is assumed to be 1 (eg. x.X,y.Y = x.X:1,y.Y).  Items \n\
       begin numbering at 1 \n\
       Example: to obtain value of tag 0008 0100 nested inside second item of \n\
       sequence 0040 a043, \n\
                -e 0040.a043:2,0008.0100\n\
       Alternatively, specifying \"-e -\" will read in tag values from standard \n\
       input.\n\
    -s Expand sequences.  Default is no expand.  See below.\n\
    -o Format to be read by dcm_create_object (# and #### marks for empty \n\
       elements and sequences, resp.)\n\
    -i Do not print warning if element does not exist, but return appropriate \n\
       error value.\n\
    file   Name of input file(s) containing DICOM object\n\n\
    The policy of expanding sequences is based on 1) if last item is specified \n\
    and 2) expanding sequences or not.\n\
    1. ITEM, EXPAND -- all elements in item recursively printed.\n\
    2. NO ITEM, EXPAND -- all elements in all items of sequence recursively \n\
       printed.\n\
    3. ITEM, NO EXPAND -- all elements printed, no further recursion to \n\
       sequences.\n\
    4. NO ITEM, NO EXPAND -- number of items this sequence has is printed.\n\
    If -e is not specified, policy 1 or 3 is applied to the whole DICOM object.\n";

    fprintf(stderr, msg);
    exit(NO_ERROR_USAGE_PRINTED);
}

static void usageerror()
{
    char msg[] = "\
dcm_get_elements [-h] [-e group.element[:item][,group.element[:item]...] | -] \n\
        [-s] [-o] file [file2 file3 ...]\n\
Print the value of a given element, or of a number of elements in the given \n\
        DICOM file.\n\n\
    -h print extended help\n\
    -e specifies the element to parse, optionally with a item number. E.g.\n\
                -e 0040.a043:1,0008.0100\n\
       Alternatively, specifying \"-e -\" will read in tag values from standard \n\
       input.\n\
    -s Expand sequences.  Default is no expand.\n\
    -o Format to be read by dcm_create_object (# and #### marks for empty elements\n\
       and sequences, resp.)\n\
    file   Name of input file(s) containing DICOM object\n\n";

    fprintf(stderr, msg);
    exit(USAGE_ERROR);
}

void printSequence(const DCM_ELEMENT *e, void *ctx) {
   MDICOMWrapper* wl = ((PRINT_ELEMENT_STRUCT*)ctx)->w; 
   int level = ((PRINT_ELEMENT_STRUCT*)ctx)->level, 
       item = ((PRINT_ELEMENT_STRUCT*)ctx)->item; 
   CTNBOOLEAN expandSequences = ((PRINT_ELEMENT_STRUCT*)ctx)->expandSequences; 
   CTNBOOLEAN recurseFurther = ((PRINT_ELEMENT_STRUCT*)ctx)->recurseFurther; 
   char prefix[128];

   for (int i = 0; i < level; i++)
      prefix[i] = '\t';
   prefix[level] = '\0'; 

   int numItems = wl->numberOfItems(e->tag);
   // recurseFurther is a flag specifying if we are to expand sequences further.
   // it is different from the expandSequences flag, which is set with the -s flag
   // on the command line: not specifying -s and specifying an item will expand 
   // that item (recurseFurther = true), but on the next iteration recurseFurther
   // will be set to false (generally, recurseFurther will = expandSequences)
   // and no further expansion will occur. 
   if (!recurseFurther) {
       printf(SEQUENCE_MSG, numItems);
       printf("\n");
       return;
   }

   MDICOMWrapper *s;
   // constructing the structure for the next callback.
   // recurseFurther is set to expandSequence here.  Recursion will take place for all
   // items, hence item = -1.
   PRINT_ELEMENT_STRUCT d = {NULL, level + 1, -1, UNDEFINED_TAG, expandSequences, 
       expandSequences};

   if (item != -1) { // Item is specified
       s = wl->getSequenceWrapper(e->tag, item);
       printf("\t// Item %d\n", item);
       if (s == 0) { // Error
           fprintf(stderr, "Error getting item\n");
           exit(ERROR_GETTING_ITEM);
       }
       d.w = s;
       s->getElements(printElement, (void *)&d);
   } else {  // recurse through all items.  Item indices start at 1
       if (numItems == 0) {
           if (dcoFormat) 
               printf("####\t// Sequence with no Items\n");
           else 
               printf("(\t// Sequence with no Items\n%s)\n", prefix);
           return;
       }
       for (int i = 1; i <= numItems; i++) {   
           if (i == 1) {
               if (numItems == 1) printf(" (\n");
               else printf(" (\t// Item %d\n", i);
           } else {
               printf("%s(\t// Element %04x %04x Item %d\n", prefix, 
                   DCM_TAG_GROUP(e->tag), DCM_TAG_ELEMENT(e->tag), i);
           }
           s = wl->getSequenceWrapper(e->tag, i);
           if (s == 0) { // Error
               fprintf(stderr, "Error getting sequence\n");
               exit(ERROR_GETTING_SEQUENCE);
           }
           d.w = s;
           s->getElements(printElement, (void *)&d);

           printf("%s)\n", prefix);
       } 
   }
}


static CONDITION printElement(const DCM_ELEMENT *e, void *ctx) {
   char scratch[128], prefix[128];
   MDICOMWrapper* wl = ((PRINT_ELEMENT_STRUCT*)ctx)->w; 
   int stringLength, 
       level = ((PRINT_ELEMENT_STRUCT*)ctx)->level; 
   DCM_TAG tag = ((PRINT_ELEMENT_STRUCT*)ctx)->tag; 

   // If tag is undefined, then we will print just this tag (ignore others)
   if ((tag != UNDEFINED_TAG) && (e->tag != tag)) return DCM_NORMAL; 

   for (int i = 0; i < level; i++)
      prefix[i] = '\t';
   prefix[level] = '\0'; 

   (void) printf("%s%04x %04x ", prefix, DCM_TAG_GROUP(e->tag), 
                 DCM_TAG_ELEMENT(e->tag));
   if (e->d.ot == NULL) {
       (void) printf(DATA_ON_DISK_MSG);
       (void) printf("\n");
       return DCM_NORMAL;
   }

   switch (e->representation) {
       case DCM_AE:
       case DCM_AS:
       case DCM_CS:
       case DCM_DA:
       case DCM_DT:
       case DCM_DS:
       case DCM_IS:
       case DCM_LO:
       case DCM_LT:
       case DCM_PN:
       case DCM_SH:
       case DCM_UT:
       case DCM_ST:
       case DCM_TM:
       case DCM_UI:
           if ((dcoFormat) && (e->length == 0))
               printf("#\n");
           else {
               stringLength = MIN(sizeof(scratch) - 1, e->length);
               strncpy(scratch, e->d.string, stringLength);
               scratch[stringLength] = '\0';
                // print quotes only if there's a space in the string and its not last (padding)
               char *sp = strchr(scratch, ' ');
               if (sp && (sp != scratch + stringLength-1))
                   (void) printf("\"%s\"\n", scratch);
               else 
                   (void) printf("%s\n", scratch);
           }
           break;
       case DCM_SL:
           // To implement this and other binary VM's, take a look at dumpBinaryData
           // in dcm.c.  That code ought to be reused (by making it public).
           if (e->multiplicity > 1) {
               printf(VM_UNIMPLEMENTED_MSG, e->multiplicity);
               printf("\n");
               return DCM_NORMAL;
           }
           (void) printf("%8x %d\n", *e->d.sl, *e->d.sl); break;
       case DCM_SS:
           if (e->multiplicity > 1) {
               printf(VM_UNIMPLEMENTED_MSG, e->multiplicity);
               printf("\n");
               return DCM_NORMAL;
           }
           (void) printf("%4x %d\n", *e->d.ss, *e->d.ss); break;
       case DCM_AT:
       case DCM_UL:
           if (e->multiplicity > 1) {
               printf(VM_UNIMPLEMENTED_MSG, e->multiplicity);
               printf("\n");
               return DCM_NORMAL;
           }
           (void) printf("%8x %d\n", *e->d.ul, *e->d.ul); break;
       case DCM_US:
           if (e->multiplicity > 1) {
               printf(VM_UNIMPLEMENTED_MSG, e->multiplicity);
               printf("\n");
               return DCM_NORMAL;
           }
           (void) printf("%4x %d\n", *e->d.us, *e->d.us); break;
       case DCM_OB:
       case DCM_UN:
           (void) printf(BINARY_MSG); break;
       case DCM_OT:
       case DCM_OW:
       case DCM_RET:
       case DCM_DD:
       case DCM_FD:
       case DCM_FL:
           (void) printf(UNIMPLEMENTED_MSG); break;
       case DCM_SQ: 
           printSequence(e, ctx); break;
       default:
           (void) printf("<<Some unimplemented logic if here>>\n"); 
           exit(UNKNOWN_ERROR);
   }
   return DCM_NORMAL;
}

// Parses one elementDesc string (of form "xxxx.yyyy" or "xxxx.yyyy:z")
// returns the tag value and an item value.  If item is not specified, 
// -1 is returned in item.
int readElementDescription(MString elementDesc, DCM_TAG *tag, int *item) {
    char* str;
    int group, element;

    *item = -1;
    if (!elementDesc.tokenExists('.', 1))  {
        cerr << "Malformed root element: " << elementDesc << "\n"; 
        return MALFORMED_ROOT_ELEMENT;
    }
    MString groupS = elementDesc.getToken('.', 0); 
    MString elementS = elementDesc.getToken('.', 1);

    if (elementS.tokenExists(':',1)) {
        MString itemS = elementS.getToken(':', 1);
        elementS = elementS.getToken(':', 0);
        str = itemS.strData();
        if (!sscanf(str, "%x", item)) {
            cerr << "Malformed root element: " << elementDesc << "\n"; 
            return MALFORMED_ROOT_ELEMENT;
        }
        delete [] str;
        if (*item < 1) {
            fprintf(stderr, "Item cannot be less than 1\n");
            return MALFORMED_ROOT_ELEMENT;
        }
    } 

    str = groupS.strData();
    if (!sscanf(str, "%x", &group)) {
        cerr << "Malformed root element: " << elementDesc << "\n"; 
        return MALFORMED_ROOT_ELEMENT;
    }
    delete [] str;

    str = elementS.strData();
    if (!sscanf(str, "%x", &element)) {
        cerr << "Malformed root element: " << elementDesc << "\n"; 
        return MALFORMED_ROOT_ELEMENT;
    }
    delete [] str;

    // create the element
    *tag = DCM_MAKETAG(group, element);
    return MESA_NO_ERROR;
}

int parseRootElement(MDICOMWrapper **w, MString rootElement, DCM_ELEMENT *e, int *item) {
// Returns the element specified by the rootElement tag, as described below.
// Also returns the item number, if applicable, of the final element; if no item is
// specified, a value of -1 is given to item. 
// rootElement string is of form aaaa.bbbb:c,(repeat)
// where aaaa is the group, bbbb is element, and c is the item.
// item numbers are optional, and when they are missing and required,
// 1 is assumed.
// If there is more than one element in the root element (indicating a sequence)
// the sequences are traversed and w is set to be the object which contains 
// the element e.

    int elementIndex = 0;
    DCM_TAG tag;
    CTNBOOLEAN itemSpecified = FALSE, lastElement;
    CONDITION cond;

    while (rootElement.tokenExists(',', elementIndex)) {
        // if lastElement is true, no more elements specified after this one.
        lastElement = !rootElement.tokenExists(',', elementIndex+1);

        MString eS = rootElement.getToken(',', elementIndex);

        int retval = readElementDescription(eS, &tag, item);
        if (retval != MESA_NO_ERROR) return retval;

        e->tag = tag;
        cond = DCM_LookupElement(e);
        if (cond != DCM_NORMAL) {
            ::COND_DumpConditions();
            return UNKNOWN_ERROR;
        }

        // make sure this element really exists in this object
        if (!(*w)->attributePresent(tag)) {
            if (!ignoreNoElement) 
                fprintf(stderr, "Element %04x %04x does not exist\n", 
                        DCM_TAG_GROUP(tag), DCM_TAG_ELEMENT(tag));
            return ELEMENT_DOES_NOT_EXIST;
        }

        // make sure non-SQ element doesn't have item tag
        if ((e->representation != DCM_SQ) && (*item != -1)) {
            fprintf(stderr, "Item number specified for a non-SQ tag.\n");
            return ITEM_IN_NON_SQ_TAG;
        }

        // make sure non-SQ element doesn't have other elements following in rootElement list
        if ((!lastElement) && (e->representation != DCM_SQ))  {
            fprintf(stderr, "Non-SQ tag has an element following it in item specification\n");
            return NON_SQ_TAG_NOT_LAST;
        }

        // If this is not the last element, this is an SQ element; "open" it up and read in
        // the appropriate item.  If the item number is not specified, 1 is assumed here. 
        // Finally, set w to this item in question.
        if (!lastElement) {
            if (*item == -1)
                *w = (*w)->getSequenceWrapper(tag, 1);
            else
                *w = (*w)->getSequenceWrapper(tag, *item);
            if (w == 0) {
                fprintf(stderr, "Error creating sequence wrapper.\n");
                return UNKNOWN_ERROR;
            }
        } 

        elementIndex++;
    }
    return MESA_NO_ERROR;
}

/* 
 * Algorithm
 *
 * User has two main options: No Expand (default) or Expand (-s)
 *                            specification of root element with -e flag
 * The root element may be one of four categories:
 * 1) no root element set (no -e flag)
 * 2) root element is a non-SQ element
 * 3) root element is SQ element, no item specified
 * 4) root element is SQ, item specified
 *
 * Based on this, the following actions will be performed:
 * 1NE -- print all elements, for each sequence print <<sequence N items>>
 * 1EX -- print all elements, for each item in each sequence print all elements recursively
 * 2NE -- print element value
 * 2EX -- print element value
 * 3NE -- print <<Sequence N items>>
 * 3EX -- for each item in each sequence print all items recursively
 * 4NE -- for this item, do as for 1NE
 * 4EX -- for this item, do as for 1EX
 *
 * After the arguments are read in, parseRootElement is called on the root element string.
 * This parses the string, making sure all elements are legal.  If there are sequences,
 * they are expanded as appropriate.  At the conclusion of the function, the element e is
 * the last element specified in the string, and item is the item which is specified for
 * it (or -1 if not specified).  The MDICOMWrapper w points to the object which contains
 * the element e.
 *
 * Calling w.getElements with printElement as an argument makes the printElement function
 * be called once for every element in w.  This is the desired outcome only in case 1) above.
 * For all other cases, the tag of the element of interest is set, and only this element
 * is parsed.
 */

int main(int argc, char **argv)
{

  CTNBOOLEAN expandSequence = FALSE;
  CTNBOOLEAN multipleFilename = FALSE;
  char *rootElement = NULL, 
       *filename;
  int returnValue = MESA_NO_ERROR;

  while (--argc > 0 && (*++argv)[0] == '-') {
    switch (*(argv[0] + 1)) {
    case 'h':
      extended_usage_error();
      break;
    case 'e':
      if (argc < 1) usageerror();
      argc--; argv++;
      rootElement = *argv;
      break;
    case 's':
      expandSequence = TRUE;
      break;
    case 'v':
      verbose = TRUE;
      break;
    case 'o':
      dcoFormat = TRUE;
      break;
    case 'i':
      ignoreNoElement = TRUE;
      break;
    default:
      break;
    }
  }

  if (argc < 1)
    usageerror();

  /* Multiple filename
   * multipleFilename is true if we are processing more than one file -- useful if you want to
   * examine all files in a directory, say.
   * there are two differences in behavior between multiple filename mode and single filename mode:
   * 1. for multiple filenames, the filename is printed out
   * 2. if the element does not exist, for single filenames the program exits with an ELEMENT_DOES_NOT_EXIST
   *    code; for multiple filenames, the program does not exit (and just the error message is printed
   *    out).  In the latter case, ELEMENT_DOES_NOT_EXIST is returned if any elements do not exist.
   */
  if (argc > 1)
    multipleFilename = TRUE;
      
  while (argc-- > 0) {
      filename = *argv++;
      if (multipleFilename) 
          printf("\nFile %s:\n", filename);

      if (verbose)
          printf("root element: %s\nseq expand = %s\nfilename = %s, dco format = %s\n", 
                  rootElement != NULL ? rootElement : "none",
                  expandSequence ? "yes" : "no", filename, dcoFormat ? "yes" : "no");


      MDICOMWrapper *w = new MDICOMWrapper();
      if (w->open(filename)) {
          fprintf(stderr, "Error opening %s.\n", filename);
          exit(ERROR_OPENING_FILE);
      }

      if ((rootElement == NULL) || (strcmp(rootElement, "-"))) {
          if (processRootElement(w, rootElement, expandSequence) == ELEMENT_DOES_NOT_EXIST)
              returnValue = ELEMENT_DOES_NOT_EXIST;
      } else {
          while (!cin.eof()) {
              char buffer[1024];
              cin.getline(buffer, 1024, '\n');
              if (cin.eof()) continue;
              if (!strcmp(buffer, ""))
                  if (processRootElement(w, NULL, expandSequence) == ELEMENT_DOES_NOT_EXIST)
                      returnValue = ELEMENT_DOES_NOT_EXIST;
              else
                  if (processRootElement(w, buffer, expandSequence) == ELEMENT_DOES_NOT_EXIST)
                      returnValue = ELEMENT_DOES_NOT_EXIST;
          }
      }
  }
//  printf ("returning %d\n", returnValue);
  return(returnValue);
}

int processRootElement(MDICOMWrapper *w, char *rootElement,  CTNBOOLEAN expandSequence) { 
    /* returns NO_ERROR if there is not error in processing, and ELEMENT_DOES_NOT_EXIST if
     * the element is not found.  The program exits with the appropriate error code for
     * any other errors.
     */  
  DCM_ELEMENT element;
  memset(&element, 0, sizeof(element));

  int item;

  if (rootElement == NULL) {
      item = -1;
  } else {
      int retval = parseRootElement(&w, rootElement, &element, &item); 
      if (retval == ELEMENT_DOES_NOT_EXIST) {
          return retval;
      }
      if (retval != MESA_NO_ERROR) {
          ::COND_DumpConditions();
          exit(retval);
      }
  }

  PRINT_ELEMENT_STRUCT d = {w, 0, item, UNDEFINED_TAG, expandSequence, TRUE};
  if ((element.representation == DCM_SQ) && (item == -1) && (!expandSequence)) 
          d.recurseFurther = FALSE;

  if ((rootElement == NULL) && (!expandSequence))
          d.recurseFurther = FALSE;

  if (rootElement != NULL) {
      d.tag = element.tag;
  }

  w->getElements(printElement, (void *)&d);
  return MESA_NO_ERROR;
}
