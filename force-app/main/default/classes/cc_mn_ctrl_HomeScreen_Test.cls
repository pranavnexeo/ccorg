/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        08/06/2018
*    Author:             Ignacio Gonzalez
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Unit test for Controller cc_mn_ctrl_HomeScreen
*   
*   
*	
*   **********************************************************************************************************************/
@IsTest
public class cc_mn_ctrl_HomeScreen_Test {
    
    public static Map<String, SObject> setupData(){
        
        Map<String, SObject> mapData = cc_imp_testUtils.initData();
       	
        /*
    	* Account
    	*/
        Account userAccount;
        User nexeoIntegrationUser = (User) mapData.get('nexeoIntegrationUser');
        System.runAs(nexeoIntegrationUser) {
            cc_imp_StorefrontSettings__c listOfSettings =  cc_imp_testUtils.createMyNexeoCustomSetting();
            insert listOfSettings;
            userAccount = (Account) mapData.get('userAccount');
            userAccount.SAP_DivisionCode__c = '34';
            update userAccount;
        
        
        ccrz.cc_CallContext.effAccountId = userAccount.Id;    
        ccrz__E_Cart__c cart = (ccrz__E_Cart__c) mapData.get('cart');
        Contact userContact = (Contact) mapData.get('userContact');
        User portalUser = (User) mapData.get('portalUser');
        ccrz__E_ContactAddr__c address = (ccrz__E_ContactAddr__c) mapData.get('address');
        ccrz__E_Product__c product = (ccrz__E_Product__c) mapData.get('product');
            
        /*
        * Order
        *
        */
        
        ccrz__E_Order__c theOrder = cc_imp_testUtils.createOrder(cart.Id, userAccount.Id, userContact.Id, portalUser.Id, address.Id, address.Id);
        insert theOrder;
       

        /*
        * Order Item
        *
        */
        
        ccrz__E_OrderItem__c parentOrderItem = createOrderItem(theOrder.Id, 'oi1', 'Major', product.Id, null, null, 1.00, 1, 1.00);
        insert parentOrderItem;      

		ccrz__E_TransactionPayment__c tp = cc_imp_testUtils.createTransactionPayment(theOrder.Id, 'uid');
		insert tp;
		
        mapData.put('order', theOrder);
        }    
        
        return mapData;
        
    }
    
    @IsTest
    public static void isESAccount() {
        
        setupData();
            
        cc_mn_ctrl_HomeScreen homeScreen = new cc_mn_ctrl_HomeScreen();
        
        System.assertEquals(true, homeScreen.isESAccount());
    }

    @IsTest
    public static void getContactSettings() {
        
        setupData();
            
        cc_mn_ctrl_HomeScreen homeScreen = new cc_mn_ctrl_HomeScreen();
        homeScreen.getContactSettings();
        System.assertNotEquals(null, homeScreen.numberHeaders);
        System.assertNotEquals(null, homeScreen.numberItems);
    }    

    @IsTest
    public static void getOrderHeaders() {
        
        setupData();
            
        cc_mn_ctrl_HomeScreen homeScreen = new cc_mn_ctrl_HomeScreen();
        homeScreen.getOrderHeaders();
        System.assertNotEquals(null, homeScreen.numberHeaders);
        System.assertNotEquals(null, homeScreen.numberItems);
    }
    
    @IsTest
    public static void getOrderItems() {
        
        setupData();
            
        cc_mn_ctrl_HomeScreen homeScreen = new cc_mn_ctrl_HomeScreen();
        homeScreen.getOrderItems();
        System.assertNotEquals(null, homeScreen.orderItems);
    } 
    
    @IsTest
    public static void getReleaseNews() {
        
        Map<String, SObject> mapData = setupData();
        User nexeoIntegrationUser = (User) mapData.get('nexeoIntegrationUser');
        System.runAs(nexeoIntegrationUser) {
            CC_Release_News__c news = new CC_Release_News__c();
            news.Body_Content__c = 'A great Name';
            news.Button_Label__c = 'Test News';
            news.Button_Link__c = 'www.test.com';
            news.Title__c = 'Test';
            news.Start_Date__c = Date.today();
            news.End_Date__c = Date.today().addDays(20);
            news.Enabled__c = true;
            news.Language__c = 'en_US';
            news.Division__c = '34';
            insert news;
        }
        
        cc_mn_ctrl_HomeScreen homeScreen = new cc_mn_ctrl_HomeScreen();
        homeScreen.getReleaseNews();
        System.assertNotEquals(null, homeScreen.releaseNews);
    } 

    @IsTest
    public static void setActiveCart() {
        
        setupData();
		Map<String, Object> reorderresult = new Map<String, Object>();
		reorderresult.put('cartEncId', 'cartEncripId');
        
        cc_mn_ctrl_HomeScreen.setActiveCart(reorderresult);
    }

    @IsTest
    public static void updateContactSettings() {
        
		Map<String, SObject> mapData = setupData();
        
        System.runAs((User)mapData.get('portalUser')) {
        
            System.assert(cc_mn_ctrl_HomeScreen.updateContactSettings('headers', '5'));
            System.assert(!cc_mn_ctrl_HomeScreen.updateContactSettings('headers', '20'));
            System.assert(cc_mn_ctrl_HomeScreen.updateContactSettings('items', '5'));
            System.assert(!cc_mn_ctrl_HomeScreen.updateContactSettings('items', '20'));
            System.assert(!cc_mn_ctrl_HomeScreen.updateContactSettings('N/A', '20'));
        }
    }

    @IsTest
    public static void reOrder() {
        
        
		Map<String, SObject> mapData = setupData();
 
        ccrz__E_Order__c order = (ccrz__E_Order__c) mapData.get('order');
        ccrz__E_Product__c product = (ccrz__E_Product__c) mapData.get('product');
        ccrz.cc_RemoteActionContext ctx = new ccrz.cc_RemoteActionContext();
        cc_mn_ctrl_HomeScreen.reOrder(order.Id, product.Id, '30','',ctx);
        
        
    }    
    
	public static ccrz__E_OrderItem__c createOrderItem(Id orderId, String orderItemId, String lineType, Id productId, Id parentOrderItemId, Id parentProductId, Decimal price, Decimal quantity, Decimal subAmount){
		ccrz__E_OrderItem__c oi = new ccrz__E_OrderItem__c();
		oi.ccrz__Order__c = orderId;
		oi.ccrz__OrderItemId__c = orderItemId;
		oi.ccrz__OrderLineType__c = lineType;
		oi.ccrz__Product__c = productId;
		oi.ccrz__ParentOrderItem__c = parentOrderItemId;
		oi.ccrz__ParentProduct__c = parentProductId;
		oi.ccrz__Price__c = price;
		oi.ccrz__Quantity__c = quantity;
		oi.ccrz__SubAmount__c = subAmount;
        oi.ccrz__UnitOfMeasure__c = 'DRUM';
		return oi;
	}    
    
}