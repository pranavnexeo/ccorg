@isTest
public class CISRelationships_Functions_TestFGG {
    static Id accountId;
    static String salesArea = '00000000';
    static Account shipTo, soldTo, cHerky, invalidAcc ,sourceAcc1,custType1,targetAcc1;
    static Account pa = new Account();
    static Account Parentact= new Account();
    static Account act= new Account();
    static Account sourceAcc= new Account();
   
    
      public static testMethod void myUnitTestFGG() {
          test.starttest();
          String returnedValue='';
       act=createAccountWithParent();
          sourceAcc=createAccountShipTo();
       
        Set<String> accids = new Set<String>();
          accids.add(act.Id);
          //accids.add(pa.Id);
        Set<Id> accountIds = new Set<Id>{act.Id};
        Map<String, Id> mapset = new Map<String, Id>();
        Map<String, Id> mapset1 = new Map<String, Id>();
        Map<Id, Map<String, Set<String>>>  pnmap = new Map<Id, Map<String, Set<String>>>();
        Map<String, Set<String>> ptmap = new Map<String, Set<String>>();
        //Set<Id> accountIds = new Set<Id>{'0015000000Qqhlt'};
        //Set<Id> accountIds = new Set<Id>{'0015000000QqhBV'};
        CISRelationships__c cr = new CISRelationships__c();          
        cr.Source_Customer__c=act.Id;
        cr.Target_Customer__c=act.Id;
        insert cr;
   
          CISRelationships_Functions.debug('Testing debug method.');
        Map<Id, Map<String, List<Id>>> partnerIds = new Map<Id, Map<String, List<Id>>>();            
        CISRelationships_Functions.getPartnerIds(act.Id);
        String defaultPaymentTerms=CISRelationships_Functions.getDefaultPaymentTerms(act.Id);
            List<Id> listIds =new List<Id>();
            listIds.add(act.Id);
          Map<String, List<Id>> pIds =new Map<String, List<Id>>();            
       pIds.put('test', listIds);
       partnerIds.put(act.Id, pIds);   
          
        Map<Id, Account> amap = CISRelationships_Functions.getAccountsMap(partnerIds);
        
        CISRelationships_Functions.Lookup_Related_Accounts(accids);
        //printAccounts(amap.values());
        //Set<Id> acctId = new Set<Id>{shipTo.Id};       
        CISRelationships_Functions.getPartnerIds(accountIds);
        CISRelationships_Functions.getPartnerIdMap(accountIds);
          
        Set<String> cnset = new Set<String>();
        cnset.add('Values');
        Map<String, Set<String>> firstdata= new Map<String, Set<String>>();
          firstdata.put('Values', cnset);
        Map<Id,Map<String, Set<String>>> firstNode = new Map<Id,Map<String, Set<String>>>();     
        firstNode.put(act.Id,firstdata);
        //Map<Id,Map<String, Set<String>>> = complexData = new Map<Id,Map<String,Set<String>>>();                       
       
        CISRelationships_Functions.getPartnerIdMap(cnset, firstNode);
        CISRelationships_Functions.setAccountNumberIdMaps(accids,mapset,mapset1);
        CISRelationships_Functions.getCustomerNumber(cr);      
        CISRelationships_Functions.setPartnerNums(cr,accids,firstNode,ptmap,act.Id);          
       
      test.stopTest();
      }
    
    
    
    
  /* public static testMethod void createTestData() {
        cHerky = createAccountSoldTo();
        insert cHerky;
        soldTo = createAccountSoldTo();
        soldTo.SAP_Partner_Functions__c = CISRelationships_Functions.SOLDTO;
        soldTo.ParentId = cHerky.Id;
        insert soldTo;
        shipTo = createAccountShipTo();
        insert shipTo;
        invalidAcc = createAccountinvalidAcc();
        insert invalidAcc;
        createCISRelationship(shipTo, CISRelationships_Functions.SHIPTO, shipTo);
        createCISRelationship(shipTo, CISRelationships_Functions.SOLDTO, soldTo);
        createCISRelationship(soldTo, CISRelationships_Functions.SOLDTO);
        createCISRelationship(invalidAcc, 'invalidAcc');
        return;
    }
   */
    public static testMethod Account createAccountWithParent(){
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        
        pa.Name='Parent Account';
        pa.SAP_Account_Name_2__c = 'Parent Account';
        pa.AccountNumber = 'Parent Account';
        pa.BillingCity = 'City';
        pa.BillingCountry = 'US';
        pa.BillingPostalCode = '99999';
        pa.BillingState = 'OH';
        pa.SAP_Customer_Group_1_Desc__c = 'CustGrp1';
        pa.SAP_Customer_Group_Desc__c = 'CustGrp';
        pa.SAP_DistChannel__c = '10';
        pa.SAP_Dist_Channel_Desc__c = 'AHWT';
        pa.SAP_DivisionCode__c = '11';
        pa.SAP_Division_Desc__c = 'AHWT';
        pa.SAP_Sales_Org__c = '1020';
        pa.SAP_Sales_Org_Desc__c = 'Ashland';        
        pa.SAP_Partner_Functions__c='Sold';        
        pa.Account_Number__c = 'Parent Account'+pa.SAP_Sales_Org__c+pa.SAP_DistChannel__c+pa.SAP_DivisionCode__c;
        insert pa;        
        return pa;
    }
   
public static testMethod Account createAccountinvalidAcc() {
        
        //Creation of Parent Account
   
        //End of Creation Parent Account
        //
        String s='invalidAcc';
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
        a.SAP_Partner_Functions__c='Sold';
        a.Account_Number__c = s+a.SAP_Sales_Org__c+a.SAP_DistChannel__c+a.SAP_DivisionCode__c;
        return a;
    }

