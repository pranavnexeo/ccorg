/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         09/06/2016
*    Author:              Sneha Likhar
*   Last Modified:        09/06/2016
*   Last Modified By:     Sneha Likhar
*
*   Short Description:  To assign queue member to assigned user lookup fiels of nexcare record
*   **********************************************************************************************************************/

public with sharing class neXcareController{

        public List<SelectOption> QueueList{get; set;}
        public String selecteduser{get;set;}
        public boolean displayPopup{get; set;}
        public id rid{get; set;}
        Public List<User> usrlist = new List<User>();
        Set<Id> idslist = new Set<id>();
        public id ownrid{get; set;}
        
        public neXcareController(ApexPages.StandardController controller){
        rid = apexpages.currentpage().getparameters().get('id');
        ownrid = apexpages.currentpage().getparameters().get('ownerid');
        
            QueueList = new List<SelectOption>();
            QueueList.add(new SelectOption('','--None--'));
            
            List<GroupMember> queueUsers=[Select UserOrGroupId FROM GroupMember WHERE GroupId =:ownrid];
      
            for(GroupMember gm: queueUsers)
            {
                idslist.add(gm.UserOrGroupId);
               
            }
            
         if(idslist.size()>0)              
          usrlist = [select id, name from User where id =:idslist];
            for(user u:usrlist){
              QueueList.add(new selectoption(u.id,u.Name));
            } 
        }
       
    
    
  public PageReference customSave(){
      PageReference pageref = null;
      nexcare__c nx = [select id, Assigned_User__c from nexcare__c where id =:rid];
      nx.Assigned_User__c = selecteduser;
      update nx;
      return null;
  
  }

}