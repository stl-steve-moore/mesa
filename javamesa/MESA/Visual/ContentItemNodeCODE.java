/*
 */

package MESA.Visual;

import java.util.Vector;
import javax.swing.*;
import DICOM.SR.*;

public class ContentItemNodeCODE extends ContentItemNode {

  private String mConceptName;
  private String mConceptCode;

  public ContentItemNodeCODE(DICOM.SR.ContentItem item) {
    super(item);
    mConceptName = new String("");
    mConceptCode = new String("no code assigned");
  }

  public void conceptName(String s) {
    mConceptName = new String(s);
  }

  public void conceptCode(String s) {
    mConceptCode = new String(s);
  }

  public String toString() {
   return fRelationshipType + " : " + mConceptName + " = " + mConceptCode;
  }

  public void explore() {
  }
}
