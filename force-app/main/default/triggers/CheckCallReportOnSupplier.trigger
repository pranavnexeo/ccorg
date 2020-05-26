/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         11/08/2016
*    Author:              Sneha Likhar and Shwetha Suvarna
*   Last Modified:        11/08/2016
*   Last Modified By:     Sneha Likhar
*
*   Short Description:  To check or uncheck the call report check box on Parent record when its child records chemical call report field gets changed
*   **********************************************************************************************************************/

trigger CheckCallReportOnSupplier on Supplier_Contact__c (after insert, after update) {
    Set<id> insertList = new Set<id>();
    Set<id> updateList = new Set<id>();
    List<Supplier_Contact__c> SCList = new List<Supplier_Contact__c>();
    List<Nexeo_Competitor__c> Supplier = new List<Nexeo_Competitor__c>();
    List<Nexeo_Competitor__c> ToUpdateSupplier = new List<Nexeo_Competitor__c>();
    List<Nexeo_Competitor__c> ToUpdateSupplier1 = new List<Nexeo_Competitor__c>();
    Map<id,id> SCCheckMap = new Map<id,id>();
    Map<id,id> SCUncheckMap = new Map<id,id>();
   
        for(Supplier_Contact__c sc : Trigger.New)
        {
            if(sc.Call_Report_Contact__c == true)
            {
                insertList.add(sc.Competitor_Supplier_or_OEM__c);
            }
        
        }
        system.debug('AAA List:' + insertList);
        if(insertList.size()>0)
        Supplier = [select id, Call_Report__c from Nexeo_Competitor__c where id in:insertList]; 
       
       For(Nexeo_Competitor__c NC : Supplier)
       {
           if(NC.Call_Report__c == False){
               NC.Call_Report__c = true;
               ToUpdateSupplier.add(NC);
           }
       }
       system.debug('BBB List:' + ToUpdateSupplier);
       if(ToUpdateSupplier.size()>0)
       update ToUpdateSupplier;
    
    if(Trigger.IsUpdate)
    {
        for(Supplier_Contact__c sc : Trigger.New)
        {
            if(sc.Call_Report_Contact__c == false && trigger.oldmap.get(sc.id).Call_Report_Contact__c)
            {
                updateList.add(sc.Competitor_Supplier_or_OEM__c);
            }
        
        }
        
        if(updateList.size()>0)
            SCList = [select id, Competitor_Supplier_or_OEM__c, Call_Report_Contact__c  from Supplier_Contact__c where Competitor_Supplier_or_OEM__c in:updateList ];
            for(Supplier_Contact__c sc1 : SCList)
            {
                if(sc1.Call_Report_Contact__c == true)
                SCCheckMap.put(sc1.id,sc1.Competitor_Supplier_or_OEM__c);
                else
                SCUncheckMap.put(sc1.Competitor_Supplier_or_OEM__c,sc1.id);
            }
            
            for(string keyId:SCCheckMap.values())
            {
                if(SCUncheckMap.keyset().contains(keyId))
                SCUncheckMap.remove(keyId);
            }
            
            List<Nexeo_Competitor__c> Supplier1 = [select id, Call_Report__c from Nexeo_Competitor__c where id in:SCUncheckMap.keyset()]; 
            
            For(Nexeo_Competitor__c NC1 : Supplier1)
            {
       
               NC1.Call_Report__c = false;
               ToUpdateSupplier1.add(NC1);
       
           }
           system.debug('BBB1 List:' + ToUpdateSupplier1);
           if(ToUpdateSupplier1.size()>0)
           update ToUpdateSupplier1;
           
    
    }
}