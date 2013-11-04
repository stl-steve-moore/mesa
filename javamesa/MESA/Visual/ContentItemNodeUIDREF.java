/*
 */

package MESA.Visual;

import java.util.Vector;
import javax.swing.*;
import DICOM.SR.*;

public class ContentItemNodeUIDREF extends ContentItemNode {

  private String mUID;
  private String mUIDMeaning;

  public ContentItemNodeUIDREF(DICOM.SR.ContentItem item) {
    super(item);
    mUID = new String("");
    mUIDMeaning = new String("no meaning assigned");
  }

  public void uid(String s) {
    mUID = new String(s);
  }

  public void uidMeaning(String s) {
    mUIDMeaning = new String(s);
  }

  public String toString() {
   return fRelationshipType + " : " + mUIDMeaning + " = " + mUID;
  }

  public void explore() {
  }
}
