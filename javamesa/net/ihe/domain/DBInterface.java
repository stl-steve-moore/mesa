package net.ihe.domain;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.Set;
import java.util.Vector;

                                                                                
public class DBInterface
{
  protected Connection mDBConnection;

  public DBInterface()throws ClassNotFoundException, SQLException
  {
    initDBConnections();
  }

  public DBInterface (Connection con){
	  this.mDBConnection = con;
  }
  
  public DBInterface (String dbName, String login, String password) throws ClassNotFoundException, SQLException
  {
    initDBConnections(dbName, login, password);
  }

  protected void finalize() throws Throwable 
  {
    try 
    {
        System.out.println ("\n**************** IN FINALIZE ******************" + getClass() + "\n");
        if (mDBConnection != null)
          mDBConnection.close();
    } 
    finally 
    {
        super.finalize();
    }
}

  protected void initDBConnections () throws ClassNotFoundException, SQLException{
    this.initDBConnections("imgmgr", "postgres", "p0stgres");
  }
 
  protected void initDBConnections (String dbName, String login, String password) throws ClassNotFoundException, SQLException{
    try
    {
      Class.forName("org.postgresql.Driver");
    }
    catch (ClassNotFoundException c)
    {
      System.out.println ("Could not load Postgresql Driver " + c);
      mDBConnection = null;
      throw c;
    }
                                                                                      
    try
    {
      if (mDBConnection == null) 
        mDBConnection=DriverManager.getConnection("jdbc:postgresql://10.252.175.2:5432/"+ dbName,
                                                 login, password);
    }
    catch (SQLException s)    //No driver available SQLException
    {
      System.out.println ("Could not make connection to Database. Driver not "
                          + "available.  Make sure that the Database driver is "
                          + "included in the java classpath." + s.getMessage());
      s.printStackTrace();
      mDBConnection = null;
      throw s;
    }
  }

  public void destroy ()
  {
    //Clean up
    try
    {
      if (mDBConnection != null)
        mDBConnection.close();
    }
    catch (SQLException ignored)
    {
    }
  }

  public Vector selectFromDB(DomainObject o, String whereClause) throws SQLException{
    String query = "SELECT ";
    Set s = o.getKeys();
    Iterator it = s.iterator(); 
    while (it.hasNext()) {
      String k = (String)it.next();
      query += k;
      if (it.hasNext()) {
	query += ",";
      }
    }
    query += " from " + o.tableName() + " " + whereClause + ";";

    System.out.println(query);
 
    ResultSet rs = null;
    Vector v = new Vector(1,1);
    try {
      Statement stmt = mDBConnection.createStatement();
      stmt.execute(query);
      rs = stmt.getResultSet();
      while (rs.next()) {
	int idx = 1;
	Iterator it1 = s.iterator();
	DomainObject dbRecord = new DomainObject(o.tableName());
	while (it1.hasNext()) {
	  String k = (String)it1.next();
	  String val = rs.getString(idx);
	  System.out.println(val);
	  dbRecord.put(k, val);
	  idx += 1;
	}
	v.addElement(dbRecord);
      }
      rs.close();

       //stmt.close();
     }
     catch (SQLException se)
     {
       se.printStackTrace();
       throw se;
     }

     return v;
  }
}
