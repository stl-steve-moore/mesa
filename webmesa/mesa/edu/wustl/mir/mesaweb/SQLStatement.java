package edu.wustl.mir.mesaweb;

// SQLStatement.java
// Amy Hawkins
// 7-2-01

// This class encapsulates the clauses of an SQL statement as Strings. It only
// supports the clauses I happened to need while writing the ImageManager 
// servlet. An instance of this class is intended to be built and executed, but
// not modified extensively for reuse. Minimal modifications can be made by 
// calling one of the mutators with null as the argument. This deletes that 
// clause. Also, extra parameters can be added to a clause by calling its 
// mutator again. The exception to this is the addToDelete mutator, which 
// takes no argument. 

import java.io.*;
import java.util.*;
import java.sql.*;

public class SQLStatement {

    String select;
    String delete;
    String from;

    String update;
    String set;

    String where;
    String orderBy;
    //add others if needed

    public static final int NORMAL = 1;  // used for addToWhere
    public static final int IN = 2;
    public static final int LIKE = 3;

    SQLStatement () {
	select = null;
	delete = null;
	from = null;
	update = null;
	set = null;
	where = null;
	orderBy = null;
    }

    SQLStatement (SQLStatement s) {
	this.select = s.select;
	this.delete = s.delete;
	this.from = s.from;
	this.update = s.update;
	this.set = s.set;
	this.where = s.where;
	this.orderBy = s.orderBy;
    }

    SQLStatement (String query) {
	//parse and save into args
	int selectI = query.indexOf ("SELECT");
	int deleteI = query.indexOf ("DELETE");
	int fromI = query.indexOf ("FROM");
	int updateI = query.indexOf ("UPDATE");	
	int setI = query.indexOf ("SET");
	int whereI = query.indexOf ("WHERE");
	int orderI = query.indexOf ("ORDER BY");

	if (selectI > -1) { 
	    select = query.substring (selectI + 7); //start from end of SELECT
	    if (deleteI > -1)   // trim extra clauses, if needed
		select = select.substring (0, select.indexOf ("DELETE"));
	    else if (fromI > -1)
		select = select.substring (0, select.indexOf ("FROM"));
	    else if (updateI > -1)
		select = select.substring (0, select.indexOf ("UPDATE"));
	    else if (setI > -1)
		select = select.substring (0, select.indexOf ("SET"));
	    else if (whereI > -1)
		select = select.substring (0, select.indexOf ("WHERE"));
	    else if (orderI > -1)
		select = select.substring (0, select.indexOf ("ORDER BY"));
	}else select = null;

	if (deleteI > -1) { 
	    delete = query.substring (deleteI + 7); //start from end of DELETE
	    if (fromI > -1)    // trim extra clauses, if needed
		delete = delete.substring (0, delete.indexOf ("FROM"));
	    else if (updateI > -1)
		delete = delete.substring (0, delete.indexOf ("UPDATE"));
	    else if (setI > -1)
		delete = delete.substring (0, delete.indexOf ("SET"));
	    else if (whereI > -1)
		delete = delete.substring (0, delete.indexOf ("WHERE"));
	    else if (orderI > -1)
		delete = delete.substring (0, delete.indexOf ("ORDER BY"));
	}else delete = null;

	if (fromI > -1) {
	    from = query.substring (fromI + 5); //start from end of FROM
	    if (updateI > -1)  // trim extra clauses, if needed
		from = from.substring (0, from.indexOf ("UPDATE"));	    
	    else if (setI > -1)
		from = from.substring (0, from.indexOf ("SET"));
	    else if (whereI > -1)  
		from = from.substring (0, from.indexOf ("WHERE"));
	    else if (orderI > -1) 
		from = from.substring (0, from.indexOf ("ORDER BY"));
	}else from = null;

	if (updateI > -1) {
	    update = query.substring (updateI + 5); //start from end of UPDATE
	    if (setI > -1)   // trim extra clauses, if needed
		update = update.substring (0, update.indexOf ("SET"));
	    else if (whereI > -1)  
		update = update.substring (0, update.indexOf ("WHERE"));
	    else if (orderI > -1) 
		update = update.substring (0, update.indexOf ("ORDER BY"));
	}else update = null;

	if (setI > -1) {
	    set = query.substring (setI + 4); //start from end of SET
	    if (whereI > -1)   // trim extra clauses, if needed
		set = set.substring (0, set.indexOf ("WHERE"));
	    else if (orderI > -1) 
		set = set.substring (0, set.indexOf ("ORDER BY"));
	}else set = null;

	if (whereI > -1) {
	    where = query.substring (whereI + 6); // start from end of WHERE
	    if (orderI > -1)    // trim extra clauses, if needed
		where = where.substring (0, where.indexOf ("ORDER BY"));
	}else where = null;

	if (orderI > -1) {
	    orderBy = query.substring (orderI + 9); // start from end of BY
	    // nothing to trim
	}else orderBy = null;

    }

    // mutator methods
    // for all of these, you can "reset" the clause by passing a null parameter
    // otherwise, it adds the parameter to the clause, with appropriate char 
    // in between

    public void addToSelect (String column) {
	if (column == null) { select = null; return; }
	if (select == null) select = ("" + column);
	else select += (", " + column);
    }

    public void addToDelete () {
	//delete takes no args, so just make sure that toString works:
	delete = "";
    }

    public void addToFrom (String table) {
	if (table == null) { from = null; return; }
	if (from == null) from = ("" + table);
	else from += (", " + table);
    }

    public void addToUpdate (String  table) {
	if (table == null) { update = null; return; }
	if (update == null) update = ("" + table);
	else update += (", " + table);
    }

    public void addToSet (String column) {
	//parameter should be 'columnName=expression'
	if (column == null) { set = null; return; }
	if (set == null) set = ("" + column);
	else set += (" AND " + column);
    }

    public void addToWhere (String column, String value, int type) {
	switch (type) {
	case NORMAL:
	    if (column == null) { where = null; return; }
	    if (where == null) where = ("" + column + "='" + value + "'"); 
	    else where += (" AND " + column + "='" + value + "'"); break;
	case IN:
	    //column == null has a different meaning here -- it doesn't clear
	    if (column != null) 
		if (where == null) where = ("" +column + " IN ('"+value +"')");
		else where += (" AND " + column + " IN ('" + value + "')");
	    else{
		if (where != null) {
		    where = where.substring (0, where.length() - 1); //trim ')'
		    where  += (", '" + value + "')");
		}
	    } break;
	case LIKE:
	    if (column == null) { where = null; return; }
	    if (where == null) where = ("" + column + " LIKE '" + value + "'");
	    else where += (" AND " + column + " LIKE '" + value + "'");
	}
    }

    public void addToOrderBy (String column) {
	if (column == null) { orderBy = null; return; }
	if (orderBy == null) orderBy = ("" + column);
	else orderBy += (", " + column);
    }

    public String toString () {
	String result = "";
	if (select != null) result += (" SELECT " + select);
	if (delete != null) result += (" DELETE " + delete);
	if (from != null) result += (" FROM " + from);
	if (update != null) result += (" UPDATE " + update);	
	if (set != null) result += (" SET " + set);
	if (where != null) result += (" WHERE " + where);
	if (orderBy != null) result += (" ORDER BY " + orderBy);
	return result.trim();
    }

}
