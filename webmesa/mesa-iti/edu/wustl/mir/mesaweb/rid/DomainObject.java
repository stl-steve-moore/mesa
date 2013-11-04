package edu.wustl.mir.mesaweb.rid;

import java.io.*;                       
import java.util.*;
import java.sql.*;

public class DomainObject {

  private java.util.HashMap mHashMap;

  public DomainObject() {
    mHashMap = new java.util.HashMap();
  }

  public int put(String key, String value) {
    mHashMap.put(key, value);
    return 0;
  }

  public String get(String key) {
    return (String)mHashMap.get(key);
  }
}
