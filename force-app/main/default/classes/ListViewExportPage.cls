public class ListViewExportPage{

  public string ViewId{get; set;}
  
  public ListViewExportPage(apexpages.standardsetcontroller ssc){ 
     viewid = ssc.getFilterId(); 
  }
}