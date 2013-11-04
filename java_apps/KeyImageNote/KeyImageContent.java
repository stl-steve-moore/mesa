import javax.swing.*;
import java.beans.*;
import java.awt.*;
import java.util.Vector;

import DICOM.DICOMWrapper;
import DICOM.Code.CodeManager;
import DICOM.Code.CodeItem;
import symantec.itools.awt.MultiList;

class KeyImageContent extends javax.swing.JPanel
{
    String mFileNames[];
	public KeyImageContent()
	{

		//{{INIT_CONTROLS
		setLayout(null);
		setSize(460,448);
		add(documentTitle);
		documentTitle.setBounds(48,24,348,33);
		add(keyImageDescrText);
		keyImageDescrText.setBounds(36,72,372,94);
		JButton1.setText("Add");
		JButton1.setActionCommand("Add");
		add(JButton1);
		JButton1.setBounds(60,372,87,25);
		add(keyImageList);
		keyImageList.setBackground(java.awt.Color.white);
		keyImageList.setBounds(36,192,372,125);
		JButton2.setText("Remove");
		JButton2.setActionCommand("Remove");
		add(JButton2);
		JButton2.setBounds(180,372,87,25);
		JButton3.setText("Clear");
		JButton3.setActionCommand("Clear");
		add(JButton3);
		JButton3.setBounds(300,372,87,25);
		//}}

		//{{REGISTER_LISTENERS
		//}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JComboBox documentTitle = new javax.swing.JComboBox();
	javax.swing.JTextArea keyImageDescrText = new javax.swing.JTextArea();
	javax.swing.JButton JButton1 = new javax.swing.JButton();
	symantec.itools.awt.MultiList keyImageList = new symantec.itools.awt.MultiList();
	javax.swing.JButton JButton2 = new javax.swing.JButton();
	javax.swing.JButton JButton3 = new javax.swing.JButton();
	//}}

    public void loadDocumentTitles(String s)
    {
        DICOM.Code.CodeManager mgr = new DICOM.Code.CodeManager();
        java.util.Vector v = mgr.readCodeTable(s);
        int i = 0;

        for (i = 0; i < v.size(); i++) {
            DICOM.Code.CodeItem item = (DICOM.Code.CodeItem)v.elementAt(i);
            documentTitle.addItem(item.codeMeaning());
        }
    }
    public void loadKeyImages(String s[])
    {
        String headings[] = {"Name", "ID", "Acc #", "Date", "Series", "Ima"};
        int count = s.length;
        try {
            keyImageList.setHeadings(headings);
        }
        catch (java.beans.PropertyVetoException e) {}

        if (count > 0) {
            String rows[] = new String[count];
            mFileNames = new String[count];
            int i = 0;
            for (i = 0; i < count; i++) {
                mFileNames[i] = new String(s[i]);
                rows[i] = this.formatImageForList(s[i]);
            }
            try {
                keyImageList.setListItems(rows);
            }
            catch (java.beans.PropertyVetoException e) {}            
        }
    }
    DICOM.Code.CodeItem getDocumentTitle(String s)
    {
        DICOM.Code.CodeManager mgr = new DICOM.Code.CodeManager();
        String title = (String)documentTitle.getSelectedItem();
        DICOM.Code.CodeItem item = mgr.matchMeaning(title, s);
        return item;
    }
    String getReportText() {
        String s = new String(keyImageDescrText.getText());
        return s;
    }
    String formatImageForList(String s)
    {
        DICOM.DICOMWrapper w = new DICOM.DICOMWrapper(s);
        String x = new String(w.getString((short)0x0010, (short)0x0010));
        x = x + ";" + w.getString((short)0x0010, (short)0x0020);
        x = x + ";" + w.getString((short)0x0008, (short)0x0050);
        x = x + ";" + w.getString((short)0x0008, (short)0x0020);
        x = x + ";" + w.getString((short)0x0020, (short)0x0011);
        x = x + ";" + w.getString((short)0x0020, (short)0x0013);

        return x;
    }
    String[] getFileNames() {
        if (mFileNames == null)
            return null;
            
        String[] s = new String[mFileNames.length];
        int i = 0;
        for (i = 0; i < mFileNames.length; i++) {
            s[i] = new String(mFileNames[i]);
        }
        return s;
    }
}