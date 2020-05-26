@isTest
public class CompatibilityDuplicatePreventerTests{
    static testMethod void testCompatibilityDuplicatePreventer() {
        
    
      Set<String> compatibility = new Set<String>();
      Set<String> container=new Set<String>();
      compatibility.add('compatible');
      compatibility.add('noncompatible');
      compatibility.add('standard');
      
      System.assert([SELECT count() FROM Container_Chemical_Junction__c
                     WHERE Compatibility__c IN :compatibility and Container_Specification_Document__c IN : container] == 0);
        
      
      Chemical_Package_Request__c chereq= new Chemical_Package_Request__c(Package_Type__c='Bags');
      insert chereq;
      
      Container_Specification_Document__c con1= new Container_Specification_Document__c(Short_Description__c='Test1',Package_Specification_Number__c='spec1',Issue_Date__c=Datetime.now());
      Container_Specification_Document__c con2= new Container_Specification_Document__c(Short_Description__c='Test2',Package_Specification_Number__c='spec2',Issue_Date__c=Datetime.now());
      Container_Specification_Document__c con3= new Container_Specification_Document__c(Short_Description__c='Test3',Package_Specification_Number__c='spec3',Issue_Date__c=Datetime.now());
      Container_Specification_Document__c con4= new Container_Specification_Document__c(Short_Description__c='Test4',Package_Specification_Number__c='spec4',Issue_Date__c=Datetime.now());
      Container_Specification_Document__c con5= new Container_Specification_Document__c(Short_Description__c='Test5',Package_Specification_Number__c='spec5',Issue_Date__c=Datetime.now());
      Container_Specification_Document__c con6= new Container_Specification_Document__c(Short_Description__c='Test6',Package_Specification_Number__c='spec6',Issue_Date__c=Datetime.now());
      Container_Specification_Document__c con7= new Container_Specification_Document__c(Short_Description__c='Test7',Package_Specification_Number__c='spec7',Issue_Date__c=Datetime.now());
      Container_Specification_Document__c[] rec = new Container_Specification_Document__c[] {con1, con2, con3, con4, con5, con6, con7};
      insert rec;
      
      Container_Chemical_Junction__c lead1 = new Container_Chemical_Junction__c(Chemical_Package_Request__c= chereq.id,
                            Compatibility__c='compatible',Container_Specification_Document__c=con1.id);
      insert lead1;
      Container_Chemical_Junction__c lead2 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='noncompatible',Container_Specification_Document__c=con2.id);
      insert lead2;
      Container_Chemical_Junction__c lead3 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='standard',Container_Specification_Document__c=con3.id);
      insert lead3;
          
       
    
      Container_Chemical_Junction__c dup1 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='compatible',Container_Specification_Document__c=con1.id);
      try {
         insert dup1;
         
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 1);
         System.assert(e.getDmlIndex(0) == 0);
         System.assert(e.getDmlFields(0).size() == 1);

      } 
    
       
         
      dup1 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='compatible',Container_Specification_Document__c=con4.id);
      Container_Chemical_Junction__c dup2 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='noncompatible',Container_Specification_Document__c=con5.id);
     
      Container_Chemical_Junction__c[] dups = new Container_Chemical_Junction__c[] {dup1, dup2};
      try {
         insert dups;
        
      } catch (DmlException e) {
         System.assert(e.getNumDml() == 2);
         System.assert(e.getDmlIndex(0) == 1);
         System.assert(e.getDmlFields(0).size() == 1);
         
         System.assert(e.getDmlIndex(1) == 2);
         System.assert(e.getDmlFields(1).size() == 1);
      }
    
       
    
      dup1 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='Standard', Container_Specification_Document__c=con4.id);
      dup2 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='compatible', Container_Specification_Document__c=con6.id);
      
      dups = new Container_Chemical_Junction__c[] {dup1, dup2};
      try {
         insert dups;
         
      } catch (DmlException e) {
                  
      }
      
      dup1 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='compatible', Container_Specification_Document__c=con4.id);
      dup2 = new Container_Chemical_Junction__c(Chemical_Package_Request__c=chereq.id,
                            Compatibility__c='noncompatible', Container_Specification_Document__c=con7.id);
      
      dups = new Container_Chemical_Junction__c[] {dup1, dup2};
      try {
         insert dups;
         
      } catch (DmlException e) {
         
         
      }
   }
}