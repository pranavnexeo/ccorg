/**  
* @Name CallUpEditExtension
* @Purpose This is an Extension for CallUp Standard Controller .
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class CallUpEditExtension {

    
    private final Call_Up__c callUp;
    private String feePropertyId = null;
    private String leasePropertyId = null;
    private String description = null;
    private String entityName = null;
    private String fileLocation = null;
    private boolean editFlag = false;
       
	/**  
	* @Name CallUpEditExtension
	* @Purpose This is the constructor for CallUpEditExtension
	* @param ApexPages.StandardController
	* @return 
	* @Author  Deepak
	*/
    public CallUpEditExtension(ApexPages.StandardController controller) {
        
        System.debug('-----Inside CheckRequestExtension-----'); 
        callUp=(Call_Up__c)controller.getRecord();
                
    }
    /**  
	* @Name init
	* @Purpose This method executes at page load and extracts certain values send through url param and sets it to call up fields
	* @param 
	* @return void
	* @Author  Deepak
	*/
    public void init(){
    
        System.debug('------- Inside Init -------');
        feePropertyId=Apexpages.currentPage().getParameters().get('feePropertyId');
        leasePropertyId=Apexpages.currentPage().getParameters().get('leasePropertyId');
        description=Apexpages.currentPage().getParameters().get('description');
        entityName=Apexpages.currentPage().getParameters().get('entityName');
        fileLocation=Apexpages.currentPage().getParameters().get('location');
        
        System.debug('------- location -------'+fileLocation);
        System.debug('------- entityName -------'+entityName);
        System.debug('------- description -------'+description);
        System.debug('------- feePropertyId -------'+feePropertyId);
        System.debug('------- leasePropertyId -------'+leasePropertyId);
        
        if(entityName!=null){
        
            callUp.Description__c=description;
            callUp.Entity_Name__c=entityName;
            callUp.File_Location__c=fileLocation;
            callUp.Status__c='Open';
    
            if(leasePropertyId!=null){
                callUp.Lease_Property__c=leasePropertyId;
            }else if(feePropertyId!=null){
                callUp.Fee_Property__c=feePropertyId;
            }
        }else{
            editFlag = true;
        }
    }
    /**  
	* @Name closeCallUp
	* @Purpose This method is used to change the status of a call up to closed.
	* @param 
	* @return void
	* @Author  Deepak
	*/
    public void closeCallUp(){
    
        System.debug('-------Close Call Up-------------');
        callUp.Status__c='Closed';
        callUp.Reviewed_By__c = UserInfo.getName();
        update callUp;
    
    }
    /**  
	* @Name getEditFlag
	* @Purpose This method returns edit flag.Used in Ui to control the display of Close Call Up Button.
	* @param 
	* @return boolean
	* @Author  Deepak
	*/
    public boolean getEditFlag(){
        return editFlag;
    }
    
        
}