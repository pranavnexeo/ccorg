/**  
* @Name FeePropertyExtension
* @Purpose This is an Extension for Fee Property Standard Controller .
* @Author  Deepak
* @Version 1.0 
*/
public class FeePropertyExtension {

      
    private Fee_Property__c feePropertyObj = null;
    //Apexpages.StandardController controllerObj;
    private List<CrossReferenceProperty> crossReferenceList = new List<CrossReferenceProperty>();
    private List<SelectOption> allCounties = null;
    private CrossReferenceProperty crossProperty = null;
    public boolean emptyFlag{get;set;}
    /**  
        * @Name getAllCounties
        * @Purpose This is used to return the counties for a particular state
        * @param 
        * @return List<SelectOption>
        * @Author  Deepak
        */
    public List<SelectOption> getAllCounties(){
        
        return allCounties;
    }
    /**  
        * @Name getCrossReferenceList
        * @Purpose This is used to return the cross referenced Fee Properties
        * @param 
        * @return List<CrossReferenceProperty>
        * @Author  Deepak
        */
     public List<CrossReferenceProperty> getCrossReferenceList(){
        
        return crossReferenceList;
    }
    /**  
        * @Name FeePropertyExtension
        * @Purpose This is the constructor for FeePropertyExtension
        * @param ApexPages.StandardController
        * @return 
        * @Author  Deepak
        */
    public FeePropertyExtension(ApexPages.StandardController controller) {
        
        //controllerObj = controller;
        feePropertyObj = (Fee_Property__c)controller.getRecord();
        
        if(feePropertyObj!=null){
        
            List<Fee_Property__c> feePropertyList = [select Id,File__c,name from Fee_Property__c where county__c=:feePropertyObj.county__c and state__c =:feePropertyObj.state__c and Id<>:feePropertyObj.Id];
            List<Lease_Property__c> leasePropertyList = [select Id,File__c,name from Lease_Property__c where county__c=:feePropertyObj.county__c and state__c =:feePropertyObj.state__c];
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
        * @Name getCounties
        * @Purpose This is used to fetch the list of counties for the state selected by the user
        * @param 
        * @return void
        * @Author  Deepak
        */ 
   public void getCounties(){
                
                System.debug('--------Inside getCounties--------');
               // System.debug('------allCounties Size 1------'+allCounties.size());
                
                System.debug('--------Selected State------'+Apexpages.currentPage().getParameters().get('selectedState'));
                
                String selectedState = Apexpages.currentPage().getParameters().get('selectedState');
                
                if(selectedState!=null){
                        feePropertyObj.county__c='';
                        feePropertyObj.state__c=selectedState;
                }
                
                
                List<County__c> countyList = [select State__c,County__c from County__c where State__c=:selectedState or State__c=:feePropertyObj.state__c ];
                
                if(countyList!=null && !countyList.isEmpty()){
                        
                        allCounties = new List<SelectOption>();
                         // System.debug('------allCounties Size 2------'+allCounties.size());
                        //System.debug('------County List Size------'+countyList.size());
                        allCounties.add(new SelectOption('','--Select--'));
                         
                         for(County__c county:countyList){
                                
                         allCounties.add(new SelectOption(county.County__c,county.County__c));
                         
                         }
                        
                }else{
                        System.debug('------allCounties=null------');
                        allCounties=null;
                }
        
        }
     
    
    
}