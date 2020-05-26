public  with Sharing Class Project_Resource_Controller1{

public static ART_Project__c project{get; set;}
public static String projectId{get; set;}
public Project_Resource_Controller1(ApexPages.standardcontroller sc){
  project = (ART_Project__c)sc.getrecord();
  projectId = project.Id;
}

@RemoteAction
Public static void upsertResources(String projectId1,String resGroup, List<Double> values){
 
    List<Project_Resource__c> toUpsert = new List<Project_Resource__c>();
    List<ART_Project__c> projs = [select id, Resourcing_Start_Date__c, Resourcing_End_Date__c, CreatedDate from ART_Project__c where id = :projectId1 limit 1];
    if(projs.size()>0){
        List<Date> weekFridays = new List<Date>();
        
        Date startdate = projs.get(0).Resourcing_Start_Date__c;
        while(DateTime.newInstance(startdate, Time.newInstance(0, 0, 0, 0)).format('EEE') != 'Fri'){
            startdate = startdate.adddays(1);
        }
        system.debug('startdate : '+startdate);
        for(integer i=0;i<values.size();i++){
            Date weekFriday ;
            weekFriday = startdate.adddays(i*7);
            weekFridays.add(weekFriday);
        }
        system.debug('weekFridays: '+weekFridays);
        List<Project_Resource__c> pr = [select id, project__c, Hours__c, Week_Friday__c, Resource_Group__c from Project_Resource__c where Project__c = :projectId1 and Resource_Group__c = :resGroup and Week_Friday__c in :weekFridays order by Week_Friday__c asc];
        for(integer i=0;i<pr.size();i++){
            for(integer j=0;j<weekFridays.size();j++){
                if(pr[i].Week_Friday__c == weekFridays[j]){
                    pr[i].Hours__c = values[j];
                    toUpsert.add(pr[i]);
                    weekFridays.remove(j);
                    values.remove(j);
                    break;
                }
            }
        }
        
        for(Integer i=0;i<weekFridays.size();i++){
            if(values[i] > 0)
                toUpsert.add(new Project_Resource__c(project__c = projectId1 , Hours__c = values[i],Week_Friday__c = weekFridays[i], Resource_Group__c = resGroup )); 
        }
        if(toUpsert.size()>0)
            upsert toUpsert;
    }

}


Public static String getResources(){

List<List<String>> toreturn = new List<List<String>>();
toreturn.add(new List<String>{'---'});
List<Schema.PicklistEntry> ples = Project_Resource__c.Resource_Group__c.getDescribe().getPicklistValues();
List<String> temp = new list<String>();
for(Schema.PicklistEntry ple:ples)
  temp.add(ple.getValue());
temp.sort();
for(string s:temp)
  toreturn.add(new List<String>{s});

List<ART_Project__c> projs = [select id, Resourcing_Start_Date__c, Resourcing_End_Date__c, CreatedDate from ART_Project__c where id = :projectId limit 1];
List<Project_Resource__c> projRes = [Select Id,Week_Friday__c from Project_Resource__c where Project__c =:projs[0].Id];
Date startdate = system.today();
Date tempstartdate;
if(projs.size() > 0)
{
  startdate = Date.valueof(projs.get(0).createddate);
  if(projs.get(0).Resourcing_Start_Date__c != null)
   startdate = projs.get(0).Resourcing_Start_Date__c;
  
  Date EndDate = startdate + 14;
  if(projs.get(0).Resourcing_End_Date__c != null)
    enddate = Projs.get(0).Resourcing_End_Date__c;
    
  tempstartdate = startdate;
  
  while(DateTime.newInstance(tempstartdate, Time.newInstance(0, 0, 0, 0)).format('EEE') != 'Fri'){
    tempstartdate = tempstartdate.adddays(1);
  }
  
for(Project_Resource__c prjres : projRes){
    if(prjres.Week_Friday__c < tempstartdate){
        tempstartdate = prjres.Week_Friday__c;
    }    
}
  
  Date tempenddate = enddate;
  
  while(DateTime.newInstance(tempenddate, Time.newInstance(0, 0, 0, 0)).format('EEE') != 'Fri'){
    tempenddate= tempenddate.adddays(1);
  }
  
for(Project_Resource__c prjres : projRes){
    if(prjres.Week_Friday__c > tempenddate){
        tempenddate = prjres.Week_Friday__c;
    }    
}  
  system.debug(tempstartdate.daysBetween(tempenddate));
  Integer columns = Integer.valueof(Math.Ceil((tempstartdate.daysBetween(tempenddate)) / 7)+1);
  system.debug('columns: ' + columns);
  for(Integer i=1; i<= columns; i++)
  {  system.debug('columns ' + i);
     ToReturn.get(0).add(String.valueof(i));
     for(integer j=1; j<toreturn.size(); j++)
       toreturn.get(j).add('0');
  }

  for(Project_Resource__c pr:[select id, project__c, Hours__c, Week_Friday__c, Resource_Group__c from Project_Resource__c where Project__c = :projectId])
    for(integer j=1; j<toreturn.size(); j++)
    {
      List<String> rows = toreturn.get(j);
      
      if(rows.get(0) == pr.resource_group__c)
      {  for(integer i=1; i<rows.size(); i++)
         if(Integer.valueof(Math.ceil(startdate.daysbetween(pr.Week_Friday__c) / 7)) < i && 
            Integer.valueof(Math.ceil(startdate.daysbetween(pr.Week_Friday__c) / 7)) >= (i-1))
         {
           if(rows.get(i) != '' )
           {
             if(i<(rows.size()-1)){
                 integer val = Integer.valueof(rows.remove(i));
                 rows.add(i, String.valueof(val + pr.Hours__c));
             }else{
                 integer val = Integer.valueof(rows.remove(i));
                 rows.add(String.valueof(pr.Hours__c));
             }  
           }
           else
             rows.add(i, String.valueof(pr.Hours__c));
         }
      }
     }

}

string thetable = '<table id="thetable"><thead><th>Resource Groups</th><th>Edit</th>';

for(integer i=1; i<toreturn.get(0).size(); i++){
  thetable += '<th>' + tempstartdate.adddays((Integer.valueof(toreturn.get(0).get(i))-1) * 7).format() + '</th>';
  
}

thetable += '<th>Total</th>';
thetable += '</td></thead><tbody>';


for(integer i=1; i<toreturn.size(); i++)
{  
   Double total = 0.00;
   List<String> rows1 = toreturn.get(i);
   system.debug('rows1.get(0) is '+rows1.get(0));
   thetable += '<tr id =' +rows1.get(0)+ '>';
   thetable += '<td class = "editable" >' + rows1.get(0) + '</td>';
   thetable += '<td><a class="edit" href="">Edit</a></td>';
   for(integer j=1;j<toreturn.get(i).size();j++){
       
       thetable += '<td class = "editable" >' +toreturn.get(i).get(j) + '</td>';
       total = total+Double.valueof(toreturn.get(i).get(j));
       
   }
   
   thetable += '<td>'+total+'</td>';
   
   thetable += '</tr>';
}

thetable += '</tbody></table>';
return thetable;

}
}