public class OpportunityTriggerHandler {
    
    public static void updateProject(List<Opportunity> opps,Map<Id,Opportunity> oldmap){
        
        List<EMEA_Project_Mapping__mdt> codeMappings = [SELECT MasterLabel, DeveloperName, Material_Group_Code__c FROM EMEA_Project_Mapping__mdt];
   
   
   if(!codeMappings.isempty()){
        Id emeaRecordTypeId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Distribution Plastics EMEA').getRecordTypeId();
        Set<Id> matids = new set<id>();
        map<id,Material_Sales_Data2__c> matMap = new map<id,Material_Sales_Data2__c>(); 
        map<string,string> codeMaps = new map<string,string>(); 
        
        for(EMEA_Project_Mapping__mdt code : codeMappings){
            codeMaps.put(code.Material_Group_Code__c,code.MasterLabel);
        }
        for(Opportunity o : opps){
            if(emeaRecordTypeId == o.RecordTypeId && ((oldmap == null && o.SAP_Material__c != null) || (oldmap != null && o.SAP_Material__c != null && o.SAP_Material__c != oldmap.get(o.id).SAP_Material__c))){
                matids.add(o.SAP_Material__c); 
            }
        }
        if(!matids.isempty()){
            matMap = new map<id,Material_Sales_Data2__c>([select id, Material_Group1_Code__c from Material_Sales_Data2__c where id in: matids]);
        }
        
        for(Opportunity o : opps){
            string code = matMap.containskey(o.SAP_Material__c) ? matMap.get(o.SAP_Material__c).Material_Group1_Code__c : null;
            o.Project_Name__c = (code != null && codeMaps.containskey(code)) ? codeMaps.get(code) : o.Project_Name__c;
        
        }
   }
        
        
    }

}