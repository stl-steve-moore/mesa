/*
 * DICOMWrapper
 */

package MESA.Visual;

import java.util.Vector;
import java.awt.Dimension;
import javax.swing.*;
import DICOM.*;
import MESA.Visual.ContentItemNode;

public class CompositePainter {

  //protected long dcmObject;
  //private int ownObject;
  private ContentItemNodeFactory mFactory;
  private DICOM.InfoObj.CompositeFactory mCompositeFactory;

  public CompositePainter() {
    mFactory = new ContentItemNodeFactory( );
    mCompositeFactory = new DICOM.InfoObj.CompositeFactory();
  }

  public int paintPatientModule(JList listBox, DICOM.DICOMWrapper obj) {
    int tags[] = { 0x00100010, 0x00100020, 0x00100030, 0x00100040,
		   0x00101000, 0x00101001, 0x00102160, 0x00104000 };
    String labels[] = { "        Name ", "          ID ",
			"         DOB ", "         Sex ",
			"    Other ID ", "  Other Name ",
			"Ethnic Group ",
			"Comments" };
    int index;
    for (index = 0; index < 7; index++) {
      String s = obj.getString(tags[index]);
      labels[index] = labels[index] + s;
    }
    listBox.setListData(labels);
    return 0;
  }
  public int paintSRContentModule(JScrollPane sp,
				  DICOM.SR.StructuredReport rpt) {

/*
    Vector v = rpt.contentItemVector();
    int count = v.size();
    Vector v2 = new Vector(count, 1);
    int i;
    for (i = 0; i < count; i++) {
      DICOM.SR.ContentItem contentItem = (DICOM.SR.ContentItem)v.elementAt(i);
      String s1 = contentItem.getValueType();
      String s2 = contentItem.getRelationshipType();

      if (!contentItem.isLeaf()) {
        Vector v3 = new Vector(1,1);
        Vector v4 = contentItem.contentItemVector();
        int c4 = v4.size();
        int j;
        for (j = 0; j < c4; j++) {
	  DICOM.SR.ContentItem item4 = (DICOM.SR.ContentItem) v4.elementAt(j);
	  String s4_1 = item4.getValueType();
	  String s4_2 = item4.getRelationshipType();
	  ContentItemNode node4 = new ContentItemNode(s4_1, s4_2, item4);
	  v3.addElement(node4);
        }
	v2.addElement(v3);
      } else {
        ContentItemNode item = new ContentItemNode(s1, s2, contentItem);
        v2.addElement(item);
      }
    }
    JTree tree = new JTree(v2);
*/
    DICOM.SR.ContentItem rootItem = rpt.contentItem( );
    String rootValue = rootItem.getValueType();
    String rootRelationship = rootItem.getRelationshipType();
    ContentItemNode rootNode = mFactory.produce(rootItem);
    addChildren(rootItem, rootNode);
    rootNode.explore();
    javax.swing.tree.DefaultTreeModel model = new javax.swing.tree.DefaultTreeModel(rootNode);
    JTree tree = new JTree(model);

/*
    Vector v = new Vector(3, 1);
    v.addElement("xxx");
    v.addElement("yyy");
    v.addElement("zzz");
    Vector v2 = new Vector(3, 1);
    v2.addElement("aaa");
    v2.addElement("bbb");
    v2.addElement("ccc");
    v.addElement(v2);
    JTree tree = new JTree(v);
*/
    sp.setPreferredSize(new Dimension(300, 300));
    sp.getViewport().add(tree);
    return 0;
  }
  public void addChildren(DICOM.SR.ContentItem item, ContentItemNode node) {
    if (item.isLeaf())
      return;

    Vector v = item.contentItemVector( );
    int count = v.size();
    int i;
    for (i = 0; i < count; i++) {
      DICOM.SR.ContentItem subItem = (DICOM.SR.ContentItem)v.elementAt(i);
      String s1 = subItem.getValueType( );
      String s2 = subItem.getRelationshipType( );
      ContentItemNode subItemNode = mFactory.produce(subItem);
      node.add(subItemNode);
      addChildren(subItem, subItemNode);
    }
  }
  public int paintPatientModule(javax.swing.JTextField pName,
				javax.swing.JTextField pID,
				javax.swing.JTextField pDOB,
				javax.swing.JTextField pSex,
				DICOM.DICOMWrapper w) {

    DICOM.Module.PatientModule m = mCompositeFactory.getPatientModule(w);
    String s = m.patientName();
    pName.setText(s);

    s = m.patientID();
    pID.setText(s);

    s = m.birthDate();
    pDOB.setText(s);

    s = m.sex();
    pSex.setText(s);

    return 0;
  }
  public int paintGeneralStudyModule(javax.swing.JTextField studyInstanceUID,
				     javax.swing.JTextField studyDate,
				     javax.swing.JTextField studyTime,
				     javax.swing.JTextField referringPhysician,
				     javax.swing.JTextField studyID,
				     javax.swing.JTextField accessionNumber,
				     DICOM.DICOMWrapper w) {

    DICOM.Module.GeneralStudyModule m =
	mCompositeFactory.getGeneralStudyModule(w);

    String s = m.studyUID();
    studyInstanceUID.setText(s);

    s = m.studyDate();
    studyDate.setText(s);

    s = m.studyTime();
    studyTime.setText(s);

    s = m.referringPhysician();
    referringPhysician.setText(s);

    s = m.studyID();
    studyID.setText(s);

    s = m.accessionNumber();
    accessionNumber.setText(s);

    return 0;
  }

  public int paintSRDocumentSeriesModule(javax.swing.JTextField modality,
					 javax.swing.JTextField seriesInstanceUID,
					 javax.swing.JTextField seriesNumber,
					 DICOM.SR.StructuredReport w) {

    DICOM.Module.SRDocumentSeriesModule m =
	mCompositeFactory.getSRDocumentSeriesModule(w);

    String s = m.modality();
    modality.setText(s);

    s = m.seriesUID();
    seriesInstanceUID.setText(s);

    s = m.seriesNumber();
    seriesNumber.setText(s);

    return 0;
  }
}
