public class SAP_Sales_Org_Lookup_Functions {


  public static List<SAP_Sales_Org_Lookup__c> SAP_Sales_Orgs;

  public static void populateSAP_Sales_Orgs() {
        if (SAP_Sales_Orgs == null)
          {
          SAP_Sales_Orgs = [SELECT SAP_Sales_Org__c, 
                                   SAP_Sales_Org_Desc__c, 
                                   Region__c 
                              FROM SAP_Sales_Org_Lookup__c];
          }                                                
    
  }


    //Lookup Region based on Sales Org
    public static String lookup_Region_from_Sales_Org(String Sales_Org) {
        String region = '';

        populateSAP_Sales_Orgs();
    
        for (SAP_Sales_Org_Lookup__c SAP_Sales_Org : SAP_Sales_Orgs)
          {
          if(SAP_Sales_Org.SAP_Sales_Org__c == Sales_Org) {region = SAP_Sales_Org.Region__c;}
          }

        return region;
      }

    public static Map<String,String> lookup_Region_from_Sales_Org(List<String> Sales_Orgs) {

        Map<String,String> sales_Org_Lookups = new Map<String,String>();
        List<SAP_Sales_Org_Lookup__c> SAP_Sales_Org_Lookups;
        
        try {       
              SAP_Sales_Org_Lookups = [SELECT SAP_Sales_Org__c, Region__c 
                                        FROM SAP_Sales_Org_Lookup__c 
                                       WHERE SAP_Sales_Org__c IN :Sales_Orgs];
        } 
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
        
        for(SAP_Sales_Org_Lookup__c s: SAP_Sales_Org_Lookups)
          {sales_Org_Lookups.put(s.SAP_Sales_Org__c,s.Region__c);}
        
        return sales_Org_Lookups;
      }
      
    public static Map<String,String> getSalesOrgDescriptions(List<String> Sales_Orgs) {

       Map<String,String> sales_Org_Lookup_Description = new Map<String,String>();
       populateSAP_Sales_Orgs();
/*       
       List<SAP_Sales_Org_Lookup__c> SAP_Sales_Org_Lookups;
        
       try {       
          SAP_Sales_Org_Lookups = [SELECT SAP_Sales_Org__c, SAP_Sales_Org_Desc__c FROM SAP_Sales_Org_Lookup__c WHERE SAP_Sales_Org__c IN :Sales_Orgs];
       } 
       catch (Exception e) {} // Most likely, no record was returned
*/        
       for(SAP_Sales_Org_Lookup__c s: SAP_Sales_Orgs)  {
          if(!sales_Org_Lookup_Description.containsKey(s.SAP_Sales_Org__c))
             sales_Org_Lookup_Description.put(s.SAP_Sales_Org__c,s.SAP_Sales_Org_Desc__c);
       }
        
       return sales_Org_Lookup_Description;
    }    

 
      
  static testMethod void TestMe() {

    String Region = '';
    Region = lookup_Region_from_Sales_Org('0315');
    
    Region = lookup_Region_from_Sales_Org('');
    
    List<String> SalesOrgs = new List<String>();
    List<String> SalesOrgsEmpty = new List<String>();
    SalesOrgs.add('1000');
    SalesOrgs.add('0315');
    
    Map<String,String> SalesOrgLookup = lookup_Region_from_Sales_Org(SalesOrgs);
    System.debug(SalesOrgLookup);

    List<Account> accounts = new List<Account>();
    accounts.add(new Account(name='Test 1',SAP_Sales_Org__c = '1000'));
    accounts.add(new Account(name='Test 2',SAP_Sales_Org__c = '0315'));
    accounts.add(new Account(name='Test 3',SAP_Sales_Org__c = '1700'));
    
    Map<String,String> SalesOrgLookup2 = lookup_Region_from_Sales_Org(SalesOrgs);
    Map<String,String> sapSalesOrgDesc = getSalesOrgDescriptions(SalesOrgs);    
    System.debug(SalesOrgLookup2);
    System.debug(sapSalesOrgDesc);    

    // To test with Empty values so the catch statement runs
    Map<String,String> SalesOrgLookup3 = lookup_Region_from_Sales_Org(SalesOrgsEmpty);
    Map<String,String> sapSalesOrgDesc2 = getSalesOrgDescriptions(SalesOrgsEmpty);    
    System.debug(SalesOrgLookup3);
    System.debug(sapSalesOrgDesc2);     
    
  }

      
//The End
}