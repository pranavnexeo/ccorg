@isTest
private class ReorderController_Test {    
public static testMethod void test01() {
    Map<String, SObject> testData = NexeoTestUtils_Test.initData();
   Test.startTest();
        //createTestData();
        List<Reorder__c> rol = new List<Reorder__c>();
        Reorder__c ro = new Reorder__c(Requested_Delivery_Date__c = system.today(),Customer_PO_Number__c = '2345',ReOrder_Type__c = 'Contract Billing');
        insert ro;
        rol.add(ro);
        
    SAP_Sales_Org__c so;
    SAP_Distribution_Channel__c dc;
    Account shipTo, soldTo, cHerky, invalidAcc;
    Set<String> accountIds; 
    Material_Sales_Data2__c msd2;
    Open_Orders__c openOrder;
    
    String matnum = '010000000123456789';
    String salesOrg = '1234';
    String distChan = '12';
    String salesArea = '00000000';
    String plantCode = '1234';
    String langCode = 'E';
    String salesOrderNumber = 'TestOrder1';
    String lineItemNumber = '000'; 
    so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = salesOrg;
        so.Language_Code__c = langCode;
        insert so;
        
        dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = distChan;
        dc.Language_Code__c = langCode;
        insert dc;
        
        cHerky = new Account(Name = 'CHerky');
        cHerky.Account_Number__c = 'CHerky';
        insert cHerky;

        soldTo = new Account(Name = 'SoldTo');
        soldTo.Account_Number__c = 'SoldTo';
        soldTo.ParentId = cHerky.Id;
        insert soldTo;

        shipTo = new Account(Name = 'ShipTo');
        shipTo.Account_Number__c = 'ShipTo';
        shipTo.SAP_DistChannel__c = dc.Distribution_Channel_Code__c;
        shipTo.SAP_Sales_Org__c = so.Sales_Org_Code__c;
        insert shipTo;

        /*invalidAcc = new Account(Name = 'invalidAcc');
        invalidAcc.Account_Number__c = 'invalidAcc';
        insert invalidAcc;*/
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plantCode;
        insert sp;

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        
        Material_Plant2__c mp2 = new Material_Plant2__c();
        mp2.Material_Number__c = matnum;
        mp2.Plant_Code__c = plantCode;
        mp2.SalesOrg_Code__c = salesOrg;
        mp2.Record_Key__c = matnum + plantCode + salesOrg;
        mp2.Material_General_Data__r = mgd2;
        mp2.SAP_Plant__r = sp;
        mp2.SAP_Sales_Org__r = so;
        insert mp2;
        
                Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = 'E';
        ph1.Product_Hierarchy_Code__c = '!';
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = 'E';
        ph2.Product_Hierarchy_Code__c = '!@#';
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = 'E';
        ph3.Product_Hierarchy_Code__c = '!@#$%^';
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = 'E';
        ph4.Product_Hierarchy_Code__c = '!@#$%^&*(';
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = 'E';
        ph5.Product_Hierarchy_Code__c = '!@#$%^&*()!@';
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = 'E';
        ph6.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%';
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = 'E';
        ph7.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%^&*';
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = ph7.Product_Hierarchy_Code__c;
        pherky2.Product_Hierarchy1__r = ph1;
        pherky2.Product_Hierarchy2__r = ph2;
        pherky2.Product_Hierarchy3__r = ph3;
        pherky2.Product_Hierarchy4__r = ph4;
        pherky2.Product_Hierarchy5__r = ph5;
        pherky2.Product_Hierarchy6__r = ph6;
        pherky2.Product_Hierarchy7__r = ph7;
        insert pherky2;
        
        msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
       // msd2.SalesOrg_Code__r = so;
       // msd2.DistChannel_Code__r = dc;
       // msd2.Material_General_Data__r = mgd2;
       // msd2.Product_Hierarchy__r = pherky2;
       try{
        insert msd2;
        }
        catch(exception e){}
         Test.stopTest(); 
         
        openOrder = new Open_Orders__c();
        openOrder.ShipTo__c = shipTo.Id;
        openOrder.SoldTo__c = soldTo.Id;
        openOrder.Sales_Order_Number__c = salesOrderNumber;
        openOrder.Line_Item_Number__c = lineItemNumber;
        openOrder.Key__c = salesOrderNumber + lineItemNumber;
        openOrder.Agreed_Ship_Date2__c = system.today();
        openOrder.Sales_Order_Number__c = 'test123';
        openOrder.Material__r = msd2;
        try{
        insert openOrder;
        }catch(exception e){}
        
        ApexPages.StandardController sc;
        ApexPages.currentPage().getParameters().put('Id', openOrder.Id);
     
        ReorderController c = new ReorderController(sc);
        c.callReorderPage();
        c.getMaterialByKey('msd2');
        try{
        c.addReorder();
        }catch(exception e){}
        c.materialId = msd2.id;
        c.orderSummary();
               
    }

