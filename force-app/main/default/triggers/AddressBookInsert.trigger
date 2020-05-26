/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        10/10/2016
*   Author:              Shwetha Suvarna
*   Last Modified:       10/13/2016
*   Last Modified By:    Shwetha Suvarna
*
*   Short Description:   This trigger creates addressBook record on creation of contact address
*   **********************************************************************************************************************/

trigger AddressBookInsert on ccrz__E_ContactAddr__c (After Insert) {
    List<ccrz__E_AccountAddressBook__c> addrsBookList = new List<ccrz__E_AccountAddressBook__c>();
    id accid;
    string type,id;    
    for(ccrz__E_ContactAddr__c c : trigger.new){
    if(c.Storefront__c=='mynexeo'){
        System.debug('@@ship'+c.AccountId_Shipping__c);
        accid = c.AccountId_Shipping__c.split('-')[0];
        id = accid;
        type = c.AccountId_Shipping__c.split('-')[1];
        ccrz__E_AccountAddressBook__c aa = new ccrz__E_AccountAddressBook__c(ccrz__Account__c=accid,ccrz__AccountId__c=id,ccrz__AddressType__c=type,ccrz__E_ContactAddress__c=c.id,ccrz__Default__c=true,ccrz__TypeReadOnly__c=true);
        addrsBookList.add(aa);}
    }
    System.debug('@@book '+addrsBookList.size());
    if(addrsBookList.size()>0){
        insert addrsBookList;
    }
}