/***********************************************************************************************************************   
Univar Solutions    
---------------------------------------------------------------------------------------------------------------------
*   Date Created:          04/15/2019
*   Author:                Parvez.B
*   Last Modified:         05/17/2019
*   Last Modified By:      Francisco Garcia.
*   Short Description:  Data Cleanup on Open_Orders__c object when Delivery_Date__c is 27+ months, should run monthly by scheduler.
*   **********************************************************************************************************************/
global class DataDeletion_OpenOrders implements  Database.Batchable<sObject> {
    
    global Database.QueryLocator start(Database.BatchableContext bc){ 
            Data_Deletion_Months__c myCS1 = Data_Deletion_Months__c.getValues('Open Orders');
            Integer numberofmonths = Integer.valueOf(myCS1.Months__c);
            if(numberofmonths >= 26) {
                system.debug('I am in >=26 loop' );
                date monthsAgo= date.today().addMonths(-numberofmonths);  
                system.debug('monthsAgo' + monthsAgo );
                system.debug('numberofmonths' + numberofmonths );
                //system.debug('FGG Number of Records' + Database.countQuery('SELECT count() FROM Open_Orders__c WHERE Agreed_Ship_Date2__c <:monthsAgo and id not in(select Open_Orders__c from NCAR_Line_Item__c where Open_Orders__c!=null)'));
                
                return Database.getQueryLocator('SELECT ID FROM Open_Orders__c WHERE Agreed_Ship_Date2__c <:monthsAgo and id not in(select Open_Orders__c from NCAR_Line_Item__c where Open_Orders__c!=null)'); 
              //return Database.getQueryLocator('SELECT ID FROM Open_Orders__c WHERE Agreed_Ship_Date2__c <:monthsAgo AND ID IN (\'a2FE0000000m5LG\',\'a2FE0000000m5cR\',\'a2FE0000000m5pC\',\'a2FE0000000l3Ut\',\'a2F44000002kumV\',\'a2F44000002kunI\',\'a2F44000002kuco\',\'a2F44000002ktiG\',\'a2FE0000000m1SB\',\'a2FE0000000mK4O\',\'a2FE0000000lrEp\',\'a2FE0000000mITB\')');
              //return Database.getQueryLocator('SELECT ID FROM Open_Orders__c WHERE Agreed_Ship_Date2__c <:monthsAgo AND ID IN (\'a2FE0000000m5LG\',\'a2FE0000000m5cR\',\'a2FE0000000m5pC\',\'a2FE0000000l3Ut\',\'a2F44000002kumV\',\'a2F44000002kunI\',\'a2F44000002kuco\',\'a2FE0000000m1SB\')');             
            }
            else{  
                system.debug('I am in < 26 loop' );
                Date monthsAgo= date.today().addMonths(-26);
                return Database.getQueryLocator('SELECT ID FROM Open_Orders__c WHERE Agreed_Ship_Date2__c <:monthsAgo and id not in(select Open_Orders__c from NCAR_Line_Item__c where Open_Orders__c!=null)'); 
              //return Database.getQueryLocator('SELECT ID FROM Open_Orders__c WHERE Agreed_Ship_Date2__c <:monthsAgo AND ID IN (\'a2FE0000000m5LG\',\'a2FE0000000m5cR\',\'a2FE0000000m5pC\',\'a2FE0000000l3Ut\',\'a2F44000002kumV\',\'a2F44000002kunI\',\'a2F44000002kuco\',\'a2F44000002ktiG\',\'a2FE0000000m1SB\',\'a2FE0000000mK4O\',\'a2FE0000000lrEp\',\'a2FE0000000mITB\')');     
              //return Database.getQueryLocator('SELECT ID FROM Open_Orders__c WHERE Agreed_Ship_Date2__c <:monthsAgo AND ID IN (\'a2FE0000000m5LG\',\'a2FE0000000m5cR\',\'a2FE0000000m5pC\',\'a2FE0000000l3Ut\',\'a2F44000002kumV\',\'a2F44000002kunI\',\'a2F44000002kuco\',\'a2FE0000000m1SB\')');     
            }
        }
    global void execute(Database.BatchableContext bc, List<Open_Orders__c> scopeOpenOrders){
            system.debug('scopeOpenOrders' + scopeOpenOrders.size() );
        
        try{
            if(!scopeOpenOrders.isEmpty()){
                delete scopeOpenOrders;            
            }
        }catch(Exception exp){
            System.debug('ERROR-DataDeletion_OpenOrders: '+exp.getMessage()+exp.getStackTraceString());
        }
    }            
     global void finish(Database.BatchableContext bc){
            System.debug('DataCleanupOpenOrders '+bc.getJobId());    
    }    
}