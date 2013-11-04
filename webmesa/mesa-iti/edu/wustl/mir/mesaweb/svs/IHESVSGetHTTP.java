//
// class IHESVSGetHTTP
// 

package edu.wustl.mir.mesaweb.svs;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import edu.wustl.mir.mesaweb.common.SQLInterface;
import edu.wustl.mir.mesaweb.common.DomainObject;
/**
 IHESVSGetHTTP generates documents to test IHE Section 3.12

 */
public class IHESVSGetHTTP extends HttpServlet {
  Connection mDB = null;	// Provides database access
  private String storagePath = null;	// Path to test images
  private String defaultPath = "/opt/postgres/data";	// Path to test images
  private String mLogPath = null;

/**
 init sets up the database connection for the servlet

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
    System.out.println("IHESVSGetHTTP::init found driver for " + jdbcDriverName);

    try {
      mDB = DriverManager.getConnection(jdbcConnectURL);
    } catch (SQLException se) {
      System.out.println("Could not connect to database: " + jdbcConnectURL);
      System.out.println("SQL Error: " + se.getMessage());
      mDB = null;
      return;
    }
    System.out.println("IHESVSGetHTTP::init connected to DB: " + jdbcConnectURL);

    mLogPath = config.getInitParameter("logPath");
    if (mLogPath == null) mLogPath = "/opt/mesa/logs/info_src.log";
    storagePath = config.getInitParameter("storagePath");
    if (storagePath == null) storagePath = defaultPath;
    System.out.println("storage path :'" + storagePath + "'" );
  }

/**
  doGet implements the servlet get method.  
  @throws ServletException
  @throws IOException

 */
    
  public void doGet (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

    int status = this.validateInputQuery(req);
    if (status != 0) {
      res.setStatus(HttpServletResponse.SC_BAD_REQUEST);
      return;
    }
    SQLInterface sql = new SQLInterface();
    status = this.processInputQuery(sql, req);
    if (status != 0) {
      res.setStatus(HttpServletResponse.SC_NOT_FOUND);
      return;
    }

    int idx = 0;

    while (idx<sql.rowCount()){
    DomainObject d1 = sql.getRow(idx++);
    String dir = d1.get("path_root");
    String image  = d1.get("path");

    if (dir.trim() == null) {
       int fileOffset = image.lastIndexOf("/");
       dir = image.substring(1,fileOffset);
       image = image.substring(fileOffset,image.length()); 
    }

    if (dir.trim().compareToIgnoreCase("MESA_STORAGE") == 0) {
       dir = storagePath;
    }

    String type  = d1.get("doc_type");
    String contentType = "<NULL>";

    contentType = "text/xml";

    System.out.println("content type: " + contentType);
    System.out.println("Dir name: " + dir.trim());
    System.out.println("File name:" + image.trim());


    File file = new File(dir.trim(),image.trim());
    res.setContentLength ((int)file.length());
    res.setHeader ("Cache-Control", "no-cache");
    res.setContentType(contentType);
    OutputStream outStream = res.getOutputStream();

    FileInputStream inStream = new FileInputStream(file);
    byte[] buffer = new byte[8192];

    int bytesWritten = 0;
    while (true) {
        int n = inStream.read(buffer);
        if (n<0) break;
        outStream.write(buffer, 0, n);
	bytesWritten += n;
	System.out.println (" After write, n = " + n);
	System.out.println (" Bytes written  = " + bytesWritten);
    } 
    inStream.close();
    outStream.flush();
    System.out.println("Bytes written to xfer file: " + bytesWritten);
    System.out.println("File length: " + (int)file.length());
    break;
   }
/*      res.setStatus(HttpServletResponse.SC_NOT_ACCEPTABLE);*/
      res.setStatus(HttpServletResponse.SC_OK);
  }

/**
   validateInputQuery checks the request for completeness
@param req the request 
@return 0 if the request is valid, 1 if the request is defective
 */
 public int validateInputQuery(HttpServletRequest req) {
    System.out.println("IHESVSGetHttp::Validate input query");
    String svsID = req.getParameter("id");
    System.out.println("id" + svsID);
    if (svsID == null) {
       System.out.println("Invalid query: null id");
       return 1;
    }
    return 0;
  }

/**
 matchMimeType checks the parameter against the browser Accept directive
@param req the request 
@param contentType the type of the proposed document
@return 1 if the contentType is in the list of Acceptable contentTypes, 0 otherwise

*/
  public int matchMimeType(HttpServletRequest req, String contentType) {
    System.out.println("Function matchMimeType with contentType: " + contentType);
    StringTokenizer st = new StringTokenizer(req.getHeader("Accept"),",");
    while (st.hasMoreTokens()){
        String mimeType = st.nextToken();
	System.out.println("mimeType/contentType " + mimeType + "/" + contentType);
        if (mimeType.compareToIgnoreCase(contentType) == 0) {
           System.out.println("Acceptable content type: '" + contentType + "'"  ); 
           return 1;
        }
        if (mimeType.indexOf("*/*") != -1) {
           System.out.println("Default content type: '" + contentType + "'"  ); 
	   return 1;
        }
	System.out.println("mime type did not match: " + mimeType);
    }
    System.out.println("No matching MIME types found");
    return 0;
  }

/**
 processInputQuery retrieves the the document entry from the database, based in the requested UID.
 @param req the request 
 @param sql the database object 
 @return 1 if no entries are in found in the database, 0 otherwise 
 */
  public int processInputQuery(SQLInterface sql, HttpServletRequest req) {
    String svsID = req.getParameter("id");
    if (svsID == null) {
       svsID = new String("<NULL>");
    }
    String whereClause = "where svs_id = '" + svsID + "'";
    String[] columns = {"id", "svs_id", "version", "lang", "path_root", "path" };
    sql.select(mDB, "svs", whereClause, columns, 0);

    int rowCount = sql.rowCount();
    System.out.println ("Retrieved rows from svs table: " + rowCount);
    if (rowCount == 0) {
      return 1;
    }
    return 0;
  }
}
