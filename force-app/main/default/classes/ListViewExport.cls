public class ListViewExport{

private ListViewResult result;
private List<List<sObject>> nestedrecords;
public List<sObject> records{get; set;}
public string Inst{get; set;}
public string sobjtype{get; set;}
public string View_Id{get; set;}
 
public ListViewResult getresult(){
  if(result == null){ calltoolingapi(); }
  return result;
}

public List<List<sObject>> getnestedrecords(){
 if(result == null){ calltoolingapi(); }
 if(nestedrecords == null){ querydata(); }
 return nestedrecords;
}

@TestVisible private void querydata(){
     records = database.query(result.query + ' limit 10000');
     nestedrecords = new List<List<sObject>>{new List<sobject>()};
     if(records.size() <= 1000)
       nestedrecords.get(0).addall(records);
     else{     
         for(integer i=0; i<records.size(); i++){  
            if(Math.mod(i+1,1000) == 0)
              nestedrecords.add(new List<sObject>{records.get(i)});
            else
              nestedrecords.get(nestedrecords.size()-1).add(records.get(i));
         }
     }
}

@TestVisible private void calltoolingapi(){

  string endpoint = 'https://' + inst + '.salesforce.com/services/data/v34.0/sobjects/' + sobjtype + '/listviews/' + view_id + '/describe';
  records = new List<sObject>();
  
  Http http = new Http();
  HttpRequest hreq = new HttpRequest();
  hreq.setHeader('Content-Type', 'application/xml');  
  hreq.settimeout(60000);
  hreq.setHeader('Authorization', 'OAuth ' + userinfo.getSessionId());
  hreq.setEndpoint(endpoint);
  hreq.setMethod('GET');
        
  if(Test.isRunningTest() == false)
  {
     httpResponse res = http.send(hreq); 
     result = (ListViewResult)JSON.deserialize(res.getBody(), ListViewExport.ListViewResult.class);
     
  }

}

public class ListViewResult{
    public string query{get; set;}
    public List<ListViewColumn> columns{get; set;}
  
    public ListViewResult(){
      columns = new List<ListViewColumn>();
    }
}

public class ListViewColumn{
    public string ascendingLabel{get; set;}
    public string descendingLabel{get; set;}
    public string fieldNameOrPath{get; set;}
    public boolean hidden{get; set;}
    public string label{get; set;}
    public string selectListItem{get; set;}
    public string sortDirection{get; set;}
    public integer sortIndex{get; set;}
    public boolean sortable{get; set;}
    public string type{get; set;}
 }
   
}