@isTest
private class Sample_Material_Functions_Test {

static testMethod void myUnitTest() {

Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Test.startTest();
        
    Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
    mat.Material_Number__c = '0000001';
    mat.Name = 'Material-1';
    mat.Dist_Channel_Code__c = '30';
    mat.Record_Key__c = mat.Name;
    mat.Sales_Org_Code__c = '1000';
    insert mat;
        
    List<Sample_Material__c> materials = new List<Sample_Material__c>();
    Sample_Material__c material1 = new Sample_Material__c();
    
    material1.Sample_UOM__c = 'Drum';
    material1.Sample_Quantity__c = 1;
    
    materials.add(material1);
    
    Boolean result = Sample_Material_Functions.List_Contains_Material_Greater_Then_5_Gallons(materials);
    
    System.debug('result = ' + result);

    Account account = new Account();

    account.name = 'Test';
    //account.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Valvoline Customer','Account');
    account.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    account.SAP_SALES_ORG__C = '0315';
    insert account;
    
   
    //System.assertEquals(true,Sample_Material_Functions.SupportsTectylProducts(account.Id));
    //System.assertEquals(false,Sample_Material_Functions.SupportsProductLine(account.Id));
    //System.assertEquals(false,Sample_Material_Functions.SupportsADCompoundProducts(account.Id));


    account = new Account();

    account.name = 'Test';
    account.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Customer','Account');
    account.SAP_SALES_ORG__C = '0315';
    insert account;

    System.debug('Distribution 0315 Tectyl: ' + Sample_Material_Functions.SupportsTectylProducts(account.Id));
    System.debug('Distribution 0315 ProductLine: ' + Sample_Material_Functions.SupportsProductLine(account.Id));
    System.debug('Distribution 0315 ADCompound: ' + Sample_Material_Functions.SupportsADCompoundProducts(account.Id));
    System.debug('Distribution 0315 OakCreek: ' + Sample_Material_Functions.SupportsOakCreek(account.Id));

    //System.assertEquals(false,Sample_Material_Functions.SupportsTectylProducts(account.Id));
    //System.assertEquals(false,Sample_Material_Functions.SupportsProductLine(account.Id));
    //System.assertEquals(true,Sample_Material_Functions.SupportsADCompoundProducts(account.Id));
    //System.assertEquals(false,Sample_Material_Functions.SupportsOakCreek(account.Id));
    
    //System.assertEquals(false,Sample_Material_Functions.SupportsProductDevelopment(account.Id));
    System.debug('SupportsASTSamples = ' + Sample_Material_Functions.SupportsASTSamples());

    account = new Account();

    account.name = 'Test';
    account.SAP_SALES_ORG__C = '0315';
    account.RecordTypeId = RecordType_Functions.LookupRecordTypeId('Distribution Prospect','Account');
    insert account;

   
    //System.assertEquals(true,Sample_Material_Functions.SupportsOakCreek(account.Id));
    
    //Validation Testing
    Sample_Request__c sampleRequest = new Sample_Request__c();
    insert sampleRequest;
    
    List<Sample_Material__c> materials2 = new List<Sample_Material__c>();
    
    Sample_Material__c material2 = new Sample_Material__c();
    material2.Name = 'Test Material';
    material2.Sample_Request__c = sampleRequest.Id;

    materials2.add(material2);

    List<String> errors;
    
    errors = Sample_Material_Functions.Validate_Materials(materials2, account.Id, 'InitialEntry', true, '');
    System.debug('errors - InitialEntry - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    errors = Sample_Material_Functions.Validate_Materials(materials2, account.Id, 'AssignOrderEntrytoCSR', true, '');
    System.debug('errors - AssignOrderEntrytoCSR - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    errors = Sample_Material_Functions.Validate_Materials(materials2, account.Id, 'OrderEntry-CSR', true, '');
    System.debug('errors - OrderEntry-CSR - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    errors = Sample_Material_Functions.Validate_Materials(materials2, account.Id, 'OrderEntry-Coordinator', true, '');
    System.debug('errors - OrderEntry-Coordinator - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    errors = Sample_Material_Functions.Validate_Materials(materials2, account.Id, 'OrderShipped', true, '');
    System.debug('errors - OrderShipped - ' + String_Functions.Format_ListString_into_HTML_List(errors,'Error: ',''));

    Sample_Material__c material3 = new Sample_Material__c();
    materials2.add(material3);

    materials2 = Sample_Material_Functions.Remove_Blank_Rows_From_Material_List(materials2);

    
    Sample_Material_Functions.Delete_Sample_Materials_Not_In_List(sampleRequest,materials2);

    List<Sample_Material__c> materialsForMap = new List<Sample_Material__c>();
    Sample_Material__c mtl1 = new Sample_Material__c();
    mtl1.Name = 'test';
    mtl1.SAP_Material__c = mat.Id;
    materialsForMap.add(mtl1);
    
    List<Sample_Material__c> materialsWithNbrs;
    
    materialsWithNbrs = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(materialsForMap);
    
    List<Sample_Material__c> mtlsrelatedtoSample = Sample_Material_Functions.Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequest.Id);
    Test.stopTest();
  }

}