import javax.swing.*;
import java.beans.*;
import java.awt.*;

import DICOM.Module.SRDocumentSeriesModule;

class SRDocumentSeriesModulePanel extends javax.swing.JPanel
{
	public SRDocumentSeriesModulePanel()
	{

		//{{INIT_CONTROLS
		setLayout(null);
		Insets ins = getInsets();
		setSize(430,270);
		JLabel1.setText("Modality");
		add(JLabel1);
		JLabel1.setBounds(36,36,135,29);
		add(modalityText);
		modalityText.setBounds(180,36,204,24);
		JLabel2.setText("Series Ins UID");
		add(JLabel2);
		JLabel2.setBounds(36,84,135,29);
		JLabel3.setText("Series Number");
		add(JLabel3);
		JLabel3.setBounds(36,132,135,29);
		add(seriesUIDText);
		seriesUIDText.setBounds(180,84,204,24);
		add(seriesNumberText);
		seriesNumberText.setBounds(180,132,204,24);
		//}}

		//{{REGISTER_LISTENERS
		//}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JLabel JLabel1 = new javax.swing.JLabel();
	javax.swing.JTextField modalityText = new javax.swing.JTextField();
	javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
	javax.swing.JLabel JLabel3 = new javax.swing.JLabel();
	javax.swing.JTextField seriesUIDText = new javax.swing.JTextField();
	javax.swing.JTextField seriesNumberText = new javax.swing.JTextField();
	//}}


    public DICOM.Module.SRDocumentSeriesModule getModule()
    {
        String s1 = modalityText.getText();
        String s2 = seriesUIDText.getText();
        String s3 = seriesNumberText.getText();
 
        DICOM.Module.SRDocumentSeriesModule x =
            new DICOM.Module.SRDocumentSeriesModule(s1, s2, s3);
        return x;
    }

    public void setModule(DICOM.Module.SRDocumentSeriesModule x)
    {
        String s1;
        s1 = x.modality();
        modalityText.setText(s1);
        s1 = x.seriesUID();
        seriesUIDText.setText(s1);
        s1 = x.seriesNumber();
        seriesNumberText.setText(s1);
    }
}