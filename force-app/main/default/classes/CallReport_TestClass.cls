@isTest
private class CallReport_TestClass
{
    static testMethod void CallReport_TestMethod() 
    {
        String[] test_Email_Addrr = new String[]{'test@mail.com'};
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
               
        //Inserting test PM Prospect - Cast Account
        Account test_PM_Prospect_Cast_Acc = new Account();
        test_PM_Prospect_Cast_Acc.Name = 'Test PM Prospect - Cast Account';
        //test_PM_Prospect_Cast_Acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Performance Materials Prospect - CAST', 'Account');
        test_PM_Prospect_Cast_Acc.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer', 'Account');
        test_PM_Prospect_Cast_Acc.Type = 'Prospect';
        test_PM_Prospect_Cast_Acc.SAP_Sales_District_Desc__c = 'COMM DIR ASIA';
        test_PM_Prospect_Cast_Acc.SAP_Sales_Office_Desc__c = 'COMM MGR CHINA';
        test_PM_Prospect_Cast_Acc.SAP_Sales_Group_Desc__c = 'EAST CHINA A';
        test_PM_Prospect_Cast_Acc.Phone = '1234567980';
        test_PM_Prospect_Cast_Acc.T_Market__c = 'Aerospace';
        test_PM_Prospect_Cast_Acc.T_Metal_Castings__c = 'Aluminium Base';
        test_PM_Prospect_Cast_Acc.Specific_MoldingCasting_Process__c = 'Ceramics';
        insert test_PM_Prospect_Cast_Acc;
        
        Material_Description__c d = new Material_Description__c(Language_Code__c = 'E', Material_Description__c = 'Test Desc', Material_Number__c = 'test material');
        insert d;
        d.material_Description__c = 'test2';
        update d;
        
        //Inserting test PM Call Report
        Call_Report__c test_PM_Call_Rep = new Call_Report__c();
        test_PM_Call_Rep.Title__c = 'Test PM Call Report';
        test_PM_Call_Rep.RecordTypeId = RecordType_Functions.LookupRecordTypeId('PM Call Report Record Type', 'Call_Report__c');
        test_PM_Call_Rep.Account__c  = test_PM_Prospect_Cast_Acc.Id;
        insert test_PM_Call_Rep;
        
        //Testing the emailCallReport method in CallReport class
        String result = CallReport.emailCallReport(test_Email_Addrr, test_PM_Call_Rep.id);
        System.debug('Result------------------' + result);
    }
}