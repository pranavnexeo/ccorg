/**  
* @Name PriceSupportExtension
* @Purpose This is the main Extension class for PriceSupport Object and it contains most of the business logic.
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class PriceSupportExtension {
        
    private List<Bracketed_Pricing__c> pricingList = new List<Bracketed_Pricing__c>();
    private List<String> supplierDmContactNumberList = new List<String>();
    private List<SelectOption> supplierDmContactNameList = new List<SelectOption>();
    private List<SelectOption> territoryList = new List<SelectOption>();
    private final Price_Support__c priceSupport;
    private final ApexPages.StandardController priceSupportController;
    private Supplier_Profile__c supplierProfile = null;
    public boolean insertFlag{get;set;}
    private final String objectName = 'Price_Support__c';
    private Static Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Price_Support__c.fields.getMap();
    public String comments{get;set;}
    public string recordtype{get;set;}
    public Boolean isDisplay{get;set;}
    public Boolean dispCheckBox{get;set;}
    public String region{get;set;}
    
    List<String> emailList ;
    List<Nexeo_Member__c> nexeoMemberList ;
    List<Supplier_Member__c> supplierMemberList ;
    List<Nexeo_Group__c> nexeoMainApprover ;
    List<Supplier_Group__c> supplierMainApprover ;
    String[] toAddresses = new String[] {};
    String message ;
    String subject ;
    
    Public String Divino;
    Integer i;
    public boolean displayPopUp{get;set;}
    public boolean exiprationFlag{get;set;}
    public boolean reviewFlag{get;set;}
    public boolean conditionalPopUp{get;set;}
    
    //Added for dynamic required Fields//
    public boolean Supplier_Sales_Contact_Req{get;set;}
    public boolean Competitor_Manufacturer_Req{get;set;}
    public boolean Competitive_Product_Req{get;set;}
    public boolean OEM_Req{get;set;}
    public boolean Potential_Annual_Volume_Req{get;set;}
    public boolean Application_Req{get;set;}
    public boolean Market_Segment_Req{get;set;}
    
    public boolean cancelFlag{get;set;}
    public boolean declineFlag{get;set;}
    //private List<SelectOption> uom = new List<SelectOption>();
    private List<SelectOption> hub = new List<SelectOption>();
    //private Map<String,String> plantMap = new  Map<String,String>();
    private String currentUserId = System.Userinfo.getUserId();
    private final String OPEN = 'Open';
    private final String AWAITING_NEXEO_APPROVAL = 'Awaiting Nexeo Approval';
    private final String DECILNED = 'Declined';
    private final String AWAITING_SUPPLIER_APPROVAL = 'Awaiting Supplier Approval';
    private final String REJECTED_BY_SUPPLIER = 'Rejected by Supplier';
    private final String CONDITIONALLY_APPROVED = 'Conditionally Approved';
    private final String APPROVED = 'Approved';
    private final String REJECTED = 'Rejected';
    private final String EXPIRED = 'Expired';
    private final String CANCELLED = 'Cancelled';
    private final String REBATE = 'Rebate';
    private List<FieldHistoryVO> priceHistories = new List<FieldHistoryVO>();
    private Date expirationDate = null;        
    
    
    /*public List<SelectOption> getUom(){
        return uom;
    }*/
    
    public List<SelectOption> getHub(){
        return hub;
    }
    
    public List<SelectOption> getSupplierDmContactNameList(){
    
        return supplierDmContactNameList;
    }
    
    public List<SelectOption> getTerritoryList(){
    
        return territoryList;
    }
    
    public List<Bracketed_Pricing__c> getPricingList(){
        System.debug('--Inside get Pricing List--'+pricingList);
            return pricingList;
    }
    
    public void setPricingList(List<Bracketed_Pricing__c> newList){
            System.debug('--Inside set Pricing List--'+pricingList);
            this.pricingList.clear();
            this.pricingList.addAll(newList);
    }
    /**  
    * @Name customEdit
    * @Purpose This method is used to redirect to Price Support edit page.
    * @param 
    * @return PageReference
    * @Author  Deepak
    */   
    public PageReference customEdit(){
    
    
        if(priceSupport.Status__c==PriceSupportUtil.APPROVED){
        
            PageReference pageRef = Page.PriceSupportApproved;
            
            pageRef.getParameters().put('Id',priceSupport.Id);
            pageRef.setRedirect(true);
            return pageRef;
            
        }else{
            return priceSupportController.edit();
        }
    }
  
   public PageReference editComments(){
        
        if(priceSupport.Status__c=='Expired'){
            
            PageReference pageRef = Page.PriceSupportEditComments;
            pageRef.getParameters().put('Id',priceSupport.Id);
            pageRef.setRedirect(true);
            return pageRef;
            
        }else{
            return priceSupportController.edit();
        }
    } 
    
    
    
    
    
    
    
    /**  
    * @Name customSupplierEdit
    * @Purpose This method is used to redirect to Price Support supplier edit page.
    * @param 
    * @return PageReference
    * @Author  Chandrakant
    */   
    
    
    public PageReference customSupplierEdit(){
        
        if(priceSupport.Status__c!=''){
            
            PageReference pageRef = Page.PriceSupportSupplierEditPage;
            pageRef.getParameters().put('Id',priceSupport.Id);
            pageRef.setRedirect(true);
            return pageRef;
            
        }else{
            return priceSupportController.edit();
        }
    }

  /**  
    * @Name doSapretransfer
    * @Purpose This method is used to make the SAP transfer status again OPEN in Transfer Error Page.
    * @param 
    * @return PageReference
    * @Author  Chandrakant
    */   

