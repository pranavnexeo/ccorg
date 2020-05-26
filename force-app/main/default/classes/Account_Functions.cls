public class Account_Functions {

    private static final String OBJECT_NAME = 'Account';
    private static final String DELETE_ERR = '***** Delete failed - Non Prospect Account cannot be deleted *****';
    private static final String MERGE_ERR = getMergeErrorMsg();
    private static final Map<Id,String> RT_MAP = RecordType_Functions.RetrieveRecordTypeIdMap(OBJECT_NAME);
    private static final Set<String> MRT_SET = Merging_Record_Type_Functions.getMergingRecordTypes(OBJECT_NAME);

  public static double Calculate_Account_Age_in_Days(Id accountId) {
    Double account_Age = 0;
    Date createdDate;
    
    createdDate = Date_Functions.convertDateTimetoDate([SELECT CreatedDate FROM Account WHERE Id = :accountId].CreatedDate);
    account_Age = createdDate.daysBetween(System.today());
    System.debug('Created Date = ' + createdDate);
    System.debug('Today = ' + System.today());
    System.debug('Account Age = ' + account_Age);
    
    return account_Age;
  
  }

  public static Boolean isNewProspect(Id accountId) {
  
    Boolean result = false;  
    String accountType = '';
    Double accountAge = 0;
  
    System.debug('accountId = ' + accountId);
    
    Account acct = [SELECT RecordTypeId FROM Account WHERE Id = :accountId];
  
    accountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(acct.RecordTypeId);
    System.debug('accountType = ' + accountType);
    if (accountType == 'Prospect')
      {
      accountAge = Calculate_Account_Age_in_Days(accountId);
      if (accountAge <= 30) {result = true;}
      }

    return result;
    
  }

  public static Account Select_Fields_Needed_for_Sample_Requests(Id accountId) {
    Account result = null;
    List<Id> accountIds = new List<Id>();
    accountIds.add(accountId);
    List<Account> accounts = Select_Fields_Needed_for_Sample_Requests(accountIds);
    if (accounts.size() > 0) {result = accounts[0];}
    return result;
  }

  public static List<Account> Select_Fields_Needed_for_Sample_Requests(List<Id> accountIds) {
        List<Account> accounts = [SELECT  id,
                                           Name,
                                           OwnerId,
                                           Owner.Name,
                                           AccountNumber,
                                           SAP_Street__c,
                                           SAP_StreetSuppl1__c,
                                           SAP_StreetSuppl2__c,
                                           SAP_StreetSuppl3__c,
                                           SAP_City__c,
                                           SAP_State__c,
                                           SAP_Zip_Code__c,
                                           SAP_Country__c,
                                           SAP_Customer_Number__c,
                                           SAP_SALES_ORG__C,
                                           SAP_SALES_OFFICE__C,
                                           SAP_SALES_OFFICE_DESC__C,
                                           SALESOFFICE__C,
                                           SAP_DISTCHANNEL__C,
                                           SAP_DIST_CHANNEL_DESC__C,
                                           SAP_DIVISIONCODE__C,
                                           SAP_DIVISION_DESC__C,
                                           SAP_SALESGROUP__C,
                                           SAP_SALES_GROUP_DESC__C,
                                           SAP_SALESDISTRICT__C,
                                           SAP_SALES_DISTRICT_DESC__C,
                                           SAP_REGION__C,
                                           SAP_Customer_Group__c,
                                           SAP_Customer_Group_1__c,
                                           SAP_Customer_Group_2__c,
                                           SAP_Customer_Group_3__c,
                                           SAP_Customer_Group_4__c,
                                           SAP_Customer_Group_5__c,
                                           SAP_CSR__c, 
                                           SAP_CSR_Email__c,
                                           RecordTypeId,
                                           RecordType.Name
                                           FROM Account WHERE Id IN :accountIds];
    return accounts;                                                        
  }
  
    public static void printAccounts(Account[] aa) {
        for (Account a : aa) {
            String rectype = getRecordType(a);
            System.debug('Account             Id : '+a.id);
            System.debug('Account MasterRecordId : '+a.masterRecordId);
            System.debug('Account           Name : '+a.name);
            System.debug('Account          Phone : '+a.phone);
            System.debug('Account    Record Type : '+rectype);
        }
    }
  /*
    public static void validateAndLogForDelete(Account[] aa) {
        printAccounts(aa);
        boolean isAdmin = User_Functions.isSysAdmin() || User_Functions.isSupport();
        List<Audit_Log__c> logs = new List<Audit_Log__c>();
        for (Account a : aa) {
            String rectype = getRecordType(a);
            String masterRecId = a.masterRecordId;
            if (!isAdmin && !MRT_SET.contains(rectype)) {
                if (masterRecId != null) {
                   a.addError(MERGE_ERR);
                } else {
                   a.addError(DELETE_ERR);
                }
            } else {
                logs.add(Audit_Log_Functions.createLogForDeleted(OBJECT_NAME,rectype,a.id,a.Name));
            }
        }
        Audit_Log_Functions.insertAuditLogs(logs);
    } */
    
    private static String getRecordType(Account a) {
        String rectype = '';
        System.debug('Record Type Id: '+a.RecordTypeId);
        if (RT_MAP.containsKey(a.RecordTypeId)) {
           rectype = RT_MAP.get(a.RecordTypeId);
        }   
        System.debug('Record Type : '+rectype);
        return rectype;
    }
    
    private static String getMergeErrorMsg() {
        String s = '<br/><div style="text-align:center;font-weight:bold">';
        s += 'Merge failed for one of the following reasons:<br/>';
        s += '1. Prospect Account cannot be the Master Record when merging with a Customer Account.<br/>';
        s += '2. Cannot merge two Customer Accounts together.<br/>';
        s += '</div><br/>'; 
        return s;
    }
    public static void deletAccountDirectory(List<Account> aList){
        Set<String> accNumbers = new Set<String>();
        List<Account_Directory__c> adList = new List<Account_Directory__c>();
        for(Account a : aList){
            if(a.Type=='Customer')
              accNumbers.add(a.Account_Number__c);
            else if(a.Type=='Prospect')
                accNumbers.add(a.CIS_Prospect_Number__c);
        }
        if(!accNumbers.isEmpty())
        	adList = [Select Id, Account_Id__c from Account_Directory__c where Record_Key__c in: accNumbers and Record_Key__c<>''];
        if(!adList.isEmpty()){
            delete adList;
        }
    }

//******************
//Test Method 
//******************
  static testMethod void TestMe() {
    Test.startTest();
    testAccountAgeInDays();
    
    testAccountDelete('System Administrator');
    //testAccountDelete('W-Standard User');
    Test.stopTest();
  }
  
  private static void testAccountAgeInDays() {

    Account[] accts = new Account[]{}; 
    Account acct1 = new Account();
    Account acct2 = new Account();
    
    acct1.Name = 'Test 1';
    acct2.Name = 'Test 2';
    
    acct1.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Prospect','Account');
    acct1.Type = 'Prospect';
    acct2.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Prospect','Account');
    acct2.Type = 'Customer';
    
    accts.add(acct1);
    accts.add(acct2);
    
    insert accts;
    

    Double age = Calculate_Account_Age_in_Days(acct1.id);
    Boolean isnew1 = isNewProspect(acct1.id);
    Boolean isnew2 = isNewProspect(acct2.id);
  
    System.debug('isnew1 = ' + isnew1);
    System.debug('isnew2 = ' + isnew2);
    
    Account testacct = Select_Fields_Needed_for_Sample_Requests([SELECT Id FROM Account LIMIT 1].Id);

  }
  
  private static void testAccountDelete(String profileName) {
    
    //Distribution Prospect
    //Distribution Prospect
    /*
    Id prospectRecordTypeId = [select Id from RecordType 
                                where Name = 'Water Prospect' 
                                  and sObjectType = 'Account' limit 1].Id;
    
    Id accountRecordTypeId  = [select Id from RecordType 
                                where Name = 'Drew Customer' 
                                  and sObjectType = 'Account' limit 1].Id;
     */                             
                                  
    
    Id prospectRecordTypeId = [select Id from RecordType 
                                where Name = 'Distribution Prospect' 
                                  and sObjectType = 'Account' limit 1].Id;
    
    Id accountRecordTypeId  = [select Id from RecordType 
                                where Name = 'Distribution Customer' 
                                  and sObjectType = 'Account' limit 1].Id;
    
    Account prospectAccount = new Account();
    prospectAccount.Name = 'Prospect';
    prospectAccount.RecordTypeId = prospectRecordTypeId;
    
    Account regularAccount = new Account();
    regularAccount.Name = 'Account';
    regularAccount.RecordTypeId = accountRecordTypeId;
    
    Account[] aa = new Account[] {prospectAccount, regularAccount};
    insert aa;
    printAccounts(aa);
    
    Profile p = [select id from profile 
                  where name=:profileName];
    User u = [select id from user 
               where profileid = :p.Id
                 and isActive = true 
               limit 1];
    
    if (u != null) {
        System.runAs(u) {
            try {
                delete prospectAccount;
                // merge regularAccount prospectAccount;
            } catch(Exception e) {
                System.debug(e.getMessage());
                //validateAndLogForDelete(aa);
            }
        }
    }
    
  }

//The End
}