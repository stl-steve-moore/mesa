package edu.wustl.mir.mesaweb;

import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;


public class QueueManager extends HttpServlet {
    
    Connection db = null;      // db is shared by all threads that request this servlet
    HtmlHelper html = null;    // helps with html tables, formatting, and general prettiness

    static final String[] work_orders_headers = {"Order Number", "Type", "Parameters", "Ordered By", "DateOrdered", "Time Ordered", 
						 "Date Completed", "Time Completed", "Elapsed Time", "Work Time"};
    static final String[] work_orders_vars = {"ordnum", "typ","par", "ordbyini", "datord", "timord", "datcom", "timcom", "elatim", "wortim"};
    static final String[] users_headers = {"Initials", "Name", "Department", "Phone Number", "Email", "Last Update", "Status"};
    static final String[] users_vars = {"ini", "nam", "dep", "phonum", "ema", "lasupd", "status"};
    static final String[] last_request_headers = {"Initials", "Last Request Date", "Last Request Type"};
    static final String[] last_request_vars = {"ini", "lasreqdat", "lasreqtyp"};
    
    public void doGet (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	
	res.setContentType ("text/html");
	PrintWriter out = res.getWriter();

	initDriver (out);   // init methods are found below
	initConnection (out, "imgmgr_study");

	String action = req.getParameter("action");  // action is a hidden form param on each page which tells the servlet what method is executed next 

	if (action == null || action.equals ("")) {
	    //printStartPage (out);
	    view (out, "work_orders");
	}
	else if (action.equals ("viewWorkOrders")) { 
	    view (out, "work_orders");
	}
	else if (action.equals ("viewUsers")) { 
	    view (out, "users");
	}
	else if (action.equals ("viewLastRequest")) {
	    view (out, "last_req");
	}
	else if (action.equals ("options")) {
	    String table = req.getParameter("table");
	    String option = req.getParameter("option");
	    String[] entriesChecked = req.getParameterValues (table);
	    options (out, table, option, entriesChecked);
	}
	else if (action.equals ("add")) {
	    String table = req.getParameter("table");
	    String[] args = new String[getNumCols(table)];
	    for (int i = 0; i < args.length; i++) {
		args[i] = req.getParameter ((getVars(table))[i]);
	    }
	    add (out, table, args);
	}
	else if (action.equals ("update")) {
	    String table = req.getParameter("table");
	    String query = req.getParameter("query");
	    String[] args = new String[getNumCols(table)];
	    for (int i = 0; i < args.length; i++) {
		args[i] = req.getParameter ((getVars(table))[i]);
	    }
	    update (out, table, query, args);
	}
	else if (action.equals ("delete")) {
	    String table = req.getParameter("table");
	    String query = req.getParameter("query");
	    delete (out, table, query);
	}
	else if (action.equals ("quit")) {
	    try { if (db != null) db.close(); out.println ("<PRE>Connection to the database has been closed.</PRE>"); }
	    catch (SQLException se) { out.println ("<PRE>Error: " + se + "</PRE>"); }
	}

    }



    private void printStartPage (PrintWriter out) {
	out.println (html.printHeader ("Manage Queue Information"));
	out.println ("<P>To update or add entries to any of the three tables in the queue database, click on one of the links below:<br><br>");
	out.println ("<UL>");
	out.println ("<LI><A HREF=/servlet/QueueManager?action=viewWorkOrders> Work Orders </A><br>");
	out.println ("<LI><A HREF=/servlet/QueueManager?action=viewUsers> Users </A><br>");
	out.println ("<LI><A HREF=/servlet/QueueManager?action=viewLastRequest> Last Request </A><br>");
	out.println ("</UL>");
	out.println ("</BODY></HTML>");
    }



    private void view (PrintWriter out, String table) {
	String query = ("SELECT * FROM " + table);
	String uniqueid = getUniqueID(table);

	out.println (html.printHeader (getPrettyName(table) + ":"));
	out.println ("<FORM ACTION='/servlet/QueueManager'>");
	out.println ("<INPUT TYPE=hidden NAME=action VALUE=options>");
	out.println ("<INPUT TYPE=hidden NAME=table VALUE=" + table + ">");
	out.println (html.printTable (query, table, uniqueid, true)); 
      	out.println ("<INPUT TYPE=radio NAME=option VALUE=add>Add a new entry to the table.<br>");
	if (table.equals ("users")) {
	    out.println ("<INPUT TYPE=radio NAME=option VALUE=update>Update the information in a table entry. (Please check one entry to update).<br>");
	    out.println ("<INPUT TYPE=radio NAME=option VALUE=delete>Delete table entries. (Please check as many entries as you would like to delete).<br>");
	}
	out.println ("<INPUT TYPE=submit VALUE=GO!><br><br>");
	out.println ("</FORM>\n");
	out.println ("</BODY></HTML>");
    }



