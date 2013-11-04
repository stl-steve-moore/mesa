package net.ihe.domain;


public class SeriesTable extends DomainObject
{
  public SeriesTable() 
  {
    super();
    this.tableName("series");
    this.put("serinsuid", "");
    this.put("stuinsuid", "");
  }

  public SeriesTable(DomainObject o) 
  {
    super(o);
  }
  
  public String getSeriesInstanceUID(){
	  return (String)mHashMap.get("serinsuid");
  }
}