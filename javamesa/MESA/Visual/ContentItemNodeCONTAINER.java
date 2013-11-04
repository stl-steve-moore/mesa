/*
 */

package MESA.Visual;

import java.util.Vector;
import javax.swing.*;
import DICOM.SR.*;

public class ContentItemNodeCONTAINER extends ContentItemNode {

  private String mTitle;

  public ContentItemNodeCONTAINER(DICOM.SR.ContentItem item) {
    super(item);
    mTitle = new String("");
  }

  public void title(String s) {
    mTitle = new String(s);
  }

  public String toString() {
   return fRelationshipType + " Title : " + mTitle;
  }

  public void explore() {
  }
}
