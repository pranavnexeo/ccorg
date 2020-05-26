public class ReorderController {

    // Variable Declerations //
    public String orderId;
    public String SortField{get; set;}
    private String PrevSortField;
    public String SortImage{get; set;}
    public static final String SORT_ASC_IMG = '/img/sort_asc_arrow.gif'; 
    public static final String SORT_DESC_IMG = '/img/sort_desc_arrow.gif'; 
    
    //variable declaration for Custom Lookup
    public String materialName {get; set;}
    public Id materialId {get; set;}
    
    private String salesOrg;
    private String distChan;
    
    private static final String MSD2_QRY1 = '' +
        'Select Id, Sales_UOM_Desc__c, ' + 
        'Material_Number__c, Material_Desc__c, ' + 
        'Sales_UOM__r.Base_UOM_Desc__c, ' + 
        'Material_General_Data__r.Base_UOM_Desc__c ' + 
        'From Material_Sales_Data2__c ';
    
    public Open_Orders__c orderMaster {get; set;}
    public List<Line_Item> LineItems {get; set;}
    public List<New_Reorder> newOrders {get; set;}
    
    public Boolean allDateSelected {get; set;}
    public Boolean allMatsSelected {get; set;}
    public Boolean recordsInserted {get; set;}
    
    public Boolean allOrderSelected {get; set;}
    public Boolean isMultiReorder {get; set;}
    
    public Integer LineItemsSize {get; set;}
    public Integer newOrdersSize {get; set;}
    
    public Reorder_Line_Item__c newRecMat {get; set;}
    
    public Reorder__c reorderHeader {
        get {
            if (reorderHeader == null) {
                reorderHeader = new Reorder__c();
            }
            return reorderHeader;
        } 
        set;
    }
    
    // Variables declared for multiple Open Orders //
    
    public String accountId {get; set;}
    private List<Open_Orders__c> orderMasters;
    public List<Open_Order> orderMasterList;
    
   @TestVisible private static void debug(String s) {
        System.debug(LoggingLevel.INFO, '>>>>>>>>> ' + s);
    }

   @TestVisible private static String getZeroFilled(String s, Integer n) {
        String r = s.trim();
        Integer m = r.length();
        while (m++ < n) {r = '0' + r;}
        return r;
    }
    
   @TestVisible private static Boolean isNull(String s) {
        return (s == null || s.trim().length() == 0);
    }
    
    public List<Open_Order> getOrderMasterList()
    {
        return this.orderMasterList;
    }    
    public void setOrderMasterList(List<Open_Order> orders)
    {
        this.orderMasterList = orders;
    }
    
    
    // Constructor Class //
    public ReorderController(ApexPages.StandardController  sc) {
    
        isMultiReorder = false;
        prevSortField = '';
        SortImage = '';
        SortField = '';

    
        // Enhancement by Ankit //
        if(ApexPages.currentPage().getParameters().containsKey('Id'))
        {
            // Get the Id of the Open_Orders record being cloned.
            orderId = ApexPages.currentPage().getParameters().get('Id');
            
            // Get the Open_Orders record
            try {
                orderMaster = [Select 
                    Agreed_Ship_Date2__c, 
                    Line_Item_Number__c, 
                    Material_Desc__c,
                    Material__c,
                    Material__r.Material_Desc__c,
                    Material__r.Material_Number__c,
                    Name, 
                    Ordered_Qty_UOM__c, 
                    Ordered_Qty__c, 
                    Plant_Desc__c, 
                    Sales_Order_Number__c,
                    Sales_UOM__c, 
                    ShipTo__c, 
                    ShipTo__r.ShippingCity, 
                    ShipTo__r.ShippingCountry, 
                    ShipTo__r.ShippingPostalCode, 
                    ShipTo__r.ShippingState, 
                    ShipTo__r.ShippingStreet, 
                    SoldTo__c 
                From Open_Orders__c where Id = :orderId LIMIT 1][0];        
            } catch (Exception e) {debug('Error 1 : ' + e.getMessage());}
            
            // Get the Line Items for the Open Order

            LineItems = initLineItems();
            
            isMultiReorder = false;         
        }
        // End Enhancement by Ankit //
        else if(ApexPages.currentPage().getParameters().containsKey('accountId'))
        {
             //getting the Account ID
             accountId = ApexPages.currentPage().getParameters().get('accountId');
             orderMasters = new List<Open_Orders__c>();
             //get the Open Order Records
             try {
                orderMasters = [Select 
                    Agreed_Ship_Date2__c, 
                    Line_Item_Number__c, 
                    Material_Desc__c,
                    Material__c,
                    Material__r.Material_Desc__c,
                    Material__r.Material_Number__c,
                    Name, 
                    Ordered_Qty_UOM__c, 
                    Ordered_Qty__c, 
                    Plant_Desc__c, 
                    Sales_Order_Number__c,
                    Sales_UOM__c, 
                    ShipTo__c, 
                    ShipTo__r.ShippingCity, 
                    ShipTo__r.ShippingCountry, 
                    ShipTo__r.ShippingPostalCode, 
                    ShipTo__r.ShippingState, 
                    ShipTo__r.ShippingStreet, 
                    SoldTo__c 
                From Open_Orders__c where ShipTo__c = :accountId];        
            } catch (Exception e) {debug('Error 2 : ' + e.getMessage());}
            
            if(orderMasters != null && orderMasters.size() > 0) {
                orderMaster = orderMasters[0];
                isMultiReorder = true;
            
                Id SoldToId = CISRelationships_Functions.Lookup_Related_Sold_To(accountId);
    
                if(soldToID == null) {
                    orderMaster.soldto__c = AccountID;
                } else {
                    orderMaster.soldto__c = soldToID;
                }
                orderMasterList = new List<Open_Order>();       
                for(Open_Orders__c order : orderMasters) {
                    Open_Order oO = new Open_Order();
                    oO.openOrder = order;
                    oO.isSelected = false;
                    orderMasterList.add(oO);
                }
            }
            LineItems = initLineItems();
        }
        // Defining a temporary order master in case of no open orders //
        
        if(ApexPages.currentPage().getParameters().containsKey('hasOrders')) {
            Account shippingAccount = new Account();
            Account soldToAccount;
            try {
                shippingAccount = getAccount(accountId);
                Id SoldToId = CISRelationships_Functions.Lookup_Related_Sold_To(accountId);
                soldToAccount = getAccount(SoldToId);
            } catch (Exception e) {debug('Error 4 : ' + e.getMessage());}
            
            if(soldToAccount == null) {soldToAccount = shippingAccount;}
            Open_Orders__c tempOrder = new Open_Orders__c();
            tempOrder.ShipTo__c = shippingAccount.Id;
            tempOrder.ShipTo__r = shippingAccount;
            tempOrder.SoldTo__c = soldToAccount.Id;
            orderMaster = tempOrder;
        }
        
        newOrders = new List<New_Reorder>();
        New_Reorder newOrder = new New_Reorder(orderMaster);
        newOrder.isnew = false;
        newOrders.add(newOrder);

        allDateSelected = false;
        allMatsSelected = false;
        recordsInserted = false;
        allOrderSelected = false;
                
        newRecMat = new Reorder_Line_Item__c();
        
        updateSizes();
    }
    
   @TestVisible private Account getAccount(String accId) {
        Account a = null;
        try {
            a = [Select Name, SAP_DistChannel__c, SAP_Sales_Org__c, 
                        ShippingCity, ShippingCountry, ShippingPostalCode, 
                        ShippingState, ShippingStreet 
                   from Account where Id =: accId][0];
            if (salesOrg == null) {salesOrg = a.SAP_Sales_Org__c;}
            if (distChan == null) {distChan = a.SAP_DistChannel__c;}
        } catch(Exception e) {
            debug('getAccount : ' + e.getMessage());
        }
        return a;
    }
    
    // Class Declerations //
    public class New_Reorder {
        public Reorder__c reOrder {get; set;}
        public Boolean selected {get; set;}
        public Boolean isnew {get; set;}
        public New_Reorder(Open_Orders__c oO) {
            reOrder = new Reorder__c();
            reOrder.Requested_Delivery_Date__c = System.today();
            try {
                reOrder.Ship_To__c = oO.ShipTo__c;
                reOrder.Sold_To__c = oO.SoldTo__c;
            } catch(Exception e) {
                debug('New_Reorder Error : ' + e.getMessage());
            }
            selected = false;
            isnew = true;
        } 
    }
    
    public class Line_Item {
        public Reorder_Line_Item__c lineItem {get; set;}
        public Boolean selected {get; set;}
        public Boolean isnew {get; set;}
        public String UoM {get; set;}
        public String matDesc {get; set;}
        public String matNumber {get; set;}
        public Line_Item(Reorder_Line_Item__c li) {
            lineItem = li;
            selected = false;
            isnew = true;
        }
        public void refresh() {
            // Do nothing
        }
    }
       
    public class Open_Order {
        public Open_Orders__c openOrder {get; set;}
        public Boolean isSelected {get; set;}
        public Open_Order()
        {
            openOrder = new Open_Orders__c();
            isSelected = false;
        }
    }
    // Function Declerations //
    
    // Continue Function for Intermdiate Page //
    public Pagereference callReorderPage()
    {
        // Get the Line Items for the Open Order
        LineItems = new List<Line_Item>();
        if (orderMasterList == null || orderMasterList.isEmpty()) {
            return Page.Reorder;
        }
        for(Open_Order oO : orderMasterList) {
            List<Line_Item> tempList = new List<Line_Item>();
            if(oO.isSelected) {
                orderMaster = oO.openOrder;
                tempList = initLineItems();
                for(Line_Item li : tempList) {
                    LineItems.add(li);
                }
            }
        }
        if(orderMasters != null && orderMasters.size() > 0) {
            orderMaster = orderMasters[0];
        }
        updateSizes();
        return Page.Reorder;
    }
    
    // Back Function for reorder Page //
    public PageReference callIntermediatePage()
    {
        Map<String, String> pmap = ApexPages.currentPage().getParameters();
        //System.debug(pmap);
        Boolean hasAccountId = ApexPages.currentPage().getParameters().containsKey('accountId');
        Boolean hasId = ApexPages.currentPage().getParameters().containsKey('Id');
        if (hasId || hasAccountId && !isMultiReorder) {
            String accountId = ApexPages.currentPage().getParameters().get('accountId');
            return new PageReference('/' + accountId);
        } else {
            return Page.ReorderRedirectPage;
        }
    }
    
    public PageReference gotoAccountPage() {
        Boolean hasAccountId = ApexPages.currentPage().getParameters().containsKey('accountId');
        if (hasAccountId) {
            String accountId = ApexPages.currentPage().getParameters().get('accountId');
            return new PageReference('/' + accountId);
        }
        return null;
    }
    
    public List<Line_Item> initLineItems() {
        List<Line_Item> liList = new List<Line_Item>();
        if (orderMaster == null) {
            return liList;
        }         
        Reorder_Line_Item__c newReLi = new Reorder_Line_Item__c();
        newReLi.Material2__c = orderMaster.Material__c;
        Line_Item newLi = new Line_Item(newReLi);
        
        //String salesUOM = orderMaster.Material__r.Sales_UOM__r.Alternative_UOM__c;
        String salesUOM = orderMaster.Sales_UOM__c;
        newLi.UoM = salesUOM;
        
        if(salesUOM!=orderMaster.Ordered_Qty_UOM__c && salesUOM!=null) {
            newReLi.Quantity__c = UoM_Conversion.retrieve_UoM_Conversion(orderMaster.Material__r.Material_Number__c, orderMaster.Ordered_Qty__c.intValue(), orderMaster.Ordered_Qty_UOM__c, newLi.UoM).resultQty;
        } else {
            newReLi.Quantity__c = orderMaster.Ordered_Qty__c;
        }
        if (newReLi.Quantity__c != null) {
            newReLi.Quantity__c = newReLi.Quantity__c.round(System.RoundingMode.UP);
        }
        
        newLi.matDesc = orderMaster.Material__r.Material_Desc__c;
        newLi.matNumber = String_Functions.removeLeadingZeros(orderMaster.Material__r.Material_Number__c);
        liList.add(newLi);

        return liList;
    }
    
    @TestVisible private String orderSummary() {
        String retVal = '';
        String tnknum = '';
        for(Integer i = 0 ; i < LineItems.size() ; i++) {
            tnknum = LineItems[i].lineItem.Tank_Number__c;
            if (tnknum == null || 
                tnknum.trim().length() == 0) {tnknum = '';}
            else {tnknum = 'Tank Number : ' + tnknum;}
            retVal += '('+LineItems[i].lineItem.Quantity__c+
                      ' '+LineItems[i].UoM+')'+
                      ' '+LineItems[i].matNumber+
                      ' '+LineItems[i].matDesc+
                      ' - '+tnknum+
                      '.\n';
        }
        return retVal;
    }
    
    public void addMat() {
        Reorder_Line_Item__c newReLi = new Reorder_Line_Item__c();
        newReLi.Quantity__c = 0;
        Material_Sales_Data2__c tmpMat;
        Line_Item newLi = new Line_Item(newReLi);
        try {
            debug('addMat : ' + newRecMat.Material2__c + ' : ' + materialName);
            if (isNull(newRecMat.Material2__c)) {
                tmpMat = getMaterialByKey(materialName);
            } else {
                newReLi.Material2__c = newRecMat.Material2__c;
                tmpMat = getMaterialById(newRecMat.Material2__c);
            }
            newLi.matDesc = tmpMat.Material_Desc__c;
            newLi.matNumber = String_Functions.removeLeadingZeros(tmpMat.Material_Number__c);
            
            if('['+tmpMat.Sales_UOM_Desc__c+']'=='[null]') {
                newLi.UoM = tmpMat.Material_General_Data__r.Base_UOM_Desc__c;
            } else {
                newLi.UoM = tmpMat.Sales_UOM_Desc__c;
            }
        
            LineItems.add(newLi);
                    
            newRecMat = new Reorder_Line_Item__c();
            updateSizes();
            materialName = '';
        } catch(Exception e) {
            string errmsg = 'Select a valid Material from the lookup';
            ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.Error, errmsg);
            ApexPages.addMessage(mymsg);
            debug('addMat Error : ' + e.getMessage());
        }
    }
    
   @TestVisible private Material_Sales_Data2__c getMaterialById(String matId) {
        if (isNull(matId)) {return null;}
        String q = MSD2_QRY1 + 'where Id = :matId limit 1';
        debug(q);
        List<Material_Sales_Data2__c> msd2s = null;
        try {msd2s = Database.query(q);} catch(Exception e) {}
        if (msd2s == null || msd2s.isEmpty()) {return null;}
        return msd2s[0];
    }
    
   @TestVisible private Material_Sales_Data2__c getMaterialByKey(String matNum) {
        if (isNull(matNum)) {return null;}
        String recKey = getZeroFilled(matNum, 18) + salesOrg + distChan;
        debug(recKey);
        String q = MSD2_QRY1 + 'where Record_Key__c = :recKey limit 1';
        debug(q);
        List<Material_Sales_Data2__c> msd2s = null;
        try {msd2s = Database.query(q);} catch(Exception e) {}
        if (msd2s == null || msd2s.isEmpty()) {return null;}
        return msd2s[0];
    }
    
    public void delMat() {
        Integer liSize = LineItems.size() - 1;
        for (Integer i = liSize ; i >= 0 ; i--){
            if(LineItems[i].selected == true) {
                LineItems.remove(i);
            }
        }
        allMatsSelected = false;
        updateSizes();
    }
    
    public void addReorder() {
        // Add new New_Order record to newOrders list as a clone of orderMaster
        Open_Orders__c masterCopy = new Open_Orders__c();
        masterCopy = orderMaster.clone();
        New_Reorder newOrder = new New_Reorder(orderMaster);
        newOrder.isnew = false;
        
        newOrders.add(newOrder);
        updateSizes();
    }
    
    public void delReorder() {
        // Removed selected (checked) New_Order records from Requested Date table
        Integer liSize = newOrders.size() - 1;
        for (Integer i = liSize ; i >= 0 ; i--){
            if(newOrders[i].selected == true) {
                newOrders.remove(i);
            }
        }
        allDateSelected = false;    
        updateSizes();
    }
    
    public void updateSizes() {
        if (newOrders != null) {newOrdersSize = newOrders.size();}
        if (LineItems != null) {LineItemsSize = LineItems.size();}
    }
    
   @TestVisible private Boolean validateReorder() {
        String rotype = ''; 
        if (reorderHeader.ReOrder_Type__c != null) {
            rotype = reorderHeader.ReOrder_Type__c.trim();
        }
        if (rotype == 'Contract Billing') {
            String contractNumber = reorderHeader.Contract_Number__c;
            String s1 = 'Invalid Contract Number (Must be numeric and a maximum of 10 digits): ' + contractNumber;
            ApexPages.Message m1 = new ApexPages.Message(ApexPages.Severity.Error, s1);
            if (contractNumber == null || contractNumber.trim().length() < 1) {
                //ApexPages.addMessage(m1);
                //return false;
                return true;
            }
            contractNumber = contractNumber.trim();
            if (contractNumber.length() < 1 || 
                contractNumber.length() > 10) {
                ApexPages.addMessage(m1);
                return false;
            }
            try {
                Integer i = Integer.valueOf(contractNumber);
                return true;
            } catch (Exception e) {
                ApexPages.addMessage(m1);
                return false;
            }
        }
        return true;
    }
    
    // Save Function //
    public PageReference saveReorders() {
        if (!validateReorder()) {return null;}
        PageReference originalOpenOrders;
        if(isMultiReorder || orderId == null) {
            originalOpenOrders = new PageReference('/'+accountId);
        } else {
            originalOpenOrders = new PageReference('/'+orderId);
        }
        if(newOrders.size() > 0 && LineItems.size() > 0) {
            List<Reorder__c> newReorders = new List<Reorder__c>();
            List<Reorder_Line_Item__c> newReorderLis = new List<Reorder_Line_Item__c>();
//Sean changes 
           Set<Date> reOrderDates = new Set<Date>(); 
//end sean changes;
            boolean validOrder = true;
            Reorder__c newReorder;
            Reorder_Line_Item__c newReorderLi;
            for(Integer i = 0 ; i < newOrders.size() ; i++) {
                newReorder = new Reorder__c();
                // Set values in newReorder from newOrders[i] & orderMaster
                newReorder.Ship_To__c = orderMaster.ShipTo__c;
                newReorder.Sold_To__c = orderMaster.SoldTo__c;
                newReorder.ReOrder_Type__c = reorderHeader.ReOrder_Type__c;
                newReorder.Contract_Number__c = reorderHeader.Contract_Number__c;
                newReorder.Customer_PO_Number__c = newOrders[i].reOrder.Customer_PO_Number__c;
                newReorder.Requested_Delivery_Date__c = newOrders[i].reOrder.Requested_Delivery_Date__c;
                newReorder.Special_Instructions__c = newOrders[i].reOrder.Special_Instructions__c;
                newReorder.Order_Summary__c = orderSummary();
//more sean changes     
                if (reorderDates.contains(newOrders[i].reOrder.Requested_Delivery_Date__c)){
                    string errmsg = 'Can not add a reorder with the same date';
                    ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.Error, errmsg);
                    ApexPages.addMessage(mymsg);
                    validOrder = false;
                    return null;
                }
                if (validOrder){
                    //end changes
                   reorderDates.add(newOrders[i].reOrder.Requested_Delivery_Date__c);
                   newReorders.add(newReorder);
                }//end process valid order
            }// end for

            try { 
                insert newReorders;
            } catch (Exception e) {
                debug('Error 8 : ' + e.getMessage());
            }
            
            for(Integer i = 0 ; i < newReorders.size() ; i++) {
                for(Integer j = 0 ; j < LineItems.size() ; j++) {
                    newReorderLi = new Reorder_Line_Item__c();
                    // Set values in newReorderLi from LineItems[j]
                    newReorderLi.Reorder__c = newReorders[i].Id;
                    newReorderLi.Material2__c = LineItems[j].lineItem.Material2__c;
                    newReorderLi.Quantity__c = LineItems[j].lineItem.Quantity__c;
                    newReorderLi.Tank_Number__c = LineItems[j].lineItem.Tank_Number__c;
                    
                    newReorderLis.add(newReorderLi);                
                }
            }

            try { 
                insert newReorderLis;
            } catch (Exception e) {
                debug('Error 9 : ' + e.getMessage());
            }
            
            originalOpenOrders.setRedirect(true);
        } else {
         // Display error
            if (LineItemsSize == 0){
                string errmsg = 'At least one Line Item is required.';
                ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.Error, errmsg);
                ApexPages.addMessage(mymsg);
                return null;    
            }
            if (newOrdersSize == 0){
                string errmsg = 'At least one Requested Date is required.';
                ApexPages.Message mymsg = new ApexPages.Message(ApexPages.Severity.Error, errmsg);
                ApexPages.addMessage(mymsg);
                return null;    
            }   
        }
        return originalOpenOrders;
    }
    
    public Boolean isContractType {get; private set;}

    public void updateOrderType() {
        debug('updateOrderType : '+reorderHeader.ReOrder_Type__c);
        isContractType = (reorderHeader.ReOrder_Type__c != null && 
                          reorderHeader.ReOrder_Type__c == 'Contract Billing'); 
    }

    public pagereference SortMasterList(){
    
        /*This checks to see if the same header was click two times in a row, if so 
        it switches the order.*/
        boolean ascsortorder = true;
        if(prevSortField == sortField){
            ascsortOrder = false;
            prevSortField = '';
            sortimage = SORT_DESC_IMG;
        }else{
            ascsortOrder = true;
            prevSortField = sortField;
            sortimage = SORT_ASC_IMG;
        }
        
       List<Open_Orders__c> templist = new list<Open_Orders__c>();
       Map<ID, boolean> selectedmap = new map<ID, boolean>();
       
       for(Open_Order o:orderMasterList){
           templist.add(o.openorder);
           selectedmap.put(o.openorder.id, o.isselected);     
       }
       Sort_Helper SH = new Sort_Helper();
       templist = SH.getSortedList(templist, SortField, ascsortorder);
       
       ordermasterlist.clear();
       for(integer i=0; i<templist.size(); i++){
           Open_Order open = new Open_Order();
           open.openorder = templist.get(i);
           open.isselected = selectedmap.get(open.openorder.id);
           orderMasterList.add(open);
       }
       templist.clear();
       return null;
    }

/*
 **************************************************
 * Test methods are in ReorderController_Test class
 **************************************************
 */
     
}