    static testMethod void test02() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
        //createTestData();
        SAP_Sales_Org__c so;
        SAP_Distribution_Channel__c dc;
        Account shipTo, soldTo, cHerky, invalidAcc;
        Set<String> accountIds; 
        Material_Sales_Data2__c msd2;
        Open_Orders__c openOrder;
        String matnum = '010000000123456789';
        String salesOrg = '1234';
        String distChan = '12';
        String salesArea = '00000000';
        String plantCode = '1234';
        String langCode = 'E';
        String salesOrderNumber = 'TestOrder1';
        String lineItemNumber = '000'; 
        //Test if accessed from account page
        so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = salesOrg;
        so.Language_Code__c = langCode;
        insert so;
        
        dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = distChan;
        dc.Language_Code__c = langCode;
        insert dc;
        
        //cHerky = new Account(Name = 'CHerky');
        //cHerky.Account_Number__c = 'CHerky';
        //insert cHerky;

        soldTo = new Account(Name = 'SoldTo');
        soldTo.Account_Number__c = 'SoldTo';
        //soldTo.ParentId = cHerky.Id;
        insert soldTo;

        shipTo = new Account(Name = 'ShipTo');
        shipTo.Account_Number__c = 'ShipTo';
        shipTo.SAP_DistChannel__c = dc.Distribution_Channel_Code__c;
        shipTo.SAP_Sales_Org__c = so.Sales_Org_Code__c;
        insert shipTo;

        /*invalidAcc = new Account(Name = 'invalidAcc');
        invalidAcc.Account_Number__c = 'invalidAcc';
        insert invalidAcc;*/
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plantCode;
        insert sp;

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        
        Material_Plant2__c mp2 = new Material_Plant2__c();
        mp2.Material_Number__c = matnum;
        mp2.Plant_Code__c = plantCode;
        mp2.SalesOrg_Code__c = salesOrg;
        mp2.Record_Key__c = matnum + plantCode + salesOrg;
        mp2.Material_General_Data__r = mgd2;
        mp2.SAP_Plant__r = sp;
        mp2.SAP_Sales_Org__r = so;
        insert mp2;
        
                Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = 'E';
        ph1.Product_Hierarchy_Code__c = '!';
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = 'E';
        ph2.Product_Hierarchy_Code__c = '!@#';
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = 'E';
        ph3.Product_Hierarchy_Code__c = '!@#$%^';
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = 'E';
        ph4.Product_Hierarchy_Code__c = '!@#$%^&*(';
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = 'E';
        ph5.Product_Hierarchy_Code__c = '!@#$%^&*()!@';
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = 'E';
        ph6.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%';
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = 'E';
        ph7.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%^&*';
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = ph7.Product_Hierarchy_Code__c;
        pherky2.Product_Hierarchy1__r = ph1;
        pherky2.Product_Hierarchy2__r = ph2;
        pherky2.Product_Hierarchy3__r = ph3;
        pherky2.Product_Hierarchy4__r = ph4;
        pherky2.Product_Hierarchy5__r = ph5;
        pherky2.Product_Hierarchy6__r = ph6;
        pherky2.Product_Hierarchy7__r = ph7;
        insert pherky2;
        
        msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
       // msd2.SalesOrg_Code__r = so;
       // msd2.DistChannel_Code__r = dc;
       // msd2.Material_General_Data__r = mgd2;
       // msd2.Product_Hierarchy__r = pherky2;
       try{
        insert msd2;
        }
        catch(exception e){}
        
        openOrder = new Open_Orders__c();
        openOrder.ShipTo__c = shipTo.Id;
        openOrder.SoldTo__c = soldTo.Id;
        openOrder.Sales_Order_Number__c = salesOrderNumber;
        openOrder.Line_Item_Number__c = lineItemNumber;
        openOrder.Key__c = salesOrderNumber + lineItemNumber;
        //openOrder.Material__r = msd2;
        insert openOrder;
        Test.stopTest();
        
        ApexPages.StandardController sc;
        //ApexPages.currentPage().getParameters().put('AccountId', openOrder.ShipTo__c);
        //ApexPages.currentPage().getParameters().put('hasOrders', 'false');
        
        ReorderController c = new ReorderController(sc);
        //PageReference pg1 = c.callReorderPage();
        PageReference pg2 = c.callIntermediatePage();
        List<ReorderController.Open_Order> oml = c.getOrderMasterList();
        c.setOrderMasterList(oml);
        c.SortField = 'Id';
        try{
        c.SortMasterList();        
        c.saveReorders();
        }catch(exception e){}
        ReorderController.getZeroFilled('test',4);

