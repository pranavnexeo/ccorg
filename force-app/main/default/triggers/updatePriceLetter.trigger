trigger updatePriceLetter on Price_Letter__c (before update) {

    List<String> plids = new List<String>();
    List<Price_Letter_Item__c> plisformap = new List<Price_Letter_Item__c>();
    Set<String> PLIdANDAccountIdMatCount = new Set<String>();
    Set<Account> PLAccounts = new Set<Account>();
    List<Account_Price_Letters__c> toInsert = new List<Account_Price_Letters__c>();
    List<Account_Price_Letters__c> aplRecord = new List<Account_Price_Letters__c>();
    
    Map<String, List<Price_Letter_Item__c>> PLIdItemListMap = new Map<String, List<Price_Letter_Item__c>>();
    
    for (Integer i = 0; i < Trigger.new.size(); i++) {
        plids.add(Trigger.new[i].id);
    }
    
    //Retrieve the list of Price List Items    
    List<Price_Letter_Item__c> plis = [select Price_Letter__c, Account_Material__c,Account_Material__r.Account__r.Name,Account_Material__r.Account__r.Sap_City__c,Account_Material__r.Account__r.Sap_State__c,Account_Material__r.Account__c,Account_Material__r.Account__r.SAP_Customer_Number__c from Price_Letter_Item__c where Price_Letter__c in: plids];
    
    for(Integer j=0;j<plis.size();j++){
        Integer count = 1;
        for(Integer l=0;l<plis.size();l++){
            
            if(j!= l && plis[j].Account_Material__r.Account__c == plis[l].Account_Material__r.Account__c 
                && plis[j].Price_Letter__c  == plis[l].Price_Letter__c ){
                
                count++;
            }
        }
        if(!PLIdANDAccountIdMatCount.contains(plis[j].price_letter__c + ',,,,'+plis[j].Account_Material__r.Account__r.SAP_Customer_Number__c+', '+plis[j].Account_Material__r.Account__r.Name+', '+plis[j].Account_Material__r.Account__r.SAP_City__c+', '+plis[j].Account_Material__r.Account__r.SAP_State__c+' - '+count))
            PLIdANDAccountIdMatCount.add(plis[j].price_letter__c + ',,,,'+plis[j].Account_Material__r.Account__r.SAP_Customer_Number__c+', '+plis[j].Account_Material__r.Account__r.Name+', '+plis[j].Account_Material__r.Account__r.SAP_City__c+', '+plis[j].Account_Material__r.Account__r.SAP_State__c+' - '+count);
        
        if(!PLAccounts.contains(plis[j].Account_Material__r.Account__r))
            PLAccounts.add(plis[j].Account_Material__r.Account__r);
    
    }
    
    for (Integer i = 0; i < Trigger.new.size(); i++) {
        String finalstring = '';
        List<String> tempList= new List<String>(PLIdANDAccountIdMatCount);  
        for(Integer l=0;l<tempList.size();l++){
            List<String> temp = tempList[l].split(',,,,');
            if(temp[0].equals(Trigger.new[i].id)){
                finalstring += temp[1] + '\n';
            }
        }
        Trigger.new[i].Customers__c = finalstring ;
    }
    
    aplRecord = [select Price_Letter__c from Account_Price_Letters__c where Price_Letter__c =: Trigger.new[0].id];
    if(aplRecord.size() == 0){
    for(Account a:PLAccounts){
        Account_Price_Letters__c apl = new Account_Price_Letters__c();
        system.debug('accnt:'+a.id);
        system.debug('pl:'+Trigger.new[0]);
        
        apl.Account__c = a.id;
        apl.Price_Letter__c = Trigger.new[0].id;
        toInsert.add(apl);
    }
     insert toInsert;
    }
     
    if(aplRecord.size() == 1){
       aplRecord[0].PL_Contacts__c = Trigger.new[0].sent_to__c;  
       
       
       update aplRecord;
    }
        
    
}