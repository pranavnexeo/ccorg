/**  
* @Name PriceSupportExtension
* @Purpose This is the main Extension class for PriceSupport Object and it contains most of the business logic.
* @Author  Rajeev
* @Version 1.0 
*/
public with sharing class PriceSupportExtensionRequest {
        
    private List<Bracketed_Pricing__c> pricingList = new List<Bracketed_Pricing__c>();
    private List<String> supplierDmContactNumberList = new List<String>();
    private List<SelectOption> supplierDmContactNameList = new List<SelectOption>();
    private List<SelectOption> territoryList = new List<SelectOption>();
    private final Price_Support_Request__c priceSupport;
    private final ApexPages.StandardController priceSupportController;
    private Supplier_Profile__c supplierProfile = null;
    public boolean insertFlag{get;set;}
    private final String objectName = 'Price_Support_Request__c';
    private Static Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Price_Support_Request__c.fields.getMap();
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
    public String subtitle{get;set;}
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
    * @Author Rajeev
    */   
    public PageReference customEdit(){
    system.debug('Custom edit called');
        PageReference pageRef;
        String rid = ApexPages.currentPage().getParameters().get('rid');
        String returl = ApexPages.currentPage().getParameters().get('returl');
        Map<String, Schema.RecordTypeInfo> RTMap = Price_Support_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        if(rid == RTMap.get('Rebate').getrecordtypeid()){
        pageref = new PageReference('/apex/PriceSupportRequestRebate?id='+priceSupport.Id+'&rid='+rid+'&returl='+returl);
        pageref.setRedirect(true);
        }else if(rid == RTMap.get('Upfront').getrecordtypeid()){
        pageref = new PageReference('/apex/PriceSupportRequestUpfront?id='+priceSupport.Id+'&rid='+rid+'&returl='+returl);
        pageref.setRedirect(true);
        }else{
        pageref = null;
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
    * @Author  Rajeev
    */     
    public PriceSupportExtensionRequest (ApexPages.StandardController controller) {
                String Id = ApexPages.currentPage().getParameters().get('id');
                
                priceSupport = (Price_Support_Request__c)controller.getRecord();
                this.priceSupportController = controller;
                String rid = ApexPages.currentPage().getParameters().get('rid');
                priceSupport.Sales_Organization__c = '1000';
                priceSupport.Division_Number__c = '31';
                priceSupport.Customer_Type__c = 'PY-Payer';
                priceSupport.Distribution_Channel__c = '30';
                system.debug('priceSupport name is: '+priceSupport);
                Map<String, Schema.RecordTypeInfo> rtmap = Price_Support_Request__c.getSObjectType().getDescribe().getRecordTypeInfosByName();
                if(rid == rtmap.get('Rebate').getrecordtypeid()){
                priceSupport.Support_type1__c = 'Rebate';
                }else{
                priceSupport.Support_type1__c = 'Upfront';
                }
                dispCheckBox = true;
                
               
                getPlants();

    }

    
    /**  
    * @Name customSave
    * @Purpose This method is used save the Price Support.
    * @param 
    * @return PageReference
    * @Author Rajeev
    */     
   
    public PageReference customSave(){
     
        String rid = ApexPages.currentPage().getParameters().get('rid');
        
        String returl = ApexPages.currentPage().getParameters().get('returl');
        PageReference pageRef;
        Map<String, Schema.RecordTypeInfo> RTMap = Price_Support_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
        if(validate()){
        pricesupport.recordtypeid = rid;
        //pricesupport.status__c = 'Open';
        
        system.debug('price support is'+pricesupport);
        //pricesupportcontroller.save();
        upsert pricesupport;
        if(rid == RTMap.get('Rebate').getrecordtypeid()){
        pageref = new PageReference('/apex/PriceSupportRequestRebateView?id='+pricesupport.id+'&rid='+rid+'&returl='+returl);
        pageref.setRedirect(true);
        }else if(rid == RTMap.get('Upfront').getrecordtypeid()){
        pageRef = new PageReference('/apex/PriceSupportRequestUpfrontView?id='+pricesupport.id+'&rid='+rid+'&returl='+returl);
        pageref.setRedirect(true);
        }else{
        pageref = null;
        }}
        return pageRef;
        
    }
    
    /**  
    * @Name getRegionDetails
    * @Purpose This method is used to get the region deatils on click of Region Checkbox
    * @param 
    * @return 
    * @Author  Rajeev
    */   
     public void getRegionDetails(){
     system.debug('inside region method');
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
    
    /**  
    * @Name getPricing
    * @Purpose This method is used fetch details from the supplier profile selected.
    * @param 
    * @return 
    * @Author  Rajeev
    */   
    public void getPricing(){
        
        System.debug('---------selected supplier profile-----------'+Apexpages.currentPage().getParameters().get('supplierProfile'));
        
        //priceSupport.Supplier_Group__c = null;
        //priceSupport.Supplier_Main_Approver__c =  null;
        //priceSupport.Supplier_Group_Name__c = '';
        
        
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
                        //priceSupport.Street_Address__c = supplierProfile.Supplier_Street_Address__c;
                        priceSupport.Supplier_Name__c = supplierProfile.Supplier_Name__r.Name;
                        priceSupport.Supplier_Number__c = supplierProfile.Supplier_Number__c;
                        //priceSupport.Supplier_PI_Number__c = supplierProfile.Vendor_PI__c;
                        priceSupport.Application__c = supplierProfile.Potential_Applications__c; 
                        //priceSupport.Adjust_for_PO_Difference__c = supplierProfile.Adjust_for_PO_Price_Difference__c;
                        //priceSupport.Match_to_PO_Required__c = supplierProfile.Match_to_PO_Required__c;
                        if(supplierProfile.of_rows_for_Bracketed_Pricing__c!=null){
                            noOfRows = Integer.valueOf(supplierProfile.of_rows_for_Bracketed_Pricing__c);
                        }
                        
                        System.debug('--------Required Fields--------'+supplierProfile.Required_Fields__c);
                        System.debug('--------Supplier_Name__c--------'+supplierProfile.Supplier_Name__r.Name);
                        
                        String reqFields = supplierProfile.Required_Fields__c;
                        if(reqFields!=null){
                            //setDynamicReqFields(reqFields);
                        }
                        
                        if(priceSupport.Support_Type__c==PriceSupportUtil.REBATE){
                                //getPartnerFunctionCode(supplierProfile.Supplier_Name__c);
                        }
                        
                        
                        
         }else{
                        priceSupport.city__c = '';
                        priceSupport.State_Province__c = '';
                        //priceSupport.Street_Address__c = '';
                        priceSupport.Supplier_Name__c = '';
                        priceSupport.Supplier_Number__c = '';
                        //priceSupport.Supplier_PI_Number__c = '';
         
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
    * @Name populateMaterialData
    * @Purpose This method is used to get the details from Material selected.
    * @param 
    * @return 
    * @Author  Rajeev
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
            
            
            if(materialType!=null && materialType.equalsIgnoreCase('Selling')){
                
                priceSupport.Material_Code_Selling__c = material.Material_Number__c;
                priceSupport.Material_Description_Selling__c = material.Material_Desc__c;
                //priceSupport.Material_Buying__c = materialId;
                
                //priceSupport.Container_Type_Buying__c = material.Material_General_Data__r.Material_Container_Desc__c;
                
                
                //priceSupport.Base_Material_Code_Buying__c = material.Material_Base_Code__c;
                //To set Material Group2 value -anj
                //priceSupport.Material_Group_2_Buying__c = material.Material_Group2_Code__c;
                //System.debug('----------priceSupport.Material_Description_Buying__c---------'+priceSupport.Material_Description_Buying__c);
                //System.debug('----------priceSupport.Material_Description_Selling__c---------'+priceSupport.Material_Description_Selling__c);
                
            }else if(materialType!=null && materialType.equalsIgnoreCase('Buying')){
                
                //priceSupport.Material_Buying__c = materialId;
                //priceSupport.Container_Type_Buying__c = material.Material_General_Data__r.Material_Container_Desc__c;
                priceSupport.Material_Code_Buying__c = material.Material_Number__c;
                priceSupport.Material_Description_Buying__c = material.Material_Desc__c;
                //priceSupport.Base_Material_Code_Buying__c = material.Material_Base_Code__c;//Uncomment if deafulr Uom needs to be populated
               //To set Material Group2 value -anj
                //priceSupport.Material_Group_2_Buying__c = material.Material_Group2_Code__c;
                if(priceSupport.Support_Type__c=='Upfront'){
                
                    
                }
            
            }
        
        }
        
    }
    
     
    /**  
    * @Name getPlants
    * @Purpose This method is used to fetch plants from SAP_Plant__c table.
    * @param 
    * @return 
    * @Author  Rajeev
    */
    @TestVisible 
     private void getPlants(){
     
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
    * @Author  Rajeev
    */ 
     public void getPlantCode(){
     
        String plantName = ApexPages.currentPage().getParameters().get('plantName');
        
        if(plantName!=null && plantName.contains('-')){
         String[] plantDeatils = plantName.split('-');
         System.debug('---------Plant Code --------'+plantDeatils[1]);
         priceSupport.Hub__c = plantDeatils[1];
        }
        
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
    
    * @Name getCustomerDetails
    * @Purpose This method is used to get the deatils from the Customer selected.
    * @param 
    * @return 
    * @Author  Rajeev
    */   
     public void getCustomerDetails(){
        
        String customerId = ApexPages.currentPage().getParameters().get('customerId');
        String custType = ApexPages.currentPage().getParameters().get('custType');
        String soldToId = ApexPages.currentPage().getParameters().get('soldToId');
        String payerNo = ApexPages.currentPage().getParameters().get('payerNo');
        String region = ApexPages.currentPage().getParameters().get('region');
        dispCheckBox = true;
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
                //priceSupport.Territory__c = '';
                //priceSupport.Sales_Group_Desc__c = '';
                //priceSupport.Seller__c ='';
                //priceSupport.Customer_City__c = '';
                //priceSupport.Customer_State_Province__c = '';
                priceSupport.All_Regions__c = false;
                dispCheckBox = false;
                priceSupport.Region_Code__c = '';
                 

            
            }
     
     }
     /**  
    * @Name setSalesGroup
    * @Purpose When the customer is of Payer type the Customer Number and Name is from Payer but 
    *          Sales Group ,Seller, Territory etc are selected from the Sold To party for that Payer.
    * @param 
    * @return 
    * @Author  Rajeev
    */ 
     @TestVisible
     private  void setSalesGroup(String customerId, String custType){
     
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
    /** @Name validate
    * @Purpose Used to perform validation before submitting for approval. 
    * @param 
    * @return 
    * @Author  Rajeev
    */
     @TestVisible
     private boolean validate(){
     String errMsg = 'Please Select ';
     boolean status = true;
        if(priceSupport.Status__c==null){
            errMsg = errMsg +'Status';
        }if(priceSupport.New_or_Changed__c==null){
             if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'New or Changed';
             else errMsg = errMsg +'New or Changed';
        }if(priceSupport.Order_Type__c==null){
             if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Order Type';
             else errMsg = errMsg +'Order Type';
       }if(priceSupport.Mode__c==null && pricesupport.Support_Type1__c == 'Upfront'){
             if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Mode';
             else errMsg = errMsg +'Mode';
        }if(priceSupport.Flat_or_Purchased__c==null){
            if(errMsg != 'Please Select ')
                 errMsg = errMsg +','+'Flat Or Purchased';
             else errMsg = errMsg +'Flat Or Purchased';
        }if(priceSupport.Sales_Organization__c ==null){
            if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Sales Organization';
             else errMsg = errMsg +'Sales Organization';
        }if(priceSupport.Customer_Name__c ==null){
            if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Customer Name';
             else errMsg =errMsg +'Customer Name'; 
        }if(priceSupport.Supplier_Profile_ID__c==null && pricesupport.support_type1__c == 'Upfront'){
            if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Supplier Profile';
             else errMsg =errMsg +'Supplier Profile';
        }if(priceSupport.Customer_Type__c ==null){
            if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Customer Type';
             else errMsg =errMsg +'Customer Type';
        }if(priceSupport.Competitor_Name__c ==null){
           if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Competitor Name';
             else errMsg =errMsg +'Competitor Name';
        }if(priceSupport.Material_Selling__c ==null && pricesupport.support_type1__c == 'Rebate'){
             if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Material(Selling)';
             else errMsg =errMsg +'Material(Selling)';
        }if(priceSupport.Material_Buying__c ==null && pricesupport.support_type1__c == 'Upfront'){
             if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Material(Buying)';
             else errMsg =errMsg +'Material(Buying)';
        }if(priceSupport.UOM__c ==null){
             if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'UOM';
             else errMsg =errMsg +'UOM';
         }if(priceSupport.Effective_Date__c==null ){
             if(errMsg !='Please Select ')
                 errMsg = errMsg +','+'Effective Date';
             else errMsg =errMsg +'Effective Date';
        }
        
        if(errMsg != 'Please Select '){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,errMsg));
            status= false;
        }
        
        if(priceSupport.Expiration_Date__c!=null && priceSupport.Expiration_Date__c<priceSupport.Effective_Date__c){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.Error,'Expiration date should be greater than Effective Date'));
            status= false;
        }
        return status;
     }
}