        Reorder_Line_Item__c li = new Reorder_Line_Item__c(Quantity__c = 11);
        //c.getMaterialById(msd2.id);
        c.gotoAccountPage();
        //c.getMaterialByKey('msd2');
        try{
        c.delMat();
        c.accountId = shipTo.Id;
        c.materialName = msd2.Material_Number__c;
        c.initLineItems();
        c.gotoAccountPage();
        c.newRecMat = li;   
        c.addReorder();
        c.saveReorders();
        c.updateOrderType();
        }catch(exception e){}
        
        
    }
    
    static testMethod void test03() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
        //createTestData();
        SAP_Sales_Org__c so;
        SAP_Distribution_Channel__c dc;
        Account shipTo, soldTo, cHerky, invalidAcc;
        Set<String> accountIds; 
        Material_Sales_Data2__c msd2;
        Open_Orders__c openOrder;
        String matnum = '010000000123456789';
        String salesOrg = '1234';
        String distChan = '12';
        String salesArea = '00000000';
        String plantCode = '1234';
        String langCode = 'E';
        String salesOrderNumber = 'TestOrder1';
        String lineItemNumber = '000'; 
        //Test if accessed from account page
        so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = salesOrg;
        so.Language_Code__c = langCode;
        insert so;
        
        dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = distChan;
        dc.Language_Code__c = langCode;
        insert dc;
        
        //cHerky = new Account(Name = 'CHerky');
        //cHerky.Account_Number__c = 'CHerky';
        //insert cHerky;

        soldTo = new Account(Name = 'SoldTo');
        soldTo.Account_Number__c = 'SoldTo';
        //soldTo.ParentId = cHerky.Id;
        insert soldTo;

        shipTo = new Account(Name = 'ShipTo');
        shipTo.Account_Number__c = 'ShipTo';
        shipTo.SAP_DistChannel__c = dc.Distribution_Channel_Code__c;
        shipTo.SAP_Sales_Org__c = so.Sales_Org_Code__c;
        insert shipTo;

        /*invalidAcc = new Account(Name = 'invalidAcc');
        invalidAcc.Account_Number__c = 'invalidAcc';
        insert invalidAcc;*/
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plantCode;
        insert sp;

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        
        Material_Plant2__c mp2 = new Material_Plant2__c();
        mp2.Material_Number__c = matnum;
        mp2.Plant_Code__c = plantCode;
        mp2.SalesOrg_Code__c = salesOrg;
        mp2.Record_Key__c = matnum + plantCode + salesOrg;
        mp2.Material_General_Data__r = mgd2;
        mp2.SAP_Plant__r = sp;
        mp2.SAP_Sales_Org__r = so;
        insert mp2;
        
                Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = 'E';
        ph1.Product_Hierarchy_Code__c = '!';
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = 'E';
        ph2.Product_Hierarchy_Code__c = '!@#';
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = 'E';
        ph3.Product_Hierarchy_Code__c = '!@#$%^';
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = 'E';
        ph4.Product_Hierarchy_Code__c = '!@#$%^&*(';
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = 'E';
        ph5.Product_Hierarchy_Code__c = '!@#$%^&*()!@';
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = 'E';
        ph6.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%';
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = 'E';
        ph7.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%^&*';
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = ph7.Product_Hierarchy_Code__c;
        pherky2.Product_Hierarchy1__r = ph1;
        pherky2.Product_Hierarchy2__r = ph2;
        pherky2.Product_Hierarchy3__r = ph3;
        pherky2.Product_Hierarchy4__r = ph4;
        pherky2.Product_Hierarchy5__r = ph5;
        pherky2.Product_Hierarchy6__r = ph6;
        pherky2.Product_Hierarchy7__r = ph7;
        insert pherky2;
        
        msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
       // msd2.SalesOrg_Code__r = so;
       // msd2.DistChannel_Code__r = dc;
       // msd2.Material_General_Data__r = mgd2;
       // msd2.Product_Hierarchy__r = pherky2;
       try{
        insert msd2;
        }
        catch(exception e){}
        
        openOrder = new Open_Orders__c();
        openOrder.ShipTo__c = shipTo.Id;
        openOrder.SoldTo__c = soldTo.Id;
        openOrder.Sales_Order_Number__c = salesOrderNumber;
        openOrder.Line_Item_Number__c = lineItemNumber;
        openOrder.Key__c = salesOrderNumber + lineItemNumber;
        //openOrder.Material__r = msd2;
        insert openOrder;
        ApexPages.StandardController sc;
       // ApexPages.currentPage().getParameters().put('AccountId', openOrder.ShipTo__c);
       // ApexPages.currentPage().getParameters().put('hasOrders', 'false');
        
        ReorderController c = new ReorderController(sc);
        //PageReference pg1 = c.callReorderPage();
        PageReference pg2 = c.callIntermediatePage();
        List<ReorderController.Open_Order> oml = c.getOrderMasterList();
        Reorder_Line_Item__c li = new Reorder_Line_Item__c(Quantity__c = 11);
       // li.Material2__r = msd2;
        insert li;
        Test.stopTest();
        c.newRecMat = li;
        c.addMat();
        c.updateOrderType();
        c.delReorder();
        c.LineItemsSize = 4;
       // c.getAccount('acc.id');
        c.validateReorder();    
           
         
    }
    
    static testMethod void test04() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
        //createTestData();
        SAP_Sales_Org__c so;
        SAP_Distribution_Channel__c dc;
        Account shipTo, soldTo, cHerky, invalidAcc;
        Set<String> accountIds; 
        Material_Sales_Data2__c msd2;
        Open_Orders__c openOrder;
        String matnum = '010000000123456789';
        String salesOrg = '1234';
        String distChan = '12';
        String salesArea = '00000000';
        String plantCode = '1234';
        String langCode = 'E';
        String salesOrderNumber = 'TestOrder1';
        String lineItemNumber = '000'; 
        //Test if accessed from account page
        so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = salesOrg;
        so.Language_Code__c = langCode;
        insert so;
        
        dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = distChan;
        dc.Language_Code__c = langCode;
        insert dc;
        
        //cHerky = new Account(Name = 'CHerky');
        //cHerky.Account_Number__c = 'CHerky';
        //insert cHerky;

        soldTo = new Account(Name = 'SoldTo');
        soldTo.Account_Number__c = 'SoldTo';
        //soldTo.ParentId = cHerky.Id;
        insert soldTo;

        shipTo = new Account(Name = 'ShipTo');
        shipTo.Account_Number__c = 'ShipTo';
        shipTo.SAP_DistChannel__c = dc.Distribution_Channel_Code__c;
        shipTo.SAP_Sales_Org__c = so.Sales_Org_Code__c;
        insert shipTo;

        /*invalidAcc = new Account(Name = 'invalidAcc');
        invalidAcc.Account_Number__c = 'invalidAcc';
        insert invalidAcc;*/
        
        SAP_Plant__c sp = new SAP_Plant__c();
        sp.Plant_Code__c = plantCode;
        insert sp;

        Material_General_Data2__c mgd2 = new Material_General_Data2__c();
        mgd2.Material_Number__c = matnum;
        insert mgd2;
        
        Material_Plant2__c mp2 = new Material_Plant2__c();
        mp2.Material_Number__c = matnum;
        mp2.Plant_Code__c = plantCode;
        mp2.SalesOrg_Code__c = salesOrg;
        mp2.Record_Key__c = matnum + plantCode + salesOrg;
        mp2.Material_General_Data__r = mgd2;
        mp2.SAP_Plant__r = sp;
        mp2.SAP_Sales_Org__r = so;
        insert mp2;
        
                Product_Hierarchy__c ph1 = new Product_Hierarchy__c();
        ph1.Language_Code__c = 'E';
        ph1.Product_Hierarchy_Code__c = '!';
        insert ph1;

        Product_Hierarchy__c ph2 = new Product_Hierarchy__c();
        ph2.Language_Code__c = 'E';
        ph2.Product_Hierarchy_Code__c = '!@#';
        insert ph2;

        Product_Hierarchy__c ph3 = new Product_Hierarchy__c();
        ph3.Language_Code__c = 'E';
        ph3.Product_Hierarchy_Code__c = '!@#$%^';
        insert ph3;

        Product_Hierarchy__c ph4 = new Product_Hierarchy__c();
        ph4.Language_Code__c = 'E';
        ph4.Product_Hierarchy_Code__c = '!@#$%^&*(';
        insert ph4;

        Product_Hierarchy__c ph5 = new Product_Hierarchy__c();
        ph5.Language_Code__c = 'E';
        ph5.Product_Hierarchy_Code__c = '!@#$%^&*()!@';
        insert ph5;

        Product_Hierarchy__c ph6 = new Product_Hierarchy__c();
        ph6.Language_Code__c = 'E';
        ph6.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%';
        insert ph6;

        Product_Hierarchy__c ph7 = new Product_Hierarchy__c();
        ph7.Language_Code__c = 'E';
        ph7.Product_Hierarchy_Code__c = '!@#$%^&*()!@#$%^&*';
        insert ph7;

        Product_Hierarchy2__c pherky2 = new Product_Hierarchy2__c();
        pherky2.Product_Hierarchy__c = ph7.Product_Hierarchy_Code__c;
        pherky2.Product_Hierarchy1__r = ph1;
        pherky2.Product_Hierarchy2__r = ph2;
        pherky2.Product_Hierarchy3__r = ph3;
        pherky2.Product_Hierarchy4__r = ph4;
        pherky2.Product_Hierarchy5__r = ph5;
        pherky2.Product_Hierarchy6__r = ph6;
        pherky2.Product_Hierarchy7__r = ph7;
        insert pherky2;
        
        msd2 = new Material_Sales_Data2__c();
        msd2.Material_Number__c = matnum;
        msd2.Sales_Org_Code__c = salesOrg;
        msd2.Dist_Channel_Code__c = distChan;
        msd2.Record_Key__c = matnum + salesOrg + distChan;
       // msd2.SalesOrg_Code__r = so;
       // msd2.DistChannel_Code__r = dc;
       // msd2.Material_General_Data__r = mgd2;
       // msd2.Product_Hierarchy__r = pherky2;
       try{
        insert msd2;
        }
        catch(exception e){}
        
        List<Open_Orders__c> ool = new List<Open_Orders__c>();
        openOrder = new Open_Orders__c();
        openOrder.ShipTo__c = shipTo.Id;
        openOrder.SoldTo__c = soldTo.Id;
        openOrder.Sales_Order_Number__c = salesOrderNumber;
        openOrder.Line_Item_Number__c = lineItemNumber;
        openOrder.Key__c = salesOrderNumber + lineItemNumber;
        //openOrder.Material__r = msd2;
        insert openOrder;
        ool.add(openOrder);
        ApexPages.StandardController sc;
       // ApexPages.currentPage().getParameters().put('AccountId', openOrder.ShipTo__c);
       // ApexPages.currentPage().getParameters().put('hasOrders', 'false');
        
        ReorderController c = new ReorderController(sc);
        ReorderController.Open_Order oo1 = new ReorderController.Open_Order();
        oo1.openOrder = openOrder;
        oo1.isSelected = true;
        try{
        oml.add(oo1);
        }catch(exception e){}
        //PageReference pg1 = c.callReorderPage();
        PageReference pg2 = c.callIntermediatePage();
        List<ReorderController.Open_Order> oml = c.getOrderMasterList();
        Reorder_Line_Item__c li = new Reorder_Line_Item__c(Quantity__c = 11);
        li.Material2__c = msd2.id;
        insert li;
        Test.stopTest();
         c.accountId = 'test';
         c.getMaterialById(msd2.id);
         try{
         //c.getAccount(shipTo.id);            
         c.addReorder();   
         c.saveReorders();
         }catch(exception e){}
         
         
    }
    
    static testMethod void test05() {
        Map<String, SObject> testData = NexeoTestUtils_Test.initData();
        Test.startTest();
        //createTestData();
        SAP_Sales_Org__c so;
        SAP_Distribution_Channel__c dc;
        Account shipTo, soldTo, cHerky, invalidAcc;
        Set<String> accountIds; 
        Material_Sales_Data2__c msd2;
        Open_Orders__c openOrder;
        String matnum = '010000000123456789';
        String salesOrg = '1234';
        String distChan = '12';
        String salesArea = '00000000';
        String plantCode = '1234';
        String langCode = 'E';
        String salesOrderNumber = 'TestOrder1';
        String lineItemNumber = '000'; 
        //Test if accessed from account page
        so = new SAP_Sales_Org__c();
        so.Sales_Org_Code__c = salesOrg;
        so.Language_Code__c = langCode;
        insert so;
        
        dc = new SAP_Distribution_Channel__c();
        dc.Distribution_Channel_Code__c = distChan;
        dc.Language_Code__c = langCode;
        insert dc;
        
        cHerky = new Account(Name = 'CHerky');
        cHerky.Account_Number__c = 'CHerky';
        insert cHerky;

        soldTo = new Account(Name = 'SoldTo');
        soldTo.Account_Number__c = 'SoldTo';
        soldTo.ParentId = cHerky.Id;
        insert soldTo;

        shipTo = new Account(Name = 'ShipTo');
        shipTo.Account_Number__c = 'ShipTo';
        shipTo.SAP_DistChannel__c = dc.Distribution_Channel_Code__c;
        shipTo.SAP_Sales_Org__c = so.Sales_Org_Code__c;
        insert shipTo;
        Test.stopTest();
        
        Reorder_Line_Item__c li = new Reorder_Line_Item__c(Quantity__c = 11);
        
        ApexPages.StandardController sc;
        
        ReorderController c = new ReorderController(sc);
        ReorderController.Open_Order oo1 = new ReorderController.Open_Order();
        oo1.openOrder = openOrder;
        oo1.isSelected = true;

        PageReference pg1 = c.callReorderPage();
        PageReference pg2 = c.callIntermediatePage();

         c.getAccount(shipTo.id);
         
        ReorderController.Line_Item litm = new ReorderController.Line_Item(li); 
        litm.UoM = 'test';    
        litm.matDesc = 'test12';
        litm.matNumber = '00013mat55';    
         
    }
    
}