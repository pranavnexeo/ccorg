public class Case_Functions {

    private static final String CASE_OBJECT_TYPE = 'Case';


   @TestVisible private static final Set<String> DZ_CASE_REC_TYPES = new Set<String> {
        'AAFI DZ', 
        'Distribution DZ', 
        'Water DZ'
    };

   @TestVisible private static final Map<String, Id> CASE_REC_TYPES = RecordType_Functions.RetrieveRecordTypeNameMap(CASE_OBJECT_TYPE); 


    public static void processBeforeUpsert(List<Case> cs) {
        setCaseSubject(cs);
        markCaseCreatedOnOpp(cs); 
        ApprovalHistory(cs);       
    }
    
    public static void processAfterUpsert(List<Case> cs){

       
    }
    
    public static void ApprovalHistory(List<Case> cs){

      Set<ID> ids = new Set<Id>();
      For(Case NC:cs){
       IDs.add(NC.id);
      }

      Map<ID, String> Comments = Approval_Functions.getComments(IDs);

      For(Case NC:cs){
      if(Comments.containskey(NC.id)){
          NC.Approval_History__c = Comments.get(NC.id);}
      }

     }  
    
   @TestVisible private static void markCaseCreatedOnOpp(List<Case> cs){
      Set<ID> oppIDs = new set<ID>();
      for(Case c:cs){
         if(c.related_Opportunity__c != null){
            oppIDs.add(c.related_Opportunity__c);
         }
      }
      /*List<Opportunity> Opps = [select id, Opportunity_Status__c from Opportunity where id in :oppIDs];
      
      /*for(Opportunity o:Opps){
         o.Opportunity_Status__c = 'Application Support Case Created';
      }
      Update Opps;*/

    }
   @TestVisible private static void submitcasesforapproval(List<Case> cases){
       Set<Id> NCARIds = new Set<ID>();
       NCARIDs.add(CASE_REC_TYPES.get('Nexeo Return'));
       NCARIDs.add(CASE_REC_TYPES.get('Nexeo Credit Debit Claim'));
       NCARIDs.add(CASE_REC_TYPES.get('Nexeo Standard Incident'));    
       
       for(Case c:cases){
        if(NCARIDs.contains(c.recordtypeid)){
        Approval_Functions.submitrecord(c.id, 'Resubmitting Record. ');}
       }
    }
    
   @TestVisible private static void setCaseSubject(List<Case> cs) {
        Map<Id, Account> amap = getAccounts(cs);
        Set<Id> aset = getDZCaseRecordTypeIds();
        String dznumber;
        Id accountId;
        Account acc;
        for (Case c : cs) {
            if (aset.contains(c.RecordTypeId)) {
                accountId = c.AccountId;
                if (accountId != null) {
                    dznumber = c.DZ_Number__c;
                    if (amap.containsKey(accountId)) {
                        acc = amap.get(accountId);
                        c.Subject = acc.Name + ' - ' + dznumber;
                    }
                }
                //System.debug(c);
            }
        }
    }
    
   @TestVisible private static Set<Id> getDZCaseRecordTypeIds() {
        Set<Id> aset = new Set<Id>();
        for (String s : DZ_CASE_REC_TYPES) {
            if (CASE_REC_TYPES.containsKey(s)) {
                aset.add(CASE_REC_TYPES.get(s));
            }
        }
        return aset;
    }
    
   @TestVisible private static Set<Id> getAccountIds(List<Case> cs) {
        Set<Id> accIds = new Set<Id>();
        for (Case c : cs) {
            if (c.AccountId != null) {
                accIds.add(c.AccountId);
            }
        }
        return accIds;
    }
    
   @TestVisible private static Map<Id, Account> getAccounts(List<Case> cs) {
        Map<Id, Account> amap = new Map<Id, Account>();
        Set<Id> accIds = getAccountIds(cs);
        if (!accIds.isEmpty()) {
            List<Account> alist = [select Id, Name
                                     from Account
                                    where Id in :accIds];
            for (Account a : alist) {
                amap.put(a.Id, a);
            }
        }
        return amap;
    }
    
}