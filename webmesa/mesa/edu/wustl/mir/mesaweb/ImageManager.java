package edu.wustl.mir.mesaweb;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import edu.wustl.mir.mesaweb.HtmlHelper;

public class ImageManager extends HttpServlet {
    
    Connection db = null;      // db is shared by all threads that request this servlet
    HtmlHelper html = null;    // helps with html tables, formatting, and general prettiness
    IMStudyPage mIMStudyPage = null;
    IMSeriesPage mIMSeriesPage = null;
    
    public void doGet (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	
	res.setContentType ("text/html");
	PrintWriter out = res.getWriter();
	
	int ix = 0;
	ix = initDriver (out);   // init methods are found below
	if (ix == 1)
	  return;
	ix = initConnection (out, "imgmgr_study");
	if (ix == 1)
	  return;
	
	Enumeration enum = req.getParameterNames ();
	String action = req.getParameter("action");
	// action is a hidden form param on each page which tells the servlet what method is executed next  

	String[] argNames = null;                           
	String[] args = null;
	
	// The methods called in each clause of the if statement appear below in the same order
	String x1 = "null";
	if (action != null) {
	  x1 = action;
	}
	System.out.println("Action = " + x1);
	
	if (action == null || action.equals ("")) {  // prints the initial query page
	    printStartPage (out);
	}
	else if (action.equals("doStudyQuery")) {    // executes the query and prints results + options available
	    // 6 query categories
	    argNames = new String[7];
	    args = new String[7];
	    parseArgs (enum, req, argNames, args);
	    String[] modsChecked = req.getParameterValues ("modinstu");
	    //doStudyQuery (out, null, argNames, args, modsChecked, null, null);
	    mIMStudyPage.doStudyQuery(out, html, null, argNames, args, modsChecked, null, null);
	}
	else if (action.equals("sortStudy")) {       // re-sorts the table by a chosen column
	    String s = req.getParameter ("savedQuery");
	    SQLStatement savedQuery = new SQLStatement (s);
	    String sortBy = req.getParameter ("sort"); 
	    mIMStudyPage.doStudyQuery (out, html, savedQuery, null, null, null, sortBy, null);
	    //doStudyQuery (out, savedQuery, null, null, null, sortBy, null);
	}
	else if (action.equals("studyOptions")) {    // handles the option request at the study level
	    String s = req.getParameter ("savedQuery");
	    SQLStatement savedQuery = new SQLStatement (s);
	    String[] studiesChecked = req.getParameterValues ("ps_view");
	    String option = req.getParameter ("option");
	    if (option.equals("view") &&
		studiesChecked != null &&
		studiesChecked.length == 1) {
	      SQLStatement seriesQuery = new SQLStatement();
	      seriesQuery.addToSelect("sernum, mod, numins, serdes, serinsuid, stuinsuid");
	      seriesQuery.addToFrom ("series");
	      seriesQuery.addToWhere ("stuinsuid", studiesChecked[0].trim(), SQLStatement.NORMAL);
	      mIMSeriesPage.doSeriesQuery (out, db, html, seriesQuery, "sernum", null);
	    } else {
	      mIMStudyPage.studyOptions (out, db, html, savedQuery,
		studiesChecked, option);
	    }
	}
	else if (action.equals("exportStudy")) {       // re-sorts the table by a chosen column
	    mIMStudyPage.exportStudies(out, db, html, req);
	    printStartPage (out);
	    //String s = req.getParameter ("savedQuery");
	    //SQLStatement savedQuery = new SQLStatement (s);
	    //mIMStudyPage.doStudyQuery (out, html, savedQuery, null, null, null, null, null);
	}
	else if (action.equals("updateStudy")) {     // executes the update
	    String s = req.getParameter ("savedQuery");
	    SQLStatement savedQuery = new SQLStatement (s);
	    String u = req.getParameter ("updateQuery");
	    SQLStatement updateQuery = new SQLStatement (u);
	    argNames = new String[10];
	    args = new String[10];
	    parseArgs (enum, req, argNames, args);
	    updateStudy (out, savedQuery, updateQuery, argNames, args);
	}
	else if (action.equals("sortSeries")) {      // re-sorts the table by a chosen column
	    String s = req.getParameter ("savedQuery");
	    SQLStatement savedQuery = new SQLStatement (s);
	    String sortBy = req.getParameter ("sort"); 
	    mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, sortBy, null);
	}
	else if (action.equals("seriesOptions")) {   // handles the option request at the series level
	    String s = req.getParameter ("savedQuery");
	    SQLStatement savedQuery = new SQLStatement (s);
	    String[] seriesChecked = req.getParameterValues ("series");
	    String option = req.getParameter ("option");
	    mIMSeriesPage.seriesOptions (out, db, html, savedQuery, seriesChecked, option);
	}
	else if (action.equals("exportSeries")) {       // Export selected series
	    mIMSeriesPage.exportSeries(out, db, html, req);
	    printStartPage (out);
	}
	else if (action.equals("updateSeries")) {    // executes the update
	    String s = req.getParameter ("savedQuery");
	    SQLStatement savedQuery = new SQLStatement (s);
	    String u = req.getParameter ("updateQuery");
	    SQLStatement updateQuery = new SQLStatement (u);
	    argNames = new String[1];
	    args = new String [1];
	    parseArgs (enum, req, argNames, args);
	    updateSeries (out, savedQuery, updateQuery, argNames, args);
	} 
	else if (action.equals("imageOptions")) {    // handles the option request at the image level
	    String s = req.getParameter ("savedQuery");
	    SQLStatement savedQuery = new SQLStatement (s);
	    String[] imagesChecked = req.getParameterValues ("sopins");
	    String option = req.getParameter ("option");
	    imageOptions (out, savedQuery, imagesChecked, option);
	}
	else if (action.equals("quit")) {            // closes database connection
	    destroy();
	    out.println ("<PRE>Connection to the database has been closed.</PRE>");
	}

    }


    
    
    // **** The following are action methods: there is one method (representing a page) for each branch of the conditional above ****
    


    
    private void printStartPage (PrintWriter out) {
	int studyCount = 0;
	Statement st = null;
	try {
	    st = db.createStatement ();
	    if (st.execute ("SELECT * FROM ps_view")) { 
		ResultSet rs = st.getResultSet ();
		while (rs.next()) studyCount++;
	    }
	}
	catch (SQLException se) { out.println (se.getMessage()); }
	finally {
	    try { if (st != null) st.close(); }
	    catch (SQLException ignored) { }
	}
	
	out.println (html.printHeader ("Initial Query Page"));		
	out.println ("<P>There are <B>" + studyCount + "</B> studies in the archive you have selected.<br><br>");
	out.println ("If you would like to narrow down your search, please fill in any information you know in the boxes below.<br>");
	
	//out.println ("<FORM ACTION='http://pongo:8080/servlet/ImageManager'>");
	out.println ("<FORM ACTION='/servlet/ImageManager'>");
	out.println ("<INPUT TYPE=hidden NAME=action VALUE=doStudyQuery>"); // this is where action param is set 
	out.println ("<TABLE>");                                   
	out.println ("<tr><td>Patient's Last Name: </td><td><INPUT TYPE=text NAME=nam>      </td></tr>");
	out.println ("<tr><td>Patient ID:          </td><td><INPUT TYPE=text NAME=patid>    </td></tr>");
	out.println ("<tr><td>Study Date:          </td><td>Month:<INPUT TYPE=text NAME=mon  SIZE=2 MAXLENGTH=2>&nbsp;&nbsp;" + 
		                                           "Day:  <INPUT TYPE=text NAME=day  SIZE=2 MAXLENGTH=2>&nbsp;&nbsp;" + 
		                                           "Year: <INPUT TYPE=text NAME=year SIZE=4 MAXLENGTH=4></td></tr>");
	out.println ("<tr><td>Accession Number:    </td><td><INPUT TYPE=text NAME=accnum>   </td></tr>");
	out.println ("<tr><td>Study ID:            </td><td><INPUT TYPE=text NAME=stuid>    </td></tr>");
	out.println ("<tr><td ROWSPAN=4 VALIGN=top>Modalities in Study: </td><td><INPUT TYPE=checkbox NAME=modinstu VALUE=MR>MR </td></tr>");
	out.println ("<tr>                                                   <td><INPUT TYPE=checkbox NAME=modinstu VALUE=CT>CT </td></tr>");
	out.println ("<tr>                                                   <td><INPUT TYPE=checkbox NAME=modinstu VALUE=OT>OT </td></tr>");
	out.println ("<tr>                                                   <td><INPUT TYPE=checkbox NAME=modinstu VALUE=US>US </td></tr>");
	out.println ("</TABLE><br>");
	out.println ("<INPUT TYPE=submit VALUE=Submit><br><br>");
	out.println ("</FORM>");
	
	out.println ("<P>If you would like to view all <B>" + studyCount +  "</B> studies, simply leave the boxes blank and click submit.");	
	out.println ("</BODY></HTML>");
    }
    
 


    private void updateStudy (PrintWriter out, SQLStatement savedQuery, SQLStatement updateQuery, String[] argNames, String[] args) {
	Statement st = null;
	try {
	    db.setAutoCommit (false);  // allows several updates to be performed, then commited only once they are all completed successfully
	    st = db.createStatement();
	    
	    int index = updateQuery.where.indexOf ("stuinsuid");
	    String stuinsuid = updateQuery.where.substring (index + 11, updateQuery.where.indexOf(' ', index) - 1); 
	    
	    // Names (patient and physician) need to be reconstructed into strings with carats. Month day and year need to be combined into a date string
	    String lastNamePat = ""; String firstNamePat = "";
	    String lastNamePhy = ""; String firstNamePhy = "";
	    String mon = ""; String day = ""; String year = "";
	    
	    SQLStatement update = new SQLStatement ();
	    update.addToUpdate ("ps_view");
	    update.addToWhere ("stuinsuid", stuinsuid, SQLStatement.NORMAL);
	    
	    // Finds args that need to be reconstructed. Executes update for args that do not.
	    for (int i = 0; i < argNames.length; i++) {
		if (argNames[i].equals("lastNamePat")) lastNamePat = args[i].trim();
		else if (argNames[i].equals("firstNamePat")) firstNamePat = args[i].trim();
		else if (argNames[i].equals("lastNamePhy")) lastNamePhy = args[i].trim();
		else if (argNames[i].equals("firstNamePhy")) firstNamePhy = args[i].trim();
		else if (argNames[i].equals("mon")) mon = args[i].trim();
		else if (argNames[i].equals("day")) day = args[i].trim();
		else if (argNames[i].equals("year")) year = args[i].trim();
		else {
		    update.addToSet (null);  //clear out any previous SET clause
		    update.addToSet (argNames[i].trim() + "='" + args[i].trim() + "'");
		    st.executeUpdate (update.toString());
		}
	    }
	
	    String nam = (lastNamePat + "^" + firstNamePat.replace(' ', '^'));
	    update.addToSet (null); update.addToSet ("nam='" + nam.trim() + "'");
	    st.executeUpdate (update.toString());
	    String refphynam = (lastNamePhy + "^" + firstNamePhy.replace(' ', '^'));
	    update.addToSet (null); update.addToSet ("refphynam='" + refphynam.trim() + "'");
	    st.executeUpdate (update.toString());
	    String datbir = (year + mon + day);  // need more checks here to ensure valid format *********
	    update.addToSet (null); update.addToSet ("datbir='" + datbir.trim() + "'");
	    st.executeUpdate (update.toString());

	    db.commit();  // if we've gotten this far without an exception, then everything should be ok
	    mIMStudyPage.doStudyQuery (out, html, savedQuery, null, null, null, null, null);  // updates will show up in the table now
	}catch (Exception e) {
	    try { db.rollback(); }
	    catch (SQLException ignored) { }
	    mIMStudyPage.doStudyQuery (out, html, savedQuery, null, null, null, null, ("Update failed! " + e));
	}finally {
	    try { if (st != null) st.close(); }
	    catch (SQLException ignored) { }
	}
    }
    
    

