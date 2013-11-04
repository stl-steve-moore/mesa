/*
 */

package MESA.Visual;

import java.util.Vector;
import javax.swing.*;
import DICOM.SR.*;

public class ContentItemNode extends javax.swing.tree.DefaultMutableTreeNode {

  protected boolean fExplored = false;
  protected String fValueType;
  protected String fRelationshipType;
  protected boolean fIsLeaf;
  protected DICOM.SR.ContentItem fContentItem;

  public ContentItemNode(DICOM.SR.ContentItem item) {
    setUserObject(item);
    fValueType = item.getValueType();
    fRelationshipType = item.getRelationshipType();
    fContentItem = item;
    fIsLeaf = fContentItem.isLeaf();
  }

  public boolean getAllowsChildren() {
    return !fIsLeaf;
  }

  public boolean isLeaf( ) {
    return fIsLeaf;
  }
  public boolean allowsChildren( ) {
    return !fIsLeaf;
  }

  public String toString() {
   return fValueType + " : " + fRelationshipType;
  }

  public void explore() {
  }
}
