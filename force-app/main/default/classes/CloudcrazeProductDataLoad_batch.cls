/*
This batch class is used to mass upload the Material data from Material_Sales_Data2 objects to Cloudcraze ccProduct object

*/

global class CloudcrazeProductDataLoad_batch implements Database.Batchable<SObject>{


String q;
String Division;

//pass the flag value as true and Division code in DivCode to mass load the data for any particular division products
global CloudcrazeProductDataLoad_batch(Integer batchNumber, Boolean flag, String DivCode){
Division = DivCode;

q = 'select Id, Name, Material_Number__c,Base_UOM_Code__c, Sales_Org_Code__c,Material_General_Data__c,Material_General_Data__r.Material_Base_Code_Desc__c, Container_Desc_del__c,';
q+= 'Material_General_Data__r.Material_Container_Desc__c,Material_General_Data__r.Division_Code__c,Material_General_Data__r.Ext_Material_Group_Code__c, Sales_UOM_Desc__c,';
q+= 'Division_Desc__c,Material_Base_Code__c,Material_Base_Code_Desc__c,Material_General_Data__r.Base_UOM_Desc__c,Product_Hierarchy__r.PH4_Supplier__c, Sales_UoM_Code__c,';
q+= 'Ext_Material_Group_Code__c, Product_Hierarchy__r.PH6_Segment__c, Division_Code__c, Dist_Channel_Code__c, Record_Key__c, PH4_Supplier__c, PH2_Line__c, PH6_Segment__c, Marked_for_Deletion__c,Material_Container_Abbreviation__c from Material_Sales_Data2__c';
// where Marked_for_Deletion__c = \'FALSE\'';

system.debug('DivCode:'+DivCode); 
if(flag == true)
    if(DivCode != '' || DivCode != null)
        q+= ' where Division_Code__c =: Division'; 

}//CloudcrazeProductDataLoad Ends


global Database.QueryLocator start(Database.BatchableContext bcMain) {
system.debug('q:'+q);
return Database.getQueryLocator(q);
}//Start Ends


global void execute(Database.BatchableContext bcMain, List<Material_Sales_Data2__c> lstBatchRecords) {


if(lstBatchRecords.size()>0)
    Cloudcraze_Product_Function.upsert_cloudcraze_product(lstBatchRecords);
    
}//execute ends


global void finish(Database.BatchableContext bc){




}//finish ends





}//main function ends