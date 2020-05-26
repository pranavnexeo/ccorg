@isTest
private class DonotallowrecordcreateTest {

    static testMethod void myUnitTest() {    
        
            Container_Specification_Document__c ContainerInfo=new Container_Specification_Document__c(Short_Description__c='test3',Package_Specification_Number__c='spec5', 
                                                                Issue_Date__c=Datetime.now());                
           insert ContainerInfo; 
            Container_Specification_Document__c ContainerInfo1=new Container_Specification_Document__c(Short_Description__c='test1',Package_Specification_Number__c='spec1', 
                                                                Issue_Date__c=Datetime.now());
            insert ContainerInfo1; 
            try{
            Closure_Specification_SubSection__c record1=new Closure_Specification_SubSection__c(); 
            record1.Container_Specification_Document_closure__c=ContainerInfo1.id;
            record1.Container_Specification_Document__c=ContainerInfo.id; 
            insert record1; 
            
           Closure_Specification_SubSection__c record2=new Closure_Specification_SubSection__c();     
            record2.Container_Specification_Document_closure__c=ContainerInfo1.id;
            record2.Container_Specification_Document__c=ContainerInfo.id;            
            insert record2;
            
             Closure_Specification_SubSection__c record3=new Closure_Specification_SubSection__c();     
            record3.Container_Specification_Document_closure__c=ContainerInfo1.id;
            record3.Container_Specification_Document__c=ContainerInfo.id;            
            insert record3;
            
             Closure_Specification_SubSection__c record4=new Closure_Specification_SubSection__c();     
            record4.Container_Specification_Document_closure__c=ContainerInfo1.id;
            record4.Container_Specification_Document__c=ContainerInfo.id;            
            insert record4;
            
           Closure_Specification_SubSection__c record5=new Closure_Specification_SubSection__c();     
            record5.Container_Specification_Document_closure__c=ContainerInfo1.id;
            record5.Container_Specification_Document__c=ContainerInfo.id;            
            insert record5;
            
            Closure_Specification_SubSection__c record6=new Closure_Specification_SubSection__c();     
            record6.Container_Specification_Document_closure__c=ContainerInfo1.id;
            record6.Container_Specification_Document__c=ContainerInfo.id;            
            insert record6;
            }
            catch (dmlException e){
            system.assertEquals(False,e.getDMLMessage(0).contains('Only 6 records can be created for this Combination Container record.'));
           }      
    }
}