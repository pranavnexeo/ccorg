trigger ccProductUpsert_Nexeo on ccrz__E_Product__c (after insert, after update) {
    
    List<ccrz__E_Product__c> nexeo3D = new List<ccrz__E_Product__c>();
    List<ccrz__E_Product__c> myNexeo = new List<ccrz__E_Product__c>();
    
    for(ccrz__E_Product__c p :trigger.new){
        if(p.Nexeo3D__c == true)
            nexeo3D.add(p);
        else
            myNexeo.add(p);
    }
      
      if(myNexeo.size() > 0){      
        Cloudcraze_Product_Function.upsert_cloudcraze_product(myNexeo); 
        //this should be executed only at cc product insert
        //if(trigger.isInsert)
           // Cloudcraze_Product_Function.insert_product_media(myNexeo);
       }
        
        
      if(nexeo3D.size() > 0)      
        Cloudcraze_Product_Function.upsert_nexeo3D_product(nexeo3D);    
        
        
    
       
}