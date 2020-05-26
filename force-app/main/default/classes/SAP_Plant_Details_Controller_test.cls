@istest
public class SAP_Plant_Details_Controller_test{
    public static testMethod void testSAP_Plant_Details_Controller(){
    
    String queryString;
    String matnum = '010000000123456789';
    String plant = '1234';
    String sorg = '1234';
    String dchan = '12';
    String lang = 'E';
    String salesOrg = '1234';
    String distChan = '30';
    
    User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
    
    SAP_Purchasing_Group__c spg = new SAP_Purchasing_Group__c(User__c = u.id, Purchasing_Group_Code__c = 'test122334');
    insert spg;
    
    Material_General_Data2__c mgd2 = new Material_General_Data2__c();
    mgd2.Material_Number__c = matnum;
    insert mgd2;
    
    Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
    msd2.Material_Number__c = matnum;
    msd2.Material_Base_Code__c = 'testdata12';
    msd2.Material_Base_Code_Desc__c = 'testingdata12';
    msd2.PH4_Supplier__c = 'phdetails';
    msd2.Division_Desc__c = 'chemical';
    msd2.Sales_Org_Code__c = salesOrg;
    msd2.Dist_Channel_Code__c = distChan;
    msd2.Record_Key__c = matnum + salesOrg + distChan;
    msd2.Material_General_Data__c = mgd2.Id;
    insert msd2;
    
    SAP_Plant__c sp = new SAP_Plant__c();
    sp.Plant_Code__c = plant;
    insert sp;
    
    SAP_Sales_Org__c so = new SAP_Sales_Org__c();
    so.Sales_Org_Code__c = sorg;
    so.Language_Code__c = lang;
    insert so;    
    
    List<Material_Plant2__c> mpl = new List<Material_Plant2__c>();
    Material_Plant2__c MP = new Material_Plant2__c(SalesOrg_Code__c = 'test12',Record_Key__c = 'test12345',SAP_Purchasing_Group__c = spg.id,SAP_Purchasing_Analyst__c = spg.id,SAP_Sales_Org__c = so.id,SAP_Plant__c = sp.id,Material_Number__c = 'tes1223',Plant_Code__c = '21t',Minimum_Order_Quantity__c = '2600',Planned_Delivery_Time__c = 'today',Deletion_Flag__c = 'N',COGS__c = 12.32,Material_General_Data__c = mgd2.id);
    insert MP;
    mpl.add(MP);
    
    apexpages.currentpage().getparameters().put('paramid', msd2.id);
   
    SAP_Plant_Details_Controller spdc = new SAP_Plant_Details_Controller();
    
    SAP_Plant_Details_Controller.SAPPlantWrapper spwrp = new SAP_Plant_Details_Controller.SAPPlantWrapper();
    spwrp.numberOfRow = 4;
    spwrp.Plant_Name = 'willowspring';
    spwrp.Plant_Code = 'test12';
    spwrp.Planned_Delivery_Time = 'today';
    spwrp.Minimum_Order_Quantity = 'test';
    spwrp.City_State_ZipCode = 'testdata';
    spwrp.Deleted = 'no';
    spwrp.Purchasing_Analyst = 'PA';
    spwrp.Purchasing_Group = 'Testgrp';
    spwrp.COGS = 12.32;
    spwrp.mp2 = MP; 
    
    SAP_Plant_Details_Controller.ids = 'testid';
    SAP_Plant_Details_Controller.mgdId = 'testmgid';
    
     SAP_Plant_Details_Controller.SAPPlantWrapper w = new SAP_Plant_Details_Controller.SAPPlantWrapper(); 
    w.Plant_Name = MP.id;
    w.Plant_Code = MP.id;
    w.Planned_Delivery_Time =  MP.id;
    w.Minimum_Order_Quantity =  MP.id;
    w.City_State_ZipCode =  MP.id;
    w.COGS =  12.23;
    w.Deleted =  MP.id;
    w.Purchasing_Analyst=  MP.id;
    w.Purchasing_Group=  MP.id;
    
   // try{            
    SAP_Plant_Details_Controller.getRecordsToDisplay(msd2.id);
   // }catch(exception e){}

    
    }
    
}