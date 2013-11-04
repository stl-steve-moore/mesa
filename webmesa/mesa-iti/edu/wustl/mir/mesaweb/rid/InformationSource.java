//
// class InformationSource
//
// Provides a test information source in support of IHE validation

package edu.wustl.mir.mesaweb.rid;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import edu.wustl.mir.mesaweb.rid.SQLInterface;
import edu.wustl.mir.mesaweb.rid.DomainObject;
/**
  InformationSource generates information for IHE validations

 */
public class InformationSource extends HttpServlet {
  Connection mDB = null;	// Provides database access
  String mLogPath = null;
  String mStoragePath = null;
  PrintStream mLogStream = null;

/**
  init sets up the database and logging environment for the servlet

 */
  public void init(ServletConfig config) {
    String jdbcDriverName = config.getInitParameter("jdbcDriverName");
    String jdbcConnectURL = config.getInitParameter("jdbcConnectURL");
    try {
      Class.forName(jdbcDriverName);
    } catch (ClassNotFoundException ignored) {
      System.out.println("Could not load JDBC driver: " + jdbcDriverName);
      return;
    }
    //String dbName = "info_src";


    try {
      //mDB = DriverManager.getConnection("jdbc:postgresql:"+ dbName + "?user=postgres");
      mDB = DriverManager.getConnection(jdbcConnectURL);
    } catch (SQLException se) {
      System.out.println("Could not connect to database: " + jdbcConnectURL);
      System.out.println("SQL Error: " + se.getMessage());
      mDB = null;
      return;
    }
    mLogPath = config.getInitParameter("logPath");
    if (mLogPath == null) mLogPath = "/opt/mesa/logs/info_src.log";
    System.out.println("Information Source log path:'" + mLogPath + "'" );
    mStoragePath = config.getInitParameter("imagePath");
    if (mStoragePath == null) mLogPath = "/opt/mesa/storage";
    System.out.println("Information Source Storage path:'" + mStoragePath + "'" );

    try {
      FileOutputStream f = new FileOutputStream(mLogPath, true);
      mLogStream = new PrintStream(f);
    } catch (java.io.FileNotFoundException fnf) {
      System.out.println("Could not open output log file: " + mLogPath);
    }
  }

/**
  doGet implements the servlet get method

 */
  
