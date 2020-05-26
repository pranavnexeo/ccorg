/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        2/1/2016
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By: 
*   VF Controller:       cc_imp_mn_ctrl_HomePageBIE
*   VF Page:                        
*   Short Description:   Test class for HomePageBIE Controller.
*   **********************************************************************************************************************/
@isTest(SeeAllData=false) 
public class cc_imp_mn_ctrl_HomePageBIETest {
    public static testMethod void MyTest(){
        Id ProfileId = [select id from Profile where name= 'CloudCraze Customer Community User MyNexeo'].Id;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
          TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true,Ashland_Employee_Number__c = 'A123000');
          insert u;
        //Map<String, SObject> testData = cc_imp_testUtils.initData();
        insert cc_imp_testUtils.createCPICustomSettingList();
    
        Account dummyAccount= new Account();    
        dummyAccount.Name='Test';
        dummyAccount.AccountNumber='P123456';
        insert dummyAccount;
        
        contact dummyContact=new contact();
        dummycontact.AccountId=dummyAccount.Id;
        dummyContact.cc_imp_Is_MyNexeo_Admin__c=true;  
        dummyContact.Email='test@test.com';
        dummyContact.LastName='Test';
        insert dummyContact;
        system.runas(u)
        {
        
        userRole ur = [SELECT id from userrole where  developername= 'ADSales' limit 1];
        system.debug('ur==='+ur.id);    
        User dummyUser=new User();
        dummyUser.Username='test@test.com';
        dummyUser.LastName='Test';
        dummyUser.Email='test@test.com';
        dummyUser.Alias='Test';
        dummyUser.CommunityNickname='Test';
        dummyUser.TimeZoneSidKey='GMT';
        dummyUser.LocaleSidKey='en_US';
        dummyUser.EmailEncodingKey='ISO-8859-1';
        dummyUser.LanguageLocaleKey='en_US';
        dummyUser.ProfileId=ProfileId;
        dummyUser.ContactId=dummyContact.Id; 
        dummyUser.userroleid=ur.id;       
        /*insert dummyUser;
        ccrz.cc_CallContext.currUser=dummyUser;
        ccrz.cc_CallContext.currUserId=dummyUser.Id;*/
            ccrz.cc_CallContext.currUserId=dummyUser.Id;
        CC_SFDC_Settings__c  obj = new CC_SFDC_Settings__c (name='CPI_MyNexeo',prospectMessage__c='test',GuestProfileId__c=p.id);
            insert obj;
            cc_imp_mn_ctrl_HomePageBIE hpb= new cc_imp_mn_ctrl_HomePageBIE();
        }
        
        
    }
    
}