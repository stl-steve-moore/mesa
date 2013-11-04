import javax.swing.*;
import java.beans.*;
import java.awt.*;
import symantec.itools.awt.MultiList;
import symantec.itools.awt.shape.HorizontalLine;

import DICOM.Code.CodeManager;
import DICOM.Code.CodeItem;
import DICOM.SR.ContentItem;
import DICOM.SR.ContentItemFactory;
import symantec.itools.awt.InvisibleButton;

class IHEY2ObsContextPanel extends javax.swing.JPanel
{
    String mListItems[];
    String mConceptNameFile;
    String mCodeTypeFile;
    String mCodedEntriesFile;
    java.util.Vector mContentItemVector;
    DICOM.SR.ContentItemFactory mFactory;
    DICOM.Code.CodeManager mCodeManager;

	public IHEY2ObsContextPanel()
	{

		//{{INIT_CONTROLS
		setLayout(null);
		Insets ins = getInsets();
		setSize(553,568);
		add(horizontalLine1);
		horizontalLine1.setBounds(12,216,504,2);
		add(obsContextConceptNameCode);
		obsContextConceptNameCode.setBounds(132,240,360,27);
		add(obsContextType);
		obsContextType.setBounds(132,288,360,27);
		add(obsContextText);
		obsContextText.setBounds(132,336,360,24);
		JButton1.setText("Add");
		add(JButton1);
		JButton1.setBounds(216,432,120,24);
		JButton1.setActionCommand("Add");
		add(obsContextCodedValue);
		obsContextCodedValue.setBounds(132,384,360,27);
		JLabel1.setText("Obs Context");
		add(JLabel1);
		JLabel1.setBounds(24,240,70,15);
		JLabel2.setText("Type");
		add(JLabel2);
		JLabel2.setBounds(24,288,27,15);
		JLabel3.setText("Free Text");
		add(JLabel3);
		JLabel3.setBounds(24,336,53,15);
		JLabel4.setText("Coded Value");
		add(JLabel4);
		JLabel4.setBounds(24,384,71,15);
		JPanel1.setOpaque(false);
		JPanel1.setAutoscrolls(true);
		JPanel1.setLayout(new BoxLayout(JPanel1,BoxLayout.X_AXIS));
		add(JPanel1);
		JPanel1.setBounds(24,480,504,48);
		try {
			{
				String[] tempString = new String[3];
				tempString[0] = "Concept Name";
				tempString[1] = "Type";
				tempString[2] = "Text";
				observationContextList.setHeadings(tempString);
			}
		}
		catch(java.beans.PropertyVetoException e) { }
		add(observationContextList);
		observationContextList.setBackground(java.awt.Color.white);
		observationContextList.setBounds(24,12,504,180);
		//}}

		//{{REGISTER_LISTENERS
		SymAction lSymAction = new SymAction();
		JButton1.addActionListener(lSymAction);
		//SymComponent aSymComponent = new SymComponent();
		//this.addComponentListener(aSymComponent);
		SymFocus aSymFocus = new SymFocus();
		this.addFocusListener(aSymFocus);
		//}}
		//String[] headings = {"Code", "Type", "Text"};
		//try {
    	//	observationContextList.setHeadings(headings);
    	//} catch (java.beans.PropertyVetoException e) {}
	}

	//{{DECLARE_CONTROLS
	symantec.itools.awt.shape.HorizontalLine horizontalLine1 = new symantec.itools.awt.shape.HorizontalLine();
	javax.swing.JComboBox obsContextConceptNameCode = new javax.swing.JComboBox();
	javax.swing.JComboBox obsContextType = new javax.swing.JComboBox();
	javax.swing.JTextField obsContextText = new javax.swing.JTextField();
	javax.swing.JButton JButton1 = new javax.swing.JButton();
	javax.swing.JComboBox obsContextCodedValue = new javax.swing.JComboBox();
	javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
	javax.swing.JPanel JPanel1 = new javax.swing.JPanel();
	symantec.itools.awt.MultiList observationContextList = new symantec.itools.awt.MultiList();
	//}}

    void loadCodes(String conceptNameFile, String codeTypeFile, String codedEntries)
    {
        DICOM.Code.CodeManager mgr = new DICOM.Code.CodeManager();
        mConceptNameFile = new String(conceptNameFile);
        mCodeTypeFile = new String(codeTypeFile);
        mCodedEntriesFile = new String(codedEntries);
        
        java.util.Vector v = mgr.readCodeTable(mConceptNameFile);
        int i = 0;
        for (i = 0; i < v.size(); i++) {
            DICOM.Code.CodeItem item = (DICOM.Code.CodeItem)v.elementAt(i);
            obsContextConceptNameCode.addItem(item.codeMeaning());
        }
        v = mgr.readCodeTable(mCodeTypeFile);
        for (i = 0; i < v.size(); i++) {
            DICOM.Code.CodeItem item = (DICOM.Code.CodeItem)v.elementAt(i);
            obsContextType.addItem(item.codeMeaning());
        }
        v = mgr.readCodeTable(mCodedEntriesFile);
        for (i = 0; i < v.size(); i++) {
            DICOM.Code.CodeItem item = (DICOM.Code.CodeItem)v.elementAt(i);
            obsContextCodedValue.addItem(item.codeMeaning());
        }
        //observationContextList.setVisible(true);
    }

