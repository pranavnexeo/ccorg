public class RecordType_Relationship_Functions {

  public static List<String> Update_RecordType_Relationship_Ids() {
    List<String> results = new List<String>();
    Id newParentRecordTypeId;
    Id newChildRecordTypeId;
    Map<String, Id> recordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap();
    List<RecordType_Relationship__c> rr;
    try {    
        rr = [SELECT Id,
                    Child_Name__c,
                    Child_RecordTypeId__c,
                    Child_SobjectType__c,
                    Parent_Name__c,
                    Parent_RecordTypeId__c,
                    Parent_SobjectType__c
               FROM RecordType_Relationship__c];
        } catch (Exception e) {}
        
    if (rr != null)
      {
      for (RecordType_Relationship__c r:rr)
        {
          newParentRecordTypeId = recordTypeMap.get(r.Parent_Name__c + '-' + r.Parent_SobjectType__c);
          newChildRecordTypeId = recordTypeMap.get(r.Child_Name__c + '-' + r.Child_SobjectType__c);
          if (newParentRecordTypeId == null) {results.add('Error: Could not locate Parent RecordType:' + r.Parent_Name__c + ' : ' + r.Parent_SobjectType__c);}
          if (newChildRecordTypeId == null) {results.add('Error: Could not locate Child RecordType:' + r.Child_Name__c + ' : ' + r.Child_SobjectType__c);}
          r.Parent_RecordTypeId__c = newParentRecordTypeId;
          r.Child_RecordTypeId__c = newChildRecordTypeId;
        }
      if (results.size() == 0)  
        {update rr;}
      else
        {results.add('Due to the previous errors, no records were updated.');
         System.debug('Update_RecordType_Relationship_Ids Errors:');
         for(String result:results) {System.debug(result);}
        }
      } else {results.add('Error: No records in the RecordType_Relationship__c Table!');}
        
          
    return results;
  }


  public static List<RecordType_Relationship__c> RecordType_Relationships;

  public static void populateRecordType_Relationships() {
        if (RecordType_Relationships == null)
          {
          RecordType_Relationships = [SELECT Parent_RecordTypeId__c, Business__c, Parent_SubType__c FROM RecordType_Relationship__c];
          }                                                
    
  }


  public static String GetBusinessType_Based_on_AccountRecordTypeId(Id AccountRecordTypeId)
    {
      String result;

      populateRecordType_Relationships();

        for (RecordType_Relationship__c RecordType_Relationship : RecordType_Relationships)
          {
          if(RecordType_Relationship.Parent_RecordTypeId__c == AccountRecordTypeId) {result = RecordType_Relationship.Business__c;}
          }

      return result;                               
    }

  public static String GetAccountType_Based_on_AccountRecordTypeId(Id AccountRecordTypeId)
      {
        String result = '';

      populateRecordType_Relationships();

        for (RecordType_Relationship__c RecordType_Relationship : RecordType_Relationships)
          {
          if(RecordType_Relationship.Parent_RecordTypeId__c == AccountRecordTypeId) {result = RecordType_Relationship.Parent_SubType__c;}
          }

      return result;
      }

  public static Map<Id, String> GetAccountType_Based_on_AccountRecordTypeId(List<Id> AccountRecordTypeIds) {
    Map<Id,String> results = new Map<Id,String>();
    List<RecordType_Relationship__c> recordTypeRelationships;

    try {
          recordTypeRelationships = [SELECT 
                                           id, 
                                           Business__c,
                                           Parent_RecordTypeId__c,
                                           Parent_SubType__c
                                      FROM RecordType_Relationship__c 
                                     WHERE Parent_RecordTypeId__c IN :AccountRecordTypeIds
                                   ];
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
  
    if (recordTypeRelationships != null)
        {
          for (RecordType_Relationship__c r:recordTypeRelationships)
            {results.put(r.Parent_RecordTypeId__c,r.Parent_SubType__c);}
          }
    return results;
  }
      

  public static String GetCSRTaskType_Based_on_AccountRecordTypeId(Id AccountRecordTypeId)
      {
        RecordType_Relationship__c recordTypeRelationship;
        String result = '';

      try {
            recordTypeRelationship = [SELECT 
                                             id, 
                                             Business__c,
                                             Parent_SubType__c,
                                             Child_RecordTypeId__c,
                                             Child_SobjectType__c
                                        FROM RecordType_Relationship__c 
                                       WHERE Parent_RecordTypeId__c = :AccountRecordTypeId
                                         AND (
                                              (Relationship_Name__c = 'Account to Task' AND Business__c != 'Distribution') OR 
                                              (Relationship_Name__c = 'Account to Task - CSR' AND Business__c = 'Distribution')
                                             ) 
                                       LIMIT 1
                                     ];
                result = recordTypeRelationship.Child_RecordTypeId__c;

          }                           
      catch (Exception e) 
          {
          //Most likely, no record was returned
          }

      return result;
      }


  public static String GetMaterialRecordType_Based_on_AccountRecordTypeId(Id accountRecordTypeId) {
    String result = '';
    RecordType_Relationship__c recordTypeRelationship;

    System.debug('GetMaterialRecordType_Based_on_AccountRecordTypeId:Id=' + accountRecordTypeId);

    if (accountRecordTypeId != null)
      {
        try {

            recordTypeRelationship = [SELECT
                                      id,
                                      Child_RecordTypeId__c
                                      FROM RecordType_Relationship__c
                                WHERE Parent_RecordTypeId__c = : accountRecordTypeId
                                                                     AND Relationship_Name__c = 'Account to Sample Material'
                                                                                                LIMIT 1];
            result = recordTypeRelationship.Child_RecordTypeId__c;
            System.debug('GetMaterialRecordType_Based_on_AccountRecordTypeId:MaterialId=' + result);
            } 
        catch (Exception e) 
            {
            //Most likely, no record was returned
            }
      }
    return result;   
  }


    public static String GetContactRecordType_Based_on_AccountRecordTypeId(Id AccountRecordType) {
      String result = null;
      RecordType_Relationship__c recordTypeRelationship;

      try {

      recordTypeRelationship = [SELECT
                                id,
                                Child_RecordTypeId__c
                                FROM RecordType_Relationship__c
                          WHERE Parent_RecordTypeId__c = : AccountRecordType
                                                               AND Relationship_Name__c = 'Account to Contact'
                                                                                          LIMIT 1
                               ];

      result = recordTypeRelationship.Child_RecordTypeId__c;
            } catch (Exception e) {}
            
      return result;
    }


  static testMethod void TestMe() {

    List<String> RecordType_Relationship_Ids_Result;

        String results = '';

    RecordType_Relationship_Ids_Result = Update_RecordType_Relationship_Ids();

        //Test GetBusinessType_Based_on_AccountRecordType Function
        results = GetBusinessType_Based_on_AccountRecordTypeId(RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account'));
        System.Debug('BusinessType = ' + results);
        results = GetBusinessType_Based_on_AccountRecordTypeId(null);
        System.Debug('Bad BusinessType = ' + results);
        
        //Test GetAccountType_Based_on_AccountRecordType Function
        results = GetAccountType_Based_on_AccountRecordTypeId(RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account'));
        System.Debug('AccountType = ' + results);

        //Test GetCSRTaskType_Based_on_AccountRecordType Function
        results = GetCSRTaskType_Based_on_AccountRecordTypeId(RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account'));
        System.Debug('CSRTaskType = ' + results);
        results = GetCSRTaskType_Based_on_AccountRecordTypeId(null);
        System.Debug('Bad CSRTaskType = ' + results);

        //Test GetMaterialRecordType_Based_on_AccountRecordTypeId Function
        results = GetMaterialRecordType_Based_on_AccountRecordTypeId(RecordType_Functions.LookupRecordTypeId('Other Customer Account','Account'));
        System.Debug('MaterialType = ' + results);
        results = GetMaterialRecordType_Based_on_AccountRecordTypeId(null);
        System.Debug('Bad MaterialType = ' + results);

        //Test GetContactRecordType_Based_on_AccountRecordTypeId Function
        results = GetContactRecordType_Based_on_AccountRecordTypeId(RecordType_Functions.LookupRecordTypeId('Other Customer Account','Account'));
        System.Debug('ContactType = ' + results);

    Id RecId = RecordType_Functions.LookupRecordTypeId('Other Customer Account','Account');

    List<Account> testAccounts = [SELECT Id,RecordTypeId FROM Account WHERE RecordTypeId = :RecId LIMIT 5];
    List<Id> recIds = new List<Id>();
    for(Account a:testAccounts)
      {recIds.add(a.RecordTypeId);}

    Map<Id, String> testMap = GetAccountType_Based_on_AccountRecordTypeId(recIds);
    //System.debug(testMap);

    //System.debug(Update_RecordType_Relationship_Ids());
  }

//The End
}