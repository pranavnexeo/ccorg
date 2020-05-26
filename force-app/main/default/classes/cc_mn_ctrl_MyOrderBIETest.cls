@isTest
public class cc_mn_ctrl_MyOrderBIETest {
    
    @isTest static void ValidateViewDoc()
    {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'standt2', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='sbhdsfdc@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123f002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
           Account objAcc = new Account(name='test',SAP_DivisionCode__c='34');
           insert objAcc;
           cc_mn_ctrl_MyOrderBIE obj = new cc_mn_ctrl_MyOrderBIE ();
            
    }
   
}