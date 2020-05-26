@isTest
private class CISRelationships_Functions_Test {
 /*
    static Id accountId;
    static String salesArea = '00000000';
    static Account shipTo, soldTo, cHerky, invalidAcc ,sourceAcc1,custType1,targetAcc1;

    static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>> ' + s);
                 System.debug(CISRelationships_Functions.getDefaultPaymentTerms(shipTo.Id));

    }
    
    static void printAccounts(List<Account> accs) {
        for (Account a : accs) {
            debug('Account Id:'+a.Id+' Name:'+a.Name);
        }
    }
   
    static testMethod void myUnitTest() {
        Test.startTest();
        try{
         createTestData();
        }catch(DmlException e) {
        }
        CISRelationships_Functions.getDefaultPaymentTerms(createAccount('Test FGG').Id);//FGG
        Map<String, List<Id>> amap;
        amap = CISRelationships_Functions.getPartnerIds(shipTo.Id);
        System.debug(amap);
        amap = CISRelationships_Functions.getPartnerIds(soldTo.Id);
        System.debug(amap);
        amap = CISRelationships_Functions.getPartnerIds(cHerky.Id);
        System.debug(amap);
        System.debug(CISRelationships_Functions.getAccountType(shipTo.Id));
        System.debug(CISRelationships_Functions.getAccountType(invalidAcc.Id));
        System.debug(CISRelationships_Functions.Lookup_Related_Sold_To(shipTo.Id));
        //System.debug(CISRelationships_Functions.getDefaultPaymentTerms(shipTo.Id));
        
       //Map<Id, Account> amap1 = CISRelationships_Functions.getAccountsMap(partnerIds);
       //printAccounts(amap1.values());
            
        //test03();
        Test.stopTest();
    }
    



    static void createTestData() {
        cHerky = createAccount('CHerky');
        insert cHerky;
        soldTo = createAccount('SoldTo');
        soldTo.SAP_Partner_Functions__c = CISRelationships_Functions.SOLDTO;
        soldTo.ParentId = cHerky.Id;
        insert soldTo;
        shipTo = createAccount('ShipTo');
        insert shipTo;
        invalidAcc = createAccount('invalidAcc');
        insert invalidAcc;
        createCISRelationship(shipTo, CISRelationships_Functions.SHIPTO, shipTo);
        createCISRelationship(shipTo, CISRelationships_Functions.SOLDTO, soldTo);
        createCISRelationship(soldTo, CISRelationships_Functions.SOLDTO);
        createCISRelationship(invalidAcc, 'invalidAcc');
    }
    
    static Account createAccount(String s) {
        Account a = new Account(Name = s);
        a.SAP_Account_Name_2__c = s;
        a.AccountNumber = s;
        a.BillingCity = 'City';
        a.BillingCountry = 'US';
        a.BillingPostalCode = '99999';
        a.BillingState = 'OH';
        a.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        a.SAP_Customer_Group_Desc__c = 'CustGrp';
        a.SAP_DistChannel__c = '10';
        a.SAP_Dist_Channel_Desc__c = 'AHWT';
        a.SAP_DivisionCode__c = '11';
        a.SAP_Division_Desc__c = 'AHWT';
        a.SAP_Sales_Org__c = '1020';
        a.SAP_Sales_Org_Desc__c = 'Ashland';
        a.Account_Number__c = s+a.SAP_Sales_Org__c+a.SAP_DistChannel__c+a.SAP_DivisionCode__c;
        return a;
    }
    
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType) {
        return createCISRelationship(sourceAcc, custType, null);
    }
    
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType,
                                                     Account targetAcc) {
        CISRelationships__c cr = new CISRelationships__c();
        cr.Customer_Number__c = sourceAcc.AccountNumber;
        cr.Customer_Type__c = custType;
        cr.Source_Customer__c = sourceAcc.Id;
        if (targetAcc != null) {
            cr.Target_Customer__c = targetAcc.Id;
        }
        cr.Ext_Unique_ID_c__c = cr.Source_Customer__c+cr.Customer_Number__c+salesArea+custType;
        insert cr;
        return cr;
        
    }
  
    static testMethod void test03() {
    Set<String> accids = new Set<String>();
        Set<Id> accountIds = new Set<Id>{'0015000000QqhmJ'};
        Map<String, Id> mapset = new Map<String, Id>();
        Map<String, Id> mapset1 = new Map<String, Id>();
        
        Map<Id, Map<String, Set<String>>>  pnmap = new Map<Id, Map<String, Set<String>>>();
        Map<String, Set<String>> ptmap = new Map<String, Set<String>>();
        //Set<Id> accountIds = new Set<Id>{'0015000000Qqhlt'};
        //Set<Id> accountIds = new Set<Id>{'0015000000QqhBV'};
        CISRelationships__c cr = new CISRelationships__c();
      
        Map<Id, Map<String, List<Id>>> partnerIds = CISRelationships_Functions.getPartnerIds(accountIds);
        try{
        debug(''+partnerIds);
        }catch(exception e){}
        Map<Id, Account> amap = CISRelationships_Functions.getAccountsMap(partnerIds);
        try{
        debug(''+amap.keySet());
        }catch(exception e){}
          CISRelationships_Functions.Lookup_Related_Accounts(accids);
        printAccounts(amap.values());
        //Set<Id> acctId = new Set<Id>{shipTo.Id};       
        CISRelationships_Functions.getPartnerIds(accountIds);
    CISRelationships_Functions.setAccountNumberIdMaps(accids,mapset,mapset1);
    CISRelationships_Functions.getCustomerNumber(cr);
    try{
    CISRelationships_Functions.setPartnerNums(cr,accids,pnmap,ptmap,'test');
    }catch(exception e){}
    
   
    }
  */
}