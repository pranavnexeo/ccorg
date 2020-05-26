@isTest

Public class SavePDFSupplierPage_test{
    Public static TestMethod void testMe(){
        Test.startTest();
        String matnum = '010000000123456789';
        String salesOrg = '1234';
        String distChan = '30';
    
        User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
        
        List<Nexeo_Competitor__c> ReqSupplier = new List<Nexeo_Competitor__c>();
        Id RecordTypeIdNexeoCompetitorCompetitor = Schema.SObjectType.Nexeo_Competitor__c.getRecordTypeInfosByName().get('Competitor').getRecordTypeId();
        Nexeo_Competitor__c nc = new Nexeo_Competitor__c(Technical_Service_Representative__c = u.id,Product_Specialist__c = u.id,Product_Line_Manager__c = u.id,Call_Report__c = true,Supplies_To__c = 'Chemicals',Competitor_or_Supplier__c = 'Supplier',name = 'test',Status__c='Active',RecordTypeid=RecordTypeIdNexeoCompetitorCompetitor);
        insert nc; 
        ReqSupplier.add(nc);
                     
        Material_Base_Code__c mbc = new Material_Base_Code__c(Material_Base_Code__c='testdata12',Material_Base_Code_Description__c='testingdata12');                   
        insert mbc;
          
        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        mgd2.Material_Base_Code__c = mbc.id;
        mgd2.Division_Code__c='31';
        insert mgd2;
        
        List<Material_Sales_Data2__c> msdl = new List<Material_Sales_Data2__c>();
        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Material_Base_Code__c = 'testdata12';
        msd2.Material_Base_Code_Desc__c = 'testingdata12';
        msd2.PH4_Supplier__c = 'test';
        msd2.Division_Desc__c = 'chemical';
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        //msd2.Marked_for_Deletion__c = false;
        
        msd2.Record_Key__c = matnum + salesOrg + distChan;
        msd2.Material_General_Data__c= mgd2.Id;
        insert msd2;
        msdl.add(msd2);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(nc);
        
        
        PageReference pageRef = page.SavePDFSupplierPage;
        pageRef.getParameters().Put('ids',nc.id);
        Test.setCurrentPage(pageRef);
        SavePDFSupplierPage sp = new SavePDFSupplierPage();
        Test.StopTest();
    }
}