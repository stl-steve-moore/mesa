package edu.wustl.mir.mesaweb;

// HtmlHelper.java
// Amy Hawkins
// 6-26-01

// This class encapsulates some of the html formatting needed by ImageManager.java. This avoids repeating code
// and makes ImageManager much cleaner.

import java.io.*;
import java.util.*;
import java.sql.*;

public class HtmlHelper {

    private Connection db;

    public HtmlHelper (Connection db) { 
	this.db = db;
    }


    public String printHeader (String header) {
	String result = ("<HTML>\n" + 
			 "<HEAD><TITLE>" + header + "</TITLE></HEAD>\n" +
			 "<BODY>\n" + 
			 "<H2>" + header + "</H2>\n");
	return result;
    }


    public String printRadioOptions (String table) {
	// table is either "study", "series" or "image"

	String plural = "";
	if (table.equals ("study")) plural = "studies";
	else if (table.equals ("series")) plural = "series";
	else plural = "images";

	String next = "";
	if (table.equals ("study")) next = "series";
	else if (table.equals ("series")) next = "image";
	else next = null;


	String result = "";
	result += ("<br><br>Your options include the following:<br>\n");
      	result += ("<INPUT TYPE=radio NAME=option VALUE=delete>" + 
		   "Delete a " + table + " or multiple " + plural + " <I>permanently</I> from the server " +
		   "(please check one or more " + plural + " to delete)<br>\n");
	result += ("<INPUT TYPE=radio NAME=option VALUE=export>" +
		   "Export a " + table + " or multiple " + plural + " to a DICOM receiver or to a local " +
		   "file (please check one or more " + plural + " to export)<br>\n");
	if (next != null) {
	    result += ("<INPUT TYPE=radio NAME=option VALUE=update>" + 
		       "Update " + table + " information (please check only one " + table + ")<br>\n");
	    result += ("<INPUT TYPE=radio checked NAME=option VALUE=view>" + 
		       "View " + next + " information about a selected " + table + 
		       " (please check only one " + table +")<br>\n");
	}
	result += ("<INPUT TYPE=submit VALUE=GO!><br><br>\n");

	return result;
    }


    // taken from the servlet book, but modified somewhat for checkbox functionality and formatting 
    public String printTable (String query, String checkboxName, String checkboxVal, boolean checkboxes) {
	// checkboxName and checkboxVal are used for form parameters for the checkboxes
	// name should be the name of the table being used
	// val should be the unique identifier for that table
	// assumes that the unique identifier is NOT shown in the table, and is included LAST in the query

	String result = ("<P>Results of SQL statement: " + query + "<P>\n");

	try {
	    Statement st = db.createStatement ();
	    if (st.execute (query)) {
		ResultSet rs = st.getResultSet();
		
		result += ("<P><TABLE BORDER cellspacing=0 cellpadding = 5>\n");
		
		ResultSetMetaData rsm = rs.getMetaData();
		int numCols = rsm.getColumnCount ();
		
		result += "<TR>\n";
		if (checkboxes) result += "<TH></TH>\n";  
		int stopLoop = numCols;
		if (checkboxName.equals("ps_view")) stopLoop -= 1;  // need to skip last col (unique id col)
		if (checkboxName.equals("series") || checkboxName.equals("sopins")) stopLoop -=2; // skip last 2

		for (int i = 1; i <= stopLoop; i++) {

		    result += ("<TH>" + format(rsm.getColumnLabel(i), checkboxName + "_header", i) + "</TH>\n");
		}

		result +="</TR>\n";

		while (rs.next()) {
		    result += "<TR>\n";
		    if (checkboxes) 
			result += ("<TD><INPUT TYPE=checkbox NAME=" + checkboxName + " VALUE=" + 
			           rs.getString(checkboxVal).trim() + "></TD>\n"); 

		    for (int i = 1; i <= stopLoop; i++) { 
			result += "<TD>";
			String val = rs.getString(i);
			if (val == null) {
			    val = "----";
			}

			val = val.trim();
			if (val.equals("") || val.equals("^")) result += ("----</TD>\n");
			else result += (format (val, checkboxName, i) + "</TD>\n");
		    }
		    result += "</TR>\n\n";
		}
		result += "</TABLE>\n";
	    }else {
		result += ("<B>Records affected:</B> " + st.getUpdateCount() + "\n");
	    }
	}catch (SQLException se) {
	    result += ("</TABLE> " + se.getMessage() + "\n");
	}   
	return result;
    }

    
    public String format (String val, String tableName, int col) {
	if (tableName.equals("ps_view_header")) {
	    switch (col) {
	    case 1:  val = "Patient Name";        break;
	    case 2:  val = "Patient ID";          break;
	    case 3:  val = "Patient's DOB";       break;
	    case 4:  val = "Study Date";          break;
	    case 5:  val = "Accession Number";    break;
	    case 6:  val = "Study ID";            break;
	    case 7:  val = "Modalities";          break;
	    case 8:  val = "Series Count";        break;
	    case 9:  val = "Image Count";         break;
	    case 10: val = "Study Description";   break;
	    case 11: val = "Referring Physician"; break;
	    }
	}
	else if (tableName.equals("ps_view")) {
	    switch (col) {
	    case 1:  val = formatName(val); break;  // patient name
	    case 2:                         break;  // patient id 
	    case 3:  val = formatDate(val); break;  // DOB
	    case 4:  val = formatDate(val); break;  // study date
	    case 5:                         break;  // accession number
	    case 6:                         break;  // study id
	    case 7:                         break;  // modalities
	    case 8:                         break;  // number of of series
	    case 9:                         break;  // number of images
	    case 10:                        break;  // description
	    case 11: val = formatName(val); break;  // physician's name
	    }
	}
	else if (tableName.equals("series_header")) {
	    switch (col) {
	    case 1: val = "Series Number";      break;
	    case 2: val = "Modalities";         break;
	    case 3: val = "Image Count";        break;
	    case 4: val = "Series Description"; break;
	    }
	}
	else if (tableName.equals("series")) {
	    // no special formatting necessary here
	}
	else if (tableName.equals("sopins_header")) {
	    switch (col) {
	    case 1: val = "Image Number";   break;
	    case 2: val = "Rows";           break;
	    case 3: val = "Columns";        break;
	    case 4: val = "Bits Per Pixel"; break;
	    }
	}
	else if (tableName.equals("sopins")) {
	    // no special formatting necessary here
	}
	else if (tableName.equals("work_orders_header")) {
	    switch (col) {
	    case 1:  val = "Order Number";   break;
	    case 2:  val = "Type";           break;
	    case 3:  val = "Parameters";     break;
	    case 4:  val = "Ordered By";     break;
	    case 5:  val = "Date Ordered";   break;
	    case 6:  val = "Time Ordered";   break;
	    case 7:  val = "Date Completed"; break;
	    case 8:  val = "Time Completed"; break;
	    case 9:  val = "Elapsed Time";   break;
	    case 10: val = "Work Time";      break;
	    }
	}
	else if (tableName.equals("work_orders")) {
	    // there will probably be some date formatting here eventually
	}
	else if (tableName.equals("users_header")) {
	    switch (col) {
	    case 1: val = "Initials";     break;
	    case 2: val = "Name";         break; 
	    case 3: val = "Department";   break;
	    case 4: val = "Phone Number"; break;
	    case 5: val = "Email";        break;
	    case 6: val = "Last Update";  break;
	    case 7: val = "Status";       break;
	    }
	}
	else if (tableName.equals("users")) {
	    // there will probably be some date and name formatting here eventually
	}
	else if (tableName.equals("last_req_header")) {
	    switch (col) {
	    case 1: val = "Initials";             break;
	    case 2: val = "Date of Last Request"; break;
	    case 3: val = "Type of Request";      break;
	    }
	}
	else if (tableName.equals("last_req")) {
	    // there will probably be some date formatting here eventually
	}

	return val;
    }


