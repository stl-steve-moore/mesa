package MESA.Visual;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.table.*;
import javax.swing.event.*;
import java.util.*;

import DICOM.*;

public class CompositeObjectTable extends JPanel {
  private String[] rowData = new String[5];
  private MESA.Visual.CustomModel model = new MESA.Visual.CustomModel();
  private MESA.Visual.CustomTableModelListener mListener = new MESA.Visual.CustomTableModelListener();
  private JTable mTable = new JTable(model);
  private DICOM.DICOMWrapper mWrapper;
  private int[] mTagList;

  public CompositeObjectTable (JPanel parentPanel, DICOM.DICOMWrapper w) {
    String columnNames[] = {"Tag", "VR", "Length", "Description", "Value"};
    //parentPanel.add(this);
    //setText("XXX");

    model.addTableModelListener(mListener);
    mListener.addCompositeObjectTable(this);

    for(int c=0; c < columnNames.length; ++c)
      model.addColumn(columnNames[c]);

    mTagList = w.linearizeAttributes();
    model.setTagList(mTagList);

    for (int t = 0; t < mTagList.length; t++) {
      int thisTag = mTagList[t];

      String s = "000" + Integer.toHexString(thisTag);
      int l = s.length();
      s = s.substring(l-8);

      rowData[0] = s.substring(0, 4) + " " + s.substring(4, 8);

      s = w.getVR(thisTag);
      if (s == null) {
	rowData[1] = "XX";
      } else {
	rowData[1] = s;
      }

      s = w.getString(thisTag);
      if (s != null) {
	rowData[4] = s;
	rowData[2] = Integer.toString(s.length());
      } else {
	rowData[4] = "<none>";
	rowData[2] = "0";
      }

      s = w.getDescription(thisTag);
      if (s == null) {
	rowData[3] = "No description";
      } else {
	rowData[3] = s;
      }

      model.addRow(rowData);
    }

    //Dimension d = null;
    //parentPanel.getSize(d);
    mTable.setSize(550, 300);
    JScrollPane p = new JScrollPane(mTable);

    this.setLayout(new BorderLayout(0,0));
    this.add(BorderLayout.CENTER, p);

    //this.add(p);
    parentPanel.add(this);

    mWrapper = w;
  }

  public void updateCell(int row, int col) {
    if (row < 0 || col < 0)
      return;

    String s = (String) model.getValueAt(row, col);
    //System.out.println("new value = " + s);

    int tag = mTagList[row];
      mWrapper.setString(tag, s);
  }

}
class CustomModel extends DefaultTableModel {
  private int tagList[];
  public CustomModel() {
    super();
  }

  public CustomModel(Object[][] data, Object [] columnNames) {
    super(data, columnNames);
  }

  public boolean isCellEditable(int row, int col) {
    if (col < 4 || row < 0)
      return false;

    if (tagList == null)
      return false;

    int tag = tagList[row];
    int group = tag & 0xffff;
    if (group == 0x0000)
      return false;

    return true;
  }

  public void setTagList(int tags[]) {
    tagList = tags;
  }
}

class CustomTableModelListener implements TableModelListener {
  private MESA.Visual.CompositeObjectTable mCompositeObjectTable;
  public CustomTableModelListener() {
    //super();
  }

  public void tableChanged(TableModelEvent e) {
    if (e.getType() != TableModelEvent.UPDATE)
      return;

    int firstRow = e.getFirstRow();
    int lastRow = e.getLastRow();
    int col = e.getColumn();

    //System.out.println("Update first: " + firstRow + " last: " + lastRow);
    if (mCompositeObjectTable != null) 
      mCompositeObjectTable.updateCell(firstRow, col);
  }
  public void addCompositeObjectTable(MESA.Visual.CompositeObjectTable t) {
    mCompositeObjectTable = t;
  }

}
