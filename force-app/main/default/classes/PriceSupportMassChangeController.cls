/**  
* @Name PriceSupportMassChangeController
* @Purpose This is a controller class used for peforming Mass Changes on Price Supports .
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class PriceSupportMassChangeController {
    
    public double supplierSupportedPriceChange{get;set;}
    public String supportedPriceType{get;set;}
    public double increaseRebateAmountBy{get;set;}
    public double purchaseCostChange{get;set;}
    public String purchaseCostType{get;set;}
    public String comments{get;set;}
    public Date effectiveDate{get;set;}
    public Date expirationDate{get;set;}
    //used for handling mass renew with price change
    public boolean renewFlag{get;set;}
    private List<String> selectFields = new List<String>();
    private final String objectName = 'Price_Support__c';
    
    String selectedRecords  =null;
    List<String> selectedPriceSupports = null;
    List<String> SuppprofileIds=new List<String>();
    Map<String,String> SuppprofileIdRoundno=new Map<String,String>();
    List<Price_Support_Ids__c> PSIds = new List<Price_Support_Ids__c>();
    
    /**  
    * @Name PriceSupportMassChangeController
    * @Purpose This is the constructor for PriceSupportMassChangeController.Used to distinguish btwn Mass change and Mass renew with price change
    * @param 
    * @return 
    * @Author  Deepak
    */
    public PriceSupportMassChangeController(){
        System.debug('@@@@inside constructor');
        supplierSupportedPriceChange = 0;
        increaseRebateAmountBy = 0;
        purchaseCostChange = 0;
        supportedPriceType ='$';
        purchaseCostType='$';
        selectedRecords = Apexpages.currentPage().getParameters().get('selectedRecords');
        System.debug('!!!!!!selectedRecords '+selectedRecords);
        PSIds = [Select Ids__c from Price_Support_Ids__c where Id =: selectedRecords ];
        String renew = Apexpages.currentPage().getParameters().get('renew');
        if(renew!=null && renew.equalsIgnoreCase('true')){
            System.debug('--------Mass Renew with Price Change------------------');
            renewFlag = true;
        }else{
            System.debug('--------Mass Change------------------');
            renewFlag = false;
        }
        System.debug('Selected Price Supports-------'+selectedRecords);
        
        System.debug('@@@ PSIds-------'+PSIds);
        
        if(!renewFlag){
            if(PSIds.size()>0){
            
                selectedPriceSupports = PSIds[0].Ids__c.split(',');
                
            }
        }
        else{
            if(selectedRecords!=null){
            
               selectedPriceSupports = selectedRecords.split(',');
            }
        }   
        System.debug('@@@@ Selected Price Supports-------'+selectedPriceSupports );
    
    }
    /**  
    * @Name customSave
    * @Purpose This is used perform the Mass change on selected records.
    * @param 
    * @return 
    * @Author  Deepak
    */
    public void customSave(){
        
        /*
        "Net Purchase Cost should be calculated as:
        Purchase Cost - 1st Discount - 2nd Discount + Freight Allowance + Other"
    
        "Requested Rebate Amount should be calculated as : 
        Net Support Cost (from Support Information Section) - Net Purchase Cost."
    
        "Net Price (For Support Type = Upfronts) should be calculated as :
        (Price - 1st Dicount) - 2nd Discount"
    
        "Net Support Cost should be calculated as follows :
        Net Suppprt Cose = Supplier Supported Price - (1st disount + Second discount)  - Packaging Allowance - Freight Allowance - Other Allowances"
        */
        system.debug('entering custom save');
        delete PSIds; 
        double actualDiscountOne = 0.0;
        double actualDiscountTwo = 0.0;
        double actualDiscountOneSelling = 0.0;
        double actualDiscountTwoSelling = 0.0;
        List<Price_Support__c> clonedPriceSupports =null;
        System.debug('@@@@1 Selected Price Supports-------'+selectedPriceSupports);
        System.debug('@@@@2 PriceSupportUtil.CHANGE-------'+PriceSupportUtil.CHANGE);
        System.debug('@@@@3 expirationDate-------'+expirationDate);
        
        if(!renewFlag){
             if(selectedPriceSupports!=null){
             System.debug('@@@@ - renew flag false selectedPriceSupports not null-------');
            clonedPriceSupports = PriceSupportUtil.clonePriceSupports(objectName, selectedPriceSupports,PriceSupportUtil.CHANGE,expirationDate,effectiveDate);
            }
        }else{
            if(selectedPriceSupports!=null){
            System.debug('@@@@ - renew flag trueselectedPriceSupports not null-------');
            clonedPriceSupports = PriceSupportUtil.clonePriceSupports(objectName, selectedPriceSupports,PriceSupportUtil.RENEW,expirationDate,null);
             }
        }
        System.debug('@@@@ cloned PS-------'+clonedPriceSupports);
        List<Price_Support__c> updatedCloneList = new List<Price_Support__c>();
        List<Price_Support__c> updatedCloneList1 = new List<Price_Support__c>();
        if(clonedPriceSupports !=null){
        for(Price_Support__c priceObj1 : clonedPriceSupports){
        SuppprofileIds.add(priceObj1.Supplier_Profile_ID__c);
        }
        }
        System.debug('-----------PricesupportsuppprofileId-------'+SuppprofileIds);
        List<Supplier_Profile__c> SuppprofileeObjList =[select Round_Final_Support_to__c from Supplier_Profile__c where Id in:SuppprofileIds];
        
         for (Integer k = 0; k < SuppprofileeObjList.size(); k++) {
            SuppprofileIdRoundno.put(SuppprofileeObjList[k].id,SuppprofileeObjList[k].Round_Final_Support_to__c);
        }
        System.debug('-----------PricesupportsuppprofileIdMap-------'+SuppprofileIdRoundno);
        
        if(clonedPriceSupports !=null){
        for(Price_Support__c priceObj : clonedPriceSupports){
            
            if(priceObj.Support_Type__c==PriceSupportUtil.REBATE){
                
                if(priceObj.Flat_or_Purchased__c==PriceSupportUtil.FLAT && priceObj.Rebate_Editable__c==true){
                    
                    System.debug('----------FLAT Price Support------');
                    priceObj.Requested_Rebate_Amount__c = nullCheck(priceObj.Requested_Rebate_Amount__c) + nullCheck(increaseRebateAmountBy);
                
                }else{
                    
                        System.debug('------old Purchase Cost-------'+priceObj.Purchase_Cost__c);
                        
                        System.debug('------Purchase cost Type-------'+purchaseCostType);
                        
                        System.debug('-----purchaseCostChange-------'+purchaseCostChange);
                        
                        if(purchaseCostType.equalsIgnoreCase('$')){
                            priceObj.Purchase_Cost__c = nullCheck(priceObj.Purchase_Cost__c) + nullCheck(purchaseCostChange);
                        }else if(purchaseCostType.equalsIgnoreCase('%')){
                            priceObj.Purchase_Cost__c = nullCheck(priceObj.Purchase_Cost__c)+(nullCheck(priceObj.Purchase_Cost__c)*nullCheck(purchaseCostChange));
                        }
                        
                        System.debug('------Modified Purchase Cost-------'+priceObj.Purchase_Cost__c);
                        
                        System.debug('------old Supplier_Supported_Price__c-------'+priceObj.Supplier_Supported_Price__c);
                        
                        System.debug('------supportedPriceType-------'+supportedPriceType);
                        
                        System.debug('-----supplierSupportedPriceChange-------'+supplierSupportedPriceChange);
                        
                        if(supportedPriceType.equalsIgnoreCase('$')){
                            priceObj.Supplier_Supported_Price__c = nullCheck(priceObj.Supplier_Supported_Price__c) + nullCheck(supplierSupportedPriceChange);
                        }else if(supportedPriceType.equalsIgnoreCase('%')){
                            priceObj.Supplier_Supported_Price__c = nullCheck(priceObj.Supplier_Supported_Price__c)+(nullCheck(priceObj.Supplier_Supported_Price__c)*nullCheck(supplierSupportedPriceChange));
                        }
                        
                        System.debug('------Modified supportedPrice-------'+priceObj.Supplier_Supported_Price__c);
                        
                        if(priceObj.X1st_Discount_Type_Buy__c!=null && priceObj.X1st_Discount_Type_Buy__c.equalsIgnoreCase('%')){
                            actualDiscountOne=priceObj.Purchase_Cost__c*(nullCheck(priceObj.X1st_Discount_Buy__c)/100);
                        }else{
                            actualDiscountOne = priceObj.X1st_Discount_Buy__c;
                        }
                        
                        if(priceObj.X2nd_Discount_Type_Buy__c!=null && priceObj.X2nd_Discount_Type_Buy__c.equalsIgnoreCase('%')){
                            actualDiscountTwo=priceObj.Purchase_Cost__c*(nullCheck(priceObj.X2nd_Discount_Buy__c)/100);
                        }else{
                            actualDiscountTwo = priceObj.X2nd_Discount_Buy__c;
                        }
                        
                        
                       if(priceObj.X1st_Discount_Type_Sell__c!=null && priceObj.X1st_Discount_Type_Sell__c.equalsIgnoreCase('%')){
                            actualDiscountOneSelling=priceObj.Supplier_Supported_Price__c*(nullCheck(priceObj.X1st_Discount_Sell__c)/100);
                        }else{
                            actualDiscountOneSelling = priceObj.X1st_Discount_Sell__c;
                        }
                        
                        if(priceObj.X2nd_Discount_Type_Sell__c!=null && priceObj.X2nd_Discount_Type_Sell__c.equalsIgnoreCase('%')){
                            actualDiscountTwoSelling=priceObj.Supplier_Supported_Price__c*(nullCheck(priceObj.X2nd_Discount_Sell__c)/100);
                        }else{
                            actualDiscountTwoSelling = priceObj.X2nd_Discount_Sell__c;
                        }
                        
                        priceObj.Net_Purchase_Cost__c = nullCheck(priceObj.Purchase_Cost__c)-nullCheck(actualDiscountOne)-nullCheck(actualDiscountTwo)+nullCheck(priceObj.Freight_Allowance_Buying__c)+nullCheck(priceObj.Other__c);
                        
                        String  Roundsupport1=nullchecknew(SuppprofileIdRoundno.get(priceObj.Supplier_Profile_ID__c));
                        Integer Roundsupport2=Integer.valueof(Roundsupport1.trim());
                        system.debug('--------------Roundsupport2----------'+Roundsupport1);
                        priceObj.Net_Support_Cost__c = nullCheck(priceObj.Supplier_Supported_Price__c) - (nullCheck(actualDiscountOneSelling)+nullCheck(actualDiscountTwoSelling)) - nullCheck(priceObj.Packaging_Allowance__c) - nullCheck(priceObj.Freight_Allowance_Selling__c) - nullCheck(priceObj.Other_Allowances__c);
                        
                        System.debug('----------Net purchase Cost------'+priceObj.Net_Purchase_Cost__c);
                        System.debug('----------Net support Cost------'+priceObj.Net_Support_Cost__c);
                       
                        priceObj.Requested_Rebate_Amount__c = (priceObj.Net_Purchase_Cost__c - priceObj.Net_Support_Cost__c).setscale(Roundsupport2);
                       
                        System.debug('----------Requested_Rebate_Amount__c------'+priceObj.Requested_Rebate_Amount__c);
                }
                
                
            }/*else if(priceObj.Support_Type__c==PriceSupportUtil.UPFRONT){
                
                System.debug('------old Purchase Cost-------'+priceObj.Purchase_Cost__c);
                
                System.debug('------Purchase cost Type-------'+purchaseCostType);
                
                System.debug('-----purchaseCostChange-------'+purchaseCostChange);
                
                if(purchaseCostType.equalsIgnoreCase('$')){
                    priceObj.Purchase_Cost__c = nullCheck(priceObj.Purchase_Cost__c) + nullCheck(purchaseCostChange);
                }else if(purchaseCostType.equalsIgnoreCase('%')){
                    priceObj.Purchase_Cost__c = nullCheck(priceObj.Purchase_Cost__c)+(nullCheck(priceObj.Purchase_Cost__c)*nullCheck(purchaseCostChange));
                }
                
                System.debug('------Modified Purchase Cost-------'+priceObj.Purchase_Cost__c);
                
                
            }*/
            if(comments!=null && !comments.equals('')){
               // priceObj.Comments__c = System.now()+' '+comments +'\n' + nullCheck(priceObj.Comments__c);
                priceObj.Comments__c = comments +'\n' + nullCheck(priceObj.Comments__c);
            }
            //Setting the default value of review date to 9999/12/31 as per the request from Business users.
            //For Mass changed and Mass renew with price changed records
            //Salesforce max limit is 4000 so setting that.
             //priceObj.Review_Date__c = date.newInstance(4000, 12, 31);
            
            if(validate(priceObj)){
                System.debug('------Agreement Number ---------'+priceObj.Agreement_Number__c);
                updatedCloneList.add(priceObj);
               System.debug('------updatedCloneList0 ---------'+updatedCloneList.size());
            }
            
        }
        }
        System.debug('------updatedCloneList1 ---------'+updatedCloneList.size());
        Map<price_support__c,boolean> PSstatus1=validate1(updatedCloneList);
        system.debug('---PSstatus1-----'+PSstatus1);
        for(Price_support__c psupdated:updatedCloneList){
        boolean statusps1=PSstatus1.get(psupdated);
        if(statusps1==true){
        updatedCloneList1.add(psupdated);
        }
        }
        system.debug('----updatedCloneList1-----'+updatedCloneList1.size());
        insert updatedCloneList1 ;
        
        List<Bracketed_Pricing__c> clonedBracketedPricing = PriceSupportUtil.cloneBracketedPricing(updatedCloneList1);
        
        //Added as per Charlotte. Purchase Cost for Upfront means all the 'Price' in bracketed pricing
                
        List<Bracketed_Pricing__c> updatedClonedBracketedPricing = new List<Bracketed_Pricing__c>();
        
        for(Bracketed_Pricing__c pricingObj:clonedBracketedPricing){
                
                                
                if(purchaseCostType.equalsIgnoreCase('$')){
                    pricingObj.Price__c = nullCheck(pricingObj.Price__c) + nullCheck(purchaseCostChange);
                }else if(purchaseCostType.equalsIgnoreCase('%')){
                    pricingObj.Price__c = nullCheck(pricingObj.Price__c) +(nullCheck(pricingObj.Price__c)*nullCheck(purchaseCostChange));
                }
                
                updatedClonedBracketedPricing.add(pricingObj);
        }
        
        List<Bracketed_Pricing__c> newUpdatedClonedBracketedPricing = PriceSupportUtil.doUpfrontCalculation(updatedClonedBracketedPricing);
        system.debug('Evaluate insert: ' + (newUpdatedClonedBracketedPricing!=null && !newUpdatedClonedBracketedPricing.isEmpty()));
        system.debug('newUpdatedClonedBracketedPricing does not equal null: ' + (newUpdatedClonedBracketedPricing!=null));
        system.debug('newUpdatedClonedBracketedPricing is not empty: ' + !newUpdatedClonedBracketedPricing.isEmpty());
        
        if(newUpdatedClonedBracketedPricing!=null && !newUpdatedClonedBracketedPricing.isEmpty()){
            system.debug('inserting records');
            insert newUpdatedClonedBracketedPricing;
            
        }
    }
    
   @TestVisible private double nullCheck(decimal val){
        if(val==null){
            return 0.0;
        }else{
            return val;
        }
    }
   @TestVisible private String nullCheck(String val){
        if(val==null){
            return '';
        }else{
            return val;
        }
    }
   @TestVisible private String nullChecknew(String val){
        if(val==null){
            return '4';
        }else{
            return val;
        }
    }
    
    /**  
    * @Name validate
    * @Purpose This is used to perform validation on Prices after Mass change.
    * @param 
    * @return 
    * @Author  Deepak
    */
    
   @TestVisible private boolean validate(Price_Support__c priceObj){
        
        
        boolean status = true;
        
      /**  List <String> duplicates = PriceSupportUtil.checkDuplicatePriceSupportforMassChange(priceObj);
        if(duplicates!=null && !duplicates.isEmpty()){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Support # '+priceObj.Support_ID__c + 'is skipped Duplicate Support Ids '+duplicates +' found.'));
           status= false;
        }    **/
        
        if(status && priceObj.Support_Type__c=='Rebate'){
            if(priceObj.Flat_or_Purchased__c==PriceSupportUtil.PURCHASED){
                if(priceObj.Net_Support_Cost__c==null||priceObj.Net_Support_Cost__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceObj.Support_ID__c + 'is skipped as net support cost is zero or less.'));
                    status= false;
                }else if(priceObj.Net_Purchase_Cost__c==null || priceObj.Net_Purchase_Cost__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceObj.Support_ID__c + 'is skipped as net purchase cost is zero or less.'));
                    status= false;
                }else if(priceObj.Requested_Rebate_Amount__c==null || priceObj.Requested_Rebate_Amount__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceObj.Support_ID__c + 'is skipped as requested rebate amount is zero or less.'));
                    status= false;
                }
                If(priceObj.Customer_Soldto__c==null && priceObj.Customer_Type__c=='PY-Payer'){
                   ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceObj.Support_ID__c + 'is skipped because this record cannot be submitted for approval and sent to SAP for Transfer as the Sold to Customer Information is missing. Please get this corrected before Submitting the record for Approval.'));
                   status= false;
                }
                  
            }else{
                if(priceObj.Requested_Rebate_Amount__c==null || priceObj.Requested_Rebate_Amount__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceObj.Support_ID__c + 'is skipped as requested rebate amount is zero or less.'));
                    status= false;
                }
            }
                
        }
        
        return status;
    
    }
 public static Map<Price_support__c,boolean>  validate1(List<Price_Support__c> priceObjs){
        boolean status = true;
        List<String> duplicates=new List<String>();
        Map<price_support__c,List<String>> duplicates1 = checkDuplicatePriceSupportforMassChangeone(priceObjs);
        Map<price_support__c,Boolean>  PSstatus=new Map<price_support__c,Boolean >();
        system.debug('-----duplicates1 --------'+duplicates1 );
        for(Price_support__C ps2:priceObjs){
        duplicates =duplicates1.get(ps2);
         system.debug('---duplicates -----'+duplicates );
        if(duplicates!=null && !duplicates.isEmpty()){
           ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Support # '+ps2.Support_ID__c+' is skipped Duplicate Support Ids '+duplicates +' found.'));
           status= false;
           }
          else{
         status=true;
        }
        PSstatus.put(ps2,status);
        system.debug('-----PSstatus-----'+PSstatus);
        }    
      return  PSstatus; 
}
public static Map<price_support__c,List<String>> checkDuplicatePriceSupportforMassChangeone(List<Price_Support__c> priceObjs){

                   
    Map<price_support__c, List<String>> duplicatePSMap = new Map<price_support__c,List<String>>();
        List<String> keys = new List<String>();
        List<String> keys1= new List<String>();
        for(price_support__c ps:priceObjs){
        
         keys1.add(ps.Supplier_Profile_ID__c+ps.Flat_or_Purchased__c+ps.Material_Buying__c);
         keys.add(ps.Customer_Name__c+ps.Support_Type__c+ps.Order_Type__c+ps.Purchasing_Organization__c+ps.Division_Name__c);
         
         system.debug('---Keys----'+keys );
         }
         
         /** Changes by Matt 5/10 **/
         Map<string, List<Price_Support__c>> supports = new Map<String, List<Price_Support__c>>();
         for(Price_Support__c ps:[select id,Parent_Price_Support__c,Key_Field__c ,Key_Field1__c,Expiration_Date__c,Supplier_Profile_ID__c,Effective_Date__c,Division_Name__c,Order_Type__c,Purchasing_Organization__c,Support_Type__c ,Sales_Group_Desc__c,Customer_Name__c,Sales_Organisation__c,Material_Buying__c,name,Agreement_Number__c,Material_Selling__c,status__c from 
                                           Price_Support__c where (status__c='Approved' OR status__c ='Awaiting Nexeo Approval' OR status__c ='Awaiting Supplier Approval' OR status__c ='Conditionally Approved' OR 
                                           status__c ='Rejected by Supplier') AND Key_Field__c IN :keys AND Key_Field1__c IN :keys1  AND Archieved__c !=True])
         {
           if(supports.containskey(ps.key_field__c + ps.key_field1__c))
             supports.get(ps.key_field__c + ps.key_field1__c).add(ps);
           else
             supports.put((ps.key_field__c + ps.key_field1__c), new List<Price_Support__c>{ps});
         }
        system.debug('----supports----'+supports);
        
        For(Price_Support__c priceObj:priceObjs){
          List<String> sLIst = new List<String>();
          Date effectiveDate = priceObj.Effective_Date__c;
          system.debug('----effectiveDate -'+effectiveDate );
          system.debug('----effectiveDate1 -'+priceObj.Effective_Date__c);
          
         if(supports.containskey(priceObj.Customer_Name__c+priceObj.Support_Type__c+priceObj.Order_Type__c+priceObj.Purchasing_Organization__c+priceObj.Division_Name__c        +priceObj.Supplier_Profile_ID__c+priceObj.Flat_or_Purchased__c+priceObj.Material_Buying__c))
         for(Price_Support__c ps2:supports.get(priceObj.Customer_Name__c+priceObj.Support_Type__c+priceObj.Order_Type__c+priceObj.Purchasing_Organization__c+priceObj.Division_Name__c        +priceObj.Supplier_Profile_ID__c+priceObj.Flat_or_Purchased__c+priceObj.Material_Buying__c))
        {
        
        /** End Changes by Matt 5/10 **/
        Boolean addthis = true;
        
        if (priceObj.Supplier_Profile_ID__c!=null)
          if(ps2.Supplier_Profile_id__c != priceObj.Supplier_Profile_Id__c)
             addthis = false;
        if (priceObj.Material_Selling__c!=null && priceObj.Support_Type__c==PriceSupportUtil.REBATE )
          if(ps2.Material_Selling__c != priceObj.Material_Selling__c)
             addthis = false;
          
        if (priceObj.Material_Buying__c!=null && priceObj.Support_Type__c==PriceSupportUtil.REBATE )
          if(ps2.Material_Buying__c != priceObj.Material_Buying__c)
             addthis = false;
        if (priceObj.Material_Buying__c!=null && priceObj.Support_Type__c==PriceSupportUtil.UPFRONT )
          if(ps2.Material_Buying__c != priceObj.Material_Buying__c)
             addthis = false;
        if (priceObj.Customer_Name__c!=null)
          if(ps2.Customer_Name__c != priceObj.Customer_Name__c)
             addthis = false;
        if (priceObj.Sales_Group_Desc__c != null &&  priceObj.Sales_Group_Desc__c!='')
          if(ps2.Sales_Group_Desc__c != priceObj.Sales_Group_Desc__c)
             addthis = false;
        if (priceObj.Support_Type__c != null)
          if(ps2.Support_Type__c != priceObj.Support_Type__c)
             addthis = false;
        if (priceObj.Sales_Organisation__c!=null)
          if(ps2.Sales_Organisation__c != priceObj.Sales_Organisation__c)
             addthis = false;
        if (priceObj.Purchasing_Organization__c!=null)
          if(ps2.Purchasing_Organization__c != priceObj.Purchasing_Organization__c)
             addthis = false;
        if (priceObj.Order_Type__c!=null)
          if(ps2.Order_Type__c != priceObj.Order_Type__c)
             addthis = false;
        if (priceObj.Division_Name__c!=null)
          if(ps2.Division_Name__c != priceObj.Division_Name__c)
             addthis = false;            
        if (priceObj.Effective_Date__c!=null)
          if(ps2.Expiration_Date__c <= priceObj.effective_Date__c || ps2.Effective_Date__c > priceObj.expiration_date__c)
             addthis = false;
        if (priceObj.Parent_Price_Support__c != null)
          if(ps2.Id == priceObj.Parent_Price_Support__c)
             addthis = false;

        if(addthis == true)
           sList.add(ps2.Agreement_Number__c);
       }
       duplicatePSMap.put(priceObj, slist);
    }
    system.debug('----duplicatePSMap-----'+duplicatePSMap);
    return duplicatePSMap; 
    
}

}