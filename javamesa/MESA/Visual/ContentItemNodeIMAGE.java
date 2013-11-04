/*
 */

package MESA.Visual;

import java.util.Vector;
import javax.swing.*;
import DICOM.SR.*;

public class ContentItemNodeIMAGE extends ContentItemNode {

  private String mPurposeOfReference;

  public ContentItemNodeIMAGE(DICOM.SR.ContentItem item) {
    super(item);
    mPurposeOfReference = new String("");
  }

  public void purposeOfReference(String s) {
    mPurposeOfReference = new String(s);
  }

  public String toString() {
   return fRelationshipType + " : " + mPurposeOfReference;
  }

  public void explore() {
  }
}
