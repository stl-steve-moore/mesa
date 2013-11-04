import javax.swing.*;
import java.beans.*;
import java.awt.*;

import DICOM.Module.GeneralEquipmentModule;

class GeneralEquipmentModulePanel extends javax.swing.JPanel
{
	public GeneralEquipmentModulePanel()
	{

		//{{INIT_CONTROLS
		setLayout(null);
		Insets ins = getInsets();
		setSize(430,270);
		JLabel2.setText("Manufacturer");
		add(JLabel2);
		JLabel2.setBounds(36,96,120,29);
		add(manufacturerText);
		manufacturerText.setBounds(168,96,204,24);
		//}}

		//{{REGISTER_LISTENERS
		//}}
	}

	//{{DECLARE_CONTROLS
	javax.swing.JLabel JLabel2 = new javax.swing.JLabel();
	javax.swing.JTextField manufacturerText = new javax.swing.JTextField();
	//}}

    public DICOM.Module.GeneralEquipmentModule getModule()
    {
        String s1 = manufacturerText.getText();
 
        DICOM.Module.GeneralEquipmentModule x =
            new DICOM.Module.GeneralEquipmentModule(s1);
        return x;
    }

    public void setModule(DICOM.Module.GeneralEquipmentModule x)
    {
        String s1;
        s1 = x.manufacturer();
        manufacturerText.setText(s1);
    }

}