    private void options (PrintWriter out, String table, String option, String[] entriesChecked) {
	int col = getNumCols(table);
	String uniqueid = getUniqueID(table);
	
	if (option.equals("add")) {
	    out.println (html.printHeader ("Add a new entry to the table:"));
	    out.println ("<FORM ACTION='/servlet/QueueManager'>");
	    out.println ("<INPUT TYPE=hidden NAME=action VALUE=add>");
	    out.println ("<INPUT TYPE=hidden NAME=table VALUE=" + table + ">");
	    out.println ("<TABLE>");
	    String val = "";
	    for (int i = 0; i < col; i++) {
		out.println ("<tr><td>" + getHeader(table)[i] + ":</td><td><INPUT TYPE=text NAME=" + getVars(table)[i] + "></td></tr>");
	    }
	    out.println ("</TABLE>");
	    out.println ("<INPUT TYPE=submit VALUE=Submit><br><br>");
	    out.println ("</FORM></BODY></HTML>"); 
	}

	else if (option.equals("update")) {
	    if (entriesChecked == null || entriesChecked.length == 0) {
		out.println ("<PRE>Error: Please select an entry to update</PRE>"); view (out, table);
	    }else if (entriesChecked.length > 1) {
		out.println ("<PRE>Error: Please select only one entry to update</PRE>"); view (out, table);
	    }else {
		String query = ("SELECT * FROM " + table + " WHERE " + uniqueid + "='" + entriesChecked[0] + "'");
		
		Statement st = null;
		try { 
		    st = db.createStatement(); 
		    st.execute (query); 
		    ResultSet rs = st.getResultSet();
		    ResultSetMetaData rsm = rs.getMetaData();
		    out.println (html.printHeader ("Update a table entry:"));
		    out.println ("<FORM ACTION='/servlet/QueueManager'>");
		    out.println ("<INPUT TYPE=hidden NAME=action VALUE=update>");
		    out.println ("<INPUT TYPE=hidden NAME=table VALUE=" + table + ">");
		    out.println ("<INPUT TYPE=hidden NAME=query VALUE=\"" + query + "\">");
		    out.println ("<TABLE>");
		    while (rs.next()) {
			for (int i = 1; i <= col; i++) {
			    String val = rs.getString(i).trim(); 
			    String header = rsm.getColumnLabel(i); 
			    out.println ("<tr><td>" + html.format (header, table + "_header", i) + "</td>");
			    out.println ("<td><INPUT TYPE=text VALUE='" + html.format (val, table, i) + "' NAME=" + header + "></td></tr>");
			}
		    }
		    out.println ("</TABLE><br>");
		    out.println ("<INPUT TYPE=submit VALUE=Update><br><br>");
		    out.println ("</FORM>");
		    out.println ("</BODY></HTML>");
		}
		catch (SQLException se) { out.println ("<PRE>Error occured while updating entry: " + se.getMessage() + " </PRE>"); }
		finally {
		    try { if (st != null) st.close(); }
		    catch (SQLException ignored) { }
		}
	    }
	}

	else if (option.equals("delete")) {
	    if (entriesChecked == null || entriesChecked.length == 0) {
		out.println ("<PRE>Error: Please select an entry to delete</PRE>"); view (out, table);
	    }else {
		String query = ("SELECT * FROM " + table + " WHERE " + uniqueid + " IN ("); 
		for (int i = 0; i < entriesChecked.length; i++) {
		    if (i < entriesChecked.length - 1) query += ("'" + entriesChecked[i] + "', ");
		    else query += ("'" + entriesChecked[i] + "')");
		}
		
		out.println (html.printHeader ("Delete entries from the table:"));
		out.println ("<P>You have chosen to delete the following studies:");
		out.println (html.printTable (query, table, null, false)); 
		out.println ("<FORM ACTION='/servlet/QueueManager'>");
		out.println ("<INPUT TYPE=hidden NAME=action VALUE=delete>");
		out.println ("<INPUT TYPE=hidden NAME=table VALUE=" + table + ">");
		out.println ("<INPUT TYPE=hidden NAME=query VALUE=\"" + query + "\">");
		out.println ("<INPUT TYPE=submit VALUE=Confirm><br><br>");
		out.println ("</FORM>\n");
		out.println ("</BODY></HTML>");
	    }
	}
    }



