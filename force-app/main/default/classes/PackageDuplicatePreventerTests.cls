@isTest
public class PackageDuplicatePreventerTests{
    static testMethod void testPackageDuplicatePreventer() {
        
    
      Set<String> packagetype = new Set<String>();
      packagetype.add('test1');
      packagetype.add('test2');
      packagetype.add('test3');
      packagetype.add('test4');
      packagetype.add('test5');
      System.assert([SELECT count() FROM Chemical_Package_Request__c
                     WHERE Package_Type__c IN :packagetype] == 0);
        
      
      Chemical_Request__c chereq= new Chemical_Request__c();
      Chemical_Package_Request__c lead1 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test1');
      Chemical_Package_Request__c lead2 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test2');
      Chemical_Package_Request__c lead3 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test3');
      Chemical_Package_Request__c[] leads = new Chemical_Package_Request__c[] {lead1, lead2, lead3};
      insert leads;
        
       
    
      lead2.Package_Type__c = 'test2';
      lead3.Package_Type__c = 'test3';
      update leads;
        
       
    
      Chemical_Package_Request__c dup1 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test1');
      try {
         insert dup1;
         
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 1);
         System.assert(e.getDmlIndex(0) == 0);
         System.assert(e.getDmlFields(0).size() == 1);

      } 
    
      dup1 = new Chemical_Package_Request__c(Id = lead1.Id, Chemical_Request__c=chereq.id,
                            Package_Type__c='test2');
      try {
         update dup1;
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 1);
         System.assert(e.getDmlIndex(0) == 0);
         System.assert(e.getDmlFields(0).size() == 1);
         
        }
    
         
      dup1 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test4');
      Chemical_Package_Request__c dup2 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test2');
      Chemical_Package_Request__c dup3 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test3');
      Chemical_Package_Request__c[] dups = new Chemical_Package_Request__c[] {dup1, dup2, dup3};
      try {
         insert dups;
        
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 2);
         System.assert(e.getDmlIndex(0) == 1);
         System.assert(e.getDmlFields(0).size() == 1);
         
         System.assert(e.getDmlIndex(1) == 2);
         System.assert(e.getDmlFields(1).size() == 1);
      }
    
       
    
      dup1 = new Chemical_Package_Request__c(Id=lead1.Id, Package_Type__c='test4');
      dup2 = new Chemical_Package_Request__c(Id=lead2.Id, Package_Type__c='test2');
      dup3 = new Chemical_Package_Request__c(Id=lead3.Id, Package_Type__c='test1');
      dups = new Chemical_Package_Request__c[] {dup1, dup2, dup3};
      try {
         update dups;
         
      } catch (DmlException e) {
         System.debug(e.getNumDml());
         System.debug(e.getDmlMessage(0));
         System.assert(e.getNumDml() == 1);
         System.assert(e.getDmlIndex(0) == 2);
         System.assert(e.getDmlFields(0).size() == 1);
        
        }
        
      
    
      dup1 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test4');
      dup2 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test4');
      dup3 = new Chemical_Package_Request__c(Chemical_Request__c=chereq.id,
                            Package_Type__c='test3');
      dups = new Chemical_Package_Request__c[] {dup1, dup2, dup3};
      try {
         insert dups;
         
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 2);
         System.assert(e.getDmlIndex(0) == 1);
         System.assert(e.getDmlFields(0).size() == 1);
         System.assert(e.getDmlIndex(1) == 2);
         System.assert(e.getDmlFields(1).size() == 1);
         
      }
      
      dup1 = new Chemical_Package_Request__c(Id=lead1.Id, Package_Type__c='test4');
      dup2 = new Chemical_Package_Request__c(Id=lead2.Id, Package_Type__c='test4');
      dup3 = new Chemical_Package_Request__c(Id=lead3.Id, Package_Type__c='test2');
      dups = new Chemical_Package_Request__c[] {dup1, dup2, dup3};
      try {
         update dups;
         
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 2);
         System.assert(e.getDmlIndex(0) == 1);
         System.assert(e.getDmlFields(0).size() == 1);
         System.assert(e.getDmlIndex(1) == 2);
         System.assert(e.getDmlFields(1).size() == 1);
         
      }
   }
}