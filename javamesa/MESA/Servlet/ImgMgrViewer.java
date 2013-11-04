package MESA.Servlet;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import MESA.Servlet.PatientStudyTable;
import MESA.Servlet.SeriesTable;
import MESA.Servlet.SOPInstanceTable;


public class ImgMgrViewer extends HttpServlet {
 
  Connection mDB = null;	// mDB is shared by all threads that
				// request this servlet
  //HtmlHelper html = null;	// helps with html tables, formatting,

  public void init() {
    try {
      Class.forName("org.postgresql.Driver");
    } catch (ClassNotFoundException ignored) {
      System.out.println("Could not load postgresql driver");
      return;
    }
    String dbName = "imgmgr_study";
    try {
      mDB = DriverManager.getConnection("jdbc:postgresql:" +
		dbName + "?user=postgres&password=7066ms##");
    } catch (SQLException se) {
      System.out.println("Could not connect to database: " + dbName);
      System.out.println("SQL Error: " + se.getMessage());
      mDB = null;
      return;
    }
  }

    
  public void doGet (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	
    res.setContentType ("text/html");
    PrintWriter out = res.getWriter();

    if (mDB == null) {
      this.init();
      if (mDB == null) {
	out.println("Unable to initialize our database");
	out.println ("</BODY></HTML>");
	return;
      }
    }

    out.println("<FORM ACTION='/servlet/X'>");
    String action = req.getParameter("action");
    String keyName = req.getParameter("keyname");
    String keyValue = req.getParameter("keyval");

    if (action == null || action.equals("")) {
      this.printStartPage(out);
    } else if (action.equals("Display Table")) {
      String tableName = req.getParameter("tablename");
      this.printStartPage(out);
      this.displayTable(out, tableName, keyName, keyValue);
    }

    out.println ("</BODY></HTML>");
  }

  private void printStartPage(PrintWriter out) {
    String result = ("<HTML>\n" + 
                         "<HEAD><TITLE>" + "Image Manager Tables" + "</TITLE></HEAD>\n" +
                         "<BODY>\n" + 
                         "<H2>" + "Image Manager Tables" + "</H2>\n");

    out.println(result);

    this.printTableSelection(out);
  }

  private void printTableSelection(PrintWriter out) {
    out.println("<P>Select a table: <SELECT NAME=tablename SIZE=1>");
    String[] t = {"Patient", "PatientStudy", "Study", "Series",
	"SOPInstance"};

    int idx = 0;
    for (idx = 0; idx < t.length; idx++) {
      out.println("<OPTION VALUE=" + t[idx] + "> " + t[idx]);
    }
    out.println("</SELECT>");
    out.println("<BR>");
    out.println("<BR>");
    out.println("<INPUT TYPE=submit NAME=action VALUE='Display Table'><BR><BR>");
  }

  private void displayTable(PrintWriter out, String tableName,
	String keyName, String keyValue) {
    if (tableName == null) {
      return;
    }

    out.println("Table Name: " + tableName);
    if (tableName.equals("PatientStudy")) {
      PatientStudyTable t = new PatientStudyTable();
      t.printTable(out, mDB, keyName, keyValue);
    } else if (tableName.equals("Series")) {
      SeriesTable s = new SeriesTable();
      s.printTable(out, mDB, keyName, keyValue);
    } else if (tableName.equals("SOPInstance")) {
      SOPInstanceTable s = new SOPInstanceTable();
      s.printTable(out, mDB, keyName, keyValue);
    }
  }
}
