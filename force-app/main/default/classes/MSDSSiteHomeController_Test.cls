/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        12/03/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Test for the MSDSSiteHomeController
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class MSDSSiteHomeController_Test {
    /*
    public static String DOCUMENTS_LIST = '[{"document": "","status": [],"dockey": "SBRWWI-00000000000006947646 00000","genvar": "1_GHS_NA","langu": "E","recn_dh": "00000000000011583693","material": "000000000000020005","genvar_desc": "USA - GHS","langu_desc": "English"},{"document": "","status": [],"dockey": "SBRWWI-00000000000006947647 00000","genvar": "1_GHS_NA","langu": "F","recn_dh": "00000000000011583697","material": "000000000000020005","genvar_desc": "USA - GHS","langu_desc": "French"}]';
    public static String DOCUMENT_RESPONSE = '['+
		'      {'+
		'      \"document\": \"0M8R4KGxGuEAAAAAAAAAAAAAAAAAAAAAPgADAP7/CQAGAAAAAAAAAAAAAAAEAAAAvQEAAAAAAAAAEAAAvwEAAAEAAAD+////AAAAALkBAAC6AQAAuwEAALwBAAD////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////\",'+
		'      \"status\": [],'+
		'      \"dockey\": \"SBRWWI-00000000000006947646 00000\",'+
		'      \"genvar\": \"1_GHS_NA\",'+
		'      \"langu\": \"E\",'+
		'      \"recn_dh\": \"00000000000011583693\",'+
		'      \"material\": \"000000000000020005\",'+
		'      \"genvar_desc\": \"USA - GHS\",'+
		'      \"langu_desc\": \"English\"'+
		'   }' +
		']';
    
    static void setupData () {
        MSDS_Site__c siteSettings = new MSDS_Site__c ();
        siteSettings.Get_SDS_Document_Body__c = '[{"MATERIAL":"PLACE_HOLDER_0","RECN_DH":"PLACE_HOLDER_1"}]';
        siteSettings.Get_SDS_Document_List_Body__c = '[{"MATERIAL":"PLACE_HOLDER"}';
        siteSettings.Landing_Zeros_Material_Number__c = '18';
        siteSettings.MSDS_EndpointPath__c = 'ZSD_GET_MSDS_LI';
        siteSettings.MSDS_EndpointPath_Query_Parameter__c = 'sap-client=020&spnego=disabled';
        insert siteSettings;
        
        Material_Description__c md = new Material_Description__c();
        md.Material_Description__c = 'Material';
        md.Language_Code__c = 'ES';
        md.Material_Number__c = '000000000000005467';
        insert md;
            

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = '000000000000005467';
       	mgd2.Material_Desc_Code__c = md.Id;
        insert mgd2;
        
      	Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material SDS', Material_Number__c = '000000000000005467', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key', Material_General_Data__c = mgd2.Id);        
        insert matlist;    
     
        ES_Order_Document__c orderDocument = new ES_Order_Document__c();
        insert orderDocument;        
    }
    
    public static testMethod void MSDSSiteHomeControllerNotFound() {
        setupData();
        MSDSSiteHomeController controller = new MSDSSiteHomeController();
    }
    
    public static testMethod void MSDSSiteHomeController() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', DOCUMENTS_LIST, new Map<String, String>()));
            ApexPages.CurrentPage().getParameters().put('materialNumber', '5467');
            MSDSSiteHomeController controller = new MSDSSiteHomeController();
        Test.stopTest();  
    }
    
    public static testMethod void MSDSSiteHomeControllerEx() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(400, '400', DOCUMENTS_LIST, new Map<String, String>()));
            ApexPages.CurrentPage().getParameters().put('materialNumber', '5467');
            MSDSSiteHomeController controller = new MSDSSiteHomeController();
        Test.stopTest();  
    }
    
    public static testMethod void getSDSDocument() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', DOCUMENT_RESPONSE, new Map<String, String>()));        
        	String documentId = MSDSSiteHomeController.getSDSDocument('5467', '7666000000', '00000000000011347766');
        Test.stopTest();  
    }*/
 private static String SEARCH_RESPONSE = '[{"material_list":[{"material":"0000000000005586151","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"0000000000005586152","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"0000000000005586153","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"},{"material":"000000000000558615","matl_desc":"TI IFF ALLYL AMYL GLYCOLATE HOL D07","product_name":"ALLYL AMYL GLYCOLATE HOL","comp_code":"","salesorg":"","distr_chan":"","division":"31","envi_indi":"X","langu":"E","mtart":"ZNVA","format":"","genvar":"","record_no":"00000000000000000000"}],"exceed_flag":"","status":[{"type":"E","id":"ZOTC","number":"137","message":"Material not found in System","log_no":"","log_msg_no":"000000","message_v1":"","message_v2":"","message_v3":"","message_v4":"","parameter":"","row":"0 ","field":"","system":""}]}]';
    
    static void setupData () {
        MSDS_Site__c siteSettings = new MSDS_Site__c ();
        siteSettings.Get_SDS_Document_Body__c = '[{"MATERIAL":"PLACE_HOLDER_0","RECN_DH":"PLACE_HOLDER_1"}]';
        siteSettings.Get_SDS_Document_List_Body__c = '[{"MATERIAL":"PLACE_HOLDER"}';
        siteSettings.Get_SDS_Document_List_Body_Internal__c = '[{"MATERIAL":"PLACE_HOLDER"," RECN_DH":"","EXCL_REFMSDS_FLAG":""}]';
        siteSettings.Landing_Zeros_Material_Number__c = '18';
        siteSettings.MSDS_EndpointPath__c = 'ZSD_GET_MSDS_LI';
        siteSettings.MSDS_EndpointPath_Query_Parameter__c = 'sap-client=020&spnego=disabled';
        siteSettings.Max_Number_Of_Records_Per_Page__c = 10;
        siteSettings.Pagination_Limit__c = '5';
        siteSettings.Search_By_Material_Name__c = 'SEARCH_BY_MATERIAL_NUMBER';
        siteSettings.MSDS_Material_Search_Endpoint__c = 'sap/bc/ZEHS_MATL_LIST?sap-client=020&spnego=disabled';
        siteSettings.Get_Material_Search_Body__c = '[{"MATERIAL":"PLACE_HOLDER_0","PRODUCT_NAME":"PLACE_HOLDER_1","LANGU":"","GENVAR":""}]';
       siteSettings.Get_External_Material_Search_Body__c = '[{"MATERIAL":"PLACE_HOLDER_0","PRODUCT_NAME":"PLACE_HOLDER_1","LANGU":"","GENVAR":""},"EXCL_REFMSDS_FLAG":""]';
        insert siteSettings;
        
        Material_Description__c md = new Material_Description__c();
        md.Material_Description__c = 'Material';
        md.Language_Code__c = 'ES';
        md.Material_Number__c = '000000000000005467';
        insert md;
            

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = '000000000000005467';
         mgd2.Material_Desc_Code__c = md.Id;
        insert mgd2;
        
        Material_Sales_Data2__c matlist = new Material_Sales_Data2__c(name = 'Test Material SDS', Material_Number__c = '000000000000005467', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',   Record_Key__c = 'Test Record Key', Material_General_Data__c = mgd2.Id);        
        insert matlist;    
     
        ES_Order_Document__c orderDocument = new ES_Order_Document__c();
        insert orderDocument;        
    }
    
    public static testMethod void MSDSSiteHomeControllerNotFound() {
        setupData();
        MSDSSiteHomeController controller = new MSDSSiteHomeController();
    }
    
    public static testMethod void MSDSSiteHomeControllerRedirect() {
        setupData();
        Test.startTest();
            //Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', SEARCH_RESPONSE, new Map<String, String>()));
            ApexPages.CurrentPage().getParameters().put('materialNumber', '5467');
            MSDSSiteHomeController controller = new MSDSSiteHomeController();
        Test.stopTest();  
    }
    
    public static testMethod void MSDSSiteHomeControllerSearch() {
        setupData();
        Test.startTest();
           Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', SEARCH_RESPONSE, new Map<String, String>()));
           MSDSSiteHomeController controller = new MSDSSiteHomeController();
          controller.valueToSearch = 'glycol';
          controller.searchSelected = 'SEARCH_BY_MATERIAL_NUMBER';
          controller.searchMaterial();
            String hasPrevious = controller.hasPrevious;
            String hasNext = controller.hasNext;
            controller.first();
            controller.last();
            controller.previous();
            controller.next();
        Test.stopTest();  
    }
    
    public static testMethod void MSDSSiteHomeControllerGoToMaterialDetail() {
        setupData();
        Test.startTest();
            MSDSSiteHomeController controller = new MSDSSiteHomeController();
      controller.materialNumber = '9777';
          controller.goToMaterialDetail();
        Test.stopTest();  
    }
    
    public static testMethod void MSDSSiteHomeControllerGoToMaterialSearch() {
        setupData();
        Test.startTest();
            MSDSSiteHomeController controller = new MSDSSiteHomeController();
          controller.goToMaterialSearch();
        Test.stopTest();  
    }
    
    public static testMethod void MSDSSiteHomeControllerGetSearchOptions() {
        setupData();
        Test.startTest();
            MSDSSiteHomeController controller = new MSDSSiteHomeController();
          controller.getSearchOptions();
        Test.stopTest();  
    }
    
    public static testMethod void MSDSSiteHomeControllerGetFormatOptions() {
        setupData();
        Test.startTest();
            MSDSSiteHomeController controller = new MSDSSiteHomeController();
          controller.getFormatOptions();
        Test.stopTest();  
    }
    
    public static testMethod void MSDSSiteHomeControllerGetLanguageOptions() {
        setupData();
        Test.startTest();
            MSDSSiteHomeController controller = new MSDSSiteHomeController();
          controller.getLanguageOptions();
        Test.stopTest();  
    }
}