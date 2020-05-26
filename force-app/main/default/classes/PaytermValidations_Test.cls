@isTest
private class PaytermValidations_Test
{
Static User U;
public static testMethod void  PaytermValidations_Test()
{ 
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acct1 = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acct1;
          //Account acct1= new Account(name='TestAccount1',SAP_Vendor_Purchase_Org__c='1000',SAP_Supplier_Number__c='123456',VendorUniqueId__c='1234561000',Type='Customer',SAP_Accounting_Group__c='ZREG',W_Account_Status__c='ACTIVE');
             // insert acct1;
             Profile profile = [select id from profile where name='System Administrator'];
             U = new User(alias = 'standt', email='standarduser@testorg.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = profile.Id, 
            timezonesidkey='America/Los_Angeles', username='nexeoMain@testorg.com',Payterm_Business_Role__c='VP,Credit Rep,Sales Manager,District Manager');
        
            insert U;
                 Pay_Term_Request__c j=new Pay_Term_Request__c();
               
                        j.Business_Unit__c='ADC East';
                        j.Sales_Rep__c=U.id;
                        j.District_Manager__c=U.id;
                        j.Sales_Director__c=U.id;
                        
                        j.Requested_Terms_Rebate__c='60 Days';
                        j.CSR__c=U.id;
                        j.Credit_Rep__c=U.id;
                        j.Customer_Name__c=acct1.id;
                        j.Annual_Sales__c=0.00;
                        j.Current_Monthly_Sales__c=0.00;
                        j.Gross_Profit__c=0.00;
                        j.Expense__c='7';
                        j.Status__c='Waiting Director Approval';
                        j.Account_Receivable__c=0.00;
                        j.Inventory_Dollars__c=0.00;    
                        j.Accounts_Payable__c=0.00;
                        j.Approved_Terms__c='';
                        j.Is_VP_Approval_Required__c='No';
                           
                        insert j;
                          system.debug('j.Status__c '+j.Status__c);                        
                          system.debug('j.Is_VP_Approval_Required__c  '+j.Is_VP_Approval_Required__c);
                          system.debug('j.Approved_Terms__c  '+j.Approved_Terms__c);
                           j.Status__c='Waiting VP Approval';
                           j.Is_VP_Approval_Required__c='';
                           j.Sales_Rep__c=U.id;
                           j.District_Manager__c=U.id;
                           j.Sales_Director__c=U.id;
                           
                           j.Requested_Terms_Rebate__c='60 Days';
                          
                           try
{
    update j;
}
Catch(Exception e)
{
  system.debug('Some Error Message:'+e);
}

                          system.debug('j.Status__c '+j.Status__c);                        
                          system.debug('j.Is_VP_Approval_Required__c  '+j.Is_VP_Approval_Required__c);
                          system.debug('j.Approved_Terms__c  '+j.Approved_Terms__c);

                       
                      
}
}