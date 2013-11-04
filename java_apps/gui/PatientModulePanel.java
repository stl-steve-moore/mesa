import javax.swing.*;
import java.beans.*;
import java.awt.*;
import DICOM.Module.PatientModule;

public class PatientModulePanel extends javax.swing.JPanel
{
	public PatientModulePanel()
	{

		//{{INIT_CONTROLS
		setLayout(null);
		Insets ins = getInsets();
		setSize(430,270);
		JLabel1.setText("Patient Name");
		add(JLabel1);
		JLabel1.setBounds(36,36,135,29);
		JLabel2.setText("Patient ID");
		add(JLabel2);
		JLabel2.setBounds(36,84,103,25);
		JLabel3.setText("Birth Date");
		add(JLabel3);
		JLabel3.setBounds(36,132,90,21);
		JLabel4.setText("Sex");
		add(JLabel4);
		JLabel4.setBounds(36,180,104,25);
		add(patientNameText);
		patientNameText.setBounds(180,36,204,24);
		add(patientIDText);
		patientIDText.setBounds(180,84,204,24);
		add(birthDateText);
		birthDateText.setBounds(180,132,204,24);
		add(sexText);
		sexText.setBounds(180,180,204,24);
		//}}

		//{{REGISTER_LISTENERS
		//}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel4 = new javax.swing.JLabel();
	javax.swing.JTextField patientNameText = new javax.swing.JTextField();
	javax.swing.JTextField patientIDText = new javax.swing.JTextField();
	javax.swing.JTextField birthDateText = new javax.swing.JTextField();
	javax.swing.JTextField sexText = new javax.swing.JTextField();
	//}}

    public DICOM.Module.PatientModule getPatientModule()
    {
        String s1 = patientNameText.getText();
        String s2 = patientIDText.getText();
        String s3 = birthDateText.getText();
        String s4 = sexText.getText();
        DICOM.Module.PatientModule p =
            new DICOM.Module.PatientModule(s1, s2, s3, s4);
        return p;
    }
    public void setPatientModule(DICOM.Module.PatientModule p)
    {
        String s1;
        s1 = p.patientName();
        patientNameText.setText(s1);
        s1 = p.patientID();
        patientIDText.setText(s1);
        s1 = p.birthDate();
        birthDateText.setText(s1);
        s1 = p.sex();
        sexText.setText(s1);
    }
}