/*@LAB Project.
 *Trigger to share record based on certain criteria.
 *Apex Managed Sharing.
 *@Rajeev
*/


trigger SampleAnalysisRecordSharing on Sample_Analysis_Request__c (after insert,after update) {
    /*Initalizing variables*/
    List<Sample_Analysis_Request__share> sarShareList  = new List<Sample_Analysis_Request__share>();
    Map<Id,Account> CustomerMap;
    Map<Id,String> errormap = new Map<Id,String>();
    Set<Id> AccountIds = new Set<Id>();
    Sample_Analysis_Request__share sarCreator;
    Sample_Analysis_Request__share relatedUser;
    Sample_Analysis_Request__share requestor;
    Set<Id> recordIds = new Set<Id>();
    
    /*delete existing sharing records if the record is updated*/
    if(trigger.IsUpdate){
     List<Sample_Analysis_Request__share> deleteshares = [Select Id, RowCause from Sample_Analysis_Request__share where ParentID IN :trigger.new and RowCause != 'Owner'];
      if(deleteshares.size()>0){
        delete deleteshares;
    }
   }

    /*query related account id*/
    for(Sample_Analysis_Request__c sar : trigger.new){
        recordIds.add(sar.Id);
        if(sar.Customer__c != null)
            AccountIds.add(sar.Customer__c);
    }
    
    /*create map of account id and account*/
    if(AccountIds != null && AccountIds.size()>0){
      CustomerMap = new Map<Id,Account>([Select Id, OwnerId, Owner.IsActive from Account where Id In :AccountIds]);
    }


    /*Modify all the records for sharing after the records are inserted*/
    for(Sample_Analysis_Request__c sar : [Select Id,CreatedById,CreatedBy.IsActive,
                                          Requested_by__c,Requested_by__r.IsActive,Customer__c from
                                          Sample_Analysis_Request__c where Id In :recordIds]){
          
                       
          sarCreator = new Sample_Analysis_Request__share();
          sarCreator.ParentId = sar.Id;
          sarCreator.AccessLevel = 'Edit';
          sarCreator.RowCause = Schema.Sample_Analysis_Request__share.RowCause.Creator__c;
             
        if(sar.CreatedById != null && sar.CreatedBy.IsActive == true){
          sarCreator.UserOrGroupId = sar.CreatedById;
           sarShareList.add(sarCreator);
        }
        
          relatedUser = new Sample_Analysis_Request__share();
          relatedUser.ParentId = sar.Id;
          relatedUser.AccessLevel = 'Read';
          relatedUser.RowCause = Schema.Sample_Analysis_Request__share.RowCause.Related_User__c;
        
        if(sar.Customer__c != null){
         Account relatedAccount = CustomerMap.get(sar.Customer__c);
          if((relatedAccount.OwnerId != null) && (relatedAccount.Owner.IsActive == true)){
           relatedUser.UserOrGroupId = relatedAccount.OwnerId;
            sarShareList.add(relatedUser);
        }
       } 
          
          requestor = new Sample_Analysis_Request__share();
          requestor.ParentId = sar.Id;
          requestor.AccessLevel = 'Edit';
          requestor.RowCause = Schema.Sample_Analysis_Request__share.RowCause.Requestor__c;
        
        if(sar.Requested_by__c != null && sar.Requested_by__r.IsActive == true){
          requestor.UserOrGroupId = sar.Requested_by__c;
           sarShareList.add(requestor);
        }  
    }

    /*insert the sharing objects into the database*/
    Database.SaveResult[] lsr = Database.insert(sarShareList,false); 
        Integer i=0;
         for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                Database.Error err = sr.getErrors()[0];
                 if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                      &&  err.getMessage().contains('AccessLevel'))){
                        trigger.newMap.get(sarShareList[i].ParentId).addError('Unable to grant sharing access due to following exception: ' +err.getMessage());                          
                }
            }
            i++;
        }
}