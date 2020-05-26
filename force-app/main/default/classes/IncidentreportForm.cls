public with sharing class IncidentreportForm{
Public boolean displayList {get;set;}
public ApexPages.StandardController controller{get;set;}
public IncidentreportForm(ApexPages.StandardController controller) {
           this.controller=controller;
}
public IncidentreportForm(){}
public PageReference getDisplayECC(){
        
        String SiteName=Apexpages.currentPage().getParameters().get('SiteValue'); 

              Integer bs  = [SELECT count() FROM Incident_Approver__c where Site_Information__r.Name= :SiteName and Approver__c=:UserInfo.getUserId() and Division__c='EH&S Manager'];
               List<GroupMember> getGroup = [SELECT UserOrGroupId FROM GroupMember WHERE UserOrGroupId =:UserInfo.getUserId()and (group.name = 'GIR_Emergency_Operator' or group.name = 'GIR_HSSSE_personnel')];  
                if(bs > 0 || getGroup.size()>0){
                    
                    displayList = TRUE;
                  
                }
                else{
                  
                    displayList = FALSE;
                
                  
                }
                
                return null;
        }
        }