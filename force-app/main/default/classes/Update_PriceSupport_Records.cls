global class Update_PriceSupport_Records{
 
    public void update_Method(){
        
        List<Account> accountList = new List<Account>();
        List<Price_Support__c> priceSupportList = new List<Price_Support__c>();
        
        // select account ids as per checkbox
        accountList = [select id from Account where Sap_SalesGroup_Updated__c = TRUE];
        // select price support objects which are related to accounts queried
        priceSupportList = [select id,Support_Type__c,Customer_Type__c,Status__c,Customer_Name__r.SAP_SalesGroup__c, Customer_Name__r.SAP_Sales_Group_Desc__c,Customer_soldto__c from Price_Support__c where Customer_Name__c IN: accountList OR Customer_soldto__c IN:accountList];
        
        // update price support records with new values
        for(Price_Support__c ps: priceSupportList){
            system.debug('----------ps.Status__c-------'+ps.Status__c);
            if(ps.Customer_Type__c=='PY-Payer'){
             system.debug('----------Inside Payer-------'+ps.Status__c);
            system.debug('----------ps.Status__c-------'+ps.Status__c);
                if(ps.Support_Type__c == 'Rebate' && ps.Customer_soldto__c!=null  && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'&&(ps.Status__c=='Approved'||ps.Status__c=='Expired'))
                                 ps.SAP_Transfer__c = 'OPEN';
            }else if(ps.Support_Type__c == 'Rebate' && ps.Status__c!='Rejected' && ps.Status__c!='Cancelled'&&(ps.Status__c=='Approved'||ps.Status__c=='Expired')){
                ps.SAP_Transfer__c = 'OPEN';
            }   
        }
        update priceSupportList;
        
        // reset checkbox in account to FALSE
        for(Account acc: accountList){
            acc.Sap_SalesGroup_Updated__c = FALSE;
        }
        update accountList;
    }
}