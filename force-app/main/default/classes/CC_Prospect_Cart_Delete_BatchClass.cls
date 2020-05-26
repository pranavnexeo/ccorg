// Class Name: CC_Prospect_Cart_Delete_BatchClass 
// Developer Name: Sneha Likhar
// Functionality Description:  Batch Class to delete ccrz__E_Cart__c records of Prospect accounts.
// Last Modified By: Naren Karthik  Date: 03/28/2017.
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


global class CC_Prospect_Cart_Delete_BatchClass implements Database.Batchable<sObject>{

        global string q;
        global Id accRecordTypeId;
      
      
        global CC_Prospect_Cart_Delete_BatchClass(){
            accRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Portal Prospect').getRecordTypeId();
                          
            q = 'select id,ccrz__Storefront__c,ccrz__Account__c, ccrz__Account__r.recordtypeid,ccrz__Account__r.type ' + 'from ccrz__E_Cart__c '+ 'where ccrz__Storefront__c = \'mynexeo\''+ ' AND ccrz__Account__r.type = \'Prospect\'' + ' AND ccrz__Account__r.recordtypeid =: accRecordTypeId'; 
              
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