@isTest
private class BW_Sales_Data_Test {

    static testMethod void test01() {
        Test.startTest();
        Account acc = getAccount();
        List<Account_Sales_Figure__c> asfs = new List<Account_Sales_Figure__c>();
        asfs.add(getAccountSales(acc));
        asfs.add(getAccountSales(acc));
        try {insert asfs;} catch(Exception e){}
        asfs = [select Id from Account_Sales_Figure__c where Key__c = '1234567890'];
        System.debug(LoggingLevel.INFO, asfs);
    }
    
    static Account getAccount() {
    
Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account a = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert a;
        /*Account a = new Account();
        a.Name = 'Test Account';
        insert a;*/
        return a;
    }
    
    static Account_Sales_Figure__c getAccountSales(Account a) {
        Account_Sales_Figure__c asf = new Account_Sales_Figure__c();
        asf.Account__c = a.Id;
        asf.Key__c = '1234567890';
        return asf;
    }
    
    static void insertMaterials() {
        List<Material_Sales_Data2__c> mats = new List<Material_Sales_Data2__c>();
        Material_Sales_Data2__c mat;
        for(Integer i=0;i<50;i++) {
            mat = new Material_Sales_Data2__c();
            mat.Material_Number__c = '000000' + i;
            mat.Name = 'Material-' + i;
            mat.Dist_Channel_Code__c = '12';
            mat.Record_Key__c = mat.Name;
            mat.Sales_Org_Code__c = '1234';
            mats.add(mat);
        }
        insert mats;
    }

