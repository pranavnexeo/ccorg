global class Update_Material_Group2_Description  implements Database.Batchable<sObject>{

   map<String, String> namedesclocal = new map<String,String>();  
   set<String> keys = new set<String>();
   public Update_Material_Group2_Description(map<String,String> namedesc)
       {
               namedesclocal =  namedesc.clone();           
               keys.addall(namedesclocal.keyset());
       }
   
   global Database.QueryLocator start(Database.BatchableContext BC){
      return Database.getQueryLocator('select Id, Material_Group2_Code__c, Material_Group2_Desc__c from Material_Sales_Data2__c where Material_Group2_Code__c IN :keys'); 
      
   }

   global void execute(Database.BatchableContext BC, List<Material_Sales_Data2__c> scope){
   
       for(Material_Sales_Data2__c msd2 :scope)
           {
               if(namedesclocal.containsKey(msd2.Material_Group2_Code__c))
                   {
                       msd2.Material_Group2_Desc__c = namedesclocal.get(msd2.Material_Group2_Code__c); 
                   }
           }
        update scope;   
    }

   global void finish(Database.BatchableContext BC){
   }
   
}