  public void doGet (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
  	SQLInterface sql = new SQLInterface();       
    int status = this.processInputQuery(sql, req);
    /** if (status != 0) {
      res.setStatus(HttpServletResponse.SC_NOT_FOUND);
      return;  	
    } **/ 
  	if (req.getParameter("requestType").equalsIgnoreCase("SUMMARY-CARDIOLOGY-ECG")) {
    	// THERE IS ONLY ONE XML...
  		int rowCount = sql.rowCount();
  		System.out.println("ROW COUNT: " + rowCount);
  	    if (rowCount == 0) {
  	      /** res.setContentType("text/html");
  	       PrintWriter out = res.getWriter();
  	       this.writeDocType(out);
  	       this.writeHTMLHeader(out);
  	       out.println("<BODY>");
  	       out.println("<PRE>");
  	       out.println("<B> ERROR!!! NO XML REPORT </B>");
  	       out.println("</BODY></HTML>"); **/	       
  	      res.setStatus(HttpServletResponse.SC_NOT_FOUND);
	      return;	
  	    } else if (rowCount == 1) { 	    
  	    	    DomainObject d1 = sql.getRow(0);
		    String patID = d1.get("patid");
		    String reportType = d1.get("rpttype");
		    System.out.println("Pat ID: " + patID + " rpt type: " + reportType);
  	    	    String rptxml = d1.get("rptxml");
		    if (rptxml == null) {
		      System.out.println("MESA implementation error: rptxml is null");
		      res.setStatus(HttpServletResponse.SC_NOT_FOUND);
		      return;
		    }
		    rptxml = rptxml.trim();
  	    	    String rptpath = d1.get("rptpath");
		    rptpath = rptpath.trim();
		    if (rptpath.compareToIgnoreCase("MESA_STORAGE") == 0) {
		      rptpath = mStoragePath;
		    }
  	    	    System.out.println ("RPTXML : " + rptxml + " !RPTPATH : " + rptpath);
  	    	    File file = new File(rptpath.trim(),rptxml.trim());
		    if (file == null) {
		      res.setStatus(HttpServletResponse.SC_NOT_FOUND);
		      return;
		    }
		    	//File file = new File("C:\\users\\smm\\mesa\\storage\\rid","ecg20304.xml");
		    	res.setContentLength((int)file.length());
		    	res.setHeader("Cache-Control","no-cache");
		    	res.setContentType("text/xml");
		    	OutputStream outStream = res.getOutputStream();
		    	
		    	FileInputStream inStream = new FileInputStream(file);
				byte[] buffer = new byte[8192];
				while (true) {
					int n = inStream.read(buffer);
					if (n < 0)
						break;
					outStream.write(buffer, 0, n);
				}
				inStream.close(); 
  	    } else if (rowCount > 1) {
	  	       res.setContentType("text/html");
	   	       PrintWriter out = res.getWriter();
	   	       this.writeDocType(out);
	   	       this.writeHTMLHeader(out);
	   	       out.println("<BODY>");
	   	       out.println("<PRE>");
	   	       out.println("<B> MORE THAN ONE XML REPORT. </B> <BR> <B>THE MESA SERVER IS NOT READY FOR THIS TEST. </B>");
	   	       out.println("</BODY></HTML>");
  	    }
    } else {
       /** SQLInterface sql = new SQLInterface(); 
    
        int status = this.processInputQuery(sql, req); **/
	    if (status != 0) {
	      res.setStatus(HttpServletResponse.SC_NOT_FOUND);
	      return;
	    }  

	    res.setContentType ("text/html");
	    PrintWriter out = res.getWriter();
	
	    Enumeration e = req.getParameterNames ();
	
	
	    String patientID = req.getParameter("patientID");
	    if (patientID == null) {
	       patientID = new String("<NULL>");
	    }
	
	    this.writeDocType(out);
	    this.writeHTMLHeader(out);
	    out.println ("<BODY>");
	    out.println ("<PRE>");
	    out.println ("Patient ID: " + patientID);
	    while (e.hasMoreElements()) {
	      String v = (String)e.nextElement();
	      String value = req.getParameter(v);
	      out.println(v + ":" + value);
	      if (mLogStream != null)
		mLogStream.println(v + ":" + value);
	    }
	    this.printHTTPFields(out, req);
	    out.println ("</PRE>");
	    status = this.processQueryResult(out, sql);
        out.println ("</BODY></HTML>");
    }
  }
/**
  writeDocType sends an xhtml basic header to the output stream
  @param out the output stream

 */
  public void writeDocType(PrintWriter out) {
    out.println("<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML Basic 1.0//EN\" \"http://www.w3.org/TR/xhtml-basic/xhtml-basic10.dtd\">");
  }
/**
  writeHTMLHeader sends an HTML header to the output stream
  @param out the output stream

 */
  public void writeHTMLHeader(PrintWriter out) {
    out.println("<html xmlns=\"http://www.w3.org/1999/xhtml\" xml:lang=\"en\" >");
  }

/**
  printHTTPFields retrieves the HTTP Accept values and displays them
  @param out the output stream
  @param req the web request

 */
  public void printHTTPFields(PrintWriter out, HttpServletRequest req) {
    String acceptValue = req.getHeader("Accept");
    out.println("Accept: " + acceptValue);
    StringTokenizer st = new StringTokenizer(acceptValue, ",");
    while (st.hasMoreTokens()){
      String mimeType = st.nextToken();
      out.println("  MIME type: " + mimeType);
    }
  }

/**
  processQueryResult formats database output for the display stream
  @param out the output stream
  @param sql the database handle 

 */
  public int processQueryResult(PrintWriter out, SQLInterface sql) {
    int rowCount = sql.rowCount();
    if (rowCount == 0) {
      return 1;
    }
    out.println("<PRE>Row count: " + rowCount + "</PRE>");
    DomainObject d1 = sql.getRow(0);
    String name = d1.get("nam");
    String dob  = d1.get("datbir");
    out.println("<H3>Patient: " + name + " " + dob + "</H3>");
    int idx = 0;
    for (idx = 0; idx < rowCount; idx++) {
      DomainObject d = sql.getRow(idx);
	     name        = d.get("nam");
     // String rptType     = d.get("rpttype");
      String rptTxt      = d.get("rpttxt");
      String rptDateTime = d.get("rptdatetime");
      out.println("<H5>Date/time: " + rptDateTime + "</H5>");
      out.println(rptTxt);
    }
    return 0;
  }
/**
  processInputQuery formats the database query from the web request
  @param sql the database handle 
  @param req the web request 
  @return 1 for no matching records, 0 otherwise

 */

  public int processInputQuery(SQLInterface sql, HttpServletRequest req) {
    String patientID = req.getParameter("patientID");
    if (patientID == null) {
       patientID = new String("<NULL>");
    }
    String requestType = req.getParameter("requestType");
    if (requestType == null) {
       requestType = new String("<NULL>");
    }
    String lowerTime = req.getParameter("lowerDateTime");
    if (lowerTime == null) {
       lowerTime = new String("-infinity");
    }
    String upperTime = req.getParameter("upperDateTime");
    if (upperTime == null) {
       upperTime = new String("infinity");
    }
    String numResults = req.getParameter("mostRecentResults");
    if (numResults == null) {
       numResults = new String("0");
    }
    java.util.StringTokenizer t = new java.util.StringTokenizer(patientID, "^", false);
    String pid = (String)t.nextElement();
    String whereClause = "where patid = '" + pid + "'";
    if (!requestType.equals("SUMMARY")) {
      whereClause += " and rpttype = '" + requestType + "'";
    }
    whereClause += " and rptdatetime between '"+ lowerTime + "' and '" + upperTime + "' ";
    whereClause += " order by rptdatetime desc";
    int rowLimit = Integer.parseInt(numResults);
    String[] columns = {"patid", "issuer", "nam", "datbir", "sex", "rpttype", "rpttxt", "rptdatetime", "rptxml", "rptpath" };
    sql.select(mDB, "reportview", whereClause, columns, rowLimit);

    int rowCount = sql.rowCount();
    if (rowCount == 0) {
      return 1;
    }
    return 0;
  }
}
