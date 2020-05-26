@isTest
private class OppToConsConvert_Test {

static testMethod void myUnitTest() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
       string rto = 'Account';
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
    
    	Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Distribution Targets').getRecordTypeId();
               
        Opportunity Opp = new Opportunity();
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        //opp.product_of_interest_other__c = '12345'; 
        opp.price_unit_of_measure__c = 'KG';
       
        opp.details__c = 'These are my details';
        Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        opp.recordtypeid = RecordTypeIdOpp;

        insert opp;

        Nexeo_Competitor__c ncc = new Nexeo_Competitor__c(Name = 'Test');
        insert ncc;
        
        Nexeo_Competitor_to_Opportunity__c nc=new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=opp.id,Nexeo_Competitor__c = ncc.id );
        insert nc;
        
        list<Nexeo_Competitor_to_Opportunity__c> NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();  
        NCOList.add(nc);
        
        apexpages.currentpage().getparameters().put('redirectto', rto);
        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup();
        c.processcancel();
        c.showPopup();
       

}

static testMethod void myUnitTest2() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
       string rto = 'Account';
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
    	Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Distribution Plastics').getRecordTypeId();

        Opportunity Opp = new Opportunity();
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        opp.price_unit_of_measure__c = 'KG';
       
        opp.details__c = 'These are my details';
        Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        opp.recordtypeid = RecordTypeIdOpp;

        insert opp;

        Nexeo_Competitor__c ncc = new Nexeo_Competitor__c(Name = 'Test');
        insert ncc;
        
        Nexeo_Competitor_to_Opportunity__c nc=new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=opp.id,Nexeo_Competitor__c = ncc.id );
        insert nc;
        
        list<Nexeo_Competitor_to_Opportunity__c> NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();  
        NCOList.add(nc);
        
        apexpages.currentpage().getparameters().put('redirectto', rto);
        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup();
        c.processcancel();
        c.showPopup();
       

}

static testMethod void myUnitTest3() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
       string rto = 'Account';
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
         
       	Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Distribution Plastics EMEA').getRecordTypeId();

        Opportunity Opp = new Opportunity();
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        opp.price_unit_of_measure__c = 'KG';
       
        opp.details__c = 'These are my details';
        Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        opp.recordtypeid = RecordTypeIdOpp;
    	opp.ADE_Tech_Rep_Required__c = 'No'; 

        insert opp;

        Nexeo_Competitor__c ncc = new Nexeo_Competitor__c(Name = 'Test');
        insert ncc;
        
        Nexeo_Competitor_to_Opportunity__c nc=new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=opp.id,Nexeo_Competitor__c = ncc.id );
        insert nc;
        
        list<Nexeo_Competitor_to_Opportunity__c> NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();  
        NCOList.add(nc);
        
        apexpages.currentpage().getparameters().put('redirectto', rto);
        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup();
        c.processcancel();
        c.showPopup();
       

}

static testMethod void myUnitTest4() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
       string rto = 'Account';
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
           
   	    Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Distribution Environmental Services').getRecordTypeId();
 
        Opportunity Opp = new Opportunity();
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        opp.price_unit_of_measure__c = 'KG';
       
        opp.details__c = 'These are my details';
        Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        opp.recordtypeid = RecordTypeIdOpp;

        insert opp;

        Nexeo_Competitor__c ncc = new Nexeo_Competitor__c(Name = 'Test');
        insert ncc;
        
        Nexeo_Competitor_to_Opportunity__c nc=new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=opp.id,Nexeo_Competitor__c = ncc.id );
        insert nc;
        
        list<Nexeo_Competitor_to_Opportunity__c> NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();  
        NCOList.add(nc);
        
        apexpages.currentpage().getparameters().put('redirectto', rto);
        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup();
        c.processcancel();
        c.showPopup();    

}


static testMethod void myUnitTest5() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
       string rto = 'Account';
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
               
    	Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Performance Materials - PM').getRecordTypeId();
        Opportunity Opp = new Opportunity();
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        opp.price_unit_of_measure__c = 'KG';
       
        opp.details__c = 'These are my details';
        Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        opp.recordtypeid = RecordTypeIdOpp;

        insert opp;

        Nexeo_Competitor__c ncc = new Nexeo_Competitor__c(Name = 'Test');
        insert ncc;
        
        Nexeo_Competitor_to_Opportunity__c nc=new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=opp.id,Nexeo_Competitor__c = ncc.id );
        insert nc;
        
        list<Nexeo_Competitor_to_Opportunity__c> NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();  
        NCOList.add(nc);
        
        apexpages.currentpage().getparameters().put('redirectto', rto);
        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup();
        c.processcancel();
        c.showPopup();    

}


