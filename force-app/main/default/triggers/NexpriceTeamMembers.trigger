trigger NexpriceTeamMembers on Nexeo_Account_Team__c (after insert,after update,after delete) {
    if(trigger.isDelete){
    Nexprice_Account_Team_Functions.deleteSharingRecords(trigger.old);
    }else{
    Nexprice_Account_Team_Functions.createSharingRecords(trigger.new,trigger.isInsert);
    }
}