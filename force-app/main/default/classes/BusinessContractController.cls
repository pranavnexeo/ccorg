public class BusinessContractController {
  public Business_Contract__c busCont{get;set;}
  public Id contractId;
  public Boolean isEdit{get; set;}
  public string returl{get; set;}
  public Boolean isClone{get; set;}
  public Boolean isApprover{get; set;}
  public boolean lockedrecord{get; set;}
  public boolean isNotEditable{get; set;}
  public Boolean isSuperUser{get; set;}
  public List<PermissionSetAssignment> psa;
  
     public BusinessContractController(ApexPages.StandardController stdController){
        busCont = (Business_Contract__c) stdController.getRecord();
        isApprover = isApprover();
        String clone = ApexPages.currentPage().getParameters().get('clone');
        psa =  [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name = 'Manage_Business_Contracts_Full_permission' Limit 1];
        isSuperUser = isSuperUser();
        if(clone == '1')
            isClone = true;
        else
            isClone = false;
        if(busCont.id != null){
            isEdit = true;
        }else{
            isEdit = false;
            busCont.OwnerId = UserInfo.getUserId();
            contractId = ApexPages.currentPage().getParameters().get('contractId');
        }
        if(isClone){
            busCont.Status__c = null;
        }
        if(contractId != null){
            Contract con = [SELECT Id, AccountId, SAP_Material__c,Default_Shipping_Plant__c,Quantity_1__c,StartDate,Account.SAP_Sales_Org__c,Stocking_Unit__c from Contract Where id = :contractId LIMIT 1];
            busCont.Customer_Name__c = con.AccountId;
            busCont.SAP_Material__c = con.SAP_Material__c;
            busCont.Contract_Type__c = 'High Risk Inventory Agreement';
            busCont.Nexeo_Solutions_Stocking_Location__c = con.Default_Shipping_Plant__c;
            busCont.Forecasted_Quantity__c = con.Quantity_1__c;
            busCont.First_Anticipated_Sale_Date__c = con.StartDate;
            busCont.Effective_Date__c = system.today();
            busCont.Stocking_Unit__c = con.Stocking_Unit__c;
            if(con.Account.SAP_Sales_Org__c == '1000'){
                busCont.Agreement__c = 'Long Term US';
                busCont.Expiration_Date__c = system.today().addyears(1);
            }
            else if(con.Account.SAP_Sales_Org__c == '1700'){
                busCont.Agreement__c = 'Long Term Canada';
                busCont.Expiration_Date__c = system.today().addyears(1);
            }
            else if(con.Account.SAP_Sales_Org__c == '1800'){
                busCont.Agreement__c = 'Long Term Mexico';
                busCont.Expiration_Date__c = system.today().addyears(1);
            }
            else if(con.Account.SAP_Sales_Org__c == '1031'){
                busCont.Agreement__c = 'Long Term US';
                busCont.Expiration_Date__c = system.today().addyears(1);
            }
            else{
                busCont.Expiration_Date__c = system.today().adddays(45);
            }
            
        }
        if(isEdit && busCont.Status__c == 'In Approval Process' && !isApprover && !isSuperUser ){
           lockedrecord = true;
        }
        isNotEditable = isNotEditable();
    }
    
    public PageReference saveBusinessContract(){
        if(!isEdit && !isClone){
            insert busCont;
            if(contractId != null){
                Contract con = [SELECT Id, AccountId, SAP_Material__c,Default_Shipping_Plant__c,Quantity_1__c,StartDate,Account.SAP_Sales_Org__c from Contract Where id = :contractId LIMIT 1]; 
                con.Business_Contract__c = busCont.Id;
                update con;
            }
        }
        else if(isEdit && !isClone){
            update busCont;
        }
        else if(isClone){
            buscont.id = null;
            insert busCont;
        }
        return new PageReference('/'+busCont.Id);
    }
    public PageReference cancel(){
        System.debug('returlcancel'+returl);
         if(returl == null && busCont.id != null){  
            return new pagereference('/' + busCont.id );
         }
         else if(returl == null && busCont.id == null){
             return new pagereference('/' +'a0T/o');
         }
         else{
             return new pagereference(returl);
         } 
    }
    //checking if current user is approver
    public boolean isApprover(){
        boolean issubmitted = Approval_Functions.issubmitted(busCont.id);
        boolean isapprover = false; 
        if(issubmitted == true){ 
            isapprover = approval_functions.isapprover(userinfo.getuserid(), busCont.id); 
        } 
        return isapprover;
    }
    public boolean isNotEditable(){
        boolean notEditable = false;
        //Id permsnId;
        system.debug('11111111111111'+notEditable);
        //List<PermissionSetAssignment> psa =  [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name = 'Manage_Business_Contracts_Full_permission' Limit 1];
        system.debug('list1111111111111222222222'+psa);
        if(busCont.Status__c == 'Activated' || busCont.Status__c == 'Expired'){
            if(psa.isempty()){
                
                notEditable = true;
                system.debug('222222222222222'+notEditable);
                
            }
        }
        
        return notEditable;
    }
    public boolean isSuperUser(){
        boolean superUser = false;
            if(!psa.isempty()){
                superUser = true;
                system.debug('3333333333'+superUser);
            }
        return superUser;
    }
    

}