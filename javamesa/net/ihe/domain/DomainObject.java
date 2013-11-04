package net.ihe.domain;

import java.util.*;

public class DomainObject
{
  protected String mTableName = null;
  protected HashMap mHashMap = null;

  public DomainObject() 
  {
    mHashMap = new HashMap();
  }

  public DomainObject(String tableName) 
  {
    mHashMap = new HashMap();
    mTableName = new String(tableName);
  }

  public DomainObject(DomainObject o) 
  {
    mHashMap = new HashMap();
    mHashMap.putAll(o.mHashMap);
    mTableName = o.tableName();
  }

  public int put (String key, String value)
  {
    mHashMap.put (key, value);
    return 0;
  }

  public String get (String key)
  {
    return (String)mHashMap.get(key);
  }

  public boolean containsKey (String key)
  {
    return mHashMap.containsKey(key);
  }

  public Set getKeys ()
  {
    return mHashMap.keySet();
  }

  public void tableName(String tableName) {
    mTableName = new String(tableName);
  }

  public String tableName( ) {
    return mTableName;
  }
}
