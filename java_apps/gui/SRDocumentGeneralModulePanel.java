import javax.swing.*;
import java.beans.*;
import java.awt.*;

import DICOM.Code.CodeManager;
import DICOM.Code.CodeItem;
import DICOM.Module.SRDocumentGeneralModule;

class SRDocumentGeneralModulePanel extends javax.swing.JPanel
{
    String mVerifyingObserverCodeFile;
    DICOM.Code.CodeManager mCodeManager;
    
	public SRDocumentGeneralModulePanel()
	{

		//{{INIT_CONTROLS
		setLayout(null);
		Insets ins = getInsets();
		setSize(502,479);
		JLabel1.setText("Instance Number");
		add(JLabel1);
		JLabel1.setBounds(36,36,135,29);
		add(instanceNumberText);
		instanceNumberText.setBounds(180,36,204,24);
		JLabel2.setText("Completion Flag");
		add(JLabel2);
		JLabel2.setBounds(36,84,135,29);
		add(completionFlagCombo);
		completionFlagCombo.setBounds(180,84,205,28);
		JLabel3.setText("Verification Flag");
		add(JLabel3);
		JLabel3.setBounds(36,240,135,29);
		JLabel4.setText("Content Date");
		add(JLabel4);
		JLabel4.setBounds(36,144,135,29);
		JLabel5.setText("Content Time");
		add(JLabel5);
		JLabel5.setBounds(36,192,135,29);
		JLabel6.setText("Verifying Observer");
		add(JLabel6);
		JLabel6.setBounds(36,300,135,29);
		JLabel7.setText("Verifying Organization");
		add(JLabel7);
		JLabel7.setBounds(36,360,135,29);
		JLabel8.setText("Verification Date Time");
		add(JLabel8);
		JLabel8.setBounds(36,408,135,29);
		add(verificationFlagCombo);
		verificationFlagCombo.setBounds(180,240,205,28);
		add(contentDateText);
		contentDateText.setBounds(180,144,204,24);
		add(contentTimeText);
		contentTimeText.setBounds(180,192,204,24);
		add(verifyingObserverCombo);
		verifyingObserverCombo.setBounds(204,300,205,28);
		add(verifyingOrganizationText);
		verifyingOrganizationText.setBounds(204,360,204,24);
		add(verificationDateTimeText);
		verificationDateTimeText.setBounds(204,408,204,24);
		//}}

		//{{REGISTER_LISTENERS
		//}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
	javax.swing.JTextField instanceNumberText = new javax.swing.JTextField();
	javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
	javax.swing.JComboBox completionFlagCombo = new javax.swing.JComboBox();
	javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel5 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel6 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel7 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel8 = new javax.swing.JLabel();
	javax.swing.JComboBox verificationFlagCombo = new javax.swing.JComboBox();
	javax.swing.JTextField contentDateText = new javax.swing.JTextField();
	javax.swing.JTextField contentTimeText = new javax.swing.JTextField();
	javax.swing.JComboBox verifyingObserverCombo = new javax.swing.JComboBox();
	javax.swing.JTextField verifyingOrganizationText = new javax.swing.JTextField();
	javax.swing.JTextField verificationDateTimeText = new javax.swing.JTextField();
	//}}

    void initialize(String verifyingObserverCodeFile) {
        completionFlagCombo.addItem("PARTIAL");
        completionFlagCombo.addItem("COMPLETE");
        verificationFlagCombo.addItem("UNVERIFIED");
        verificationFlagCombo.addItem("VERIFIED");

        mCodeManager = new DICOM.Code.CodeManager();
        mVerifyingObserverCodeFile = new String(verifyingObserverCodeFile);
        
        java.util.Vector v =
            mCodeManager.readCodeTable(verifyingObserverCodeFile);
        int i = 0;
        for (i = 0; i < v.size(); i++) {
            DICOM.Code.CodeItem item = (DICOM.Code.CodeItem)v.elementAt(i);
            verifyingObserverCombo.addItem(item.codeMeaning());
        }
    }
    
    DICOM.Module.SRDocumentGeneralModule getModule()
    {
        String x1 = instanceNumberText.getText();
        String x2 = (String)completionFlagCombo.getSelectedItem();
        String x3 = (String)verificationFlagCombo.getSelectedItem();
        String x4 = contentDateText.getText();
        String x5 = contentTimeText.getText();
        
        String x6, x7, x8, x9, x10, x11;
        if (x3.equals("VERIFIED")) {
            x6 = (String)verifyingObserverCombo.getSelectedItem();
            DICOM.Code.CodeItem item =
                mCodeManager.matchMeaning(x6, mVerifyingObserverCodeFile);
            x7 = item.codeValue();
            x8 = item.codeDesignator();
            x9 = item.codeMeaning();
            x10 = verifyingOrganizationText.getText();
            x11 = verificationDateTimeText.getText();
        } else {
            x6 = new String("");
            x7 = new String("");
            x8 = new String("");
            x9 = new String("");
            x10 = new String("");
            x11 = new String("");
        }
        
        DICOM.Module.SRDocumentGeneralModule m =
            new DICOM.Module.SRDocumentGeneralModule(x1, x2, x3, x4, x5,
            x6,x7,x8,x9,x10,x11);
        return m;
    }
}