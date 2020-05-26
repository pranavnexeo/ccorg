/* @@ The Trigger that populates the user field with the user that has the same user name as the SAP_Purchasing_Group__c email field. 
 Trigger will blanks out this user field if it does not find an active user for that email address.*/

trigger PopulateUserField on SAP_Purchasing_Group__c (before insert, before update) { //<-- Change to before trigger
    set<string> useremails= new set<string>();
    //Map<Id, String> SAPPurchIDEmail = new Map<Id, String>();  <-- Don't need this
    Map<String,Id> UserEmailId = new Map<String, Id>();
    
//Iterating through all Sap Purchasing Group Products inserted/updated   
    for(SAP_Purchasing_Group__c q: Trigger.new)
    {
        if(q.email__c!= null){
            useremails.add(q.email__c.toUpperCase());
            useremails.add(q.email__c.toUpperCase() + '.FULL');
            
        }
        //SAPPurchIDEmail.put(q.Id,q.email__c); <-- Don't need this
    }
    
//Fetching all active users which have same email as Sap Purchasing Group email field.
    list <user> userlist = [ Select id, email, isActive, username from User where email in: useremails and isactive = true];
    for(user u: userlist){
        UserEmailId.put(u.email.ToUpperCase(), u.Id);
    }
    
    system.debug(userlist);
    
//Comparing Sap Purchasing Group records with user records and populating user field on Sap Purchasing Group.
    //Use Trigger.new instead. --> List<SAP_Purchasing_Group__c > purchGrpRecords = [select Id, Email__c, User__c from SAP_Purchasing_Group__c where id in :SAPPurchIDEmail.keyset()];
    for(SAP_Purchasing_Group__c rec: trigger.new){
        string em = rec.email__c;
        if(em != null && em != ''){
          em = em.ToUpperCase();
        }
        if(UserEmailId.containskey(em))
            rec.User__c = UserEmailId.get(em);
        else if(UserEmailId.containskey(em + '.FULL'))
            rec.User__c = UserEmailId.get(em + '.FULL');
        else
            rec.User__c = null;    
    }
    
 //   Don't need the below
 //   if(checkRecursive.runonce())
 //       update purchGrpRecords ;
    
}