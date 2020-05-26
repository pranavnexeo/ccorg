/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         02/22/2018
*   Author:               Abhinay Raja
*   Last Modified:        02/22/2018
*   Last Modified By:     Abhinay Raja
*
*   This class retrives the purchase ES order number that gets displayed on the Order history page
*   **********************************************************************************************************************/


global with sharing class cc_imp_ctrl_MyAccountESOrders
{
    global String extendedProdJSON {get;set;}
    global Boolean isES {get;set;}
    global cc_imp_ctrl_MyAccountESOrders() {
        extendedProdJSON = 'teting json';
        
         Account a = cc_imp_dao_Account.queryAccountByAccountId(ccrz.cc_CallContext.effAccountId);        
        isES = false;
        if(a.SAP_DivisionCode__c!=null){
            if(a.SAP_DivisionCode__c=='34')
            {
              isES=True;  
            }
        }
    }
    
    
    //=========================Above is test code==================================
    public class MyException extends Exception {} 
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getExtendedOrdersList(ccrz.cc_RemoteActionContext ctx, List <String> orderIds)
    {
        
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        
        
        
        try 
        {
            Map<String,ExtendedOrderHistory> extendedOrderHistoryMap = new Map<String,ExtendedOrderHistory>();
            List<ccrz__E_Order__c> cc_orders = [SELECT Id,Name,ccrz__EncryptedId__c,   
                                                ccrz__CurrencyISOCode__c,ccrz__TotalAmount__c,Waste_Manifest__c,Cert_of_DIsposal__c,
                                                Bill_of_Lading__c,ccrz__OrderStatus__c,ccrz__PONumber__c,ccrz__OrderId__c,
                                                (   SELECT 
                                                 ccrz__AccountNumber__c, 
                                                 ccrz__AccountType__c
                                                 FROM 
                                                 ccrz__TransactionPayments__r
                                                 WHERE  
                                                 ccrz__AccountType__c = 'PO' 
                                                 OR
                                                 ccrz__AccountType__c = 'po'
                                                 LIMIT 1)
                                                FROM 
                                                ccrz__E_Order__c 
                                                WHERE 
                                                ccrz__EncryptedId__c IN :orderIds 
                                               ];
            System.debug('FGG Orders'+cc_orders);
           	cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
            List<String> statusesToShowTotalAmount = customSettings.ES_Orders_To_Show__c.split(',');    
            for(ccrz__E_Order__c cc_order : cc_orders)
            {
                
                if ( Test.isRunningTest() ) {
                    
                    if(cc_order.ccrz__EncryptedId__c == '123Error'){
                        throw new MyException('Trigger an exception for test code coverage');
                    }
                    
                }
                ExtendedOrderHistory newExtendedOrderHistory = new ExtendedOrderHistory();
                newExtendedOrderHistory.orderNumber = cc_order.Name;
                if(cc_order.ccrz__CurrencyISOCode__c==''){
                    newExtendedOrderHistory.currencyCode = '';
                }else{
                    
                    newExtendedOrderHistory.currencyCode = cc_order.ccrz__CurrencyISOCode__c;
                }
                
                newExtendedOrderHistory.totalAmount=cc_order.ccrz__TotalAmount__c;
                /*if(cc_order.Waste_Manifest__c != null)
                {
                    string str='';
                    integer count=1;
                    for(string strpart :cc_order.Waste_Manifest__c.split(','))
                    {
                        str += '<a href="#" data-id="'+strpart+'" >'+(count<10?'WM00'+string.valueof(count):'WM0'+string.valueof(count))+'</a><br/>';
                        count++;
                    }
                    newExtendedOrderHistory.wasteManifest =cc_order.Waste_Manifest__c;
                }*/
                newExtendedOrderHistory.wasteManifest =cc_order.Waste_Manifest__c;
                newExtendedOrderHistory.billOfLading = cc_order.Bill_of_Lading__c;
                newExtendedOrderHistory.CertOfDisposal = cc_order.Cert_of_DIsposal__c;
                newExtendedOrderHistory.externalSapOrderId = cc_order.ccrz__OrderId__c;
                if(cc_order.ccrz__TransactionPayments__r != null && cc_order.ccrz__TransactionPayments__r.size() > 0){
                    System.debug('Adding PO NUMBER: ' + cc_order.ccrz__TransactionPayments__r[0]);
                    ccrz__E_TransactionPayment__c  poPaymentTransaction = cc_order.ccrz__TransactionPayments__r[0];
                    
                    newExtendedOrderHistory.poNumber=poPaymentTransaction.ccrz__AccountNumber__c;                                    
                }
                else {                        
                    newExtendedOrderHistory.poNumber='';                  
                    System.debug('Transaction payment list is null or empty');
                }
                if (statusesToShowTotalAmount.contains(cc_order.ccrz__OrderStatus__c)) {
                    newExtendedOrderHistory.totalAmountCanBeRendered = true;
                } else {
                    newExtendedOrderHistory.totalAmountCanBeRendered = false;
                }
                extendedOrderHistoryMap.put(cc_order.ccrz__EncryptedId__c, newExtendedOrderHistory);
            }
            
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
                                                             new Map<String,Object>
                                                             {'success' => true,
                                                                 'extendedData' => extendedOrderHistoryMap
                                                                 });
        }
        catch(Exception e)
        {
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
                                                             new Map<String,Object>
                                                             {
                                                                 'success' => false,
                                                                     'message' => e.getMessage(),
                                                                     'cause' => e.getCause(),
                                                                     'trace' => e.getStackTraceString()
                                                                     }
                                                            );  
        }
        
        return response;
    }
    
    @RemoteAction
    global static ccrz.cc_RemoteActionResult getAllOrdersForShipToAddress(ccrz.cc_RemoteActionContext ctx) {
        
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        
        Id accountId = ccrz.cc_CallContext.effAccountId;
        if(accountId == null){
            accountId = ccrz.cc_CallContext.currAccount.Id;
        }
        
        List<ccrz.cc_bean_MockOrder> allOrders = cc_imp_hlpr_MyAccountOrders.getAllOrders(accountId);
        
        cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
                                                         new Map<String,Object>
                                                         {'success' => true,
                                                             'orders' => allOrders
                                                             });
        return response;
        
    }
    
    @RemoteAction 
    global static ccrz.cc_RemoteActionResult getAllInvoicesForShipToAddress( ccrz.cc_RemoteActionContext ctx ) {
        
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        
        try 
        {
            Id accountId = ccrz.cc_CallContext.effAccountId;
            if(accountId == null){
                accountId = ccrz.cc_CallContext.currAccount.Id;
            }
            
            List<Map<String,Object>> invoices = cc_imp_hlpr_MyAccountInvoices.getAllInvoices(accountId );
            
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
                                                             new Map<String,Object>
                                                             {'success' => true,
                                                                 'invoices' => invoices
                                                                 });
            
        }catch(Exception e)
        {
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
                                                             new Map<String,Object>
                                                             {
                                                                 'success' => false,
                                                                     'message' => e.getMessage(),
                                                                     'cause' => e.getCause(),
                                                                     'trace' => e.getStackTraceString()
                                                                     }
                                                            );  
        }
        
        return response;
        
        
        
    }  
    
    @RemoteAction 
    global static ccrz.cc_RemoteActionResult searchAllInvoices(ccrz.cc_RemoteActionContext ctx, String searchFormData ) {
        
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        
        try 
        {
            Id accountId = ccrz.cc_CallContext.effAccountId;
            if(accountId == null){
                accountId = ccrz.cc_CallContext.currAccount.Id;
            }
            
            cc_mn_json_InvoiceQueryWrapper wrapper =  cc_mn_json_InvoiceQueryWrapper.parse(searchFormData);
            
            List<Map<String,Object>> invoices = cc_imp_hlpr_MyAccountInvoices.searchByCriteria(accountId,wrapper);
            
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
                                                             new Map<String,Object>
                                                             {'success' => true,
                                                                 'invoices' => invoices
                                                                 });
            
        }catch(Exception e)
        {
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
                                                             new Map<String,Object>
                                                             {
                                                                 'success' => false,
                                                                     'message' => e.getMessage(),
                                                                     'cause' => e.getCause(),
                                                                     'trace' => e.getStackTraceString()
                                                                     }
                                                            );  
        }
        
        return response;
        
        
        
    }
    
    @RemoteAction 
    global static ccrz.cc_RemoteActionResult searchAllOrdersByParams(ccrz.cc_RemoteActionContext ctx, String searchFormData ) {
        
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        
        try 
        {
            Id accountId = ccrz.cc_CallContext.effAccountId;
            if(accountId == null){
                accountId = ccrz.cc_CallContext.currAccount.Id;
            }
            
            cc_mn_json_OrderQueryWrapper wrapper =  cc_mn_json_OrderQueryWrapper.parse(searchFormData);
            
            List<ccrz.cc_bean_MockOrder> orders = cc_imp_hlpr_MyAccountOrders.getAllOrdersFilteredByParams(accountId,wrapper);
            
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
                                                             new Map<String,Object>
                                                             {'success' => true,
                                                                 'orders' => orders
                                                                 });
            
        }catch(Exception e)
        {
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
                                                             new Map<String,Object>
                                                             {
                                                                 'success' => false,
                                                                     'message' => e.getMessage(),
                                                                     'cause' => e.getCause(),
                                                                     'trace' => e.getStackTraceString()
                                                                     }
                                                            );  
        }
        
        return response;
        
        
        
    }
    
    @RemoteAction 
    global static ccrz.cc_RemoteActionResult reorderByPONumber(ccrz.cc_RemoteActionContext ctx, String searchFormData ) {
        
        ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);
        
        try 
        {
            Id accountId = ccrz.cc_CallContext.effAccountId;
            if(accountId == null){
                accountId = ccrz.cc_CallContext.currAccount.Id;
            }
            
            cc_mn_json_OrderQueryWrapper wrapper =  cc_mn_json_OrderQueryWrapper.parse(searchFormData);
            
            //List<ccrz.cc_bean_MockOrder> orders = cc_imp_hlpr_MyAccountOrders.getAllOrdersFilteredByParams(accountId,wrapper);
            List<ccrz__E_Order__c> orders = cc_imp_hlpr_MyAccountOrders.queryOrdersByAccountIdAndParams(accountId,wrapper);
            
            List<String> ordersForQuery = new List<String>();
            Map<String, ccrz.cc_bean_MockOrder> mockOrderMap = new Map<String, ccrz.cc_bean_MockOrder>();
            for(ccrz__E_Order__c currentOrder: orders ){
                ordersForQuery.add(currentOrder.ccrz__EncryptedId__c);
                ccrz.cc_bean_MockOrder mockOrder = new ccrz.cc_bean_MockOrder();
                mockOrder.name = currentOrder.Name;
                mockOrder.encryptedId = currentOrder.ccrz__EncryptedId__c;
                mockOrder.status = currentOrder.ccrz__OrderStatus__c;
                mockOrder.totalAmount = currentOrder.ccrz__TotalAmount__c;
                
                if( currentOrder.ccrz__OrderDate__c != null) {
                    Datetime dt = datetime.newInstance(currentOrder.ccrz__OrderDate__c.year(), currentOrder.ccrz__OrderDate__c.month(),currentOrder.ccrz__OrderDate__c.day());
                    
                    mockOrder.orderDateStr = dt.format('MM/dd/yyyy');
                }
                mockOrder.externalOrderId = currentOrder.ccrz__OrderId__c;
                mockOrder.canReOrder = true;
                
                mockOrderMap.put(currentOrder.name, mockOrder);
                
            }
            
            List<OrderWrapper> orderedListPoNumbers = new List<OrderWrapper>();
            List<ccrz__E_Order__c> cc_orders = cc_imp_hlpr_MyAccountOrders.queryOrdersByOrderIds(ordersForQuery);
            
            for( ccrz__E_Order__c ccOrder:  cc_orders){
                if(ccOrder.ccrz__TransactionPayments__r != null && ccOrder.ccrz__TransactionPayments__r.size() > 0){
                    ccrz__E_TransactionPayment__c  poPaymentTransaction = ccOrder.ccrz__TransactionPayments__r[0];
                    
                    ExtendedOrderHistory newExtendedOrderHistory = new ExtendedOrderHistory();
                    newExtendedOrderHistory.poNumber       = poPaymentTransaction.ccrz__AccountNumber__c;
                    newExtendedOrderHistory.orderNumber = ccOrder.Name;
                    newExtendedOrderHistory.currencyCode = ccOrder.ccrz__CurrencyISOCode__c;
                    newExtendedOrderHistory.totalAmount=ccOrder.ccrz__TotalAmount__c;
                    OrderWrapper wrpr = new OrderWrapper(newExtendedOrderHistory, wrapper.sortDir.equals('Asc') );
                    orderedListPoNumbers.add(wrpr);
                }
                
            }
            orderedListPoNumbers.sort();
            System.debug('Sorted list of size ' + orderedListPoNumbers.size());
            List<ccrz.cc_bean_MockOrder> orderedListOfOrders = new List<ccrz.cc_bean_MockOrder>();
            
            for(OrderWrapper poNumberWrapper  : orderedListPoNumbers){
                orderedListOfOrders.add(mockOrderMap.get( poNumberWrapper.order.orderNumber ));
            }
            System.debug('RETURNING FINAL list of size ' + orderedListOfOrders.size());
            
            
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
                                                             new Map<String,Object>
                                                             {'success' => true,
                                                                 'orders' => orderedListOfOrders
                                                                 });
            
        }catch(Exception e)
        {
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, false, 
                                                             new Map<String,Object>
                                                             {
                                                                 'success' => false,
                                                                     'message' => e.getMessage(),
                                                                     'cause' => e.getCause(),
                                                                     'trace' => e.getStackTraceString()
                                                                     }
                                                            );  
        }
        
        return response;
        
        
        
    }
    
    
    //**************************************************************************
    // WRAPPER CLASS FOR ADDITIONAL ORDER HISTORY FIELDS
    //**************************************************************************
    public class ExtendedOrderHistory
    {
        public String poNumber;
        public String orderNumber;
        public String currencyCode;
        public Decimal totalAmount;
        public string wasteManifest;
        public string billOfLading;
        public string CertOfDisposal; 
        public string externalSapOrderId;
        public boolean totalAmountCanBeRendered;
        public ExtendedOrderHistory() 
        {
            
        }
    }
    
    public class OrderWrapper implements Comparable {
        public ExtendedOrderHistory order;
        public boolean isAscending;
        
        public OrderWrapper( ExtendedOrderHistory inOrder, boolean isAscendingInput ){
            order = inOrder;
            isAscending = isAscendingInput;
        }
        
        public Integer compareTo(Object compareTo) {
            String thisPoNumber = '';
            String compareToOrderPoNumber = '';
            
            OrderWrapper compareToOrder = (OrderWrapper)compareTo;
            
            if(order.poNumber != null){
                thisPoNumber = order.poNumber;
            }
            if(compareToOrder.order.poNumber != null){
                compareToOrderPoNumber = compareToOrder.order.poNumber;
            }
            
            
            if(isAscending)
                return thisPoNumber.compareTo(compareToOrderPoNumber);
            else
                return compareToOrderPoNumber.compareTo(thisPoNumber);
            
        }
    }
    
    
    
}