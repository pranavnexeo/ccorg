public without sharing class BusinessContractPdfController {
   public Business_Contract__c busCon{get;set;} 
    public Business_Contract_Agreement_Data__c pdfData{get;set;}
    public string fax;
    public string email;
    public BusinessContractPdfController(ApexPages.StandardController stdController){
        busCon = (Business_Contract__c) stdController.getRecord();
        busCon = [SELECT Id,Name, Agreement__c,Customer_Name__r.Name, Customer_Name__r.Mapquest_Address__c,Customer_Name__c,
                    SAP_Material__c,Nexeo_Solutions_Stocking_Location__c,Forecasted_Quantity__c,Customer_Name__r.AccountNumber,Effective_Date__c,
                    Expiration_Date__c,SAP_Material__r.PH4_Supplier__c,SAP_Material__r.Material_Desc__c,SAP_Material__r.Container_Desc_del__c,
                    SAP_Material__r.Material_General_Data__r.Material_Number__c,Owner.Email,Nexeo_Solutions_Stocking_Location__r.Plant_Name__c,Stocking_Unit__c,
                    Customer_Name__r.Owner.Email
                    from Business_Contract__c 
                    where Id =: stdController.getId()];
        getData();
    }
    
    public void getData(){
        pdfData = [SELECT Id, First_Block__c,Second_Block__c,Third_Block__c,Fourth_block__c,Heading__c,
                            Third_Block_1__c,Third_Block_2__c,Third_Block_3__c,Terms_1__c,Terms_2__c,Terms_3__c,Terms_4__c,
                            Terms_5__c,Terms_6__c,Terms_7__c,Terms_8__c,Terms_9__c,Terms_10__c,Terms_11__c,Terms_12__c,Terms_13__c,Terms_14__c,
                            Terms_15__c,Terms_16__c,Terms_17__c,Terms_18__c,Terms_19__c,Terms_20__c,Extra_Text__c,Line_Break__c
                        FROM Business_Contract_Agreement_Data__c 
                        WHERE Name =:busCon.Agreement__c];
             
    }

}