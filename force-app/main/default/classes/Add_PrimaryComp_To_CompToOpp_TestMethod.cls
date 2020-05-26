@isTest
private class Add_PrimaryComp_To_CompToOpp_TestMethod  {

   static testMethod void testCompetitorOpportunity() {
   Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
/*    
      Integer size = 15;
      Integer j = 0;
      List<Opportunity> newOpp = new List<Opportunity>();
      List<Competitor__c> comp = [SELECT Id FROM Competitor__c LIMIT 2];
      Account a = [SELECT Id FROM Account WHERE Type = 'Customer' LIMIT 1];

    

      for (Integer i = 0; i < size; i++)  {
         Opportunity o = new Opportunity();
         o.name = 'Opportunity Test: ' + i;
         o.Primary_Competitor__c = comp[0].Id;
         o.accountId = a.Id;
         o.closeDate = System.today() + 150;
         o.stageName = 'Quotation';
         //o.Annualized_Gross_Profit_GP__c = 1000;
         if(j == 0)  {
            o.recordTypeId = '012300000000afJ';
            j = 1;
         }
         else if (j == 1)  {
            o.recordTypeId = '012300000000afT';
            j = 2;
         }
         else  {
            o.recordTypeId = '012500000009E1e';
            o.Project_Name__c = 'Other';
            o.Annual_Usage__c = 10;
            o.Target_Price__c = 25;
            j = 0;
         }
         newOpp.add(o);
      }
      
      insert newOpp;
      
      Opportunity currentOpp = [SELECT Id, StageName FROM Opportunity WHERE StageName = 'Qualification' LIMIT 1];
      //currentOpp.StageName = 'Closed Won'; 
      currentOpp.StageName = 'Testing'; 
      currentOpp.T_Reason_Won_Lost__c = 'Testing';    
      currentOpp.Material_won_or_lost__c = 'Testing';
      currentOpp.CIS_Materials__c = [SELECT Id FROM CIS_Materials__c LIMIT 1].Id;
      //currentOpp.Annualized_Gross_Profit_GP__c = 1000;
      update(currentOpp);
      delete(newOpp[3]);
*/    
                 
        List<Account> accts = new List<Account>();
        
               
        Account acct_AD_Chemicals = new Account(Name='AD_Chemicals',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Distribution Customer', 'Account'),
                                                SAP_Division_Desc__c = 'Chemicals');accts.add(acct_AD_Chemicals);                                                
                                                
       
        Account acct_AD_Composites = new Account(Name='AD_Composites',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Distribution Customer', 'Account'),
                                                SAP_Division_Desc__c = 'Composites');accts.add(acct_AD_Composites);                                           
                                                
        
        Account acct_AD_Plastics = new Account(Name='AD_Plastics',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Distribution Customer', 'Account'),
                                                SAP_Division_Desc__c = 'Plastics');accts.add(acct_AD_Plastics);                                                
                                                
        
        Account acct_AD_ES = new Account(Name='AD_ES',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Distribution Customer', 'Account'),
                                                SAP_Division_Desc__c = 'Environmental Svcs');accts.add(acct_AD_ES);                                                
       /*                                         
        
        Account acct_PM_CAST = new Account(Name='PM_CAST',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Performance Materials Customer', 'Account'),
                                                SAP_Division_Desc__c = 'Castings Solutions');accts.add(acct_PM_CAST);                                                
                                                
        
        Account acct_PM_COMP = new Account(Name='PM_COMP',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Performance Materials Customer', 'Account'),
                                                SAP_Division_Desc__c = 'Composite Polymers');accts.add(acct_PM_COMP);                                                
                                                
        
        Account acct_PM_SPA = new Account(Name='PM_SPA',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Performance Materials Customer', 'Account'),
                                                SAP_Division_Desc__c = 'Specialty Poly & Adh');accts.add(acct_PM_SPA);                                                
                                                
        
        Account acct_Valvoline_DIFM = new Account(Name='Valvoline_DIFM',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Valvoline Customer', 'Account'),
                                                SAP_Sales_District_Desc__c = 'DIFM');accts.add(acct_Valvoline_DIFM);                                                
                                                
       
        Account acct_Valvoline_DIY = new Account(Name='Valvoline_DIY',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Valvoline Customer', 'Account'),
                                                SAP_Sales_District_Desc__c = 'DIY');accts.add(acct_Valvoline_DIY);                                                
                                                
        
        Account acct_Valvoline_DIY2 = new Account(Name='Valvoline_DIY2',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Valvoline Customer', 'Account'),
                                                SAP_Sales_District_Desc__c = 'DIY');accts.add(acct_Valvoline_DIY2);                                                
                                                
        
        Account acct_Valvoline_Specialty = new Account(Name='Valvoline_Specialty',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Valvoline Customer', 'Account'),
                                                SAP_Sales_District_Desc__c = 'SPECIALTY');accts.add(acct_Valvoline_Specialty);                                                
                                                
        
        Account acct_Water = new Account(Name='Water',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Water Prospect', 'Account')); accts.add(acct_Water);                                             
                                                
        
        Account acct_Water_Drew = new Account(Name='Water_Drew',
                                                RecordTypeId=RecordType_Functions.LookupRecordTypeId('Drew Customer', 'Account'));accts.add(acct_Water_Drew);
                                                
        */
                                                        
        insert accts;

    
    
        Competitor__c competitor = new Competitor__c(Name = 'Test Competitor');
        insert competitor;

        List<Competitor_to_Account__c> newRecs = new List<Competitor_to_Account__c>(); 
        
        for (Account acct:accts)
            {
            Competitor_to_Account__c newRec = new Competitor_to_Account__c(Account__c = acct.Id,Competitor__c = competitor.Id);
            newRecs.add(newRec);
            } 
        insert newRecs;
        
        delete newRecs;

        //Test Opportunities
        //acct_AD_ES
        //Opportunity opp = new Opportunity(Name='opp',AccountId=acct_Valvoline_Specialty.Id,StageName='General Information',CloseDate=System.today());insert(opp);
        Opportunity opp = new Opportunity(Name='opp',AccountId=acct_AD_ES.Id,StageName='General Information',CloseDate=System.today());insert(opp);
        Competitor_to_Opportunity__c compOpp = new Competitor_to_Opportunity__c(Opportunity__c = opp.id,Competitor__c=competitor.Id);
        insert compOpp;
        delete compOpp; 
                     
        
  List <String> addressLines_List = Address_Functions.convert1LineAddressto4('Line1\nLine2\nLine3\nLine4');
  List <String> addressLines_List2 = Address_Functions.convert1LineAddressto4('');
  List <String> addressLines_List3 = Address_Functions.convert1LineAddressto4(null);
  String addressLines_String = Address_Functions.convert4LineAddressto1(addressLines_List);
  String location1 = Address_Functions.FormatCustomerLocation('State', 'City', 'Country');
  String location2 = Address_Functions.FormatCustomerLocation('State', 'City', '');  

  System.debug(Address_Functions.FormatAddressforWebDisplay(addressLines_List,'city','state','zipcode','country'));
  System.debug(Address_Functions.FormatAddressforWebDisplay(addressLines_String,'city','state','zipcode','country'));
  System.debug(Address_Functions.FormatAddressforWebDisplay(addressLines_String,'city',null,'zipcode','country'));  

  System.debug(Address_Functions.FormatAddressforTextArea(addressLines_List,'city','state','zipcode','country'));
  System.debug(Address_Functions.FormatAddressforTextArea(addressLines_String,'city','state','zipcode','country'));
  System.debug(Address_Functions.FormatAddressforTextArea(addressLines_String,'city',null,'zipcode','country'));
  System.debug(Address_Functions.FormatCustomerLocation('State', 'City', 'Country'));
  System.debug(Address_Functions.FormatCustomerLocation('State', 'City', ''));  
  
  SAP_Sales_Org_Lookup_Functions.populateSAP_Sales_Orgs();
  System.debug(SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org('0441'));
  List<String> salesOrgs = new List<String>();
  salesOrgs.add('0441');
  System.debug(SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(salesOrgs));
  System.debug(String_Functions.convertBRtoCR('This is a <BR>TEST'));
  System.debug(String_Functions.removeLeadingZeros('0000test'));
  System.debug(String_Functions.trimAllStringsinListString(salesOrgs));
  List<String> test1 = new List<String>();
  test1.add('Line 1 ');
  test1.add('Line 2 ');  
  System.debug(String_Functions.Format_ListString_into_HTML_List(test1, 'prefix:', ':suffix'));
  System.debug(String_Functions.Format_ListString_into_HTML_List(test1, 'prefix:', ':suffix'));  
      
  
   }
}