global with Sharing class cc_mn_ctrl_HomeScreen {
public Boolean isES {get; private set;}
public String guestURL {get; set;}
public String guestLink {get; set;}
    
    
public String urlOrdersImage {get; set;}
public String urlServiceImage {get; set;}
public Integer numberHeaders {get; private set;}
public Integer numberItems {get; private set;}
public List<orderHeadersWrapper> orderHeaders {get; set;} 
public List<orderItemsWrapper> orderItems{get; set;}
public List<newsWrapper> releaseNews {get; set;}
public String cartItems {get; set;} 
List<Account> divCode;
   
    
    public cc_mn_ctrl_HomeScreen(){
        System.debug('FGG'+UserInfo.getUserId());
      
        if(String.valueOf(UserInfo.getUserId())!='0055A000009s7CeQAI'){
            guestURL='';
            divCode=new List<Account>();
            cc_imp_StorefrontSettings__c settings=cc_imp_StorefrontSettings__c.getInstance('mynexeo');        
            isES=isESAccount();
            getContactSettings();
            getOrderHeaders();
            //reOrder();
            getOrderItems();
            getReleaseNews();
            urlOrdersImage=settings.urlOrdersImage__c;
            urlServiceImage=settings.urlServiceImage__c;
            cartItems=getCartNumberItems(ccrz.cc_CallContext.currCartId);
        }
        else{
            cartItems='0';
            urlServiceImage='';
            urlOrdersImage='';
            isES=False;
            guestURL='https://images.nexeo3d.com/wp-content/uploads/mynexeo/ns_mynexeo_prelogin_graphic_en.jpg';
            guestLink='/mynexeo/ccrz__CCSiteLogin';
            numberHeaders=0;
            numberItems=0;
            
        }
    }    
    public static string getCartNumberItems(string cartEncId){
        
        try{
        List<ccrz__E_Cart__c> cart = [select ccrz__TotalQuantity__c from ccrz__E_Cart__c where ccrz__EncryptedId__c=:cartEncId and ccrz__TotalQuantity__c!=null];
        if(cart.size()>0){
            if(cart[0].ccrz__TotalQuantity__c!=null){
                return String.valueOf(cart[0].ccrz__TotalQuantity__c);
            }            
            else{
                return '0';
            }
        }else{
            return '0';
        }
        }catch(Exception exc){            
            System.debug('FGG-Error-cc_mn_ctrl_HomeScreen '+exc.getMessage());            
            return '0';
        }       
    }
    public void getReleaseNews(){    
        String div=getAccountDivision();
        releaseNews=New List<newsWrapper>();
        Date todayDate = Date.today() ;
        String divSearch = '%'+div+'%';       
        User u=ccrz.cc_CallContext.currUser;
        String LocaleSidKey=u.LocaleSidKey;            

        
       List<CC_Release_News__c> News=[select id,name,Body_Content__c,Button_Label__c,Button_Link__c,Title__c,Start_Date__c,End_Date__c, Enabled__c from CC_Release_News__c where Language__c=:LocaleSidKey and Start_Date__c <=:todayDate and End_Date__c>=:todayDate and Enabled__c=True and (Division__c like :divSearch or Division__c='')];
         for (CC_Release_News__c newsItem : News) {
             newsWrapper inw =new newsWrapper();                
             inw.News_Title=newsItem.Title__c;      
             inw.Body_Content=newsItem.Body_Content__c;
             inw.Button_Label=newsItem.Button_Label__c;
             inw.Button_Link=newsItem.Button_Link__c;
             releaseNews.add(inw);             
        }
        
        }
    public String getAccountDivision(){    
        try{            
        List<Account> divCode=[select SAP_DivisionCode__c from Account where id=:ccrz.cc_CallContext.effAccountId and SAP_DivisionCode__c!=null];                   
        if(divCode.size()>0){
            if(divCode[0].SAP_DivisionCode__c!=null){
                return divCode[0].Sap_DivisionCode__c;        
            }
        }   else{
            return '';
        }
        return '';            
        }catch (exception e){   
            System.debug('FGG-Error-cc_mn_ctrl_HomeScreen '+e.getMessage());  
            return '';
        }
    }
    public boolean isESAccount(){  
        try{
        List<Account> divCode=[select SAP_DivisionCode__c,Name from Account where id=:ccrz.cc_CallContext.effAccountId and SAP_DivisionCode__c!=null ];
        if(divCode.size()>0){
            if(divCode[0].SAP_DivisionCode__c=='34')
                return true;
            else
                return false;
        }
        else{
            return false;
        }
        }catch (exception e){  
            System.debug('FGG-Error-cc_mn_ctrl_HomeScreen '+e.getMessage());  
            return false;            
        }
        
    }
    public static Set<id> geteffectiveAccounts(){
        Set<id> effectiveAccounts=new Set<id>();
        Id effectiveAccount=ccrz.cc_CallContext.effAccountId;
        effectiveAccounts.add(effectiveAccount);        
        return effectiveAccounts;  
        /*Need to do the same query as EffectiveAccount selector.*/
    }
    public void getOrderItems(){
    orderItems=new List<orderItemsWrapper>();
    Integer limi=getContactSettingsValues('items');  
    Set<id> effectiveAccounts=geteffectiveAccounts();        
         List<ccrz__E_OrderItem__c> items = [
            SELECT
                Id, 
                ccrz__Product__c,
                ccrz__Product__r.Name,
                ccrz__Product__r.NexeoMaterialId__c,
                ccrz__Product__r.Product_Number__c,
                cc_imp_Sequence__c,
                ccrz__Quantity__c,
                Sales_UoM__c,
                ccrz__UnitOfMeasure__c,
                HS_Unit_of_Measure__c,
                Batch__c,
                Batch1__c,
                Batch2__c,
                Batch3__c,
                Batch4__c,
                Batch5__c,
                Batch6__c,
                Batch7__c,
                Batch8__c,
                Batch9__c,
                Batch10__c,
                Batch11__c,
                Batch12__c,
                Batch13__c,
                Batch14__c,
                Batch15__c,
                ccrz__Order__R.ccrz__OrderId__c,
                Price_Per_Unit__c
            FROM
                ccrz__E_OrderItem__c
            WHERE
                
            //CreatedById='005E0000000Yzrd' and 
             //HS_Unit_of_Measure__c!=null and
             ccrz__Quantity__c>0 and
             ccrz__Product__r.Product_Number__c!=null and
             ccrz__Order__R.ccrz__Account__c in :effectiveAccounts order By CreatedDate desc Limit :limi 
        ];      
        Set<Id> productIdSet = new Set<Id>();
        Set<Id> orderIdSet = new Set<Id>();
        Set<String> productNumbers = new Set<String>();
        for (ccrz__E_OrderItem__c orderItem : items) {            
            productIdSet.add(orderItem.ccrz__Product__c);
            orderIdSet.add(orderItem.ccrz__Order__R.id);
            productNumbers.add(orderItem.ccrz__Product__r.Product_Number__c);
            
        }
        
        
        List<Material_UOM2__c> materialUOMs=[select Alternative_UOM__c,Alt_Net_Weight__c,Material_Number__c from Material_UOM2__c where Material_Number__c in:productNumbers];        
         Map<String,Map<String,Double>> productandConvertionmap= new Map<String,Map<String,Double>>();          
        for(String mat:productNumbers){
            Map<String,Double> conversionmap=new Map<String,Double>();
            for(Material_UOM2__c material:materialUOMs){
                
                if(mat==material.Material_Number__c){
                    conversionmap.put(material.Alternative_UOM__c,material.Alt_Net_Weight__c);                                          
                }
            }
            System.debug('FGG '+conversionmap);
            productandConvertionmap.put(mat,conversionmap);            
            System.debug('FGG'+productandConvertionmap);
        }        
        
        
      
            
        
        Map<Id,String> orderpayment=new Map<Id,String>();
        List<ccrz__E_TransactionPayment__c> ccpayments=[select ccrz__CCOrder__c,ccrz__AccountNumber__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c in :orderIdSet];
        for(ccrz__E_TransactionPayment__c payment:ccpayments){
            orderpayment.put(payment.ccrz__CCOrder__c,payment.ccrz__AccountNumber__c);            
        }                
 
        Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));
            System.debug('FGG Size pliMap'+pliMap.size());
            System.debug('FGG Size productIdSet '+productIdSet.size());
            PricingCustomerPortal pcp=new PricingCustomerPortal();
        for (ccrz__E_OrderItem__c orderItem : items) {
            orderItemsWrapper newExtendedOrderItem = new orderItemsWrapper();            
            newExtendedOrderItem.nexeoMaterialId =orderItem.ccrz__Product__r.NexeoMaterialId__c;               
            newExtendedOrderItem.productNumber = orderItem.ccrz__Product__r.Product_Number__c;
            newExtendedOrderItem.priceperunit= orderItem.Price_Per_Unit__c;
            newExtendedOrderItem.sku=String.valueOf(Integer.valueOf(orderItem.ccrz__Product__r.Product_Number__c));                  
            newExtendedOrderItem.sequenceNumber = Integer.valueOf(orderItem.cc_imp_Sequence__c);
            
             ccrz__E_PriceListItem__c pliuom = pliMap.get(orderItem.ccrz__Product__c);
            if (pliuom != null && (orderItem.HS_Unit_of_Measure__c!='' && orderItem.HS_Unit_of_Measure__c!=null && orderItem.HS_Unit_of_Measure__c!='-')) {
                if(orderItem.HS_Unit_of_Measure__c!=pliuom.ccrz__UnitOfMeasure__c){
                    Map<String, Double> conversionmap=new Map<String, Double>();  
                    System.debug('FGG PN '+orderItem.ccrz__Product__r.Product_Number__c);
                    
                    conversionmap=productandConvertionmap.get(orderItem.ccrz__Product__r.Product_Number__c); 
                    System.debug('FGG conversionmap '+conversionmap);
                    System.debug('FGG orderItem '+orderItem.id);                    
                    string unitFrom=pcp.checkOtherNames(orderItem.HS_Unit_of_Measure__c);                                
                    string unitTo=pcp.checkOtherNames(pliuom.Material_Container_Abbreviation__c);
                    System.debug('FGG conversionmap function values'+conversionmap+'-'+orderItem.ccrz__Quantity__c+'-'+unitFrom+'-'+unitTo);                                                        
                    Decimal tvol=Account_Material_Functions.ConvertUnits(conversionmap, pcp.stringtodouble(String.valueOf(orderItem.ccrz__Quantity__c)), unitFrom,unitTo, false);                              
                    System.debug('FGG tvol'+tvol);
                    if(tvol>0 && tvol<1)
                        newExtendedOrderItem.Qty='1';
                    else{
                        newExtendedOrderItem.Qty=String.valueOf(tvol.setScale(0,RoundingMode.UP)); 
                    }
                    newExtendedOrderItem.SUOM=pcp.checkOtherNames(unitTo);
                }else{
                    newExtendedOrderItem.Qty=String.valueof(orderItem.ccrz__Quantity__c);
                    newExtendedOrderItem.SUOM=pcp.checkOtherNames(orderItem.HS_Unit_of_Measure__c);
                }
            }
            
            newExtendedOrderItem.batchNumber = orderItem.Batch__c;           
            newExtendedOrderItem.batchNumber1 = orderItem.Batch1__c;
            newExtendedOrderItem.batchNumber2 = orderItem.Batch2__c;
            newExtendedOrderItem.batchNumber3 = orderItem.Batch3__c;
            newExtendedOrderItem.batchNumber4 = orderItem.Batch4__c;
            newExtendedOrderItem.batchNumber5 = orderItem.Batch5__c;
            newExtendedOrderItem.batchNumber6 = orderItem.Batch6__c;
            newExtendedOrderItem.batchNumber7 = orderItem.Batch7__c;
            newExtendedOrderItem.batchNumber8 = orderItem.Batch8__c;
            newExtendedOrderItem.batchNumber9 = orderItem.Batch9__c;
            newExtendedOrderItem.batchNumber10 = orderItem.Batch10__c;
            newExtendedOrderItem.batchNumber11 = orderItem.Batch11__c;
            newExtendedOrderItem.batchNumber12 = orderItem.Batch12__c;
            newExtendedOrderItem.batchNumber13 = orderItem.Batch13__c;
            newExtendedOrderItem.batchNumber14 = orderItem.Batch14__c;
            newExtendedOrderItem.batchNumber15 = orderItem.Batch15__c;
            newExtendedOrderItem.productdescription=orderItem.ccrz__Product__r.name;
            newExtendedOrderItem.orderId = orderItem.ccrz__Order__R.ccrz__OrderId__c; 
            newExtendedOrderItem.orderSFDCId = orderItem.ccrz__Order__c;             
            newExtendedOrderItem.po=orderpayment.get(orderItem.ccrz__Order__R.Id);
            newExtendedOrderItem.orderItemId=orderItem.Id;
            newExtendedOrderItem.productId=orderItem.ccrz__Product__c;
            ccrz__E_PriceListItem__c pli = pliMap.get(orderItem.ccrz__Product__c);
            if (pli != null && pli.CPI__c != null) {
                newExtendedOrderItem.customerMaterialNumber = pli.CPI__r.Customer_Material_Number__c;
            }
            orderItems.add(newExtendedOrderItem);  
            System.debug('FGG '+orderItems.size());
        }        
    }
    
    
    @RemoteAction
    global static string reOrder(string orderid, string productid, string qty, string cartEncId,ccrz.cc_RemoteActionContext ctx){  
        ccrz.cc_RemoteActionResult res = ccrz.cc_CallContext.init(ctx);        
        try{
            
        String theCartSFID = ccrz.cc_CallContext.currCartId;//presumes that the cart Id is passed into this code.            
        
        List<ccrz.ccApiCart.LineData> theNewLines = new List<ccrz.ccApiCart.LineData>();        
        if(orderid!=''){              
                 List<ccrz__E_OrderItem__c> items = [
                    SELECT
                        Id, 
                        ccrz__Product__c,
                        ccrz__Quantity__c,
                        HS_Unit_of_Measure__c,
                        ccrz__Product__r.Product_Number__c
                    FROM
                        ccrz__E_OrderItem__c
                    WHERE
                        
                       //CreatedById='005E0000000Yzrd' and 
                       //
                      ccrz__Order__c=:orderid 
                     and
                     HS_Unit_of_Measure__c!=''
                     
                     
                     //ccrz__Order__R.ccrz__Account__c in :effectiveAccounts
                ];      
                Set<String> productNumbers = new Set<String>();
                Set<Id> productIdSet = new Set<Id>();
                PricingCustomerPortal pcp= new PricingCustomerPortal();
                for (ccrz__E_OrderItem__c orderItem : items) {                
                    productIdSet.add(orderItem.ccrz__Product__c);
                    productNumbers.add(orderItem.ccrz__Product__r.Product_Number__c);
                }
                Map<Id, ccrz__E_PriceListItem__c> pliMap = cc_imp_hlpr_PriceListHelper.getPriceListItemsBySequence(new List<Id>(productIdSet));
                List<Material_UOM2__c> materialUOMs=[select Alternative_UOM__c,Alt_Net_Weight__c,Material_Number__c from Material_UOM2__c where Material_Number__c in:productNumbers];        
                Map<String,Map<String,Double>> productandConvertionmap= new Map<String,Map<String,Double>>();          
                for(String mat:productNumbers){
                    Map<String,Double> conversionmap=new Map<String,Double>();
                    for(Material_UOM2__c material:materialUOMs){                
                        if(mat==material.Material_Number__c){
                            conversionmap.put(material.Alternative_UOM__c,material.Alt_Net_Weight__c);                                          
                        }
                    }
                    System.debug('FGG '+conversionmap);
                    productandConvertionmap.put(mat,conversionmap);            
                    System.debug('FGG'+productandConvertionmap);
                }   
                for (ccrz__E_OrderItem__c orderItem : items) {
                    ccrz__E_PriceListItem__c pliuom = pliMap.get(orderItem.ccrz__Product__c);
                    if (pliuom != null && (orderItem.HS_Unit_of_Measure__c!='' && orderItem.HS_Unit_of_Measure__c!=null && orderItem.HS_Unit_of_Measure__c!='-')) {
                        if(orderItem.HS_Unit_of_Measure__c!=pliuom.ccrz__UnitOfMeasure__c){
                            Map<String, Double> conversionmap=new Map<String, Double>();                            
                            ccrz.ccApiCart.LineData theNewLine = new ccrz.ccApiCart.LineData();
                            conversionmap=productandConvertionmap.get(orderItem.ccrz__Product__r.Product_Number__c);                                           
                            string unitFrom=pcp.checkOtherNames(orderItem.HS_Unit_of_Measure__c);                                
                            string unitTo=pcp.checkOtherNames(pliuom.Material_Container_Abbreviation__c);                           
                            Decimal tvol=Account_Material_Functions.ConvertUnits(conversionmap, pcp.stringtodouble(String.valueOf(orderItem.ccrz__Quantity__c)), unitFrom,unitTo, false);                                                       
                            theNewLine.productId=orderItem.ccrz__Product__c;
                            if(tvol>0 && tvol<1){                        
                                theNewLine.quantity = 1;
                                theNewLines.add(theNewLine);                    
                            }else{
                                theNewLine.quantity = tvol.setScale(0,RoundingMode.HALF_DOWN); 
                                theNewLines.add(theNewLine);                            
                            }                    
                        }else{
                            ccrz.ccApiCart.LineData theNewLine = new ccrz.ccApiCart.LineData();
                            theNewLine.productId=orderItem.ccrz__Product__c;
                            theNewLine.quantity=orderItem.ccrz__Quantity__c;
                            theNewLines.add(theNewLine);
                        }
                    }                                    
               }                        
        }else{
                ccrz.ccApiCart.LineData theNewLine = new ccrz.ccApiCart.LineData();
                //item to add
                //String skuToAdd = '000000000000697878100030';
                Decimal qtyToAdd = Decimal.valueOf(qty);
                //theNewLine.sku = skuToAdd;
                //theNewLine.sfid=productid;
                theNewLine.productId=productid;
                theNewLine.quantity = qtyToAdd;            
                theNewLines.add(theNewLine);   
                
        }


// add to cart
        System.debug('FGG newLinesList '+theNewLines);
         Map<String,Object> addResults=new Map<String,Object>();
        if (!Test.isRunningTest()) {
           addResults = ccrz.ccApiCart.addTo(new Map<String,Object>{
                   ccrz.ccApi.API_VERSION => ccrz.ccApi.CURRENT_VERSION,                    
                    ccrz.ccApiCart.CART_ID => theCartSFID,
                    ccrz.ccApiCart.LINE_DATA => theNewLines
                        });
            System.debug('FGG addResults -'+addResults.get('success')+'-');
            System.debug('FGG addResults -MAP- '+addResults);            
        }
        if(String.valueOf(addresults.get('success'))=='true'){
            
            system.debug('FGG returnging true'+getCartNumberItems(cartEncId));
            return getCartNumberItems(cartEncId);
        }
        else{
            system.debug('FGG returnging false');

            return 'false';
        }
    }catch(Exception ex){
        ccrz.ccLog.log(LoggingLevel.ERROR,'ERR:ReOrderRemoteAction',ex);
        System.debug('FGG-Error-cc_mn_ctrl_HomeScreen '+ex.getMessage());  
        return 'false';        
    }
    finally{
        ccrz.ccLog.log(LoggingLevel.INFO,'HomeScree-ReOrderRemoteAction','ReOrderRemoteAction');
        ccrz.ccLog.close(res);
    }

    }
    public static void setActiveCart(Map<String, Object> reorderresult){        
        Map<String, Object> request=new Map<String, Object>{
        ccrz.ccApiCart.CART_ENCID=>reorderresult.get('cartEncId'),
          ccrz.ccApi.API_VERSION=>7
        };
        Map<String, Object> setActiveResult= ccrz.ccApiCart.setActive(request); 
        
        System.debug('FGG activeResult '+setActiveResult);
    }
    public void getOrderHeaders(){         
        Map<Id,String> orderpayment=new Map<Id,String>();
        orderHeaders=new List<orderHeadersWrapper>();
        Integer limi=getContactSettingsValues('headers');
        Id effectiveAccount=ccrz.cc_CallContext.effAccountId;
        List<ccrz__E_Order__c> ccorders=[select id,ccrz__OrderId__c,ccrz__OrderStatus__c,ccrz__EncryptedId__c from ccrz__E_Order__c where ccrz__Account__c=:effectiveAccount and ccrz__OrderStatus__c!='Rejected' Limit :limi];        
        List<ccrz__E_TransactionPayment__c> ccpayments=[select ccrz__CCOrder__c,ccrz__AccountNumber__c from ccrz__E_TransactionPayment__c where ccrz__CCOrder__c in :ccorders];
        for(ccrz__E_TransactionPayment__c payment:ccpayments){
            orderpayment.put(payment.ccrz__CCOrder__c,payment.ccrz__AccountNumber__c);            
        }                
        System.debug('FGG '+ccpayments);
        for(ccrz__E_Order__c order:ccorders ){  
                OrderHeadersWrapper ohw=new OrderHeadersWrapper();
                ohw.poNumber=orderpayment.get(order.Id);
                ohw.orderNumber=order.ccrz__OrderId__c;
                ohw.status=order.ccrz__OrderStatus__c;
                ohw.encryptedid=order.ccrz__EncryptedId__c;        
                orderHeaders.add(ohw);   
        }       
    }
    
    @RemoteAction
    global static boolean updateContactSettings(string Actiontype, string value){
         
        if(Actiontype=='headers'){
            if(value=='3' || value=='5' || value=='10'){                
                updateSettings(Actiontype,value);
                return true;
            }
            else{
                
                return false;
            }
            
        }
        else if(Actiontype=='items'){
            if(value=='3' || value=='5' || value=='10'){   
                updateSettings(Actiontype,value);
                return true;
            }
            else{                
                return false;
            }
        }
        else{
            return false;                                    
        }                                
    }
    
    public static void updateSettings(string Actiontype, string value){
        if(Actiontype=='headers'){
        User usr=[select HS_Number_of_Headers__c,HS_Number_of_Items__c from User where id=:ccrz.cc_CallContext.currUserId];
        usr.HS_Number_of_Headers__c=Decimal.valueOf(value);     
        update usr;
            return;
        }
        if(Actiontype=='items'){
        User usr=[select HS_Number_of_Headers__c,HS_Number_of_Items__c from User where id=:ccrz.cc_CallContext.currUserId];
        usr.HS_Number_of_Items__c=Decimal.valueOf(value);     
        update usr;
            return;
        }
        
        
    }
    public Integer getContactSettingsValues(String HeadersorItems){
        
        if(HeadersorItems=='headers'){
            User usr=[select HS_Number_of_Headers_Formula__c,HS_Number_of_Items__c from User where id=:ccrz.cc_CallContext.currUserId];
            return Integer.valueOf(usr.HS_Number_of_Headers_Formula__c);            
        }
        else if(HeadersorItems=='items'){
            User usr=[select HS_Number_of_Headers__c,HS_Number_of_Items_Formula__c from User where id=:ccrz.cc_CallContext.currUserId];
            return Integer.valueOf(usr.HS_Number_of_Items_Formula__c);            
        }         
        return 0;
    }
    public void getContactSettings(){
        
        User usr=[select HS_Number_of_Headers_Formula__c,HS_Number_of_Items_Formula__c from User where id=:ccrz.cc_CallContext.currUserId];
        numberHeaders=Integer.valueOf(usr.HS_Number_of_Headers_Formula__c);
        numberItems=Integer.valueOf(usr.HS_Number_of_Items_Formula__c);

    }


}