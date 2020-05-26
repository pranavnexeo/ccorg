@isTest
private class AccountSyncIssue_Test {
  
    static testMethod void myUnitTest() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='INVALID_FIELD:Foreign key external ID:',Error_Type__c='Foreign key external ID - Seller Issue',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest1() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='while updating the partner function(Payer) for Idoc',Error_Type__c='Account Does not Exists (Payer)',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest2() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='INVALID_CROSS_REFERENCE_KEY:Relationship Manager: owner cannot be blank',Error_Type__c='Blank Owner Issue',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest3() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY:Territory_Before_Upsert: execution of BeforeUpdate',Error_Type__c='Salesforce Trigger Issue (SAP Territory)',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest4() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='INVALID_FIELD_FOR_INSERT_UPDATE:Attempting to update (as part of an upsert) parent field Account__c with new value',Error_Type__c='Duplicate Account Number and CIS number Issue',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest5() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='DUPLICATE_EXTERNAL_ID:VendorUniqueId: more than one record found for external id field:',Error_Type__c='Vendor Account Issue',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest6() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='UNABLE_TO_LOCK_ROW:unable to obtain exclusive access to this record',Error_Type__c='Unable to Lock Record Issue',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest7() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='DUPLICATE_VALUE:duplicate value found: Record_Key__c duplicates value on record with id:',Error_Type__c='Duplicate Record Key Issue',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest8() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='while updating the partner function(Bill To) for Idoc#:',Error_Type__c='Account Does not Exists (Bill To)',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest9() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY:SAP_Territory_After_Upsert: execution of AfterUpdate',Error_Type__c='Salesforce Trigger Issue (SAP Territory)',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
     static testMethod void myUnitTest10() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY:Account_Trigger_Before_Upsert_After_Upsert: execution of AfterUpdate',Error_Type__c='Salesforce Trigger Issue (Account)',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest11() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Email__c ='DUPLICATE_EXTERNAL_ID:CIS Account Number: more than one record found for external id field:',Error_Type__c='KNA1 Account Issue',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
    static testMethod void myUnitTest12() {
    try{
    Account acc = new Account(Name='TestAcc',Type='Prospect',SAP_Division_Desc__c='Nexeo Chem');
    insert acc;   
        
    Integration_Error__c IE = new Integration_Error__c(Error_Type__c='Other Issue',Account_Number__c = acc.id,Distribution_Channel__c = '30',Division__c = '31',Sales_Org__c = '1000');
    insert IE;
    }catch(exception e){}
    }
    
 }