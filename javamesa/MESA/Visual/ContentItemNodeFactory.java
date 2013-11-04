/*
 */

package MESA.Visual;

import java.util.Vector;
import java.awt.Dimension;
import javax.swing.*;
import DICOM.DICOMWrapper;
import DICOM.SR.ContentItem;
import MESA.Visual.*;

public class ContentItemNodeFactory {

  public ContentItemNodeFactory () {
  }

  public ContentItemNode produce(DICOM.SR.ContentItem item) {
    String vType = item.getValueType( );

    if (vType.equals("CODE"))
      return produceCODE(item);
    if (vType.equals("CONTAINER"))
      return produceCONTAINER(item);
    if (vType.equals("IMAGE"))
      return produceIMAGE(item);
    if (vType.equals("PNAME"))
      return producePNAME(item);
    if (vType.equals("UIDREF"))
      return produceUIDREF(item);
    if (vType.equals("TEXT"))
      return produceTEXT(item);

    return new ContentItemNode(item);
  }

  private ContentItemNode produceCODE(DICOM.SR.ContentItem item) {
      ContentItemNodeCODE n = new ContentItemNodeCODE(item);
      String s = item.getString(0x0040a043, 0x00080104, 1);
      n.conceptName(s);
      s = item.getString(0x0040a168, 0x00080104, 1);
      n.conceptCode(s);

      return n;
  }

  private ContentItemNode produceCONTAINER(DICOM.SR.ContentItem item) {
      ContentItemNodeCONTAINER n = new ContentItemNodeCONTAINER(item);
      String s = item.getString(0x0040a043, 0x00080104, 1);
      n.title(s);

      return n;
  }

  private ContentItemNode produceIMAGE(DICOM.SR.ContentItem item) {
      ContentItemNodeIMAGE n = new ContentItemNodeIMAGE(item);
      String s = item.getString(0x0040a043, 0x00080104, 1);
      n.purposeOfReference(s);

      return n;
  }

  private ContentItemNode producePNAME(DICOM.SR.ContentItem item) {
      ContentItemNodePNAME n = new ContentItemNodePNAME(item);
      String s = item.getString(0x0040a123);
      n.personName(s);
      s = item.getString(0x0040a043, 0x00080104, 1);
      n.nameMeaning(s);

      return n;
  }
  private ContentItemNode produceUIDREF(DICOM.SR.ContentItem item) {
      ContentItemNodeUIDREF n = new ContentItemNodeUIDREF(item);
      String s = item.getString(0x0040a124);
      n.uid(s);
      s = item.getString(0x0040a043, 0x00080104, 1);
      n.uidMeaning(s);

      return n;
  }
  private ContentItemNode produceTEXT(DICOM.SR.ContentItem item) {
      ContentItemNodeTEXT n = new ContentItemNodeTEXT(item);
      String s = item.getString(0x0040a160);
      n.text(s);
      s = item.getString(0x0040a043, 0x00080104, 1);
      n.textMeaning(s);

      return n;
  }
}
