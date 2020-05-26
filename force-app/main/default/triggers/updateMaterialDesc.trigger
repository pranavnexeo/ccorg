trigger updateMaterialDesc on Material_Description__c (after update) {

  Set<String> mats = new SeT<String>();
  for(Material_Description__c d:trigger.new){
    mats.add(d.Material_Number__c);
  }

  List<Material_General_Data__c> mgd = [select id from Material_General_Data__c where Material_Number__c IN :mats];
  List<Material_Sales_Data__c> msd = [select id from Material_Sales_Data__c where Material_Number__c IN :mats];
  if(mgd.size() > 0){
    update mgd;
  }
  if(msd.size() > 0){
    update msd;
  }
  
}