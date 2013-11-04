import javax.swing.*;
import java.beans.*;
import java.awt.*;
import java.util.TreeMap;

import DICOM.Module.SOPCommonModule;

class SOPCommonModulePanel extends javax.swing.JPanel
{
    java.util.TreeMap mMap;
	public SOPCommonModulePanel()
	{

		//{{INIT_CONTROLS
		setLayout(null);
		Insets ins = getInsets();
		setSize(430,270);
		JLabel1.setText("SOP Class");
		add(JLabel1);
		JLabel1.setBounds(36,36,135,29);
		JLabel2.setText("SOP Instance");
		add(JLabel2);
		JLabel2.setBounds(36,96,135,29);
		add(sopClassComboBox);
		sopClassComboBox.setBounds(168,36,228,38);
		add(sopInstanceText);
		sopInstanceText.setBounds(168,96,204,24);
		//}}

        mMap = new java.util.TreeMap();
        
		//{{REGISTER_LISTENERS
		//}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
	javax.swing.JComboBox sopClassComboBox = new javax.swing.JComboBox();
	javax.swing.JTextField sopInstanceText = new javax.swing.JTextField();
	//}}

    public void addEntry(String classUID, String classText)
    {
        mMap.put(classText, classUID);
        sopClassComboBox.addItem(classText);
    }
    public DICOM.Module.SOPCommonModule getModule()
    {
        String s1 = (String)sopClassComboBox.getSelectedItem();
        s1 = (String)mMap.get(s1);
        String s2 = sopInstanceText.getText();

        DICOM.Module.SOPCommonModule x =
            new DICOM.Module.SOPCommonModule(s1, s2);
        return x;
    }
}