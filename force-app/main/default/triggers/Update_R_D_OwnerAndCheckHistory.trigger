//This triggers captures comments of approval process and populates in a field.
//Also changes the owner.
//LAB Project
//Rajeev

trigger Update_R_D_OwnerAndCheckHistory on R_D_Requests__c (before insert,before update) {

  R_D_Object_Functions.ProcessBefore(trigger.new,trigger.oldmap,trigger.isUpdate);
  
}