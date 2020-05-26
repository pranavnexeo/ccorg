/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        4/10/2017
*   Author:              Shwetha Suvarna
*   Last Modified:       4/10/2017
*   Last Modified By:    Shwetha Suvarna
*
*   **********************************************************************************************************************/

@isTest
private class Material_Sales_Data2_After_UpsertTest {
    public static testMethod void testmybatch1(){
        Profile P = [select id,Name from profile where name =: 'Integration User'];
        User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
        system.runas(u){
            Material_Sales_Data2__c msd = new Material_Sales_Data2__c(Name='test',Material_Number__c='091234',Create_CC_Product__c=true,Dist_Channel_Code__c='30',Record_Key__c='09123410003031',Sales_Org_Code__c='1000');
            insert msd;
        }
    }
}