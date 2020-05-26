global class cc_3d_ctrl_MyAccountUserInfo {

	public class MyException extends Exception {} 

	@RemoteAction
	global static ccrz.cc_RemoteActionResult getVatNumber(ccrz.cc_RemoteActionContext ctx ){

		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

		Id accountId = ccrz.cc_CallContext.currAccount.Id;

		try 
		{

			if ( Test.isRunningTest() ) {
				if(ccrz.cc_CallContext.currAccount.VAT_Number__c == '123Error'){
					throw new MyException('Test of Exception for code coverage.');
				}
			}	
			
			Account account = cc_3d_ctrl_MyAccountUserInfo.queryAccountById(accountId);


				cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
					new Map<String,Object>
					{'success' => true,
					  'vatNumber' => account.VAT_Number__c
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
	global static ccrz.cc_RemoteActionResult setVatNumber(ccrz.cc_RemoteActionContext ctx, String vatNumber ){

		ccrz.cc_RemoteActionResult response = cc_imp_hlpr_RemoteActionHelper.remoteInit(ctx);

		Id accountId = ccrz.cc_CallContext.currAccount.Id;

		try 
		{	

			if ( Test.isRunningTest() ) {
				if(ccrz.cc_CallContext.currAccount.VAT_Number__c == '123Error'){
					throw new MyException('Test of Exception for code coverage.');
				}
			}	

			
			List<Account> accounts = queryAccountsById(accountId);

			Account acct = null;

			if(! accounts.isEmpty() )  {
				    acct = accounts[0];


					acct.VAT_Number__c = vatNumber;
					update acct;	
					cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
						new Map<String,Object>
						{'success' => true }
					);	
	
			}else{
					cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, true, 
					new Map<String,Object>
					{'success' => false,
					'randall_test' => 'val'});
			}



		}
		catch(Exception e)
     	{
	     		
     			System.debug(e.getMessage());
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

	public static Account queryAccountById(Id inputId){
		Account account = [
							SELECT
								Id, 
									VAT_Number__c,
									Name
							FROM 
								Account 
							WHERE 
								Id = :inputId 
							LIMIT
								1
							];
		return account;
	}

	public static List<Account> queryAccountsById(Id inputId){
		List<Account> accounts = [
							SELECT
								Id, 
								VAT_Number__c,
								Name
							FROM 
								Account 
							WHERE 
								Id = :inputId 
							LIMIT
								1
							];
		return accounts;
	}


}