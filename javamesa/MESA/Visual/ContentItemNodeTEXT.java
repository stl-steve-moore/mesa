/*
 */

package MESA.Visual;

import java.util.Vector;
import javax.swing.*;
import DICOM.SR.*;

public class ContentItemNodeTEXT extends ContentItemNode {

  private String mText;
  private String mTextMeaning;

  public ContentItemNodeTEXT(DICOM.SR.ContentItem item) {
    super(item);
    mText = new String("");
    mTextMeaning = new String("no meaning assigned");
  }

  public void text(String s) {
    mText = new String(s);
  }

  public void textMeaning(String s) {
    mTextMeaning = new String(s);
  }

  public String toString() {
   return fRelationshipType + " : " + mTextMeaning + " = " + mText;
  }

  public void explore() {
  }
}
