//Contains methods to be overriden by standard buttons on R&D Request Object.
//LAB Project
//Test method in R_D_Object_Functions_test class.
//@Rajeev

public class RDEditController {

    //Initializing variables
    public R_D_Requests__c myRec{get; set;}
    public String rType {get; set;}
    public Map<String, Schema.RecordTypeInfo> RTMap{get; set;}
    public Map<Id, Schema.RecordTypeInfo> RTMap1{get; set;}
    public String CloneRec{get; set;}
    public string retURL;
    
    
    //*****Constructor*****
    public RDEditController(ApexPages.StandardController controller) {
        RTMap = R_D_Requests__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        myRec = (R_D_Requests__c)controller.getrecord();
        SYSTEM.DEBUG('myRec is'+myRec);
        CloneRec = ApexPages.currentPage().getParameters().get('Clone');
        
        
        if (CloneRec == 'Yes'){
            myRec.Stage__c = 'Stage 0 - Concept';
        }
     }
    
    //Method overriden by "Edit" button.
    //*****Start*****
    public pagereference redirectToEditPage(){
        
        rtype = [select recordtypeid from R_D_Requests__c where id = :myRec.id].recordtypeid;
        PageReference returnURL;
        //RTMap = R_D_Requests__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        
        if(rtype == RTMap.get('Customer – Stage 0 Concept').getrecordtypeid()){
            returnURL = new PageReference('/apex/Customer_Concept_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
        else if(rtype == RTMap.get('Customer – Stage 0 Pending Approval').getrecordtypeid()){
            //returnURL = new PageReference('/apex/Customer_Pending_Approval0_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
              returnURL = new PageReference('/' + myRec.Id + '/e?id=' + myRec.Id + '&nooverride=1&retURL=%2F' + myRec.Id);
        }
        else if(rtype == RTMap.get('Customer – Stage 1 Pending Approval').getrecordtypeid()){
            //returnURL = new PageReference('/apex/Customer_Pending_Approval1_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
              returnURL = new PageReference('/' + myRec.Id + '/e?id=' + myRec.Id + '&nooverride=1&retURL=%2F' + myRec.Id);
        }
        else if(rtype == RTMap.get('Customer – Stage 1 Scope').getrecordtypeid()){
            returnURL = new PageReference('/apex/Customer_Scope_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
         else if(rtype == RTMap.get('Customer – Stage 2 In Process').getrecordtypeid()){
            returnURL = new PageReference('/apex/Customer_In_Process_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
         else if(rtype == RTMap.get('Customer – Stage 2 Pending Approval').getrecordtypeid()){
            //returnURL = new PageReference('/apex/Customer_Pending_Approval2_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
            returnURL = new PageReference('/' + myRec.Id + '/e?id=' + myRec.Id + '&nooverride=1&retURL=%2F' + myRec.Id);
        }
         else if(rtype == RTMap.get('Customer – Stage 3 Closed Complete').getrecordtypeid()){
            returnURL = new PageReference('/apex/Customer_Close_Complete_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
         else if(rtype == RTMap.get('Customer – Stage 4 Closed Dead').getrecordtypeid()){
            returnURL = new PageReference('/apex/Customer_Close_Dead_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
         else if(rtype == RTMap.get('Innovation – Stage 0 Concept').getrecordtypeid()){
            returnURL = new PageReference('/apex/Innovation_Concept_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
         else if(rtype == RTMap.get('Innovation – Stage 0 Pending Approval').getrecordtypeid()){
            //returnURL = new PageReference('/apex/Innovation_Pending_Approval0_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
            returnURL = new PageReference('/' + myRec.Id + '/e?id=' + myRec.Id + '&nooverride=1&retURL=%2F' + myRec.Id);
        }
         else if(rtype == RTMap.get('Innovation – Stage 1 Market Research').getrecordtypeid()){
            returnURL = new PageReference('/apex/Innovation_Market_Research_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
        else if(rtype == RTMap.get('Innovation – Stage 1 Pending Approval').getrecordtypeid()){
            //returnURL = new PageReference('/apex/Innovation_Pending_Approval1_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
              returnURL = new PageReference('/' + myRec.Id + '/e?id=' + myRec.Id + '&nooverride=1&retURL=%2F' + myRec.Id);
        }
        else if(rtype == RTMap.get('Innovation – Stage 2 Pending Approval').getrecordtypeid()){
            //returnURL = new PageReference('/apex/Innovation_Pending_Approval2_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
              returnURL = new PageReference('/' + myRec.Id + '/e?id=' + myRec.Id + '&nooverride=1&retURL=%2F' + myRec.Id);
        }
        else if(rtype == RTMap.get('Innovation – Stage 2 Product Development').getrecordtypeid()){
            returnURL = new PageReference('/apex/Innovation_Product_Development_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
        else if(rtype == RTMap.get('Innovation – Stage 3 Pending Approval').getrecordtypeid()){
            //returnURL = new PageReference('/apex/Innovation_Pending_Approval3_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
              returnURL = new PageReference('/' + myRec.Id + '/e?id=' + myRec.Id + '&nooverride=1&retURL=%2F' + myRec.Id);
        }
        else if(rtype == RTMap.get('Innovation – Stage 3 Pre-Launch').getrecordtypeid()){
            returnURL = new PageReference('/apex/Innovation_PreLaunch_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
        else if(rtype == RTMap.get('Innovation – Stage 4 Dead').getrecordtypeid()){
            returnURL = new PageReference('/apex/Innovation_Dead_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
        else if(rtype == RTMap.get('Innovation – Stage 4 Launch').getrecordtypeid()){
            returnURL = new PageReference('/apex/Innovation_Launch_Page?id='+myRec.id+'&rid='+rtype+'&edit=true');
        }
        returnURL.setRedirect(true);
        return returnURL;
       }
    //*****End*****
    
    //Overriden by "Clone" button
    //*****Start*****
    public pagereference redirectToClonePage(){
    
        rtype = [select recordtypeid from R_D_Requests__c where id = :myRec.id].recordtypeid;
        PageReference returnURL;
        RTMap1 = R_D_Requests__c.sObjectType.getDescribe().getRecordTypeInfosById();
        String RecTypeId;
        if(RTMap1.get(rtype).getName().contains('Customer')){
            RecTypeId = RTMap.get('Customer – Stage 0 Concept').getrecordtypeid();
            returnURL = new PageReference('/apex/Customer_Concept_Page?id='+myRec.id+'&rid='+RecTypeId+'&Clone=Yes');
        }
        else if(RTMap1.get(rtype).getName().contains('Innovation')){
            RecTypeId = RTMap.get('Innovation – Stage 0 Concept').getrecordtypeid();
            returnURL = new PageReference('/apex/Innovation_Concept_Page?id='+myRec.id+'&rid='+RecTypeId+'&Clone=Yes');
        }
        
        return returnURL;
       }
    //*****End*****
    
    
    //Method overriden by "New" button on R&D Request Object.
    //@Rajeev
    //*****Start*****
    public pagereference redirectToNewPage(){
    String rid = myRec.RecordTypeId;
    String retURL = ApexPages.currentPage().getParameters().get('retURL');
        PageReference returnURLL;
        if((rid != null) && (rid == RTMap.get('Customer – Stage 0 Concept').getrecordtypeid())){ 
            returnURLL = new PageReference('/apex/Customer_Concept_Page?rid='+rid+'&returl='+retURL+'&edit=false');               
        }
        else if(rid == RTMap.get('Customer – Stage 0 Pending Approval').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Customer_Pending_Approval0_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Customer – Stage 1 Pending Approval').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Customer_Pending_Approval1_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Customer – Stage 1 Scope').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Customer_Scope_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
         else if(rid == RTMap.get('Customer – Stage 2 In Process').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Customer_In_Process_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
         else if(rid == RTMap.get('Customer – Stage 2 Pending Approval').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Customer_Pending_Approval2_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
         else if(rid == RTMap.get('Customer – Stage 3 Closed Complete').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Customer_Close_Complete_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
         else if(rid == RTMap.get('Customer – Stage 4 Closed Dead').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Customer_Close_Dead_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
         else if((rid != null) && (rid == RTMap.get('Innovation – Stage 0 Concept').getrecordtypeid())){
            returnURLL = new PageReference('/apex/Innovation_Concept_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
         else if(rid == RTMap.get('Innovation – Stage 0 Pending Approval').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_Pending_Approval0_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
         else if(rid == RTMap.get('Innovation – Stage 1 Market Research').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_Market_Research_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Innovation – Stage 1 Pending Approval').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_Pending_Approval1_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Innovation – Stage 2 Pending Approval').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_Pending_Approval2_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Innovation – Stage 2 Product Development').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_Product_Development_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Innovation – Stage 3 Pending Approval').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_Pending_Approval3_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Innovation – Stage 3 Pre-Launch').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_PreLaunch_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Innovation – Stage 4 Dead').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_Dead_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }
        else if(rid == RTMap.get('Innovation – Stage 4 Launch').getrecordtypeid()){
            returnURLL = new PageReference('/apex/Innovation_Launch_Page?rid='+rid+'&returl='+retURL+'&edit=false');
        }else{
            Id defaultRecordTypeId = [SELECT Id, Name from RecordType WHERE SobjectType = 'R_D_Requests__c' and Name = 'Innovation – Stage 0 Concept'].Id;
            returnURLL = new PageReference('/apex/Innovation_Concept_Page?rid='+defaultRecordTypeId+'&returl='+retURL+'&edit=false');
            //Schema.DescribeSObjectResult R = R_D_Requests__c.SObjectType.getDescribe();
            //returnURLL = new PageReference('/'+R.getKeyPrefix()+'/e?RecordType='+rid+'&retURL='+retURL+'&nooverride=1&edit=false');
        }
        returnURLL.setRedirect(true);
        return returnURLL;
       }
       //*****End*****
}
//*****End of Class*****
//LAB Project