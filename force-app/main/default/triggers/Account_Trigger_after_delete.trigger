trigger Account_Trigger_after_delete on Account (after delete) {

    if (Trigger.isAfter && Trigger.isDelete) {
        System.debug('trigger on account after delete');
        //Account_Functions.validateAndLogForDelete(Trigger.old);
        Account_Functions.deletAccountDirectory(Trigger.old);
    }
    
}