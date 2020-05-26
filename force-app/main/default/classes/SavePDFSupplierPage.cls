public class SavePDFSupplierPage {
    
    Public id supp{Get;Set;}
    Public List<Material_Sales_Data2__c> matlist = new List<Material_Sales_Data2__c>();
    Public set<id> basecode = new set<id>();
    Public List<Material_Base_Code__c> BaseCodeList{Get;Set;}
   
    public SavePDFSupplierPage(){
                 
     
        supp = ApexPages.currentPage().getParameters().get('ids');
        
        String sup_name = [SELECT id, Name FROM Nexeo_Competitor__c where id=: supp].name;
        system.debug('@@@Name@@' +sup_name);
        
        matlist = [select id, Name, Material_Number__c, Material_Base_Code__c, Material_General_Data__c, Material_General_Data__r.Material_Base_Code__c, Material_Base_Code_Desc__c, Container_Desc_del__c, PH4_Supplier__c, Division_Desc__c, Marked_for_Deletion__c, Division_Code__c from Material_Sales_Data2__c where PH4_Supplier__c =: sup_name and (NOT Name LIKE '%DO NOT%') and Division_Code__c LIKE '31'and Marked_for_Deletion__c != 'true']; 
        
        system.debug('@@@matlist@@' +matlist.size());
        for(Material_Sales_Data2__c ms2 : matlist ){
           basecode.add(ms2.Material_General_Data__r.Material_Base_Code__c);
        
        }
        BaseCodeList = [select id, Material_Base_Code__c, Material_Base_Code_Description__c from Material_Base_Code__c where id in : basecode];              
      
        
       } 

}