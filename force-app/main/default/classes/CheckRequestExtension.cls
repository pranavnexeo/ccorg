/**  
* @Name CheckRequestExtension
* @Purpose his is an Extension for Check Request Standard Controller .
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class CheckRequestExtension {
    
    private final Check_Request__c checkRequest;
    /**  
    * @Name CheckRequestExtension
    * @Purpose This is the constructor for CheckRequestExtension
    * @param ApexPages.StandardController
    * @return 
    * @Author  Deepak
    */ 
    public CheckRequestExtension(ApexPages.StandardController controller) {
        
        System.debug('-----Inside CheckRequestExtension-----'); 
        checkRequest=(Check_Request__c)controller.getRecord();
             
        
    }
    /**  
    * @Name doCalculation
    * @Purpose This method is used to calculate Old Total,Total Amount and Total Change 
    * @param 
    * @return void
    * @Author  Deepak
    */ 
    public void doCalculation(){
    
        System.debug('-------Do Calculation------');
        System.debug('-------checkRequest.Vendor_Rent__c------'+checkRequest.Vendor_Rent__c);
        System.debug('-------checkRequest.Original_Vendor_Rent__c------'+checkRequest.Original_Vendor_Rent__c);
        System.debug('-------checkRequest.Original_Expenses__c------'+checkRequest.Original_Expenses__c);
        System.debug('-------checkRequest.Original_Adjustments__c------'+checkRequest.Original_Adjustments__c);
        double originalVendorRent = 0.0;
        double originalExpenses = 0.0;
        double originalAdjustments = 0.0;
        double vendorRent = 0.0;
        double vendorExpenses = 0.0;
        double adjustments = 0.0;
        double totalAmount = 0.0;
        double oldTotal = 0.0;
            
        if(checkRequest.Original_Vendor_Rent__c!=null){
            originalVendorRent = checkRequest.Original_Vendor_Rent__c;
            
        }    
        if(checkRequest.Original_Expenses__c!=null){
            originalExpenses=checkRequest.Original_Expenses__c;
        }
        if(checkRequest.Original_Adjustments__c!=null){
            originalAdjustments=checkRequest.Original_Adjustments__c;
        }
        if(checkRequest.Vendor_Rent__c!=null){
            vendorRent=checkRequest.Vendor_Rent__c;
            checkRequest.Base_Rent__c=vendorRent;
        }
        if(checkRequest.Vendor_Expenses__c!=null){
            vendorExpenses=checkRequest.Vendor_Expenses__c;
        }
        if(checkRequest.Adjustments__c!=null){
            adjustments=checkRequest.Adjustments__c;
        }       
           
        
        checkRequest.Old_Total__c = originalVendorRent+originalExpenses+originalAdjustments;
        checkRequest.Total_Amount__c = vendorRent + vendorExpenses + adjustments;
        checkRequest.Total_Change__c = checkRequest.Total_Amount__c-checkRequest.Old_Total__c;
    }
    /**  
    * @Name init
    * @Purpose This method is called during page load and it loads some fields in the check requests from the parent Lease Object. 
    * @param 
    * @return void
    * @Author  Deepak
    */ 
    public void init(){
        
        String leasePropertyId = System.currentPagereference().getParameters().get('leasePropertyId');
        String vendor= System.currentPagereference().getParameters().get('vendor');
        system.debug('-----Vendor---------'+vendor);
        if(vendor!=null && vendor!=''){
            checkRequest.Vendor__c = vendor;
        }
        
        System.debug('-----leasePropertyId1-----'+leasePropertyId);
        List<Lease_Property__c> leaseList = [select Base_Rent__c,Property_Address__c,Total_Expense__c from Lease_Property__c where name=:leasePropertyId];
        if(leaseList!=null && !leaseList.isEmpty()){
            
            double baseRent = 0.0;
            double totalExpenses = 0.0;
            double adjustments = 0.0;
            double oldTotal = 0.0;
            
            Lease_Property__c leaseProperty = leaseList.get(0);
            checkRequest.Lease_Property__c = leaseProperty.Id;
            
            if(leaseProperty.Base_Rent__c != null){
                baseRent = leaseProperty.Base_Rent__c;
            }
            if(leaseProperty.Total_Expense__c !=null){
                totalExpenses = leaseProperty.Total_Expense__c;
            }
            if(checkRequest.Adjustments__c!=null){
                adjustments = checkRequest.Adjustments__c;
            }
            if(checkRequest.Old_Total__c!=null){
                oldTotal = checkRequest.Old_Total__c;
            }
            
            
            System.debug('-------baseRent------'+baseRent);
            System.debug('-------totalExpenses------'+totalExpenses);
            
            checkRequest.Vendor_Rent__c= baseRent;
            checkRequest.Vendor_Expenses__c = totalExpenses;
            
            System.debug('-------checkRequest.Vendor_Rent__c------'+checkRequest.Vendor_Rent__c);
            System.debug('-------checkRequest.Vendor_Expenses__c------'+checkRequest.Vendor_Expenses__c);
            System.debug('-------adjustments------'+adjustments);
            
                        
            
            checkRequest.Total_Amount__c = checkRequest.Vendor_Rent__c + checkRequest.Vendor_Expenses__c + adjustments;
            
            
            checkRequest.Total_Change__c = checkRequest.Total_Amount__c - oldTotal;
            
            
            
            
            checkRequest.Base_Rent__c = baseRent;
            checkRequest.Rent_Expenses__c = totalExpenses;
            
            
        }else{
            System.debug('-------leaseList Is empty ie In edit mode------');
        }
    
    }

}