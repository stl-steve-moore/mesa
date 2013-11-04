package MESA.Servlet;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import MESA.Servlet.HtmlHelper;

public class SOPInstanceTable extends HttpServlet {
 
  public void printTable(PrintWriter out, Connection db,
	String keyName, String keyValue) {

    String[] columnHeadings =
	{ "Inst #", "Rows", "Cols", "Path" };

    HtmlHelper h = new HtmlHelper();
    String stmt = "select insuid, imanum, row, col, filnam from sopins";
    if (keyName != null && keyValue != null) {
      stmt = stmt + " where " + keyName + " = '" + keyValue + "'";
    }

    h.printTable(out, db, stmt, columnHeadings, "SOPInstance", "insuid");
  }
}
