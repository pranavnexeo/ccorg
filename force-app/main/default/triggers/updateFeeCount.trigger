/**  
* @Name updateFeeCount
* @Purpose This trigger is used to calculate the count of Fee Properties belonging to a 
*		   particular file type and state.This count is used to generate the file number.
* @Author  Deepak
* @Version 1.0 
*/
trigger updateFeeCount on Fee_Property__c (before update,before insert) {

    List<Fee_Property__c> feeList = Trigger.new;
    List<Fee_Property__c> oldFeeList = Trigger.old;
    
    if(feeList!=null && !feeList.isEmpty()){
        
        Fee_Property__c property = (Fee_Property__c)feeList.get(0);
        
        integer count =[select count() from Fee_Property__c where file_type__c=:property.file_type__c and state__c =:property.state__c];
        
        if(Trigger.isInsert){

            property.count__c = String.valueOf(count+1) ;

        }else if(Trigger.isUpdate){
              
            Fee_Property__c oldProperty = (Fee_Property__c)oldFeeList.get(0);
            
            System.debug('-------Old File Type -------------'+oldProperty.File_Type__c);
            System.debug('-------new File Type -------------'+property.File_Type__c);
            
            if(oldProperty.File_Type__c!=property.File_Type__c || oldProperty.state__c!=property.State__c){
                
                System.debug('-------File_Type__c is changed -------'+count);
            
                property.count__c = String.valueOf(count+1) ;
            }    
        }      
             
            System.debug('-------Final Count value -------'+property.count__c);      
    }
    

}