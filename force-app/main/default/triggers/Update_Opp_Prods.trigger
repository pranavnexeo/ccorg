trigger Update_Opp_Prods on Opportunity (after update) 
{


/*Start enhancement*/        
//Enhancement to send email to ADE tech rep and Opp Plastics CAM when an Opportunity is closed.
//Data stored in a custom setting.
//Author-Rajeev

Set<Id> oppIds = new Set<Id>();

//Initialize single email
List<Messaging.SingleEmailMessage> theEmails = new List<Messaging.SingleEmailMessage>();

    for(Opportunity o : trigger.new){
            oppIds.add(o.Id);
    }

   Map<String,Opp_Plastics_CAM__c> emailMap = Opp_Plastics_CAM__c.getall();
   
    //Create emails based on Opportunity
    for(Opportunity op : [Select Id,Name,StageName,Plastics_CAM__c,Corporate_Bid__c,RecordType.Name,ADE_Technical_Representative__c,
                                    Account.Name from Opportunity where Id In :oppIds]){
     
     if(op.StageName == trigger.oldMap.get(op.Id).StageName)
      continue;                    
      
      if(op.StageName == 'Closed - Won' || op.StageName == 'Closed - Lost'){
        if(op.RecordType.Name == 'Distribution Plastics'){
        Set<String> toAddresses = new Set<String>();
        List<String> toAddressesList = new List<String>();
        String fullRecordURL = URL.getSalesforceBaseUrl().toExternalForm() + '/' + op.Id;
        String message ='Hi,' +'<Br/><Br/>'+ 'This is to inform you that an Opportunity - ' + '<b>'+op.Name+'</b>' + ' has been moved to Stage - '+ '<b>'+op.StageName+'</b>' +'.' + 
                        '<Br/><Br/>'+'Click on the following link to review the Opportunity record. '+'<Br/>'+'<a href='+fullRecordURL+'>'+fullRecordURL+'</a>'+'<Br/><Br/>'+'Regards'+'<Br/>'+'Nexeo Support';
        String subjectline = 'Opportunity ' + Op.Name + ' related to Account ' + op.Account.Name + ' has been moved to Stage - '+ op.StageName;
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        if(op.Corporate_Bid__c == 'Yes' && emailMap.containsKey(op.Plastics_CAM__c) && op.Plastics_CAM__c != null)
        toAddresses.add(emailMap.get(op.Plastics_CAM__c).Email__c);
        
        if(emailMap.containsKey(op.ADE_Technical_Representative__c) && op.ADE_Technical_Representative__c != null)
        toAddresses.add(emailMap.get(op.ADE_Technical_Representative__c).Email__c);
        
        toAddressesList.addAll(toAddresses);
        if(toAddressesList != null && toAddressesList.size()>0){
        mail.setToAddresses(toAddressesList);
        mail.setSubject(subjectline);
        mail.setHtmlBody(message);
        theEmails.add(mail);
      }
     }
    }
   }
    
   if(theEmails.size()>0 && checkRecursive.runOnce())
       Messaging.sendEmail(theEmails);
    
    
    /*----**End of enhancement**-----*/
    
    
    
    //Getting RecordTypeId for Aqualon Opportunity EMEA, NA & Latin America       
    Map<String, Schema.RecordTypeInfo> rtMapByNameOpp = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
    Id aquaEMEAOppRecordTypeId = rtMapByNameOpp.get('Aqualon Opportunity - EMEA').getRecordTypeId();
    Id aquaNAOppRecordTypeId = rtMapByNameOpp.get('Aqualon Opportunity - NA').getRecordTypeId();
    Id aquaLAoppRecordTypeId = rtMapByNameOpp.get('Aqualon Opportunity - Latin Amer').getRecordTypeId();
    
    //List of Opportunity Products for update       
    List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
    
    //Iterating thru all the Opportunities updated    
    for (List<Opportunity> opps : [Select Id, RecordTypeId, (Select Id from OpportunityLineItems) from Opportunity where Id IN : Trigger.newMap.keySet()])
    {
        for(Integer i=0; i<opps.size(); i++)
        {
            //Only Opportunities with Record Types - Aqualon NA, EMEA & Latin America
            if (opps[i].RecordTypeId == aquaEMEAOppRecordTypeId || opps[i].RecordTypeId == aquaNAOppRecordTypeId || opps[i].RecordTypeId == aquaLAoppRecordTypeId)
            {
                //Only Opportunities with Record Type update
                if (Trigger.newMap.get(opps[i].Id).RecordTypeId != Trigger.oldMap.get(opps[i].Id).RecordTypeId)
                {
                    //Iterating thru all Opportunity Products for an Opportunity and adding it to a list for update
                    for(Integer j=0; j<opps[i].OpportunityLineItems.size(); j++)
                    olis.add(opps[i].OpportunityLineItems[j]);
                    
                    //Checking the limit for list of 1000 elements and updating the list and clearing it
                    if(olis.size()>1000 || i == opps.size()-1)
                    {
                        update olis;
                        olis.clear();
                    }
                }
            }
        }
    }
}