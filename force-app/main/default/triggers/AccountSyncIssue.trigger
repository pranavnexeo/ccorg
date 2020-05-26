trigger AccountSyncIssue on Integration_Error__c (Before Insert, Before Update) {

    for(Integration_Error__c  ie : Trigger.New){
    
        if(ie.Email__c.contains('INVALID_FIELD:Foreign key external ID:')){
            ie.Error_Type__c = 'Foreign key external ID - Seller';
        }
        else if(ie.Email__c.contains('DUPLICATE_EXTERNAL_ID:CIS Account Number: more than one record found for external id field:')){
            ie.Error_Type__c = 'KNA1 Account';
        }
        else if(ie.Email__c.contains('while updating the partner function(Payer) for Idoc')){
            ie.Error_Type__c = 'Account Does not Exists (Payer)';
        }
        else if(ie.Email__c.contains('INVALID_CROSS_REFERENCE_KEY:Relationship Manager: owner cannot be blank')){
            ie.Error_Type__c = 'Blank Owner';
        }
        else if(ie.Email__c.contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY:Territory_Before_Upsert: execution of BeforeUpdate')){
            ie.Error_Type__c = 'Salesforce Trigger(SAP Territory)';
        }
        else if(ie.Email__c.contains('INVALID_FIELD_FOR_INSERT_UPDATE:Attempting to update (as part of an upsert) parent field Account__c with new value')){
            ie.Error_Type__c = 'Duplicate Account Number and CIS number';
        }
        else if(ie.Email__c.contains('DUPLICATE_EXTERNAL_ID:VendorUniqueId: more than one record found for external id field:')){
            ie.Error_Type__c = 'Vendor Account';
        }
        else if(ie.Email__c.contains('UNABLE_TO_LOCK_ROW:unable to obtain exclusive access to this record')){
            ie.Error_Type__c = 'Unable to Lock Record';
        }
        else if(ie.Email__c.contains('DUPLICATE_VALUE:duplicate value found: Record_Key__c duplicates value on record with id:')){
            ie.Error_Type__c = 'Duplicate Record Key';
        }
        else if(ie.Email__c.contains('while updating the partner function(Bill To) for Idoc#:')){
            ie.Error_Type__c = 'Account Does not Exists (Bill To)';
        }
        else if(ie.Email__c.contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY:SAP_Territory_After_Upsert: execution of AfterUpdate')){
            ie.Error_Type__c = 'Salesforce Trigger(SAP Territory)';
        }
        else if(ie.Email__c.contains('CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY:Account_Trigger_Before_Upsert_After_Upsert: execution of AfterUpdate')){
            ie.Error_Type__c = 'Salesforce Trigger(Account)';
        }
    
        else {
            ie.Error_Type__c = 'Other';
        }
    }
}