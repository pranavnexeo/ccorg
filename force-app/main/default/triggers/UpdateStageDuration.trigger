trigger UpdateStageDuration on ES_Profile__c (Before insert,Before update) {

//Get data for Profile Archived from Custom Settings - General Data Store house
//Added for Profile Archived enhancement - Rajeev
Set<String> profiles = new Set<String>();
for(Opp_Plastics_CAM__c s : Opp_Plastics_CAM__c.getAll().Values()){
    if(s.IsProfile__c)
      profiles.add(s.Name);
}

for(ES_Profile__c a : Trigger.new) {
   if((!profiles.contains(a.Profile_Name__c)) && ((a.Stage__c == 'Profile Archived')||(trigger.isUpdate && trigger.oldmap.get(a.Id).Stage__c == 'Profile Archived')))
        a.addError('Sorry, You are not authorized to make this change !!');
   //**End**
   
if(trigger.isInsert){
if (a.Stage__c=='New Profile') { //if the Stage value was, in fact, updated
    a.New_Profile_stage_change_date__c=System.TODAY();} //Update current date into mentioned field in Salesforce

else if (a.Stage__c=='Submitted to WMS') { //if the Stage value was, in fact, updated
    a.SubmittedtoWMS_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
      
else if (a.Stage__c=='Profile Sent to Customer') { //if the Stage value was, in fact, updated
    a.ProfileSenttoCustomer_Stg_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
    
else if (a.Stage__c=='Submitted to TSDF') { //if the Stage value was, in fact, updated
    a.SubmittedtoTSDF_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
    
else if (a.Stage__c=='Profile Approved') { //if the Stage value was, in fact, updated
    a.ProfileApproved_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
    
else if (a.Stage__c=='Pricing Submitted for Approval') { //if the Stage value was, in fact, updated
    a.PricingSubmitedforApproval_Stg_Chng_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
  
else if (a.Stage__c=='Pricing Approved') { //if the Stage value was, in fact, updated
    a.PricingApproved_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce

//Added for Enh Res-4745 enhancement - 08/25/2016 Annes Ahamed
else if (a.Stage__c=='Substance Created') { //if the Stage value was, in fact, updated
    a.Substance_Created_Stage_Chnge_Date__c=System.TODAY();}
    
//Added for Enh Res-4745 enhancement - 07/26/2016 Annes Ahamed
else if (a.Stage__c=='Material/Pricing Created') { //if the Stage value was, in fact, updated
    a.Material_Pricing_Created_Stag_Chnge_Date__c=System.TODAY();}      
    
else if (a.Stage__c=='Material Added to CPI') { //if the Stage value was, in fact, updated
    a.Material_Added_to_CPI_Stage_Change_Date__c=System.TODAY();} 
    
else if (a.Stage__c=='Set-up Complete') { //if the Stage value was, in fact, updated
    a.Set_up_Complete_Stage_Change_Date__c=System.TODAY();}  
//**End** 
     
else if (a.Stage__c=='Material Setup in SAP') { //if the Stage value was, in fact, updated
    a.MaterialSetupinSAP_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
    
else if (a.Stage__c=='Pricing Rejected') { //if the Stage value was, in fact, updated
    a.PricingRejected_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce

//Added for Profile Archived enhancement - Rajeev
else if (a.Stage__c=='Profile Archived') { //if the Stage value was, in fact, updated
    a.ProfileArchived_Stage_Change_Date__c=System.TODAY();}
//**End**                               
}

if(trigger.isUpdate){

if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='New Profile') { //if the Stage value was, in fact, updated
    a.New_Profile_stage_change_date__c=System.TODAY(); }//Update current date into mentioned field in Salesforce

else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Submitted to WMS') { //if the Stage value was, in fact, updated
    a.SubmittedtoWMS_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
     
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Profile Sent to Customer') { //if the Stage value was, in fact, updated
    a.ProfileSenttoCustomer_Stg_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
  
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Submitted to TSDF') { //if the Stage value was, in fact, updated
    a.SubmittedtoTSDF_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
    
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Profile Approved') { //if the Stage value was, in fact, updated
    a.ProfileApproved_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
   
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Pricing Submitted for Approval') { //if the Stage value was, in fact, updated
    a.PricingSubmitedforApproval_Stg_Chng_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
   
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Pricing Approved') { //if the Stage value was, in fact, updated
    a.PricingApproved_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce

//Added for Enh Res-4745 enhancement - 08/25/2016 Annes Ahamed
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Substance Created') { //if the Stage value was, in fact, updated
    a.Substance_Created_Stage_Chnge_Date__c=System.TODAY();}    
//Added for Enh Res-4745 enhancement - 07/26/2016 Annes Ahamed
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Material/Pricing Created') { //if the Stage value was, in fact, updated
    a.Material_Pricing_Created_Stag_Chnge_Date__c=System.TODAY();}      
    
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Material Added to CPI') { //if the Stage value was, in fact, updated
    a.Material_Added_to_CPI_Stage_Change_Date__c=System.TODAY();} 
    
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Set-up Complete') { //if the Stage value was, in fact, updated
    a.Set_up_Complete_Stage_Change_Date__c=System.TODAY();}  
//**End**   
  
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Material Setup in SAP') { //if the Stage value was, in fact, updated
    a.MaterialSetupinSAP_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce
    
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Pricing Rejected') { //if the Stage value was, in fact, updated
    a.PricingRejected_Stage_Change_Date__c=System.TODAY();} //Update current date into mentioned field in Salesforce

//Added for Profile Archived enhancement - Rajeev
else if (a.Stage__c != Trigger.oldMap.get(a.Id).Stage__c && a.Stage__c=='Profile Archived') { //if the Stage value was, in fact, updated
    a.ProfileArchived_Stage_Change_Date__c=System.TODAY();}      
//**End**                         
}
}
}