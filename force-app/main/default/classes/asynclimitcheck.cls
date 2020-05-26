public with sharing class asynclimitcheck {
    @RemoteAction
    @readOnly
    public static Integer getTask(){
        return [select count() from AsyncApexJob  where CreatedDate >= :Datetime.now().addHours(-24) and (JobType = 'Future' or JobType = 'Batch Apex' or JobType = 'Queueable' or JobType = 'Scheduled Apex')];
     }
}