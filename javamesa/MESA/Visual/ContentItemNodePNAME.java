/*
 */

package MESA.Visual;

import java.util.Vector;
import javax.swing.*;
import DICOM.SR.*;

public class ContentItemNodePNAME extends ContentItemNode {

  private String mPersonName;
  private String mNameMeaning;

  public ContentItemNodePNAME(DICOM.SR.ContentItem item) {
    super(item);
    mPersonName = new String("");
    mNameMeaning = new String("no meaning assigned");
  }

  public void personName(String pName) {
    mPersonName = new String(pName);
  }

  public void nameMeaning(String s) {
    mNameMeaning = new String(s);
  }

  public String toString() {
   //return fValueType + " : " + fRelationshipType + " " + mPersonName;
   return fRelationshipType + " : " + mNameMeaning + " = " + mPersonName;
  }

  public void explore() {
  }
}
