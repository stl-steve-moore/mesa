package edu.wustl.mir.mesaweb;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import java.text.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class IMSeriesPage extends HttpServlet {
 

  public void doSeriesQuery (PrintWriter out, Connection db, HtmlHelper html,
	SQLStatement quer, String sortBy, String err) {

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

    out.println ("<FORM ACTION='/servlet/ImageManager'>");
    out.println ("<INPUT TYPE=hidden NAME=action VALUE=sortSeries>");
    out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + query + "\">");
    out.println (html.printSortOptions ("series", query));
    out.println ("<INPUT TYPE=submit VALUE='Sort Table'><br><br>\n");
    out.println ("</FORM>\n");

    out.println ("<FORM ACTION='/servlet/ImageManager'>");
    out.println ("<INPUT TYPE=hidden NAME=action VALUE=seriesOptions>");
    out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + query + "\">");
    out.println (html.printTable (query, tableName, primaryCol, true));
    out.println (html.printRadioOptions ("series"));
    out.println ("</FORM>");
    out.println ("</BODY></HTML>");
  }

  public void seriesOptions (PrintWriter out, Connection db, HtmlHelper html,
	SQLStatement savedQuery, String[] seriesChecked, String option) {

    // seriesChecked array contains series id
    if (option.equals ("delete")) {
      if (seriesChecked == null || seriesChecked.length == 0) {
	doSeriesQuery (out, db, html, savedQuery, null, "Please select at least one series to delete.");
      } else {
	deleteHelper (out, db, html, savedQuery, seriesChecked, "series");
	// the helper method (below) constructs and executes the necessary SQL statements 

      }
    } else if (option.equals ("export")) {
      if (seriesChecked == null || seriesChecked.length == 0) {
	doSeriesQuery (out, db, html, savedQuery, null, "Please select at least one series to export.");
      } else {
	SQLStatement query = new SQLStatement (savedQuery);
	boolean first = true;
	for (int i = 0; i < seriesChecked.length; i++) {
	  if (first) {
	    query.addToWhere ("serinsuid", seriesChecked[i], SQLStatement.IN); first = false;
	  } else {
	    query.addToWhere (null, seriesChecked[i], SQLStatement.IN);
	  }
	}

	out.println (html.printHeader ("Export Series"));
	out.println ("<FORM ACTION='/servlet/ImageManager'>");   // should this go to queue servlet instead?
	out.println ("<INPUT TYPE=hidden NAME=action VALUE=exportSeries>");
	out.println ("<INPUT TYPE=hidden NAME=savedQuery VALUE=\"" + savedQuery + "\">");
	int ix = 0;
	for (ix = 0; ix < seriesChecked.length; ix++) {
	  out.println ("<INPUT TYPE=hidden NAME=serinsuid VALUE=\"" + seriesChecked[ix] + "\">");
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

	out.println ("<P> You have chosen to export the following series:");

	out.println (html.printTable (query.toString(), "series", "serinsuid", false));

	out.println ("<P><br> If you would like to export these series to a DICOM receiver, please select one below.<br>");
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
	out.println ("</SELECT><br><br><br>");

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
    }
  }
    public void exportSeries (PrintWriter out, Connection db, HtmlHelper html, HttpServletRequest req) {
      String[] receivers = req.getParameterValues("receivers");
      if (receivers == null) {
	System.out.println("No receivers");
	return;
      }
      String[] series = req.getParameterValues("serinsuid");
      if (series == null) {
	System.out.println("No series");
	return;
      }
      int ix = 0;
      int iy = 0;
      String insertBase =
	"insert into work_orders (typ, params, ordbyin, datord, " +
	" timord, status) values(";
      for (ix = 0; ix < receivers.length; ix++) {
	for (iy = 0; iy < series.length; iy++) {
	  String rcvr = receivers[ix];
	  String seriesUID = series[iy];
	  String sql = insertBase + formatExportSeriesOrder(rcvr, seriesUID, req);

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

  private void deleteHelper (PrintWriter out, Connection db, HtmlHelper html,
	SQLStatement savedQuery, String[] checked, String type) {

    Statement st = null;
    ResultSet rs;
    try {
      db.setAutoCommit(false);
      st = db.createStatement();

      if (type.equals("study")) {
      }

      else if (type.equals("series")) {
	// first, need to update number of series and images contained in the parent study
	// for each series checked, get number of images.
	// go to parent study, decrement series count by 1. decrement image count

	SQLStatement s = help("series", "serinsuid", "select", "for", checked, null);
	// returns all series marked for deletion
	st.execute (s.toString()); 
	rs = st.getResultSet();                              

	rs.next();
	String stuinsuid = ("'" + rs.getString ("stuinsuid").trim() + "'"); // UID of the parent study
	rs.beforeFirst();
	// move ptr back to the beginning so that the while loop will work

	Statement st2 = db.createStatement();

	while (rs.next()) {
	  isEmpty (db, "ps_view", "stuinsuid", stuinsuid, "numser");
	  // if the parent study is empty of series, delete parent

	  st2.execute ("UPDATE ps_view SET numser=numser-1 WHERE stuinsuid=" + stuinsuid);
	  st2.execute ("UPDATE ps_view SET numins=numins-" + rs.getString("numins").trim() + "WHERE stuinsuid=" + stuinsuid);
	}
	st2.close(); // clean up		

	SQLStatement selectImages = help("sopins", "serinsuid", "select", "for", checked, null);
	// returns all images in each series marked 
	st.execute (selectImages.toString());
	rs = st.getResultSet();
 
	SQLStatement deleteImages = help("sopins", "insuid", "delete", "while", checked, rs);
	// deletes each image in each series selected above
	st.execute (deleteImages.toString());                          

	selectImages.addToSelect (null);
	// clear out the SELECT clause, change to DELETE
	selectImages.addToDelete ();           
	selectImages.addToFrom (null);
	// clear out FROM (previously "sopins"), change to "series". 
	selectImages.addToFrom ("series");
	// Keep the same WHERE clause.
	st.execute (selectImages.toString());                            // deleting empty series
      }

      else if (type.equals("image")) {

      }
    } catch (Exception e) {
      if (type.equals("study")) {
	;
      } else if (type.equals("series")) {
	doSeriesQuery (out, db, html, savedQuery, null, ("Delete failed! " + e));
      } else if (type.equals("image")) {
	;
      }

      try { db.rollback(); }
	catch (SQLException ignored) { }
	finally { out.println ("<PRE>" + e + "</PRE>"); }
      } finally {
	try { if (st != null) st.close(); }
	catch (SQLException ignored) { }
      }
  }

    // helper for deleteHelper 
  private SQLStatement help (String fromTable, String uniqueID, String queryType,
		String loopType, String[] checked, ResultSet rs) throws SQLException {
    boolean first = true;
    SQLStatement q = new SQLStatement ();    
    if (queryType.equals("select")) q.addToSelect ("*");
    else if (queryType.equals("delete")) q.addToDelete ();
    q.addToFrom (fromTable);
    if (loopType.equals("for")) {
      for (int i=0; i < checked.length; i++) {
	if (i==0)
	  q.addToWhere (uniqueID, checked[i], SQLStatement.IN);
	else
	  q.addToWhere (null, checked[i], SQLStatement.IN);
      }
    } else if (loopType.equals("while")) {  // using results from a previous query 
      while (rs.next()) {           
	if (first) { 
	  q.addToWhere (uniqueID, rs.getString(uniqueID).trim(), SQLStatement.IN); 
	  first = false; 
	} else {
	  q.addToWhere (null, rs.getString(uniqueID).trim(), SQLStatement.IN);
	}
      }
    }
    return q;
  }

  //another helper for deleteHelper
  private boolean isEmpty (Connection db, String table, String uidType,
		String uid, String emptyOf) throws SQLException { 
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
    } else {
       return false;
    }
  }

    private String formatExportSeriesOrder(String rcvr, String seriesUID, HttpServletRequest req) {
      String s = "'XMIT_SERIES', ";
      String aeTitle;
      int ix = rcvr.indexOf(' ');
      if (ix > 0) {
	aeTitle = rcvr.substring(0, ix);
      } else {
	aeTitle = rcvr;
      }

      s += "'destAE=" + aeTitle;
      s += "&seriesUID=" + seriesUID + "'";

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
