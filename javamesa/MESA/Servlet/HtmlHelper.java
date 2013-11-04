package MESA.Servlet;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class HtmlHelper extends HttpServlet {
 
  public void printTable(PrintWriter out, Connection db,
	String query, String[] headings, String tableName, String keyName) {

    if (db == null) {
      out.println("Null db in HtmlHelper.printTable");
      return;
    }

    int idx = 0;

    try {
      Statement stmt = db.createStatement();
      if (stmt.execute(query)) {
	ResultSet rs = stmt.getResultSet();

	out.println("<P><TABLE BORDER cellspacing=0 cellpadding=5>");
	out.println("<TR>");
	for (idx = 0; idx < headings.length; idx++) {
	  out.println("<TH> " + headings[idx] + "</TH>");
	}
	out.println("</TR>");

	while(rs.next()) {
	  int j;
	  out.println("<TR>");
	  String keyValue = rs.getString(1);
	  for (j = 1; j <= headings.length; j++) {
	    String val = rs.getString(j+1);
	    if (val == null) {
	      val = "----";
	    } else {
	      val = val.trim();
	      if (val.equals("") || val.equals(" ")) {
		val = "----";
	      }
	    }
	    if (j == 1) {
	      this.printReference(out, val, tableName, keyName, keyValue);
	    } else {
	      out.println("<TD>" + val);
	    }
	  }
	  out.println("<TR>");
	}
      }
      out.println("</TABLE>");
    } catch (SQLException se) {
      out.println("</TABLE> " + se.getMessage());
    //out.println("<TR>");
    //for (idx = 0; idx < columnHeadings.length; idx++) {
    //  out.println("<TD> " + columnHeadings[idx] + "</TD>");
    //}
    }
  }
  public void printReference(PrintWriter out, String val,
	String tableName, String keyName, String keyValue ) {
    String s1 = "tablename=" + tableName;
    String s2 = "&action=Display+Table";
    String s3 = "&keyname=" + keyName;
    String s4 = "&keyval=" + keyValue;

    out.println("<TD><a href=ImgMgrViewer?" + s1 + s2 + s3 + s4 +">" + val + "</a></TD>");

//	PatientStudy&action=Display+Table>"
//    out.println("<TD><a href=ImgMgrViewer?tablename=PatientStudy&action=Display+Table>"
//	+ val + "</a></TD>");
  }
}
