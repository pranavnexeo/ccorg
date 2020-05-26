global class TerritoryRoleData_Batch implements Database.Batchable<SObject> {


global String q;

// Class Constructor - set query string
global TerritoryRoleData_Batch () {
q = 'Select id, YS_partner__r.User__r.userroleid, ZS_Partner__r.User__r.userroleid,'; // SAP_Territory Fields
  q+= 'SAP_Sales_Dog__r.YD_Partner__r.User__r.userroleid, SAP_Sales_Dog__r.YO_Partner__r.User__r.userroleid, SAP_Sales_Dog__r.YV_Partner__r.User__r.userroleid,'; // SAP_Sales_DOG__c fields
  q+= 'SAP_Sales_District_Desc__c, SAP_Sales_Office_Desc__c, SAP_Sales_Group_Desc__c '; // SAP_Sales_DOG__c fields
  q +=' from SAP_Territory__c'; // where id=\'a5yc00000004GOD\'';
}
// "Start" runs when the class in instanciated
global Database.QueryLocator start(Database.BatchableContext bcMain) {

List<Role_Data__c> data = [select id from Role_Data__c where type__C = 'Account'];
if(data.size() > 0)
delete data;

return Database.getQueryLocator(q);
}

// "Execute" is what is being run as a separate process per batch
global void execute(Database.BatchableContext bcMain, List<SAP_Territory__c> lstBatchRecords) {

 //List<String> fields = new List<String>{'SAP_Sales_Org__c', 'SAP_DivisionCode__c', 'SAP_Industry_Key__c',  'HQ_Sales_Office__c', 'SAP_SalesGroup__c', 'SAP_Sold_To_Account_Owner__c'};
 List<String> terrFields = new List<String>{'id','SAP_Sales_District_Desc__c', 'SAP_Sales_Group_Desc__c', 'SAP_Sales_Office_Desc__c'};
 List<String> acctFields = new List<String>{'SAP_Sales_Org__c', 'SAP_DivisionCode__c', 'SAP_Industry_Key__c','SAP_DistChannel__c'};
 
  List<Role_Data__c> toUpsert = new List<Role_Data__c>();
  Map<Id, UserRole> Role_Map = new Map<Id, UserRole>([select id, name, parentroleid from UserRole]);
  Map<string, Map<String, Role_Data__c>> Role_Data_Map = new Map<string, Map<String, Role_Data__c>>();
  for(Role_Data__c rd:[select id, role_id__c, role_name__c, type__c, API_Field_Name__c, Data__c from Role_Data__c where type__c = 'Account'])
  {
    Map<String, Role_Data__c> amap = new Map<String, Role_Data__c>();
    if(Role_Data_Map.containskey(rd.role_id__c))
      amap = Role_Data_map.get(rd.role_id__c);

    if(!amap.containskey(rd.API_Field_Name__c))
      amap.put(rd.API_Field_Name__c, rd);
    
      
    Role_Data_Map.put(rd.role_id__c, amap);  
  }
  
  
//Map<id,List<string>> TerritoryUserRoleMap = new Map<id, List<String>>();

Map<Id, List<Account>> terracctmap = new map<Id, List<Account>>();

for(SAP_Territory__c t: lstBatchRecords){
  terracctmap.put(t.id, new List<Account>());
}

for(Account a:[select id, YZ_Partner__c, YY_Partner__c, YI_Partner__c, SAP_Sales_Org__c, SAP_DistChannel__c, SAP_DivisionCode__c, SAP_Industry_Key__c from Account where
                 YZ_Partner__c IN :terracctmap.keyset() or
                 YY_Partner__c IN :terracctmap.keyset() or 
                 YI_Partner__c IN :terracctmap.keyset()]){
       if(a.YZ_Partner__c != null && terracctmap.containskey(a.YZ_Partner__c))
       terracctmap.get(a.YZ_Partner__c).add(a);  
       if(a.YY_Partner__c != null && terracctmap.containskey(a.YY_Partner__c))
       terracctmap.get(a.YY_Partner__c).add(a);   
       if(a.YI_Partner__c != null && terracctmap.containskey(a.YI_Partner__c))
       terracctmap.get(a.YI_Partner__c).add(a);                  
   }

List<String> UserRoles = new List<String>();
for(SAP_Territory__c sapTerr :lstBatchRecords)
{
    UserRoles.add(sapTerr.YS_partner__r.User__r.userroleid);
    UserRoles.add(sapTerr.ZS_partner__r.User__r.userroleid);
    UserRoles.add(sapTerr.SAP_Sales_Dog__r.YD_Partner__r.User__r.userroleid);
    UserRoles.add(sapTerr.SAP_Sales_Dog__r.YO_Partner__r.User__r.userroleid);
    UserRoles.add(sapTerr.SAP_Sales_Dog__r.YV_Partner__r.User__r.userroleid);
    //TerritoryUserRoleMap.put(sapTerr.id,UserRoles);

    List<Account> terrAccounts = terracctmap.get(sapterr.id);
    //List<Account> terrYZ_Accounts = new List<Account>(); //YZ Accounts List
    //List<Account> terrYI_Accounts = new List<Account>(); //YI Accounts List
    //List<Account> terrYY_Accounts = new List<Account>(); //YY Accounts List
    //terrYZ_Accounts = sapTerr.Accounts_YZ__r;
    //terrYI_Accounts = sapTerr.Accounts_YI__r;
    //terrYY_Accounts = sapTerr.Accounts_YY__r;
    
    //Add YZ, YI, YY Accounts in Mater Accounts List
    //terrAccounts.addall(terrYZ_Accounts); 
    //terrAccounts.addall(terrYI_Accounts);
    //terrAccounts.addall(terrYY_Accounts);
    system.debug('terrAccounts size:'+terrAccounts.size());
    
    for(integer i=0; i< UserRoles.size(); i++)
    {
    String roleid = UserRoles.get(i);
     
     for(string s: terrFields)
     {
      system.debug('sapTerr: ' + s + '::' + sapTerr.get(s));
      if(sapTerr.get(s) != null )
      {
       if(Role_Data_map.containskey(roleid)) //if Role is present in the Role_Data table
       {
         if(Role_Data_Map.get(roleid).containskey(s)) // if api field value is present in table
         {   
            if(Role_Data_Map.get(roleid).get(s).data__c != null && Role_Data_Map.get(roleid).get(s).data__c != '')
            {         
              if(!Role_Data_Map.get(roleid).get(s).data__c.contains(string.valueof(sapTerr.get(s))))
                 Role_Data_Map.get(roleid).get(s).data__c += '; ' + sapTerr.get(s);   
            }
            else
              Role_Data_Map.get(roleid).get(s).data__c = string.valueof(sapTerr.get(s));
         }
         else
         {
            if(roleid != '' && roleid != null)
            {
            Role_Data__c rd = new Role_Data__c();
            rd.role_id__c = roleid;
            rd.role_name__c = role_map.get(roleid).name;
            rd.type__c = 'Account';
            rd.data__c = string.valueof(sapTerr.get(s));
            rd.api_field_name__c = s;
            Role_Data_Map.get(roleid).put(s, rd);
            }
         }
       } 
       else
       {
          if(roleid != null && roleid != '')
          {
          Role_Data__c rd = new Role_Data__c ();
          rd.role_id__c = roleid;
          rd.role_name__c = role_map.get(roleid).name;
          rd.type__c = 'Account';
          rd.data__c = string.valueof(sapTerr.get(s));
          rd.api_field_name__c = s;
          Map<String, Role_Data__c> datamap = new Map<String, Role_Data__c>();
          datamap.put(s, rd);
          Role_Data_Map.put(roleid, datamap);
          }
       }
      } //end of SAP Territory loop
     } //end of SAP Territory fields
     
     for(String s: acctFields)
     {
     for(Account a :terrAccounts)
     {
     system.debug('terrAccount: ' + s + '::' + a.get(s));
      if(a.get(s) != null )
      {
       if(Role_Data_map.containskey(roleid)) //if Role is present in the Role_Data table
       {
         if(Role_Data_Map.get(roleid).containskey(s)) // if api field value is present in table
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
     } //end of Accounts loop
    } //end of Accounts Fields
     
  }//end of UserRoles list of SAP Territory record
} //end of SAP Territory record 

 system.debug('Role_Data_Map: '+Role_Data_Map);
    for(Map<String, Role_Data__c> udmap:Role_Data_Map.values())
      toupsert.addall(udmap.values());
      
 system.debug('toupsert:'+toupsert.size());
 
    if(ToUpsert.size() > 0)
      upsert ToUpsert;
  
}


// Finish the Batch Job
global void finish(Database.BatchableContext bcMain) {
// Optional - you can send an email to an admin with results
}
}