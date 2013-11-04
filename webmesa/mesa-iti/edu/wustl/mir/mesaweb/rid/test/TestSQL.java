
import java.io.*;                       
import java.util.*;
import java.sql.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class TestSQL {
  Connection mDB = null;	// Provides database access

  public void init(String sysType) {
    String dbName = "info_src";
    if (sysType.equals("UNIX")) {
      try {
	Class.forName("org.postgresql.Driver");
      } catch (ClassNotFoundException ignored) {
	System.out.println("Could not load postgresql driver");
	return;
      }
      try {
	mDB = DriverManager.getConnection("jdbc:postgresql:"+
	  dbName + "?user=smm");
      } catch (SQLException se) {
	System.out.println("Could not connect to database: " + dbName);
	System.out.println("SQL Error: " + se.getMessage());
	mDB = null;
	return;
      }
    } else if (sysType.equals("W32")) {
      try {
	Class.forName("com.microsoft.jdbc.sqlserver.SQLServerDriver");
      } catch (ClassNotFoundException ignored) {
	System.out.println("Could not load JDBC driver for W32: com.microsoft.jdbc.sqlserver.SQLServerDriver");
	return;
      }
      System.out.println("Loaded JDBC driver for MS SQL Server");
      try {
	mDB = DriverManager.getConnection("jdbc:microsoft:sqlserver://127.0.0.1:1433;DatabaseName=info_src;ServerName=C39HR61;User=ctn;Password=ctn");
	//mDB = DriverManager.getConnection("jdbc:microsoft:sqlserver://127.0.0.1:1433");

      } catch (SQLException se) {
	System.out.println("Could not connect to database: " + dbName);
	System.out.println("SQL Error: " + se.getMessage());
	mDB = null;
	return;
      }
    } else {
      System.out.println("System type should be W32 or UNIX; you specified: " + sysType);
      return;
    }
  }

    
  public static void main(String[] args) {
    if (args.length == 0) {
      System.out.println("Usage: java TestSQL <W32 or UNIX>");
      return;
    }
    TestSQL t = new TestSQL();
    t.init(args[0]);
    return;
  }
}