public PageReference doSapretransfer(){
        
        System.debug('---------  Price Support --------------');
        PageReference pageRef = new PageReference('/'+priceSupport.Id);
        pageRef.setRedirect(true);
        priceSupport.SAP_Transfer__c='Open';
       
        update priceSupport;
        conditionalPopUp = false;
        return pageRef;
        
    
    }
    /**  
    * @Name init
    * @Purpose This method is used to redirect Price supports into a different pages rather than actual edit page based on Status.
    * @param 
    * @return PageReference
    * @Author  Deepak
    */ 
    public PageReference init(){
        
        System.debug('------Inside init------');
        PageReference pageRef = null;
        if(priceSupport.Status__c==PriceSupportUtil.APPROVED){
            pageRef = Page.PriceSupportApproved;
            pageRef.getParameters().put('Id',priceSupport.Id);
            pageRef.setRedirect(true);
           
        }else if(priceSupport.Status__c==PriceSupportUtil.OPEN || priceSupport.Status__c == PriceSupportUtil.REJECTED_BY_SUPPLIER 
        ||priceSupport.Status__c == PriceSupportUtil.CONDITIONALLY_APPROVED){
            pageRef = null;
        }else if(!insertFlag){
            pageRef = Page.PriceSupportView;
            pageRef.getParameters().put('Id',priceSupport.Id);
            pageRef.setRedirect(true);
        }
        return pageRef;
    }
    
    /**  
    * @Name supplierCheck
    * @Purpose This method is used to check whether the logged in user is a supplier and redirect
    *            to the supplier page rather than actual PriceSupportView page.
    * @param 
    * @return PageReference
    * @Author  Deepak
    */ 
    public PageReference supplierCheck(){
    
        System.debug('-----Supplier Check------');
        PageReference pageRef = null;
        Profile profilename=[SELECT Id, Name FROM Profile where Id=:UserInfo.getProfileId()];
        if(profilename.name.equalsIgnoreCase('Price Support External')){
            pageRef = Page.PriceSupportSupplierView;
            pageRef.getParameters().put('Id',priceSupport.Id);
            pageRef.setRedirect(true);
        }
        
        return pageRef;
        
    }
    /**  
    * @Name PriceSupportExtension
    * @Purpose This the constructor for PriceSupportExtension.It is used to reset some fields during copy and 
    *          fetch Bracketed Pricing for Upfront, Set required fields from Supplier Profile etc
    * @param ApexPages.StandardController
    * @return 
    * @Author  Deepak
    */     
    public PriceSupportExtension(ApexPages.StandardController controller) {
                
                
                priceSupport = (Price_Support__c)controller.getRecord();
                this.priceSupportController = controller;
                
                getPlants();//populate hub list
                
                System.debug('-------------priceSupport----------------------'+priceSupport);
                System.debug('-------------priceSupport Id----------------------'+priceSupport.Id);
                System.debug('name is '+priceSupport.RecordTypeId);
                Map<String, Schema.RecordTypeInfo> rtmap = Price_Support__c.getSObjectType().getDescribe().getRecordTypeInfosByName();
     
                dispCheckBox = false;
                isDisplay = false;

                if(priceSupport.RecordTypeId  == rtmap.get('Chemicals').getrecordtypeid()){
                    
                   system.debug('######inside257');
                    isDisplay = false;
                }
                else{
                  system.debug('######inside261');
                   //system.debug('@@@@@@@'+priceSupport.All_Regions__c);
                   priceSupport.All_Regions__c = true;
                    priceSupport.Region_code__c = 'ALL';
                   isDisplay = true;
                }           

                
                //Setting the status = open on click of renew button//
                String action = ApexPages.currentPage().getParameters().get('action');
                System.debug('---------action-------------'+action);
                
                if(action!=null && action.equalsIgnoreCase('renew')){
                        
                        System.debug('---------setting renew Flag-------------');
                        priceSupport.Support_ID__c='';
                        priceSupport.Status__c=PriceSupportUtil.OPEN;
                        priceSupport.SAP_Transfer__c='';
                        priceSupport.Additional_Comments__c='';
                        priceSupport.Previous_Comments__c='';
                }
                
                if(priceSupport.Id==null){
                        
                        System.debug('----------New Mode--------------');
                        
                        insertFlag = true;
                        if(pricingList.isEmpty()){
                            Bracketed_Pricing__c pricingObj = new Bracketed_Pricing__c(Product_Min_Qty__c=0.0,Price__c=0.0,X2nd_Discount_Type__c='%',X2nd_Discount__c=0.0,X1st_Discount_Type__c='%',X1st_Discount__c=0.0,Net_Price__c=0.0);
                    
                            pricingList.add(pricingObj);
                        }
                        
                        
                
                }else{
                
                        System.debug('----------Edit/View Mode--------------');
                        
                        insertFlag = false;
                        expirationDate= priceSupport.Expiration_Date__c;
                        
                        pricingList = [SELECT Id, Name,Net_Price__c, Price__c, Product_Min_Qty__c, X1st_Discount_Type__c, X1st_Discount__c, X2nd_Discount_Type__c, X2nd_Discount__c FROM Bracketed_Pricing__c  where Price_Support__r.Id=:priceSupport.Id];
                        
                        
                        //Setting the dynamic required fields//
                        List<Price_Support__c> reqList = [select Supplier_Profile_ID__r.Required_Fields__c,Supplier_Profile_ID__r.Supplier_Name__c,Support_Type__c from Price_Support__c where Id=:priceSupport.Id];
                        
                        if(reqList!=null && !reqList.isEmpty()){
                            Price_Support__c supp = reqList.get(0);
                            String reqFields = supp.Supplier_Profile_ID__r.Required_Fields__c;
                            if(supp.Support_Type__c==PriceSupportUtil.REBATE){
                                getPartnerFunctionCode(supp.Supplier_Profile_ID__r.Supplier_Name__c);
                            }
                            if(reqFields!=null){
                                setDynamicReqFields(reqFields);
                            }
                        }
                        //populating territory
                        /*List<Account> custList = [select Owner.Ashland_Employee_Number__c from Account where Id=:priceSupport.Customer_Name__c];
                        if(custList!=null && !custList.isEmpty()){
                            Account cust = custList.get(0);
                            setTerritory(cust.Owner.Ashland_Employee_Number__c);
                        }*///Uncomment this if territory needs to be a drop down.
                        
                        
                }
                
                
    }


    /*public void getSupplierDetails(){
        
       
        String supplierId = ApexPages.currentPage().getParameters().get('supplierForceId');
       
        String selectedSupplierProfile = Apexpages.currentPage().getParameters().get('supplierProfile');
               
        //system.debug('purchasingOrg is : '+purchasingOrgValue);
        List<Supplier_Profile__c> suppPro = [Select Id,Supplier_Name__c  FROM Supplier_Profile__c where name=: selectedSupplierProfile ];   
        if(suppPro.size()>0){
        
            List <Account> supplierList = [select SAP_PartnerFunctionCodeText__c,SAP_PartnerFunctionText__c,SAP_Currency__c from Account where Id=:supplierId or Id=:suppPro[0].Supplier_Name__c];
            System.debug('----------supplierList -------------'+supplierList );
            if(supplierList!=null && !supplierList.isEmpty()){
            
                Account supplierObj = supplierList.get(0);
                
                getPartnerFunctionCode(supplierObj);
                
            }
            
        }
    
    }*/
    
    /**  
    * @Name getPartnerFunctionCode
    * @Purpose This method is used to get the Debit memo contact for a supplier from Partner functions.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
   @TestVisible private void getPartnerFunctionCode(String accountId){
        
        List <Account> supplierList = [select SAP_PartnerFunctionCodeText__c,SAP_Vendor_Purchase_Org__c,SAP_PartnerFunctionText__c,SAP_Currency__c from Account where Id=:accountId];
        String partnerFuctions = null; 
        String partnerFuctionCodes = null;
        String purchaseOrg = null;
        if(supplierList!=null && !supplierList.isEmpty()){
            
            Account supplierObj = supplierList.get(0);
            partnerFuctions = supplierObj.SAP_PartnerFunctionText__c;
            partnerFuctionCodes = supplierObj.SAP_PartnerFunctionCodeText__c;
            purchaseOrg = supplierObj.SAP_Vendor_Purchase_Org__c;
            
            System.debug('------------partnerFuctions11----------'+partnerFuctions);
            System.debug('------------partnerFuctionCodes11----------'+partnerFuctionCodes);
            
            if(partnerFuctions==null){
                
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO, 'No Partner Function is available for this Supplier.Please correct the Supplier Profile.');
                    
                ApexPages.getMessages().clear();
                    
                ApexPages.addMessage(myMsg);
                    
                return;
            }
            
            Map<String,String> partnerFunctionMap = new Map<String,String>();
            List<String> partnerFunctionList =null;
            List<String> partnerFuctionCodesList =null;
           
            supplierDmContactNumberList.clear();
            supplierDmContactNameList.clear();
            
            if(partnerFuctions!=null && partnerFuctions.length()>0){
                partnerFunctionList = partnerFuctions.split(',');
            }
            
            if(partnerFuctionCodes!=null && partnerFuctionCodes.length()>0){
                partnerFuctionCodesList = partnerFuctionCodes.split(',');
            }
            
            if(partnerFunctionList!=null && partnerFuctionCodesList!=null){
                
                if(partnerFunctionList.size()!=partnerFuctionCodesList.size()){
                
                    System.debug('-------------Partner Function Not Proper in SFDC----------');
                    
                }
                try{
                    Integer indx =0;
                
                    for(String functions: partnerFunctionList){
                        
                        if(functions.equalsIgnoreCase('ZA')){
                            
                            supplierDmContactNumberList.add(partnerFuctionCodesList.get(indx));
                        }
                        
                        indx++;
                        
                    }
                }catch(Exception e){
                
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Partner Function Not Proper in SFDC');
                    
                    ApexPages.getMessages().clear();
                    
                    ApexPages.addMessage(myMsg);
                    
                    return;
                    
                    
                }
                
                
                 System.debug('-------------supplierDmContactNumberList Size----------'+supplierDmContactNumberList.size());
                 System.debug('------------supplierDmContactNumberList  is ----------'+supplierDmContactNumberList); 
                 //String purchaseOrg1=priceSupport.Purchasing_Organization__c.substring(0, 4);
                 
                 System.debug('-------------Purchase Org----------'+purchaseOrg);
                  
                 List <Account> acctList= [select Name,SAP_Supplier_Number__c,SAP_Account_Name_2__c, W_Account_Status__c, SAP_Accounting_group__c,SAP_Sales_Org__c,SAP_DivisionCode__c from Account where  SAP_Supplier_Number__c in : supplierDmContactNumberList and W_Account_Status__c = 'ACTIVE' and SAP_Accounting_group__c = 'ZREG' and SAP_Vendor_Purchase_Org__c=:purchaseOrg];           
                 
                 
                 Set<String> numberNameSet = new Set<String>();
                 Set<String> numberSet     = new Set<String>();  
                    for(i=0; i<acctList.size();i++){
     
                        String suppName = acctList[i].Name;
                        String suppNumber = acctList[i].SAP_Supplier_Number__c;
                         String Sacctname2 = acctList[i].SAP_Account_Name_2__c;
                         if(Sacctname2 !=null){
                         numberNameSet.add(suppNumber + '-' + Sacctname2 );
                         }
                         else{
                         numberNameSet.add(suppNumber + '-' + suppName );
                         }
                        
                    }   
                        
                       
                    for(String val:numberNameSet){
                        supplierDmContactNameList.add(new SelectOption(val,val));
                       
                    }  
                    
               system.debug('supplierDmContactNameList is '+supplierDmContactNameList );
               
               
                if(supplierDmContactNameList.isEmpty()){
                
                    ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL, 'Supplier Does not have an ZA Vendor');
                    
                    ApexPages.getMessages().clear();
                    
                    ApexPages.addMessage(myMsg);
                    
                    return;
                }
                
             
            }
                
        }
        
        
         
    }
    
    /**  
    * @Name customSave
    * @Purpose This method is used save the Price Support.
    * @param 
    * @return PageReference
    * @Author  Deepak
    */     
    public PageReference customSave(){
        
        System.debug('-------Inside Custom Save-------');
        System.debug('-------Support_Type__c-------'+priceSupport.Support_Type__c);
        
        
        if(priceSupport.Support_Type__c==PriceSupportUtil.REBATE ){
            doRebateCalculation();
        }else if(priceSupport.Support_Type__c==PriceSupportUtil.UPFRONT){
            doUpfrontCalculation();
        }
        System.debug('------- Purchase Cost ------'+priceSupport.Customer_City__c);
        System.debug('------- Supplier Supported Price ------'+priceSupport.Customer_Number__c);
        priceSupportController.save();
        
        if(priceSupport.Support_Type__c==PriceSupportUtil.UPFRONT){
                
                System.debug('-------New Price Support Id--------------- '+priceSupportController.getId());
                
                System.debug('-------Old Price Support Id--------------- '+priceSupport.Id);
                
                System.debug('-------old pricing list --------------- '+pricingList);
        
                List<Bracketed_Pricing__c> upsertPriceList = new List<Bracketed_Pricing__c>();
                
                
                String action = ApexPages.currentPage().getParameters().get('action');
                
                if(action!=null && action.equalsIgnoreCase('renew')){
                    System.debug('-------Inside Clone Block --------------- ');
                    List<Bracketed_Pricing__c> clonedPriceList = PriceSupportUtil.cloneBracketedPricing(pricingList,priceSupportController.getId());
                    System.debug('-------new pricing list --------------- '+clonedPriceList);
                    insert clonedPriceList;
                
                }else{
                    System.debug('-------Inside Insert/Update Block --------------- ');
                    for(Bracketed_Pricing__c bracketedPrice:pricingList){
                            
                            if(bracketedPrice.Price_Support__c==null){
                                bracketedPrice.Price_Support__c = priceSupportController.getId();
                            }
                            upsertPriceList.add(bracketedPrice);
                    
                    }
                    
                    upsert upsertPriceList;
                }
                 
        }
        
        
        
        PageReference pageRef = new PageReference('/'+priceSupportController.getId());
        pageRef.setRedirect(true);
        
        return pageRef;
    
    }
    /**  
    * @Name getPricing
    * @Purpose This method is used fetch details from the supplier profile selected.
    * @param 
    * @return 
    * @Author  Deepak
    */   
    public void getPricing(){
        
        System.debug('---------selected supplier profile-----------'+Apexpages.currentPage().getParameters().get('supplierProfile'));
        
        priceSupport.Supplier_Group__c = null;
        priceSupport.Supplier_Main_Approver__c =  null;
        priceSupport.Supplier_Group_Name__c = '';
        
        
        String selectedSupplierProfile = Apexpages.currentPage().getParameters().get('supplierProfile');
        integer noOfRows = 0;
        
        List<Supplier_Profile__c> profileList=[SELECT Id, Name, Discount_before_Other_Costs__c,Freight_Allowance__c,Lot_Required__c, 
        Match_to_PO_Required__c,Adjust_for_PO_Price_Difference__c, PO_Received_before_Sale__c,Packaging_Allowance__c,Potential_Applications__c, 
        Price_Changes_Automatically_Approved__c,  Required_Fields__c, Round_All_Support_Calculations_to__c, 
        X1st_Discount__c, X2nd_Discount__c, of_rows_for_Bracketed_Pricing__c, X1st_Discount_Type__c, X2nd_Discount_Type__c ,Supplier_Street_Address__c,
        Supplier_Number__c,Supplier_Name__r.Name,Supplier_Name__c,Vendor_PI__c,Supplier_City__c,State__c
         FROM Supplier_Profile__c where name=: selectedSupplierProfile];
         
         if(profileList!=null && !profileList.isEmpty()){
                
                        supplierProfile = profileList.get(0);
                        priceSupport.X1st_Discount_Sell__c = supplierProfile.X1st_Discount__c;
                        priceSupport.X1st_Discount_Type_Sell__c = supplierProfile.X1st_Discount_Type__c;
                        priceSupport.X2nd_Discount_Sell__c = supplierProfile.X2nd_Discount__c;
                        priceSupport.X2nd_Discount_Type_Sell__c = supplierProfile.X2nd_Discount_Type__c;
                        priceSupport.Packaging_Allowance__c = supplierProfile.Packaging_Allowance__c;
                        priceSupport.Freight_Allowance_Selling__c = supplierProfile.Freight_Allowance__c;
                
                        priceSupport.X1st_Discount_Buy__c = supplierProfile.X1st_Discount__c;
                        priceSupport.X1st_Discount_Type_Buy__c = supplierProfile.X1st_Discount_Type__c;
                        priceSupport.X2nd_Discount_Buy__c = supplierProfile.X2nd_Discount__c;
                        priceSupport.X2nd_Discount_Type_Buy__c = supplierProfile.X2nd_Discount_Type__c;
                        priceSupport.city__c = supplierProfile.Supplier_City__c;
                        priceSupport.State_Province__c = supplierProfile.State__c;
                        priceSupport.Street_Address__c = supplierProfile.Supplier_Street_Address__c;
                        priceSupport.Supplier_Name__c = supplierProfile.Supplier_Name__r.Name;
                        priceSupport.Supplier_Number__c = supplierProfile.Supplier_Number__c;
                        priceSupport.Supplier_PI_Number__c = supplierProfile.Vendor_PI__c;
                        priceSupport.Application__c = supplierProfile.Potential_Applications__c; 
                        priceSupport.Adjust_for_PO_Difference__c = supplierProfile.Adjust_for_PO_Price_Difference__c;
                        priceSupport.Match_to_PO_Required__c = supplierProfile.Match_to_PO_Required__c;
                        if(supplierProfile.of_rows_for_Bracketed_Pricing__c!=null){
                            noOfRows = Integer.valueOf(supplierProfile.of_rows_for_Bracketed_Pricing__c);
                        }
                        
                        System.debug('--------Required Fields--------'+supplierProfile.Required_Fields__c);
                        System.debug('--------Supplier_Name__c--------'+supplierProfile.Supplier_Name__r.Name);
                        
                        String reqFields = supplierProfile.Required_Fields__c;
                        if(reqFields!=null){
                            setDynamicReqFields(reqFields);
                        }
                        
                        if(priceSupport.Support_Type__c==PriceSupportUtil.REBATE){
                                getPartnerFunctionCode(supplierProfile.Supplier_Name__c);
                        }
                        
                        
                        
         }else{
                        priceSupport.city__c = '';
                        priceSupport.State_Province__c = '';
                        priceSupport.Street_Address__c = '';
                        priceSupport.Supplier_Name__c = '';
                        priceSupport.Supplier_Number__c = '';
                        priceSupport.Supplier_PI_Number__c = '';
         
         }
        if(priceSupport.Support_Type__c==PriceSupportUtil.UPFRONT){
            if(insertFlag){
                    
                    System.debug('-----------Insert Operation--------------');
                    System.debug('-----------Creating new pricing list--------------');
                    List<Bracketed_Pricing__c> newList = new  List<Bracketed_Pricing__c>();
                    
                    Bracketed_Pricing__c bracketedPricing = null;
                    
                    for(integer i=0;i<noOfRows;i++){
                    
                            bracketedPricing = new Bracketed_Pricing__c(Product_Min_Qty__c=0.0,Price__c=0.0,X2nd_Discount_Type__c='%',X2nd_Discount__c=0.0,X1st_Discount_Type__c='%',X1st_Discount__c=0.0,Net_Price__c=0.0);
                            newList.add(bracketedPricing);
                            
                    }
                    setPricingList(newList);
                    System.debug('-------get Pricing pricingList------'+getPricingList().size());
                    
            }else{
                
                //First one supplier Profile was selected and latter we are updating to a supplier profile which has more no of rows than the previous one
                integer currentSize = pricingList.size();
                
                if(noOfRows>currentSize){
                    Bracketed_Pricing__c bracketedPricing = null;
                    for(integer i=currentSize;i<noOfRows;i++){
                    
                            bracketedPricing = new Bracketed_Pricing__c(Product_Min_Qty__c=0.0,Price__c=0.0,X2nd_Discount_Type__c='%',X2nd_Discount__c=0.0,X1st_Discount_Type__c='%',X1st_Discount__c=0.0,Net_Price__c=0.0);
                            pricingList.add(bracketedPricing);
                            
                    }
                }
                
                
            }
        }
        
    } 
    /**  
    * @Name setDynamicReqFields
    * @Purpose This method is used set the required mark on the fields selected in Supplier Profile as required fields.
    * @param 
    * @return 
    * @Author  Deepak
    */   
   @TestVisible private void setDynamicReqFields(String reqFields){
    
        if(reqFields.contains(PriceSupportUtil.SUPPLIER_SALES_CONTACT)){
            Supplier_Sales_Contact_Req= true;
        }else {
            Supplier_Sales_Contact_Req = false;
        }
        if(reqFields.contains(PriceSupportUtil.COMPETITOR_MANUFACTURER)){
            Competitor_Manufacturer_Req = true;
        }else{
            Competitor_Manufacturer_Req = false;
        }
        if(reqFields.contains(PriceSupportUtil.COMPETITIVE_PRODUCT)){
            Competitive_Product_Req = true;
        }else{
            Competitive_Product_Req = false;
        }
        if(reqFields.contains(PriceSupportUtil.OEM)){
            OEM_Req = true;
        }else{
            OEM_Req = false;
        }
        if(reqFields.contains(PriceSupportUtil.POTENTIAL_ANNUAL_VOLUME)){
            Potential_Annual_Volume_Req = true;
        }else{
            Potential_Annual_Volume_Req = false;
        }
        if(reqFields.contains(PriceSupportUtil.APPLICATION)){
            Application_Req = true;
        }else{
            Application_Req = false;
        }
        if(reqFields.contains(PriceSupportUtil.MARKET_SEGMENT)){
            Market_Segment_Req = true;
        }else{
            Market_Segment_Req = false;
        }
        
        System.debug('---OEM_Req----'+OEM_Req);
        System.debug('---Market_Segment_Req----'+Market_Segment_Req);
    }
    
    public void showExiprationPopUp(){
    
        displayPopUp = true;
        exiprationFlag = true;
        reviewFlag= false;
    }
    
    public PageReference PriceSupportHistory(){
        
        PageReference pageRef = new PageReference('/_ui/common/history/ui/EntityHistoryFilterPage?id='+priceSupport.Id);
        pageRef.setRedirect(true);
        return pageRef;
    }
    public void showReviewPopUp(){
    
        displayPopUp = true;
        reviewFlag= true;
        exiprationFlag = false;
    }
    
    public void showCancelPopUp(){
        
        conditionalPopUp = true;
        cancelFlag = true;
    }
    public void showDeclinePopUp(){
        
        conditionalPopUp = true;
        declineFlag = true;
    }
    
    public void showCommentsPopUp(){
        
         cancelFlag = false;
         declineFlag = false;
         conditionalPopUp = true;
    
    }
    /**  
    * @Name updateExpiryDate
    * @Purpose This method is used to update the Expiry date.
    * @param 
    * @return 
    * @Author  Deepak
    */  
    public void updateExpiryDate(){
        
        /*PageReference pageRef = new PageReference('/'+priceSupport.Id);
        pageRef.setRedirect(true);
        System.debug('Expiration date --------'+priceSupport.Expiration_Date__c);
        System.debug('Today date --------'+System.today());
        if(priceSupport.Expiration_Date__c<System.today()){
            
            System.debug('Expiration date less than today--------');
            priceSupport.Status__c = 'Expired';
        }
        priceSupport.SAP_Transfer__c=OPEN;
        update priceSupport;
        
        hidePopUp();
        return pageRef;*/
        
       /* if(priceSupport.Expiration_Date__c>expirationDate || priceSupport.Expiration_Date__c<priceSupport.Effective_Date__c){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'You are attempting to set the expiration date on Support # '+priceSupport.Support_ID__c +' before its effective date ('+priceSupport.Effective_Date__c+') or after its expiration date ('+expirationDate+').This is not allowed.'));
        }else{ */
            if(priceSupport.Support_Type__c==PriceSupportUtil.REBATE){
                priceSupport.SAP_Transfer__c=PriceSupportUtil.OPEN;
            }else{
                priceSupport.SAP_Transfer__c='';
            }
            update priceSupport;
            hidePopUp();
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Info,'Expiration Date is Changed.'));
      //  }
        
    }
    /**  
    * @Name updateReviewDate
    * @Purpose This method is used to update the Review date.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    public PageReference updateReviewDate(){
        
        PageReference pageRef = new PageReference('/'+priceSupport.Id);
        pageRef.setRedirect(true);
       
        priceSupportController.save();
        hidePopUp();
        return pageRef;
    }
    /**  
    * @Name hidePopUp
    * @Purpose This method is used to hide the popup.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    public void hidePopUp(){
    
        displayPopUp = false;
        conditionalPopUp = false;
    }
    /**  
    * @Name cancelPriceSupport
    * @Purpose This method is used to cancel the price support.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    public PageReference cancelPriceSupport(){
        
        System.debug('--------- Cancel Price Support --------------');
        PageReference pageRef = new PageReference('/'+priceSupport.Id);
        pageRef.setRedirect(true);
        priceSupport.Status__c='Cancelled';
        if(comments!=null && !comments.equals('')){
            priceSupport.Additional_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Additional_Comments__c);
        }
        //priceSupportController.save();
        update priceSupport;
        conditionalPopUp = false;
        return pageRef;
        
    
    }
    /**  
    * @Name doRenewal
    * @Purpose This method is used to renew the price support.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    public void doRenewal(){
        
        System.debug('---------Do renewal-------------------');
        //priceSupportController.addFields(PriceSupportUtil.getFieldsToBeCloned(objectName));
        Price_Support__c renewPriceObj = (Price_Support__c)priceSupportController.getRecord();
        Price_Support__c newPriceObj = renewPriceObj.clone(false,true);
        //newPriceObj.Parent_Price_Support__c = renewPriceObj.Id;
 
        if(validateduringRenewal())
        {
        insert PriceSupportUtil.setStatusAfterRenew(PriceSupportUtil.resetFields(newPriceObj, PriceSupportUtil.RENEW));
        }
        System.debug('newPriceObj.Id-----------'+newPriceObj.Id);
        
        if(newPriceObj.Support_Type__c==PriceSupportUtil.UPFRONT && newPriceObj.Id!=null){
      
          
            insert PriceSupportUtil.cloneBracketedPricing(pricingList, newPriceObj.Id);    
         
      }
    }
    
    /**  
    * @Name getNexeoApprovers
    * @Purpose This method is used to get the main approver from Nexeo Group selected.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    public void getNexeoApprovers(){
    
        System.debug('----------Inside getNexeoMainApprover-------------');
        
        String nexeoGroup = Apexpages.currentPage().getParameters().get('nexeoGroup');
        
        System.debug('----------Nexeo Group-------------'+nexeoGroup);
        
        if(nexeoGroup!=null){
        
            List<Nexeo_Group__c> nexeoGroupList = [select Id,Main_Approver__c,Group_Name__c from Nexeo_Group__c where name=:nexeoGroup];
            if(nexeoGroupList!=null && !nexeoGroupList.isempty()){
                                
                    Nexeo_Group__c nexeoGroupObj = nexeoGroupList.get(0);
                    priceSupport.Nexeo_Main_Approver__c = nexeoGroupObj.Main_Approver__c;
                    priceSupport.Nexeo_Group_Name__c = nexeoGroupObj.Group_Name__c;
                            
            }else{
                    priceSupport.Nexeo_Main_Approver__c = null;
                    priceSupport.Nexeo_Group_Name__c = '';
            }
        
        }
        
        System.debug('----------priceSupport.Nexeo_Main_Approver__c---------'+priceSupport.Nexeo_Main_Approver__c);
       
    
    }
    /**  
    * @Name getSupplierApprovers
    * @Purpose This method is used to get the main approver from Supplier Group selected.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    public void getSupplierApprovers(){
    
        System.debug('----------Inside getSupplierApprovers-------------');
        
        String supplierGroup = Apexpages.currentPage().getParameters().get('supplierGroup');
        
        System.debug('----------Supplier Group-------------'+supplierGroup);
        
        if(supplierGroup!=null){
            
            List<Supplier_Group__c> supplierGroupList = [select Id,Main_Approver__c,Group_Name__c from  Supplier_Group__c where name=:supplierGroup];
            if(supplierGroupList!=null && !supplierGroupList.isempty()){
                                
                Supplier_Group__c supplierGroupObj = supplierGroupList.get(0);
                priceSupport.Supplier_Main_Approver__c = supplierGroupObj.Main_Approver__c;
                priceSupport.Supplier_Group_Name__c = supplierGroupObj.Group_Name__c;
                                
            }else{
                priceSupport.Supplier_Main_Approver__c =  null;
                priceSupport.Supplier_Group_Name__c = '';
            }
        
        }
        
        System.debug('----------priceSupport.Supplier_Main_Approver__c---------'+priceSupport.Supplier_Main_Approver__c);
        
    }
    
    
    /**  
    * @Name populateMaterialData
    * @Purpose This method is used to get the details from Material selected.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    public void populateMaterialData(){
    
        
        String materialId = ApexPages.currentPage().getParameters().get('materialId');
        String materialType = ApexPages.currentPage().getParameters().get('materialType');
        
        System.debug('--------materialId--------'+materialId);
        
        List<Material_Sales_Data2__c> materialList = [select Id,name,Material_Number__c,
        Material_Desc__c,PH4_Supplier__c,MATERIAL_GROUP2_CODE__C,
        Material_General_Data__r.Material_Container_Desc__c,Material_Base_Code__c,Base_UOM_Code__c from Material_Sales_Data2__c where Id=:materialId];
        
        if(materialList!=null && !materialList.isEmpty()){
        
            Material_Sales_Data2__c material = materialList.get(0);
            
            System.debug('----------material Container Type---------'+material.Material_General_Data__r.Material_Container_Desc__c);
            System.debug('----------material UOM---------'+material.Base_UOM_Code__c);
            System.debug('----------material Material_Base_Code__c---------'+material.Material_Base_Code__c);
            
            //Material_Buying__r.Material_Number__c -- Material Code (Selling)
            //Material Description (Selling)  -- Material_Selling__r.Material_Desc__c
            //Material_Base_Code__c --Base Material Code (Buying)
            

            if(materialType!=null && materialType.equalsIgnoreCase('Selling')){
                //priceSupport.UOM__c = material.Base_UOM_Code__c;
                //uom.add(new SelectOption( material.Base_UOM_Code__c, material.Base_UOM_Code__c));
                //getUOMS(material.Material_Number__c); // Un comment and change the VF page if needed
                priceSupport.Container_Type__c = material.Material_General_Data__r.Material_Container_Desc__c;
                priceSupport.Material_Code_Selling__c = material.Material_Number__c;
                priceSupport.Material_Description_Selling__c = material.Material_Desc__c;
                priceSupport.Material_Buying__c = materialId;
                priceSupport.Base_Material_Code_Selling__c = material.Material_Base_Code__c;
                    
                priceSupport.Container_Type_Buying__c = material.Material_General_Data__r.Material_Container_Desc__c;
                priceSupport.Material_Code_Buying__c = material.Material_Number__c;
                priceSupport.Material_Description_Buying__c = material.Material_Desc__c;
                priceSupport.ProductSupplier__c = material.PH4_Supplier__c;
                priceSupport.Base_Material_Code_Buying__c = material.Material_Base_Code__c;
                //To set Material Group2 value -anj
                priceSupport.Material_Group_2_Buying__c = material.Material_Group2_Code__c;
                System.debug('----------priceSupport.Material_Description_Buying__c---------'+priceSupport.Material_Description_Buying__c);
                System.debug('----------priceSupport.Material_Description_Selling__c---------'+priceSupport.Material_Description_Selling__c);
                
            }else if(materialType!=null && materialType.equalsIgnoreCase('Buying')){
                
                priceSupport.Material_Buying__c = materialId;
                priceSupport.Container_Type_Buying__c = material.Material_General_Data__r.Material_Container_Desc__c;
                priceSupport.Material_Code_Buying__c = material.Material_Number__c;
                priceSupport.Material_Description_Buying__c = material.Material_Desc__c;
                priceSupport.Base_Material_Code_Buying__c = material.Material_Base_Code__c;//Uncomment if deafulr Uom needs to be populated
               //To set Material Group2 value -anj
                priceSupport.Material_Group_2_Buying__c = material.Material_Group2_Code__c;
                if(priceSupport.Support_Type__c=='Upfront'){
                
                     //priceSupport.UOM__c = material.Base_UOM_Code__c;
                     //uom.add(new SelectOption( material.Base_UOM_Code__c, material.Base_UOM_Code__c));//Uncomment if Default Uom needs to be populated
                    //getUOMS(material.Material_Number__c);
                }
            
            }
        
        }
        
    }
    
     /*private void getUOMS(){
        
        List<Material_UOM__c> uomList = [select Alternative_UOM__c,Material_Number__c from Material_UOM__c where Material_Number__c=:materialNumber];
        
        //System.debug('-------Uom List Size------'+uomList.size());
        
        if(uomList!=null & !uomList.isEmpty()){
            
            System.debug('-------Uom List Size------'+uomList.size());
            for(Material_UOM__c uomObj :uomList){
            
                uom.add(new SelectOption(uomObj.Alternative_UOM__c,uomObj.Alternative_UOM__c));
            
            }
        
        }
        uom.add(new SelectOption('LB','LB'));
        uom.add(new SelectOption('KG','KG'));
        
        
     }*/
     
    /**  
    * @Name getPlants
    * @Purpose This method is used to fetch plants from SAP_Plant__c table.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    @TestVisible private void getPlants(){
     
        List<SAP_Plant__c> plantList = [select Plant_Name__c,Plant_Code__c from SAP_Plant__c where Distribution_Channel__c='99' and Deleted__c=false and (NOT Plant_Name__c like '%DO NOT USE%') and (NOT Plant_Name__c like '%MASKED%')   ORDER BY Plant_Name__c LIMIT 999 ];
        
        hub.add(new SelectOption('','--None--'));
        
        System.debug('-----Inside getPlants--------------');
        
        if(plantList !=null && !plantList.isEmpty()){
           // boolean firstTime = true;
           String plantName = null;
           String newPlantName = null;
            for(SAP_Plant__c plantObj:plantList){
                plantName = plantObj.Plant_Name__c;
                newPlantName= plantName.replaceAll('-', ' ');
                hub.add(new SelectOption(newPlantName+'-'+plantObj.Plant_Code__c,newPlantName+'-'+plantObj.Plant_Code__c));
                
                //plantMap.put(plantObj.Plant_Name__c,plantObj.Plant_Code__c);
            }
        
        }
     }
    /**  
    * @Name getPlantCodelants
    * @Purpose This method is used to get the plant code from the plant selected.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
     public void getPlantCode(){
     
        String plantName = ApexPages.currentPage().getParameters().get('plantName');
        
        if(plantName!=null && plantName.contains('-')){
         String[] plantDeatils = plantName.split('-');
         System.debug('---------Plant Code --------'+plantDeatils[1]);
         priceSupport.Hub__c = plantDeatils[1];
        }
        
     }
     /**  
    * @Name doRebateCalculation
    * @Purpose This method is used to calculate the prices for a Rebate Support.
    * @param 
    * @return 
    * @Author  Deepak
    */
     public void doRebateCalculation(){
        
        System.debug('-------priceSupport.Supplier_Supported_Price__c------------'+priceSupport.Supplier_Supported_Price__c);
        
        List<decimal> result = PriceSupportUtil.doRebateCalculation(priceSupport);
        
        
        priceSupport.Net_Support_Cost__c = result.get(0);
        priceSupport.Net_Purchase_Cost__c = result.get(1);
        if(!priceSupport.Rebate_Editable__c){
            priceSupport.Requested_Rebate_Amount__c = result.get(2);
        }
        
     }
     /**  
    * @Name doUpfrontCalculation
    * @Purpose This method is used to calculate the prices for a Upfront Support.
    * @param 
    * @return 
    * @Author  Deepak
    */
     public void doUpfrontCalculation(){
        System.debug('----------doUpfrontCalculation--------');
        List<Bracketed_Pricing__c> newPricingList = PriceSupportUtil.doUpfrontCalculation(getPricingList());
        setPricingList(newPricingList);
        
     }
     
    @TestVisible private decimal nullCheck(decimal val){
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
    
     /**  
    * @Name getRegionDetails
    * @Purpose This method is used to get the region deatils on click of Region Checkbox
    * @param 
    * @return 
    * @Author  Manish
    */   
     public void getRegionDetails(){
        String region = ApexPages.currentPage().getParameters().get('region');
        String allRegionVal = ApexPages.currentPage().getParameters().get('allRegionVal');
        system.debug('allRegionVal : '+allRegionVal );
        system.debug('region : '+region);
        
        if(allRegionVal == 'true'){
            priceSupport.Temp_Region__c = priceSupport.Region_Code__c;
            priceSupport.Region_Code__c = 'ALL';
        }
        else{
            priceSupport.Region_Code__c = priceSupport.Temp_Region__c;
        }
     }
   /**  
    * @Name getCustomerDetails
    * @Purpose This method is used to get the deatils from the Customer selected.
    * @param 
    * @return 
    * @Author  Deepak
    */   
     public void getCustomerDetails(){
        
        String customerId = ApexPages.currentPage().getParameters().get('customerId');
        String custType = ApexPages.currentPage().getParameters().get('custType');
        String soldToId = ApexPages.currentPage().getParameters().get('soldToId');
        String payerNo = ApexPages.currentPage().getParameters().get('payerNo');
        List<RecordType> rectype = new  List<RecordType>();
        rectype = [Select Id,Name from RecordType where Id=:priceSupport.RecordTypeId];
        if(rectype[0].Name == 'Chemicals'){
        region = ApexPages.currentPage().getParameters().get('region');
        dispCheckBox = true;
        }
        else{
        region = 'ALL'; 
        
        }
        
        System.debug('-----------Customer Id----------'+customerId);
        system.debug('region is : '+region);
        if(customerId!=null && customerId!=''){
            
            if(custType.contains('Ship')) {
                
                setSalesGroup(customerId,custType); 
                priceSupport.Region_Code__c = region;
                
            }else{
                priceSupport.Customer_Number__c = payerNo;
                priceSupport.Customer_Soldto__c = soldToId;
                priceSupport.Region_Code__c = region;
                setSalesGroup(soldToId,custType);
            
            }
            
        
        }else{
                
                priceSupport.Customer_Number__c = '';
                priceSupport.Territory__c = '';
                priceSupport.Sales_Group_Desc__c = '';
                priceSupport.Seller__c ='';
                priceSupport.Customer_City__c = '';
                priceSupport.Customer_State_Province__c = '';
                if(rectype[0].Name == 'Chemicals')
                priceSupport.Region_Code__c = '';
                 

            
            }
     
     }  
     
    /**  
    * @Name setSalesGroup
    * @Purpose When the customer is of Payer type the Customer Number and Name is from Payer but 
    *          Sales Group ,Seller, Territory etc are selected from the Sold To party for that Payer.
    * @param 
    * @return 
    * @Author  Deepak
    */ 
     
    @TestVisible private  void setSalesGroup(String customerId, String custType){
     
            List<Account> customerList = [select Name,SAP_SalesGroup__c,SAP_City__c,SAP_State__c,SAP_Sales_Group_Desc__c,SAP_Customer_Number__c,Seller__c,SAP_Seller__c,Owner.Name,Owner.Ashland_Employee_Number__c from Account where Id=:customerId];
        
            if(customerList!=null && !customerList.isEmpty()){
                
                Account customerObj = customerList.get(0);
                if(custType.contains('Ship')){
                    priceSupport.Customer_Number__c = customerObj.SAP_Customer_Number__c;
                }
                
                if(customerObj.SAP_SalesGroup__c!=null && customerObj.SAP_Sales_Group_Desc__c!=null){
                    priceSupport.Sales_Group_Desc__c = customerObj.SAP_SalesGroup__c+ '  -  '+customerObj.SAP_Sales_Group_Desc__c;
                }else{
                    priceSupport.Sales_Group_Desc__c='';
                }
                /*
                For price support seller instead of seller field in Account , use accountowner field -anj
                priceSupport.Seller__c = customerObj.Seller__c;
                
                */

                priceSupport.Seller__c =customerObj.Owner.Name;
                 //Need to fetch territory from SAP_Seller table
                //setTerritory(customerObj.Owner.Ashland_Employee_Number__c);//Uncomment this if territory needs to be a drop down.
                List<SAP_Seller__c> sapSellerList = [select Name from SAP_Seller__c where Employee_Number__c=:customerObj.Owner.Ashland_Employee_Number__c limit 1];
                if(sapSellerList!=null && !sapSellerList.isEmpty()){
                    SAP_Seller__c sellerObj = sapSellerList.get(0);
                    priceSupport.Territory__c = sellerObj.Name;
                }
                
                priceSupport.Customer_City__c = customerObj.SAP_City__c;
                priceSupport.Customer_State_Province__c = customerObj.SAP_State__c;

        }
     }
     
     /*private void setTerritory(String employeeNo){
        
        List<SAP_Seller__c> sapSellerList = [select Name from SAP_Seller__c where Employee_Number__c=:employeeNo];
        for(SAP_Seller__c sellerObj:sapSellerList){
           territoryList.add(new SelectOption(sellerObj.name,sellerObj.name));
        }
     }*///Uncomment this if territory needs to be a dropdown.
     
     /*------Approval Modifications----*/
     /*----------All these are used to control the visibility approval buttons in the page*/
     public boolean getSubmitForApproval(){
        System.debug('----------getSubmitForApproval-------------');
        
        
        
        if(priceSupport.Status__c ==OPEN){
            
            return true;
        }else{
            return false;
        }
     
     }
     public boolean getResubmit(){
        if((priceSupport.Status__c ==PriceSupportUtil.CONDITIONALLY_APPROVED || priceSupport.Status__c==PriceSupportUtil.REJECTED_BY_SUPPLIER) && checkNexeoApprover()){
            
            return true;
        }else{
            return false;
        }
     }
     
     public boolean getAcceptConditionalApproval(){
        if((priceSupport.Status__c ==PriceSupportUtil.CONDITIONALLY_APPROVED ) && checkNexeoApprover()){
            
            return true;
        }else{
            return false;
        }
     }
     
     public boolean getNexeoApprove(){
        if(priceSupport.Status__c ==AWAITING_NEXEO_APPROVAL && checkNexeoApprover()){
            return true;
        }else{
            return false;
        } 
            
     
     }
      public boolean getSupplierApprove(){
        if(priceSupport.Status__c ==AWAITING_SUPPLIER_APPROVAL && checkSupplierApprover()){
            return true;
        }else{
            return false;
        }
     
     }
     public boolean getSupplierReject(){
        if(priceSupport.Status__c ==AWAITING_SUPPLIER_APPROVAL && checkSupplierApprover()){
            return true;
        }else{
            return false;
        }
     }
     public boolean getNexeoReject(){
        if(priceSupport.Status__c ==AWAITING_NEXEO_APPROVAL && checkNexeoApprover()){
            return true;
        }else{
            return false;
        }
     }
     public boolean getDecline(){
        return getSupplierReject();
     }
     public boolean getConditionallyApprove(){
        return getSupplierReject();
     }
     public boolean getAcceptReject(){
        if(priceSupport.Status__c ==REJECTED_BY_SUPPLIER && checkNexeoApprover()){
            return true;
        }else{
            return false;
        }
     }
     
    /**  
    * @Name checkSupplierApprover
    * @Purpose Used to check whether the logged in user can do Supplier Approval 
    * @param 
    * @return 
    * @Author  Deepak
    */ 
     
    @TestVisible private boolean checkSupplierApprover(){
        
        return PriceSupportUtil.checkSupplierApprover(priceSupport.Supplier_Group__c);
        
        /*String supplierGroup = priceSupport.Supplier_Group__c;
        
        System.debug('----------Supplier Group-------------'+supplierGroup);
        System.debug('----------currentUserId -------------'+currentUserId);
        
        if(supplierGroup!=null){
         
                List<Supplier_Member__c> supplierMemberList = [SELECT Id, Approver__c, Member_ID__c, Send_Email__c, Supplier_Main_Approver__c, Supplier_Group__r.Id, Supplier_Group__r.Group_Name__c, Name__r.Id FROM Supplier_Member__c WHERE Supplier_Group__r.Id = :priceSupport.Supplier_Group__c AND Approver__c = True and Name__r.Id=:currentUserId];
                
                List<Nexeo_Member__c> nexeoSupplierMemberList = [SELECT Id, Approver__c, Send_Email__c, Name__r.Id, Supplier_Group__r.Id, Supplier_Group__r.Group_Name__c FROM Nexeo_Member__c WHERE Supplier_Group__r.Id = :priceSupport.Supplier_Group__c AND Approver__c = True and Name__r.Id=:currentUserId];
                
                List<Supplier_Group__c> supplierGroupList = [select Id,Main_Approver__c from    Supplier_Group__c where Id=:priceSupport.Supplier_Group__c and Main_Approver__c=:currentUserId];
                
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
        }*/
        
     
     }
     /**  
    * @Name checkNexeoApprover
    * @Purpose Used to check whether the logged in user can do Nexeo Approval 
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    @TestVisible private boolean checkNexeoApprover(){
        
        return PriceSupportUtil.checkNexeoApprover(priceSupport.Nexeo_Group__c);
        
        /*String nexeoGroup = priceSupport.Nexeo_Group__c;
        
        System.debug('----------nexeoGroup Group-------------'+nexeoGroup);
        System.debug('----------currentUserId -------------'+currentUserId);
        if(nexeoGroup!=null){
         
                List<Nexeo_Member__c> nexeoMemberList = [SELECT Id, Approver__c,Nexeo_Main_Approver__c,Name__r.Id, Nexeo_Group__r.Id,Nexeo_Group__r.Main_Approver__r.Name,Nexeo_Group__r.Group_Name__c FROM Nexeo_Member__c where Approver__c  = True AND Nexeo_Group__r.Id = :priceSupport.Nexeo_Group__c and Name__r.Id=:System.Userinfo.getUserId()];
                
                List<Nexeo_Group__c> nexeoGroupList = [select Id,Main_Approver__c from Nexeo_Group__c where Id=:priceSupport.Nexeo_Group__c and Main_Approver__c=:System.Userinfo.getUserId()];
                
                if(nexeoGroupList!=null && !nexeoGroupList.isEmpty()){
                    return true;
                } else if(nexeoMemberList!=null && !nexeoMemberList.isEmpty()){
                    return true;
                }else{
                    return false;
                }
                            
        }else{
        
            return false;
        
        }*/
     }
     
     /**  
    * @Name saveandsubmitforapproval
    * @Purpose Used to save the support and submit it for approval at the same time. 
    * @param 
    * @return 
    * @Author  Deepak
    */ 
     
     Public pagereference saveandsubmitforapproval(){
        
        if(priceSupport.Support_Type__c==PriceSupportUtil.REBATE ){
            doRebateCalculation();
        }else if(priceSupport.Support_Type__c==PriceSupportUtil.UPFRONT){
            doUpfrontCalculation();
        }
        if(validate()){
            if(PriceSupportUtil.checkNexeoApprover(priceSupport.Nexeo_Group__c)){
                priceSupport.Status__c = PriceSupportUtil.AWAITING_SUPPLIER_APPROVAL;
                priceSupport.Submitted_to_Supplier_by__c = System.Userinfo.getName();
                priceSupport.Submitted_to_Supplier_Date__c = System.today();
            }else{
                priceSupport.Status__c = PriceSupportUtil.AWAITING_NEXEO_APPROVAL;
            }
            priceSupport.Initial_Submitter__c = System.Userinfo.getName();
            priceSupport.Initial_Submitter_Date__c = System.Today();
            return customsave();
            
        }else{
            return null;
        }
        
         
     }
     
      /**  
    * @Name awaitingSupplierApproval
    * @Purpose Used to send remider email to supplier. 
    * @param 
    * @return 
    * @Author  Deepak
    */ 
     
     public PageReference awaitingSupplierApproval(){
        
        String Emailid = '';
        
        if(priceSupport.Supplier_Main_Approver1__c!=null)
            Emailid=priceSupport.Supplier_Main_Approver_Email__c;
            
        EmailTemplate emailTemplate = [SELECT id FROM EmailTemplate WHERE developerName ='price_support_request'];
        PageReference pageRef = new PageReference('/email/author/emailauthor.jsp?retURL=%2F'+priceSupport.Id+'&p3_lkid='+priceSupport.Id+'&p24='+Emailid+'&rtype=003&template_id='+emailTemplate.id+'&save=1');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    /**  
    * @Name submitForApproval
    * @Purpose Used to submit a price support for approval. 
    * @param 
    * @return 
    * @Author  Deepak
    */ 
    
     public PageReference submitForApproval(){
        if(validate()){
            if(PriceSupportUtil.checkNexeoApprover(priceSupport.Nexeo_Group__c)){
                priceSupport.Status__c = PriceSupportUtil.AWAITING_SUPPLIER_APPROVAL;
                priceSupport.Submitted_to_Supplier_by__c = System.Userinfo.getName();
                priceSupport.Submitted_to_Supplier_Date__c = System.today();
            }else{
                priceSupport.Status__c = PriceSupportUtil.AWAITING_NEXEO_APPROVAL;
            }
            priceSupport.Initial_Submitter__c = System.Userinfo.getName();
            priceSupport.Initial_Submitter_Date__c = System.Today();
            Update priceSupport;
            PageReference pageRef = Page.PriceSupportView;
            pageRef.getParameters().put('Id',priceSupport.Id);
            pageRef.setRedirect(true);
            return pageRef;
        }else{
            return null;
        }
        
     }
     //TODO
     Public pagereference saveandresubmit(){
      
        customsave();
        return resubmit();
       
     }
     
    /**  
    * @Name resubmit
    * @Purpose Used to resubmit a price support for approval. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
     public PageReference resubmit(){
        
        priceSupport.Status__c = AWAITING_SUPPLIER_APPROVAL;
        if(comments!=null && !comments.equals('')){
            priceSupport.Additional_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Additional_Comments__c);
        }
        update priceSupport;
        PageReference pageRef = Page.PriceSupportView;
        pageRef.getParameters().put('Id',priceSupport.Id);
        pageRef.setRedirect(true);
        return pageRef;
        
     }
     /**  
    * @Name acceptConditionalApproval
    * @Purpose Used to accept a conditional approval. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
     public PageReference acceptConditionalApproval(){
        
        priceSupport.Status__c = PriceSupportUtil.APPROVED;
        if(priceSupport.Support_Type__c ==PriceSupportUtil.REBATE){
            priceSupport.SAP_Transfer__c = PriceSupportUtil.OPEN;
        }
        priceSupport.Final_Action_by__c = System.Userinfo.getName();
        priceSupport.Final_Action_by_Date__c = System.now();
        if(comments!=null && !comments.equals('')){
            priceSupport.Additional_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Additional_Comments__c);
        }
        update priceSupport;
        PageReference pageRef = Page.PriceSupportView;
        pageRef.getParameters().put('Id',priceSupport.Id);
        pageRef.setRedirect(true);
        return pageRef;
        
     }
     
      /**  
    * @Name supplierApproval
    * @Purpose Used to perform a supplier approval. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
     public PageReference supplierApproval(){
        
        priceSupport.Status__c = APPROVED;
        if(priceSupport.Support_Type__c ==REBATE){
            priceSupport.SAP_Transfer__c = OPEN;
        }else{
             priceSupport.SAP_Transfer__c ='';
        }
        if(comments!=null && !comments.equals('')){
            priceSupport.Additional_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Additional_Comments__c);
        }
        priceSupport.Supplier_1st_Action_by__c = System.Userinfo.getName();
        priceSupport.Supplier_1st_Action_Date__c = System.today();
        priceSupport.Final_Action_by__c = System.Userinfo.getName();
        priceSupport.Final_Action_by_Date__c = System.now();
        update priceSupport;
        
        PageReference pageRef = Page.PriceSupportView;
        pageRef.getParameters().put('Id',priceSupport.Id);
        pageRef.setRedirect(true);
        return pageRef;
        
     }
     
    /**  
    * @Name nexeoApproval
    * @Purpose Used to perform a Nexeo approval. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
     public PageReference nexeoApproval(){
        
        priceSupport.Status__c = AWAITING_SUPPLIER_APPROVAL;
        priceSupport.Submitted_to_Supplier_by__c = System.Userinfo.getName();
        priceSupport.Submitted_to_Supplier_Date__c = System.today();
        if(comments!=null && !comments.equals('')){
            priceSupport.Additional_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Additional_Comments__c);
        }
        update priceSupport;
        PageReference pageRef = Page.PriceSupportView;
        pageRef.getParameters().put('Id',priceSupport.Id);
        pageRef.setRedirect(true);
        return pageRef;
     }
     
     /**  
    * @Name supplierRejection
    * @Purpose Used to perform a supplier Rejection. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
     public PageReference supplierRejection(){
        
        priceSupport.Status__c = REJECTED_BY_SUPPLIER;
        priceSupport.Supplier_1st_Action_by__c = System.Userinfo.getName();
        priceSupport.Supplier_1st_Action_Date__c = System.today();
        if(comments!=null && !comments.equals('')){
            priceSupport.Additional_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Additional_Comments__c);
        }
        update priceSupport;
        PageReference pageRef = Page.PriceSupportView;
        pageRef.getParameters().put('Id',priceSupport.Id);
        pageRef.setRedirect(true);
        return pageRef;
     }
     
     /**  
    * @Name nexeoRejection
    * @Purpose Used to perform a Nexeo Rejection. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
     public PageReference nexeoRejection(){
        
        priceSupport.Status__c = REJECTED;
        if(comments!=null && !comments.equals('')){
            priceSupport.Nexeo_Only_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Nexeo_Only_Comments__c);
        }
        update priceSupport;
        PageReference pageRef = Page.PriceSupportView;
        pageRef.getParameters().put('Id',priceSupport.Id);
        pageRef.setRedirect(true);
        return pageRef;
        
     }
     
     /**  
    * @Name decline
    * @Purpose Used to perform a decline. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
     public PageReference decline(){
        
        priceSupport.Status__c = DECILNED;
        priceSupport.Supplier_1st_Action_by__c = System.Userinfo.getName();
         if(comments!=null && !comments.equals('')){
            priceSupport.Additional_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Additional_Comments__c);
        }
        priceSupport.Supplier_1st_Action_Date__c = System.today();
        Update priceSupport;
        PageReference pageRef = Page.PriceSupportView;
        pageRef.getParameters().put('Id',priceSupport.Id);
        pageRef.setRedirect(true);
        return pageRef;
        
     }
     
      /**  
    * @Name conditionalApproval
    * @Purpose Used to perform a conditional approval. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
     public PageReference conditionalApproval(){
        
        PageReference pageRef = null;
        
        if(conditionalApprovalValidation()){
        
            priceSupport.Status__c = PriceSupportUtil.CONDITIONALLY_APPROVED;
            priceSupport.Supplier_1st_Action_by__c = System.Userinfo.getName();
            if(comments!=null && !comments.equals('')){
                priceSupport.Additional_Comments__c = System.now()+' '+comments+'\n'+nullCheck(priceSupport.Additional_Comments__c);
            }
            priceSupport.Supplier_1st_Action_Date__c = System.today();
            if(priceSupport.Support_Type__c==PriceSupportUtil.REBATE && priceSupport.Support_Type__c!=PriceSupportUtil.FLAT){
                doRebateCalculation();
            }else {
                
                update PriceSupportUtil.doUpfrontCalculation(getPricingList());
            }
            update priceSupport;
            
            String supplier = ApexPages.currentPage().getParameters().get('Supplier');
            System.debug('--------Completed Conditional approval----supplier------'+supplier);
            if(supplier!=null && supplier.equalsIgnoreCase('true')){
                pageRef = Page.PriceSupportSupplierView;
                pageRef.getParameters().put('Id',priceSupport.Id);
                pageRef.setRedirect(true);
            }else{
                pageRef = Page.PriceSupportView;
                pageRef.getParameters().put('Id',priceSupport.Id);
                pageRef.setRedirect(true);
            }
            
        }
        
            return pageRef;
        
     }
     
    /**  
    * @Name conditionalApprovalValidation
    * @Purpose Used to perform validation before conditional approval. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
    @TestVisible private boolean conditionalApprovalValidation(){
     
        boolean status = true;
        
        if(priceSupport.Effective_Date__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please enter Effective date'));
            status= false;
        }
        
         if(priceSupport.Support_Type__c==PriceSupportUtil.REBATE){
            if(priceSupport.Flat_or_Purchased__c==PriceSupportUtil.PURCHASED){
                if(priceSupport.Net_Support_Cost__c==null||priceSupport.Net_Support_Cost__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Net Support Cost should be greater than zero'));
                    status= false;
                }else if(priceSupport.Net_Purchase_Cost__c==null || priceSupport.Net_Purchase_Cost__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Net Purchase Cost should be greater than zero'));
                    status= false;
                }else if(priceSupport.Requested_Rebate_Amount__c==null || priceSupport.Requested_Rebate_Amount__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Requested Rebate Amount should be greater than zero'));
                    status= false;
                }
            }else{
                if(priceSupport.Requested_Rebate_Amount__c==null || priceSupport.Requested_Rebate_Amount__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Requested Rebate Amount should be greater than zero'));
                    status= false;
                }
            }
        }else if(priceSupport.Support_Type__c==PriceSupportUtil.UPFRONT){
            for(Bracketed_Pricing__c priceObj :pricingList){
            
                if((priceObj.Price__c!=null && priceObj.Price__c!=0) && (priceObj.Net_Price__c==null || priceObj.Net_Price__c<=0 )){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Net Price should be greater than zero'));
                    status= false;
                    break;
                }
            }
        }
        
        return status;
     
     }
     
      /**  
    * @Name validate
    * @Purpose Used to perform validation before submitting for approval. 
    * @param 
    * @return 
    * @Author  Deepak
    */
     
    @TestVisible private boolean validate(){
        
        boolean status = true;
        if(priceSupport.Support_Type__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Support Type'));
            status= false;
        }else if(priceSupport.New_or_Changed__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select New or Changed'));
            status= false;
        }else if(priceSupport.Order_Type__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Order Type'));
            status= false;
        }else if(priceSupport.Mode__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Mode'));
            status= false;
        }else if(priceSupport.Nexeo_Group__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Nexeo Group'));
            status= false;
        }else if(priceSupport.Supplier_Profile_ID__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Supplier Profile'));
            status= false;
        }else if(priceSupport.Supplier_Group__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Supplier Group'));
            status= false;
        }else if(priceSupport.Customer_Name__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Customer'));
            status= false;
        }else if(priceSupport.Material_Buying__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Material Buying'));
            status= false;
        }else if(priceSupport.UOM__c==null || priceSupport.UOM__c==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please enter UOM.'));
            status= false;
        }/*else if(priceSupport.Expiration_Date__c==null && priceSupport.Review_Date__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please enter Expiration date or Review date'));
            status= false;
        }*/else if(priceSupport.Effective_Date__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please enter Effective date'));
            status= false;
        }else if(priceSupport.Expiration_Date__c!=null && priceSupport.Expiration_Date__c<priceSupport.Effective_Date__c){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Expiration date should be greater than Effective Date'));
            status= false;
        }else if(priceSupport.Customer_Type__c==null ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please enter Customer Type'));
            status= false;
           

        }else if(priceSupport.Customer_Type__c=='PY-Payer' && priceSupport.Customer_Soldto__c==null){
             system.debug('--------------priceSupport.Customer_Type__c-----'+priceSupport.Customer_Type__c);
            system.debug('--------------priceSupport.Customer_Soldto__c-----'+priceSupport.Customer_Soldto__c);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'This record cannot be submitted for approval and sent to SAP for Transfer as the Sold to Customer Information is missing. Please get this corrected before Submitting the record for Approval.'));
            status= false;
        }
        
        
        if(priceSupport.Support_Type__c=='Rebate'){
            if(priceSupport.Flat_or_Purchased__c==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Flat or Purchased'));
                status= false;
            }
            
            if(priceSupport.Material_Selling__c==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Please select Material Selling'));
                status= false;
            }
            if(priceSupport.Debit_Memo_Contact1__c==null||priceSupport.Debit_Memo_Contact1__c==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Supplier does not have a Debit Memo Contact.'));
            status= false;
            }
            if(priceSupport.Flat_or_Purchased__c==PriceSupportUtil.PURCHASED){
                if(priceSupport.Net_Support_Cost__c==null||priceSupport.Net_Support_Cost__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Net Support Cost should be greater than zero'));
                    status= false;
                }else if(priceSupport.Net_Purchase_Cost__c==null || priceSupport.Net_Purchase_Cost__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Net Purchase Cost should be greater than zero'));
                    status= false;
                }else if(priceSupport.Requested_Rebate_Amount__c==null || priceSupport.Requested_Rebate_Amount__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Requested Rebate Amount should be greater than zero'));
                    status= false;
                }
            }else{
                if(priceSupport.Requested_Rebate_Amount__c==null || priceSupport.Requested_Rebate_Amount__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Requested Rebate Amount should be greater than zero'));
                    status= false;
                }
            }
        }else if(priceSupport.Support_Type__c=='Upfront'){
            
            for(Bracketed_Pricing__c priceObj :pricingList){
            
                if( (priceObj.Price__c!=null && priceObj.Price__c!=0) && (priceObj.Net_Price__c==null || priceObj.Net_Price__c<=0)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Net Price should be greater than zero'));
                    status= false;
                    break;
                }
            }
        }
        
        List <String> duplicates = PriceSupportUtil.checkDuplicatePriceSupport(priceSupport);
        
        if(duplicates!=null && !duplicates.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Duplicate Support Ids '+duplicates +' found.Please use Mass Change, Mass Price Change or Price Change if you are trying to do a price change on existing support.'));
            status= false;
        }
        
        return status;
     }
     
 
  /**  
    * @Name validateduringRenewal
    * @Purpose Used to perform validation when price support is renewing and save. 
    * @param 
    * @return 
    * @Author  Chandrakant
    */
     
    @TestVisible private boolean validateduringRenewal(){
        
        boolean status = true;
        if(priceSupport.Support_Type__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please select Support Type'));
            status= false;
        }else if(priceSupport.New_or_Changed__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please select New or Changed'));
            status= false;
        }else if(priceSupport.Order_Type__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please select Order Type'));
            status= false;
        }else if(priceSupport.Supplier_Profile_ID__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please select Supplier Profile'));
            status= false;
        }else if(priceSupport.Customer_Name__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please select Customer'));
            status= false;
        }else if(priceSupport.Material_Buying__c==null){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please select Material Buying'));
            status= false;
        }else if(priceSupport.Customer_Type__c==null ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please enter Customer Type'));
            status= false;
        
        }
        
        
        if(priceSupport.Support_Type__c=='Rebate'){
            if(priceSupport.Flat_or_Purchased__c==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please select Flat or Purchased'));
                status= false;
            }
            
            if(priceSupport.Material_Selling__c==null){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Please select Material Selling'));
                status= false;
            }
            if(priceSupport.Debit_Memo_Contact1__c==null||priceSupport.Debit_Memo_Contact1__c==''){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Supplier does not have a Debit Memo Contact.'));
            status= false;
            }
            if(priceSupport.Flat_or_Purchased__c==PriceSupportUtil.PURCHASED){
                if(priceSupport.Net_Support_Cost__c==null||priceSupport.Net_Support_Cost__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Net Support Cost should be greater than zero'));
                    status= false;
                }else if(priceSupport.Net_Purchase_Cost__c==null || priceSupport.Net_Purchase_Cost__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Net Purchase Cost should be greater than zero'));
                    status= false;
                }else if(priceSupport.Requested_Rebate_Amount__c==null || priceSupport.Requested_Rebate_Amount__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Requested Rebate Amount should be greater than zero'));
                    status= false;
                }
            }else{
                if(priceSupport.Requested_Rebate_Amount__c==null || priceSupport.Requested_Rebate_Amount__c<=0){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Requested Rebate Amount should be greater than zero'));
                    status= false;
                }
            }
        }else if(priceSupport.Support_Type__c=='Upfront'){
            
            for(Bracketed_Pricing__c priceObj :pricingList){
            
                if( (priceObj.Price__c!=null && priceObj.Price__c!=0) && (priceObj.Net_Price__c==null || priceObj.Net_Price__c<=0)){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Support # '+priceSupport.Support_ID__c + ' is skipped Net Price should be greater than zero'));
                    status= false;
                    break;
                }
            }
        }
        
        List <String> duplicates = PriceSupportUtil.checkDuplicatePriceSupportforMassChange(priceSupport);
        
        if(duplicates!=null && !duplicates.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error, 'Support # '+priceSupport.Support_ID__c + ' is skipped Duplicate Support Ids '+duplicates +' found.'));
            status= false;
        }
        
        return status;
     }
     
 
 
 
     /**
        @Author: Hani M on 07-25-2012 for showing field history based on the change done by the Supplier
     **/ 
    public List<FieldHistoryVO> getPriceHistories(){
        FieldHistoryVO priceVO;
        Schema.DescribeFieldResult fieldDescribe;
        List<Price_Support__History> priceHistory = [SELECT p.OldValue, p.NewValue, p.IsDeleted, p.Field, p.CreatedDate,p.CreatedBy.Name FROM Price_Support__History p WHERE p.ParentId =: priceSupport.id ORDER BY p.CreatedDate desc];
        if( priceHistory != null && priceHistory.size() >0 ){
            for( Price_Support__History pHistory:priceHistory ){
                priceVO = new FieldHistoryVO();
                String fieldName = String.ValueOf( pHistory.field );
                if(fieldMap.containsKey(fieldName))
                priceVO.fieldName = fieldMap.get(fieldName).getDescribe().getLabel();          
                priceVO.oldValue = String.ValueOf( pHistory.oldValue );
                priceVO.newValue = String.ValueOf( pHistory.newValue );
                priceVO.changedBy = pHistory.CreatedBy.Name;
                priceVO.changedDate = ((Datetime) pHistory.CreatedDate).format('MM/dd/yyyy hh:mm:ss');
                priceHistories.add( priceVO );
            }        
        }
        
        return priceHistories;
    }
    
               
     
}