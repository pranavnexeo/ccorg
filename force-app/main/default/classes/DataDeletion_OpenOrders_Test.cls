/***********************************************************************************************************************   
Univar Solutions    
---------------------------------------------------------------------------------------------------------------------
*   Date Created:          04/15/2019
*   Author:                Parvez.B
*   Last Modified:       
*   Last Modified By:    
*   Short Description:  Data Cleanup on Open_Orders__c object when Delivery_Date__c is 27+ months, should run monthly by scheduler.
*   **********************************************************************************************************************/
@isTest 
private class DataDeletion_OpenOrders_Test {
        
    static testmethod void test() {   
        
        Data_Deletion_Months__c cs = new Data_Deletion_Months__c();
        cs.name='Open Orders';
        cs.Months__c='26';
        insert cs;
        
         Account acc = new Account();
         acc.Name = 'Test Account';
         acc.SAP_Street__c='1 Waterway Ave';  
         acc.SAP_City__c ='The Woodlands';
         acc.SAP_State__c ='Texas';
         acc.SAP_Zip_Code__c ='77380';
         acc.SAP_Country__c ='US';
         insert acc; 
         
         list<Open_Orders__c> oolist = new list<Open_Orders__c>();
         for(integer i=0; i<200; i++){
         Open_Orders__c oo = new Open_Orders__c();
         oo.Sales_Order_Number__c='0005259557';
         oo.ShipTo__c=acc.Id;
         oo.Line_Item_Number__c='0010'+i;
         oo.Key__c='0005259592000010'+i; 
         oo.Agreed_Ship_Date2__c = system.today().addMonths(-28);
             system.debug('Date is '+oo.Agreed_Ship_Date2__c);
         oolist.add(oo);   
         }
         insert oolist;
        
         Data_Deletion_Months__c myCS1 = Data_Deletion_Months__c.getValues('Open Orders');
         Integer numberofmonths = Integer.valueOf(myCS1.Months__c);
         date monthsAgo= oolist[0].Agreed_Ship_Date2__c.addMonths(24);
        
         system.debug('Date monthsAgo '+monthsAgo);
         system.assertEquals(200, [select count() from Open_Orders__c]);
         //system.assertEquals(200, [select count() from Open_Orders__c WHERE Agreed_Ship_Date2__c < :monthsAgo ]);
        
        /* NCAR_Cases__c nc = new NCAR_Cases__c();
         insert nc;
         system.assertEquals(1, [select count() from NCAR_Cases__c]); 
        
         NCAR_Line_Item__c ncl = new NCAR_Line_Item__c();
         ncl.Open_Orders__c = oolist[0].id;
         ncl.NCAR_Cases__c = nc.id;
         insert ncl;
         system.assertEquals(1, [select count() from NCAR_Line_Item__c]); */
     
         Test.startTest();
         DataDeletion_OpenOrders oob = new DataDeletion_OpenOrders();
         Database.executeBatch(oob);
         Test.stopTest();
   }
}