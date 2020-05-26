@isTest
    private class PriceSupportRequest_Redirect_Test {

        static testMethod void PriceSupportRequest_Redirect_Test() {
            //ApexPages.StandardController sc;
            
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
            Account acc = new Account(name= 'test');
            insert Acc;
            Material_Sales_Data2__c msd = new Material_Sales_Data2__c(name = 'test',Dist_Channel_Code__c = '12',Material_Number__c = '1234',Sales_Org_Code__c ='12345',Record_Key__c ='12345');
            insert msd;
            Price_Support_Request__c psr = new Price_Support_Request__c(Status__c = 'Open',New_Or_Changed__c = 'Changed',Order_Type__c = 'Both',Flat_or_Purchased__c = 'Flat',Sales_Organization__c = '1000-US',Customer_Type__c='PY-Payer',Customer_Name__c = acc.id,Competitor_Name__c = '1-time buy',Material_Selling__c =msd.id,UOM__c ='KG');
            insert psr;
            ApexPages.standardcontroller sc = new ApexPages.standardcontroller(psr);
            PriceSupportRequest_Redirect prt = new PriceSupportRequest_Redirect(sc);
            prt.redirect();
            prt.ViewRedirect();
        }
    }