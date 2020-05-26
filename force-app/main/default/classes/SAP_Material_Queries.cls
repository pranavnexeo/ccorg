global with sharing class SAP_Material_Queries {

  Webservice static List<Material_Plant2__c> getMaterialPlants(String matNumbr,
                                                               String salesOrg,
                                                               String distChan) {
                                                                
    List<Material_Plant2__c> alist = Material_Sales_Data_Functions.getPlants(matNumbr, 
                                                                             salesOrg, 
                                                                             distChan);
    List<Material_Plant2__c> blist = new List<Material_Plant2__c>();
    if (alist != null && !alist.isEmpty()) {
    	for (Material_Plant2__c mp : alist) {
    		//if (mp.Deletion_Flag__c == 'X') {continue;}
    		blist.add(mp);
    	}
    }
    System.debug(blist);
    return blist;
    
  }
    
  Webservice static List<Product_Hierarchy__c> getProductFamilies(String distChan,
                                                                  String prodLine) {

    List<Product_Hierarchy__c> alist = Product_Hierarchy_Functions.getProductFamilies(distChan, prodLine);
    return alist;

  }

  Webservice static List<Product_Hierarchy__c> getProductFamilyList(String distChan,
                                                                    List<String> prodLines) {

    List<Product_Hierarchy__c> alist = Product_Hierarchy_Functions.getProductFamilies(distChan, prodLines);
    return alist;

  }

  Webservice static List<Product_Hierarchy__c> getProductLines(String distChan) {

    List<Product_Hierarchy__c> alist = Product_Hierarchy_Functions.getProductSegments(distChan);
    return alist;

  }

  Webservice static List<SAP_UOM_Description__c> getMaterialUoms(String msd2Id) {
                                                                
    List<SAP_UOM_Description__c> alist = Material_Sales_Data_Functions.getMaterialUoms(msd2Id);
    if (alist == null) {
    	alist = new List<SAP_UOM_Description__c>();
    }
    return alist;
    
  }

 /*
 **********************************************************
 Test Methods are in SAP_Material_Queries_Test
 ********************************************************** 
 */    

}