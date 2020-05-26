@isTest
private class SAP_Price_History_Test {
    public static testMethod void testSAPPriceHistory() {
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    Account acc = new Account(Name='Test',AccountNumber='abcdef',SAP_Sold_To_Account_Id__c='test');
    insert acc;
    Material_Sales_Data2__c SAPMat = new Material_Sales_Data2__c(Name='Test1',Dist_Channel_Code__c='te',Material_Number__c='test',Record_Key__c='abcd',Sales_Org_Code__c='asdf');
    insert SAPMat;
    Account_material__c accMat = new Account_material__c(Account__c = acc.Id,SAP_Material__c= SAPMat.Id);
    insert accMat;
    //Id RecordTypeId = Schema.SObjectType.Customer_Product_Info__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();    
    Customer_Product_Info__c  Cpi = new Customer_Product_Info__c (CPI_Record_Type__c='A',Customer_Number__c='hdsfjh',Distribution_Channel_Code__c='AB',Material_Number__c='djfhdjs',Record_Key__c='jsdfhsj74',Sales_Org_Code__c='hgdf');
        
    insert Cpi;
    Account_material__c accMat1 = new Account_material__c(Account__c = acc.Id,SAP_Material__c= SAPMat.Id,SAP_Data_Refreshed__c=system.today(),Target_Unit__c=1,Prospect_Material__c=false, Target_Price__c=1.1500, CurrencyIsoCode='USD',Price_Protection__c='Z0 - No Protection', Avg_Order_Qty__c=0,Estimated_Order_Quantity__c=3,Target_UoM__c='LB',Created_From_CPI__c= Cpi.id,Has_Open_PRT__c=false,Has_CSP__c=true,UoMs__c='DR;GAL;KG;LB;PAL;RCU', CSP_Tier_UoM__c='DR', CSP_UoM__c='LB', CSP_Effective_Date__c=system.today(),CSP_Expiration_Date__c=system.today(), Has_Unit_Options__c=true,CSP_Price__c=0.9900, TPI__c=86.00);
    insert accMat1;
    
    SAP_Price_History controller = new SAP_Price_History();
    
    SAP_Price_History.getRecordsToDisplay(null);
    SAP_Price_History.stringtodate('11062014');
    SAP_Price_History.formatDate(system.today());
    SAP_Price_History.formatDate(null);
    SAP_Price_History.getDateFormat();
    SAP_Price_History.stringtodouble('2,3-45');
    SAP_Price_History.stringtodouble('');
    SAP_Price_History.stringtodouble(2);
    SAP_Price_History.stringtodouble(2.34);
    SAP_Price_History.Stringtodouble('2.3');
    List<CSP_JSON_Response.tbl_csp_prices> blankList = new List<CSP_JSON_Response.tbl_csp_prices>();
    SAP_Price_History.SAPHistoryWrapper sH = new SAP_Price_History.SAPHistoryWrapper(accMat1,3,'test','test','test','test','test','test','test','test','test','test','test','test','test',blankList) ;
    
    
    }
}