// Developer : Parvez
// Date Created : 2/14/2018
// Summary: This Trigger will execute on Material Pricing Group2 Description field Update only.
//          This Trigger will fetch all the Material Sales Data2 records where it matches the Material Pricing Group2 Code
//          and update them with New or Modified value of Material Pricing Group2 Description field.    
         
trigger UpdateRelatedMaterials on Material_Pricing_Group2__c (after Update) {

    map<String,String> namedesc = new map<String,String>();
    
    for(Material_Pricing_Group2__c mpg2 : trigger.new ) 
        {
            If((Trigger.oldMap.get(mpg2.Id).Material_Pricing_Group2_Description__c != null && mpg2.Material_Pricing_Group2_Description__c != null ) && (Trigger.oldMap.get(mpg2.Id).Material_Pricing_Group2_Description__c != mpg2.Material_Pricing_Group2_Description__c)) 
                {    
                    namedesc.put(mpg2.Material_Pricing_Group2_Code__c, mpg2.Material_Pricing_Group2_Description__c); 
                }        
        }    
    if(!namedesc.isEmpty()) 
        {    
            Database.executeBatch(new Update_Material_Group2_Description(namedesc));
        }
}