<?php 
    $title = "Send Admit Message for Visit";
    $nativedb = "webadt";
    require "common_functions.inc";
    check_user_is_logged_in();
?>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>
	<META HTTP-EQUIV="CONTENT-TYPE" CONTENT="text/html; charset=windows-1252">
	<TITLE></TITLE>
	<META NAME="GENERATOR" CONTENT="StarOffice 7  (Win32)">
	<META NAME="AUTHOR" CONTENT="Robert Whitman">
	<META NAME="CREATED" CONTENT="20040119;21084073">
	<META NAME="CHANGEDBY" CONTENT="Robert Whitman">
	<META NAME="CHANGED" CONTENT="20040120;8495942">
	<STYLE>
	<!--
		@page { size: 8.5in 11in }
	-->
	</STYLE>
</HEAD>
<BODY LANG="en-US" DIR="LTR">

<?php 
    print_header($title);
    if (!empty($_GET["viskey"])) {
       $submit1="Visit ID";
       $filter1=$_GET["viskey"];
    }
    $process_form = false;
//    $submit = $_POST["submit"];
    
    if ($submit == "Name") {
        $verbose = $_POST["verbose"];
        $submit1 = $submit;
        $filter1 = $Namefilter;
    }
    if ($submit == "Patient ID") {
        $verbose = $_POST["verbose"];
        $submit1 = $submit;
        $filter1 = $PatIDfilter ;
                                                                                                                     
    }
    if ($submit == "Visit ID") {
        $verbose = $_POST["verbose"];
        $submit1 = $submit;
        $filter1 = $DOBfilter ;
    }
    if ($submit == "Send Message") {
        if (empty($viskey)) {
            print_user_error("Please select visit.");
        } else {
            $process_form = true;
        }
   if ($process_form) {
# Button has been pressed. First, create the hl7 message
# "Usage: perl mesa_construct_hl7.pl [-h] [-v] [-t tmpdir] \n";
# "\t[-T templateFile | -D templateDir] [-N newName] [-n oldName]\n";
# "\tmessage database visitID destID outputFile\n";
                                                                                
    $viskey = $_POST["viskey"];
# first, need to get patient class.  Lookup by the visit number.  This
# determines what message type we send.
    $visit = get_patient_visit_by_viskey($viskey, $nativedb);
    $patcla = rtrim($visit["patcla"]);
    switch ($patcla) {
        case "I": $message = "a01"; break;
        case "O": $message = "a04"; break;
        default: die ("Unknown Patient Class \"$patcla\" for viskey=$viskey");
    }
                                                                                
    $tmpdir = "$risMallRoot/tmp";
    $dest_id = rtrim($_POST["dest_id"]);
    $template = "$mesaTarget/templates/hl7/$message.tpl";
    $outputFile = $tmpdir."/$message.hl7";
    $verbose = $_POST["verbose"];
    $vflag = $verbose ? "-v" : "";
    $noSend = !empty($_POST["noSend"]); // if _POST[.] = "noSend", NOT empty
                                                                                
                                                                                
    $bin = "$mesaTarget/bin/mesa_construct_hl7.pl";
    $cmd = "perl $bin $vflag -t $tmpdir -V $viskey " .
        "$message $template $nativedb $dest_id $outputFile";
                                                                                
    execute_piped_command($cmd, $verbose);
                                                                                
    send_hl7($nativedb, $dest_id, $outputFile, $noSend, $verbose);
                                                                                
    logSendAdmit($viskey, $dest_id, $nativedb, !$noSend);
  }



    }

                                                                               
?>

<?php 
add_navigation();
?>

<form action="<?php $PHP_SELF;?>" method="post">    
<table WIDTH=611 BORDER=0 CELLPADDING=0 CELLSPACING=0>
			<THEAD>
				<Th WIDTH=1>
				</Th>
				<Th WIDTH=299>
					Sort:<INPUT TYPE=submit NAME="submit" VALUE="Name"> <br> Filter:<INPUT TYPE=TEXT NAME="Namefilter" value="" SIZE=9 >
				</Th>
				<Th WIDTH=30>
					<P><INPUT TYPE=submit NAME="submit" VALUE="Patient ID"><INPUT TYPE=TEXT NAME="PatIDfilter" SIZE=27></P>
				</Th>
				<Th WIDTH=30>
					<P><INPUT TYPE=submit NAME="submit" VALUE="Visit ID"><INPUT TYPE=TEXT NAME="DOBfilter" SIZE=15></P>
				</Th>
				<Th WIDTH=1>
					<P><BR>
					</P>
				</th>
			</thead>
			<TR VALIGN=TOP>
				 <? NEWgetVisitList($_POST["viskey"], $nativedb, $submit1,$filter1) ?>
			</TR>
</table>
<br>
<table WIDTH=611 BORDER=0 CELLPADDING=0 CELLSPACING=0>
                                                                   
                                                                                  
        <tr>
            <th align=right>Destination:
            <td align=left><select name="dest_id">
                <? getDestinationList($_POST["dest_id"], $nativedb) ?>
                </select>
        <tr>
            <th align=right>Debugging Output:
            <td align=left><input type="checkbox" name="verbose" value="verbose" <?=$_POST["verbose"] ? "checked" : "" ?>>
        <tr>
            <th align=right>Do Not Send Message:
            <td align=left><input type="checkbox" name="noSend" value="noSend">
        <tr>
            <td colspan=2 align=center>
            <input type=submit name="submit" value="Send Message">
    </table>
</FORM>

<? include "footer.inc" ?>
<?php   end_navigation(); 

?>

</BODY>
</HTML>
