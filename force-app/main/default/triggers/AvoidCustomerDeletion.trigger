trigger AvoidCustomerDeletion on Account (before delete) {

   if(Trigger.isBefore && Trigger.isDelete) {
    
     for(account a :trigger.old){
        if((a.Type == 'Customer') && (userInfo.getProfileId() != '00e5A00000284nFQAQ') && (!(Test.isRunningTest())) )
            {
                a.addError('SAP Customer Accounts Cannot be Deleted.');
            }
    }

}

}