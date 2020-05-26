public with sharing class SAP_Plant_Details_Controller{
 
 Public Static List<SAPPlantWrapper> display_list = new List<SAPPlantWrapper>();
 Public Static String ids {get; set;} 
 public static String mgdId {get; set;}
 
 
 Public SAP_Plant_Details_Controller(){  
 }
 
 
  @RemoteAction
        Public Static List<SAPPlantWrapper> getRecordsToDisplay(String paramid) {
           mgdId = [select id,Material_General_Data__c from Material_Sales_Data2__c where id =: paramid].Material_General_Data__c ;
           string matname = [select id,name from Material_Sales_Data2__c where id =: paramid].name;
          
           String queryString = 'select Id, Material_Number__c,Plant_Code__c, MRPTypeCode__c, MRPTypeDescription__c, ProcurementTypeCode__c, ProcurementTypeDescription__c  , ProcurementTypeCode_formula__c, Plant_Name__c, Plant_Address__c, Minimum_Order_Quantity__c,Planned_Delivery_Time__c, Deletion_Flag__c, COGS__c, Material_General_Data__c, SAP_Plant__c,SAP_Sales_Org__c, SAP_Purchasing_Analyst__c,SAP_Purchasing_Analyst__r.name, SAP_Purchasing_Group__c,SAP_Purchasing_Group__r.name  from Material_Plant2__c where Material_General_Data__c =: mgdId order by Plant_Name__c';
            List<Material_Plant2__c> lstMaterialPlant = DataBase.Query(queryString);
            for(Material_Plant2__c mp : lstMaterialPlant){
                SAPPlantWrapper w = new SAPPlantWrapper(); 
                w.Id = mp.Id;
                w.matname1 = matname;              
                w.mp2 = mp; 
                w.Plant_Name = mp.Plant_Name__c;
                w.Plant_Code = mp.Plant_Code__c;
                w.Planned_Delivery_Time =  mp.Planned_Delivery_Time__c;
                w.Minimum_Order_Quantity =  mp.Minimum_Order_Quantity__c;
                w.City_State_ZipCode =  mp.Plant_Address__c;
                w.COGS =  mp.COGS__c.setScale(4,RoundingMode.HALF_UP);
                w.Deleted =  mp.Deletion_Flag__c;
                w.ProcurementTypeCode_formula = mp.ProcurementTypeCode_formula__c;   
                w.Purchasing_Analyst=  mp.SAP_Purchasing_Analyst__r.name;
                w.Purchasing_Group=  mp.SAP_Purchasing_Group__r.name ;
                w.MRPTypeDescription = mp.MRPTypeDescription__c;
                display_list.add(w);  
            }
            System.debug('@@list '+display_list);
            return display_list;              
        }
          
    Public class SAPPlantWrapper{
        public Material_Plant2__c mp2 {get; set;} //Material Plant2 object
        public Integer numberOfRow {get; set;} //row counter variable
        Public String Id{get; set;}
        Public String Plant_Name{get; set;}
        Public String Plant_Code{get; set;}
        Public String Planned_Delivery_Time{get; set;}
        Public String Minimum_Order_Quantity{get; set;}
        Public String City_State_ZipCode{get; set;}
        Public Decimal COGS{get; set;}
        Public String Deleted{get; set;}
        Public String Purchasing_Analyst{get; set;}
        Public String Purchasing_Group{get; set;}    
        public String matname1 {get; set;}  
        Public String ProcurementTypeCode_formula {get; set;}
        Public String MRPTypeDescription {get; set;}
        
       public SAPPlantWrapper() {}
       
        
    }    
}