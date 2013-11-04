package edu.wustl.mir.mesaweb.common;

import java.io.*;                       
import java.util.*;
import java.sql.*;

import edu.wustl.mir.mesaweb.common.DomainObject;

public class SQLInterface {
  private java.util.Vector mResultsVector;
  private String mException = null;

  public SQLInterface() {
    mResultsVector= new java.util.Vector(10,1);
  }

  public int select(Connection db, String tableName, String whereClause, 
	String[] columnNames, int rowLimit) {

    mResultsVector.clear();
    String q = "select " + columnNames[0];
    int len = columnNames.length;
    int idx = 0;
    for (idx = 1; idx < len; idx++) {
      q += "," + columnNames[idx];
    }
    q += " from " + tableName + " " + whereClause + ";";
    System.out.println(q);
    int rowCount = 0;
    boolean rowLimitReached = false;

    try {
      Statement stmt = db.createStatement();
      if (stmt.execute(q)) {
	ResultSet rs = stmt.getResultSet();
	while (!rowLimitReached && rs.next()) {
	  DomainObject d = new DomainObject();
	  for (idx = 1; idx <= len; idx++) {
	    String val = rs.getString(idx);
	    d.put(columnNames[idx-1], val);
	  }
	  mResultsVector.addElement(d);
	  rowCount++;
	  if (rowLimit > 0 && rowCount >= rowLimit) {
	    rowLimitReached = true;
	  }
	}
      }
    } catch (SQLException se) {
      mException = new String(se.getMessage());
    }
    return 0;
  }

  public int rowCount() {
    return mResultsVector.size();
  }

  public DomainObject getRow(int index) {
    return (DomainObject) mResultsVector.elementAt(index);
  }
}

