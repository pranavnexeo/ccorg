@isTest
public class NCAR_Case_TriggerTest {
     static testMethod void TestMe() {
         Map<String, SObject> testData = NexeoTestUtils_Test.initData();

            Account acc = (Account) testData.get('testGeneralAccount');    
         list<NCAR_Cases__c> lst = new list<NCAR_Cases__c>();
         Id devRecordTypeId = Schema.SObjectType.NCAR_Cases__c.getRecordTypeInfosByName().get('Nexeo Return').getRecordTypeId();
        Id rtID = Schema.SObjectType.NCAR_Cases__c.getRecordTypeInfosByName().get('Nexeo Standard Incident').getRecordTypeId();
          
         lst.add(new NCAR_Cases__c(Account__c =acc.id,Type__c = 'Nexeo Physical Material Return',Status__c = 'Waiting on Delivery Block release'));
          lst.add(new NCAR_Cases__c(recordTypeid=devRecordTypeId,Account__c =acc.id,Type__c = 'Nexeo Physical Material Return',Status__c = 'Waiting on Delivery Block release'));
         lst.add(new NCAR_Cases__c(recordTypeid=devRecordTypeId,Account__c =acc.id,Type__c = 'Nexeo Physical Material Return',Status__c = 'Rejected',Reason_Rejected__c = 'More Information Required',Saved_As_Draft__C=false));
        lst.add(new NCAR_Cases__c(recordTypeid=devRecordTypeId,Account__c =acc.id,Type__c = 'Nexeo Physical Material Return',Status__c = 'Rejected',Reason_Rejected__c = 'More Information Required',Saved_As_Draft__C=true));
        lst.add(new NCAR_Cases__c(recordTypeid=rtID,Account__c =acc.id,Type__c = 'Nexeo Physical Material Return',Status__c = 'Rejected',Reason_Rejected__c = 'More Information Required',Saved_As_Draft__C=false));
        lst.add(new NCAR_Cases__c(recordTypeid=devRecordTypeId,Account__c =acc.id,Type__c = 'Nexeo Paperwork Only Return',Status__c = 'Submitted to Plant'));
        lst.add(new NCAR_Cases__c(recordTypeid=devRecordTypeId,Account__c =acc.id,Type__c = 'Nexeo Physical Material Return',Status__c = 'Approved by Purchasing',Reason_Rejected__c = 'More Information Required',Saved_As_Draft__C=false));
        lst.add(new NCAR_Cases__c(recordTypeid=devRecordTypeId,Route_to__c = 'Dan Black',Account__c =acc.id,Type__c = 'Nexeo Physical Material Return',Status__c = 'NCAR- ES Approval Process',Reason_Rejected__c = 'More Information Required',Saved_As_Draft__C=false));
       
         insert lst;
         
         lst[5].Saved_As_Draft__C=true;
         update lst[5];
         
     }
}