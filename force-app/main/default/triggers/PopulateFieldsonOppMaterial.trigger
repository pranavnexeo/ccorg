trigger PopulateFieldsonOppMaterial on Opportunity_Material__c (before insert, before update) {
   Map <String, ID>RTMap = RecordType_Functions.RetrieveRecordTypeNameMap('Opportunity_Material__c');
   
    //Iterating thru all Opportunity Products inserted/updated   
     for(Opportunity_Material__c oppMat : Trigger.new) {       
        if(oppMat.RecordTypeID == RTMap.get('AQ Opportunity Material')){
      //Calculation of Quantity in MT based on Unit Of Measure 
           if(oppMat.Unit_of_Measure__c == 'KG'){
             if(oppMat.Quantity__c != null){
             oppMat.Quantity_in_MT__c = oppMat.Quantity__c/1000;}
             if(oppMat.Sales_Price__c != null){
             oppMat.Sales_Price_per_MT__c = oppMat.Sales_Price__c * 1000;}     
           } 
           else {
              if(oppMat.Quantity__c != null){
             oppMat.Quantity_in_MT__c = oppMat.Quantity__c/2204.6;}
             if(oppMat.Sales_Price__c != null){
             oppMat.Sales_Price_per_MT__c = oppMat.Sales_Price__c * 2204.6;}     
    
           }
             oppMat.Revenue__c = oppMat.Sales_Price__c * oppMat.Quantity__c;}
        
        
        }
     }