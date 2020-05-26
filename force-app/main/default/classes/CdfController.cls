public class CdfController {
    public Contract contractObj{get;set;}
    public boolean showContractCreateMessage{get; set;}
    public boolean lockedrecord{get; set;}
    public boolean statusPermission{get; set;}
    public String userProfileName{get; set;}
    public Id plasticsRecordTypeId;
    public Boolean isEdit{get; set;}
    public string returl{get; set;}
    public Boolean isClone{get; set;}
    public Boolean createBusCon;
    public Boolean isApprover{get; set;}
    public CdfController(ApexPages.StandardController stdController){
        plasticsRecordTypeId = Schema.SObjectType.Contract.getRecordTypeInfosByName().get('CDF AD Plastics').getRecordTypeId();
        contractObj = (Contract) stdController.getRecord();
        isApprover = isApprover();
        userProfileName = userProfile();
        statusPermission = statusPermsn();
        String clone = ApexPages.currentPage().getParameters().get('clone');
        if(clone == '1')
            isClone = true;
        else
            isClone = false;
        if(contractObj.id != null && !isClone){
            isEdit = true;
        }else{
            isEdit = false;
            contractObj.ContractTerm = 4;
            contractObj.Status = 'Draft';
        }
        showContractCreateMessage = false;
        createBusCon = false;
        if(isEdit && contractObj.Status == 'Approval In Process' && !isApprover){
           lockedrecord = true;
        }
    }
    //save contract
    public PageReference saveContract(){
        try{
            if(isClone)
                contractObj.Cloned_From__c = contractObj.Id;
            if(!isEdit){//meaning in case of CREATE and CLONE
    
                if(checkExistingCDF())
                    return null;
                if(contractObj.recordTypeId == plasticsRecordTypeId){
                    checkMaterialContract();
                }
                //insert contractObj;
                if(contractObj.id == null && !showContractCreateMessage && !createBusCon)
                    insertContract();
                if(contractObj.id != null && !showContractCreateMessage && !createBusCon && isClone){
                    contractObj.id = null;
                    insertContract();
                }
            }
            else{
                if(checkDuplicateonEdit())
                    return null;
                update contractObj;
            }
            if(showContractCreateMessage)
                return null;
            else if(createBusCon){
                if(contractObj.id == null || isClone)
                contractObj.id = null;
                insertContract();
                return new PageReference('/apex/BusinessContractPage?contractid='+contractObj.id);
            }
            else
                return new PageReference('/'+contractObj.Id);
        }catch(System.DmlException e) {
               ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getDmlMessage(0)));
               return null;
        }
    }
    //end save contract
    //cancel button
    public PageReference cancel(){
        System.debug('returlcancel'+returl);
         if(returl == null && contractObj.id != null){  
            return new pagereference('/' + contractObj.id );
         }
         else if(returl == null && contractObj.id == null){
             return new pagereference('/' +'800/o');
         }
         else{
             return new pagereference(returl);
         } 
    }
    //insert comtract
    public void insertContract(){
        insert contractObj;
    }
    //refresh page
    public PageReference changeOrderFrequency(){
        system.debug('inside of---'+contractObj.Order_Frequency__c );
        return null;
    }
    //chesking for existing cdf
    public boolean checkExistingCDF(){
        List<Contract> cdfList = [SELECT Id, ContractNumber 
                                  FROM Contract 
                                  WHERE AccountId = :contractObj.AccountId AND SAP_Material__c = :contractObj.SAP_Material__c AND 
                                  Status != 'Rejected - Never Activated' AND Status != 'Expired' AND Status != 'Canceled'
                                  LIMIT 1];
        if(!cdfList.isEmpty()){
           String first = '<a href="'; 
           String fullURL = URL.getSalesforceBaseUrl().toExternalForm();
           String last = '" target="_blank">'+ cdfList[0].ContractNumber +'</a>';
           String cdfurl = 'CDF ' + first + fullURL + '/' + cdfList[0].Id+ last + ' already exists.';
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,cdfurl));
           return true;
         }
         return false;
    }
    public boolean checkDuplicateonEdit(){
        List<Contract> cdfList = [SELECT Id, ContractNumber 
                                  FROM Contract 
                                  WHERE AccountId = :contractObj.AccountId AND SAP_Material__c = :contractObj.SAP_Material__c AND 
                                  Status != 'Rejected - Never Activated' AND Status != 'Expired' AND Status != 'Canceled'];
        system.debug('in here 1');                          
        if(!cdfList.isEmpty()){
            
            integer index = -1;
            for(Integer i = 0; i < cdfList.size(); i++){
                system.debug(cdfList[i].id);
                system.debug(contractobj.id);
                if(cdfList[i].id == contractobj.id){
                    index = i;
                    break;
                    system.debug('inside if condition'+index);
                }    
                    
            }
            system.debug('in here 2'+index);
            if(index != -1){
                cdfList.remove(index);
                system.debug('in here 3'+index);
            }
        }
        if(!cdfList.isEmpty()){
           String first = '<a href="'; 
           String fullURL = URL.getSalesforceBaseUrl().toExternalForm();
           String last = '" target="_blank">'+ cdfList[0].ContractNumber +'</a>';
           String cdfurl = 'CDF ' + first + fullURL + '/' + cdfList[0].Id+ last + ' already exists.';
           ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,cdfurl));
           return true;
         }
         return false;
    }
    //checking all conditions for plastics cdf
    public void checkMaterialContract(){
        List<Material_Contract__c> matContractList = [SELECT Id, SAP_Material__c, Contract_Required__c, SAP_Material__r.Container_Desc_del__c, 
                                                             SAP_Material__r.Material_Desc__c, SAP_Material__r.PH6_Segment__c
                                                      FROM Material_Contract__c 
                                                      WHERE SAP_Material__c = :contractObj.SAP_Material__c LIMIT 1];
        if(!matContractList.isEmpty()){
            Material_Contract__c mc = matContractList[0];
            if(mc.Contract_Required__c){
                contractObj.Business_Contract_Required__c = true;
                List<Business_Contract__c> busConList = [Select Id from Business_Contract__c 
                                                                where SAP_Material__c = :contractObj.SAP_Material__c
                                                                AND Customer_Name__c = :contractObj.AccountId AND Status__c = 'Activated' Limit 1];
                if(!busConList.isEmpty()){
                    contractObj.Business_Contract__c = busConList[0].id;
                }
                else{  
                                                               
                    if(mc.SAP_Material__r.Container_Desc_del__c == 'BULK' && 
                       mc.SAP_Material__r.PH6_Segment__c != null && 
                       (mc.SAP_Material__r.PH6_Segment__c.contains('- 322') || mc.SAP_Material__r.PH6_Segment__c.contains('- 326'))){
                        showContractCreateMessage = true;
                    }
                    else{
                        createBusCon = true;
                        //createBusinessContract();
                    }
                }
            }
        }
        else{
            
                contractObj.Business_Contract_Required__c = true;
                List<Business_Contract__c> busConList = [Select Id from Business_Contract__c 
                                                                where SAP_Material__c = :contractObj.SAP_Material__c
                                                                AND Customer_Name__c = :contractObj.AccountId AND Status__c = 'Activated' Limit 1];
                if(!busConList.isEmpty()){
                    contractObj.Business_Contract__c = busConList[0].id;
                }
                else{ 
                    List<Material_Sales_Data2__c> matList = [SELECT Id,Container_Desc_del__c, 
                                                             PH6_Segment__c
                                                            FROM Material_Sales_Data2__c 
                                                            WHERE Id = :contractObj.SAP_Material__c LIMIT 1];
                    if(!matList.isEmpty()){
                        Material_Sales_Data2__c msd = matList[0];
                        if(msd.Container_Desc_del__c == 'BULK' && 
                           msd.PH6_Segment__c != null && 
                           (msd.PH6_Segment__c.contains('- 322') || msd.PH6_Segment__c.contains('- 326'))){
                            showContractCreateMessage = true;
                        }
                        else{
                            createBusCon = true;
                            //createBusinessContract();
                        }
                    }
                }
        }
    }
    //checking if surrent user is approver
    public boolean isApprover(){
        boolean issubmitted = Approval_Functions.issubmitted(contractObj.id);
        boolean isapprover = false; 
        if(issubmitted == true){ 
            isapprover = approval_functions.isapprover(userinfo.getuserid(), contractObj.id); 
        } 
        return isapprover;
    }
    //Getting profile of current User
    public string userProfile(){
        
        return [select Profile.Name
                    from User
                    where Id = :Userinfo.getUserId()
                    ].Profile.Name;
    }
    //check permissionset for users
    public boolean statusPermsn(){
        boolean havePermsn = false;
        Id permsnId;
        system.debug('11111111111111'+havePermsn);
        List<PermissionSetAssignment> psa =  [SELECT PermissionSetId FROM PermissionSetAssignment WHERE AssigneeId= :UserInfo.getUserId() AND PermissionSet.Name = 'CDF_Status_Permission' Limit 1];
        system.debug('list1111111111111222222222'+psa);
        if(!psa.isempty()){
            permsnId = psa[0].PermissionSetId ;
            if(permsnId != null){
                havePermsn = true;
                system.debug('222222222222222'+havePermsn);
            }
        
        }
        
        return havePermsn; 
    }
    //save cdf
    public PageReference optOutBusinessContract(){
        insertContract();
        return new PageReference('/'+contractObj.Id);
    }
    //redirect to business contract
    public PageReference createBusinessContract(){
        if(contractObj.id == null)
            insertContract();
        return new PageReference('/apex/BusinessContractPage?contractid='+contractObj.id);
    }
    
    //get stocking unit on selelcting material
    public List<SelectOption> getStockingUnits(){
     List<SelectOption> options = new List<SelectOption>();
     //options.add(new SelectOption('--None--', '--None--'));
     system.debug('first check for material'+contractObj.SAP_Material__c);
     if(contractObj.SAP_Material__c != null){
      for(Material_UOM2__c mUOM : Material_Sales_Data_Functions.getAltUOMs(contractObj.SAP_Material__c)){
       options.add(new SelectOption(mUOM.Alternative_UOM_Desc__c, mUOM.Alternative_UOM_Desc__c));
      }
     }
     return options;
    }
    
    
}