public without sharing class  UserTriggerHandler {
    
      public UserTriggerHandler(){
            
      }
    
      public void OnAfterInsert(User[] newRecords){
          cc_imp_StorefrontSettings__c customSetting = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
          Map<Id, String> contactIdMap = new Map<Id, String>();
          for (User newUser  :newRecords) {
              if (customSetting != null) {
                  if (newUser.ProfileId == customSetting.Profile_Id__c) {
                      contactIdMap.put(newUser.ContactId, newUser.LocaleSidKey);
                  }
              }
          }
          
          if (!contactIdMap.isEmpty()) {
              this.updateLocaleOnContact(contactIdMap);
          }
      }
    
    
      public void OnAfterUpdate(User[] oldRecords, User[] updatedRecords, Map<ID, User> recordMap){
    	cc_imp_StorefrontSettings__c customSetting = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
          Map<Id, String> contactIdMap = new Map<Id, String>();
          for (Integer i = 0; i < updatedRecords.size(); i++) {
               User newUser = updatedRecords.get(i);
               User oldUser = oldRecords.get(i);
               if (customSetting != null) {
                  if (newUser.ProfileId == customSetting.Profile_Id__c && newUser.LocaleSidKey != oldUser.LocaleSidKey) {
                      contactIdMap.put(newUser.ContactId, newUser.LocaleSidKey);
                  }
               }
          }
          
          if (!contactIdMap.isEmpty()) {
              this.updateLocaleOnContact(contactIdMap);
          }
      }

    private void updateLocaleOnContact(Map<Id, String> contactIdMap) {
        List<Contact> contactsToUpdate = new List<Contact>();
            for (Contact contactToUpdate:[SELECT Id, User_Locale__c FROM Contact Where Id in :contactIdMap.keySet()]) {
            		String userLocale = contactIdMap.get(contactToUpdate.Id);
                    if (null != userLocale) {
                        if (contactToUpdate.User_Locale__c != userLocale) {
                            contactToUpdate.User_Locale__c = userLocale;
                            contactsToUpdate.add(contactToUpdate);
                        }
                    }
        	}
        
        if (!contactsToUpdate.isEmpty()) {
            update contactsToUpdate;
        }
    }

}