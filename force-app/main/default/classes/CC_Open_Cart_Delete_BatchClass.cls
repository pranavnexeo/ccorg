// Class Name: CC_Open_Cart_Delete_BatchClass 
// Developer Name: Naren Karthik
// Functionality Description:  Batch Class to delete ccrz__E_Cart__c records in open status for prolonged duration.
// Last Modified By: Naren Karthik  Date: 04/07/2017.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


global class CC_Open_Cart_Delete_BatchClass implements Database.Batchable<sObject>{

        global string q;

        global CC_Open_Cart_Delete_BatchClass (){
            String daysold_3 = String.valueof(system.today().addDays(-3))+'T00:00:00Z';
            String daysold_5 = String.valueof(system.today().addDays(-5))+'T00:00:00Z';
            if(Test.isRunningTest())
            {
                q = 'select id,ccrz__Storefront__c,ccrz__Account__c from ccrz__E_Cart__c where ' + '(ccrz__Storefront__c = \'nexeo3d\' AND ccrz__CartStatus__c = \'Open\')' + ' OR ' + '(ccrz__Storefront__c = \'mynexeo\' AND ccrz__CartStatus__c = \'Open\')';
            }
            else
            {
                q = 'select id,ccrz__Storefront__c,ccrz__Account__c from ccrz__E_Cart__c where ' + '(ccrz__Storefront__c = \'nexeo3d\' AND ccrz__CartStatus__c = \'Open\' AND LastModifiedDate < ' + daysold_3 + ')' + ' OR ' + '(ccrz__Storefront__c = \'mynexeo\' AND ccrz__CartStatus__c = \'Open\' AND LastModifiedDate < ' + daysold_5 + ')';
            }
        }
       
        // Start Method
        global Database.QueryLocator start(Database.BatchableContext BC){
           return Database.getQueryLocator(q);
        }
      
      // Execute Logic
       global void execute(Database.BatchableContext BC, List<ccrz__E_Cart__c>ccCartList){
              if(ccCartList.size()>0)
              delete ccCartList;
     
       }
     
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
    }