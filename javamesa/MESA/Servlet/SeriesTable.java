package MESA.Servlet;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

import MESA.Servlet.HtmlHelper;

public class SeriesTable extends HttpServlet {
 
  public void printTable(PrintWriter out, Connection db,
	String keyName, String keyValue) {

    String[] columnHeadings =
	{ "Series #", "Mod", "Objects", "Series Desc" };

    HtmlHelper h = new HtmlHelper();
    String stmt = "select serinsuid, sernum, mod, numins, serdes from series";
    if (keyName != null && keyValue != null) {
      stmt = stmt + " where " + keyName + " = '" + keyValue + "'";
    }

    h.printTable(out, db, stmt, columnHeadings, "SOPInstance", "serinsuid");
  }
}
