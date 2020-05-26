@isTest
private class Duplicate_CheckTest
 {
 static testMethod void Duplicate_CheckTest() {
Profile p = [select id from profile where name='System Administrator'];
User u1 = new User(alias = 'test111', email='test111@noemail.com',emailencodingkey='UTF-8', lastname='Testing1', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, country='United States',timezonesidkey='America/Los_Angeles', username='test111@noemail.com',Ashland_Employee_Number__c='Wipro-Dev1');
insert u1;
User u2=new User(alias = 'test222', email='test222@noemail.com',emailencodingkey='UTF-8', lastname='Testing2', languagelocalekey='en_US',localesidkey='en_US', profileid = p.Id, country='United States',timezonesidkey='America/Los_Angeles', username='test222@noemail.com',Ashland_Employee_Number__c='Wipro-Dev2');
insert u2;
Site_Information__c c1=new Site_Information__c(Name='Corporate Incident-New Corporate Incident',who_can_finalize_and_or_close_incidents__c=u1.Id,who_can_perform_Root_Cause_Analysis__c=u2.Id,EH_S_Manager__c=u2.Id,EH_S_Manager_Backups__c=u1.Id,who_provide_follow_up_info__c=u1.Id);
insert c1;
Site_RIM_Information__c  c=new Site_RIM_Information__c(Plant_Location__c='Testlocation',WWRegion__c='Testregion',Division__c='TestDiv',SICcode__c='1234',Address_1__c='Add1',Address_2__c='Add2',City__c='Test',State__c='Test',Postal_Code__c='620500',Country__c='Test',MainSitePick__c=c1.id);
insert c;
Site_RIM_Information__c  d=new Site_RIM_Information__c(Plant_Location__c='Testlocation1',WWRegion__c='Testregion1',Division__c='TestDiv1',SICcode__c='1234',Address_1__c='Add1',Address_2__c='Add2',City__c='Test1',State__c='Test1',Postal_Code__c='620500',Country__c='Test1',MainSitePick__c=c1.id);
try
{
insert d;
}
catch(Exception e)
{
Boolean expectedExceptionThrown =e.getMessage().contains('This Site Name already using existing record, Please select other site Name')?true:false;
System.AssertEquals(expectedExceptionThrown,true);
}  


}
}