    public static testMethod Account createAccountShipTo() {
        
        //Creation of Parent Account
   
        //End of Creation Parent Account
        //
        String s='ShipTo';
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
        a.SAP_Partner_Functions__c='Sold';
        a.Account_Number__c = s+a.SAP_Sales_Org__c+a.SAP_DistChannel__c+a.SAP_DivisionCode__c;
        return a;
    }

       public static testMethod Account createAccountSoldTo() {
        
        //Creation of Parent Account
   
        //End of Creation Parent Account
        //
        String s='SoldTo';
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
        a.SAP_Partner_Functions__c='Sold';
        a.Account_Number__c = s+a.SAP_Sales_Org__c+a.SAP_DistChannel__c+a.SAP_DivisionCode__c;
        return a;
    }
    
    /*
    static CISRelationships__c createCISRelationship(Account sourceAcc,
                                                     String custType) {
        return createCISRelationship(sourceAcc, custType, null);
    }*/
    
    static testMethod CISRelationships__c createCISRelationship() {
        CISRelationships__c cr = new CISRelationships__c();
        Account targetAcc= new Account();
        targetAcc=act;                                                
        String custType='Test Type';
        cr.Customer_Number__c = act.AccountNumber;
        cr.Customer_Type__c = custType;
        cr.Source_Customer__c = sourceAcc.Id;
        if (targetAcc != null) {
            cr.Target_Customer__c = targetAcc.Id;
        }
        cr.Ext_Unique_ID_c__c = cr.Source_Customer__c+cr.Customer_Number__c+salesArea+custType;
        insert cr;
        return cr;
        
    }
  
    
    /*
    static testMethod void myUnitTest() {
        Test.startTest();
        try{
         createTestData();
         Map<String, List<Id>> amap;
        String defaultPaymentTerms = CISRelationships_Functions.getDefaultPaymentTerms(shipTo.Id);
        amap = CISRelationships_Functions.getPartnerIds(shipTo.Id);
        System.debug(amap);
        amap = CISRelationships_Functions.getPartnerIds(soldTo.Id);
        System.debug(amap);
        amap = CISRelationships_Functions.getPartnerIds(cHerky.Id);
        System.debug(amap);
        System.debug(CISRelationships_Functions.getAccountType(shipTo.Id));
        System.debug(CISRelationships_Functions.getAccountType(invalidAcc.Id));
        System.debug(CISRelationships_Functions.Lookup_Related_Sold_To(shipTo.Id));
        }catch(DmlException e) {
            
            System.debug('Error DML FGG '+e.getDmlMessage(0));
        }
        
        
        //System.debug(CISRelationships_Functions.getDefaultPaymentTerms(shipTo.Id));
        
       //Map<Id, Account> amap1 = CISRelationships_Functions.getAccountsMap(partnerIds);
       //printAccounts(amap1.values());
            
        //test03();
        Test.stopTest();
    }
    */



  /*
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
        debug(''+partnerIds,'0015000000QqhmJ');
        }catch(exception e){}
        Map<Id, Account> amap = CISRelationships_Functions.getAccountsMap(partnerIds);
        try{
        debug(''+amap.keySet(),'0015000000QqhmJ');
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