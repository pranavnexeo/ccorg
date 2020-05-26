public without sharing class cc_imp_hlpr_MyAccountInvoices {



	static Map<String, String> sortMap = new Map<String,String>();

	static {
		sortMap.put('Name','Name');
		sortMap.put('InvoiceId', 'ccrz__InvoiceId__c');
		sortMap.put('DateIssued','ccrz__DateIssued__c');
		sortMap.put('DueDate','ccrz__DateDue__c');
		sortMap.put('Amount','ccrz__OriginalAmount__c');
		sortMap.put('PaidAmount','ccrz__RemainingAmount__c');
		sortMap.put('Type','ccrz__Type__c');
		sortMap.put('Status','ccrz__Status__c');				
	}

	public static List<Map<String,Object>> getAllInvoices(Id accountId){

		List<Map<String,Object>> invoiceList = new List<Map<String,Object>> ();

		List<ccrz__E_Invoice__c> invoicesByAccount = queryInvoicesByAccountId(accountId);
		if(invoicesByAccount != null && invoicesByAccount.size()>0){
			for(ccrz__E_Invoice__c currentInvoice :invoicesByAccount){
				Map<String,Object> currInvoice = ccrz.cc_hk_Invoice.convertInvoiceToMap(currentInvoice);
				currInvoice.put('poNumber',currentInvoice.PONumber__c);

				invoiceList.add(currInvoice);
			}

		}

		return invoiceList;

	}

	public static List<Map<String,Object>> searchByCriteria(Id accountId, cc_mn_json_InvoiceQueryWrapper wrapper){
		List<Map<String,Object>> invoiceList = new List<Map<String,Object>> ();

		List<ccrz__E_Invoice__c> invoicesByAccount = queryInvoicesByParams(accountId, wrapper);
		if(invoicesByAccount != null && invoicesByAccount.size()>0){
			for(ccrz__E_Invoice__c currentInvoice :invoicesByAccount){
				Map<String,Object> currInvoice = ccrz.cc_hk_Invoice.convertInvoiceToMap(currentInvoice);
				currInvoice.put('poNumber',currentInvoice.PONumber__c);
				invoiceList.add(currInvoice);
			}

		}

		return invoiceList;
	}


	private static List<ccrz__E_Invoice__c> queryInvoicesByAccountId(Id accountId){
        System.debug('FGG-Helper-Invoices '+accountId);
		List<ccrz__E_Invoice__c> invoices = [
							SELECT
								Id,
								Name,
								ccrz__BillTo__c,
								ccrz__BillTo__r.Name,
								ccrz__BillTo__r.AccountNumber,
								ccrz__BillTo__r.ccrz__E_AccountGroup__c,
								ccrz__SoldTo__c,
								ccrz__SoldTo__r.Name,
								ccrz__SoldTo__r.AccountNumber,
								ccrz__SoldTo__r.ccrz__E_AccountGroup__c,
								ccrz__SoldAddress__c,
								ccrz__SoldAddress__r.Name,
								ccrz__SoldAddress__r.ccrz__AddressFirstline__c,
								ccrz__SoldAddress__r.ccrz__AddressSecondline__c,
								ccrz__SoldAddress__r.ccrz__AddressThirdline__c,
								ccrz__SoldAddress__r.ccrz__City__c,
								ccrz__SoldAddress__r.ccrz__CompanyName__c,
								ccrz__SoldAddress__r.ccrz__DaytimePhone__c,
								ccrz__SoldAddress__r.ccrz__State__c,
								ccrz__SoldAddress__r.ccrz__PostalCode__c,
								ccrz__SoldAddress__r.ccrz__Email__c,
								ccrz__SoldAddress__r.ccrz__FirstName__c,
								ccrz__SoldAddress__r.ccrz__HomePhone__c,
								ccrz__SoldAddress__r.ccrz__LastName__c,
								ccrz__SoldAddress__r.ccrz__MailStop__c,
								ccrz__SoldAddress__r.ccrz__MiddleName__c,
								ccrz__SoldAddress__r.ccrz__Partner_Id__c,
								ccrz__SoldAddress__r.ccrz__StateISOCode__c,
								ccrz__SoldAddress__r.ccrz__Country__c,
								ccrz__SoldAddress__r.ccrz__CountryISOCode__c,
								ccrz__CCOrder__c,
								PONumber__c,
								ccrz__CCOrder__r.Name,
								ccrz__CCOrder__r.ccrz__EncryptedId__c,
								ccrz__InvoiceId__c,
								ccrz__DateIssued__c,
								ccrz__DateDue__c,
								ccrz__OriginalAmount__c,
								ccrz__RemainingAmount__c,
								ccrz__Type__c,
								ccrz__Status__c,
								ccrz__CurrencyCode__c,
								ccrz__Terms__c,
								ccrz__BillAddress__c,
								ccrz__BillAddress__r.Name,
								ccrz__BillAddress__r.ccrz__AddressFirstline__c,
								ccrz__BillAddress__r.ccrz__AddressSecondline__c,
								ccrz__BillAddress__r.ccrz__AddressThirdline__c,
								ccrz__BillAddress__r.ccrz__City__c,
								ccrz__BillAddress__r.ccrz__CompanyName__c,
								ccrz__BillAddress__r.ccrz__DaytimePhone__c,
								ccrz__BillAddress__r.ccrz__State__c,
								ccrz__BillAddress__r.ccrz__PostalCode__c,
								ccrz__BillAddress__r.ccrz__Email__c,
								ccrz__BillAddress__r.ccrz__FirstName__c,
								ccrz__BillAddress__r.ccrz__HomePhone__c,
								ccrz__BillAddress__r.ccrz__LastName__c,
								ccrz__BillAddress__r.ccrz__MailStop__c,
								ccrz__BillAddress__r.ccrz__MiddleName__c,
								ccrz__BillAddress__r.ccrz__Partner_Id__c,
								ccrz__BillAddress__r.ccrz__StateISOCode__c,
								ccrz__BillAddress__r.ccrz__Country__c,
								ccrz__BillAddress__r.ccrz__CountryISOCode__c,
								ccrz__Contact__c,
								ccrz__Contact__r.Name,
								ccrz__ParentInvoice__r.Id,
								ccrz__ParentInvoice__r.Name
							FROM 
								ccrz__E_Invoice__c 
							WHERE 
								SAP_Ship_To__c = :accountId and ccrz__RemainingAmount__c != null 
            				ORDER BY 
            					ccrz__DateIssued__c DESC
							];


		return invoices;
	}


		private static List<ccrz__E_Invoice__c> queryInvoicesByParams(Id accountId, cc_mn_json_InvoiceQueryWrapper wrapper){
		
		String accountIdString = String.valueOf(accountId);
		String query = 	'SELECT Id, Name, ccrz__BillTo__r.Id, ccrz__BillTo__r.Name, ccrz__BillTo__r.AccountNumber, ccrz__BillTo__r.ccrz__E_AccountGroup__c, ccrz__SoldTo__r.Id, ccrz__SoldTo__r.Name, ccrz__SoldTo__r.AccountNumber, ccrz__SoldTo__r.ccrz__E_AccountGroup__c, ccrz__SoldAddress__r.Id, ccrz__SoldAddress__r.Name, ccrz__SoldAddress__r.ccrz__AddressFirstline__c, ccrz__SoldAddress__r.ccrz__AddressSecondline__c, ccrz__SoldAddress__r.ccrz__AddressThirdline__c, ccrz__SoldAddress__r.ccrz__City__c, ccrz__SoldAddress__r.ccrz__CompanyName__c, ccrz__SoldAddress__r.ccrz__DaytimePhone__c, ccrz__SoldAddress__r.ccrz__State__c, ccrz__SoldAddress__r.ccrz__PostalCode__c, ccrz__SoldAddress__r.ccrz__Email__c, ccrz__SoldAddress__r.ccrz__FirstName__c, ccrz__SoldAddress__r.ccrz__HomePhone__c, ccrz__SoldAddress__r.ccrz__LastName__c, ccrz__SoldAddress__r.ccrz__MailStop__c, ccrz__SoldAddress__r.ccrz__MiddleName__c, ccrz__SoldAddress__r.ccrz__Partner_Id__c, ccrz__SoldAddress__r.ccrz__StateISOCode__c, ccrz__SoldAddress__r.ccrz__Country__c, ccrz__SoldAddress__r.ccrz__CountryISOCode__c, ccrz__CCOrder__c, ccrz__CCOrder__r.Id, ccrz__CCOrder__r.Name, ccrz__CCOrder__r.ccrz__EncryptedId__c, ccrz__InvoiceId__c, ccrz__DateIssued__c, ccrz__DateDue__c, ccrz__OriginalAmount__c, ccrz__RemainingAmount__c, ccrz__Type__c, ccrz__Status__c, ccrz__CurrencyCode__c, ccrz__Terms__c, ccrz__BillAddress__r.Id, ccrz__BillAddress__r.Name, ccrz__BillAddress__r.ccrz__AddressFirstline__c, ccrz__BillAddress__r.ccrz__AddressSecondline__c, ccrz__BillAddress__r.ccrz__AddressThirdline__c, ccrz__BillAddress__r.ccrz__City__c, ccrz__BillAddress__r.ccrz__CompanyName__c, ccrz__BillAddress__r.ccrz__DaytimePhone__c, ccrz__BillAddress__r.ccrz__State__c, ccrz__BillAddress__r.ccrz__PostalCode__c, ccrz__BillAddress__r.ccrz__Email__c, ccrz__BillAddress__r.ccrz__FirstName__c, ccrz__BillAddress__r.ccrz__HomePhone__c, ccrz__BillAddress__r.ccrz__LastName__c, ccrz__BillAddress__r.ccrz__MailStop__c, ccrz__BillAddress__r.ccrz__MiddleName__c, ccrz__BillAddress__r.ccrz__Partner_Id__c, ccrz__BillAddress__r.ccrz__StateISOCode__c, ccrz__BillAddress__r.ccrz__Country__c, ccrz__BillAddress__r.ccrz__CountryISOCode__c, ccrz__Contact__r.Id, ccrz__Contact__r.Name, ccrz__ParentInvoice__r.Id, ccrz__ParentInvoice__r.Name, PONumber__c FROM  ccrz__E_Invoice__c  WHERE SAP_Ship_To__c = :accountIdString';


		if( wrapper.searchInvoiceInput != null &&  wrapper.searchInvoiceInput.length() > 0){

			String likeQuery = '%' + wrapper.searchInvoiceInput + '%';
			query += ' and (Name like :likeQuery OR PONumber__c like :likeQuery OR ccrz__InvoiceId__c like :likeQuery)';
		}
		if ( wrapper.searchInvoiceStatus != null &&  wrapper.searchInvoiceStatus.length() > 0 && wrapper.searchInvoiceStatus != 'All' ){
			String statusFilter = wrapper.searchInvoiceStatus;
			query += ' and ccrz__Status__c =: statusFilter';
		}
		if(  wrapper.searchInvoiceType != null &&  wrapper.searchInvoiceType.length() > 0  && wrapper.searchInvoiceStatus != 'All' ){
			String invoiceFilter = wrapper.searchInvoiceType;
			query += ' and ccrz__Type__c =:invoiceFilter';
		}
		if( wrapper.fromDateStr != null && wrapper.fromDateStr.length() > 0){
			Date fromDate = Date.parse(wrapper.fromDateStr);
			query += ' and ccrz__DateIssued__c >=:fromDate';
		}if( wrapper.toDateStr != null && wrapper.toDateStr.length() > 0){
			Date toDateStr = Date.parse(wrapper.toDateStr);
			query += ' and ccrz__DateIssued__c <=:toDateStr';
		} if( wrapper.sortCriteria != null && wrapper.sortCriteria.length()>0){
			query += ' ORDER BY ';
			String orderByColumn = sortMap.get(wrapper.sortCriteria);
			query += orderByColumn;

			//If sorting by paid amount, must use remaining amount and use the opposite of the sort direction
			if(orderByColumn == 'orderByColumn'){
				if(wrapper.sortDir == 'Asc'){
					query += ' Desc';
				}else{
					query += ' Asc';
				}

			}else{
				query += ' ' + wrapper.sortDir;
			}
		}

		System.debug(query);

		List<ccrz__E_Invoice__c> invoices =(List<ccrz__E_Invoice__c>)Database.query( query );


		return invoices;
	}

	public static void disputeInvoice(String sfid) {
		ccrz__E_Invoice__c invoice = new ccrz__E_Invoice__c(Id = sfid, ccrz__Status__c = 'Disputed');
		update invoice;
	}

}