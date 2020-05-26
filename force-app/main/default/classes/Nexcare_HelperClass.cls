/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         09/07/2016
*    Author:              Sneha Likhar
*   Last Modified:        09/07/2016
*   Last Modified By:     Francisco Garcia	
*
*   Short Description:  To assign account's CSR as assigned to user and CSR's queue as owner
	Last Mod Descrip:	Modifications on the Bulkifying process.
************************************************************************************************************************/
public Without sharing class Nexcare_HelperClass{
    
    public static void NexcareMethod(list<NexCare__c> newlist){
    
    set<id> accId = new set<id>();
    List<id> UserId = new List<id>();
     boolean ac;
    list<account> AccountList = new List<Account>();
    list<GroupMember> QueueList = new List<GroupMember>();
    for(NexCare__c nc : newlist){
        accId.add(nc.Account_Name__c);        
    }
    
    accountList = [select id, ZC_Partner__c, ZC_Partner__r.User__c from account where id in : accId];
        Map<Id,boolean> accHasCSR=new Map<Id,boolean>();
    for(Account a: accountList){        
        if(a.ZC_Partner__r.User__c != null){
        	UserId.add(a.ZC_Partner__r.User__c);                	
            accHasCSR.put(a.Id, true);
        }
        else{
        	accHasCSR.put(a.Id, false);            
        }
    }
    System.debug('@@@@@'+UserId);
  
   list<GroupMember> QueueLst = [select GroupId, group.name from GroupMember where Group.Type='Queue' and UserOrGroupId in : UserId];
   list<user> ulist = [select id, name from user where id in :UserId];
   for(NexCare__c nc : newlist){
       if(accHasCSR.get(nc.Account_Name__c) == true){
       	if(QueueLst.size()>0){
       		nc.ownerid=QueueLst[0].GroupId;
       	}
       else{
       		nc.addError('Account CSR  ' + ulist[0].name +'  is not assign to any queue');
       }
       nc.Assigned_User__c=UserId[0];
       nc.IsCheckCSR__c=true;
       }
   }
    }
}