/*
    private void doSeriesQuery (PrintWriter out, SQLStatement quer, String sortBy, String err) { 
	String tableName = "series";
	String primaryCol = "serinsuid";

	String query;
	if (sortBy != null) {
	    quer.addToOrderBy (null);
	    quer.addToOrderBy (sortBy.trim());
	}
	query = quer.toString();

	out.println (html.printHeader ("Series Level Information"));
	if (err != null) out.println ("<H1><FONT COLOR=#800080><B>ERROR:</B> " + err + "</FONT></H1>"); 

       	//out.println ("<FORM ACTION='http://pongo:8080/servlet/ImageManager'>");
       	out.println ("<FORM ACTION='/servlet/ImageManager'>");
	out.println ("<INPUT TYPE=hidden NAME=action VALUE=sortSeries>");
	out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + query + "\">");
	out.println (html.printSortOptions ("series", query));
	out.println ("<INPUT TYPE=submit VALUE='Sort Table'><br><br>\n");
	out.println ("</FORM>\n");

       	//out.println ("<FORM ACTION='http://pongo:8080/servlet/ImageManager'>");
       	out.println ("<FORM ACTION='/servlet/ImageManager'>");
	out.println ("<INPUT TYPE=hidden NAME=action VALUE=seriesOptions>");
	out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + query + "\">");
	out.println (html.printTable (query, tableName, primaryCol, true));
	out.println (html.printRadioOptions ("series"));
	out.println ("</FORM>");
	out.println ("</BODY></HTML>");
    }
*/



    private void seriesOptions (PrintWriter out, SQLStatement savedQuery, String[] seriesChecked, String option) {
	// seriesChecked array contains series id
	if (option.equals ("delete")) {
	    if (seriesChecked == null || seriesChecked.length == 0) {
		mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, "Please select at least one series to delete.");
	    }else {
		deleteHelper (out, savedQuery, seriesChecked, "series"); // the helper method (below) constructs and executes the necessary SQL statements 
	    }
	}
	

	else if (option.equals ("export")) {
	    if (seriesChecked == null || seriesChecked.length == 0) {
		mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, "Please select at least one series to export.");
	    }else {
		SQLStatement query = new SQLStatement (savedQuery);
		boolean first = true;
		for (int i = 0; i < seriesChecked.length; i++) {
		    if (first) { query.addToWhere ("serinsuid", seriesChecked[i], SQLStatement.IN); first = false; }
		    else query.addToWhere (null, seriesChecked[i], SQLStatement.IN);
		}

		out.println (html.printHeader ("Export Series"));
		//out.println ("<FORM ACTION='http://pongo:8080/servlet/ImageManager'>");   // should this go to queue servlet instead?
		out.println ("<FORM ACTION='/servlet/ImageManager'>");   // should this go to queue servlet instead?
		out.println ("<INPUT TYPE=hidden NAME=action VALUE=exportSeries'>");
		out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + savedQuery + "\">");
		out.println ("<P> You have chosen to export the following series:");

		out.println (html.printTable (query.toString(), "series", "serinsuid", false));

		out.println ("<P><br> If you would like to export these series to a DICOM receiver, please select one below.<br>");
		out.println ("<SELECT NAME=receivers SIZE=5>");
		out.println ("<OPTION>This will");  out.println ("<OPTION>later include"); out.println ("<OPTION>a selection");
		out.println ("<OPTION>of DICOM");   out.println ("<OPTION>recievers");     out.println ("<OPTION>for the user");
		out.println ("<OPTION>to select."); out.println ("</SELECT><br><br><br>");

		out.println ("<P><H3> OR... </H3>");

		out.println ("<P><br> If you would like to save the series to a local file, please select a format and enter "); 
		out.println ("a filename in the box below.<br>");
		out.println ("<INPUT TYPE=radio NAME=dicom>DICOM<br>");
		out.println ("<INPUT TYPE=radio NAME=jpeg1>JPEG (Lossless)<br>");
		out.println ("<INPUT TYPE=radio NAME=jpeg2>JPEG (Lossy)<br>");
		out.println ("<INPUT TYPE=radio NAME=tif>TIF<br>");
		out.println ("<INPUT TYPE=radio NAME=raw>RAW<br>");
		out.println ("Filename: <INPUT TYPE=text NAME=filnam><br><br>");

		out.println ("<INPUT TYPE=submit VALUE='Export Series'>");
		out.println ("</FORM>\n");
		out.println ("</BODY></HTML>");
	    }

	    //do export stuff 
	    //then kick back to series view
	    //doSeriesQuery (out, savedQuery, null, "Export is not implemented at this time.");
	}

	
	else if (option.equals ("update")) {
	    if (seriesChecked == null || seriesChecked.length == 0) {
		mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, "Please select a series to update.");
	    }else if (seriesChecked.length > 1) {
		mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, "Please select only one series to update.");
	    }else {
		SQLStatement updateQuery = new SQLStatement (savedQuery);
		updateQuery.addToWhere ("serinsuid", seriesChecked[0], SQLStatement.NORMAL);	    
		
		out.println (html.printHeader ("Update Series Level Information"));
		//out.println ("<FORM ACTION='http://pongo:8080/servlet/ImageManager'>");
		out.println ("<FORM ACTION='/servlet/ImageManager'>");
		out.println ("<INPUT TYPE=hidden NAME=action VALUE=updateSeries>");
		out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + savedQuery + "\">");
		out.println ("<INPUT TYPE=hidden NAME=updateQuery VALUE=\"" + updateQuery + "\">");
		out.println ("<P>You have chosen to update the information contained in this series. When ");
		out.println ("you are finished making changes, please click the update button. <br>");
		out.println ("<TABLE>");
		
		String result = formatUpdateTable (updateQuery, "series");  // this long and ugly format helper is found below
		out.println (result);
		
		out.println ("</TABLE><br>");
		out.println ("<INPUT TYPE=submit VALUE=Update><br><br>");
		out.println ("</FORM>");
		out.println ("</BODY></HTML>");
	    }
	}

	
	else if (option.equals ("view")) {
	    if (seriesChecked == null || seriesChecked.length == 0) {
		mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, "Please select a series to view.");
	    }else if (seriesChecked.length > 1) {
		mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, "Please select only one series to view.");
	    }else {
		SQLStatement imageQuery = new SQLStatement ();
		imageQuery.addToSelect ("imanum, row, col, bitall, insuid, serinsuid");
		imageQuery.addToFrom ("sopins");
		imageQuery.addToWhere ("serinsuid", seriesChecked[0].trim(), SQLStatement.NORMAL);
		imageQuery.addToOrderBy ("imanum");
		doImageQuery (out, imageQuery, null);
	    }
	}

    }




    private void updateSeries (PrintWriter out, SQLStatement savedQuery, SQLStatement updateQuery, String[] argNames, String[] args) {
	Statement st = null;
	try {
	    // don't need autocommit off since only one update is performed
	    st = db.createStatement();
	    
	    int index = updateQuery.where.indexOf ("serinsuid");
	    String serinsuid = updateQuery.where.substring (index + 11, updateQuery.where.indexOf(' ', index) - 1); 
	    
	    SQLStatement update = new SQLStatement ();
	    update.addToUpdate ("series");
	    update.addToWhere ("serinsuid", serinsuid, SQLStatement.NORMAL);
	    update.addToSet (argNames[0].trim() + "='" + args[0].trim() + "'"); // only one field can be updated (description field)
	    st.executeUpdate (update.toString());

	    mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, null);  // updates will show up in the table now
	}catch (Exception e) {
	    mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, ("Update failed! " + e));
	}finally {
	    try { if (st != null) st.close(); }
	    catch (SQLException ignored) { }
	}
    }




    private void doImageQuery (PrintWriter out, SQLStatement query, String err) { 
	String tableName = "sopins";
	String primaryCol = "insuid";

	out.println (html.printHeader ("Image Level Information"));
	if (err != null) out.println ("<H1><FONT COLOR=#800080><B>ERROR:</B> " + err + "</FONT></H1>");
       	//out.println ("<FORM ACTION='http://pongo:8080/servlet/ImageManager'>");
       	out.println ("<FORM ACTION='/servlet/ImageManager'>");
	out.println ("<INPUT TYPE=hidden NAME=action VALUE=imageOptions>");
	out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + query + "\">");
	out.println (html.printTable (query.toString(), tableName, primaryCol, true));
	out.println (html.printRadioOptions ("image"));
	out.println ("</FORM>");
	out.println ("</BODY></HTML>");
    }




    private void imageOptions (PrintWriter out, SQLStatement savedQuery, String[] imagesChecked, String option) {
	// imagesChecked array contains image id
	if (option.equals ("delete")) {
	    if (imagesChecked == null || imagesChecked.length == 0) {
		doImageQuery (out, savedQuery, "Please select at least one image to delete.");
	    }else {
		deleteHelper (out, savedQuery, imagesChecked, "image");
	    }
	}
	
	else if (option.equals ("export")) {
	    if (imagesChecked == null || imagesChecked.length == 0) {
		doImageQuery (out, savedQuery, "Please select at least one image to export.");
	    }else {
		SQLStatement query = new SQLStatement (savedQuery);
		boolean first = true;
		for (int i = 0; i < imagesChecked.length; i++) {
		    if (first) { query.addToWhere ("insuid", imagesChecked[i], SQLStatement.IN); first = false; }
		    else query.addToWhere (null, imagesChecked[i], SQLStatement.IN);
		}

		out.println (html.printHeader ("Export Images"));
		//out.println ("<FORM ACTION='http://pongo:8080/servlet/ImageManager'>");   // should this go to queue servlet instead?
		out.println ("<FORM ACTION='/servlet/ImageManager'>");   // should this go to queue servlet instead?
		out.println ("<INPUT TYPE=hidden NAME=action VALUE=exportImages'>");
		out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + savedQuery + "\">");
		out.println ("<P> You have chosen to export the following images:");

		out.println (html.printTable (query.toString(), "sopins", "insuid", false));

		out.println ("<P><br> If you would like to export these images to a DICOM receiver, please select one below.<br>");
		out.println ("<SELECT NAME=receivers SIZE=5>");
		out.println ("<OPTION>This will");  out.println ("<OPTION>later include"); out.println ("<OPTION>a selection");
		out.println ("<OPTION>of DICOM");   out.println ("<OPTION>recievers");     out.println ("<OPTION>for the user");
		out.println ("<OPTION>to select."); out.println ("</SELECT><br><br><br>");

		out.println ("<P><H3> OR... </H3>");

		out.println ("<P><br> If you would like to save the images to a local file, please select a format and enter "); 
		out.println ("a filename in the box below.<br>");
		out.println ("<INPUT TYPE=radio NAME=dicom>DICOM<br>");
		out.println ("<INPUT TYPE=radio NAME=jpeg1>JPEG (Lossless)<br>");
		out.println ("<INPUT TYPE=radio NAME=jpeg2>JPEG (Lossy)<br>");
		out.println ("<INPUT TYPE=radio NAME=tif>TIF<br>");
		out.println ("<INPUT TYPE=radio NAME=raw>RAW<br>");
		out.println ("Filename: <INPUT TYPE=text NAME=filnam><br><br>");

		out.println ("<INPUT TYPE=submit VALUE='Export Images'>");
		out.println ("</FORM>\n");
		out.println ("</BODY></HTML>");
	    }


	    //do export stuff 
	    //then kick back to image view
	    //doImageQuery (out, savedQuery, "Export is not implemented at this time.");
	}
    }




    /*
     *
     *
     *
     *
     *
     *
     *
     *
     *
     *
     * 
     * Assorted initialization and helper methods are found below.
     */
    

    

    private int initDriver (PrintWriter out) {
	//loads the postgres driver
	try { Class.forName ("org.postgresql.Driver"); }
	catch (ClassNotFoundException ignored) {
	  out.println ("<PRE>ERROR: Could not locate Postgresql driver </PRE>");
	  return 1;
	}
	return 0;
    }



    private int initConnection (PrintWriter out, String dbName) {
	if (db == null) {
	    try {
		db = DriverManager.getConnection ("jdbc:postgresql:" + dbName + "?user=postgres&password=7066ms##");
	    }catch (SQLException se) {
		out.println ("<PRE>ERROR: Could not connect to database." + se.getMessage() + "</PRE>");
		return 1;
	    }
	}
	if (html == null) {
	  html = new HtmlHelper (db);
	}
	if (mIMStudyPage == null) {
	  mIMStudyPage = new IMStudyPage();
	}
	if (mIMSeriesPage == null) {
	  mIMSeriesPage = new IMSeriesPage();
	}
	return 0;
    } 
    


    public void doPost (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	doGet (req, res);
    }



    public void destroy () {
	try { if (db != null) db.close(); }
	catch (SQLException ignored) { }
    }



    // The following method copies the Enumeration returned by getParameterNames() and places the information it contains into two arrays.    
    private void parseArgs (Enumeration enum, HttpServletRequest req, String[] argNames, String[] args) {
	enum.nextElement();   // assume there is an action var and step past it
	for (int i = 0; i < args.length && enum.hasMoreElements(); i++) {
	    argNames[i] = (enum.nextElement().toString()).trim();
	    args[i] = req.getParameter(argNames[i]).trim();
	    if (argNames[i].equals("savedQuery") || argNames[i].equals("modinstu") || 
		argNames[i].equals("updateQuery") || argNames[i].equals("sort")) i--; //don't include these 
	}
    }



    // Most of the ugliness of the following method was separated out into name and date helper methods (found further below).
    private String formatUpdateTable (SQLStatement updateQuery, String type) {
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
			result += nameHelp (val, i);
			break;
		    case 2:  // updatable field with normal formatting
			result += ("<td><INPUT TYPE=text VALUE='" + html.format (val, "ps_view", i) + "' NAME=" + header + "></td></tr>\n"); 
			break;
		    case 3:  // DOB divided into MM DD YYYY fields
			result += dateHelp (val, i);
			break;
		    case 5:  // updatable field with normal formatting
			result += ("<td><INPUT TYPE=text VALUE='" + html.format (val, "ps_view", i) + "' NAME=" + header + "></td></tr>\n"); 
			break;
		    case 10: // study description field given extra length
			result += ("<td COLSPAN=2><INPUT TYPE=text VALUE='" + html.format (val,"ps_view",i) + "' NAME=" + header + " SIZE=50></td></tr>\n");
			break;
		    case 11: // name field broken into first and last name
			result += nameHelp (val, i);
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



    private String nameHelp (String val, int i) {
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



    private String dateHelp (String val, int i) {
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



    private String studyQuerySQLHelp (String[] args, String[] argNames, SQLStatement quer, String[] modsChecked, String sortBy) {
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



    private void deleteHelper (PrintWriter out, SQLStatement savedQuery, String[] checked, String type) { 
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
		// first, need to update number of series and images contained in the parent study
		// for each series checked, get number of images. go to parent study, decrement series count by 1. decrement image count

		SQLStatement s = help("series", "serinsuid", "select", "for", checked, null); // returns all series marked for deletion
		st.execute (s.toString()); 
		rs = st.getResultSet();                              

		rs.next();
		String stuinsuid = ("'" + rs.getString ("stuinsuid").trim() + "'"); // UID of the parent study
		rs.beforeFirst();                                                   // move ptr back to the beginning so that the while loop will work

		Statement st2 = db.createStatement();

		while (rs.next()) {
		    isEmpty ("ps_view", "stuinsuid", stuinsuid, "numser");       // if the parent study is empty of series, delete parent
		    st2.execute ("UPDATE ps_view SET numser=numser-1 WHERE stuinsuid=" + stuinsuid);
		    st2.execute ("UPDATE ps_view SET numins=numins-" + rs.getString("numins").trim() + "WHERE stuinsuid=" + stuinsuid);
		}
		st2.close();                                                                    // clean up		

		SQLStatement selectImages = help("sopins", "serinsuid", "select", "for", checked, null); // returns all images in each series marked 
		st.execute (selectImages.toString());
		rs = st.getResultSet();
 
		SQLStatement deleteImages = help("sopins", "insuid", "delete", "while", checked, rs);    // deletes each image in each series selected above
		st.execute (deleteImages.toString());                          

		selectImages.addToSelect (null);                                   // clear out the SELECT clause, change to DELETE
		selectImages.addToDelete ();           
		selectImages.addToFrom (null);                                     // clear out FROM (previously "sopins"), change to "series". 
		selectImages.addToFrom ("series");                                 // Keep the same WHERE clause.
		st.execute (selectImages.toString());                            // deleting empty series
	    }

	    
	    else if (type.equals("image")) {
		// there is only one parent series and one parent study for any set of checked images. need those UID's
		// every time an image is deleted, need to check if either parent series is empty and delete it. if it is, also check for parent to be empty
		SQLStatement s = help("sopins", "insuid", "select", "for", checked, null);      // returns all images marked for deletion
		st.execute (s.toString()); 
		rs = st.getResultSet();                              

		rs.next();
		String serinsuid = ("'" + rs.getString ("serinsuid").trim() + "'"); // UID of the parent series
		rs.beforeFirst();                                                   // move ptr back to the beginning so that the while loop will work

		Statement st2 = db.createStatement();
		st2.execute ("SELECT * FROM series WHERE serinsuid=" + serinsuid);
		ResultSet rs2 = st2.getResultSet ();
		rs2.next();
		String stuinsuid = ("'" + rs2.getString("stuinsuid").trim() + "'"); // UID of the parent study

		while (rs.next()) { 
		    boolean empty = isEmpty ("series", "serinsuid", serinsuid, "numins");                  // if the parent series is empty of img, del parent
		    if (empty) {                                                                           // if the parent series was deleted
			st2.execute ("UPDATE ps_view SET numser=numser-1 WHERE stuinsuid=" + stuinsuid);   // decrement study's "numser"
			st2.execute ("UPDATE ps_view SET numins=numins-1 WHERE stuinsuid=" + stuinsuid);   // decrement study's "numins"
			isEmpty ("ps_view", "stuinsuid", stuinsuid, "numser");                             // if the parent study is empty of ser, del parent
		    }else if (!empty) {                                                                    // no parent was deleted, so continue
			st2.execute ("UPDATE ps_view SET numins=numins-1 WHERE stuinsuid=" + stuinsuid);   // decrement study's "numins"
			st2.execute ("UPDATE series SET numins=numins-1 WHERE serinsuid=" + serinsuid);    // decrement series' "numins"
		    }
		}

		st2.close();            

		SQLStatement deleteImages = help("sopins", "insuid", "delete", "for", checked, null);      // deletes each image marked
		st.execute (deleteImages.toString());
	    }

	    db.commit();

	    if (type.equals("study")) mIMStudyPage.doStudyQuery (out, html, savedQuery, null, null, null, null, null);
	    else if (type.equals("series")) mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, null);
	    else if (type.equals("image")) doImageQuery (out, savedQuery, null);
	    
	}catch (Exception e) {
	    if (type.equals("study")) {
	      mIMStudyPage.doStudyQuery (out, html, savedQuery, null, null, null, null, ("Delete failed! " + e));
	    } else if (type.equals("series")) {
	      mIMSeriesPage.doSeriesQuery (out, db, html, savedQuery, null, ("Delete failed! " + e));
	    } else if (type.equals("image")) {
	      doImageQuery (out, savedQuery, ("Delete failed! " + e));
	    }

	    try { db.rollback(); }
	    catch (SQLException ignored) { }
	    finally { out.println ("<PRE>" + e + "</PRE>"); }
	}finally {
	    try { if (st != null) st.close(); }
	    catch (SQLException ignored) { }
	}
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
  


    //another helper for deleteHelper
    private boolean isEmpty (String table, String uidType, String uid, String emptyOf) throws SQLException { 
	// the uidType/uid pair should be able to select a particular study (series, etc) from the table given 
	// for instance: table = ps_view, uidType = stuinsuid, uid = 1.2.8.1004.23761
	// emptyOf should be "numser" to check if empty of series, or "numins" to check if empty of images
	Statement st = db.createStatement();
	st.execute ("SELECT * FROM " + table + " WHERE " + uidType + "=" + uid);
	ResultSet rs = st.getResultSet(); rs.next();     

	int num =  (new Integer (Integer.parseInt (rs.getString(emptyOf)))).intValue();   
	if (num <= 1) { 
	    st.execute ("DELETE FROM " + table + " WHERE " + uidType + "=" + uid);  // delete the parent 
	    return true;
	}else return false;
    }
    
}
