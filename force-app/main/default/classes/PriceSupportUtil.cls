/**  
* @Name PriceSupportUtil
* @Purpose This is a utility class in which most of the commonly used methods are written.
* @Author  Deepak
* @Version 1.0 
*/
public  with sharing class PriceSupportUtil { 
    
        public static final String OPEN = 'Open';
        public static final String AWAITING_NEXEO_APPROVAL = 'Awaiting Nexeo Approval';
        public static final String DECILNED = 'Declined';
        public static final String AWAITING_SUPPLIER_APPROVAL = 'Awaiting Supplier Approval';
        public static final String REJECTED_BY_SUPPLIER = 'Rejected by Supplier';
        public static final String CONDITIONALLY_APPROVED = 'Conditionally Approved';
        public static final String APPROVED = 'Approved';
        public static final String RENEWED = 'Renewed';
        public static final String REJECTED = 'Rejected';
        public static final String PURCHASED ='Purchased';
        public static final String CHANGED = 'Changed';
        public static final String EXPIRED = 'Expired';
        public static final String CANCELLED = 'Cancelled';
        public static final String REBATE = 'Rebate';
        public static final String UPFRONT = 'Upfront';
        public static final String FLAT = 'Flat';
        public static final String PRICE_CHANGE_CLONE = 'priceChangeClone';
        public static final String RENEW='Renew';
        public static final String CHANGE='Change';
        public static final String PORTALLINK='https://nexeo.my.salesforce.com/secur/login_portal.jsp?orgId=00DE0000000J54o&portalId=060E0000000PwzU';
        
        //Added for dynamic required fields
        public static final String SUPPLIER_SALES_CONTACT = 'Supplier Sales Contact';
        public static final String COMPETITOR_MANUFACTURER ='Competitor Manufacturer';
        public static final String COMPETITIVE_PRODUCT = 'Competitive Product';
        public static final String OEM = 'OEM';
        public static final String POTENTIAL_ANNUAL_VOLUME='Potential Annual Volume';
        public static final String APPLICATION= 'Application';
        public static final String MARKET_SEGMENT = 'Market Segment';
        
        /**  
        * @Name getFieldsToBeCloned
        * @Purpose This method is fetch the fields that needs to be cloned.
        * @param String 
        * @return List<String>
        * @Author  Deepak
        */       
        public static List<String> getFieldsToBeCloned(String objectName){
            
            List<String> selectFields = new List<String>();
            //Map<String,String> test = new Map<String,String>();
            Map<String, Schema.SObjectField> fMap = Schema.getGlobalDescribe().get(objectName).getDescribe().Fields.getMap(); 
            if (fMap != null){
               for (Schema.SObjectField ft : fMap.values()){ 
                // loop through all field tokens (ft)
                Schema.DescribeFieldResult fd = ft.getDescribe(); 
                // describe each field (fd)
                  if (fd.isCreateable()){ 
                     // field is creatable
                     selectFields.add(fd.getName());
                     //System.debug('--Field Name--'+fd.getName());
                     //System.debug('--Field Type--'+fd.getType());
                     
                     //test.put(fd.getName(),String.valueOf(fd.getType()));
                 }
                } 
            }
            //System.debug('--Map--'+test);
            selectFields.add('PriceChangesAutomaticallyApproved__c');
            return selectFields;
        }
        
        /**  
        * @Name clonePriceSupports
        * @Purpose This method is used to clone price supports.
        * @param String ,List<String>,String,Date,Date
        * @return List<Price_Support__c>
        * @Author  Deepak
        */   
    public static List<Price_Support__c> clonePriceSupports(String objectName,List<String> priceSupportIDs,String cloneType,Date newExpirationDate,Date newEffectiveDate){
        
        List<Price_Support__c> clonedPriceSupports = new List<Price_Support__c>();
        Price_Support__c clonedRecord = null;
        List<String> sObjectFields = getFieldsToBeCloned(objectName);
        
        String allSObjectFieldsQuery = 'SELECT ' + sObjectFields.get(0); 
        
          for (Integer i=1 ; i < sObjectFields.size() ; i++){
            allSObjectFieldsQuery += ', ' + sObjectFields.get(i);
          }
        
          allSObjectFieldsQuery += ' FROM ' + 
                                   objectName + 
                                   ' WHERE ID IN (\'' + priceSupportIDs.get(0) + 
                                   '\'';
    
          for (Integer i=1 ; i < priceSupportIDs.size() ; i++){
            allSObjectFieldsQuery += ', \'' + priceSupportIDs.get(i) + '\'';
          }
        
          allSObjectFieldsQuery += ')';
            
          for (Price_Support__c sObjectFromDatabase:
              Database.query(allSObjectFieldsQuery)){
              clonedRecord = sObjectFromDatabase.clone(false,true);
              clonedRecord.Parent_Price_Support__c = sObjectFromDatabase.Id;
              
              if(cloneType.equalsIgnoreCase(RENEW)){
                     // Effective date of renewed price support = Expiration Date of old price support + 1
                     clonedRecord.Effective_Date__c = sObjectFromDatabase.Expiration_Date__c+1;
                     clonedRecord.Expiration_Date__c = newExpirationDate;
                     clonedPriceSupports.add(setStatusAfterRenew(resetFields(clonedRecord,cloneType)));
               }else if(cloneType.equalsIgnoreCase(CHANGE)){
                     clonedRecord.Effective_Date__c = newEffectiveDate;
                     clonedRecord.Expiration_Date__c = newExpirationDate;
                     clonedPriceSupports.add(setStatus(resetFields(clonedRecord,cloneType))); 
               }
              
          }
        
        
        return clonedPriceSupports;
    }
    /**  
        * @Name resetFields
        * @Purpose This method is used to reset some important fields after cloning.
        * @param String ,List<String>,String,Date,Date
        * @return List<Price_Support__c>
        * @Author  Deepak
        */  
    public static Price_Support__c resetFields(Price_Support__c clonedObject,String cloneType){
       if(cloneType.equalsIgnoreCase(RENEW)){
            clonedObject.New_or_Changed__c = RENEWED;
            clonedObject.Birth_Date__c = System.Today();
       }else if(cloneType.equalsIgnoreCase(CHANGE)){
            clonedObject.New_or_Changed__c = CHANGED;
       }    
       clonedObject.Status__c=OPEN;
       clonedObject.Processed__c='';
       clonedObject.ErrorMsg__c='';
       clonedObject.Transfer_Time__c='';
       clonedObject.Transfer_Date__c='';
       clonedObject.SAP_Transfer__c = '';
       clonedObject.Archieved__c=false;
       clonedObject.Initial_Submitter__c='';
       clonedObject.Agreement_Number__c='';
       clonedObject.Lotus_Notes_Document_Id__c='';
       clonedObject.Initial_Submitter_Date__c=null;
       clonedObject.Submitted_to_Supplier_by__c='';
       clonedObject.Submitted_to_Supplier_Date__c=null;
       clonedObject.Supplier_1st_Action_by__c='';
       clonedObject.Supplier_1st_Action_Date__c=null;
       clonedObject.Final_Action_by__c='';
       clonedObject.Final_Action_by_Date__c=null;
       clonedObject.OwnerId = System.Userinfo.getUserId();
       
       return clonedObject;
    }
    /**  
        * @Name getRoundingNumber
        * @Purpose This method is fetch the fields from supplier profile for rounding the Request Rebate Amount.
        * @param String 
        * @return Integer
        * @Author  Chandrakant
        */   
    public static Integer getRoundingNumber(String suppProfileId)
    {
        List<Supplier_Profile__C> sp = [select Round_Final_Support_to__c from Supplier_Profile__C where  id =: suppProfileId];
        if(sp.size()>0&&sp[0].Round_Final_Support_to__c !=null)
        {
        Integer round = Integer.valueof(sp[0].Round_Final_Support_to__c);
        system.debug('-----------Round169-----------'+round );
          return round ;
        }
        else 
        {
        return 4;
        } 
    }
        /**  
        * @Name setStatus
        * @Purpose This method is used to set the correct status for cloned objects.
        * @param Price_Support__c
        * @return Price_Support__c
        * @Author  Deepak
        */ 
    public static Price_Support__c setStatus(Price_Support__c clonedObject){
        
        if(clonedObject.PriceChangesAutomaticallyApproved__c!=null && clonedObject.PriceChangesAutomaticallyApproved__c=='NO'){
               
               clonedObject.Status__c =AWAITING_SUPPLIER_APPROVAL;
               clonedObject.SAP_Transfer__c ='';
               System.debug('--------clonedObject Price Support Status-------'+clonedObject.Status__c);
       }else if(clonedObject.Support_Type__c==REBATE){
               clonedObject.Status__c = APPROVED;
               clonedObject.SAP_Transfer__c = OPEN;
       }else if(clonedObject.Support_Type__c==UPFRONT){
               System.debug('------- Set Status for Upfront ---------- ');
               clonedObject.Status__c = APPROVED;
       }
       
       return clonedObject;
    
    }
    
    public static Price_Support__c setStatusAfterRenew(Price_Support__c clonedObject){
        
        if(checkNexeoApprover(clonedObject.Nexeo_Group__c)){
               
               clonedObject.Status__c =AWAITING_SUPPLIER_APPROVAL;
               clonedObject.SAP_Transfer__c ='';
               System.debug('--------clonedObject Price Support setStatusAfterRenew-------'+clonedObject.Status__c);
       }else {
               clonedObject.Status__c =OPEN;
               clonedObject.SAP_Transfer__c ='';
       }
       
       return clonedObject;
    
    }
    
    public static List<Bracketed_Pricing__c> cloneBracketedPricing(List<Bracketed_Pricing__c> pricingList,String newPriceSupportId){
    
            Bracketed_Pricing__c pricingCloneObj = null;
            List<Bracketed_Pricing__c> clonedPricingList = new List<Bracketed_Pricing__c>();
            
            for(Bracketed_Pricing__c bracketedPrice:pricingList){
               
               System.debug('pricingCloneObj.Net Price----------- '+bracketedPrice.Net_Price__c);
                
               pricingCloneObj = bracketedPrice.clone(false,true);
               pricingCloneObj.Price_Support__c=newPriceSupportId;
               clonedPricingList.add(pricingCloneObj);            
            }
            
            return clonedPricingList;
    }
    
    public static List<Bracketed_Pricing__c> cloneBracketedPricing(List<Price_Support__c> clonedList){
        
        List<String> oldPriceSupportIds = new List<String>();
        Map<String,String> parentChildMapping = new Map<String,String>();
        List<Bracketed_Pricing__c> newPricingList = new List<Bracketed_Pricing__c>();
        Bracketed_Pricing__c pricingClonedObj = null;
        
        for(Price_Support__c clonedObj:clonedList){
            
            oldPriceSupportIds.add(clonedObj.Parent_Price_Support__c);
            parentChildMapping.put(clonedObj.Parent_Price_Support__c,clonedObj.Id);
        
        }
        
        System.debug('----------oldPriceSupportIds---------------'+oldPriceSupportIds);
        System.debug('----------parentChildMapping---------------'+parentChildMapping);
        
        List<Bracketed_Pricing__c> oldPricingList = [SELECT Id, Name,Net_Price__c, Price__c,Price_Support__c, Product_Min_Qty__c, X1st_Discount_Type__c, X1st_Discount__c, X2nd_Discount_Type__c, X2nd_Discount__c FROM Bracketed_Pricing__c  where Price_Support__r.Id IN : oldPriceSupportIds];
        
        if(oldPricingList!=null && !oldPricingList.isEmpty()){
            
            for(Bracketed_Pricing__c pricing:oldPricingList){
                
                pricingClonedObj = pricing.clone(false,true);
                pricingClonedObj.Price_Support__c = parentChildMapping.get(pricing.Price_Support__c);
                newPricingList.add(pricingClonedObj);
            }
        
        }
        
        return newPricingList;
    }
    
    public static void sendEmail(List<String> emailList,String message,String subject){
        
        System.debug('--------------------sendEmail ---------------------');
        if(emailList!=null && !emailList.isEmpty()){
            
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSubject(subject);
            mail.setHtmlBody(message);
            mail.setToAddresses(emailList);
            System.debug('--------------------setToAddresses ---------------------'+ emailList);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
        
        }
    
    }
    
    public static Map<String,Set<String>> getSupplierEmailSet(List<Price_Support__c> priceSupport){
            
        List<String> suppliergroupIds = new List<String>();
        Map<String,String> mapPriceSuppIdandSupGrpId = new Map<String,String>();
        Map<String,Set<String>> mapSupGrpIdandMailset = new Map<String,Set<String>>();
        Map<String,Set<String>> mapPriceSuppIdandMailset = new Map<String,Set<String>>();
        
        for (Integer i = 0; i < priceSupport.size(); i++) {
            mapPriceSuppIdandSupGrpId.put(priceSupport[i].Id,priceSupport[i].Supplier_Group__c);
            suppliergroupIds.add(priceSupport[i].Supplier_Group__c);
        }
    
        List<Supplier_Member__c> supplierMemberList = [SELECT Supplier_Member_Email__c,Supplier_Group__r.Id FROM Supplier_Member__c WHERE Supplier_Group__r.Id in :suppliergroupIds AND Send_Email__c =true ];
        List<Nexeo_Member__c> NexeoMemberList = [SELECT Nexeo_Member_Email__c,Supplier_Group__r.Id FROM Nexeo_Member__c WHERE Supplier_Group__r.Id in :suppliergroupIds AND Send_Email__c =true ];
        List<Supplier_Group__c> supplierGroupList = [SELECT Main_Approver_Email__c from  Supplier_Group__c where Id in :suppliergroupIds and Send_Email__c = true];
        
        for (Integer j = 0; j < suppliergroupIds.size(); j++) {
            
            
            if(!mapSupGrpIdandMailset.containskey(suppliergroupIds[j])){
                Set<String> supplierEmailSet = new Set<String>();
                for(Supplier_Member__c supplierMember : supplierMemberList ){
            
                    if(suppliergroupIds[j] == supplierMember.Supplier_Group__r.Id && supplierEmailSet!= null && !supplierEmailSet.contains(supplierMember.Supplier_Member_Email__c)){
                        supplierEmailSet.add(supplierMember.Supplier_Member_Email__c);
                    }
                }
                for(Nexeo_Member__c nexeoMember : NexeoMemberList ){
            
                    if(suppliergroupIds[j] == nexeoMember.Supplier_Group__r.Id && supplierEmailSet!= null && !supplierEmailSet.contains(nexeoMember.Nexeo_Member_Email__c)){
                        supplierEmailSet.add(nexeoMember.Nexeo_Member_Email__c);
                    }
                }
                for(Supplier_Group__c supplierMainApprover : supplierGroupList ){
            
                    if(suppliergroupIds[j] == supplierMainApprover.Id && supplierEmailSet!= null && !supplierEmailSet.contains(supplierMainApprover.Main_Approver_Email__c)){
                        supplierEmailSet.add(supplierMainApprover.Main_Approver_Email__c);
                    }
                }
                mapSupGrpIdandMailset.put(suppliergroupIds[j],supplierEmailSet);
            }
        }
        for (Integer k = 0; k < priceSupport.size(); k++) {
            mapPriceSuppIdandMailset.put(priceSupport[k].Id,mapSupGrpIdandMailset.get(mapPriceSuppIdandSupGrpId.get(priceSupport[k].Id)));
        }
            
        return mapPriceSuppIdandMailset;
    
    }
    
    public static Map<String,Set<String>> getNexeoEmailSet(List<Price_Support__c> priceSupport){
        
        
        List<String> nexeogroupIds = new List<String>();
        Map<String,String> mapPriceSuppIdandNexGrpId = new Map<String,String>();
        Map<String,Set<String>> mapNexGrpIdandMailset = new Map<String,Set<String>>();
        Map<String,Set<String>> mapPriceSuppIdandMailset = new Map<String,Set<String>>();
        
        for (Integer i = 0; i < priceSupport.size(); i++) {
            mapPriceSuppIdandNexGrpId.put(priceSupport[i].Id,priceSupport[i].Nexeo_Group__c);
            nexeogroupIds.add(priceSupport[i].Nexeo_Group__c);
        }
        
        List<Nexeo_Member__c> nexeoMemberList = [SELECT Id, Send_Email__c,Nexeo_Group__r.Id, Nexeo_Main_Approver__c,Nexeo_Member_Email__c FROM Nexeo_Member__c  where Send_Email__c = true AND Nexeo_Group__r.Id in :nexeogroupIds ];   
        List<Nexeo_Group__c> nexeoGroupList = [SELECT Id, Send_E_Mail__c,Main_Approver_Email__c FROM Nexeo_Group__c WHERE Id in :nexeoGroupIds and Send_E_Mail__c = true];
        
        for (Integer j = 0; j < nexeogroupIds.size(); j++) {
            
            if(!mapNexGrpIdandMailset.containskey(nexeogroupIds[j])){
                Set<String> nexeoEmailSet = new Set<String>();
                for(Nexeo_Member__c nexeoMember : nexeoMemberList ){
                
                    if(nexeogroupIds[j] == nexeoMember.Nexeo_Group__r.Id && nexeoEmailSet!= null && !nexeoEmailSet.contains(nexeoMember.Nexeo_Member_Email__c)){
                        nexeoEmailSet.add(nexeoMember.Nexeo_Member_Email__c);
                    }
                }
                for(Nexeo_Group__c nexeoMainApprover : nexeoGroupList ){
                
                    if(nexeogroupIds[j] == nexeoMainApprover.Id && nexeoEmailSet!= null && !nexeoEmailSet.contains(nexeoMainApprover.Main_Approver_Email__c)){
                        nexeoEmailSet.add(nexeoMainApprover.Main_Approver_Email__c);
                    }
                }
                mapNexGrpIdandMailset.put(nexeogroupIds[j],nexeoEmailSet);
            }
        }
        for (Integer k = 0; k < priceSupport.size(); k++) {
            mapPriceSuppIdandMailset.put(priceSupport[k].Id,mapNexGrpIdandMailset.get(mapPriceSuppIdandNexGrpId.get(priceSupport[k].Id)));
        }

        return mapPriceSuppIdandMailset;
    }
    
    
    public static boolean checkSupplierApprover(String supplierGroupId){
        
        //String supplierGroup = priceSupport.Supplier_Group__c;
        
        String currentUserId = System.Userinfo.getUserId();
        
        System.debug('----------Supplier Group-------------'+supplierGroupId);
        System.debug('----------currentUserId -------------'+currentUserId);
        
        if(supplierGroupId!=null){
         
                List<Supplier_Member__c> supplierMemberList = [SELECT Id, Approver__c, Member_ID__c, Send_Email__c, Supplier_Main_Approver__c, Supplier_Group__r.Id, Supplier_Group__r.Group_Name__c, Name__r.Id FROM Supplier_Member__c WHERE Supplier_Group__r.Id = :supplierGroupId AND Approver__c = True and Name__r.Id=:currentUserId];
                
                List<Nexeo_Member__c> nexeoSupplierMemberList = [SELECT Id, Approver__c, Send_Email__c, Name__r.Id, Supplier_Group__r.Id, Supplier_Group__r.Group_Name__c FROM Nexeo_Member__c WHERE Supplier_Group__r.Id = :supplierGroupId AND Approver__c = True and Name__r.Id=:currentUserId];
                
                List<Supplier_Group__c> supplierGroupList = [select Id,Main_Approver__c from    Supplier_Group__c where Id=:supplierGroupId and Main_Approver__c=:currentUserId];
                
                if(supplierMemberList!=null && !supplierMemberList.isEmpty()){
                    return true;
                } else if(nexeoSupplierMemberList!=null && !nexeoSupplierMemberList.isEmpty()){
                    return true;
                }else if(supplierGroupList!=null && !supplierGroupList.isEmpty()) {
                    return true;                
                }else{
                    return false;
                }
                            
                            
        }else{
            return false;
        }
        
     
     }
     
     public static boolean checkNexeoApprover(String nexeoGroupId){
     
        //String nexeoGroup = priceSupport.Nexeo_Group__c;
        String currentUserId = System.Userinfo.getUserId();
        
        System.debug('----------nexeoGroup Group-------------'+nexeoGroupId);
        System.debug('----------currentUserId -------------'+currentUserId);
        if(nexeoGroupId!=null){
         
                List<Nexeo_Member__c> nexeoMemberList = [SELECT Id, Approver__c,Nexeo_Main_Approver__c,Name__r.Id, Nexeo_Group__r.Id,Nexeo_Group__r.Main_Approver__r.Name,Nexeo_Group__r.Group_Name__c FROM Nexeo_Member__c where Approver__c  = True AND Nexeo_Group__r.Id = :nexeoGroupId and Name__r.Id=:currentUserId];
                
                List<Nexeo_Group__c> nexeoGroupList = [select Id,Main_Approver__c from Nexeo_Group__c where Id=:nexeoGroupId and Main_Approver__c=:currentUserId];
                
                if(nexeoGroupList!=null && !nexeoGroupList.isEmpty()){
                    return true;
                } else if(nexeoMemberList!=null && !nexeoMemberList.isEmpty()){
                    return true;
                }else{
                    return false;
                }
                            
        }else{
        
            return false;
        
        }
     }
     
     public static List<decimal> doRebateCalculation(Price_Support__c priceSupport){
        
        /*
        "Net Purchase Cost should be calculated as:
        Purchase Cost - 1st Discount - 2nd Discount + Freight Allowance + Other"
    
        "Requested Rebate Amount should be calculated as : 
        Net Support Cost (from Support Information Section) - Net Purchase Cost."
    
        "Net Support Cost should be calculated as follows :
        Net Suppprt Cose = Supplier Supported Price - (1st disount + Second discount)  - Packaging Allowance - Freight Allowance - Other Allowances"
        */
        
        System.debug('---------Rebate Calculation --------');
        
        decimal supplierSupportedPrice = nullCheck(priceSupport.Supplier_Supported_Price__c);
        decimal packagingAllowance = nullCheck(priceSupport.Packaging_Allowance__c);
        decimal freightAllowanceSelling = nullCheck(priceSupport.Freight_Allowance_Selling__c);
        decimal otherAllowances = nullCheck(priceSupport.Other_Allowances__c);
        decimal discountOneSell = nullCheck(priceSupport.X1st_Discount_Sell__c);
        decimal discountTwoSell = nullCheck(priceSupport.X2nd_Discount_Sell__c);
        String discountOneTypeSell = priceSupport.X1st_Discount_Type_Sell__c;
        String discountTwoTypeSell = priceSupport.X2nd_Discount_Type_Sell__c;
        String suppProfileId = priceSupport.Supplier_Profile_Id__c;
        System.debug('---------supplierSupportedPrice --------'+supplierSupportedPrice);
        System.debug('---------packagingAllowance --------'+packagingAllowance);
        
        
        decimal purchaseCost = nullCheck(priceSupport.Purchase_Cost__c);
        decimal freightAllowanceBuying = nullCheck(priceSupport.Freight_Allowance_Buying__c);
        decimal other = nullCheck(priceSupport.Other__c);
        decimal discountOneBuy = nullCheck(priceSupport.X1st_Discount_Buy__c);
        decimal discountTwoBuy = nullCheck(priceSupport.X2nd_Discount_Buy__c);
        String discountOneTypeBuy = priceSupport.X1st_Discount_Type_Buy__c;
        String discountTwoTypeBuy = priceSupport.X2nd_Discount_Type_Buy__c;
        Integer Round=getRoundingNumber(suppProfileId);
        
        decimal actualDiscountOneSell = 0.0;
        decimal actualDiscountTwoSell = 0.0;
        decimal actualDiscountOneBuy = 0.0;
        decimal actualDiscountTwoBuy = 0.0;
        
        decimal netPurchaseCost = 0.0;
        decimal netSupportCost = 0.0;
        decimal requestedRebateAmount = 0.0;
        
        if(discountOneTypeSell!=null && discountOneTypeSell.equalsIgnoreCase('%')){
            actualDiscountOneSell=supplierSupportedPrice*(discountOneSell/100);
        }else{
            actualDiscountOneSell = discountOneSell;
        }
        
        if(discountTwoTypeSell!=null && discountTwoTypeSell.equalsIgnoreCase('%')){
            actualDiscountTwoSell=supplierSupportedPrice*(discountTwoSell/100);
        }else{
            actualDiscountTwoSell = discountTwoSell;
        }
        
        
        if(discountOneTypeBuy!=null && discountOneTypeBuy.equalsIgnoreCase('%')){
            actualDiscountOneBuy=purchaseCost*(discountOneBuy/100);
        }else{
            actualDiscountOneBuy = discountOneBuy;
        }
        
        if(discountTwoTypeBuy!=null && discountTwoTypeBuy.equalsIgnoreCase('%')){
            actualDiscountTwoBuy=purchaseCost*(discountTwoBuy/100);
        }else{
            actualDiscountTwoBuy = discountTwoBuy;
        }
        
         netPurchaseCost = purchaseCost-actualDiscountOneBuy-actualDiscountTwoBuy+freightAllowanceBuying+other;
         netSupportCost = supplierSupportedPrice - (actualDiscountOneSell+actualDiscountTwoSell) - packagingAllowance - freightAllowanceSelling - otherAllowances;
         requestedRebateAmount = nullCheck(netPurchaseCost) - nullCheck(netSupportCost);
         System.debug('----------Round -------------'+round);
         if(round !=null)
         {
         requestedRebateAmount = requestedRebateAmount.setscale(round);
         }
         else
         {
         requestedRebateAmount = nullCheck(netPurchaseCost) - nullCheck(netSupportCost);
         }
         List<decimal> calculatedList = new List<decimal>();
         
         calculatedList.add(netSupportCost);
         calculatedList.add(netPurchaseCost);
         calculatedList.add(requestedRebateAmount);
         
         System.debug('---------calculatedList --------'+calculatedList);
         
         return calculatedList;
         
    }
    
    public static List<Bracketed_Pricing__c> doUpfrontCalculation(List<Bracketed_Pricing__c> pricingList){
            
            /*"Net Price (For Support Type = Upfronts) should be calculated as :
            (Price - 1st Dicount) - 2nd Discount"*/
            
            System.debug('---------Upfront Calculation --------');
            System.debug('-------pricingList----------'+pricingList.size());
            
            List<Bracketed_Pricing__c> newPricingList = new List<Bracketed_Pricing__c>();
            
            if(pricingList!=null && !pricingList.isEmpty()){
                
                double pricingDiscountOne = 0.0;
                String pricingDiscountOneType = '';
                double pricingDiscountTwo = 0.0;
                String pricingDiscountTwoType = '';
                double pricingPrice = 0.0;
                double actualDiscountOne = 0.0;
                double actualDiscountTwo = 0.0;
                
                for(Bracketed_Pricing__c pricingObj:pricingList){
                    
                    pricingDiscountOne = nullCheck(pricingObj.X1st_Discount__c);
                    pricingDiscountTwo = nullCheck(pricingObj.X2nd_Discount__c);
                    pricingPrice = nullCheck(pricingObj.Price__c);
                                    
                    pricingDiscountOneType = pricingObj.X1st_Discount_Type__c;
                    
                    pricingDiscountTwoType = pricingObj.X2nd_Discount_Type__c;
                    
                    if(pricingDiscountOneType!=null && pricingDiscountOneType.equalsIgnoreCase('%')){
                        actualDiscountOne=pricingPrice*(pricingDiscountOne/100);
                    }else{
                        actualDiscountOne = pricingDiscountOne;
                    }
                    
                    if(pricingDiscountTwoType!=null && pricingDiscountTwoType.equalsIgnoreCase('%')){
                        actualDiscountTwo=pricingPrice*(pricingDiscountTwo/100);
                    }else{
                        actualDiscountTwo = pricingDiscountTwo;
                    }
                    
                    pricingObj.Net_Price__c = pricingPrice-actualDiscountOne-actualDiscountTwo;
                    
                    newPricingList.add(pricingObj);
                
                }
                           
            }
            System.debug('-------newPricingList----------'+newPricingList.size());
            return newPricingList;
    
    }
    
    
    private static decimal nullCheck(decimal val){
        if(val==null){
            return 0.0;
        }else{
            return val;
        }
    }
    
    public static List<String> checkDuplicatePriceSupport(Price_Support__c priceObj){
        
        Date effectiveDate = priceObj.Effective_Date__c;
        Date expirationDate= priceObj.Expiration_Date__c;
        List<String> duplicates= new List<String>();
        List<Price_Support__c> priceSupports = null;
        String soql = 'select id,Region_code__c,name,Agreement_Number__c from Price_Support__c where (status__c=\'Approved\' OR status__c =\'Awaiting Nexeo Approval\' OR status__c =\'Awaiting Supplier Approval\' OR status__c =\'Conditionally Approved\' OR status__c =\'Rejected by Supplier\')';
        
        if (priceObj.Supplier_Profile_ID__c!=null)
            soql += ' and Supplier_Profile_ID__c = \''+priceObj.Supplier_Profile_ID__c+'\'';
        if (priceObj.Material_Selling__c!=null && priceObj.Support_Type__c==PriceSupportUtil.REBATE)
            soql += ' and Material_Selling__c = \''+priceObj.Material_Selling__c+'\'';
        if (priceObj.Material_Buying__c!=null && priceObj.Support_Type__c==PriceSupportUtil.REBATE)
            soql += ' and Material_Buying__c = \''+priceObj.Material_Buying__c+'\'';
        if (priceObj.Customer_Type__c!=null)
            soql += ' and Customer_Type__c = \''+priceObj.Customer_Type__c+'\'';
        if (priceObj.Material_Buying__c!=null && priceObj.Support_Type__c==PriceSupportUtil.UPFRONT)
            soql += ' and Material_Buying__c = \''+priceObj.Material_Buying__c+'\'';
        if (priceObj.Customer_Name__c!=null)
            soql += ' and   Customer_Name__c = \''+priceObj.Customer_Name__c+'\'';
        if (priceObj.Sales_Group_Desc__c!=null && priceObj.Sales_Group_Desc__c!='')
            soql += ' and   Sales_Group_Desc__c = \''+priceObj.Sales_Group_Desc__c+'\'';
        if (priceObj.Support_Type__c!=null)
            soql += ' and Support_Type__c = \''+priceObj.Support_Type__c+'\'';
        if (priceObj.Sales_Organisation__c!=null)
            soql += ' and   Sales_Organisation__c = \''+priceObj.Sales_Organisation__c+'\'';
        if (priceObj.Purchasing_Organization__c!=null)
            soql += ' and Purchasing_Organization__c = \''+priceObj.Purchasing_Organization__c+'\'';
        if (priceObj.Order_Type__c!=null)
            soql += ' and   Order_Type__c = \''+priceObj.Order_Type__c+'\'';
        if (priceObj.Division_Name__c!=null)
            soql += ' and Division_Name__c = \''+priceObj.Division_Name__c+'\'';
        if (priceObj.Effective_Date__c!=null)
            soql += ' and ((Expiration_Date__c = null  or Expiration_Date__c > :effectiveDate) and (Effective_Date__c < :expirationDate))';
        
        
        
        System.debug('----------soql-------------------'+soql);
        
        try {
            priceSupports = Database.query(soql + ' order by Effective_Date__c asc' );
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        if(priceSupports!=null && !priceSupports.isEmpty()){
            system.debug('********'+priceSupports.size());
            
            system.debug('********'+priceObj.Region_code__c);
            for(Price_Support__c support:priceSupports){
                system.debug('********'+support.Region_code__c);
                if(support.Region_code__c == priceObj.Region_code__c || priceObj.Region_code__c == 'ALL' || support.Region_code__c == 'ALL')
                    duplicates.add(support.Agreement_Number__c);
            }
            
        }
        System.debug('----------duplicates-------------------'+duplicates);
        return duplicates;      
    }
    
    
   /**Check for duplicate price support during Mass Change**/ 
   
    public static List<String> checkDuplicatePriceSupportforMassChange(Price_Support__c priceObj){
        
        Date effectiveDate = priceObj.Effective_Date__c;
        Date expirationDate= priceObj.Expiration_Date__c;
        List<String> duplicatesPS= new List<String>();
        String masschangerecordid= priceObj.Parent_Price_Support__c;      
        List<Price_Support__c> priceSupports = null;
        String soql = 'select id, Region_Code__c, Parent_Price_Support__c,name,Agreement_Number__c, Customer_Type__c from Price_Support__c where (status__c=\'Approved\' OR status__c =\'Awaiting Nexeo Approval\' OR status__c =\'Awaiting Supplier Approval\' OR status__c =\'Conditionally Approved\' OR status__c =\'Rejected by Supplier\')';
        
        if (priceObj.Supplier_Profile_ID__c!=null)
            soql += ' and Supplier_Profile_ID__c = \''+priceObj.Supplier_Profile_ID__c+'\'';
        if (priceObj.Material_Selling__c!=null && priceObj.Support_Type__c==PriceSupportUtil.REBATE)
            soql += ' and Material_Selling__c = \''+priceObj.Material_Selling__c+'\'';
        if (priceObj.Material_Buying__c!=null && priceObj.Support_Type__c==PriceSupportUtil.REBATE)
            soql += ' and Material_Buying__c = \''+priceObj.Material_Buying__c+'\'';
        if (priceObj.Material_Buying__c!=null && priceObj.Support_Type__c==PriceSupportUtil.UPFRONT)
            soql += ' and Material_Buying__c = \''+priceObj.Material_Buying__c+'\'';
        if (priceObj.Customer_Name__c!=null)
            soql += ' and Customer_Name__c = \''+priceObj.Customer_Name__c+'\'';
        if (priceObj.Customer_Type__c!=null)
            soql += ' and Customer_Type__c = \''+priceObj.Customer_Type__c+'\'';
        if (priceObj.Sales_Group_Desc__c!=null && priceObj.Sales_Group_Desc__c!='')
            soql += ' and   Sales_Group_Desc__c = \''+priceObj.Sales_Group_Desc__c+'\'';
        if (priceObj.Support_Type__c!=null)
            soql += ' and Support_Type__c = \''+priceObj.Support_Type__c+'\'';
        if (priceObj.Sales_Organisation__c!=null)
            soql += ' and   Sales_Organisation__c = \''+priceObj.Sales_Organisation__c+'\'';
        if (priceObj.Purchasing_Organization__c!=null)
            soql += ' and Purchasing_Organization__c = \''+priceObj.Purchasing_Organization__c+'\'';
        if (priceObj.Order_Type__c!=null)
            soql += ' and   Order_Type__c = \''+priceObj.Order_Type__c+'\'';
        if (priceObj.Division_Name__c!=null)
            soql += ' and Division_Name__c = \''+priceObj.Division_Name__c+'\'';
        if (priceObj.Effective_Date__c!=null)
            soql += ' and ((Expiration_Date__c = null  or Expiration_Date__c > :effectiveDate) and (Effective_Date__c < :expirationDate))';
        if (priceObj.Parent_Price_Support__c != null)
            soql += ' and Id != \''+priceObj.Parent_Price_Support__c+'\'';
        
        
        System.debug('----------soql-------------------'+soql);
        
        try {
            priceSupports = Database.query(soql + ' order by Effective_Date__c asc' );
        } catch (Exception e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
        }
        if(priceSupports!=null && !priceSupports.isEmpty()){
            
            for(Price_Support__c support:priceSupports){
                if(support.Region_code__c == priceObj.Region_code__c || priceObj.Region_code__c == 'ALL' || support.Region_code__c == 'ALL')
                    duplicatesPS.add(support.Agreement_Number__c);
            }
            
        }
        System.debug('----------duplicates-------------------'+duplicatesPS);
        return duplicatesPS;      
    }

}