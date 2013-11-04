package MESA.Servlet;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import MESA.Servlet.HtmlHelper;

public class PatientStudyTable extends HttpServlet {
 
  public void printTable(PrintWriter out, Connection db,
	String keyName, String keyValue) {

    String[] columnHeadings =
	{ "Name", "Pat ID", "DOB", "Acc #", "Study Date",
		"Mod", "Series", "Objects", "Study Desc" };

    HtmlHelper h = new HtmlHelper();
    String stmt = "select stuinsuid, nam, patid, datbir, accnum, studat, modinstu, numser, numins, studes, stuinsuid from ps_view";
    if (keyName != null && keyValue != null) {
      stmt = stmt + " where " + keyName + " = '" + keyValue + "'";
    }
    h.printTable(out, db, stmt, columnHeadings, "Series", "stuinsuid");
  }
}