    private void add (PrintWriter out, String table, String[] args) {
	String add = ("INSERT INTO " + table + "\nVALUES (");
	for (int i = 0; i < args.length; i++) {
	    if (i < args.length - 1) add += ("'" + args[i] + "', ");
	    else add += ("'" + args[i] + "')");
	}

	//out.println ("<PRE>" + add + "</PRE>");

	Statement st = null;
	try { st = db.createStatement(); st.execute (add); }
	catch (SQLException se) { out.println ("<PRE>Error occured while adding new entry: " + se.getMessage() + " </PRE>"); }
	finally {
	    try { if (st != null) st.close(); }
	    catch (SQLException ignored) { }
	}
	view (out, table);
    }



    private void update (PrintWriter out, String table, String query, String[] args) {
	if (table.equals ("users")) {
	    Statement st = null;
	    try {
		db.setAutoCommit (false);
		st = db.createStatement();
		
		out.println ("<PRE>" + query + "</PRE>");
		int index = query.indexOf("=");
		String uniqueid = query.substring (index + 2, query.indexOf('\'', index + 2));
		
		String update = "";
		for (int i = 0; i < args.length; i++) {
		    update = ("UPDATE " +table+ " SET " +getVars(table)[i]+ "='" +args[i].trim()+ "' WHERE " +getUniqueID(table)+ "='" +uniqueid+ "'"); 
		    st.executeUpdate (update);
		    //out.println ("<PRE>" + update + "</PRE>");
		}
		db.commit();
		view (out, table);
	    }catch (Exception e) {
		try { db.rollback(); }
		catch (SQLException ignored) { }
		finally { out.println ("<PRE>Error: " + e + "</PRE>");  view (out, table); }
	    }finally {
		try { if (st != null) st.close(); }
		catch (SQLException ignored) { }
	    }
	}else {
	    out.println ("<PRE>Cannot update this table.</PRE>");
	    view (out, table);
	}
    }



    private void delete (PrintWriter out, String table, String query) {
	// Not a real delete, instead set status to inactive. 
	if (table.equals("users")) {
	    Statement st = null;
	    try {
		db.setAutoCommit (false);
		st = db.createStatement();
		
		int index = query.indexOf("WHERE ini IN");
		String where = query.substring (index, query.indexOf(')', index) + 1);

		String delete = ("UPDATE users SET status='INACTIVE' " + where); 
		//out.println ("<PRE>" + delete + "</PRE>"); 
		st.executeUpdate (delete);

		db.commit();
		view (out, table);
	    }catch (Exception e) {
		try { db.rollback(); }
		catch (SQLException ignored) { }
		finally { out.println ("<PRE>Error: " + e + "</PRE>"); view (out, table); }
	    }finally {
		try { if (st != null) st.close(); }
		catch (SQLException ignored) { }
	    }
	} else {
	    out.println ("<PRE>Cannot delete anything from this table.</PRE>");
	    view (out, table);
	}
    }




    /*
     *
     *
     *
     *
     *
     *
     * Init and helper methods:
     */


    public void doPost (HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
	doGet (req, res);
    }

    private void initDriver (PrintWriter out) {
	//loads the postgres driver
	try { Class.forName ("org.postgresql.Driver"); }
	catch (ClassNotFoundException ignored) { }
    }

    private void initConnection (PrintWriter out, String dbName) {
	if (db == null) {
	    try {
		db = DriverManager.getConnection ("jdbc:postgresql:" + dbName + "?user=postgres&password=7066ms##");
	    }catch (SQLException se) {
		out.println ("<PRE>ERROR: Could not connect to database." + se.getMessage() + "</PRE>");
	    }
	}
	if (html == null) { html = new HtmlHelper (db);	}
    } 

    public void destroy () {
	try { if (db != null) db.close(); }
	catch (SQLException ignored) { }
    }

    private String[] getHeader (String table) {
	if (table.equals("work_orders")) return work_orders_headers;
	else if (table.equals("users")) return users_headers;
	else return last_request_headers;
    }

    private String[] getVars (String table) {
	if (table.equals("work_orders")) return work_orders_vars;
	else if (table.equals("users")) return users_vars;
	else return last_request_vars;
    }

    private String getPrettyName (String table) {
	if (table.equals("work_orders")) return "Work Orders";
	else if (table.equals("users")) return "Users";
	else return "Last Request";
    }

    private String getUniqueID (String table) {
	if (table.equals("work_orders")) return "ordnum";
	else if (table.equals("users")) return "ini";
	else return "ini";
    }

    private int getNumCols (String table) {
	if (table.equals("work_orders")) return 10;
	else if (table.equals("users")) return 7;
	else return 3;
    }

}
