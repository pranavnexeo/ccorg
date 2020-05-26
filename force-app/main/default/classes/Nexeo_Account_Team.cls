/*Nexprice CPI Security*/
//Test method in "nexpriceCPI_security" class.

Public class Nexeo_Account_Team{

    public List<Nexeo_Account_Team__c> teammembers{get; set;}
    public boolean hasError{Get; set;}
    private string AccountId{Get; set;}

    public Nexeo_Account_Team(Apexpages.standardcontroller sc){
        AccountId = ((Nexeo_Account_Team__c)sc.getrecord()).Account__c;
        system.debug('AccountId is:'+AccountId);
        initteammembers();
        hasError = false;
    }

    private void initteammembers(){
          teammembers = new List<Nexeo_Account_Team__c>();
          for(integer i=0; i<5; i++)
            teammembers.add(new Nexeo_Account_Team__c(Account__c = AccountId));
         }

    public pagereference saveandmore(){
          return save(true);
    }

    public pagereference saveonly(){
          return save(false);
    }

    private pagereference save(boolean saveandmore){
          pagereference returl = new pagereference('/' + AccountId);
          List<Nexeo_Account_Team__c> toInsert = new list<nexeo_Account_Team__c>();
  
          for(Nexeo_Account_Team__c m:teammembers){
            if(m.user__c != null && m.Expiration_Date__c != null)
                toInsert.add(m);
          }
     
           if(toInsert.size() == 0){  
              hasError = true;
              ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Warning,'Please enter the details in at least one row.'));
              return null;
           }
           else{  
       try{
           if(toInsert != null && toInsert.size()>0)
            insert toInsert;
       }catch(Exception e){
            ApexPages.addMessages(e);
             return null;
         }
       
       if(saveandmore){ 
            initteammembers();
                return null;
        } else
             return returl;
    }
  }
}