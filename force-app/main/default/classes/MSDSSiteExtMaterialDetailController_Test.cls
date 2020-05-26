@IsTest
public class MSDSSiteExtMaterialDetailController_Test {
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
        MSDSSiteExtMaterialDetailController  controller = new MSDSSiteExtMaterialDetailController ();
    }
    
    public static testMethod void MSDSSiteHomeController() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', DOCUMENTS_LIST, new Map<String, String>()));
            ApexPages.CurrentPage().getParameters().put('materialNumber', '5467');
            MSDSSiteExtMaterialDetailController  controller = new MSDSSiteExtMaterialDetailController ();
        Test.stopTest();  
    }
    
    public static testMethod void MSDSSiteHomeControllerEx() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(400, '400', DOCUMENTS_LIST, new Map<String, String>()));
            ApexPages.CurrentPage().getParameters().put('materialNumber', '5467');
            MSDSSiteExtMaterialDetailController  controller = new MSDSSiteExtMaterialDetailController ();
        Test.stopTest();  
    }
    
    public static testMethod void getSDSDocument() {
        setupData();
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new MockHttpGenerator(200, '200', DOCUMENT_RESPONSE, new Map<String, String>()));        
          String documentId = MSDSSiteExtMaterialDetailController.getSDSDocument('5467', '7666000000', '00000000000011347766');
        Test.stopTest();  
    }
    
    public static testMethod void goToMaterialSearch() {
        setupData();
        Test.startTest();
        	MSDSSiteExtMaterialDetailController  controller = new MSDSSiteExtMaterialDetailController ();
			controller.goToMaterialSearch();
        Test.stopTest();  
    }
}