trigger CheckBatchDuplicate on Certificate_Of_Analysis__c (After insert)
 {
   for(Certificate_Of_Analysis__c a : Trigger.new){
       
       
       List<Certificate_Of_Analysis__c> checkDuplicate = [select id,Batch__c, Material__c,Supplier_Name__c from Certificate_Of_Analysis__c where Batch__c = :a.Batch__c and  Material__c =:a.Material__c and Supplier_Name__c =:a.Supplier_Name__c and Id != :a.Id and Supplier_Name__c != null and Batch__c != '' and Material__c != null]; 
        if(checkDuplicate.size() > 0){
            a.adderror('This batch combination already exists, please update the existing batch instead of creating a duplicate record');
        }
       
       
   }
}