/**  
* @Name PriceSupportMassRenewExpireController
* @Purpose This is a controller class used for peforming Mass Renew/Expire on Price Supports .
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class PriceSupportMassRenewExpireController {
	
	public Date expirationDate{get;set;}
	public String expirationReason{get;set;}
	public String emailSupplier{get;set;}
	public boolean massRenew{get;set;}
	
	String selectedRecords  =null;
	List<String> selectedPriceSupports = null;
	private final String objectName = 'Price_Support__c';
	
	/**  
	* @Name PriceSupportMassRenewExpireController
	* @Purpose This is the constructor for PriceSupportMassRenewExpireController.Used to distinguish btwn Mass Renew and Mass Expire
	* @param 
	* @return 
	* @Author  Deepak
	*/
	public PriceSupportMassRenewExpireController(){
	
		String expireFlag = ApexPages.currentPage().getParameters().get('expire');
		String renewFlag = ApexPages.currentPage().getParameters().get('renew');
		
		if(expireFlag!=null && expireFlag.equalsIgnoreCase('true')){
			massRenew = false;
		}else if(renewFlag!=null && renewFlag.equalsIgnoreCase('true')){
			massRenew = true;
		}
		emailSupplier='No';
		
		selectedRecords = Apexpages.currentPage().getParameters().get('selectedRecords');
        System.debug('Selected Price Supports-------'+selectedRecords);
        
        
        if(selectedRecords!=null){
        
            selectedPriceSupports = selectedRecords.split(',');
        }
	}
	/**  
	* @Name doMassRenew
	* @Purpose This is method is used to perform Mass renew
	* @param 
	* @return 
	* @Author  Deepak
	*/
	public void doMassRenew(){
		
		System.debug('-------------Mass Renew----------');
		List<Price_Support__c> clonedPriceSupports = PriceSupportUtil.clonePriceSupports(objectName, selectedPriceSupports,PriceSupportUtil.RENEW,expirationDate,null);
		insert clonedPriceSupports;
		
		//System.debug('------------clonedPriceSupports--'+clonedPriceSupports.get(0).id);
		
		List<Bracketed_Pricing__c> clonedBracketedPricing = PriceSupportUtil.cloneBracketedPricing(clonedPriceSupports);
		
		if(clonedBracketedPricing!=null && !clonedBracketedPricing.isEmpty()){
		
			insert clonedBracketedPricing;
			
		}
	
	}
	
	/**  
	* @Name doMassExpiry
	* @Purpose This is method is used to perform Mass Expire
	* @param 
	* @return 
	* @Author  Deepak
	*/
	public void doMassExpiry(){
		
		System.debug('----------Mass Expiry---------');
		//Set <String> supplierGroupIds = new Set <String>();
		List<Price_Support__c> updateList = New List<Price_Support__c>();
		List<Price_Support__c> priceList = [select Id,Support_Id__c,Support_Type__c,Expiration_Date__c,Effective_Date__c,Supplier_Group__c,Additional_Comments__c from Price_Support__c where Id IN:selectedPriceSupports];
		
		if(priceList!=null && !priceList.isEmpty()){
			for(Price_Support__c priceObj:priceList){
				if(validate(priceObj)){
					//supplierGroupIds.add(priceObj.Supplier_Group__c);
					priceObj.Expiration_Date__c = expirationDate;
					if(priceObj.Support_Type__c==PriceSupportUtil.REBATE){
						priceObj.SAP_Transfer__c = PriceSupportUtil.OPEN;
					}
					//TODO comments in Audit Log.
					priceObj.Additional_Comments__c = nullCheck(priceObj.Additional_Comments__c) +'\n'+System.now()+' '+ expirationReason;
					if(emailSupplier.equalsIgnoreCase('Yes')){
						//Used for trigerring the email to supplier during mass Expiry.
						//This field is used in a workflow to trigger email.
						//Done like this to avoid governer limit as separate email needs to be send to each supplier.
						if(priceObj.Email_Supplier__c==true){
							priceObj.Email_Supplier__c=false;
						}else{
							priceObj.Email_Supplier__c=true;
						}
					}
					updateList.add(priceObj);
				}
			}
			if(!updateList.isEmpty()){
				update updateList;
				//TODO Email Part
				/*System.debug('--------emailSupplier------'+emailSupplier);
				if(emailSupplier.equalsIgnoreCase('Yes')){
					Set<String> supplierEmailSet = PriceSupportUtil.getSupplierEmailSet(supplierGroupIds);
					String subject = 'Expiration Date Changed';
					String message = 'Expiration date for the below price support is changed to '+expirationDate+'\n';
				}*/
			}
		
		}
	}
	/**  
	* @Name validate
	* @Purpose This is method is used to validate
	* @param 
	* @return 
	* @Author  Deepak
	*/
	private boolean validate(Price_Support__c priceObj){
	
		boolean status = true;
		
      	if(expirationDate>priceObj.Expiration_Date__c || expirationDate<priceObj.Effective_Date__c){
	        ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceObj.Support_ID__c +' is skipped as you are trying to set an expiration date before its effective date ('+priceObj.Effective_Date__c+') or after its expiration date ('+priceObj.Expiration_Date__c+').'));
	        status= false;
        }
       
        
        return status;
	}
	
	private String nullCheck(String val){
		if(val==null){
			return '';
		}else{
			return val;
		}
	}
}