@isTest
public class TriggerOnAttachmentsTest {

    public static testMethod void testRunAs() {
    
        Profile p = [SELECT Id FROM Profile WHERE Name='Integration User'];
        
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorgtr.com');
        System.runAs(u) {
        
            Material_Sales_Data2__c msd2=new Material_Sales_Data2__c(Attachment_Exist__c=true,Material_Number__c='782222',Dist_Channel_Code__c='31',Record_Key__c='Recordkey01',Sales_Org_Code__c='1000');
            insert msd2; 
                    
            List<Material_Sales_Data2__c> msd2obj=[select id, name from Material_Sales_Data2__c where id=:msd2.id];
            System.assertEquals(true, msd2.Attachment_Exist__c);
                        
            Attachment attach=new Attachment();     
            attach.Name='Unit Test Attachment';
            Blob bodyBlob=Blob.valueOf('Unit Test Attachment Body');
            attach.body=bodyBlob;
            attach.parentId=msd2.id;
            insert attach;
                    
            List<Attachment> attachments=[select id, name from Attachment where parent.id=:msd2.id];
            System.assertEquals(1, attachments.size());
            
        
        }
    
    }
}