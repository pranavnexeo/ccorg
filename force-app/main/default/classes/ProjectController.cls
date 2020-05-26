public class ProjectController{
public boolean makeRequired{get; set;}
public boolean showmessage{get; set;}
private final ART_Project__c proj;
public boolean makeEndRequired{get; set;}
public Map<String, String> OECustomSettings{get; set;} 

public ProjectController(ApexPages.StandardController controller){
     makerequired = false; 
     showmessage = false; 
     proj = (ART_Project__c)controller.getRecord();  
         // If workstream is being created from Project view we will have this parameter
     String parentProjectIdExpr = System.currentPageReference().getParameters().get('parentPId');

     if (String.isNotEmpty(parentProjectIdExpr)) {
         ART_Project__c parentProject = [SELECT Id,IT_Group__c FROM ART_Project__c WHERE Id =: parentProjectIdExpr];
         proj.Parent_Project__c = parentProject.Id;
         proj.IT_Group__c = parentProject.IT_Group__c;
     }
    
     // retrieve settings from OE Tool 
    OECustomSettings = new Map<String, String>();
    for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
        OECustomSettings.put(thisValue.Name, thisValue.Value__c);
    }
    
    if (String.isEmpty(proj.RecordTypeId)) {
        //find all  record types
        List<Schema.RecordTypeInfo> infos = Schema.SObjectType.ART_Project__c.RecordTypeInfos;
        Id defaultRecordTypeId;
        
        //check each one
        for (Schema.RecordTypeInfo info : infos) {
          if (info.DefaultRecordTypeMapping) {
            defaultRecordTypeId = info.RecordTypeId;
          }
		}
        System.debug(' defaultRecordTypeId ' + defaultRecordTypeId);
        proj.RecordTypeId = defaultRecordTypeId;
    }
}


 
 public void stagechanged(){
 
     if(proj.Start_Date__c != null){
         makeRequired=true;
     }else 
         makeRequired=false;
     
   
 }

 public void resourceStageChanged(){
    
    if(proj.Resourcing_Start_Date__c != null){
         makeEndRequired=true;
     }else 
         makeEndRequired=false;
    
 }
 
@RemoteAction
public static List<autocompletedata> autocomplete_name(string q){
  List <AutoCompleteData> autolist = new List <Autocompletedata>();
  string s = q + '%';
  for(ART_Project__c art:[select id, name from ART_Project__c where name LIKE :s order by name limit 15 ]){
    autolist.add(new autocompletedata(art.name,art.id));
    system.debug('values of autolist ' + autolist);
    }
  return autolist;
 }
}