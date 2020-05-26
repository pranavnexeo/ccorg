/**  
* @Name CrossReferencedPropertyController
* @Purpose This is a controller class used to display the Cross Referenced Properties associated with a Fee or Lease Property.
* @Author  Deepak
* @Version 1.0 
*/
public class CrossReferencedPropertyController {
    
   
    private String[] propArray = null;
   // private String[] feeArray = null;
    private List<Fee_Property__c> feePropertyList =null;
    private List<Lease_Property__c> leasePropertyList =null;
    private List<CrossReferenceProperty> propertyList = new List<CrossReferenceProperty>();
    private CrossReferenceProperty crossProperty = null;
    public boolean emptyFlag{get;set;}
     
     /**  
	* @Name getPropertyList
	* @Purpose This is used to return the propertyList 
	* @param 
	* @return List<CrossReferenceProperty>
	* @Author  Deepak
	*/
    public List<CrossReferenceProperty> getPropertyList(){
    
    	return propertyList;
    }

     /**  
	* @Name init
	* @Purpose This method is called during page load and it fetches the cross referenced properties associated with a Fee or Lease property.
	* @param 
	* @return void
	* @Author  Deepak
	*/           
    public void init() {

       System.debug('-------Inside init--------');
    
       String propertyIds = System.currentPagereference().getParameters().get('propertyId');
       //String leasePropertyIds = System.currentPagereference().getParameters().get('leasePropertyId');

       System.debug('-------propertyId----------------'+propertyIds);
       //System.debug('-------leasePropertyIds----------------'+leasePropertyIds);
       
       
       if(propertyIds !=null ){
           
           System.debug('---------propertyId  Property-----'+propertyIds );
            propArray = propertyIds.split(',');

            feePropertyList=[select id,name,file__c from Fee_Property__c where  file__c in:propArray];
            leasePropertyList = [select id,name,file__c from Lease_Property__c where  file__c in:propArray];  
            for(Fee_Property__c feeObj:feePropertyList){
            	crossProperty = new CrossReferenceProperty();
            	crossProperty.fileNumber = feeObj.File__c;
            	crossProperty.name = feeObj.Name;
            	crossProperty.Id= feeObj.Id;
            	propertyList.add(crossProperty);
            }
            for(Lease_Property__c leaseObj:leasePropertyList){
            	crossProperty = new CrossReferenceProperty();
            	crossProperty.fileNumber = leaseObj.File__c;
            	crossProperty.name = leaseObj.Name;
            	crossProperty.Id= leaseObj.Id;
            	propertyList.add(crossProperty);
            }
            
            //System.debug('------list size-----'+feePropertyList.size());  
                         
       }
       if(propertyList.isEmpty()){
            	emptyFlag = true;
       }
              
             
          
    }
    
    
}