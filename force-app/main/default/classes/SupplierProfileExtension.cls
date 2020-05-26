/**  
* @Name SupplierProfileExtension
* @Purpose This is an Extension class used for Supplier Profile .
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class SupplierProfileExtension {
    
     private final Supplier_Profile__c supplierProfile;
     private final ApexPages.StandardController supplierProfileController;
     private List<SelectOption> supplierPiNumberList = new List<SelectOption>();
     /*private List<SelectOption> currencyList = new List<SelectOption>();*/
     //private List<SelectOption> supplierDmContactNumberList = new List<SelectOption>();
    
    
    public List<SelectOption> getSupplierPiNumberList(){
        
            return supplierPiNumberList;
    }
    
    /*public List<SelectOption> getSupplierDmContactNumberList(){
        
            return supplierDmContactNumberList;
    }*/
    
    /*public List<SelectOption> getCurrencyList(){
            return currencyList;
    }*/
    
    public SupplierProfileExtension(ApexPages.StandardController controller) {
        
        supplierProfileController = controller;
        supplierProfile = (Supplier_Profile__c)controller.getRecord();
        
        if(supplierProfile.Id!=null){
        
            System.debug('------------Edit Mode-------------');
            getSupplierDetails();
        
        }
    }


    public void getSupplierDetails(){
        
        supplierPiNumberList.clear();
        supplierProfile.Upfront_Only__c='';
        
        String supplierId = ApexPages.currentPage().getParameters().get('supplierForceId');
        String purchaseOrg = ApexPages.currentPage().getParameters().get('purchasingOrg');
        String divisionName = ApexPages.currentPage().getParameters().get('divisionName');
        
        System.debug('----------supplierId-------------'+supplierId);
        System.debug('----------purchaseOrg-------------'+purchaseOrg);
        
        if(supplierId==null){
        	supplierId = supplierProfile.Supplier_Name__c;
        }
        
        if(purchaseOrg==null){
        	purchaseOrg = supplierProfile.Purchasing_Organization__c;
        }
        
        if(divisionName==null){
        	divisionName = supplierProfile.Division_Name__c;
        }
        
        System.debug('----------supplierId11-------------'+supplierId);
        System.debug('----------purchaseOrg11-------------'+purchaseOrg);
        
        /*List <Supplier_Profile__c>  duplicateProfiles = [Select Supplier_Number__c, Purchasing_Organization__c, Supplier_Name__c ,Id From Supplier_Profile__c where Supplier_Name__c =:supplierId  and Purchasing_Organization__c =:purchaseOrg and Division_Name__c=:divisionName];
        
        System.debug('-------------duplicateProfiles ----------'+duplicateProfiles);
        if(duplicateProfiles!=null && !duplicateProfiles.isEmpty()){
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'A Supplier Profile for this Supplier already exists for the selected Purchasing Organization and Division');
            
            ApexPages.getMessages().clear();
            
            ApexPages.addMessage(myMsg);
            
            return;
            
        }*/
        
        //String vendorUniqueId = supplierId+purchaseOrg;
        
        //System.debug('----------vendorUniqueId-------------'+vendorUniqueId);
        
        List <Account> supplierList = [select SAP_PartnerFunctionCodeText__c,SAP_Supplier_Number__c,SAP_PartnerFunctionText__c,SAP_Currency__c from Account where  Id=:supplierId  and SAP_Vendor_Purchase_Org__c =:purchaseOrg and VendorUniqueId__c!=null];
        
        if(supplierList!=null && !supplierList.isEmpty()){
        	Account supplierObj = supplierList.get(0);
        	getPartnerFunctionCode(supplierObj);
	        supplierProfile.Supplier_Currency__c = supplierObj.SAP_Currency__c;
        }
        
        
        /*if(supplierObj.SAP_PartnerFunctionText__c==null || supplierObj.SAP_PartnerFunctionText__c==''){
        	String supplierNo = supplierObj.SAP_Supplier_Number__c;
        	supplierList.clear();
        	supplierList= [select SAP_PartnerFunctionCodeText__c,SAP_PartnerFunctionText__c,SAP_Supplier_Number__c,SAP_Currency__c from Account where SAP_Supplier_Number__c=:supplierNo and SAP_Vendor_Purchase_Org__c =:purchaseOrg];
        }else if(supplierObj.SAP_PartnerFunctionText__c.split(',').size()!=supplierObj.SAP_PartnerFunctionCodeText__c.split(',').size()){
        	System.debug('----Size Mismatch---');
        	String supplierNo = supplierObj.SAP_Supplier_Number__c;
        	supplierList.clear();
        	supplierList= [select SAP_PartnerFunctionCodeText__c,SAP_PartnerFunctionText__c,SAP_Supplier_Number__c,SAP_Currency__c from Account where SAP_Supplier_Number__c=:supplierNo and SAP_Vendor_Purchase_Org__c =:purchaseOrg];
        }
        System.debug('---------supplierList---------'+supplierList);
        for(Account suppObj:supplierList){
        	
        	if(suppObj.SAP_PartnerFunctionText__c!=null && suppObj.SAP_PartnerFunctionCodeText__c!=null){
        		if(suppObj.SAP_PartnerFunctionText__c.split(',').size()==suppObj.SAP_PartnerFunctionCodeText__c.split(',').size()){
        			System.debug('-------Looping for correct supplier-----------');
	        		getPartnerFunctionCode(suppObj);
	            	supplierProfile.Supplier_Currency__c = suppObj.SAP_Currency__c;
	            	break;
        		}
        	}
        }*/
        
    }
    
    
    private void getPartnerFunctionCode(Account supplierObj){
    
        String partnerFuctions = supplierObj.SAP_PartnerFunctionText__c;
        String partnerFuctionCodes = supplierObj.SAP_PartnerFunctionCodeText__c;
        System.debug('------------partnerFuctions11----------'+partnerFuctions);
        System.debug('------------partnerFuctionCodes11----------'+partnerFuctionCodes);
        Map<String,String> partnerFunctionMap = new Map<String,String>();
        List<String> partnerFunctionList =null;
        List<String> partnerFuctionCodesList =null;
        supplierPiNumberList.clear();
        //supplierDmContactNumberList.clear();
        
        if(partnerFuctions!=null && partnerFuctions.length()>0){
            
            System.debug('------------partnerFuctions----------'+partnerFuctions);
            partnerFunctionList = partnerFuctions.split(',');
        }
        
        if(partnerFuctionCodes!=null && partnerFuctionCodes.length()>0){
            
            System.debug('------------partnerFuctionCodes----------'+partnerFuctionCodes);
            partnerFuctionCodesList = partnerFuctionCodes.split(',');
        }
        
        if(partnerFunctionList!=null && partnerFuctionCodesList!=null){
            
            if(partnerFunctionList.size()!=partnerFuctionCodesList.size()){
            
                System.debug('-------------Partner Function Not Proper in SFDC----------');
                
            }
            try{
                Integer indx =0;
            
                for(String functions: partnerFunctionList){
                    
                    if(functions.equalsIgnoreCase('RS')){
                    
                        supplierPiNumberList.add(new SelectOption(partnerFuctionCodesList.get(indx),partnerFuctionCodesList.get(indx)));
                        
                    }/*else if(functions.equalsIgnoreCase('ZA')){
                        
                        supplierDmContactNumberList.add(new SelectOption(partnerFuctionCodesList.get(indx),partnerFuctionCodesList.get(indx)));
                    }*/
                    
                    indx++;
                    
                }
            }catch(Exception e){
            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Partner Function Not Proper in SFDC.Please select another Supplier.');
                
                ApexPages.getMessages().clear();
                
                ApexPages.addMessage(myMsg);
                
                return;
                
                
            }
            
            /*if(supplierDmContactNumberList.isEmpty()){
            
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Supplier Does not have an ZA Vendor');
                
                ApexPages.getMessages().clear();
                
                ApexPages.addMessage(myMsg);
                
                return;
            }*/
            
            if(supplierPiNumberList.isEmpty()){
                
                supplierProfile.Upfront_Only__c= 'Yes';
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'Supplier Does not have PI Vendor. Can only be used for Upfront');
                
                ApexPages.getMessages().clear();
                
                ApexPages.addMessage(myMsg);
                
                return;
                
            }else{
            	 supplierProfile.Upfront_Only__c='';
            }
            
            System.debug('-------------supplierPiNumberList Size----------'+supplierPiNumberList.size());
            //System.debug('-------------supplierDmContactNumberList Size----------'+supplierDmContactNumberList.size());
        
        }else{
        
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No Partner Function is available for this Supplier.Please select another supplier.');
                
                ApexPages.getMessages().clear();
                
                ApexPages.addMessage(myMsg);
        
        }
        
        
        /*String supplierId = ApexPages.currentPage().getParameters().get('supplierForceId');
        String purchaseOrg = ApexPages.currentPage().getParameters().get('purchasingOrg');
        String divisionName = ApexPages.currentPage().getParameters().get('divisionName');
        
        System.debug('----------supplierId-------------'+supplierId);
        System.debug('----------purchaseOrg-------------'+purchaseOrg);
        
        if(supplierId==null){
        	supplierId = supplierProfile.Supplier_Name__c;
        }
        
        if(purchaseOrg==null){
        	purchaseOrg = supplierProfile.Purchasing_Organization__c;
        }
        
        if(divisionName==null){
        	divisionName = supplierProfile.Division_Name__c;
        }*/
        
        
    }
    
    public PageReference customSave(){
    	
    	String supplierId=supplierProfile.Supplier_Name__c;
    	String purchaseOrg=supplierProfile.Purchasing_Organization__c;
    	String divisionName=supplierProfile.Division_Name__c;
    	
    	List <Supplier_Profile__c>  duplicateProfiles = [Select Supplier_Number__c, Purchasing_Organization__c, Supplier_Name__c ,Id From Supplier_Profile__c where Supplier_Name__c =:supplierId  and Purchasing_Organization__c =:purchaseOrg and Division_Name__c=:divisionName];
        
        System.debug('-------------duplicateProfiles ----------'+duplicateProfiles);
        if(duplicateProfiles!=null && !duplicateProfiles.isEmpty() && duplicateProfiles.size()>1){
            
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'A Supplier Profile for this Supplier already exists for the selected Purchasing Organization and Division');
            
            ApexPages.getMessages().clear();
            
            ApexPages.addMessage(myMsg);
            
            return null;
            
        }else{
        	return supplierProfileController.save();
        }
    	
    
    }
    
    
}