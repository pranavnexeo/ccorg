public class CheckBatchDuplicateTests{
    static testMethod void testCheckBatchDuplicatePreventer() {
    
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Group3_Desc__c = 'COMMODITY', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        
        Account supplierAccount = new Account (Name = 'Test Supplier Account', Type = 'Vendor');
        insert supplierAccount;
        
        Certificate_Of_Analysis__c cofa=new Certificate_Of_Analysis__c();
        cofa.Batch__c='MC02BEE05';
        cofa.Material__c=matlist.Id;
        cofa.Supplier_Name__c=supplierAccount.Id;
        insert cofa;
      
     /* Certificate_Of_Analysis__c cofa1=new Certificate_Of_Analysis__c();
        cofa1.Batch__c='MC02BEE05';
        cofa1.Material__c='a0eE0000000Uhb8';
        cofa1.Supplier_Name__c='001E000000BtKEj';
        insert cofa1;*/
        
   }
    
   static testMethod void testCheckBatchDuplicatePreventer2() {
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material', Material_Group3_Desc__c = 'COMMODITY', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key');        
        insert matlist;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Account supplierAccount = new Account (Name = 'Test Supplier Account', Type = 'Vendor');
        insert supplierAccount;
        
        Certificate_Of_Analysis__c cofa=new Certificate_Of_Analysis__c();
        cofa.Batch__c='MC02BEE05';
        cofa.Material__c=matlist.Id;
        cofa.Supplier_Name__c=supplierAccount.Id;
        insert cofa;
      
       try {
            Certificate_Of_Analysis__c cofa2=new Certificate_Of_Analysis__c();
            cofa2.Batch__c='MC02BEE05';
            cofa2.Material__c=matlist.Id;
            cofa2.Supplier_Name__c=supplierAccount.Id;
            insert cofa2;
       } catch (Exception ex) {
           
       }
        
   }
   
}