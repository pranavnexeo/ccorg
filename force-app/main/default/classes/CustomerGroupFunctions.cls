public with sharing class CustomerGroupFunctions {

    public static void processBeforeUpsert(List<Customer_Group__c> cglist) {
        final String D = '-';
        for (Customer_Group__c c : cglist) {
            c.RecordKey__c = c.DistChannelCode__c + D +
                             c.CustomerGroupCode__c;
        }
    }
    
    public static List<Customer_Group__c> getCustomerGroups(Id distChanId) {
      List<Customer_Group__c> results;
      results = [Select CustomerGroupCode__c, CustomerGroup__c,
                        DistChannelCode__c, DistChannel__c,
                        SAP_Customer_Group__c,
                        SAP_Distribution_Channel__c
                   From Customer_Group__c
                  where SAP_Distribution_Channel__c = :distChanId
                ];
      if (!results.isEmpty()) {
          return results;
      }
      return null;                                                        
    }
  
}