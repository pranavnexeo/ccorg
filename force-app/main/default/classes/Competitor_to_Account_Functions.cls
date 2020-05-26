public class Competitor_to_Account_Functions {

    public static List<Account> getAccounts(List<Id> Ids) {
        List<Account> results;
        
        results = [SELECT Id, 
                          RecordType.Name, 
                          SAP_DistChannel__c, 
                          SAP_Division_Desc__c, 
                          SAP_Sales_District_Desc__c
                     FROM Account
                    WHERE Id IN :Ids];
    
        return results;
    }
    
    public static List<Competitor__c> getCompetitors(List<Id> Ids) {
        List<Competitor__c> results;
        
        results = [SELECT Id, 
                          Competes_With__c
                     FROM Competitor__c
                    WHERE Id IN :Ids];
    
        return results;
    }

    public static Map<Id,String> BuildAccountRecTypeLookup(List<Account> accounts) {
    
        Map<Id,String> results = new Map<Id,String>();
        String recType = '';
        
        for (Account account:accounts) 
            {
            recType = '';
            if (account.RecordType.Name.contains('Distribution'))
                {
                recType = 'AD';
                if (account.SAP_Division_Desc__c == 'Chemicals') {recType = 'AD Chemicals';}
                if (account.SAP_Division_Desc__c == 'Environmental Svcs') {recType = 'AD ES';}
                if (account.SAP_Division_Desc__c == 'Composites') {recType = 'AD Composites';}
                if (account.SAP_Division_Desc__c == 'Plastics') {recType = 'AD Plastics';}
                }
            else if (account.RecordType.Name.contains('Performance'))
                      {
                      recType = 'PM';
                      if (account.SAP_Division_Desc__c == 'Castings Solutions') {recType = 'PM Castings';}
                      if (account.SAP_Division_Desc__c == 'Composite Polymers') {recType = 'PM Composites';}
                      if (account.SAP_Division_Desc__c == 'Specialty Poly & Adh') {recType = 'PM SPA';}
                      }   
            else if (account.RecordType.Name.contains('Valvoline'))
                      {
                      recType = 'Valvoline';
                      if (account.SAP_Sales_District_Desc__c == 'DIFM') {recType = 'Valvoline DIFM';}
                      if (account.SAP_Sales_District_Desc__c == 'DIY') {recType = 'Valvoline DIY';}
                      if (account.SAP_Sales_District_Desc__c == 'SPECIALTY') {recType = 'Valvoline Specialty';}
                      }
            else if ((account.RecordType.Name.contains('Water')) || (account.RecordType.Name.contains('Drew')))
               recType = 'Water';        
            else
               recType = '';
                
            results.put(account.Id,recType);
            }
        
        return results; 
        
    }

    public static Map<Id,String> BuildCompetitorLookup(List<Competitor__c> competitors) {
        Map<Id,String> results = new Map<Id,String>();
        for(Competitor__c competitor:competitors) {results.put(competitor.Id,competitor.Competes_With__c);}
        return results;
    }

}