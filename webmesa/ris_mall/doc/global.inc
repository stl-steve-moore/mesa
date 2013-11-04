<?php
$actor = array (
			'ordfil' => 'Order Filler',
			'adt'	 => 'ADT',
			'ordplc' => 'Order Placer',
			'acqmod' => 'Acquisition Modality',
			'pdc' => 'Patient Demographics Consumer',
			'imgmgr' => 'Image Manager',
			'unspecified' => 'Actions',
		);

$actor_link = array (
			'ordfil' => 'ordfil_main.php',
			'ordplc' => 'ordplc_main.php',
			'acqmod' => 'acqmod_main.php',
			'pdc' => 'pdc_main.php',
			'imgmgr' => 'imgmgr_main.php',
			'unspecified' => 'unspecified.php',
		);

$create_patient_link = array (
			'ordfil' => 'Click <a href="ordfil_main.php?source=ordfil">here</a> to go back to Order Filler test control page.',
			'ordplc' => 'Click <a href="ordplc_main.php?source=ordplc">here</a> to go back to Order Placer test control page.',
			'acqmod' => 'Click <a href="create_visit.php?source=acqmod">here</a> to Create a Visit.',
			'imgmgr' => 'Click <a href="create_visit.php?source=imgmgr">here</a> to Create a Visit.',
			'pdc' => 'Click <a href="send_iti-8-a04.php?source=pdc">here</a> to Send a ADT message.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$create_visit_link = array (
			'ordfil' => 'Click <a href="ordfil_main.php?source=ordfil">here</a> to create an Order.',
			'ordplc' => 'Click <a href="ordplc_main.php?source=ordplc">here</a> to create an Order.',
			'acqmod' => 'Click <a href="create_order.php?source=acqmod">here</a> to create an Order.',
			'imgmgr' => 'Click <a href="create_order.php?source=imgmgr">here</a> to create an Order.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$create_order_link = array (
			'ordfil' => 'Click <a href="send_order.php?source=ordfil">here</a> to send ORM.',
			'acqmod' => 'Click <a href="acqmod_main.php?source=acqmod">here</a> to go back to Acquisition Modaility test control page.',
			'imgmgr' => 'Click <a href="imgmgr_main.php?source=imgmgr">here</a> to go back to Image Manager test control page.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$send_admit_link = array (
			'ordfil' => 'Click <a href="ordfil_main.php?source=ordfil">here</a> to go back to Order Filler test control page.',
			'ordplc' => 'Click <a href="ordplc_main.php?source=ordplc">here</a> to go back to Order Placer test control page.',
			'pdc' => 'Click <a href="pdc_main.php?source=pdc">here</a> to go back to Patient Demographics Consumer control page.',
			'acqmod' => 'Click <a href="send_order.php?source=acqmod">here</a> to send ORM to DSS/OFF.',
			'imgmgr' => 'Click <a href="send_order.php?source=imgmgr">here</a> to send ORM to DSS/OFF.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$send_admit_link2 = array (
			'acqmod' => 'Click <a href="acqmod_main.php?source=acqmod">here</a> to go back to Acquisition Modality test control page.',
			'imgmgr' => 'Click <a href="imgmgr_main.php?source=imgmgr">here</a> to go back to Image Manager test control page.',
		);

$send_order_link = array (
			'ordfil' => 'Click <a href="ordfil_main.php?source=ordfil\">here</a> to go back to Order Filler test control page.',
			'acqmod' => 'Click <a href="acqmod_main.php?source=acqmod">here</a> to go back to Acquisition Modaility test control page.',
			'imgmgr' => 'Click <a href="imgmgr_main.php?source=imgmgr">here</a> to go back to Image Manager test control page.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$send_order_link2 = array (
			'acqmod' => 'Click <a href="schedule_procedure.php?source=acqmod">here</a> to schedule MWL on MESA system.',
		);

$schedule_procedure_link = array (
			'acqmod' => 'Click <a href="acqmod_main.php?source=acqmod">here</a> to go back to Acquisition Modaility test control page.<p><pre>    Or</pre></p>Click <a href="send_schedule.php?source=acqmod">here</a> to send a scheduling message to Image Manager.',
			'imgmgr' => 'Click <a href="imgmgr_main.php?source=imgmgr">here</a> to go back to Image Manager test control page.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$send_rename_link = array (
			'ordfil' => 'Click <a href="ordfil_main.php?source=ordfil">here</a> to go back to Order Filler test control page.',
			'ordplc' => 'Click <a href="ordplc_main.php?source=ordplc\">here</a> to go back to Order Placer test control page.',
			'imgmgr' => 'Click <a href="imgmgr_main.php?source=imgmgr">here</a> to go back to Image Manager test control page.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$send_merge_link = array (
			'ordfil' => 'Click <a href="ordfil_main.php?source=ordfil">here</a> to go back to Order Filler test control page.',
			'ordplc' => 'Click <a href="ordplc_main.php?source=ordplc\">here</a> to go back to Order Placer test control page.',
			'imgmgr' => 'Click <a href="imgmgr_main.php?source=imgmgr">here</a> to go back to Image Manager test control page.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$send_discharge_link = array (
			'ordfil' => 'Click <a href="ordfil_main.php?source=ordfil">here</a> to go back to Order Filler test control page.',
			'ordplc' => 'Click <a href="ordplc_main.php?source=ordplc\">here</a> to go back to Order Placer test control page.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);

$send_schedule_link = array (
			'acqmod' => 'Click <a href="acqmod_main.php?source=acqmod">here</a> to go back to Acquisition Modaility test control page.',
			'imgmgr' => 'Click <a href="imgmgr_main.php?source=imgmgr">here</a> to go back to Image Manager test control page.',
			'unspecified' => 'Click <a href="unspecified.php?source=unspecified">here</a> to go back to Actions page.',
		);
?>
