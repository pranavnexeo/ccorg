trigger Material_Sales_Data2_After_Upsert on Material_Sales_Data2__c (after insert, after update) {
    Profile ProfileName = [select Name from profile where id = :userinfo.getProfileId()];
    if(ProfileName.Name=='Integration User'){
        System.debug('Record Count : '+Trigger.new.size());
        Material_Sales_Data_Functions.createSharingRecords(Trigger.new);
        
    }
    for(Material_Sales_Data2__c msd: Trigger.New){
        if(msd.Create_CC_Product__c == true){
        if(checkRecursive.runAccountOnce2()){ 
        Cloudcraze_Product_Function.upsert_cloudcraze_product(Trigger.New);
        }
        }
        }
            
       
    
}