    private String formatName (String val) {
	// Assumes that name is separated with carats. 
	// Looks for the first ^ and replaces with a comma. Replaces all further carats with a space.

	StringBuffer s = new StringBuffer (val);
	boolean first = true;

	for (int i = 0; i < s.length(); i++) {
	    if (s.charAt(i) == '^') {
		s.delete (i, i+1);
		if (first) { 
		    s.insert (i, ", "); 
		    first = false; 
		}
		else s.insert (i, " ");
	    }
	}

	val = s.toString().trim();
	if (val.endsWith(",")) val = val.replace (',', ' '); 
	return val.trim();
    }

    //Kind of ugly because the storage format in the database is inconsistent. All known formats are supported.
    private String formatDate (String val) {
	if (val.equals ("")) return val;

	int year = -2;
	int mon = -2;
	int day = -2;

	if (val.indexOf('.') == -1) {
	    // assumes date is in format "YYYYMMDD"
	    try {
		year = (new Integer (Integer.parseInt (val.substring (0,4)))).intValue();
		mon = (new Integer (Integer.parseInt (val.substring (4,6)))).intValue();
		day = (new Integer (Integer.parseInt (val.substring (6,8)))).intValue();		
	    }catch (NumberFormatException nfe) {
		return val;
	    }
	}else if (val.indexOf('.') >= 0) {
	    // assumes date is in format "YYYY.MM.DD" or "YYYY.MM"
	    try {
		year = (new Integer (Integer.parseInt (val.substring (0,4)))).intValue();
		mon = (new Integer (Integer.parseInt (val.substring (5,7)))).intValue();
		if (val.length() > 8)      // day is included
		    day = (new Integer (Integer.parseInt (val.substring (8,10)))).intValue();
	    }catch (NumberFormatException nfe) { 
		return val; 
	    }
	}
		
	// date format is unexpected
	if ((year < 1900) || (mon > 12) || (day > 31)) return val;
	
	String month = ("" + mon);
	if (mon < 10) month = ("0" + mon);
	String d = ("" + day);
	if (day < 10) d = ("0" + day);

	if (day == -2) return ("" + month + "-xx-" + year);
	else return ("" + month + "-" + d + "-" + year);
    }


    public String printSortOptions (String table, String query) {
	String result = "<P>Sort by: <SELECT NAME=sort SIZE=1>\n";
	try {
	    Statement st = db.createStatement();
	    st.execute (query);
	    ResultSet rs = st.getResultSet();
	    
	    ResultSetMetaData rsm = rs.getMetaData();
	    int numCols = rsm.getColumnCount();
	    int stopLoop = numCols;
	    if (table.equals("ps_view")) stopLoop -= 1;  // need to skip last col (unique id col)
	    if (table.equals("series") || table.equals("sopins")) stopLoop -=2; // skip last 2
	    String val;
	    for (int i = 1; i <= stopLoop; i++) {
		val = rsm.getColumnLabel(i).trim();
		if (i==1) result += ("<OPTION VALUE=" + val + " selected>" + format (val, table + "_header", i));
		else result += ("<OPTION VALUE=" + val + ">" + format (val, table + "_header", i));
		result += "\n";
	    }
	}catch (SQLException se) { result += ("\n" + se.getMessage()); }
	return (result + "</SELECT>");
    }

}
