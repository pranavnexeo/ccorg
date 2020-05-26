public without sharing class cc_mn_imp_viewcredit 
{
    
    public static Account getAccountForViewCreditRequest(String accountId)
    {
         Account iaccount =  [SELECT ID,
                                   SAP_Payer_Account_Id__c
                            FROM Account     
                            WHERE
                                 ID =: accountId];
         system.debug('---------------payer------'+iaccount.SAP_Payer_Account_Id__c);
        
         Account payeraccount =  [SELECT ID,
                                  SAP_DistChannel__c,
                                  SAP_DivisionCode__c,
                                  SAP_Sales_Org__c,
                                  SAP_Customer_Number__c
                                  FROM Account   
                                  WHERE ID =: (Id)iaccount.SAP_Payer_Account_Id__c];
        system.debug('-----------account--------'+payeraccount.SAP_Customer_Number__c);

        return payeraccount;

    }

}