/**  
* @Name updateLeaseCount
* @Purpose This trigger is used to calculate the count of Lease Properties belonging to a 
*          particular file type and state.This count is used to generate the file number.
* @Author  Deepak
* @Version 1.0 
*/
trigger updateLeaseCount on Lease_Property__c (before insert,before update) {
    
    List<Lease_Property__c> leaseList = Trigger.new;
    
    List<Lease_Property__c> oldLeaseList = Trigger.old;

    if(leaseList!=null && !leaseList.isEmpty()){
    
        Lease_Property__c property = (Lease_Property__c)leaseList.get(0);
        
        integer count =[select count() from Lease_Property__c where file_type__c=:property.File_Type__c and state__c =:property.state__c];
        
        if(Trigger.isInsert){
            property.count__c = String.valueOf(count+1) ;
        }else if(Trigger.isUpdate){
            
            Lease_Property__c oldProperty = (Lease_Property__c)oldLeaseList.get(0);
            
            System.debug('-------Old File Type -------------'+oldProperty.File_Type__c);
            System.debug('-------new File Type -------------'+property.File_Type__c);
            
            if(oldProperty.File_Type__c!=property.File_Type__c || oldProperty.state__c!=property.State__c){
            
                property.count__c = String.valueOf(count+1) ;
            }
        
        }
        //property.File__c = property.File_Code_c;
    
    }

    

}