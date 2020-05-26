public without sharing class cc_imp_hlpr_MyAccountOrders {

	static Map<String, String> orderSortMap = new Map<String,String>();

	static {
		orderSortMap.put('OrderName','Name');
		orderSortMap.put('ExternalOrderId', 'ccrz__OrderId__c');
		orderSortMap.put('PONumber','ccrz__PONumber__c');
		orderSortMap.put('OrderDate','ccrz__OrderDate__c');
		orderSortMap.put('OrderAmount','ccrz__TotalAmount__c');
		orderSortMap.put('OrderStatus','ccrz__OrderStatus__c');				
	}

	public static List<ccrz.cc_bean_MockOrder> getAllOrders(Id accountId){

		List<ccrz.cc_bean_MockOrder> orderList = new List<ccrz.cc_bean_MockOrder> ();

		List<ccrz__E_Order__c> ordersByAccount = queryOrdersByAccountId(accountId);
		if(ordersByAccount != null && ordersByAccount.size()>0){
			for(ccrz__E_Order__c currentOrder :ordersByAccount){
				//ccrz.cc_bean_MockOrder mockOrder = new ccrz.cc_bean_MockOrder(currentOrder);
				ccrz.cc_bean_MockOrder mockOrder = new ccrz.cc_bean_MockOrder();
				mockOrder.name = currentOrder.Name;
				mockOrder.encryptedId = currentOrder.ccrz__EncryptedId__c;
				mockOrder.status = currentOrder.ccrz__OrderStatus__c;
				mockOrder.totalAmount = currentOrder.ccrz__TotalAmount__c;
                mockOrder.sfid = currentOrder.Id;

				if(currentOrder.ccrz__OrderDate__c!=null){
					Datetime dt = datetime.newInstance(currentOrder.ccrz__OrderDate__c.year(), currentOrder.ccrz__OrderDate__c.month(),currentOrder.ccrz__OrderDate__c.day());
					mockOrder.orderDateStr = dt.format('MM/dd/yyyy');
				}
				mockOrder.externalOrderId = currentOrder.ccrz__OrderId__c;
                // If Owner is Nexeo Intration user
                // we are going to hide the button of
                // "Reorder"
                cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
                Id nexeoIntegrationUserId = Id.valueOf(customSettings.Nexeo_Integration_User_Id__c);
                if (currentOrder.CreatedById.equals(nexeoIntegrationUserId)) {
                    mockOrder.canReOrder = false;
                } else {
                    mockOrder.canReOrder = true;
                }
				orderList.add(mockOrder);
			}

		}

		return orderList;

	}


	public static List<ccrz.cc_bean_MockOrder> getAllOrdersFilteredByParams(Id accountId, cc_mn_json_OrderQueryWrapper wrapper){

		List<ccrz.cc_bean_MockOrder> orderList = new List<ccrz.cc_bean_MockOrder> ();

		List<ccrz__E_Order__c> ordersByAccount = queryOrdersByAccountIdAndParams(accountId, wrapper);
		if(ordersByAccount != null && ordersByAccount.size()>0){
			for(ccrz__E_Order__c currentOrder :ordersByAccount){
				//ccrz.cc_bean_MockOrder mockOrder = new ccrz.cc_bean_MockOrder(currentOrder);
				ccrz.cc_bean_MockOrder mockOrder = new ccrz.cc_bean_MockOrder();
				mockOrder.name = currentOrder.Name;
				mockOrder.encryptedId = currentOrder.ccrz__EncryptedId__c;
				mockOrder.status = currentOrder.ccrz__OrderStatus__c;
				mockOrder.totalAmount = currentOrder.ccrz__TotalAmount__c;

				if(currentOrder.ccrz__OrderDate__c!=null){
					Datetime dt = datetime.newInstance(currentOrder.ccrz__OrderDate__c.year(), currentOrder.ccrz__OrderDate__c.month(),currentOrder.ccrz__OrderDate__c.day());

					mockOrder.orderDateStr = dt.format('MM/dd/yyyy');
				}

				mockOrder.externalOrderId = currentOrder.ccrz__OrderId__c;
				// If Owner is Nexeo Intration user
                // we are going to hide the button of
                // "Reorder"
                cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
                Id nexeoIntegrationUserId = Id.valueOf(customSettings.Nexeo_Integration_User_Id__c);
                if (currentOrder.CreatedById.equals(nexeoIntegrationUserId)) {
                    mockOrder.canReOrder = false;
                } else {
                    mockOrder.canReOrder = true;
                }
				orderList.add(mockOrder);
			}

		}

		return orderList;

	}

	public static List<ccrz__E_Order__c> queryOrdersByAccountId(Id accountId){
		List<ccrz__E_Order__c> accounts = [
							SELECT
								Id,
								Name,
								Owner.Id,
								Owner.Username,
								Owner.LastName,
								Owner.FirstName,
								Owner.Name,
								Owner.Title,
								Owner.Email,
								ccrz__EncryptedId__c,
								ccrz__Name__c,
								ccrz__OrderDate__c,
								ccrz__OrderId__c,
								ccrz__OrderNumber__c,
								ccrz__OrderStatus__c,
								ccrz__OriginatedCart__c,
								ccrz__TotalAmount__c,
								ccrz__User__c,
								ccrz__PaymentMethod__c,
								ccrz__PONumber__c,
								ccrz__ShipMethod__c,
								ccrz__ShipAmount__c,
								ccrz__SubtotalAmount__c,
								ccrz__TaxAmount__c,
								ccrz__TotalSurcharge__c,
								ccrz__BuyerEmail__c,
								ccrz__BuyerFirstName__c,
								ccrz__BuyerLastName__c,
								ccrz__BuyerMobilePhone__c,
								ccrz__BuyerPhone__c,
								ccrz__CCEmailAddress__c,
								ccrz__BuyerCompanyName__c,
								ccrz__ExtShipTrackNo__c,
								ccrz__CurrencyISOCode__c,
								ccrz__ShipComplete__c,
								ccrz__RequestDate__c,
								Tracking_Number__c,
								ccrz__BillTo__r.ccrz__AddressFirstline__c,
								ccrz__BillTo__r.ccrz__AddressSecondline__c,
								ccrz__BillTo__r.ccrz__AddressThirdline__c,
								ccrz__BillTo__r.ccrz__City__c,
								ccrz__BillTo__r.ccrz__CompanyName__c,
								ccrz__BillTo__r.ccrz__ContactAddrId__c,
								ccrz__BillTo__r.ccrz__Country__c,
								ccrz__BillTo__r.ccrz__Email__c,
								ccrz__BillTo__r.ccrz__FirstName__c,
								ccrz__BillTo__r.ccrz__LastName__c,
								ccrz__BillTo__r.ccrz__Partner_Id__c,
								ccrz__BillTo__r.ccrz__PostalCode__c,
								ccrz__BillTo__r.ccrz__State__c,
								ccrz__ShipTo__r.ccrz__AddressFirstline__c,
								ccrz__ShipTo__r.ccrz__AddressSecondline__c,
								ccrz__ShipTo__r.ccrz__AddressThirdline__c,
								ccrz__ShipTo__r.ccrz__City__c,
								ccrz__ShipTo__r.ccrz__CompanyName__c,
								ccrz__ShipTo__r.ccrz__ContactAddrId__c,
								ccrz__ShipTo__r.ccrz__Country__c,
								ccrz__ShipTo__r.ccrz__Email__c,
								ccrz__ShipTo__r.ccrz__FirstName__c,
								ccrz__ShipTo__r.ccrz__LastName__c,
								ccrz__ShipTo__r.ccrz__Partner_Id__c,
								ccrz__ShipTo__r.ccrz__PostalCode__c,
								ccrz__ShipTo__r.ccrz__State__c,
            					CreatedById
							FROM 
								ccrz__E_Order__c 
							WHERE 
								ccrz__Account__r.Id = :accountId
            				ORDER BY
            					ccrz__OrderDate__c DESC
            					
							];


		return accounts;
	}

	public static List<ccrz__E_Order__c> queryOrdersByAccountIdAndParams(Id accountId, cc_mn_json_OrderQueryWrapper wrapper){
		String accountIdString = String.valueOf(accountId);

		String query = 'SELECT Id, Name, Owner.Id, Owner.Username, Owner.LastName, Owner.FirstName, Owner.Name, Owner.Title, Owner.Email, ccrz__EncryptedId__c, ccrz__Name__c, ccrz__OrderDate__c, ccrz__OrderId__c, ccrz__OrderNumber__c, ccrz__OrderStatus__c, ccrz__OriginatedCart__c, ccrz__TotalAmount__c, ccrz__User__c, ccrz__PaymentMethod__c, ccrz__PONumber__c, ccrz__ShipMethod__c, ccrz__ShipAmount__c, ccrz__SubtotalAmount__c, ccrz__TaxAmount__c, ccrz__TotalSurcharge__c, ccrz__BuyerEmail__c, ccrz__BuyerFirstName__c, ccrz__BuyerLastName__c, ccrz__BuyerMobilePhone__c, ccrz__BuyerPhone__c, ccrz__CCEmailAddress__c, ccrz__BuyerCompanyName__c, ccrz__ExtShipTrackNo__c, ccrz__CurrencyISOCode__c, ccrz__ShipComplete__c, ccrz__RequestDate__c, Tracking_Number__c, ccrz__BillTo__r.ccrz__AddressFirstline__c, ccrz__BillTo__r.ccrz__AddressSecondline__c, ccrz__BillTo__r.ccrz__AddressThirdline__c, ccrz__BillTo__r.ccrz__City__c, ccrz__BillTo__r.ccrz__CompanyName__c, ccrz__BillTo__r.ccrz__ContactAddrId__c, ccrz__BillTo__r.ccrz__Country__c, ccrz__BillTo__r.ccrz__Email__c, ccrz__BillTo__r.ccrz__FirstName__c, ccrz__BillTo__r.ccrz__LastName__c, ccrz__BillTo__r.ccrz__Partner_Id__c, ccrz__BillTo__r.ccrz__PostalCode__c, ccrz__BillTo__r.ccrz__State__c, ccrz__ShipTo__r.ccrz__AddressFirstline__c, ccrz__ShipTo__r.ccrz__AddressSecondline__c, ccrz__ShipTo__r.ccrz__AddressThirdline__c, ccrz__ShipTo__r.ccrz__City__c, ccrz__ShipTo__r.ccrz__CompanyName__c, ccrz__ShipTo__r.ccrz__ContactAddrId__c, ccrz__ShipTo__r.ccrz__Country__c, ccrz__ShipTo__r.ccrz__Email__c, ccrz__ShipTo__r.ccrz__FirstName__c, ccrz__ShipTo__r.ccrz__LastName__c, ccrz__ShipTo__r.ccrz__Partner_Id__c, ccrz__ShipTo__r.ccrz__PostalCode__c, ccrz__ShipTo__r.ccrz__State__c, CreatedById FROM ccrz__E_Order__c  WHERE ccrz__Account__r.Id = :accountId';
		if( wrapper.searchOrderInput != null &&  wrapper.searchOrderInput.length() > 0) {
			String likeQuery = '%' + wrapper.searchOrderInput + '%';
			List<Id> orderIds = new List<Id>();
			List<ccrz__E_TransactionPayment__c> payments = [SELECT Id, ccrz__CCOrder__c FROM ccrz__E_TransactionPayment__c WHERE ccrz__CCOrder__r.ccrz__Account__r.Id = :accountId AND ccrz__AccountNumber__c like :likeQuery];
			for (ccrz__E_TransactionPayment__c p : payments) {
				orderIds.add(p.ccrz__CCOrder__c);
			}
			query += ' and (Name like :likeQuery OR ccrz__OrderId__c like :likeQuery OR Id IN :orderIds)';
		}
		if ( wrapper.searchOrderStatus != null &&  wrapper.searchOrderStatus.length() > 0 && wrapper.searchOrderStatus != 'All' ){
			String statusFilter = wrapper.searchOrderStatus;
			query += ' and ccrz__OrderStatus__c =: statusFilter';
		}
		if( wrapper.fromDateStr != null && wrapper.fromDateStr.length() > 0){
			Date fromDate = Date.parse(wrapper.fromDateStr);
			query += ' and ccrz__OrderDate__c >=:fromDate';
		}if( wrapper.toDateStr != null && wrapper.toDateStr.length() > 0){
			Date toDateStr = Date.parse(wrapper.toDateStr);
			query += ' and ccrz__OrderDate__c <=:toDateStr';
		}
		if( wrapper.sortCriteria != null && wrapper.sortCriteria.length()>0){
			query += ' ORDER BY ';
			String orderByColumn = orderSortMap.get(wrapper.sortCriteria);
			query += orderByColumn;
			query += ' ' + wrapper.sortDir;
			if(wrapper.sortCriteria == 'ExternalOrderId'){
				query += ' NULLS LAST';
			}
		}

		List<ccrz__E_Order__c> orders =(List<ccrz__E_Order__c>)Database.query( query );


		return orders;
	}


	public static List<ccrz__E_Order__c> queryOrdersByOrderIds( List <String> orderIds  ){
		System.debug('queryOrdersByOrderIds: ' + JSON.serializePretty(orderIds));
		List<ccrz__E_Order__c> cc_orders = 

		[		SELECT 
			  	Id,
			  	Name,
		  		ccrz__EncryptedId__c,   
         		ccrz__CurrencyISOCode__c,
         		ccrz__TotalAmount__c,         		
	    		(	SELECT 
	    				ccrz__AccountNumber__c, 
	  		    		ccrz__AccountType__c
	    			FROM 
	     				ccrz__TransactionPayments__r
	     			WHERE  
	      				ccrz__AccountType__c = 'PO' 
	      			OR
	      				ccrz__AccountType__c = 'po'
	      			LIMIT 
	      				1
	      		)
	     		FROM 
	    	 		ccrz__E_Order__c 
	    	 	WHERE 
	    	 	ccrz__EncryptedId__c IN :orderIds 
	    ];

		System.debug('queryOrdersByOrderIds results: ' + JSON.serializePretty(cc_orders));
		return cc_orders;

	}
   
}