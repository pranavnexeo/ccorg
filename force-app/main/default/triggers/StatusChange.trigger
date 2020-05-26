/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         05/08/2016
*    Author:             Sneha Likhar
*   Short Description:  CAPA can only closed by Quality Team
*   **********************************************************************************************************************/

trigger StatusChange on CAPA__c (Before insert,Before update) {
boolean check;
Set<Id> queueIds = new Set<id>();
String queueName='NC Quality';
id queueGroupId= [Select Id from Group where type='Queue' and Name= :queueName].Id;

List<GroupMember> queueUsers=[Select UserOrGroupId FROM GroupMember WHERE GroupId =:queueGroupId];

for(GroupMember gm: queueUsers)
{
    queueIds.add(gm.UserOrGroupId);
    
}
system.debug('AAAAAAAAA' +queueIds);

string uid = userinfo.getUserId(); 


for(CAPA__c a : Trigger.new) {          
          
        if((!queueIds.contains(uid))&&((a.Status__c == 'Closed')||(trigger.isUpdate && trigger.oldmap.get(a.Id).Status__c == 'Closed')))
        a.addError('Sorry, You are not authorized to Close the CAPA !! OR you cannot re-opened Closed CAPA');
        
        if((trigger.isUpdate && a.Status__c == 'Assigned' && a.checkonce__c ==false))
           { 
                a.changed_owner__c = trigger.oldmap.get(a.Id).ownerid;
                a.changed_owner_user__c= trigger.oldmap.get(a.Id).Assigned_User__c;
                a.checkonce__c =true;
            }
        if(trigger.isInsert)
        {
        a.status__c = 'New';
        a.checkonce__c = false;
        a.changed_owner__c = '';
        a.Assigned_User__c = uid;
       
        }
        
}
 



}