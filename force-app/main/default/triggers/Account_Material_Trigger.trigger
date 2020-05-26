trigger Account_Material_Trigger on Account_Material__c (before update, before insert, after insert, after update) {
   if(trigger.isbefore){ 
       Account_Material_Functions.beforeupdate(trigger.new);
       
   }
   if(trigger.isafter){
      sharing_functions.share_with_Account_Team(trigger.new);
      Cloudcraze_Product_Function.update_CPI_PriceList(trigger.new);
      // Account_Material_Functions.Accountmaterialsharing(trigger.new, trigger.newMap, trigger.isUpdate);
   }
  
}