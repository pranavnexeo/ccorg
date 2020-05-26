trigger ActivityUserGroupTrigger on Activity_User_Group__c (before insert, before update, after insert, after update) {

    System.debug('===========================================================');
    
    if (Trigger.isBefore) {
        if (Trigger.isDelete) {
            System.debug('before record delete');
        } else if (Trigger.isInsert) {
            System.debug('before record insert');
            ActivityUserGroup_Functions.checkForDuplicate(Trigger.new);
        } else if (Trigger.isUpdate) {
            System.debug('before record update');
            ActivityUserGroup_Functions.checkForDuplicate(Trigger.new);
        }
    } else if (Trigger.isAfter) {
        if (Trigger.isDelete) {
            System.debug('after record delete');
        } else if (Trigger.isInsert) {
            System.debug('after record insert');
        } else if (Trigger.isUpdate) {
            System.debug('after record update');
        } else if (Trigger.isUndelete) {
            System.debug('after record undelete');
        }
    }

    System.debug('===========================================================');
    
}