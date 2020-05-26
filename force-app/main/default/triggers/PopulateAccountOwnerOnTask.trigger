trigger PopulateAccountOwnerOnTask on Task (before insert, before update) {

Set<String> AccountSet = new set<String>();

for(Task t:trigger.new){
AccountSet.add(t.AccountID);
}

List<Account> Accounts = [select id, Owner_Name__c from Account where id in :AccountSet];
Map<ID, String> OwnerMap = new Map<ID, String>();

for(Account a : Accounts){
OwnerMap.put(a.id, a.Owner_Name__c);
}

for(Task t:trigger.new){
t.Account_Owner__c = OwnerMap.get(t.AccountID);
if(t.WhatID == null)
{t.WhatID = t.AccountID;
system.debug('what: ' + t.whatid + ' AccID: ' + t.AccountID);}

}

}