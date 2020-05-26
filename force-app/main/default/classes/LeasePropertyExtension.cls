/**  
* @Name LeasePropertyExtension
* @Purpose This is an Extension for Lease Property Standard Controller .
* @Author  Deepak
* @Version 1.0 
*/
public class LeasePropertyExtension {
    
    private Lease_Property__c leasePropertyObj = null;
    private boolean showFinancials=false;
    private List<CrossReferenceProperty> crossReferenceList = new List<CrossReferenceProperty>();
    private List<SelectOption> allCounties = null;
    private CrossReferenceProperty crossProperty = null;
    public boolean emptyFlag{get;set;}
    
    
    /**  
        * @Name getShowFinancials
        * @Purpose This is used to return the showFinancials field
        * @param 
        * @return boolean
        * @Author  Deepak
        */
    public boolean getShowFinancials(){
        return showFinancials;
    }
    /**  
        * @Name getCrossReferenceList
        * @Purpose This is used to return the crossReferenceList 
        * @param 
        * @return List<CrossReferenceProperty>
        * @Author  Deepak
        */
    public List<CrossReferenceProperty> getCrossReferenceList(){
        
        return crossReferenceList;
    }
    /**  
        * @Name getAllCounties
        * @Purpose This is used to return the list of counties for a particular state.To show in a select box. 
        * @param 
        * @return List<SelectOption>
        * @Author  Deepak
        */
    public List<SelectOption> getAllCounties(){
        
        return allCounties;
    }
    /**  
        * @Name LeasePropertyExtension
        * @Purpose This is the constructor for CallUpEditExtension
        * @param ApexPages.StandardController
        * @return 
        * @Author  Deepak
        */
    public LeasePropertyExtension(ApexPages.StandardController controller) {
        
        leasePropertyObj = (Lease_Property__c)controller.getRecord();
        
        if(leasePropertyObj!=null){
        
            List<Fee_Property__c> feePropertyList = [select Id,File__c,name from Fee_Property__c where county__c=:leasePropertyObj.county__c and state__c =:leasePropertyObj.state__c and Id<>:leasePropertyObj.Id];
            List<Lease_Property__c> leasePropertyList = [select Id,File__c,name from Lease_Property__c where county__c=:leasePropertyObj.county__c and state__c =:leasePropertyObj.state__c];
            for(Fee_Property__c feeObj:feePropertyList){
                crossProperty = new CrossReferenceProperty();
                crossProperty.fileNumber = feeObj.File__c;
                crossProperty.name = feeObj.Name;
                crossProperty.Id= feeObj.Id;
                crossReferenceList.add(crossProperty);
            }
            for(Lease_Property__c leaseObj:leasePropertyList){
                crossProperty = new CrossReferenceProperty();
                crossProperty.fileNumber = leaseObj.File__c;
                crossProperty.name = leaseObj.Name;
                crossProperty.Id= leaseObj.Id;
                crossReferenceList.add(crossProperty);
            }
        }
        if(crossReferenceList.isEmpty()){
                emptyFlag = true;
       }
        
        getCounties();
    
    }
    /**  
        * @Name showLeaseFinancial
        * @Purpose This method is used to toggle the flag used to control the display of Lease Financial Section in the UI.
        * @param 
        * @return void
        * @Author  Deepak
        */
    public void showLeaseFinancial(){
        if(showFinancials){
            showFinancials=false;
        }else{
            showFinancials=true;
        }
    }
    /**  
        * @Name getCounties
        * @Purpose This method is used to fecth the list of counties for a particular state selected by the user.
        * @param 
        * @return void
        * @Author  Deepak
        */
    public void getCounties(){
        
        System.debug('--------Inside getCounties--------');
        
        
         System.debug('------allCounties Size 1------'+allCounties);
        String selectedState = Apexpages.currentPage().getParameters().get('selectedState');
        System.debug('--------Selected State------'+selectedState);
        
        if(selectedState!=null){
            leasePropertyObj.county__c='';
            leasePropertyObj.State__c=selectedState;
        }
        
        List<County__c> countyList = [select State__c,County__c from County__c where State__c=:leasePropertyObj.State__c or State__c=:selectedState];
        
        if(countyList!=null && !countyList.isEmpty()){
            
            //System.debug('------County List Size------'+countyList.size());
            
             allCounties = new List<SelectOption>();
             allCounties.add(new SelectOption('','--Select--'));
             
             for(County__c county:countyList){
                
                 allCounties.add(new SelectOption(county.County__c,county.County__c));
                 
             }
            
        }else{
            allCounties=null;
        }
    
    }

    
}