import javax.swing.*;
import java.beans.*;
import java.awt.*;

import DICOM.Module.GeneralStudyModule;

class GeneralStudyModulePanel extends javax.swing.JPanel
{
	public GeneralStudyModulePanel()
	{

		//{{INIT_CONTROLS
		setLayout(null);
		Insets ins = getInsets();
		setSize(430,270);
		JLabel1.setText("Study UID");
		add(JLabel1);
		JLabel1.setBounds(24,36,97,24);
		JLabel2.setText("Study Date");
		add(JLabel2);
		JLabel2.setBounds(24,72,97,24);
		JLabel3.setText("Study Time");
		add(JLabel3);
		JLabel3.setBounds(24,108,97,24);
		JLabel4.setText("Referring Physician");
		add(JLabel4);
		JLabel4.setBounds(24,144,120,24);
		JLabel5.setText("Study ID");
		add(JLabel5);
		JLabel5.setBounds(24,180,97,24);
		JLabel6.setText("Accession Number");
		add(JLabel6);
		JLabel6.setBounds(24,216,120,24);
		add(studyUIDText);
		studyUIDText.setBounds(180,36,204,24);
		add(studyDateText);
		studyDateText.setBounds(180,72,204,24);
		add(studyTimeText);
		studyTimeText.setBounds(180,108,204,24);
		add(referringPhysicianText);
		referringPhysicianText.setBounds(180,144,204,24);
		add(studyIDText);
		studyIDText.setBounds(180,180,204,24);
		add(accessionNumberText);
		accessionNumberText.setBounds(180,216,204,24);
		//}}

		//{{REGISTER_LISTENERS
		//}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel5 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel6 = new javax.swing.JLabel();
	javax.swing.JTextField studyUIDText = new javax.swing.JTextField();
	javax.swing.JTextField studyDateText = new javax.swing.JTextField();
	javax.swing.JTextField studyTimeText = new javax.swing.JTextField();
	javax.swing.JTextField referringPhysicianText = new javax.swing.JTextField();
	javax.swing.JTextField studyIDText = new javax.swing.JTextField();
	javax.swing.JTextField accessionNumberText = new javax.swing.JTextField();
	//}}

    public DICOM.Module.GeneralStudyModule getModule()
    {
        String s1 = studyUIDText.getText();
        String s2 = studyDateText.getText();
        String s3 = studyTimeText.getText();
        String s4 = referringPhysicianText.getText();
        String s5 = studyIDText.getText();
        String s6 = accessionNumberText.getText();
        DICOM.Module.GeneralStudyModule study =
            new DICOM.Module.GeneralStudyModule(s1, s2, s3, s4, s5, s6);
        return study;
    }
    public void setModule(DICOM.Module.GeneralStudyModule study)
    {
        String s1;
        s1 = study.studyUID();
        studyUIDText.setText(s1);
        s1 = study.studyDate();
        studyDateText.setText(s1);
        s1 = study.studyTime();
        studyTimeText.setText(s1);
        s1 = study.referringPhysician();
        referringPhysicianText.setText(s1);
        s1 = study.studyID();
        studyIDText.setText(s1);
        s1 = study.accessionNumber();
        accessionNumberText.setText(s1);
    }

}