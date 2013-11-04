package edu.wustl.mir.mesaweb;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import java.text.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class IMStudyPage extends HttpServlet {
    
   
    public void doStudyQuery (PrintWriter out, HtmlHelper html, SQLStatement quer,
		String[] argNames, String[] args, String[] modsChecked, String sortBy, String err) { 
	String tableName = "ps_view";
	String primaryCol = "stuinsuid";

	String query = studyQuerySQLHelp (args, argNames, quer, modsChecked, sortBy);
	// this method for formatting the SQL statement is found below
	
	out.println (html.printHeader ("Study Level Information"));
	if (err != null)
	  out.println ("<H1><FONT COLOR=#800080><B>ERROR:</B> " + err + "</FONT></H1>");

	out.println ("IMStudyPage <BR> \n");
       	out.println ("<FORM ACTION='/servlet/ImageManager'>");
	out.println ("<INPUT TYPE=hidden NAME=action VALUE=sortStudy>");
	out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + query + "\">");
	out.println (html.printSortOptions ("ps_view", query));
	out.println ("<INPUT TYPE=submit VALUE='Sort Table'><br><br>\n");
	out.println ("</FORM>\n");

       	out.println ("<FORM ACTION='/servlet/ImageManager'>");
	out.println ("<INPUT TYPE=hidden NAME=action VALUE=studyOptions>");
	out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + query + "\">");
	out.println (html.printTable (query, tableName, primaryCol, true));
	out.println (html.printRadioOptions ("study"));
	out.println ("</FORM>\n");
	out.println ("</BODY></HTML>");
    }

    public void exportStudies (PrintWriter out, Connection db, HtmlHelper html, HttpServletRequest req) { 
      String[] receivers = req.getParameterValues("receivers");
      if (receivers == null) {
	System.out.println("No receivers");
	return;
      }
      String[] studies = req.getParameterValues("stuinsuid");
      if (studies == null) {
	System.out.println("No studies");
	return;
      }
      int ix = 0;
      int iy = 0;
      String insertBase =
	"insert into work_orders (typ, params, ordbyin, datord, " +
	" timord, status) values(";
      for (ix = 0; ix < receivers.length; ix++) {
	for (iy = 0; iy < studies.length; iy++) {
	  String rcvr = receivers[ix];
	  String studyUID = studies[iy];
	  String sql = insertBase + formatExportStudyOrder(rcvr, studyUID, req);

	  Statement st = null;
	  try {
	    st = db.createStatement ();
	    st.execute (sql);
	  } catch (SQLException se) {
	    System.out.println("Could not place entry in work_orders");
	    System.out.println(sql);
	  }
	}
      }
    }

    // Private methods below this line
    private String studyQuerySQLHelp (String[] args, String[] argNames,
		SQLStatement quer, String[] modsChecked, String sortBy) {
	String query = "";
	if (argNames == null && args == null && quer != null) { 
	    if (sortBy == null) query = quer.toString(); 
	    else {
		quer.addToOrderBy (null);
		quer.addToOrderBy (sortBy.trim());
		query = quer.toString();
	    }
	}else {
	    // reconstruct a query entry from date args (3, 4, 5): data was entered as DD MM YYYY -- swap so they are in the same order as db (YYYY MM DD)
	    String temp = args[3]; String temp2 = argNames[3];
	    args[3] = args[5]; argNames[3] = argNames[5];
	    args[5] = temp;    argNames[5] = temp2;

	    String dateQ = "%";
	    SQLStatement sql = new SQLStatement ();
	    sql.addToSelect ("nam, patid, datbir, studat, accnum, stuid, modinstu, numser, numins, studes, refphynam, stuinsuid");
	    sql.addToFrom ("ps_view");
	    // this loop is a bit ugly because it takes care of making a good query for date and name, so the user doesn't have to type these exactly
	    for (int i = 0; i < args.length; i++) {
		if (args[i] != null && !(args[i].equals(""))) {
		    if (argNames[i].equals("nam")) sql.addToWhere (argNames[i], args[i] + "%", SQLStatement.LIKE);
		    else if (argNames[i].equals("year")) { dateQ += (args[i] + "%"); if (args[i+1].equals("")) dateQ += "__"; }
		    else if (argNames[i].equals("mon")) {
			if (args[i].length() == 1) args[i] = ("0" + args[i]); if (args[i-1].equals("")) dateQ += "____"; 
			dateQ += (args[i] + "%"); if (args[i+1].equals("")) dateQ += "_________";
		    }
		    else if (argNames[i].equals("day")) { if (args[i-1].equals("")) dateQ += "__"; dateQ += (args[i] + "%"); }
		    else sql.addToWhere (argNames[i], args[i], SQLStatement.NORMAL);
		}
	    }	    
	    if (dateQ.length() > 1) 
		sql.addToWhere ("studat", dateQ, SQLStatement.LIKE);
	    if (modsChecked != null) {
		for (int i = 0; i < modsChecked.length; i++) {
		    if (i == 0) 
			sql.addToWhere ("modinstu", modsChecked[i], SQLStatement.IN);
		    else 
			sql.addToWhere (null, modsChecked[i], SQLStatement.IN);
		}
	    }
	    if (sortBy == null) sql.addToOrderBy ("nam");
	    else {
		sql.addToOrderBy (null);
		sql.addToOrderBy (sortBy.trim());
	    }
	    query = sql.toString();
	}
	return query;
    }

    public void studyOptions (PrintWriter out, Connection db, HtmlHelper html, SQLStatement savedQuery, String[] studiesChecked, String option) {
	// studiesChecked array contains study id
	if (option.equals ("delete")) {
	    if (studiesChecked == null || studiesChecked.length == 0) {
		doStudyQuery (out, html, savedQuery, null, null, null, null, "Please select at least one study to delete.");
	    }else {
		deleteHelper (out, db, html, savedQuery, studiesChecked, "study"); // the helper method (below) constructs and executes the necessary SQL statements 
	    }
	}
	

	else if (option.equals ("export")) {
	    if (studiesChecked == null || studiesChecked.length == 0) {
		doStudyQuery (out, html, savedQuery, null, null, null, null, "Please select at least one study to export.");
	    }else {
		String tableName = "ps_view";
		String primaryCol = "stuinsuid";
		String q1= studyQuerySQLHelp (null, null, savedQuery, null, null);

		SQLStatement query = new SQLStatement (savedQuery);
		boolean first = true;
		for (int i = 0; i < studiesChecked.length; i++) {
		    if (first) { query.addToWhere ("stuinsuid", studiesChecked[i], SQLStatement.IN); first = false; }
		    else query.addToWhere (null, studiesChecked[i], SQLStatement.IN);
		}
		String result = "";

		out.println (html.printHeader ("Export Study"));
		out.println ("<FORM ACTION='/servlet/ImageManager'>");   // should this go to queue servlet instead?
		out.println ("<INPUT TYPE=hidden NAME=action VALUE=exportStudy>");
		out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + savedQuery + "\">");
		//out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + query + "\">");
		//out.println (html.printSortOptions ("ps_view", q1));
		int ix = 0;
		for (ix = 0; ix < studiesChecked.length; ix++) {
		  out.println ("<INPUT TYPE=hidden NAME=stuinsuid VALUE=\"" + studiesChecked[ix] + "\">");
		}

	        Statement st = null;

		ResultSet rs = null;
		ResultSetMetaData rsm = null;
		try {
		  st = db.createStatement ();
		  st.execute ("select aet, com from dicomapp");
		  rs = st.getResultSet ();
		  rsm = rs.getMetaData();
		} catch (SQLException se) {
		  out.println ("<P> SQL Exception " + se.getMessage() + "\n");
		}
		out.println ("<P> You have chosen to export the following studies:");

		out.println (html.printTable (query.toString(), "ps_view", "stuinsuid", false));

		out.println ("<P><br> If you would like to export these studies to a DICOM receiver, please select one below.<br>");
		//String q = "select aet, host, port, com from dicomapp";
		//out.println (html.printTable (q, "dicomapp", "aet", true));
		out.println ("<SELECT NAME=receivers SIZE=5>");

		try {
		  while (rs.next()) {
		    String x1 = rs.getString(1);
		    String x2 = rs.getString(2);
		    out.println ("<OPTION>" + x1 + " " + x2);
		  }
		} catch (SQLException se) {
		  out.println ("<P> SQL Exception " + se.getMessage() + "\n");
		}

		//out.println ("<OPTION>x" + x1);
		//out.println ("<OPTION>This will");
		//out.println ("<OPTION>later include");
		//out.println ("<OPTION>a selection");
		//out.println ("<OPTION>of DICOM");	
		//out.println ("<OPTION>recievers");
		//out.println ("<OPTION>for the user");
		//out.println ("<OPTION>to select.");
		out.println ("</SELECT><br><br><br>");

		out.println ("<P><H3> OR... </H3>");

		out.println ("<P><br> If you would like to save the studies to a local file, please select a format and enter "); 
		out.println ("a filename in the box below.<br>");
		out.println ("<INPUT TYPE=radio NAME=dicom>DICOM<br>");
		out.println ("<INPUT TYPE=radio NAME=jpeg1>JPEG (Lossless)<br>");
		out.println ("<INPUT TYPE=radio NAME=jpeg2>JPEG (Lossy)<br>");
		out.println ("<INPUT TYPE=radio NAME=tif>TIF<br>");
		out.println ("<INPUT TYPE=radio NAME=raw>RAW<br>");
		out.println ("Filename: <INPUT TYPE=text NAME=filnam><br><br>");

		out.println ("<INPUT TYPE=submit VALUE='Export Studies'>");
		out.println ("</FORM>\n");
		out.println ("</BODY></HTML>");
	    }

	    //do export stuff
	    //then kick back to study view
	    //doStudyQuery (out, savedQuery, null, null, null, null, "Export is not implemented at this time.");
	}
	

	else if (option.equals ("update")) {
	    if (studiesChecked == null || studiesChecked.length == 0) {
		doStudyQuery (out, html, savedQuery, null, null, null, null, "Please select a study to update.");
	    }else if (studiesChecked.length > 1) {
		doStudyQuery (out, html, savedQuery, null, null, null, null, "Please select only one study to update.");
	    }else {
		SQLStatement updateQuery = new SQLStatement (savedQuery);
		updateQuery.addToWhere ("stuinsuid", studiesChecked[0], SQLStatement.NORMAL);	    
				
		out.println (html.printHeader ("Update Study Level Information"));
		out.println ("<FORM ACTION='/servlet/ImageManager'>");
		out.println ("<INPUT TYPE=hidden NAME=action VALUE=updateStudy>");
		out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + savedQuery + "\">");
		out.println ("<INPUT TYPE=hidden NAME=updateQuery VALUE=\"" + updateQuery + "\">");
		out.println ("<P>You have chosen to update the information contained in this study. When ");
		out.println ("you are finished making changes, please click the update button. <br>");
		out.println ("<TABLE>");
		
		String result = formatUpdateTable (db, html, updateQuery, "study");  // this large and ugly formatting helper is found below 
		out.println (result);
		
		out.println ("</TABLE><br>");
		out.println ("<INPUT TYPE=submit VALUE=Update><br><br>");
		out.println ("</FORM>");
		out.println ("</BODY></HTML>");
	    }
	}
	

	else if (option.equals ("view")) {
	    if (studiesChecked == null || studiesChecked.length ==0) {
		doStudyQuery (out, html, savedQuery, null, null, null, null, "Please select a study to view.");
	    }else if (studiesChecked.length > 1) {
		doStudyQuery (out, html, savedQuery, null, null, null, null, "Please select only one study to view.");
	    }else {
		//SQLStatement seriesQuery = new SQLStatement ();
		//seriesQuery.addToSelect ("sernum, mod, numins, serdes, serinsuid, stuinsuid");
		//seriesQuery.addToFrom ("series");
		//seriesQuery.addToWhere ("stuinsuid", studiesChecked[0].trim(), SQLStatement.NORMAL);
		//doSeriesQuery (out, seriesQuery, "sernum", null);
	    }
	}

    }
    

    private void deleteHelper (PrintWriter out, Connection db, HtmlHelper html, SQLStatement savedQuery, String[] checked, String type) { 
	Statement st = null;
	ResultSet rs;
	try {
	    db.setAutoCommit(false);
	    st = db.createStatement();

	    if (type.equals("study")) {
		SQLStatement selectSeries = help("series", "stuinsuid", "select", "for", checked, null); // returns all series in each study marked 
		st.execute (selectSeries.toString());
		rs = st.getResultSet();

		SQLStatement selectImages = help("sopins", "serinsuid", "select", "while", checked, rs); // returns all images in each series selected above
		st.execute (selectImages.toString());
		rs = st.getResultSet();
		
		SQLStatement deleteImages = help("sopins", "insuid", "delete", "while", checked, rs);    // deletes all images returned above
		st.execute (deleteImages.toString());                 // deleting images now

		selectSeries.addToSelect (null);                      // clear out the SELECT clause
		selectSeries.addToDelete();                           // change to DELETE instead (delete all series from which images were just deleted)
		st.execute (selectSeries.toString());                 // deleting empty series

		selectSeries.addToFrom (null);                        // clear out FROM clause
		selectSeries.addToFrom ("ps_view");                   // change to study level
		st.execute (selectSeries.toString());                 // deleting empty study
	    }


	    else if (type.equals("series")) { 
	    }

	    
	    else if (type.equals("image")) {
	    }

	    db.commit();

	    if (type.equals("study")) doStudyQuery (out, html, savedQuery, null, null, null, null, null);
	    
	}catch (Exception e) {
	    if (type.equals("study")) doStudyQuery (out, html, savedQuery, null, null, null, null, ("Delete failed! " + e));
	    //else if (type.equals("series")) doSeriesQuery (out, savedQuery, null, ("Delete failed! " + e));
	    //else if (type.equals("image")) doImageQuery (out, savedQuery, ("Delete failed! " + e));

	    try { db.rollback(); }
	    catch (SQLException ignored) { }
	    finally { out.println ("<PRE>" + e + "</PRE>"); }
	}finally {
	    try { if (st != null) st.close(); }
	    catch (SQLException ignored) { }
	}
    }

    // Most of the ugliness of the following method was separated out into name and date helper methods (found further below).
    private String formatUpdateTable (Connection db, HtmlHelper html, SQLStatement updateQuery, String type) {
	String result = "";
	Statement st = null;

	try {
	    st = db.createStatement ();
	    st.execute (updateQuery.toString());
	    ResultSet rs = st.getResultSet (); rs.next();
	    ResultSetMetaData rsm = rs.getMetaData();
	    int col = rsm.getColumnCount();
	    
	    if (type.equals("study")) {
		for (int i = 1; i <= col; i++) {
		    String val = rs.getString(i).trim();
		    String header = rsm.getColumnLabel(i);
		    result += ("<tr><td>" + html.format (header, "ps_view_header", i) + "</td>");
		    
		    switch (i) {
		    case 1:  // name field broken into first and last name
			result += nameHelp (html, val, i);
			break;
		    case 2:  // updatable field with normal formatting
			result += ("<td><INPUT TYPE=text VALUE='" + html.format (val, "ps_view", i) + "' NAME=" + header + "></td></tr>\n"); 
			break;
		    case 3:  // DOB divided into MM DD YYYY fields
			result += dateHelp (html, val, i);
			break;
		    case 5:  // updatable field with normal formatting
			result += ("<td><INPUT TYPE=text VALUE='" + html.format (val, "ps_view", i) + "' NAME=" + header + "></td></tr>\n"); 
			break;
		    case 10: // study description field given extra length
			result += ("<td COLSPAN=2><INPUT TYPE=text VALUE='" + html.format (val,"ps_view",i) + "' NAME=" + header + " SIZE=50></td></tr>\n");
			break;
		    case 11: // name field broken into first and last name
			result += nameHelp (html, val, i);
			break;
		    default: // all other fields are not updatable
			result += ("<td>" + html.format (val, "ps_view", i) + "</td></tr>\n");
			break;
		    }
		}
		
	    }

	    else if (type.equals("series")) {
		
		for (int i = 1; i <= col; i++) {
		    String val = rs.getString(i).trim();
		    String header = rsm.getColumnLabel(i);
		    result += ("<tr><td>" + html.format (header, "series_header", i) + "</td>");

		    switch (i) {
		    case 4:  // updatable field (needs to be extra long)
			result += ("<td COLSPAN=2><INPUT TYPE=text VALUE='" + html.format (val,"series",i) + "' NAME=" + header + " SIZE=50></td></tr>\n");
			break;
		    default: // all other fields are not updatable
			result += ("<td>" + html.format (val, "series", i) + "</td></tr>\n");
			break;			
		    }
		}
	    }

	}
	catch (SQLException se) { 
	    result += ("</TABLE> " + se.getMessage()); 
	}finally {
	    try { if (st != null) st.close(); }
	    catch (SQLException ignored) { }
	}
	return result;
    }

    private String nameHelp (HtmlHelper html, String val, int i) {
	String name = html.format (val, "ps_view", i);
	int div = name.indexOf (","); 
	if (div == -1) div = name.indexOf(" ");  // no comma, see if there's a space
	if (div == -1) div = name.length();  // still no luck, so set division after last character
	String lastName = name.substring (0, div).trim();
	String firstName = name.substring (div, name.length());
	if (firstName.startsWith (",")) firstName = firstName.substring (1, firstName.length());
	firstName = firstName.trim();
	if (i < 5) {  // probably patient name is where i=1, but don't want to be to restrictive in case it changes
	    return ("<td>Last:<INPUT TYPE=text VALUE='" + lastName + "' NAME=lastNamePat></td>" +
		    "<td>First:<INPUT TYPE=text VALUE='" + firstName + "' NAME=firstNamePat></td></tr>\n"); 	
	}else {  // physician name is most likely i=11
	    return ("<td>Last:<INPUT TYPE=text VALUE='" + lastName + "' NAME=lastNamePhy></td>" +
		    "<td>First:<INPUT TYPE=text VALUE='" + firstName + "' NAME=firstNamePhy></td></tr>\n"); 	
	}
    }

    private String dateHelp (HtmlHelper html, String val, int i) {
	String dob = html.format (val, "ps_view", i);
	// dob must be either MM-DD-YYYY format, MM-YYYY, or unknown format. If unknown, leave fields blank
	String mon, day, year;
	try {
	    mon = dob.substring (0, 2);
	    if ((new Integer (Integer.parseInt (mon))).intValue() > 12 || dob.length() < 11) {  // date is in unknown format
		mon = ""; day = ""; year = "";
	    }else {
		day = dob.substring (4, 6);
		year = dob.substring (7, dob.length());
	    }
	}catch (IndexOutOfBoundsException ioobe) { mon = ""; day = ""; year = ""; }

	return ("<td>Month: <INPUT TYPE=text VALUE='" + mon  + "' NAME=mon MAXLENGTH=2 SIZE=2></td>" +
		"<td>Day:   <INPUT TYPE=text VALUE='" + day  + "' NAME=day MAXLENGTH=2 SIZE=2></td>" +
		"<td>Year:  <INPUT TYPE=text VALUE='" + year + "' NAME=year MAXLENGTH=4 SIZE=4></td>\n"); 
    }



    // helper for deleteHelper 
    private SQLStatement help (String fromTable, String uniqueID, String queryType, String loopType, String[] checked, ResultSet rs) throws SQLException { 
	boolean first = true;
	SQLStatement q = new SQLStatement ();    
	if (queryType.equals("select")) q.addToSelect ("*");
	else if (queryType.equals("delete")) q.addToDelete ();
	q.addToFrom (fromTable);
	if (loopType.equals("for")) {
	    for (int i=0; i < checked.length; i++) {
		if (i==0) q.addToWhere (uniqueID, checked[i], SQLStatement.IN);
		else q.addToWhere (null, checked[i], SQLStatement.IN);
	    }
	}else if (loopType.equals("while")) {  // using results from a previous query 
	    while (rs.next()) {           
		if (first) { 
		    q.addToWhere (uniqueID, rs.getString(uniqueID).trim(), SQLStatement.IN); 
		    first = false; 
		}else q.addToWhere (null, rs.getString(uniqueID).trim(), SQLStatement.IN);
	    }
	}
	return q;
    }
    private String formatExportStudyOrder(String rcvr, String studyUID, HttpServletRequest req) {
      String s = "'XMIT_STUDY', ";
      String aeTitle;
      int ix = rcvr.indexOf(' ');
      if (ix > 0) {
	aeTitle = rcvr.substring(0, ix);
      } else {
	aeTitle = rcvr;
      }

      s += "'destAE=" + aeTitle;
      s += "&studyUID=" + studyUID + "'";

      String remoteUser = req.getRemoteUser();
      if (remoteUser == null) {
	remoteUser = "none";
      }

      s += ", '" + remoteUser + "'";

      java.util.Date theDate = new java.util.Date();

      SimpleDateFormat df = new SimpleDateFormat();
      df.applyLocalizedPattern("yyyyMMdd");
      String stringDate = df.format(theDate);

      s += ", " + stringDate;

      df.applyLocalizedPattern("kkmmss.SSS");
      String stringTime = df.format(theDate);

      s += ", " + stringTime;
      s += ", 0";

      s += ")";
      return s;
    }

}
