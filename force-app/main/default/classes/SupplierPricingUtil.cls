global class SupplierPricingUtil {
          
                webService static String clearPriceUpdateFlags( String priceId ){
          
                    Supplier_Pricing__c sp = [Select Id, Is_Price_Changed__c FROM Supplier_Pricing__c WHERE id =: priceId ];
                    
                    sp.Is_Price_Changed__c = false;
                    update sp;
                    return '0';         
                }      
                webService static String updateRegionPriceflag( String region ){
                    
                    //get count to update           
                    Integer cnt = [Select count() FROM Supplier_Pricing__c WHERE Is_Price_Changed__c = true AND Region__c =: region ];
                    
                    //if there are none send client indicator
                    if ( cnt < 1 ){
                        return '1';
                    }
                    //get SupplierPricing list   
                    for ( Supplier_Pricing__c[] sp : [Select Id, Is_Price_Changed__c FROM Supplier_Pricing__c WHERE Is_Price_Changed__c = true AND Region__c =: region ] ){
                        for ( Supplier_Pricing__c singleSP : sp)    {
                            singleSP.Is_Price_Changed__c = false;
                        }
                        
                        //update table
                        update sp;
                            
                    }
                    return '0';         
                }        
}