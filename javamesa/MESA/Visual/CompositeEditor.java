/*
 * DICOMWrapper
 */

package MESA.Visual;

import java.util.Vector;
//import java.lang.Int;
import java.awt.Dimension;
import javax.swing.*;
import DICOM.DICOMWrapper;
import MESA.Visual.ContentItemNode;

public class CompositeEditor {

  private ContentItemNodeFactory mFactory;
  private JTable mPatientModuleTable;

  public CompositeEditor() {
    mFactory = new ContentItemNodeFactory( );
  }

  public int drawPatientModule(JPanel patientPanel,
			       DICOM.DICOMWrapper obj) {
    int tags[] = { 0x00100010, 0x00100020, 0x00100030, 0x00100040,
		   0x00101000, 0x00101001, 0x00102160, 0x00104000 };
    String labels[] = { "        Name ", "          ID ",
			"         DOB ", "         Sex ",
			"    Other ID ", "  Other Name ",
			"Ethnic Group ",
			"Comments" };
    String rowData[][] = new String[8][4];
    int index;
    for (index = 0; index < 7; index++) {
      Integer ix = new Integer(tags[index]);

      rowData[index][0] = ix.toString((tags[index] >> 16) &0xffff, 16);
      rowData[index][1] = ix.toString(tags[index] & 0xffff, 16);
      rowData[index][2] = new String(labels[index]);
      String s = obj.getString(tags[index]);
      rowData[index][3] = s;
    }
    String columnNames[] = {"Group", "Element", "Description", "Value"};
    mPatientModuleTable = new JTable(rowData, columnNames);
    JScrollPane scrollPane = new JScrollPane(mPatientModuleTable);
    patientPanel.add(scrollPane);
    return 0;
  }

  public int drawLinearPanel(JPanel panel,
			     DICOM.DICOMWrapper obj) {
    int tags[] = obj.linearizeAttributes( );
    int length = tags.length;

    String rowData[][] = new String[length][4];
    int index;
    for (index = 0; index < length; index++) {
      System.out.print(" Index = " + index);
      Integer ix = new Integer(tags[index]);

      rowData[index][0] = ix.toString((tags[index] >> 16) &0xffff, 16);
      rowData[index][1] = ix.toString(tags[index] & 0xffff, 16);
      rowData[index][2] = new String("Description");
      System.out.print(" Tag = " + rowData[index][0] + " " + rowData[index][1]);
      String s = obj.getString(tags[index]);
      System.out.println(" Value = " + s);
      rowData[index][3] = s;

    }
    String columnNames[] = {"Group", "Element", "Description", "Value"};
    mPatientModuleTable = new JTable(rowData, columnNames);
    JScrollPane scrollPane = new JScrollPane(mPatientModuleTable);
    panel.add(scrollPane);
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
}