	class SymAction implements java.awt.event.ActionListener
	{
		public void actionPerformed(java.awt.event.ActionEvent event)
		{
			Object object = event.getSource();
			if (object == JButton1)
				JButton1_actionPerformed(event);
		}
	}

	void JButton1_actionPerformed(java.awt.event.ActionEvent event)
	{
		// to do: code goes here.
		String conceptName = (String)obsContextConceptNameCode.getSelectedItem();
		String codeType = (String)obsContextType.getSelectedItem();
	    String textValue = obsContextText.getText();
	    String codedEntry = (String)obsContextCodedValue.getSelectedItem();
	    String x = formatContentItem(conceptName, codeType, textValue, codedEntry);
	    //String x = new String(codeValue);
	    //x = x + ";" + codeType;
	    //x = x + ";" + textValue;
	    int existingItems = 0;
	    if (mListItems != null) {
	        existingItems = mListItems.length;
	    }
	    String cpy[] = mListItems;
	    int i;
	    mListItems = new String[existingItems+1];
	    for (i = 0; i < existingItems; i++) {
	        mListItems[i] = new String(cpy[i]);
	    }
	    mListItems[existingItems] = new String(x);
	    //for (i = existingItems+1; i < existingItems+1+10; i++) {
	    //    mListItems[i] = new String(";;");
	    //}

	    try {
    	    observationContextList.setListItems(mListItems);
    	} catch (java.beans.PropertyVetoException e) {}
    	updateContentItemVector(conceptName, codeType, textValue, codedEntry);
	}
	
	String formatContentItem(String conceptName, String codeType,
	                             String textValue, String codedEntry)
	{
        if (mContentItemVector == null) {
            mContentItemVector = new java.util.Vector(1,1);
            mFactory = new DICOM.SR.ContentItemFactory();
            mCodeManager = new DICOM.Code.CodeManager();
        }
        //DICOM.Code.CodeItem item1 =
        //    mCodeManager.matchMeaning(codeValue, mCodeValueFile);
        DICOM.Code.CodeItem item2 =
            mCodeManager.matchMeaning(codeType, mCodeTypeFile);

        String x = new String(conceptName + ";");
        
        if (item2.codeValue().equals("PNAME")) {
            x = x + "PNAME;" + textValue;
        } else if (item2.codeValue().equals("TEXT")) {
            x = x + "TEXT;" + textValue;
        } else if (item2.codeValue().equals("CODE")) {
            x = x + "CODE;" + codedEntry;
        } else {
            x = x + "xxxx;" + textValue;
        }
        return x;
    }	
	void updateContentItemVector(String conceptName, String codeType,
	                             String textValue, String codedEntry)
	{
        if (mContentItemVector == null) {
            mContentItemVector = new java.util.Vector(1,1);
            mFactory = new DICOM.SR.ContentItemFactory();
            mCodeManager = new DICOM.Code.CodeManager();
        }
        DICOM.Code.CodeItem item1 =
            mCodeManager.matchMeaning(conceptName, mConceptNameFile);
        DICOM.Code.CodeItem item2 =
            mCodeManager.matchMeaning(codeType, mCodeTypeFile);
        DICOM.Code.CodeItem item3 =
            mCodeManager.matchMeaning(codedEntry, mCodedEntriesFile);

        DICOM.SR.ContentItem contentItem =
            createContentItem(item1, item2, textValue, item3);
        mContentItemVector.addElement(contentItem);
    }
    
    DICOM.SR.ContentItem createContentItem(DICOM.Code.CodeItem itemValue,
                                           DICOM.Code.CodeItem itemType,
                                           String txt,
                                           DICOM.Code.CodeItem codedEntry)
    {
        DICOM.SR.ContentItem item;
        if (itemType.codeValue().equals("PNAME")) {
            item = mFactory.producePName(itemValue, txt);
        } else if (itemType.codeValue().equals("TEXT")) {
            item = mFactory.produceText(itemValue, "HAS OBS CONTEXT", txt);
        } else if (itemType.codeValue().equals("CODE")) {
            item = mFactory.produceCode(itemValue, "HAS OBS CONTEXT", codedEntry);
        } else {
            item = mFactory.produceText(itemValue, "HAS OBS CONTEXT", txt);
        }
        return item;
    }
    
    public java.util.Vector observationContextVector() {
        return mContentItemVector;
    }


	class SymFocus extends java.awt.event.FocusAdapter
	{
		public void focusGained(java.awt.event.FocusEvent event)
		{
			Object object = event.getSource();
			if (object == IHEY2ObsContextPanel.this)
				IHEY2ObsContextPanel_focusGained(event);
		}
	}

	void IHEY2ObsContextPanel_focusGained(java.awt.event.FocusEvent event)
	{
		// to do: code goes here.
		observationContextList.setVisible(true);
		System.out.println("Made it visible");
			 
	}
}