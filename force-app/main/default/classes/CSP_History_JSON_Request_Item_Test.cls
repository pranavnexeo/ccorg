@isTest
public class CSP_History_JSON_Request_Item_Test { 

    public static testMethod void myUnitTest() {
                 /*account a =new account(name='test');
                 insert a;
                 Material_Sales_Data2__c mat=new Material_Sales_Data2__c(Material_Base_Code__c='test',Material_Base_Code_Desc__c='coral'); 
                 insert mat;*/
       CSP_History_JSON_Request_Item item = new CSP_History_JSON_Request_Item('Ship_to', 'Sold_to', 'Sales_Rep', 'material', 'base_code', 'Quantity', 'Sales_unit', 'date_from', 'date_to', 'SFDC_Account_Id', 'SFDC_Material_Id');
       CSP_History_JSON_Request_Item item2 = new CSP_History_JSON_Request_Item('Ship_to', 'Sold_to', 'Sales_Rep', 'material', 'Quantity', 'Sales_unit', 'date_from', 'date_to', 'SFDC_Account_Id', 'SFDC_Material_Id');
    //   CSP_History_JSON_Request_Item item = new CSP_History_JSON_Request_Item();
                        item.getShip_to();
                        item.getSold_to();
                        item.getSales_Rep();
                        item.getMaterial();
                        item.getQuantity();
                        item.getSales_Unit();
                        item.getSFDC_Account_Id();
                        item.getSFDC_Material_Id();
                        item.getDate_From();
                        item.getDate_To();
                        item.getBase_Code();
                        
    }
}