static testMethod void myUnitTest6() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
       string rto = 'Test';
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
           
		Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Distribution Chemicals').getRecordTypeId();    
        Opportunity Opp = new Opportunity();
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        opp.price_unit_of_measure__c = 'KG';
       
        opp.details__c = 'These are my details';
        Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        opp.recordtypeid = RecordTypeIdOpp;

        insert opp;

        Nexeo_Competitor__c ncc = new Nexeo_Competitor__c(Name = 'Test');
        insert ncc;
        
        Nexeo_Competitor_to_Opportunity__c nc=new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=opp.id,Nexeo_Competitor__c = ncc.id );
        insert nc;
        
        list<Nexeo_Competitor_to_Opportunity__c> NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();  
        NCOList.add(nc);
        
        apexpages.currentpage().getparameters().put('redirectto', rto);
        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup();
        c.processcancel();
        c.showPopup();    

}
    
static testMethod void myUnitTest7() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
       string rto = 'Account';
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
    	Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Distribution Plastics').getRecordTypeId();

        Opportunity Opp = new Opportunity();
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        opp.price_unit_of_measure__c = 'KG';
       
        opp.details__c = 'These are my details';
        Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        opp.recordtypeid = RecordTypeIdOpp;

        insert opp;
    
    	opp.stagename = 'Closed - Won';
    	update opp;

        Nexeo_Competitor__c ncc = new Nexeo_Competitor__c(Name = 'Test');
        insert ncc;
        
        Nexeo_Competitor_to_Opportunity__c nc=new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=opp.id,Nexeo_Competitor__c = ncc.id );
        insert nc;
        
        list<Nexeo_Competitor_to_Opportunity__c> NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();  
        NCOList.add(nc);
        
        apexpages.currentpage().getparameters().put('redirectto', rto);
        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup();
        c.processcancel();
        c.showPopup();
       

} 
    
static testMethod void myUnitTest8() {
    	Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
       string rto = 'Account';
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        Material_Sales_Data2__c mat = new Material_Sales_Data2__c();
        mat.Material_Number__c = '0000001';
        mat.Name = 'Material-1';
        mat.Dist_Channel_Code__c = '30';
        mat.Record_Key__c = mat.Name;
        mat.Sales_Org_Code__c = '1000';
        insert mat;
        
    	Id RecordTypeIdOpp = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aqualon Opportunity - EMEA').getRecordTypeId();
        Id RecordTypeIdOpp2 = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Aqualon Opportunity - Latin Amer').getRecordTypeId();


        Opportunity Opp = new Opportunity();
        opp.accountid = acc.id;
        opp.SAP_Material__c = mat.id;
        opp.price_unit_of_measure__c = 'KG';
       
        opp.details__c = 'These are my details';
        Opp.product_group__c = 'ABS';
        opp.stagename = 'in';
        Opp.Name = 'Opportunity';
        opp.closedate = system.today();
        opp.recordtypeid = RecordTypeIdOpp;

        insert opp;
    
    	opp.recordtypeid = RecordTypeIdOpp2;
    	opp.stagename = 'Closed - Won';
    	update opp;

        Nexeo_Competitor__c ncc = new Nexeo_Competitor__c(Name = 'Test');
        insert ncc;
        
        Nexeo_Competitor_to_Opportunity__c nc=new Nexeo_Competitor_to_Opportunity__c(Opportunity__c=opp.id,Nexeo_Competitor__c = ncc.id );
        insert nc;
        
        list<Nexeo_Competitor_to_Opportunity__c> NCOList = new list<Nexeo_Competitor_to_Opportunity__c>();  
        NCOList.add(nc);
        
        apexpages.currentpage().getparameters().put('redirectto', rto);
        
        ApexPages.currentpage().getparameters().put('oid', opp.Id);
        ApexPages.StandardController sc = new ApexPages.StandardController(opp); 
        OppToConsConvert c = new OpptoConsConvert(sc);
        c.doconvert();
        c.closePopup();
        c.processcancel();
        c.showPopup();
       

}     


}