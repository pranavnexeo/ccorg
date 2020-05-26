global class RoleData_Batch implements Database.Batchable<SObject> {


global String q;

// Class Constructor - set query string
global RoleData_Batch() {
q = 'SELECT id, ownerid, owner.userroleid, owner.userrole.name, SAP_Sales_Org__c, SAP_DivisionCode__c, SAP_Industry_Key__c,  HQ_Sales_Office__c, SAP_SalesGroup__c, SAP_Sold_To_Account_Owner__c';
q += ' from Account where Recordtype.name = \'Distribution Customer\'';

}
// "Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {

List<Role_Data__c> data = [select id from Role_Data__c where type__C = 'Account'];
if(data.size() > 0)
delete data;

return Database.getQueryLocator(q);
}

// "Execute" is what is being run as a separate process per batch
global void execute(Database.BatchableContext bcMain, List<Account>lstBatchRecords) {
  
  List<String> fields = new List<String>{'SAP_Sales_Org__c', 'SAP_DivisionCode__c', 'SAP_Industry_Key__c',  'HQ_Sales_Office__c', 'SAP_SalesGroup__c', 'SAP_Sold_To_Account_Owner__c'};
  List<Role_Data__c> toUpsert = new List<Role_Data__c>();
  Map<Id, UserRole> Role_Map = new Map<Id, UserRole>([select id, name, parentroleid from UserRole]);
  Map<string, Map<String, Role_Data__c>> Role_Data_Map = new Map<string, Map<String, Role_Data__c>>();
  for(Role_Data__c rd:[select id, role_id__c, role_name__c, type__c, API_Field_Name__c, Data__c from Role_Data__C where type__c = 'Account'])
  {
    Map<String, Role_Data__c> amap = new Map<String, Role_Data__c>();
    if(Role_Data_Map.containskey(rd.role_id__c))
      amap = Role_Data_map.get(rd.role_id__c);

    if(!amap.containskey(rd.API_Field_Name__c))
      amap.put(rd.API_Field_Name__c, rd);
    
      
    Role_Data_Map.put(rd.role_id__c, amap);  
  }
  


  for(Account a: lstBatchRecords)
  {  
     String roleid = a.owner.userroleid;
     do {
     for(string s:fields)
     {
      system.debug('a: ' + a.get(s));
      if(a.get(s) != null )
      {
       if(Role_Data_map.containskey(roleid))
       {
         if(Role_Data_Map.get(roleid).containskey(s))
         {   
            if(Role_Data_Map.get(roleid).get(s).data__c != null && Role_Data_Map.get(roleid).get(s).data__c != '')
            {         
              if(!Role_Data_Map.get(roleid).get(s).data__c.contains(string.valueof(a.get(s))))
                 Role_Data_Map.get(roleid).get(s).data__c += '; ' + a.get(s);   
            }
            else
              Role_Data_Map.get(roleid).get(s).data__c = string.valueof(a.get(s));
         }
         else
         {
            if(roleid != '' && roleid != null)
            {
            Role_Data__c rd = new Role_Data__c();
            rd.role_id__c = roleid;
            rd.role_name__c = role_map.get(roleid).name;
            rd.type__c = 'Account';
            rd.data__c = string.valueof(a.get(s));
            rd.api_field_name__c = s;
            Role_Data_Map.get(roleid).put(s, rd);
            }
         }
       } 
       else
       {
          if(roleid != null && roleid != '')
          {
          Role_Data__c rd = new Role_Data__c();
          rd.role_id__c = roleid;
          rd.role_name__c = role_map.get(roleid).name;
          rd.type__c = 'Account';
          rd.data__c = string.valueof(a.get(s));
          rd.api_field_name__c = s;
          Map<String, Role_Data__c> datamap = new Map<String, Role_Data__c>();
          datamap.put(s, rd);
          Role_Data_Map.put(roleid, datamap);
          }
       }
      }
     }
     if(roleid != null && roleid != '')
       roleid = Role_Map.get(roleid).parentroleid;
 
   } while (roleid != 'NEXEO SOLUTIONS ORG' && roleid != '' && roleid != null);
  }
    system.debug(Role_Data_Map);
    for(Map<String, Role_Data__c> udmap:Role_Data_Map.values())
      toupsert.addall(udmap.values());

    if(ToUpsert.size() > 0)
      upsert ToUpsert;

}
// Finish the Batch Job
global void finish(Database.BatchableContext bcMain) {
// Optional - you can send an email to an admin with results
}
}