 public static testMethod void testASRPE() {
        
        //Set up the Test Data
        /*Account acct = new Account(name='test');
        insert acct;*/
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
   Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account acct = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert acct;
        insertMaterials();
        //List<CIS_Materials__c> material = [SELECT Id FROM CIS_Materials__c LIMIT 50];
        List<Material_Sales_Data2__c> material = [SELECT Id FROM Material_Sales_Data2__c LIMIT 50];
        List<Product_Sales_Figure__c> productsfs = new List<Product_Sales_Figure__c>();
        Product_Sales_Figure__c sf;
        
        for(Integer i=0;i<50;i++)
            {
            sf = new Product_Sales_Figure__c(Account__c=acct.Id,
                                             Material2__c=material[i].Id,
                                             Billed_Unit_of_Measure__c='LB',
                                             Billed_Volume__c=100000,
                                             GM__c=5000,
                                             GMpct__c=5,
                                             Month_Year__c=System.today().addMonths(-6),
                                             Sales_Amount__c=500000,
                                             Sales_Volume__c=100000,
                                             Sales_Volume_UOM__c='LB',
                                             Key__c = acct.Id + '-' + material[i].Id + '-' + System.today().addMonths(-12)
                                             );
            productsfs.add(sf);                                                                  
            }                                                     
        insert productsfs;

        List<Account_Sales_Figure__c> acctsfs = new List<Account_Sales_Figure__c>();
        Account_Sales_Figure__c asf1 = new Account_Sales_Figure__c(Account__c=acct.Id,
                                                                 Date_Range_Label__c='Current Month',
                                                                 Start_Date__c=System.today().addMonths(-2),
                                                                 End_Date__c=System.today().addMonths(-2),
                                                                 GM__c=5000,
                                                                 GMpct__c=5,
                                                                 Sales_Amount__c=500000,
                                                                 Sales_Volume_in_LBs__c=100000,
                                                                 Sales_Volume_in_KGs__c=60000,
                                                                 Sales_Volume_in_UNs__c=2000,
                                                                 Sales_Volume_in_GALs__c=200,
                                                                 Sales_Volume_in_PTs__c=10,
                                                                 Key__c = acct.Id + 'Current Month'
                                                                 );
        acctsfs.add(asf1);                                                               

        Account_Sales_Figure__c asf2 = new Account_Sales_Figure__c(Account__c=acct.Id,
                                                                 Date_Range_Label__c='PY Current Month',
                                                                 Start_Date__c=System.today().addMonths(-2),
                                                                 End_Date__c=System.today().addMonths(-2),
                                                                 GM__c=5000,
                                                                 GMpct__c=5,
                                                                 Sales_Amount__c=500000,
                                                                 Sales_Volume_in_LBs__c=100000,
                                                                 Sales_Volume_in_KGs__c=60000,
                                                                 Sales_Volume_in_UNs__c=2000,
                                                                 Sales_Volume_in_GALs__c=200,
                                                                 Sales_Volume_in_PTs__c=10,
                                                                 Key__c = acct.Id + 'PY Current Month'
                                                                 );
        acctsfs.add(asf2);                                                               

        Account_Sales_Figure__c asf3 = new Account_Sales_Figure__c(Account__c=acct.Id,
                                                                 Date_Range_Label__c='FYTD',
                                                                 Start_Date__c=System.today().addMonths(-2),
                                                                 End_Date__c=System.today().addMonths(-2),
                                                                 GM__c=5000,
                                                                 GMpct__c=5,
                                                                 Sales_Amount__c=500000,
                                                                 Sales_Volume_in_LBs__c=100000,
                                                                 Sales_Volume_in_KGs__c=60000,
                                                                 Sales_Volume_in_UNs__c=2000,
                                                                 Sales_Volume_in_GALs__c=200,
                                                                 Sales_Volume_in_PTs__c=10,
                                                                 Key__c = acct.Id + 'FYTD'
                                                                 );
        acctsfs.add(asf3);                                                               

        Account_Sales_Figure__c asf4 = new Account_Sales_Figure__c(Account__c=acct.Id,
                                                                 Date_Range_Label__c='PFYTD',
                                                                 Start_Date__c=System.today().addMonths(-2),
                                                                 End_Date__c=System.today().addMonths(-2),
                                                                 GM__c=5000,
                                                                 GMpct__c=5,
                                                                 Sales_Amount__c=500000,
                                                                 Sales_Volume_in_LBs__c=100000,
                                                                 Sales_Volume_in_KGs__c=60000,
                                                                 Sales_Volume_in_UNs__c=2000,
                                                                 Sales_Volume_in_GALs__c=200,
                                                                 Sales_Volume_in_PTs__c=10,
                                                                 Key__c = acct.Id + 'PFYTD'
                                                                 );
        acctsfs.add(asf4);                                                               
                                                                
        insert acctsfs;
    
        PageReference pageRef = Page.Account_Show_Rolling_Product_Section;
        
        Test.setCurrentPage(pageRef);
    
        ApexPages.StandardController controller = new ApexPages.StandardController(acct);
        Account_Show_Rolling_Product_Extension extension = new Account_Show_Rolling_Product_Extension(controller);
        
        extension.getGmGpLabel();
        extension.searchByMaterialId();
        extension.searchByMaterialName();
        extension.Show_NoData_Message_JS();
        extension.Show_BWData_being_Updated_Message_JS();
        boolean b1 = extension.showLBs;
        boolean b2 = extension.showKGs;
        boolean b3 = extension.showUNs;
        boolean b4 = extension.showPTs;
        boolean b5 = extension.showGLs;
        integer b6 = extension.accountSummaryColumns;
        
        String s = '';
        Boolean b;
        Integer i;
        Double d;

        extension.InitialActions();
        
        Account_Summary_Information acctSummaryInfo = extension.getAccountSummaryInformation();

        b = extension.getFYTDvsPFYTD_Volume_in_LB_Up();
        b = extension.getFYTDvsPFYTD_Volume_in_LB_Down();
        b = extension.getFYTDvsPFYTD_Volume_in_KG_Up();
        b = extension.getFYTDvsPFYTD_Volume_in_KG_Down();
        b = extension.getFYTDvsPFYTD_Volume_in_UN_Up();
        b = extension.getFYTDvsPFYTD_Volume_in_UN_Down();
        b = extension.getFYTDvsPFYTD_Volume_in_GL_Up();
        b = extension.getFYTDvsPFYTD_Volume_in_GL_Down();
        b = extension.getFYTDvsPFYTD_Volume_in_PT_Up();
        b = extension.getFYTDvsPFYTD_Volume_in_PT_Down();
        b = extension.getFYTDvsPFYTD_Amount_Up();
        b = extension.getFYTDvsPFYTD_Amount_Down();
        b = extension.getFYTDvsPFYTD_GM_Up();
        b = extension.getFYTDvsPFYTD_GM_Down();
        b = extension.getFYTDvsPFYTD_GMpct_Up();
        b = extension.getFYTDvsPFYTD_GMpct_Down();
 
        s = extension.labelMonth01;
        s = extension.labelMonth02;
        s = extension.labelMonth03;
        s = extension.labelMonth04;
        s = extension.labelMonth05;
        s = extension.labelMonth06;
        s = extension.labelMonth07;
        s = extension.labelMonth08;
        s = extension.labelMonth09;
        s = extension.labelMonth10;
        s = extension.labelMonth11;
        s = extension.labelMonth12;
        s = extension.labelMonth13;
    
        b = extension.show_Volume_in_LBs;
        b = extension.show_Volume_in_KGs;
        b = extension.show_Volume_in_UNs;
        b = extension.show_Volume_in_GLs;
        b = extension.show_Volume_in_PTs;
        b = extension.show_Amounts;
        b = extension.show_GMs;
        b = extension.show_GMpcts;
        
        string s24 = acctSummaryInfo.FYTD_Volume_in_LB_style;
        string s1 = acctSummaryInfo.FYTD_Volume_in_KG_style;
        string s2 = acctSummaryInfo.FYTD_Volume_in_UN_style;
        string s3 = acctSummaryInfo.FYTD_Volume_in_GL_style;
        string s4 = acctSummaryInfo.FYTD_Volume_in_PT_style;
        string s5 = acctSummaryInfo.FYTD_Amount_style;
        string s6 = acctSummaryInfo.FYTD_GM_style;
        string s7 = acctSummaryInfo.FYTD_GMpct_style;
        
        string s8 = acctSummaryInfo.PFYTD_Volume_in_LB_style;
        string s9 = acctSummaryInfo.PFYTD_Volume_in_KG_style;
        string s10 = acctSummaryInfo.PFYTD_Volume_in_UN_style;
        string s11 = acctSummaryInfo.PFYTD_Volume_in_GL_style;
        string s12 = acctSummaryInfo.PFYTD_Volume_in_PT_style;
        string s13 = acctSummaryInfo.PFYTD_Amount_style;
        string s14 = acctSummaryInfo.PFYTD_GM_style;
        string s15 = acctSummaryInfo.PFYTD_GMpct_style ;
        
        string s16 = acctSummaryInfo.FYTDvsPFYTD_Volume_in_LB_Variance_style;
        string s17 = acctSummaryInfo.FYTDvsPFYTD_Volume_in_KG_Variance_style;
        string s18 = acctSummaryInfo.FYTDvsPFYTD_Volume_in_UN_Variance_style;
        string s19 = acctSummaryInfo.FYTDvsPFYTD_Volume_in_GL_Variance_style;
        string s20 = acctSummaryInfo.FYTDvsPFYTD_Volume_in_PT_Variance_style;
        string s21 = acctSummaryInfo.FYTDvsPFYTD_Amount_Variance_style;
        string s22 = acctSummaryInfo.FYTDvsPFYTD_GM_Variance_style;
        string s23 = acctSummaryInfo.FYTDvsPFYTD_GMpct_Variance_style;

        i = extension.currentPage;
        i = extension.pageCount;

        System.debug(extension.getPageInfo());
      
        b = extension.getshow_NextPageButton();
        b = extension.getshow_PreviousPageButton();
        extension.previousPage();
        extension.nextPage();
        System.debug(extension.getPageInfo());
        b = extension.getshow_NextPageButton();
        extension.nextPage();
        System.debug(extension.getPageInfo());
        extension.nextPage();
        System.debug(extension.getPageInfo());
        extension.nextPage();
        System.debug(extension.getPageInfo());
        extension.nextPage();
        System.debug(extension.getPageInfo());
        extension.nextPage();
        System.debug(extension.getPageInfo());
        extension.nextPage();
        System.debug(extension.getPageInfo());
        extension.nextPage();
        extension.nextPage();
        extension.nextPage();
        extension.nextPage();
        extension.nextPage();
        extension.nextPage();
        extension.nextPage();
        b = extension.getshow_NextPageButton();
        extension.nextPage();
        b = extension.getshow_NextPageButton();
        b = extension.getshow_PreviousPageButton();
        extension.previousPage();
        System.debug(extension.getPageInfo());
        ApexPages.currentPage().getParameters().put('pageNumber', '1');
        extension.goToPage();
        ApexPages.currentPage().getParameters().put('pageNumber', '0');
        extension.goToPage();
        ApexPages.currentPage().getParameters().put('pageNumber', '100');
        extension.goToPage();
        s = extension.getPageInfo();
        List<Integer> ints = extension.getpages();
        s = extension.getRollingTitle();
      
        extension.button_Show_Volume_in_LBs();
        s = extension.getRollingTitle();
        extension.button_Show_Volume_in_KGs();
        s = extension.getRollingTitle();
        extension.button_Show_Volume_in_UNs();
        s = extension.getRollingTitle();
        extension.button_Show_Volume_in_GLs();
        s = extension.getRollingTitle();
        extension.button_Show_Volume_in_PTs();
        s = extension.getRollingTitle();
        extension.button_Show_Amounts();
        s = extension.getRollingTitle();
        extension.button_Show_GMs();
        s = extension.getRollingTitle();
        extension.button_Show_GMpcts();
        s = extension.getRollingTitle();
      
        
        System.Debug('Records Found = ' + [SELECT Id FROM Rolling_Product_Sales_Info__c WHERE Account__c = :acct.Id]);
      
        List<Rolling_Product_Sales_Info_Line> lineItems = extension.getRolling_Product_Sales_Info();
        if (lineItems == null || lineItems.isEmpty()) {
            return;
        }      
        Rolling_Product_Sales_Info_Line l = lineItems[0];

        Id testId = l.LineItemId;     
        Rolling_Product_Sales_Info__c rec = l.LineItemRec;
        s = l.MaterialName;
        s = l.ValueType;     
      
        //Test Month 01
        l.ValueType = 'Amount';s = l.getValue_Month_01();
        l.ValueType = 'GM';s = l.getValue_Month_01();
        l.ValueType = 'GMpct';s = l.getValue_Month_01();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_01();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_01();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_01();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_01();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_01();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_01__c = -1.0;s = l.getStyle_Month_01();
                               l.LineItemRec.Amount_Month_01__c =  0.0;s = l.getStyle_Month_01();
                               l.LineItemRec.Amount_Month_01__c =  1.0;s = l.getStyle_Month_01();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_01__c = -1.0;s = l.getStyle_Month_01();
                           l.LineItemRec.GM_Month_01__c =  0.0;s = l.getStyle_Month_01();
                           l.LineItemRec.GM_Month_01__c =  1.0;s = l.getStyle_Month_01();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_01__c = -1.0;s = l.getStyle_Month_01();
                              l.LineItemRec.GMpct_Month_01__c =  0.0;s = l.getStyle_Month_01();
                              l.LineItemRec.GMpct_Month_01__c =  1.0;s = l.getStyle_Month_01();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_01__c = -1.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_KG_Month_01__c =  0.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_KG_Month_01__c =  1.0;s = l.getStyle_Month_01();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_01__c = -1.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_LB_Month_01__c =  0.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_LB_Month_01__c =  1.0;s = l.getStyle_Month_01();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_01__c = -1.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_LB_Month_01__c =  0.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_LB_Month_01__c =  1.0;s = l.getStyle_Month_01();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_01__c = -1.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_GL_Month_01__c =  0.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_GL_Month_01__c =  1.0;s = l.getStyle_Month_01();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_01__c = -1.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_PT_Month_01__c =  0.0;s = l.getStyle_Month_01();
                                   l.LineItemRec.Volume_in_PT_Month_01__c =  1.0;s = l.getStyle_Month_01();
      
        //Test Month 02
        l.ValueType = 'Amount';s = l.getValue_Month_02();
        l.ValueType = 'GM';s = l.getValue_Month_02();
        l.ValueType = 'GMpct';s = l.getValue_Month_02();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_02();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_02();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_02();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_02();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_02();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_02__c = -1.0;s = l.getStyle_Month_02();
                               l.LineItemRec.Amount_Month_02__c =  0.0;s = l.getStyle_Month_02();
                               l.LineItemRec.Amount_Month_02__c =  1.0;s = l.getStyle_Month_02();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_02__c = -1.0;s = l.getStyle_Month_02();
                           l.LineItemRec.GM_Month_02__c =  0.0;s = l.getStyle_Month_02();
                           l.LineItemRec.GM_Month_02__c =  1.0;s = l.getStyle_Month_02();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_02__c = -1.0;s = l.getStyle_Month_02();
                              l.LineItemRec.GMpct_Month_02__c =  0.0;s = l.getStyle_Month_02();
                              l.LineItemRec.GMpct_Month_02__c =  1.0;s = l.getStyle_Month_02();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_02__c = -1.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_KG_Month_02__c =  0.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_KG_Month_02__c =  1.0;s = l.getStyle_Month_02();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_02__c = -1.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_LB_Month_02__c =  0.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_LB_Month_02__c =  1.0;s = l.getStyle_Month_02();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_02__c = -1.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_LB_Month_02__c =  0.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_LB_Month_02__c =  1.0;s = l.getStyle_Month_02();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_02__c = -1.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_GL_Month_02__c =  0.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_GL_Month_02__c =  1.0;s = l.getStyle_Month_02();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_02__c = -1.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_PT_Month_02__c =  0.0;s = l.getStyle_Month_02();
                                   l.LineItemRec.Volume_in_PT_Month_02__c =  1.0;s = l.getStyle_Month_02();
      
        //Test Month 03
        l.ValueType = 'Amount';s = l.getValue_Month_03();
        l.ValueType = 'GM';s = l.getValue_Month_03();
        l.ValueType = 'GMpct';s = l.getValue_Month_03();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_03();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_03();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_03();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_03();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_03();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_03__c = -1.0;s = l.getStyle_Month_03();
                               l.LineItemRec.Amount_Month_03__c =  0.0;s = l.getStyle_Month_03();
                               l.LineItemRec.Amount_Month_03__c =  1.0;s = l.getStyle_Month_03();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_03__c = -1.0;s = l.getStyle_Month_03();
                           l.LineItemRec.GM_Month_03__c =  0.0;s = l.getStyle_Month_03();
                           l.LineItemRec.GM_Month_03__c =  1.0;s = l.getStyle_Month_03();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_03__c = -1.0;s = l.getStyle_Month_03();
                              l.LineItemRec.GMpct_Month_03__c =  0.0;s = l.getStyle_Month_03();
                              l.LineItemRec.GMpct_Month_03__c =  1.0;s = l.getStyle_Month_03();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_03__c = -1.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_KG_Month_03__c =  0.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_KG_Month_03__c =  1.0;s = l.getStyle_Month_03();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_03__c = -1.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_LB_Month_03__c =  0.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_LB_Month_03__c =  1.0;s = l.getStyle_Month_03();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_03__c = -1.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_LB_Month_03__c =  0.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_LB_Month_03__c =  1.0;s = l.getStyle_Month_03();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_03__c = -1.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_GL_Month_03__c =  0.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_GL_Month_03__c =  1.0;s = l.getStyle_Month_03();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_03__c = -1.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_PT_Month_03__c =  0.0;s = l.getStyle_Month_03();
                                   l.LineItemRec.Volume_in_PT_Month_03__c =  1.0;s = l.getStyle_Month_03();
      
        //Test Month 04
        l.ValueType = 'Amount';s = l.getValue_Month_04();
        l.ValueType = 'GM';s = l.getValue_Month_04();
        l.ValueType = 'GMpct';s = l.getValue_Month_04();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_04();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_04();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_04();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_04();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_04();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_04__c = -1.0;s = l.getStyle_Month_04();
                               l.LineItemRec.Amount_Month_04__c =  0.0;s = l.getStyle_Month_04();
                               l.LineItemRec.Amount_Month_04__c =  1.0;s = l.getStyle_Month_04();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_04__c = -1.0;s = l.getStyle_Month_04();
                           l.LineItemRec.GM_Month_04__c =  0.0;s = l.getStyle_Month_04();
                           l.LineItemRec.GM_Month_04__c =  1.0;s = l.getStyle_Month_04();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_04__c = -1.0;s = l.getStyle_Month_04();
                              l.LineItemRec.GMpct_Month_04__c =  0.0;s = l.getStyle_Month_04();
                              l.LineItemRec.GMpct_Month_04__c =  1.0;s = l.getStyle_Month_04();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_04__c = -1.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_KG_Month_04__c =  0.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_KG_Month_04__c =  1.0;s = l.getStyle_Month_04();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_04__c = -1.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_LB_Month_04__c =  0.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_LB_Month_04__c =  1.0;s = l.getStyle_Month_04();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_04__c = -1.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_LB_Month_04__c =  0.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_LB_Month_04__c =  1.0;s = l.getStyle_Month_04();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_04__c = -1.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_GL_Month_04__c =  0.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_GL_Month_04__c =  1.0;s = l.getStyle_Month_04();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_04__c = -1.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_PT_Month_04__c =  0.0;s = l.getStyle_Month_04();
                                   l.LineItemRec.Volume_in_PT_Month_04__c =  1.0;s = l.getStyle_Month_04();
      
        //Test Month 05
        l.ValueType = 'Amount';s = l.getValue_Month_05();
        l.ValueType = 'GM';s = l.getValue_Month_05();
        l.ValueType = 'GMpct';s = l.getValue_Month_05();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_05();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_05();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_05();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_05();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_05();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_05__c = -1.0;s = l.getStyle_Month_05();
                               l.LineItemRec.Amount_Month_05__c =  0.0;s = l.getStyle_Month_05();
                               l.LineItemRec.Amount_Month_05__c =  1.0;s = l.getStyle_Month_05();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_05__c = -1.0;s = l.getStyle_Month_05();
                           l.LineItemRec.GM_Month_05__c =  0.0;s = l.getStyle_Month_05();
                           l.LineItemRec.GM_Month_05__c =  1.0;s = l.getStyle_Month_05();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_05__c = -1.0;s = l.getStyle_Month_05();
                              l.LineItemRec.GMpct_Month_05__c =  0.0;s = l.getStyle_Month_05();
                              l.LineItemRec.GMpct_Month_05__c =  1.0;s = l.getStyle_Month_05();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_05__c = -1.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_KG_Month_05__c =  0.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_KG_Month_05__c =  1.0;s = l.getStyle_Month_05();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_05__c = -1.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_LB_Month_05__c =  0.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_LB_Month_05__c =  1.0;s = l.getStyle_Month_05();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_05__c = -1.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_LB_Month_05__c =  0.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_LB_Month_05__c =  1.0;s = l.getStyle_Month_05();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_05__c = -1.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_GL_Month_05__c =  0.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_GL_Month_05__c =  1.0;s = l.getStyle_Month_05();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_05__c = -1.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_PT_Month_05__c =  0.0;s = l.getStyle_Month_05();
                                   l.LineItemRec.Volume_in_PT_Month_05__c =  1.0;s = l.getStyle_Month_05();
      
        //Test Month 06
        l.ValueType = 'Amount';s = l.getValue_Month_06();
        l.ValueType = 'GM';s = l.getValue_Month_06();
        l.ValueType = 'GMpct';s = l.getValue_Month_06();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_06();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_06();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_06();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_06();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_06();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_06__c = -1.0;s = l.getStyle_Month_06();
                               l.LineItemRec.Amount_Month_06__c =  0.0;s = l.getStyle_Month_06();
                               l.LineItemRec.Amount_Month_06__c =  1.0;s = l.getStyle_Month_06();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_06__c = -1.0;s = l.getStyle_Month_06();
                           l.LineItemRec.GM_Month_06__c =  0.0;s = l.getStyle_Month_06();
                           l.LineItemRec.GM_Month_06__c =  1.0;s = l.getStyle_Month_06();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_06__c = -1.0;s = l.getStyle_Month_06();
                              l.LineItemRec.GMpct_Month_06__c =  0.0;s = l.getStyle_Month_06();
                              l.LineItemRec.GMpct_Month_06__c =  1.0;s = l.getStyle_Month_06();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_06__c = -1.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_KG_Month_06__c =  0.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_KG_Month_06__c =  1.0;s = l.getStyle_Month_06();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_06__c = -1.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_LB_Month_06__c =  0.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_LB_Month_06__c =  1.0;s = l.getStyle_Month_06();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_06__c = -1.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_LB_Month_06__c =  0.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_LB_Month_06__c =  1.0;s = l.getStyle_Month_06();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_06__c = -1.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_GL_Month_06__c =  0.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_GL_Month_06__c =  1.0;s = l.getStyle_Month_06();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_06__c = -1.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_PT_Month_06__c =  0.0;s = l.getStyle_Month_06();
                                   l.LineItemRec.Volume_in_PT_Month_06__c =  1.0;s = l.getStyle_Month_06();
      
        //Test Month 07
        l.ValueType = 'Amount';s = l.getValue_Month_07();
        l.ValueType = 'GM';s = l.getValue_Month_07();
        l.ValueType = 'GMpct';s = l.getValue_Month_07();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_07();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_07();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_07();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_07();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_07();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_07__c = -1.0;s = l.getStyle_Month_07();
                               l.LineItemRec.Amount_Month_07__c =  0.0;s = l.getStyle_Month_07();
                               l.LineItemRec.Amount_Month_07__c =  1.0;s = l.getStyle_Month_07();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_07__c = -1.0;s = l.getStyle_Month_07();
                           l.LineItemRec.GM_Month_07__c =  0.0;s = l.getStyle_Month_07();
                           l.LineItemRec.GM_Month_07__c =  1.0;s = l.getStyle_Month_07();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_07__c = -1.0;s = l.getStyle_Month_07();
                              l.LineItemRec.GMpct_Month_07__c =  0.0;s = l.getStyle_Month_07();
                              l.LineItemRec.GMpct_Month_07__c =  1.0;s = l.getStyle_Month_07();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_07__c = -1.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_KG_Month_07__c =  0.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_KG_Month_07__c =  1.0;s = l.getStyle_Month_07();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_07__c = -1.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_LB_Month_07__c =  0.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_LB_Month_07__c =  1.0;s = l.getStyle_Month_07();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_07__c = -1.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_LB_Month_07__c =  0.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_LB_Month_07__c =  1.0;s = l.getStyle_Month_07();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_07__c = -1.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_GL_Month_07__c =  0.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_GL_Month_07__c =  1.0;s = l.getStyle_Month_07();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_07__c = -1.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_PT_Month_07__c =  0.0;s = l.getStyle_Month_07();
                                   l.LineItemRec.Volume_in_PT_Month_07__c =  1.0;s = l.getStyle_Month_07();
      
        //Test Month 08
        l.ValueType = 'Amount';s = l.getValue_Month_08();
        l.ValueType = 'GM';s = l.getValue_Month_08();
        l.ValueType = 'GMpct';s = l.getValue_Month_08();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_08();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_08();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_08();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_08();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_08();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_08__c = -1.0;s = l.getStyle_Month_08();
                               l.LineItemRec.Amount_Month_08__c =  0.0;s = l.getStyle_Month_08();
                               l.LineItemRec.Amount_Month_08__c =  1.0;s = l.getStyle_Month_08();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_08__c = -1.0;s = l.getStyle_Month_08();
                           l.LineItemRec.GM_Month_08__c =  0.0;s = l.getStyle_Month_08();
                           l.LineItemRec.GM_Month_08__c =  1.0;s = l.getStyle_Month_08();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_08__c = -1.0;s = l.getStyle_Month_08();
                              l.LineItemRec.GMpct_Month_08__c =  0.0;s = l.getStyle_Month_08();
                              l.LineItemRec.GMpct_Month_08__c =  1.0;s = l.getStyle_Month_08();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_08__c = -1.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_KG_Month_08__c =  0.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_KG_Month_08__c =  1.0;s = l.getStyle_Month_08();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_08__c = -1.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_LB_Month_08__c =  0.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_LB_Month_08__c =  1.0;s = l.getStyle_Month_08();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_08__c = -1.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_LB_Month_08__c =  0.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_LB_Month_08__c =  1.0;s = l.getStyle_Month_08();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_08__c = -1.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_GL_Month_08__c =  0.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_GL_Month_08__c =  1.0;s = l.getStyle_Month_08();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_08__c = -1.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_PT_Month_08__c =  0.0;s = l.getStyle_Month_08();
                                   l.LineItemRec.Volume_in_PT_Month_08__c =  1.0;s = l.getStyle_Month_08();
      
        //Test Month 09
        l.ValueType = 'Amount';s = l.getValue_Month_09();
        l.ValueType = 'GM';s = l.getValue_Month_09();
        l.ValueType = 'GMpct';s = l.getValue_Month_09();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_09();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_09();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_09();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_09();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_09();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_09__c = -1.0;s = l.getStyle_Month_09();
                               l.LineItemRec.Amount_Month_09__c =  0.0;s = l.getStyle_Month_09();
                               l.LineItemRec.Amount_Month_09__c =  1.0;s = l.getStyle_Month_09();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_09__c = -1.0;s = l.getStyle_Month_09();
                           l.LineItemRec.GM_Month_09__c =  0.0;s = l.getStyle_Month_09();
                           l.LineItemRec.GM_Month_09__c =  1.0;s = l.getStyle_Month_09();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_09__c = -1.0;s = l.getStyle_Month_09();
                              l.LineItemRec.GMpct_Month_09__c =  0.0;s = l.getStyle_Month_09();
                              l.LineItemRec.GMpct_Month_09__c =  1.0;s = l.getStyle_Month_09();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_09__c = -1.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_KG_Month_09__c =  0.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_KG_Month_09__c =  1.0;s = l.getStyle_Month_09();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_09__c = -1.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_LB_Month_09__c =  0.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_LB_Month_09__c =  1.0;s = l.getStyle_Month_09();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_09__c = -1.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_LB_Month_09__c =  0.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_LB_Month_09__c =  1.0;s = l.getStyle_Month_09();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_09__c = -1.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_GL_Month_09__c =  0.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_GL_Month_09__c =  1.0;s = l.getStyle_Month_09();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_09__c = -1.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_PT_Month_09__c =  0.0;s = l.getStyle_Month_09();
                                   l.LineItemRec.Volume_in_PT_Month_09__c =  1.0;s = l.getStyle_Month_09();
      
        //Test Month 10
        l.ValueType = 'Amount';s = l.getValue_Month_10();
        l.ValueType = 'GM';s = l.getValue_Month_10();
        l.ValueType = 'GMpct';s = l.getValue_Month_10();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_10();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_10();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_10();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_10();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_10();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_10__c = -1.0;s = l.getStyle_Month_10();
                               l.LineItemRec.Amount_Month_10__c =  0.0;s = l.getStyle_Month_10();
                               l.LineItemRec.Amount_Month_10__c =  1.0;s = l.getStyle_Month_10();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_10__c = -1.0;s = l.getStyle_Month_10();
                           l.LineItemRec.GM_Month_10__c =  0.0;s = l.getStyle_Month_10();
                           l.LineItemRec.GM_Month_10__c =  1.0;s = l.getStyle_Month_10();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_10__c = -1.0;s = l.getStyle_Month_10();
                              l.LineItemRec.GMpct_Month_10__c =  0.0;s = l.getStyle_Month_10();
                              l.LineItemRec.GMpct_Month_10__c =  1.0;s = l.getStyle_Month_10();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_10__c = -1.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_KG_Month_10__c =  0.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_KG_Month_10__c =  1.0;s = l.getStyle_Month_10();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_10__c = -1.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_LB_Month_10__c =  0.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_LB_Month_10__c =  1.0;s = l.getStyle_Month_10();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_10__c = -1.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_LB_Month_10__c =  0.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_LB_Month_10__c =  1.0;s = l.getStyle_Month_10();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_10__c = -1.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_GL_Month_10__c =  0.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_GL_Month_10__c =  1.0;s = l.getStyle_Month_10();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_10__c = -1.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_PT_Month_10__c =  0.0;s = l.getStyle_Month_10();
                                   l.LineItemRec.Volume_in_PT_Month_10__c =  1.0;s = l.getStyle_Month_10();
      
        //Test Month 11
        l.ValueType = 'Amount';s = l.getValue_Month_11();
        l.ValueType = 'GM';s = l.getValue_Month_11();
        l.ValueType = 'GMpct';s = l.getValue_Month_11();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_11();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_11();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_11();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_11();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_11();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_11__c = -1.0;s = l.getStyle_Month_11();
                               l.LineItemRec.Amount_Month_11__c =  0.0;s = l.getStyle_Month_11();
                               l.LineItemRec.Amount_Month_11__c =  1.0;s = l.getStyle_Month_11();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_11__c = -1.0;s = l.getStyle_Month_11();
                           l.LineItemRec.GM_Month_11__c =  0.0;s = l.getStyle_Month_11();
                           l.LineItemRec.GM_Month_11__c =  1.0;s = l.getStyle_Month_11();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_11__c = -1.0;s = l.getStyle_Month_11();
                              l.LineItemRec.GMpct_Month_11__c =  0.0;s = l.getStyle_Month_11();
                              l.LineItemRec.GMpct_Month_11__c =  1.0;s = l.getStyle_Month_11();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_11__c = -1.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_KG_Month_11__c =  0.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_KG_Month_11__c =  1.0;s = l.getStyle_Month_11();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_11__c = -1.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_LB_Month_11__c =  0.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_LB_Month_11__c =  1.0;s = l.getStyle_Month_11();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_11__c = -1.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_LB_Month_11__c =  0.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_LB_Month_11__c =  1.0;s = l.getStyle_Month_11();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_11__c = -1.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_GL_Month_11__c =  0.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_GL_Month_11__c =  1.0;s = l.getStyle_Month_11();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_11__c = -1.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_PT_Month_11__c =  0.0;s = l.getStyle_Month_11();
                                   l.LineItemRec.Volume_in_PT_Month_11__c =  1.0;s = l.getStyle_Month_11();
      
        //Test Month 12
        l.ValueType = 'Amount';s = l.getValue_Month_12();
        l.ValueType = 'GM';s = l.getValue_Month_12();
        l.ValueType = 'GMpct';s = l.getValue_Month_12();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_12();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_12();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_12();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_12();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_12();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_12__c = -1.0;s = l.getStyle_Month_12();
                               l.LineItemRec.Amount_Month_12__c =  0.0;s = l.getStyle_Month_12();
                               l.LineItemRec.Amount_Month_12__c =  1.0;s = l.getStyle_Month_12();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_12__c = -1.0;s = l.getStyle_Month_12();
                           l.LineItemRec.GM_Month_12__c =  0.0;s = l.getStyle_Month_12();
                           l.LineItemRec.GM_Month_12__c =  1.0;s = l.getStyle_Month_12();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_12__c = -1.0;s = l.getStyle_Month_12();
                              l.LineItemRec.GMpct_Month_12__c =  0.0;s = l.getStyle_Month_12();
                              l.LineItemRec.GMpct_Month_12__c =  1.0;s = l.getStyle_Month_12();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_12__c = -1.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_KG_Month_12__c =  0.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_KG_Month_12__c =  1.0;s = l.getStyle_Month_12();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_12__c = -1.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_LB_Month_12__c =  0.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_LB_Month_12__c =  1.0;s = l.getStyle_Month_12();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_12__c = -1.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_LB_Month_12__c =  0.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_LB_Month_12__c =  1.0;s = l.getStyle_Month_12();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_12__c = -1.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_GL_Month_12__c =  0.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_GL_Month_12__c =  1.0;s = l.getStyle_Month_12();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_12__c = -1.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_PT_Month_12__c =  0.0;s = l.getStyle_Month_12();
                                   l.LineItemRec.Volume_in_PT_Month_12__c =  1.0;s = l.getStyle_Month_12();
      
        //Test Month 13
        l.ValueType = 'Amount';s = l.getValue_Month_13();
        l.ValueType = 'GM';s = l.getValue_Month_13();
        l.ValueType = 'GMpct';s = l.getValue_Month_13();
        l.ValueType = 'VolumeinKG';s = l.getValue_Month_13();
        l.ValueType = 'VolumeinLB';s = l.getValue_Month_13();
        l.ValueType = 'VolumeinUN';s = l.getValue_Month_13();
        l.ValueType = 'VolumeinGL';s = l.getValue_Month_13();
        l.ValueType = 'VolumeinPT';s = l.getValue_Month_13();
        
        l.ValueType = 'Amount';l.LineItemRec.Amount_Month_13__c = -1.0;s = l.getStyle_Month_13();
                               l.LineItemRec.Amount_Month_13__c =  0.0;s = l.getStyle_Month_13();
                               l.LineItemRec.Amount_Month_13__c =  1.0;s = l.getStyle_Month_13();
        l.ValueType = 'GM';l.LineItemRec.GM_Month_13__c = -1.0;s = l.getStyle_Month_13();
                           l.LineItemRec.GM_Month_13__c =  0.0;s = l.getStyle_Month_13();
                           l.LineItemRec.GM_Month_13__c =  1.0;s = l.getStyle_Month_13();
        l.ValueType = 'GMpct';l.LineItemRec.GMpct_Month_13__c = -1.0;s = l.getStyle_Month_13();
                              l.LineItemRec.GMpct_Month_13__c =  0.0;s = l.getStyle_Month_13();
                              l.LineItemRec.GMpct_Month_13__c =  1.0;s = l.getStyle_Month_13();
        l.ValueType = 'VolumeinKG';l.LineItemRec.Volume_in_KG_Month_13__c = -1.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_KG_Month_13__c =  0.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_KG_Month_13__c =  1.0;s = l.getStyle_Month_13();
        l.ValueType = 'VolumeinLB';l.LineItemRec.Volume_in_LB_Month_13__c = -1.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_LB_Month_13__c =  0.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_LB_Month_13__c =  1.0;s = l.getStyle_Month_13();
        l.ValueType = 'VolumeinUN';l.LineItemRec.Volume_in_LB_Month_13__c = -1.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_LB_Month_13__c =  0.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_LB_Month_13__c =  1.0;s = l.getStyle_Month_13();
        l.ValueType = 'VolumeinGL';l.LineItemRec.Volume_in_GL_Month_13__c = -1.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_GL_Month_13__c =  0.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_GL_Month_13__c =  1.0;s = l.getStyle_Month_13();
        l.ValueType = 'VolumeinPT';l.LineItemRec.Volume_in_PT_Month_13__c = -1.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_PT_Month_13__c =  0.0;s = l.getStyle_Month_13();
                                   l.LineItemRec.Volume_in_PT_Month_13__c =  1.0;s = l.getStyle_Month_13();
      
        //Test Account_Summary_Information Class - acctSummaryInfo
        s = acctSummaryInfo.CM_Label;
        s = acctSummaryInfo.CM_Volume_in_LB_formatted;   
        s = acctSummaryInfo.CM_Volume_in_KG_formatted;   
        s = acctSummaryInfo.CM_Volume_in_UN_formatted;   
        s = acctSummaryInfo.CM_Volume_in_GL_formatted;   
        s = acctSummaryInfo.CM_Volume_in_PT_formatted;   
        s = acctSummaryInfo.CM_Amount_formatted; 
        s = acctSummaryInfo.CM_GM_formatted;
        s = acctSummaryInfo.CM_GMpct_formatted; 
        s = acctSummaryInfo.PYCM_Label; 
        s = acctSummaryInfo.PYCM_Volume_in_LB_formatted; 
        s = acctSummaryInfo.PYCM_Volume_in_KG_formatted;
        s = acctSummaryInfo.PYCM_Volume_in_UN_formatted;
        s = acctSummaryInfo.PYCM_Volume_in_GL_formatted;
        s = acctSummaryInfo.PYCM_Volume_in_PT_formatted;
        s = acctSummaryInfo.PYCM_Amount_formatted;   
        s = acctSummaryInfo.PYCM_GM_formatted;
        s = acctSummaryInfo.PYCM_GMpct_formatted;  
        s = acctSummaryInfo.CMvsPYCM_Label;
        s = acctSummaryInfo.CMvsPYCM_Volume_in_LB_Variance_formatted;   
        s = acctSummaryInfo.CMvsPYCM_Volume_in_KG_Variance_formatted;  
        s = acctSummaryInfo.CMvsPYCM_Volume_in_UN_Variance_formatted;  
        s = acctSummaryInfo.CMvsPYCM_Volume_in_GL_Variance_formatted;  
        s = acctSummaryInfo.CMvsPYCM_Volume_in_PT_Variance_formatted;  
        s = acctSummaryInfo.CMvsPYCM_Amount_Variance_formatted;    
        s = acctSummaryInfo.CMvsPYCM_GM_Variance_formatted;    
        s = acctSummaryInfo.CMvsPYCM_GMpct_Variance_formatted;
        s = acctSummaryInfo.FYTD_Label;
        s = acctSummaryInfo.FYTD_Volume_in_LB_formatted;  
        s = acctSummaryInfo.FYTD_Volume_in_KG_formatted;   
        s = acctSummaryInfo.FYTD_Volume_in_UN_formatted;   
        s = acctSummaryInfo.FYTD_Volume_in_GL_formatted;   
        s = acctSummaryInfo.FYTD_Volume_in_PT_formatted;   
        s = acctSummaryInfo.FYTD_Amount_formatted;
        s = acctSummaryInfo.FYTD_GM_formatted; 
        s = acctSummaryInfo.FYTD_GMpct_formatted;   
        s = acctSummaryInfo.PFYTD_Label;
        s = acctSummaryInfo.PFYTD_Volume_in_LB_formatted;   
        s = acctSummaryInfo.PFYTD_Volume_in_KG_formatted;
        s = acctSummaryInfo.PFYTD_Volume_in_UN_formatted;
        s = acctSummaryInfo.PFYTD_Volume_in_GL_formatted;
        s = acctSummaryInfo.PFYTD_Volume_in_PT_formatted;
        s = acctSummaryInfo.PFYTD_Amount_formatted;     
        s = acctSummaryInfo.PFYTD_GM_formatted;     
        s = acctSummaryInfo.PFYTD_GMpct_formatted;     
        s = acctSummaryInfo.FYTDvsPFYTD_Label;
        s = acctSummaryInfo.FYTDvsPFYTD_Volume_in_LB_Variance_formatted;     
        s = acctSummaryInfo.FYTDvsPFYTD_Volume_in_KG_Variance_formatted;     
        s = acctSummaryInfo.FYTDvsPFYTD_Volume_in_UN_Variance_formatted;     
        s = acctSummaryInfo.FYTDvsPFYTD_Volume_in_GL_Variance_formatted;     
        s = acctSummaryInfo.FYTDvsPFYTD_Volume_in_PT_Variance_formatted;     
        s = acctSummaryInfo.FYTDvsPFYTD_Amount_Variance_formatted;    
        s = acctSummaryInfo.FYTDvsPFYTD_GM_Variance_formatted;     
        s = acctSummaryInfo.FYTDvsPFYTD_GMpct_Variance_formatted;    
        s = acctSummaryInfo.CM_Volume_in_LB_style;   
        s = acctSummaryInfo.CM_Volume_in_KG_style; 
        s = acctSummaryInfo.CM_Volume_in_UN_style; 
        s = acctSummaryInfo.CM_Volume_in_GL_style; 
        s = acctSummaryInfo.CM_Volume_in_PT_style; 
        s = acctSummaryInfo.CM_Amount_style;   
        s = acctSummaryInfo.CM_GM_style;    
        s = acctSummaryInfo.CM_GMpct_style;     
        s = acctSummaryInfo.PYCM_Volume_in_LB_style;    
        s = acctSummaryInfo.PYCM_Volume_in_KG_style;  
        s = acctSummaryInfo.PYCM_Volume_in_UN_style;  
        s = acctSummaryInfo.PYCM_Volume_in_GL_style;  
        s = acctSummaryInfo.PYCM_Volume_in_PT_style;  
        s = acctSummaryInfo.PYCM_Amount_style;    
        s = acctSummaryInfo.PYCM_GM_style;    
        s = acctSummaryInfo.PYCM_GMpct_style;     
        s = acctSummaryInfo.CMvsPYCM_Volume_in_LB_Variance_style;     
        s = acctSummaryInfo.CMvsPYCM_Volume_in_KG_Variance_style;     
        s = acctSummaryInfo.CMvsPYCM_Volume_in_UN_Variance_style;     
        s = acctSummaryInfo.CMvsPYCM_Volume_in_GL_Variance_style;     
        s = acctSummaryInfo.CMvsPYCM_Volume_in_PT_Variance_style;     
        s = acctSummaryInfo.CMvsPYCM_Amount_Variance_style;     
        s = acctSummaryInfo.CMvsPYCM_GM_Variance_style;     
        s = acctSummaryInfo.CMvsPYCM_GMpct_Variance_style;    

    }

}