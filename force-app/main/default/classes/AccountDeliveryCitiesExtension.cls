//Controller modified for "Delivery City migration" enhancement.
//Modified by Rajeev.


public class AccountDeliveryCitiesExtension{

//Initializing variables
public Account Acct{get;set;}
public List<Delivery_Cities__c> DC{get; set;}
public Integer dcsize{get;set;}

   //Constructor
   public AccountDeliveryCitiesExtension(ApexPages.StandardController controller) {
       Acct = (Account)Controller.getRecord();
       DC = new List<Delivery_Cities__c>();
       Acct = [Select Id, SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_ShippingPlant__c from Account where Id = :Acct.Id limit 1];
       DC = [Select Id,
                    Name,
                    State__c,
                    SAP_Plant__c,
                    SAP_Plant__r.Plant_Code__c,
                    SAP_Plant__r.Plant_Name__c,
                    Default_plant__c,
                    ship__c,
                    mon__c,
                    tues__c,
                    wed__c,
                    thur__c,
                    fri__c
                    from Delivery_Cities__c
                    where (zip__c = :Acct.SAP_Zip_Code__c) or (state__c = :Acct.SAP_State__c and
                    name = :Acct.SAP_City__c)];
                    
       dcsize = DC.size();
    }

}
/*End*/