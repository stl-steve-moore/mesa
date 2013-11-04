package net.ihe.domain;
import net.ihe.domain.DomainObject;
import net.ihe.domain.DBInterface;

import java.util.*;

public class Study extends DomainObject
{
  public Study() 
  {
    super();
    this.tableName("study");
    this.put("patid", "");
    this.put("stuinsuid", "");
  }

  public Study(DomainObject o) 
  {
    super(o);
  }

  public String getPatientID ()
  {
    return (String)mHashMap.get("patid");
  }

  public String getStudyInstanceUID()
  {
    return (String)mHashMap.get("stuinsuid");
  }

  public static void main(String[] args) {
    System.out.println(args[0]);
    System.out.println(args[1]);
    System.out.println(args[2]);

    DBInterface d = new DBInterface(args[0], args[1], args[2]);
    Study s = new Study();
    Vector v = d.selectFromDB(s, "");
    Iterator it = v.iterator();
    while (it.hasNext()) {
      DomainObject o = (DomainObject)it.next();
      Study dbRecord = new Study(o);
      System.out.println("Study: " + dbRecord.getStudyInstanceUID() );
    }
  }

}
