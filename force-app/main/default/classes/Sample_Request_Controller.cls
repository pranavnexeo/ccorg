public class Sample_Request_Controller {
    

    public boolean displayerror;
    public boolean sapmaterror;
    public string contactFromURL{Get; set;}
    public boolean hasOpportunity{get; set;}
    
    public Sample_Request_Controller(ApexPages.StandardController controller) {

         hasOpportunity = true;
         string objectName = controller.getrecord().getSobjectType().getDescribe().getName();
         
       if(controller.getRecord().Id != null)
       {
         if(objectName == 'Account')
           System.currentPageReference().getParameters().put('accountId', controller.getrecord().id);
         else if(objectName == 'Sample_Request__c')
           System.currentPageReference().getParameters().put('sampleRequestId', controller.getrecord().id);
         else if(objectName == 'Contact')
           System.currentPageReference().getParameters().put('ContactId', controller.getrecord().id);
         else if(objectName == 'Opportunity')
           System.currentPageReference().getParameters().put('OpportunityId', controller.getrecord().id);
       }
         init();
    }
    
    public Sample_Request_Controller() {
    }


  private static final Map<Id,String> ACCOUNT_RECTYPES = RecordType_Functions.RetrieveRecordTypeIdMap('Account');
  private static final Map<String, Schema.RecordTypeInfo> SAMP_RECTYPES = Sample_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  private static final String REC_TYPE_AAFI_1 = 'Aqualon Customer';
  private static final String REC_TYPE_AAFI_2 = 'Aqualon Other Account';
  private static final String REC_TYPE_AAFI_3 = 'Aqualon Prospect';
  private static final String REC_TYPE_AD_1 = 'Distribution Customer';
  private static final String REC_TYPE_AD_2 = 'Distribution Prospect';
  private static final String REC_TYPE_AD_3 = 'Distribution Prospect - Plastics';
  private static final String REC_TYPE_AD_4 = 'Distribution Other Account';
  private static final String REC_TYPE_AD_5 = 'Distribution RTK Prospect';
  private static final String REC_TYPE_AHWT_1 = 'Drew Customer';
  private static final String REC_TYPE_AHWT_2 = 'Drew Other Account';
  private static final String REC_TYPE_AHWT_3 = 'Water Prospect';
  private static final Set<String> NA_SALES_ORGS = new Set<String>{ '1000', '1031', '1800', '1700' };

  Account account;
  String accountRecordType;
  Contact contact;
  Opportunity opportunity;
  public Sample_Request__c sampleRequest;
  Sample_Request__c AccountAddressEntry;
  Sample_Request__c ContactAddressEntry;
  Sample_Request__c ManualAddressEntry;
  public Sample_Request_Aquarius__c aquarius {get; set;}
  public List<Sample_Material__c> sampleMaterials;
  String ValidationErrorMessage = '';
  public boolean emailcsrgroupbox{get; set;}
  public boolean renderemailcsrgroupbox{get; set;}
  public String getValidationErrorMessage() {return ValidationErrorMessage;}
  public String Carrier{get; set;}
  public task onhold_followup_task{get; set;}
  
  public PageReference step1() {  return Page.Sample_Request_Wizard_Step_1;}
  public PageReference step2A() { return Page.Sample_Request_Wizard_Step_2A;}
  
  public pagereference step3() {
    
    PageReference result = null;
    if (Step2C_Valid() == true)
      {result = Page.Sample_Request_Wizard_Step_3;
       result.getParameters().put('contactId',  contactSelected);
       result.getParameters().put('oppId',  opportunitySelected);
       result.getParameters().put('AccountId', Account.Id);
      }
    return result;  
    
  }
  
  public pagereference step2C() {
    
    PageReference result = null;
    if (Step2A_Valid() == true && apexpages.currentpage().getparameters().containskey('oppId')){
       result = Page.Sample_Request_Wizard_Step_3;
       result.getParameters().put('contactId',  contactSelected);
       result.getParameters().put('oppId', apexpages.currentpage().getparameters().get('oppId'));
       result.getParameters().put('AccountId', Account.Id);
    }else if(step2A_Valid() == true)
      {result = Page.Sample_Request_Wizard_Step_2C;
       result.getParameters().put('contactId',  contactSelected);
       result.getParameters().put('AccountId', Account.Id);
      }
    return result;  
    
  }
    public PageReference step4() {

      PageReference result = null;
      if (Step3_Valid() == true) 
        {
        if(AddressManualEntry_Account_Visible == true)
          {
          copyAddressInfoBetweenSampleRequests(AccountAddressEntry, sampleRequest);
          sampleRequest.Ship_To_Address_Type__c = 'Manually Entered Address';
          copyAddressInfoBetweenSampleRequests(AccountAddressEntry, ManualAddressEntry);
          AddressManualEntry_Account_Visible = false;
          }
        if(AddressManualEntry_Contact_Visible == true)
          {
          copyAddressInfoBetweenSampleRequests(ContactAddressEntry, sampleRequest);
          sampleRequest.Ship_To_Address_Type__c = 'Manually Entered Address';
          copyAddressInfoBetweenSampleRequests(ContactAddressEntry, ManualAddressEntry);
          AddressManualEntry_Contact_Visible = false;
          }
        if(AddressManualEntry_Visible == true)
          {
          copyAddressInfoBetweenSampleRequests(ManualAddressEntry, sampleRequest);
          sampleRequest.Ship_To_Address_Type__c = 'Manually Entered Address';
          }
        
        result = Page.Sample_Request_Wizard_Step_4;
        }
      return result;
    }
    
    private Pagereference populateMaterialNames(){
        displayerror = false;
        sapmaterror = false;
        Set<Id> sapmaterialids = new Set<Id>();
        for(Sample_Material__c sm : sampleMaterials){
            sapmaterialids.add(sm.SAP_Material_MSD2__c);
        }
        Map<Id,Material_Sales_Data2__c> msd2map = new Map<Id,Material_Sales_Data2__c>([Select Id,Name,Material_Desc__c from Material_Sales_Data2__c where Id In :sapmaterialids]);
        for(Sample_Material__c sm : sampleMaterials){
              if(sm.Existing_Material_in_SAP__c == false && sm.SAP_Material_MSD2__c != null){
                 sm.Name = msd2map.get(sm.SAP_Material_MSD2__c).Material_Desc__c;
                }
              if(sm.Existing_Material_in_SAP__c == false && sm.SAP_Material_MSD2__c == null){
                 sapmaterror = true;
                 break; 
              }  
              if(sm.SAP_Material_MSD2__c != null && sm.name != null && sm.Existing_Material_in_SAP__c == true){
                displayerror = true;
                break;
                } 
            }
       return null;     
    }
    
    
    
    public PageReference step5() {
      populateMaterialNames();
      PageReference result = null;
      if (Step4_Valid() == true) 
        {
          populate_PM_CAST_Largest_Product_Line_Value_on_Sample();  
          populate_AD_Carrier_Number();
          
          performApprovalProcessing();
          
          sampleRequest.hold_Total_Line_Item_Costs__c = 0;
          sampleRequest.hold_Total_Value_of_Sample__c = 0;
          for(Sample_Material__c m:sampleMaterials)
            {
            sampleRequest.hold_Total_Line_Item_Costs__c += m.Additional_Admin_Cost__c;
            //sampleRequest.hold_Total_Value_of_Sample__c += m.Estimated_Sample_Value__c;
            }
          sampleRequest.hold_Total_Sample_Cost__c = sampleRequest.hold_Total_Value_of_Sample__c + sampleRequest.hold_Total_Line_Item_Costs__c + sampleRequest.Additional_Admin_Cost__c;
          
          
          result = Page.Sample_Request_Wizard_Step_5;
        }
      return result;
    }


  public void populate_PM_CAST_Largest_Product_Line_Value_on_Sample() {  

      String sampleRequest_Product_Line = '';
      Decimal sampleRequest_Product_Line_Value = -1;

      for(Sample_Material__c m:sampleMaterials)
        {
          //Product Line
          if ((m.PM_Castings_Product_Line__c != null) && (m.Estimated_Sample_Value__c != null))
            {
            if (m.Estimated_Sample_Value__c > sampleRequest_Product_Line_Value)
              {
              sampleRequest_Product_Line = m.PM_Castings_Product_Line__c;
              sampleRequest_Product_Line_Value = m.Estimated_Sample_Value__c;
              }
            }
            
        }

        if (sampleRequest_Product_Line != '')
            {sampleRequest.Largest_Material_by_Product_Line__c = sampleRequest_Product_Line;}    
        


  }    

    
  public Sample_Request__c getAccountAddressEntry() {return AccountAddressEntry;}
  public Sample_Request__c getContactAddressEntry() {return ContactAddressEntry;}
  public Sample_Request__c getManualAddressEntry() {return ManualAddressEntry;}
  
  public Decimal Additional_Cost_per_Sample = 0.0;
  public Decimal Additional_Cost_per_Line_Item = 0.0;
  public decimal AD_Default_Potential_Annual_Revenue = 1001.0;
  public integer AD_default_required_by_adder = 10;
  public decimal AD_Default_Estimated_Sample_Value = 51.0;
  public integer AD_Default_Qty = 1;
  public string AD_Default_UOM = 'Each(s)';



  public Boolean getRenderperSampleCost() {
    if (Additional_Cost_per_Sample > 0) {return true;} else {return false;}
  }

  public Boolean getRenderperLineItemCost() {
    if (Additional_Cost_per_Line_Item > 0) {return true;} else {return false;}
  }
  
  public PageReference init() {
    sampleRequest = getSampleRequest();
    
    if (AccountAddressEntry==null) {AccountAddressEntry = new Sample_Request__c();}
    if (ContactAddressEntry==null) {ContactAddressEntry = new Sample_Request__c();}
    if (ManualAddressEntry==null) {ManualAddressEntry = new Sample_Request__c();}

   
    if (sampleRequest.Ship_To_Address_Type__c == 'Manually Entered Address')
      {copyAddressInfoBetweenSampleRequests(sampleRequest, ManualAddressEntry);}


    contactFromURL = System.currentPageReference().getParameters().get('contactId');
    Boolean refresh_SampleRequest_Contact_Fields = false;
    system.debug('Contact Selected: ' + contactSelected);
    
    if ((sampleRequest.id != null) && (contactSelected == ''))
      {contactSelected = sampleRequest.Contact__c;}

    if (contactSelected == '') {
        if ((contactFromURL != '') && (contactFromURL != null)) {
            contactSelected = contactFromURL;
            if(contactFromURL != 'New Contact'){
            sampleRequest.Contact__c = contactSelected;
            refresh_SampleRequest_Contact_Fields = true;
            }
          }
      }
    else {
        if (contactSelected == 'New Contact') {
            if (sampleRequest.Contact__c != null) {
                sampleRequest.Contact_First_Name__c = '';
                sampleRequest.Contact_Last_Name__c = '';
                sampleRequest.Contact_Phone_Number__c = '';
                sampleRequest.Contact_email__c = '';
              }

            sampleRequest.Contact__c = null;
          }
        else {
            if (sampleRequest.Contact__c != contactSelected) {
                refresh_SampleRequest_Contact_Fields = true;
              }
            
            sampleRequest.Contact__c = contactSelected;
          }
      }

    if (sampleRequest.Account__c == null) {
        sampleRequest.Account__c = System.currentPageReference().getParameters().get('accountId');
      }
    if (sampleRequest.Opportunity__c == null) {
        
        string oppId = System.currentPageReference().getParameters().get('oppId');
        if(oppId != 'New Opportunity' && oppId != 'No Opportunity'){ sampleRequest.Opportunity__c = oppId; }
        else if(oppId == 'No Opportunity'){ sampleRequest.Opportunity__c = null; hasOpportunity = false;}
        else if(oppId == 'New Opportunity' && sampleRequest.Opportunity__r == null){ 
           opportunity = new Opportunity(
             AccountId = sampleRequest.Account__c,
             closeDate = system.today() + 30,
             StageName = 'Sample Requested'
            );
           sampleRequest.Opportunity__r = Opportunity;
        }

      }
    if (sampleRequest.Reason_for_Sample__c == null) {
        sampleRequest.Reason_for_Sample__c = System.currentPageReference().getParameters().get('reason');
      }

    contact = getContact();

    opportunity = getOpportunity();
    
    getSampleMaterials();    

    if ((sampleRequest.Account__c == null) && (sampleRequest.Contact__c != null)) {
        sampleRequest.Account__c = contact.AccountId;
      }
    if ((sampleRequest.Account__c == null) && (sampleRequest.Opportunity__c != null)) {
        sampleRequest.Account__c = opportunity.AccountId;
      }

    if (refresh_SampleRequest_Contact_Fields == true) {
        sampleRequest.Contact_First_Name__c = contact.FirstName;
        sampleRequest.Contact_Last_Name__c = contact.LastName;
        sampleRequest.Contact_Phone_Number__c = contact.Phone;
        sampleRequest.Contact_Email__c = contact.email;
      }

    if (sampleRequest.Ship_To_Address_Type__c == 'Manually Entered Address') {AddressManualEntry_Visible = true;}
    account = getAccount();
   
    ValidationErrorMessage = '';
    
    if(samplerequest.rush_sample__c != true){
        samplerequest.rush_sample__c = false;
    }    

    return null;
  }

  public boolean getGotAccount() {
    Boolean result = false;
    if (account != null) {result = true;}
    return result;
  }

  public boolean getGotContact() {
    Boolean result = false;
    if (contact != null) {result = true;}
    return result;
  }

  public boolean getGotOpportunity() {
    Boolean result = false;
    if (opportunity != null) {result = true;}
    return result;
  }

  public boolean getCreatingContact() {
    Boolean result = false;
    if ((contact == null) && (contactSelected == 'New Contact')) 
      {result = true;}
    return result;
  }

// Object Get Queries
  public Account getAccount() {
    
    sampleRequest = getSampleRequest();

    Boolean runQuery = false;

    if (sampleRequest.Account__c == null) {runQuery = false;account = null;} //If no account is associated with Sample, null the account object
    else 
      {
      if (account == null) {runQuery = true;} //SampleRequest has an account, but it has not been loaded, so load it
      else 
        {
        if (sampleRequest.Account__c != account.id) {runQuery = true;}  //The account on the Sample Request has changed, so load the new one.
        else {runQuery = false;}
        }
      }

    if (runQuery == true) 
      {
        try {
      account = [SELECT  id,
                         Name,
                         OwnerId,
                         SAP_Street__c,
                         SAP_StreetSuppl1__c,
                         SAP_StreetSuppl2__c,
                         SAP_StreetSuppl3__c,
                         SAP_City__c,
                         SAP_State__c,
                         SAP_Zip_Code__c,
                         SAP_Country__c,
                         SAP_Customer_Number__c,
                         SAP_SALES_ORG__C,
                         SAP_SALES_OFFICE__C,
                         SAP_SALES_OFFICE_DESC__C,
                         SALESOFFICE__C,
                         SAP_DISTCHANNEL__C,
                         SAP_DIST_CHANNEL_DESC__C,
                         SAP_DIVISIONCODE__C,
                         SAP_DIVISION_DESC__C,
                         SAP_SALESGROUP__C,
                         SAP_SALES_GROUP_DESC__C,
                         SAP_SALESDISTRICT__C,
                         SAP_SALES_DISTRICT_DESC__C,
                         SAP_REGION__C,
                         SAP_CSR__c, 
                         SAP_CSR_Email__c,
                         RecordTypeId,
                         RecordType.Name
                         FROM Account WHERE Id = : sampleRequest.Account__c];

          accountRecordType = ACCOUNT_RECTYPES.get(account.RecordTypeId);

          String accountRegion = '';                 
          accountRegion = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(account.SAP_Sales_Org__c);
                         
          Additional_Cost_per_Sample = Sample_Request_Fixed_Costs_Functions.Retrieve_Additional_Cost_per_Sample(account.RecordType.Name, accountRegion);
          Additional_Cost_per_Line_Item = Sample_Request_Fixed_Costs_Functions.Retrieve_Additional_Cost_per_Line_Item(account.RecordType.Name, accountRegion);
          
          sampleRequest.Additional_Admin_Cost__c = Additional_Cost_per_Sample;
          for (Sample_Material__c m:sampleMaterials) {m.Additional_Admin_Cost__c = Additional_Cost_per_Line_Item;}
          
         }
      catch (Exception e) {}
      }
    return account;
  }

  public Contact getContact() {

    sampleRequest = getSampleRequest();

    Boolean runQuery = false;

    if (sampleRequest.Contact__c == null) {runQuery = false;contact = null;} //If no contact is associated with Sample, null the contact object
    else 
      {
      if (contact == null) {runQuery = true;} //SampleRequest has an contact, but it has not been loaded, so load it
      else 
        {
        if (sampleRequest.Contact__c != contact.id) {runQuery = true;}  //The contact on the Sample Request has changed, so load the new one.
        else {runQuery = false;}
        }
      }

    if (runQuery == true) 
      {
        try {
        contact = [select id,
                   AccountId,
                   OwnerId,
                   LastName,
                   FirstName,
                   Name,
                   Salutation,
                   MailingStreet,
                   MailingCity,
                   MailingState,
                   MailingPostalCode,
                   MailingCountry,
                   Phone,
                   Fax,
                   Email
         from Contact where id = : sampleRequest.Contact__c];}
         catch (Exception e) {}
      }
    return contact;
  }

  public Opportunity getOpportunity() {

    sampleRequest = getSampleRequest();

    Boolean runQuery = false;

    if (sampleRequest.Opportunity__r == null && sampleRequest.Opportunity__c == null) {
     runQuery = false;
     
     
     } //If no opportunity is associated with Sample, null the opportunity object
    else 
      {
      if (opportunity == null) {runQuery = true;} //SampleRequest has an opportunity, but it has not been loaded, so load it
      else 
        {
        if (sampleRequest.Opportunity__c != opportunity.Id) {runQuery = true;}  //The opportunity on the Sample Request has changed, so load the new one.
        else {runQuery = false;}
        }
      }
    if (runQuery == true)
      {
        try {
        opportunity = [select id,
                       AccountId,
                       OwnerId,
                       Name,
                       Description,
                       StageName,
                       Amount,
                       SAP_Material__r.Name,
                       SAP_Material__c,
                       CloseDate,
                       Probability,
                       Requested_Supplier__c,
                       Potential_CM__c,
                       Annual_Usage__c
             from Opportunity where id = : sampleRequest.Opportunity__c];
             sampleRequest.Opportunity__r = opportunity;
             if(sampleRequest.Supplier__c == null){
             sampleRequest.Supplier__c = opportunity.Requested_Supplier__c;}
             }
         catch (Exception e) {}
      }
    return opportunity;
  }

  public Sample_Request__c getSampleRequest() {
    if (sampleRequest == null) 
      {
      String sampleRequestId = System.currentPageReference().getParameters().get('sampleRequestId');
       
      if ((sampleRequestId != '') && (sampleRequestId != null))
        {
        sampleRequest = [SELECT 
                                Id, 
                                OwnerId, 
                                Name, 
                                RecordTypeId, 
                                Account__c, 
                                AD_Compound__c, 
                                Additional_Comments__c, 
                                Address_Line_1__c, 
                                Address_Line_2__c, 
                                Address_Line_3__c, 
                                Address_Line_4__c,
                                AHWT_Product_Lines__c, 
                                Approval_Date__c, 
                                Ashland_Requestor__c, 
                                City__c, 
                                Country__c, 
                                Customer_Requestor__c, 
                                Customer_Ship_To_Contact__c, 
                                Date_Required_By__c, 
                                Dist_Channel__c, 
                                Dist_Channel_Desc__c, 
                                Division__c, 
                                Division_Desc__c, 
                                Estimated_Sample_Value__c, 
                                Estimated_Ship_Date__c, 
                                If_unknown_product_description__c, 
                                Material__c, 
                                OEM__c, 
                                Opportunity__c, 
                                Parent_Account_Name__c, 
                                Parent_Account_Owner__c, 
                                Parent_Account_RecordType__c, 
                                Postal_Zip_Code__c, 
                                Potential_Annual_Volume__c, 
                                Potential_Annual_Volume_Quantifier__c, 
                                Reason_for_Sample__c, 
                                Region__c, 
                                Sales_Org__c, 
                                Sales_District__c, 
                                Sales_District_Desc__c, 
                                Sales_Group__c, 
                                Sales_Group_Desc__c, 
                                SalesOffice__c, 
                                Sales_Office__c, 
                                Sales_Office_Desc__c, 
                                Sample_Size__c, 
                                Sample_Size_Other__c, 
                                SAP_Order_Number__c, 
                                Ship_From_Location__c, 
                                State__c, 
                                Status__c, 
                                Tectyl_Product__c, 
                                Update_All_Information__c, 
                                Estimated_Arrival_Date__c, 
                                Contact__c, 
                                Contact_Phone_Number__c,
                                Contact_Email__c, 
                                Contact_First_Name__c, 
                                Contact_Last_Name__c, 
                                Create_Contact_Record_on_Account__c, 
                                Tracking_Air_Bill__c, 
                                Carrier_Type_for_Sample_Delivery__c, 
                                Sample_Approver__c, 
                                Sample_Coordinator__c, 
                                Ship_To_Address_Type__c, 
                                Number_of_Items__c, 
                                Total_Value_of_Sample__c, 
                                Total_Potential_Annual_Value_of_Sample__c, 
                                Most_Valuable_Item_Value__c, 
                                Available_Actions__c, 
                                Cancellation_Reason__c, 
                                On_Hold_Reason__c, 
                                CSR_Responsible_for_Order_Entry__c, 
                                Product_Development__c, 
                                AST_Sample__c,
                                Oak_Creek__c, 
                                Approval_Process__c, 
                                New_Prospect_Account__c, 
                                Contains_Material_Greater_Than_5_Gallons__c,
                                Material_Summary__c,
                                Account_Region__c,
                                Additional_Admin_Cost__c,
                                Total_Line_Item_Costs__c,
                                Total_Sample_Cost__c,
                                Cost_Center__c,
                                Aqualon_Hazardous_Material__c,
                                Aquarius_Sample__c,
                                Rush_Sample__c,
                                UPS_FED_EX_Number__c,
                                Material_Plant__C,
                                End_Market__c
                                FROM Sample_Request__c WHERE Id = :sampleRequestId];
        }
      else {sampleRequest = new Sample_Request__c();}
      }

    return sampleRequest;
  }

  public List<Sample_Material__c> getSampleMaterials() {
    //Make sure we have a sampleRequest object
    getSampleRequest();

    if (sampleMaterials == null)
      {
      if (sampleRequest.Id != null)
        {
        //Populate the Object from Salesforce
        sampleMaterials = [SELECT 
                                  Id, 
                                  Name, 
                                  CurrencyIsoCode, 
                                  RecordTypeId, 
                                  CreatedDate, 
                                  CreatedById, 
                                  LastModifiedDate, 
                                  LastModifiedById, 
                                  SystemModstamp, 
                                  Actual_Ship_Date__c, 
                                  AD_Compound__c, 
                                  Additional_Admin_Cost__c,
                                  AHWT_Product_Line__c,
                                  Customer_Expectations_Met_on_Delivery__c, 
                                  Date_Required_By__c, 
                                  Estimated_Arrival_Date__c, 
                                  Estimated_Sample_Value__c, 
                                  Estimated_Ship_Date__c, 
                                  Existing_Material_in_SAP__c,
                                  Lot_Numbers__c, 
                                  Material_Must_Ship_From_Location__c,
                                  Material_Plant__c,
                                  Material__c,
                                  PAC_Industry_Segment__c,
                                  PM_Castings_Product_Line__c,
                                  Potential_Annual_Value__c, 
                                  Product_Line__c,
                                  Sample_Quantity__c, 
                                  Sample_Request__c, 
                                  Sample_UOM__c, 
                                  SAP_Material__c, 
                                  SAP_Material_Number__c, 
                                  Ship_From_Location__c, 
                                  Shipping_Carrier__c, 
                                  Shipping_Result__c, 
                                  Tectyl_Product__c, 
                                  Track_Shipment__c, 
                                  Tracking_Air_Bill__c,
                                  SAP_Material_MSD2__c
                                  FROM Sample_Material__c WHERE Sample_Request__c = :sampleRequest.Id];
        }
      else
        {
        //Initialize the Object
        /*
        account = getAccount();
                
        if(Account != null){
        String artypeid = account.recordtypeid;
        if(NA_SALES_ORGS.contains(account.SAP_Sales_Org__c) == false){
         artypeid += 'EMEA';
        }

        String sampleMaterial_RecordType = RecordType_Relationship_Functions.GetMaterialRecordType_Based_on_AccountRecordTypeId(artypeid);
        }
        */
        sampleMaterials = new List<Sample_Material__c>();
        Sample_Material__c sm = new sample_material__c();
        sm.Additional_Admin_Cost__c = Additional_Cost_per_Line_Item;
        getaccount();
        if(getisdistribution()){
        sm.Estimated_Sample_Value__c = AD_Default_Estimated_Sample_Value;
        sm.Potential_Annual_Value__c = AD_Default_Potential_Annual_Revenue;
        sm.date_required_by__c = system.today() + AD_default_required_by_adder;
        sm.Sample_UOM__c = AD_Default_UOM;
        //sm.recordtypeid = sampleMaterial_RecordType;
        sm.Sample_Quantity__c = AD_Default_Qty;
        if(Opportunity != null){
          Opportunity = getOpportunity();
          sm.Opportunity__c = opportunity.id;
          if(Opportunity.SAP_Material__c != null){
            sm.name = Opportunity.SAP_Material__r.Name;
          }
        }
        }      
        sampleMaterials.add(sm);
        }
    }
    return sampleMaterials;
  }    

  private List<Contact> contacts;
  public String contactSelected = '';
  
  public String getContactSelected() {return contactSelected;}
  public void setContactSelected(String s) {this.contactSelected = s;}
  
  public Boolean Step2A_Valid() {
    Boolean result = true;
    
    ValidationErrorMessage = '';
        
    if (contactSelected == '')
      {
        result = false;
        ValidationErrorMessage = system.label.Error_Contact_Not_Chosen;
      }
      
    return result;
  }
  
  public Boolean Step2C_Valid() {
    Boolean result = true;
   
    
    ValidationErrorMessage = '';
        
    if (opportunitySelected == '' || (opportunitySelected == 'No Opportunity' && sampleRequest.End_Market__c == 'CASE'))
      {
        result = false;
        ValidationErrorMessage = 'You must select an Opportunity';
      }
    
    
      
    return result;
  }

  public List<Contact> getContacts() {
    if ( contacts == null ) {
        
      try {
      contacts = [select id,
                  Name,
                  Firstname,
                  Lastname,
                  Phone,
                  MobilePhone,
                  Fax,
                  Email,
                  MailingStreet,
                  MailingCity,
                  MailingState,
                  MailingPostalCode,
                  MailingCountry from Contact
        where AccountId = : sampleRequest.Account__c];}
      catch (Exception e) {}
        
      }
      
    return contacts;
  }

  private List<Opportunity> opportunities;
  public String opportunitySelected = '';
  
  public String getOpportunitySelected() {return opportunitySelected;}
  
  public void setOpportunitySelected(String s) {this.opportunitySelected = s;}
  
  public String getAlreadyHaveOpportunityMessage() {
    String result = '';
    getSampleRequest();
    if (sampleRequest.Opportunity__c != null)
      {
        result = system.label.Warning_Opp_Associated_1 + '<a HREF="/' + opportunity.Id + '" target="_blank">' + opportunity.Name + '</a>.' + system.label.Warning_Opp_Associated_2;
      }
    return result;      
  }
  
  public Integer getOpportunityRelatedtoParentAccount_Count() {
    Integer result = 0;
    getOpportunities();
    if (opportunities != null)
        {
        result = opportunities.size();
        }
    return result;
  }
  
  private Boolean Step2B_Valid() {
    Boolean result = true;
    
    ValidationErrorMessage = '';
      
    return result;
  }

  public List<Opportunity> getOpportunities() {
    if ( opportunities == null ) {
      try {
      opportunities = [SELECT id,
                              Name,
                              RecordType.Name,
                              Description,
                              StageName,
                              CloseDate
                         FROM Opportunity 
        WHERE AccountId = : sampleRequest.Account__c
          AND IsClosed = false]; }
       catch (Exception e) {}
          
      }
    return opportunities;
  }
  
  public PageReference Save_Sample_Request_with_New_Opportunity() {
    PageReference result = null;
    ValidationErrorMessage = '';
    if (sampleRequest != null) 
      {
      if (opportunitySelected != '')
        {
        //sampleRequest.Opportunity__c = opportunitySelected;
        //sampleRequest.Material_Summary__c = Sample_Material_Functions.SummarizeMaterialsonSampleRequest(sampleRequest.Id);
        update sampleRequest;
        PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
        sampleRequestPage.setRedirect(true);
        result = sampleRequestPage;
        }
      else
        {ValidationErrorMessage = System.label.Error_Opportunity_Not_Selected; }
      }
    return result;  
  }
  
// Sample Wizard - Step 3 - Gather basic Sample Info - Address Info

  // Variable Declaration
  boolean AddressManualEntry_Visible = false;
  boolean AddressManualEntry_Account_Visible = false;
  boolean AddressManualEntry_Contact_Visible = false;
  boolean AddressSection_Visible = true;
  boolean UseContactAddressButton_Disabled = true;
  boolean UseAccountAddressButton_Disabled = true;
  String UseAccountAddressButton_Style = 'btnDisabled';
  String UseContactAddressButton_Style = 'btnDisabled';

  // Get/Set Functions
  public Boolean getEnableDisable_AccountAddressButton() {
    account = getAccount();

    if (account != null) {
        UseAccountAddressButton_Disabled = false;
        UseAccountAddressButton_Style = 'btn';
      }
    else {
        UseAccountAddressButton_Disabled = true;
        UseAccountAddressButton_Style = 'btnDisabled';
      }

    return UseAccountAddressButton_Disabled;
  }

  public Boolean getEnableDisable_ContactAddressButton() {
    contact = getContact();

    if (contact != null) {
        UseContactAddressButton_Disabled = false;
        UseContactAddressButton_Style = 'btn';
      }
    else {
        UseContactAddressButton_Disabled = true;
        UseContactAddressButton_Style = 'btnDisabled';
      }

    return UseContactAddressButton_Disabled;
  }

  public String getStyle_AccountAddressButton() {
    account = getAccount();

    if (account != null) {
        UseAccountAddressButton_Disabled = false;
        UseAccountAddressButton_Style = 'btn';
      }
    else {
        UseAccountAddressButton_Disabled = true;
        UseAccountAddressButton_Style = 'btnDisabled';
      }

    return UseAccountAddressButton_Style;
  }

  public String getStyle_ContactAddressButton() {
    contact = getContact();

    if (contact != null) {
        UseContactAddressButton_Disabled = false;
        UseContactAddressButton_Style = 'btn';
      }
    else {
        UseContactAddressButton_Disabled = true;
        UseContactAddressButton_Style = 'btnDisabled';
      }

    return UseContactAddressButton_Style;
  }

  public Boolean gethideshow_AddressManualEntry() {
    return AddressManualEntry_Visible;
  }

  public Boolean gethideshow_AddressManualEntry_Account() {
    return AddressManualEntry_Account_Visible;
  }

  public Boolean gethideshow_AddressManualEntry_Contact() {
    return AddressManualEntry_Contact_Visible;
  }

  public Boolean gethideshow_AddressSection() {
    return AddressSection_Visible;
  }

  public String getAccountAddress() {

    String AccountAddress = '';

    if (account != null) {

      List <String> addressLines = new List <String>();
      addressLines.add(account.SAP_Street__c);
      addressLines.add(account.SAP_StreetSuppl1__c);
      addressLines.add(account.SAP_StreetSuppl2__c);
      addressLines.add(account.SAP_StreetSuppl3__c);
      
      AccountAddress = Address_Functions.FormatAddressforWebDisplay(addressLines,
                                                                    account.SAP_City__c,
                                                                    account.SAP_State__c,
                                                                    account.SAP_Zip_Code__c,
                                                                    account.SAP_Country__c);
      
      }

    return AccountAddress;
  }

  public String getContactAddress() {
    String ContactAddress = '';

    if (contact != null) {
      ContactAddress = Address_Functions.FormatAddressforWebDisplay(contact.MailingStreet,
                                                                    contact.MailingCity,
                                                                    contact.MailingState,
                                                                    contact.MailingPostalCode,
                                                                    contact.MailingCountry);
      }
    return ContactAddress;
  }

  // Step Validation

  public Boolean Step3_Valid() {
    Boolean result = true;
    if ((sampleRequest.Ship_To_Address_Type__c == '') || (sampleRequest.Ship_To_Address_Type__c == null)) {
        result = false;
        ValidationErrorMessage = system.label.Error_No_Shipping_Address;
      }
    system.debug('Has Opportunity: ' + sampleRequest.Opportunity__c != null);  
    if( SampleRequest.Opportunity__c != null){
        if(SampleRequest.Opportunity__r.CloseDate < system.today()){
          result= false;
          ValidationErrorMessage = 'Opportunity Close Date must be greater than or equal to today';
          
        }
    }
    return result;
  }

  // General Functions
  public void populateShipToAddress_Manually() {

    AddressManualEntry_Account_Visible = false;
    AddressManualEntry_Contact_Visible = false;
    AddressManualEntry_Visible = true;
    AddressSection_Visible = false;
    sampleRequest.Ship_To_Address_Type__c = 'Manually Entered Address';
    ValidationErrorMessage = '';
    
  }

  public void copyAddressInfoBetweenSampleRequests(Sample_Request__c Source_Sample, Sample_Request__c Target_Sample) {
      Target_Sample.Address_Line_1__c = Source_Sample.Address_Line_1__c;
      Target_Sample.Address_Line_2__c = Source_Sample.Address_Line_2__c;
      Target_Sample.Address_Line_3__c = Source_Sample.Address_Line_3__c;
      Target_Sample.Address_Line_4__c = Source_Sample.Address_Line_4__c;
      Target_Sample.City__c = Source_Sample.City__c;
      Target_Sample.State__c = Source_Sample.State__c;
      Target_Sample.Postal_Zip_Code__c = Source_Sample.Postal_Zip_Code__c;
      Target_Sample.Country__c = Source_Sample.Country__c;
  }

  public void populateShipToAddress_from_Account() {

    AddressManualEntry_Account_Visible = false;
    AddressManualEntry_Contact_Visible = false;
    AddressManualEntry_Visible = false;
    AddressSection_Visible = true;
    ValidationErrorMessage = '';
    account = getAccount();

    if (account != null) {

        AccountAddressEntry.Address_Line_1__c = account.SAP_Street__c;
        AccountAddressEntry.Address_Line_2__c = account.SAP_StreetSuppl1__c;
        AccountAddressEntry.Address_Line_3__c = account.SAP_StreetSuppl2__c;
        AccountAddressEntry.Address_Line_4__c = account.SAP_StreetSuppl3__c;
        AccountAddressEntry.City__c = account.SAP_City__c;
        AccountAddressEntry.State__c = account.SAP_State__c;
        AccountAddressEntry.Postal_Zip_Code__c = account.SAP_Zip_Code__c;
        AccountAddressEntry.Country__c = account.SAP_Country__c;
        AccountAddressEntry.Ship_To_Address_Type__c = 'Address from Account';
        
        copyAddressInfoBetweenSampleRequests(AccountAddressEntry, ManualAddressEntry);
        copyAddressInfoBetweenSampleRequests(AccountAddressEntry, sampleRequest);
        sampleRequest.Ship_To_Address_Type__c = 'Address from Account';
        
        
        //If Address is bad, force the interface to go into Manual Entry
        if (
          ((sampleRequest.Address_Line_1__c == '') || (sampleRequest.Address_Line_1__c == null)) ||
          ((sampleRequest.City__c == '') || (sampleRequest.City__c == null)) ||
          ((sampleRequest.Postal_Zip_Code__c == '') || (sampleRequest.Postal_Zip_Code__c == null)) ||
          ((sampleRequest.Country__c == '') || (sampleRequest.Country__c == null))
           ) 
          {
            sampleRequest.Ship_To_Address_Type__c = 'Manually Entered Address';
            AddressManualEntry_Account_Visible = true;
            AddressManualEntry_Contact_Visible = false;
            AddressManualEntry_Visible = false;
            ValidationErrorMessage = system.label.Error_Address_Not_Complete;
          }
      }
    else {
        sampleRequest.Address_Line_1__c = 'Not Found';
      }
      
  }

  public void populateShipToAddress_from_Contact() {

    AddressManualEntry_Account_Visible = false;
    AddressManualEntry_Contact_Visible = false;
    AddressManualEntry_Visible = false;

    AddressSection_Visible = true;
    ValidationErrorMessage = '';
    contact = getContact();

    if (contact != null) {

        List<String> addressLines = Address_Functions.convert1LineAddressto4(contact.MailingStreet);
        sampleRequest.Address_Line_1__c = '';
        sampleRequest.Address_Line_2__c = '';
        sampleRequest.Address_Line_3__c = '';
        sampleRequest.Address_Line_4__c = '';

        if (addressLines != null)
          {
          if (addressLines.size() > 0) {
              sampleRequest.Address_Line_1__c = addressLines.get(0);
            }
          if (addressLines.size() > 1) {
              sampleRequest.Address_Line_2__c = addressLines.get(1);
            }
          if (addressLines.size() > 2) {
              sampleRequest.Address_Line_3__c = addressLines.get(2);
            }
          if (addressLines.size() > 3) {
              sampleRequest.Address_Line_4__c = addressLines.get(3);
            }
          }
        else
          {
          sampleRequest.Address_Line_1__c = '';
          sampleRequest.Address_Line_2__c = '';
          sampleRequest.Address_Line_3__c = '';
          sampleRequest.Address_Line_4__c = '';
          }    
        sampleRequest.City__c = contact.MailingCity;
        sampleRequest.State__c = contact.MailingState;
        sampleRequest.Postal_Zip_Code__c = contact.MailingPostalCode;
        sampleRequest.Country__c = contact.MailingCountry;
        sampleRequest.Ship_To_Address_Type__c = 'Address from Contact';

        copyAddressInfoBetweenSampleRequests(sampleRequest, ContactAddressEntry);
        ContactAddressEntry.Ship_To_Address_Type__c = 'Address from Contact';
        copyAddressInfoBetweenSampleRequests(sampleRequest, ManualAddressEntry);

        //If Contact is bad, force the interface to go into Manual Entry
        if (
          ((sampleRequest.Address_Line_1__c == '') || (sampleRequest.Address_Line_1__c == null)) ||
          ((sampleRequest.City__c == '') || (sampleRequest.City__c == null)) ||
          ((sampleRequest.Postal_Zip_Code__c == '') || (sampleRequest.Postal_Zip_Code__c == null)) ||
          ((sampleRequest.Country__c == '') || (sampleRequest.Country__c == null))
           )
          {
            sampleRequest.Ship_To_Address_Type__c = 'Manually Entered Address';
            AddressManualEntry_Account_Visible = false;
            AddressManualEntry_Contact_Visible = true;
            AddressManualEntry_Visible = false;
            ValidationErrorMessage = system.label.Error_Incomplete_Contact;
          }

      }
    else {
        sampleRequest.Address_Line_1__c = 'Not Found';
      }
    
  }

  List<Sample_Material__c> sampleMaterials_toBeDeleted = new List<Sample_Material__c>();

  public Boolean getRenderTectyl() {
    if (account != null) {return Sample_Material_Functions.SupportsTectylProducts(account.Id);}
    else {return false;}
  }

  public Boolean getRenderProductLine() {
    if (account != null) {return Sample_Material_Functions.SupportsProductLine(account.Id);}
    else {return false;}
  }
  
    public Boolean getRenderAHWTProductLine() {
    if (account != null) {return Sample_Material_Functions.SupportsAHWTProductLine(account.Id);}
    else {return false;}
  }

 
  public Boolean getRenderPMCastingsProductLine() {
    if (account != null) {return Sample_Material_Functions.SupportsPMCastingsProductLine(account.Id);}
    else {return false;}
  }

  public Boolean getRenderADCompound() {
    if (account != null) {return Sample_Material_Functions.SupportsADCompoundProducts(account.Id);}
    else {return false;}
  }

  public Boolean getRenderProductDevelopment() {
    if (account != null) {return Sample_Material_Functions.SupportsProductDevelopment(account.Id);}
    else {return false;}
  }
  public Boolean getRenderASTSamples() {
    if (account != null) {return Sample_Material_Functions.SupportsASTSamples();}
    else {return false;}
  }
  public Boolean getRenderOakCreek() {
    if (account != null) {return Sample_Material_Functions.SupportsOakCreek(account.Id);}
    else {return false;}
  }
  public Boolean isAqualonAccount {
    get {
        return (accountRecordType != null && 
               (accountRecordType == REC_TYPE_AAFI_1 ||
                accountRecordType == REC_TYPE_AAFI_2 ||
                accountRecordType == REC_TYPE_AAFI_3));
    }
  }
  
  public Boolean getisAHWT(){
   
        return (accountRecordType != null && 
               (accountRecordType == REC_TYPE_AHWT_1 ||
                accountRecordType == REC_TYPE_AHWT_2 ||
                accountRecordType == REC_TYPE_AHWT_3 ));
    
  }
    public Boolean getisDistribution(){
   
        return (accountRecordType != null && 
               (accountRecordType == REC_TYPE_AD_1 ||
                accountRecordType == REC_TYPE_AD_2 ||
                accountRecordType == REC_TYPE_AD_3 ||
                accountRecordType == REC_TYPE_AD_4 ||
                accountRecordType == REC_TYPE_AD_5));
    
  }
  
  public Boolean getRenderGeneralMaterialQuestions() {
    Boolean result = false;
    if (account != null) {
      return  (  getRenderProductDevelopment()
              || getRenderASTSamples()
              || getRenderOakCreek()
              || isAqualonAccount
              );
    }
    return result;
  }
  public String getBusiness() {
   
      String business = '';
      if(isaqualonaccount == true){ business = 'Aqualon';}
      if(getisdistribution() == true) {business = 'Distribution';}
      if(getisAHWT() == true) {business = 'AHWT';}
    return business;
  }
    public Boolean Step4_Valid() {
      Boolean result = true;
      String business = getBusiness();
      
      ValidationErrorMessage = '';
        
      sampleMaterials = Sample_Material_Functions.Remove_Blank_Rows_From_Material_List(sampleMaterials);
      
      if (sampleMaterials.size() == 0)
        {ValidationErrorMessage = system.label.Error_Need_one_material;}
      else
        {ValidationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account.Id, 'InitialEntry', true, business),system.label.error + ': ','');}

      if (sampleRequest.Rush_Sample__c == true && sampleRequest.UPS_Fed_Ex_Number__c == null){
        ValidationErrorMessage += String_Functions.Format_ListString_into_HTML_List('<u>UPS / Fed-Ex Number</u> ' + system.label.Required_for_Rushed_Samples,system.label.error + ': ',''); }
      
      if (sampleRequest.Rush_Sample__c == true && (Carrier == null || Carrier == '')){
        ValidationErrorMessage += String_Functions.Format_ListString_into_HTML_List('<u>Carrier</u> ' + system.label.Required_for_Rushed_Samples,system.label.error + ': ',''); }
       
      if (sampleRequest.Rush_Sample__c == false && (Carrier == null || Carrier == '') && sampleRequest.UPS_Fed_Ex_Number__c != null ){
        ValidationErrorMessage += String_Functions.Format_ListString_into_HTML_List('<u>Carrier</u> ' + system.label.Required, system.label.error + ': ',''); }

      if (sampleRequest.Rush_Sample__c == false && Carrier != null && Carrier != '' && sampleRequest.UPS_Fed_Ex_Number__c == null){
        ValidationErrorMessage += String_Functions.Format_ListString_into_HTML_List('<u>UPS / Fed-Ex Number</u> ' + system.label.Required, system.label.error + ': ',''); }

      if (sampleRequest.Aquarius_Sample__c) {
        ValidationErrorMessage += Sample_Request_Aquarius.validateRequiredFields(aquarius);
        System.debug(ValidationErrorMessage);
      }
      
      if(displayerror)
      ValidationErrorMessage = 'Please enter only Material Name when Material Not in SAP is checked';
      if(sapmaterror)
      ValidationErrorMessage = 'SAP Material is required when "Material not in SAP" is unchecked.';
        
      if (ValidationErrorMessage != '') 
        {result = false;}
      
      
      return result;
    }

    public void AddNewMaterial() {
      if (sampleMaterials != null) 
        {        
        Sample_Material__c sm = new sample_material__c();
        sm.Opportunity__c = sampleRequest.Opportunity__c;
        sm.Additional_Admin_Cost__c = Additional_Cost_per_Line_Item;
        if(getisdistribution() == true){
        sm.Estimated_Sample_Value__c = AD_Default_Estimated_Sample_Value;
        sm.Potential_Annual_Value__c = AD_Default_Potential_Annual_Revenue;
        sm.date_required_by__c = system.today() + AD_default_required_by_adder;
        sm.Sample_UOM__c = AD_Default_UOM;
        sm.Sample_Quantity__c = AD_Default_Qty;
        }       
        sampleMaterials.add(sm);
        }
    }

    public void RemoveMaterial() {
    }

    public void ClearMaterialGrid() {
      sampleMaterials.clear();
        Sample_Material__c sm = new sample_material__c();
        sm.Additional_Admin_Cost__c = Additional_Cost_per_Line_Item;
        if(getisdistribution() == true){
        sm.Estimated_Sample_Value__c = AD_Default_Estimated_Sample_Value;
        sm.Potential_Annual_Value__c = AD_Default_Potential_Annual_Revenue;
        sm.date_required_by__c = system.today() + AD_default_required_by_adder;        
        sm.Sample_UOM__c = AD_Default_UOM;
        sm.Sample_Quantity__c = AD_Default_Qty;
        }       
        sampleMaterials.add(sm);
    }

  public String NoteToSampleCoordinator = '';

  public String getNoteToSampleCoordinator() {
    return NoteToSampleCoordinator;
  }

  public void setNoteToSampleCoordinator(String noteIn) {
    NoteToSampleCoordinator = noteIn;
  }

  public String getSampleRequestAddress() {

    String SampleRequestAddress = '';

    if (sampleRequest != null) {
      
      List <String> addressLines = new List <String>();
      addressLines.add(sampleRequest.Address_Line_1__c);
      addressLines.add(sampleRequest.Address_Line_2__c);
      addressLines.add(sampleRequest.Address_Line_3__c);
      addressLines.add(sampleRequest.Address_Line_4__c);
      
      SampleRequestAddress = Address_Functions.FormatAddressforWebDisplay(addressLines,
                                                                          sampleRequest.City__c,
                                                                          sampleRequest.State__c,
                                                                          sampleRequest.Postal_Zip_Code__c,
                                                                          sampleRequest.Country__c);
      }

    return SampleRequestAddress;
  }

  public PageReference saveAndSubmitForApproval() {

    PageReference pageResult = null;

    if (contactSelected == 'New Contact') {
        Contact newContact;
        newContact = new Contact();

        newContact.FirstName = sampleRequest.Contact_First_Name__c;
        newContact.LastName = sampleRequest.Contact_Last_Name__c;
        newContact.Phone = sampleRequest.Contact_Phone_Number__c;
        newContact.Email = sampleRequest.Contact_Email__c;

        String ContactAddress = '';
        if (sampleRequest.Address_Line_1__c != null)
          ContactAddress += sampleRequest.Address_Line_1__c + '\n';
        if (sampleRequest.Address_Line_2__c != null)
          ContactAddress += sampleRequest.Address_Line_2__c + '\n';
        if (sampleRequest.Address_Line_3__c != null)
          ContactAddress += sampleRequest.Address_Line_3__c + '\n';
        if (sampleRequest.Address_Line_4__c != null)
          ContactAddress += sampleRequest.Address_Line_4__c + '\n';

        newContact.MailingStreet = ContactAddress;
        newContact.MailingCity = sampleRequest.City__c;
        newContact.MailingState = sampleRequest.State__c;
        newContact.MailingPostalCode = sampleRequest.Postal_Zip_Code__c;
        newContact.MailingCountry = sampleRequest.Country__c;
        newContact.AccountId = sampleRequest.Account__c;

        string contactRecordType = '';
        contactRecordType = RecordType_Relationship_Functions.GetContactRecordType_Based_on_AccountRecordTypeId(account.RecordTypeId);
        if ((contactRecordType != null) && (contactRecordType != ''))
            {newContact.RecordTypeId = contactRecordType;}
        
        // Handling No Email checkbox on Contact as per Email as per ticket INC000001516217
        // Start - Changes made by Abhishek on 26Aug2013
        newContact.No_Email__c = FALSE;
        if(newContact.Email == null || newContact.Email == ''){
            newContact.No_Email__c = TRUE;
        }
        // End - Changes made by Abhishek on 26Aug2013
        
        insert newContact;

        sampleRequest.Contact__c = newContact.Id;
      }
      
    if(sampleRequest.Opportunity__r != null){
       system.debug(sampleRequest.Opportunity__r);
       upsert sampleRequest.Opportunity__r;
       sampleRequest.Opportunity__c = sampleRequest.Opportunity__r.Id;
    }
    upsert sampleRequest;
    
    String artypeid = account.recordtypeid;
    if(NA_SALES_ORGS.contains(account.SAP_Sales_Org__c) == false){
      artypeid += 'EMEA';
    }
    String sampleMaterial_RecordType = RecordType_Relationship_Functions.GetMaterialRecordType_Based_on_AccountRecordTypeId(artypeid);

    Sample_Material_Functions.Delete_Sample_Materials_Not_In_List(sampleRequest,sampleMaterials);

    if (sampleMaterials.size() > 0)
        {
        string oppid = '';
        for (Sample_Material__c sampleMaterial : sampleMaterials) {
            if(oppid == '' && samplematerial.Opportunity__c != null){ oppId = sampleMaterial.Opportunity__c; }
            if (sampleMaterial.Id == null) {sampleMaterial.Sample_Request__c = sampleRequest.id;}
                if ((sampleMaterial_RecordType != null) && (sampleMaterial_RecordType != '')) {sampleMaterial.RecordTypeId = sampleMaterial_RecordType;}
          }
        upsert sampleMaterials;
        if(oppId != '' && sampleRequest.Opportunity__c == null){
         // sampleRequest.Opportunity__c = oppId;
          update SampleRequest;
        }
        
        
        }
   
    if (NoteToSampleCoordinator != '') {
       Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,system.label.Additional_Comments_for_SC,NoteToSampleCoordinator);
       Update SampleRequest;
      }

    if (sampleRequest.Aquarius_Sample__c && aquarius != null) {
        aquarius.Sample_Request__c = sampleRequest.Id;
        upsert aquarius;
    }
    
    Approval.ProcessSubmitRequest reql = new Approval.ProcessSubmitRequest();
    reql.setComments(system.label.Submitting_SR);
    reql.setObjectId(sampleRequest.id);

    Approval.ProcessResult result = Approval.process(reql);

    System.assert(result.isSuccess());

    PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
    sampleRequestPage.setRedirect(true);
    pageResult = sampleRequestPage;
    
    return pageResult;
  }

  string noApprovalProcessMessage;

  public String getNoApprovalProcessMessage() {
    noApprovalProcessMessage = '';
    noApprovalProcessMessage += system.label.No_Approval_Process_SR;
    return noApprovalProcessMessage;
  }

  string ApproverQueue = '';

  public String getApproverQueue() {
    ApproverQueue = '';
    ApproverQueue += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approver_Queue(sampleRequest.Approval_Process__c));
    return ApproverQueue;
  }

  string ApproverQueue2 = '';

  public String getApproverQueue2() {
    ApproverQueue2 = '';
    ApproverQueue2 += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approver_Queue_2(sampleRequest.Approval_Process__c));
    return ApproverQueue2;
  }


  string ApproverQueue3 = '';

  public String getApproverQueue3() {
    ApproverQueue3 = '';
    ApproverQueue3 += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approver_Queue_3(sampleRequest.Approval_Process__c));
    return ApproverQueue3;
  }


  string BackupApproverQueue = '';

  public String getBackupApproverQueue() {
    BackupApproverQueue = '';
    BackupApproverQueue += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Backup_Approver_Queue(sampleRequest.Approval_Process__c));
    return BackupApproverQueue;
  }

  string ApproverQueueName = '';

  public String getApproverQueueName() {
    ApproverQueueName = '';
    ApproverQueueName += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approver_Queue_Name(sampleRequest.Approval_Process__c));
    return ApproverQueueName;
  }

  string ApprovalRequirements = '';

  public String getApprovalRequirements() {
    ApprovalRequirements = '';
    ApprovalRequirements += String_Functions.ConvertCRtoBR(SampleRequestApprovalProcess_Functions.lookup_Approval_Requirements(sampleRequest.Approval_Process__c));
    return ApprovalRequirements;
  }

  public void performApprovalProcessing() {
    sampleRequest.Approval_Process__c = SampleRequestApprovalProcess_Functions.lookup_Approval_Process(sampleRequest, sampleMaterials);
    sampleRequest.New_Prospect_Account__c = Account_Functions.isNewProspect(sampleRequest.Account__c);
    sampleRequest.Contains_Material_Greater_Than_5_Gallons__c = Sample_Material_Functions.List_Contains_Material_Greater_Then_5_Gallons(sampleMaterials);
    UOM_Conversion_Functions.setRouteForApprovalFlags(accountRecordType, sampleRequest, sampleMaterials);
    sampleRequest.Parent_Account_Name__c = account.Name;
    sampleRequest.Parent_Account_Owner__c = account.OwnerId;
    sampleRequest.Account_Region__c = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(account.SAP_Sales_Org__c);
  }
  
  String accountName = '';
  String accountNumber = '';
  String contactName = '';
  String opportunityName = '';
  String errorMessage = '';
  String validation_Error = '';
  public Sample_Material__c sampleMaterial_All = new Sample_Material__c();

  public String getErrorMessage() {return errorMessage;}
    
  public Sample_Material__c getsampleMaterial_All() {
    return sampleMaterial_All;
  }

  public String getSample_Request_Link() {
    String result = '';    
    if (sampleRequest != null)
      {
        if (sampleRequest.Id != null)
          {
            result = sampleRequest.Name;
          }
      }
    return result;   
  }

  public void Populate_SAP_Material_Numbers() {
    if (sampleMaterials != null)
      {
      if (sampleMaterials.size() > 0)
        { 
        sampleMaterials = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(sampleMaterials);
        }
      }     
  }

  public PageReference Save_Sample_Request() {
    PageReference result = null;
    if (sampleRequest != null) 
      {
      update sampleRequest;

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;  
  }

  public PageReference Cancel_Save() {
    PageReference result = null;
    if (sampleRequest != null) 
      {
      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;  
  }

  public void ApplyChangesToAllMaterials() {
    for (Sample_Material__c sampleMaterial : sampleMaterials)
      {
      if (sampleMaterial_All.Ship_From_Location__c != null) {sampleMaterial.Ship_From_Location__c = sampleMaterial_All.Ship_From_Location__c;}
      if (sampleMaterial_All.Estimated_Ship_Date__c != null) {sampleMaterial.Estimated_Ship_Date__c = sampleMaterial_All.Estimated_Ship_Date__c;}
      if (sampleMaterial_All.Estimated_Arrival_Date__c != null) {sampleMaterial.Estimated_Arrival_Date__c = sampleMaterial_All.Estimated_Arrival_Date__c;}
      if (sampleMaterial_All.Actual_Ship_Date__c != null) {sampleMaterial.Actual_Ship_Date__c = sampleMaterial_All.Actual_Ship_Date__c;}
      if (sampleMaterial_All.Shipping_Carrier__c != null) {sampleMaterial.Shipping_Carrier__c = sampleMaterial_All.Shipping_Carrier__c;}
      if (sampleMaterial_All.Tracking_Air_Bill__c != null) {sampleMaterial.Tracking_Air_Bill__c = sampleMaterial_All.Tracking_Air_Bill__c;}
      }
    sampleMaterial_All.Ship_From_Location__c = null;
    sampleMaterial_All.Estimated_Ship_Date__c = null;
    sampleMaterial_All.Estimated_Arrival_Date__c = null;
    sampleMaterial_All.Actual_Ship_Date__c = null;
    sampleMaterial_All.Shipping_Carrier__c = null;
    sampleMaterial_All.Tracking_Air_Bill__c = null;
  }

  Id Assign_a_Different_Coordinator_oldCoordinator;

  public void init_Assign_a_Different_Coordinator() {
    
    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    Assign_a_Different_Coordinator_oldCoordinator = sampleRequest.Sample_Coordinator__c;
    
  }

  public PageReference Assign_a_Different_Coordinator() {
    PageReference result = null;
    if (sampleRequest != null) 
      {
      update sampleRequest;

      Id oldCoordinator = Assign_a_Different_Coordinator_oldCoordinator;
      Id newCoordinator = sampleRequest.Sample_Coordinator__c;
      
      if (oldCoordinator != newCoordinator)
       {
      
          String oldCoordinatorName = 'unknown';
          String newCoordinatorName = '';
          
          if (oldCoordinator != null) {oldCoordinatorName = User_Functions.RetrieveUserName(oldCoordinator);}
          if (newCoordinator != null) {newCoordinatorName = User_Functions.RetrieveUserName(newCoordinator);}
          
          List<String> toAddresses = new List<String>();
          if (oldCoordinator != null) {toAddresses.add(retrieveEmailAddressfromUserId(oldCoordinator));}
          if (newCoordinator != null) {toAddresses.add(retrieveEmailAddressfromUserId(newCoordinator));}
            
          String subject = sampleRequest.Name + ' - ' + system.label.another_SC;
          String body = newCoordinatorName + system.label.now_has_the_responsibility_for + sampleRequest.Name + '.  ' + system.label.previous_SC + oldCoordinatorName + '.' + '\n\n' + system.label.To_View_SR + Salesforce_System_Info_Functions.Retrieve_URL_Prefix() + '/' + sampleRequest.Id;
            
          Boolean emailResult = Email_Functions.sendEmail(toAddresses,
                                null,
                                null,
                                retrieveEmailAddressfromUserId(newCoordinator),newCoordinatorName,
                                false,false,
                                subject,
                                body,
                                null);       
            
            Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,system.label.another_SC ,newCoordinatorName + system.label.now_has_the_responsibility_for + ' ' + sampleRequest.Name + '. ' + system.label.previous_SC + ' ' + oldCoordinatorName + '.');
            Update SampleRequest;
       }

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;  
  }

  public Sample_Request__c sampleRequest_CSR;
  public String accountType;
  String SAP_Order_Number_Label = '';
  Boolean CSRAlreadyAssigned = false;
  String CSRAlreadyAssignedtoEnterOrderMessage;
  public String NoteToCSR = '';

  public String getNoteToCSR() {
    return NoteToSampleCoordinator;
  }

  public void setNoteToCSR(String noteIn) {
    NoteToCSR = noteIn;
  }

  public String getAccountType() {

    if (accountType == null)
      {
      getSampleRequest();
      getAccount();
      accountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(account.RecordTypeId);
      }
    return accountType;
  }
  
  Public String getCSR_Responsible_for_Order_Entry_Label() {
    return '<b>' + system.label.CSR_Responsible + ': <FONT COLOR="RED" SIZE="4">*</FONT></b>';
  }

  Public String getSAP_Order_Number_Label() {
    return '<b>' + system.label.Order_Number + ': <FONT COLOR="RED" SIZE="4">*</FONT></b>';
  }

  public String getCSRAlreadyAssignedtoEnterOrderMessage() {

    CSRAlreadyAssignedtoEnterOrderMessage = '';
  
    if (CSRAlreadyAssigned == true)
      {
      CSRAlreadyAssignedtoEnterOrderMessage = system.label.Warning_Activity_Sent_to + ' ' + User_Functions.RetrieveUserName(sampleRequest.CSR_Responsible_for_Order_Entry__c)+ ' ' + system.label.Warning_Activity_Sent_to_2;
      }
  
    return CSRAlreadyAssignedtoEnterOrderMessage;
  }

  public void init_Assign_Task_to_CSR_to_Enter_Order() {
    
    User sampleCSRUser = null;
    
    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();
    CSRAlreadyAssigned = false;
    emailcsrgroupbox = false;
    renderemailcsrgroupbox = !(account.SAP_CSR_Email__c == '' || account.sap_csr_email__c == null);
    
    if (sampleRequest.CSR_Responsible_for_Order_Entry__c == null)
      {
      if (account.SAP_CSR_Email__c != null)
        {
        try {sampleCSRUser = [SELECT Id, UserName, Email, Backup__c FROM User WHERE Email = :account.SAP_CSR_Email__c AND UserName = :account.SAP_CSR_Email__c];}
        catch (Exception e) {sampleCSRUser = null;}
        if (sampleCSRUser != null)
          {
          sampleRequest.CSR_Responsible_for_Order_Entry__c = sampleCSRUSer.Id;
          }
        }
      }
   else {CSRAlreadyAssigned = true;}   
  }

  public Boolean Assign_Task_to_CSR_to_Enter_Order_Valid() {
    Boolean result = true;

    ValidationErrorMessage = '';

    if (sampleRequest.CSR_Responsible_for_Order_Entry__c == null)
      {
      ValidationErrorMessage = String_Functions.Format_ListString_into_HTML_List(system.label.Error_Must_Select_CSR,system.label.Error + ': ','');
      }
    
    ValidationErrorMessage += String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account.Id, 'AssignOrderEntrytoCSR', true, getBusiness()),'Error: ','');

    if (ValidationErrorMessage != '') 
      {result = false;}

    return result;
  }

  public String retrieveEmailAddressfromUserId(String id) {
    User user = [SELECT email FROM User WHERE Id = :id];
    return user.email;
  }
  
  public PageReference AssignTasktoCSRtoEnterOrder() {
    PageReference result = null;

    if (Assign_Task_to_CSR_to_Enter_Order_Valid() == true)
      {
      sampleMaterials = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(sampleMaterials);
        
      update sampleRequest;
      update sampleMaterials;

      if (NotetoCSR != '') {
          Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,system.label.Additional_Comments_for_CSR,NoteToCSR);
          Update sampleRequest;
        }

      Task task = new Task();

      task.OwnerId = sampleRequest.CSR_Responsible_for_Order_Entry__c;
      task.WhatId = sampleRequest.Id;
      task.Subject = system.label.Sample_Request + '# ' + sampleRequest.name + ' for ' + account.name + ' - ' + system.label.Order_needs_to_be_created;
      task.ActivityDate = System.today();
      task.Status = 'Not Started';
      task.RecordTypeId = RecordType_Relationship_Functions.GetCSRTaskType_Based_on_AccountRecordTypeId(account.RecordTypeId);
      task.Type = system.label.Sample_Request;
      task.Priority = 'Normal';
      task.Description = NoteToCsr + '\n\n' + system.label.Order_needs_to_be_created+'. ' + system.label.Sample_request + ': ' + Salesforce_System_Info_Functions.Retrieve_URL_Prefix() + '/' + sampleRequest.Id;

      insert task;

          List<String> toAddresses = new List<String>();
          toAddresses.add(retrieveEmailAddressfromUserId(sampleRequest.CSR_Responsible_for_Order_Entry__c));
          if(emailcsrgroupbox == true && account.SAP_CSR_Email__c != '' && account.SAP_CSR_Email__c != null){toAddresses.add(account.SAP_CSR_Email__c);}

      String targetURL = Salesforce_System_Info_Functions.Retrieve_URL_Prefix() + '/apex/Sample_Request_Enter_Order_Info_CSR?sampleRequestId=' + sampleRequest.Id + '&taskId=' + task.Id + '"';
        
      Boolean emailResult = Email_Functions.sendEmail(toAddresses,
                              null,
                              null,
                              retrieveEmailAddressfromUserId(sampleRequest.Sample_Coordinator__c),system.label.Sample_Coordinator,
                              false,false,
                              system.label.Sample_Request + '# ' + sampleRequest.name + ' for ' + account.name + ' - ' + system.label.Order_needs_to_be_Created,
                              system.label.Order_needs_to_be_created+'. ' + system.label.Sample_request + ' :' + targetURL,
                              system.label.Order_needs_to_be_created+'. ' + system.label.Sample_request + ' : <a href="' + targetURL + '" target="_blank">Click Here to Enter Order</a><br/><br/>Sample Notes: ' + samplerequest.Notes_Summary__c);       

      //Return the Sample Page
      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;     
  }

  
  public void init_Cancel_Request() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    if (sampleRequest.Sample_Coordinator__c != UserInfo.getUserId())
      {
      errorMessage = system.label.error_can_not_cancel;
      }
  }

  public Boolean Cancel_Request_Valid() {
    Boolean result = true;

    ValidationErrorMessage = '';

    if (sampleRequest.Cancellation_Reason__c == null)
      {
      ValidationErrorMessage = String_Functions.Format_ListString_into_HTML_List('You must enter a cancellation reason above before this Sample Request can be cancelled.','Error: ','');
      result = false;
      }

    return result;
  }
  public PageReference Cancel_Sample_Request() {
    PageReference result = null;
  
    errorMessage = '';

    if (sampleRequest != null) 
      {
      if (Cancel_Request_Valid() == true)
        {
        if (sampleRequest.Sample_Coordinator__c == UserInfo.getUserId())
          {
          String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Cancelled','Sample_Request__c');
          sampleRequest.RecordTypeId = NewRecordTypeId;
          sampleRequest.Status__c = 'Cancelled';
          sampleRequest.Sample_Approver__c = null;
          sampleRequest.Sample_Coordinator__c = null;
          sampleRequest.CSR_Responsible_for_Order_Entry__c = null;
          update sampleRequest;
  
          //Create a Note on the Sample Request with the Cancelled Reason
          Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,'Sample Request Cancelled',sampleRequest.Cancellation_Reason__c);
          Update sampleRequest;
          
          PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
          sampleRequestPage.setRedirect(true);
          result = sampleRequestPage;
          }
        else
          {
          //Display an Error Message
          errorMessage = system.label.error_can_not_cancel;
          result = null;
          }
       }   
      }
    else {result = null;}
  return result;
  }

  List<Sample_Material__c> sampleMaterials_toDelete;

  public List<Sample_Material__c> getSampleMaterials_toDelete() {

    if (sampleMaterials_toDelete == null)
      {
      String materialIds = System.currentPageReference().getParameters().get('materialIds');
      if ((materialIds != '') && (materialIds != null))
        {
        List<String> materialIdArray = materialIds.split(',');
  
        sampleMaterials_toDelete = [SELECT Id,
                                           Name,
                                           Actual_Ship_Date__c,
                                           AD_Compound__c,
                                           CurrencyIsoCode,
                                           Date_Required_By__c,
                                           Estimated_Arrival_Date__c,
                                           Estimated_Sample_Value__c,
                                           Estimated_Ship_Date__c,
                                           Existing_Material_in_SAP__c,
                                           Material_Must_Ship_From_Location__c,
                                           Potential_Annual_Value__c,
                                           Sample_Quantity__c,
                                           Sample_Request__c,
                                           Sample_UOM__c,
                                           SAP_Material__c,
                                           SAP_Material_Number__c,
                                           Ship_From_Location__c,
                                           Shipping_Carrier__c,
                                           Tectyl_Product__c,
                                           Tracking_Air_Bill__c,
                                           SAP_Material_MSD2__c
                                     FROM Sample_Material__c WHERE Id IN :materialIdArray];
        }
      }
    return sampleMaterials_toDelete;
  }

  public void init_Delete_Materials() {
    errorMessage = '';
  
    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();
  
    if (sampleRequest.OwnerId != UserInfo.getUserId())
      {
      errorMessage = system.label.error_can_not_delete;
      }
  }

  public PageReference Delete_Materials() {
    if (sampleMaterials_toDelete != null)
      {
      delete sampleMaterials_toDelete;
      }
    PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
    sampleRequestPage.setRedirect(true);
    return sampleRequestPage;
  }
  
  public void init_Edit_Materials() {
    errorMessage = '';
    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();
  }

  public PageReference Edit_Materials_Save() {
    
    PageReference result = null;
    
    getSampleRequest();
    getSampleMaterials();
    
    Boolean validMaterials = true;

    ValidationErrorMessage = '';

    sampleMaterials = Sample_Material_Functions.Remove_Blank_Rows_From_Material_List(sampleMaterials);

    ValidationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account.Id, 'InitialEntry', true, getbusiness()),'Error: ','');
    if (ValidationErrorMessage != '') 
      {validMaterials = false;}
      
    if (validMaterials == true)
      {
      String artypeid = account.recordtypeid;
       if(NA_SALES_ORGS.contains(account.SAP_Sales_Org__c) == false){
         artypeid += 'EMEA';
       }

      String sampleMaterial_RecordType = RecordType_Relationship_Functions.GetMaterialRecordType_Based_on_AccountRecordTypeId(artypeid);

      for (Sample_Material__c sampleMaterial : sampleMaterials)
        {
        if (sampleMaterial.Sample_Request__c == null)
          {
          Sample_Material__c newSampleMaterial = new Sample_Material__c(Additional_Admin_Cost__c = Additional_Cost_per_Line_Item);
          newSampleMaterial.Sample_Request__c = sampleRequest.id;
          newSampleMaterial.Name = sampleMaterial.Name;
          newSampleMaterial.Sample_Quantity__c = sampleMaterial.Sample_Quantity__c;
          newSampleMaterial.Sample_UOM__c = sampleMaterial.Sample_UOM__c;
          newSampleMaterial.Date_Required_By__c = sampleMaterial.Date_Required_By__c;
          newSampleMaterial.CurrencyIsoCode = sampleMaterial.CurrencyIsoCode;
          newSampleMaterial.Estimated_Sample_Value__c = sampleMaterial.Estimated_Sample_Value__c;
          newSampleMaterial.Potential_Annual_Value__c = sampleMaterial.Potential_Annual_Value__c;
          newSampleMaterial.Ship_From_Location__c = sampleMaterial.Ship_From_Location__c;
          newSampleMaterial.Tectyl_Product__c = sampleMaterial.Tectyl_Product__c;
          newSampleMaterial.AD_Compound__c = sampleMaterial.AD_Compound__c;
          newSampleMaterial.RecordTypeId = sampleMaterial_RecordType;
          
          insert newSampleMaterial;
          }
        else
          {
          if ((sampleMaterial.Name == null) || (sampleMaterial.Name == ''))
            {
            delete sampleMaterial;
            }
          else
            {
            update sampleMaterial;
            }
          }
        }
        
      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
      
    return result;      
  }
  
  String sampleRequestCompleted = 'true';

    public String getSampleRequestCompleted() {return sampleRequestCompleted;}
    public void setSampleRequestCompleted(String valueIn) {sampleRequestCompleted = valueIn;}

    public Boolean getRenderMarkSampleCompletedCheckbox() {
        Boolean result = false;
        
//            if ((SAMP_RECTYPES.get('Request Completed').getrecordtypeid() == sampleRequest.recordtypeid) && (errorMessage == ''))
            if ((sampleRequest.Status__c != 'Request Completed') && (errorMessage == ''))
                  {result = true;} 
        
            return result;
    }

  public void init_Enter_Actual_Shipping_Information() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();
    Id profileId=userinfo.getProfileId();
    system.debug('------'+profileId);
    String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
    system.debug('++++++'+profileName);
    if (sampleRequest.Sample_Coordinator__c != UserInfo.getUserId() && sampleRequest.CSR_Responsible_for_order_Entry__c != UserInfo.getUserID() && profileName != 'Nx Sales Support (Chemicals)')
      {
      errorMessage = system.label.Error_actual_shipping_info;
      }
    else{
      system.debug('+++++'+profileName);
      sampleMaterials = getsamplematerials();
      for(sample_material__c sm:samplematerials){
        if(sm.Actual_Ship_Date__c == null && sm.Estimated_Ship_Date__c != null){
        sm.Actual_Ship_Date__c = sm.Estimated_Ship_Date__c;}
      }//end for
    }//end else
  }

 public Boolean Actual_Shipping_Information_Valid() {
    Boolean result = true;
    
    ValidationErrorMessage = '';

    ValidationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account.Id, 'OrderShipped', true, getbusiness()),'Error: ','');
    if (ValidationErrorMessage != '') 
      {result = false;}

    return result;
  }

  public PageReference Save_Actual_Shipping_Information() {
    PageReference result = null;
    
    ValidationErrorMessage = '';

    if ((Actual_Shipping_Information_Valid() == true) || (sampleRequestCompleted == 'false')) 
      {
      if (sampleRequestCompleted == 'true')
        {
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Request Completed','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        sampleRequest.Status__c = 'Request Completed';
        update sampleRequest;
        }
      
      update sampleMaterials;
      
      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
    return result;
  }
  
  public String ShowMaterials='false';
  String sampleRequestOrderEntered = 'true';
  String prospectAccountInformation;
  String materialSpecificInstructions;
  public List<Note> sampleNotes;
  public Integer sampleNotesSize;
  
  public Integer getSampleNotesSize() {
    getsampleNotes();
    Integer result = 0;
    if (sampleNotes != null)
      {result = sampleNotes.Size();}
    return result;
  }
  
  public List<Note> getsampleNotes() {
    if (sampleNotes == null)
      {
        sampleNotes = Note_Functions.returnNotesRelatedtoObject(sampleRequest.Id);
      }
    
    return sampleNotes;
  }

  public Boolean getRenderSampleNotes() {
        Boolean result = false;
        
        if ((getSampleNotesSize() > 0) && (errorMessage == ''))
                {result = true;} 
        
        return result;
  }
  
  public String getShowMaterials() {return ShowMaterials;}

  public String getCSR_Found_on_Account() {return null;}

  public String getSampleRequestOrderEntered() {return sampleRequestOrderEntered;}
  public void setSampleRequestOrderEntered(String valueIn) {sampleRequestOrderEntered = valueIn;}

  public String getProspectAccountInformation() {
    prospectAccountInformation = '';
    prospectAccountInformation += system.label.ProspectAccountInfo1 + '<BR>';
    prospectAccountInformation += '<ul type=circle>';
    prospectAccountInformation += '<li>' + system.label.ProspectAccountInfo2 + ' <a href="http://prod.tradepointsystems.com/" target="_blank">http://prod.tradepointsystems.com/</a><BR><BR>';
    prospectAccountInformation += '<li>' + system.label.ProspectAccountInfo3 + '<BR><BR>';
    prospectAccountInformation += '<ul type=circle>';
    prospectAccountInformation += '<li>' + system.label.ProspectAccountInfo4 + '<BR><BR>';
    prospectAccountInformation += '<li>' + system.label.ProspectAccountInfo5;
    prospectAccountInformation += '</ul>';
    prospectAccountInformation += '</ul>';

    return prospectAccountInformation;
  }

  public String getMaterialSpecificInstructions() {
    materialSpecificInstructions = '';
    materialSpecificInstructions += system.label.SAP_Material_Instructions;

    return materialSpecificInstructions;
  }

    public String getEnterOrderInformationPageTitle() {
        String result = System.label.Enter_the_Order_Info;
        
            if (SAMP_RECTYPES.get('Waiting for Order Creation').getRecordtypeID() == sampleRequest.recordtypeid)
                  {result = system.label.update_estimated_dates;} 
        
            return result;
    }

    public Boolean getRenderMarkOrderCreatedCheckbox() {
        Boolean result = false;
        
            if ((SAMP_RECTYPES.get('Waiting for Order Creation').getRecordtypeID() == sampleRequest.recordtypeid) && (errorMessage == ''))
                  {result = true;} 
        
            return result;
    }

  public void init_Enter_Order_Information() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    if (sampleRequest.Sample_Coordinator__c != UserInfo.getUserId())
      {
      errorMessage = system.label.Error_actual_shipping_info    ;
      }
  }

  public Boolean Order_Entry_by_Coordinator_Valid() {
    Boolean result = true;

    ValidationErrorMessage = '';

    ValidationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Request_Functions.Validate_SAP_Order_Number(sampleRequest.SAP_Order_Number__c, true),system.label.Error + ': ','');
    ValidationErrorMessage += String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account.Id, 'OrderEntry-Coordinator', true, getbusiness()),system.label.Error + ': ','');

    if (ValidationErrorMessage != '') 
      {result = false;}

    return result;
  }

  public void ToggleShowMaterials() {
    if (ShowMaterials == 'true') {ShowMaterials='false';} else {ShowMaterials='true';}
  }

  public PageReference Save_Order_Information_Coordinator() {
    PageReference result = null;
  
    if ((Order_Entry_by_Coordinator_Valid() == true) || (sampleRequestOrderEntered == 'false'))
      {
      if (sampleRequestOrderEntered == 'true')
        {
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Order Created for Sample Request','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        sampleRequest.Status__c = 'Order Created for Sample Request';
        
        //Update Estimated_Ship_Date__c on Sample Request
        List<Date> EstimatedShipDates = new List<Date>();
        for (Sample_Material__c material:sampleMaterials)
          {
          EstimatedShipDates.Add(material.Estimated_Ship_Date__c);
          }
        sampleRequest.Estimated_Ship_Date__c = Date_Functions.returnLargestDate(EstimatedShipDates);
        
        String taskId = System.currentPageReference().getParameters().get('taskId');
        
        if ((taskId != '') && (taskId != null))
          {
          Task task = [SELECT Id, Status FROM Task WHERE Id = :taskId];
          task.status = 'Completed';
          update task;
          }
        }

      sampleMaterials = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(sampleMaterials);

      update sampleRequest;
      update sampleMaterials;
      
      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
        
    return result;      
  }

  
    public Boolean Allow_CSR_to_Take_OrderEntry_Responsibility = false;
    
    public Boolean getAllow_CSR_to_Take_OrderEntry_Responsibility() {
        return Allow_CSR_to_Take_OrderEntry_Responsibility;
    }

  public void init_Enter_Order_Information_CSR() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();

    Boolean TaskIncludedinURL = false;
    
    if (sampleRequest.CSR_Responsible_for_Order_Entry__c != null)
      {
      if (sampleRequest.CSR_Responsible_for_Order_Entry__c != UserInfo.getUserId())
        {
        String taskId = System.currentPageReference().getParameters().get('taskId');
        
        if ((taskId != '') && (taskId != null)) {Allow_CSR_to_Take_OrderEntry_Responsibility = true;}

        if (Allow_CSR_to_Take_OrderEntry_Responsibility == true)
            {errorMessage = system.label.Error_Order_Info_1 +  '<BR><BR>' + system.label.error_order_info_2 + '<BR><BR> ' + system.label.error_order_info_3;}
        else
            {errorMessage = system.label.error_order_info_1 +  '<BR><BR>' + system.label.error_order_info_4;}
        }
      }     
    else
      {errorMessage = system.label.error_CSR_not_requested + ' <BR><BR>' + system.label.error_sc_can_enter_order_info;}

    if (errorMessage != '')
        {
        String coordinatorName = '';
        String csrName = '';
        coordinatorName = User_Functions.RetrieveUserName(sampleRequest.Sample_Coordinator__c);
        csrName = User_Functions.RetrieveUserName(sampleRequest.CSR_Responsible_for_Order_Entry__c);
        if (coordinatorName != '') {errorMessage += '<BR><BR>' + system.label.Current_Sample_Coordinator + ': <a href="/' + sampleRequest.Sample_Coordinator__c + '" target="_blank">' + coordinatorName + '</a>';} 
        if (csrName != '') {errorMessage += '<BR>' + system.label.CSR_Responsible + ': <a href="/' + sampleRequest.CSR_Responsible_for_Order_Entry__c + '" target="_blank">' + csrName + '</a>';} 
        }   
      
  }

  // Step Validation
  public Boolean Order_Entry_by_CSR_Valid() {
    Boolean result = true;

    ValidationErrorMessage = '';

    //Perform Sample Request
    ValidationErrorMessage = String_Functions.Format_ListString_into_HTML_List(Sample_Request_Functions.Validate_SAP_Order_Number(sampleRequest.SAP_Order_Number__c, true),system.label.Error+': ','');
    
    //Perform Validation
    ValidationErrorMessage += String_Functions.Format_ListString_into_HTML_List(Sample_Material_Functions.Validate_Materials(sampleMaterials, account.Id, 'OrderEntry-CSR', true, getbusiness()),system.label.Error+': ','');

    if (ValidationErrorMessage != '') 
      {result = false;}

    return result;
  }

  // General Functions
  public PageReference Save_Order_Information_CSR() {
    PageReference result = null;
  
    if ((Order_Entry_by_CSR_Valid() == true) || (sampleRequestOrderEntered == 'false'))
      {
      if (sampleRequestOrderEntered == 'true')
        {
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Order Created for Sample Request','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        sampleRequest.Status__c = 'Order Created for Sample Request';
        
        //Update Estimated_Ship_Date__c on Sample Request
        List<Date> EstimatedShipDates = new List<Date>();
        for (Sample_Material__c material:sampleMaterials)
          {
          EstimatedShipDates.Add(material.Estimated_Ship_Date__c);
          }
        sampleRequest.Estimated_Ship_Date__c = Date_Functions.returnLargestDate(EstimatedShipDates);
        
        String taskId = System.currentPageReference().getParameters().get('taskId');
        
        if ((taskId != '') && (taskId != null))
          {
          Task task = [SELECT Id, Status, Total_Hours__c FROM Task WHERE Id = :taskId];
          task.status = 'Completed';
          if (task.Total_Hours__c == null) {task.Total_Hours__c = 0;}
          update task;
          }
        }

      sampleMaterials = Sample_Material_Functions.Populate_SAP_Material_Number_from_Materials_Table(sampleMaterials);

      update sampleRequest;
      update sampleMaterials;

      PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
      sampleRequestPage.setRedirect(true);
      result = sampleRequestPage;
      }
        
    return result;      
  }

    public PageReference Reassign_CSR_Associated_with_Sample_Request() {
        PageReference result = null;
    
        //Get the current users information
        Id newUserId = UserInfo.getUserId();
        String newUserName = UserInfo.getName();
        
        //Get the old CSRs Info
        Id oldUserId = sampleRequest.CSR_Responsible_for_Order_Entry__c;
        String oldUserName = User_Functions.RetrieveUserName(oldUserId);
        
        //Get the Sample Coordinators Info
        Id coordinatorUserId = sampleRequest.Sample_Coordinator__c;
        String coordinatorUserName = User_Functions.RetrieveUserName(coordinatorUserId);
        
        //Update the Sample Request with the new CSR
        sampleRequest.CSR_Responsible_for_Order_Entry__c = newUserId;
        //sampleRequest.Material_Summary__c = Sample_Material_Functions.SummarizeMaterialsonSampleRequest(sampleRequest.Id);
        update sampleRequest;
        
        //Send and Email to Both the CSR and Sample Coordinator
            List<String> toAddresses = new List<String>();
            toAddresses.add(retrieveEmailAddressfromUserId(oldUserId));
        toAddresses.add(retrieveEmailAddressfromUserId(coordinatorUserId));
        
        String subject = sampleRequest.Name + ' - ' + system.label.Backup_CSR_taken_over;
        String body = newUserName + system.label.is_backing_up + oldUserName + system.label.and_has_taken_over + sampleRequest.Name + '.' + '\n\n' + system.label.to_view_SR + ' ' +Salesforce_System_Info_Functions.Retrieve_URL_Prefix() + '/' + sampleRequest.Id + '\n\nSample Notes: ' + sampleRequest.Notes_Summary__c ;
        
            Boolean emailResult = Email_Functions.sendEmail(toAddresses,
                                  null,
                                  null,
                                  retrieveEmailAddressfromUserId(newUserId),newUserName,
                                  false,false,
                                  subject,
                                  body,
                                  null);       
        
        //Create a Note with the content of the Email
        Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,system.label.Backup_CSR_taken_over,newUserName + ' is backing up ' + oldUserName + ' ' +system.label.and_has_taken_over);
        Update SampleRequest;
        //Update the owner of the task
        String taskId = System.currentPageReference().getParameters().get('taskId');
        
        if ((taskId != '') && (taskId != null))
          {
          Task task = [SELECT Id, OwnerId, Status FROM Task WHERE Id = :taskId];
          task.OwnerId = newUserId;
          update task;
          }
        
        //Perform a refresh of the screen so they see the order entry screen 
        //String targetURL = '/apex/Sample_Request_Enter_Order_Info_CSR?sampleRequestId=' + sampleRequest.Id + '&taskId=' + taskId;
            PageReference CSROrderEntryPage = new PageReference('/apex/Sample_Request_Enter_Order_Info_CSR');
            CSROrderEntryPage.getParameters().put('sampleRequestId',sampleRequest.Id);
        CSROrderEntryPage.getParameters().put('taskId',taskId);
            CSROrderEntryPage.setRedirect(true);
        result = CSROrderEntryPage;
        
        return result;
    }

  
  public void init_Place_Request_On_Hold() {
    errorMessage = '';

    getSampleRequest();
    getAccount();
    getContact();
    getOpportunity();
    onhold_followup_task = new task();

    if (sampleRequest.Sample_Coordinator__c != UserInfo.getUserId())
            {
            errorMessage = system.label.error_can_not_place_on_hold;
            }
            
  }


  // Step Validation
  public Boolean Place_Request_On_Hold_Valid() {
    Boolean result = true;

    ValidationErrorMessage = '';

    //Perform Cancel Request Validation
    if (sampleRequest.On_Hold_Reason__c == null)
      {
      ValidationErrorMessage = String_Functions.Format_ListString_into_HTML_List(system.label.must_enter_reason,system.label.Error+': ','');
      result = false;
      }

    return result;
  }

  // General Functions
  public PageReference Place_Sample_Request_On_Hold() {
    PageReference result = null;
    errorMessage = '';

    if (sampleRequest != null) 
      {
      if (Place_Request_On_Hold_Valid() == true)
        {
        String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('On-Hold','Sample_Request__c');
        sampleRequest.RecordTypeId = NewRecordTypeId;
        sampleRequest.Status__c = 'On-Hold';
        update sampleRequest;
  
        //Create a Note on the Sample Request with the Cancelled Reason
        Boolean noteCreationResult = Note_Functions.createNote(sampleRequest.Id,'Sample Request Placed On-Hold',sampleRequest.On_Hold_Reason__c);
        update sampleRequest;
        
        //Send FollowUp Task to Selected User
        
        if(onhold_followup_task.ownerid != null){
        onhold_followup_task.subject = 'Follow-Up Required: Sample Request ' + samplerequest.name + ' Placed On-Hold';
        task_Functions.createtaskandsendemails(onhold_followup_task.ownerid, Samplerequest.id, onhold_followup_task.subject, samplerequest.on_hold_reason__c, account );
        }
        
        
        PageReference sampleRequestPage = new PageReference('/' + sampleRequest.id);
        sampleRequestPage.setRedirect(true);
        result = sampleRequestPage;
        }
      }
    else
      {
      result = null;
      }
  return result;
  }

// Generic Address Routines (Should eventually become a component
  // Variable Declaration
  public String Address_Street = '';
  public String Address_City = '';
  public String Address_State = '';
  public String Address_PostalCode = '';
  public String Address_Country = '';
  public String ShowUpdateAddressInformation='false';
  public String AddressChangeError = '';

  // Get/Set Functions
  public String getStreet() {return Address_Street;}
  public void setStreet(String street) {Address_Street = street;}

  public String getCity() {return Address_City;}
  public void setCity(String City) {Address_City = City;}

  public String getState() {return Address_State;}
  public void setState(String State) {Address_State = State;}

  public String getPostalCode() {return Address_PostalCode;}
  public void setPostalCode(String PostalCode) {Address_PostalCode = PostalCode;}

  public String getCountry() {return Address_Country;}
  public void setCountry(String Country) {Address_Country = Country;}

  public String getShowUpdateAddressInformation() {return ShowUpdateAddressInformation;}

  public String getAddressChangeError() {return AddressChangeError;}

  // Step Validation

  // General Functions
  public void UpdateAddressInformation_Button() {
    getSampleRequest();
    ShowUpdateAddressInformation = 'true';
    AddressChangeError = '';
    List <String> addressLines = new List<String>();
    addressLines.add(sampleRequest.Address_Line_1__c);
    addressLines.add(sampleRequest.Address_Line_2__c);
    addressLines.add(sampleRequest.Address_Line_3__c);
    addressLines.add(sampleRequest.Address_Line_4__c);
    String address = Address_Functions.convert4LineAddressto1(addressLines);

    Address_Street = address;
    Address_City = sampleRequest.City__c;
    Address_State = sampleRequest.State__c;
    Address_PostalCode = sampleRequest.Postal_Zip_Code__c;
    Address_Country = sampleRequest.Country__c;
  }


  public void SaveAddressChanges() {
    Boolean error = false;
    AddressChangeError = '';

    //Perform Validation
    if (Address_Street == '') {error = true;AddressChangeError+='<li>' + system.label.error_street_required;}
    if (Address_City == '') {error = true;AddressChangeError+='<li>' + system.label.error_city_is_required;}
//    if (Address_State == '') {error = true;AddressChangeError+='<li>Error: State/Province is Required.';}
    if (Address_PostalCode == '') {error = true;AddressChangeError+='<li>' + system.label.Error_Postal_Code_is_Required;}
    if (Address_Country == '') {error = true;AddressChangeError+='<li>' + system.label.error_country_required;}
    if (AddressChangeError!= '') {AddressChangeError = '<ul type=circle>' + AddressChangeError + '</ul>';}

    if (error == false)
            {
            List <String> addressLines = Address_Functions.convert1LineAddressto4(Address_Street);

            if (addressLines.size() > 0) {sampleRequest.Address_Line_1__c = addressLines.get(0);} else {sampleRequest.Address_Line_1__c = '';}
            if (addressLines.size() > 1) {sampleRequest.Address_Line_2__c = addressLines.get(1);} else {sampleRequest.Address_Line_2__c = '';}
            if (addressLines.size() > 2) {sampleRequest.Address_Line_3__c = addressLines.get(2);} else {sampleRequest.Address_Line_3__c = '';}
            if (addressLines.size() > 3) {sampleRequest.Address_Line_4__c = addressLines.get(3);} else {sampleRequest.Address_Line_4__c = '';}
            sampleRequest.City__c = Address_City;
            sampleRequest.State__c = Address_State;
            sampleRequest.Postal_Zip_Code__c = Address_PostalCode;
            sampleRequest.Country__c = Address_Country;
            sampleRequest.Ship_To_Address_Type__c = 'Manually Entered Address';
            }

    ShowUpdateAddressInformation = 'false';
  }

  public void CancelAddressChanges() {
    AddressChangeError = '';
    ShowUpdateAddressInformation = 'false';
  }

    public List<SelectOption> getUomSelectOptions() {
        return UOM_Conversion_Functions.getUomSelectOptions(accountRecordType);
    }
    
    public PageReference initAquarius() {
        if (sampleRequest != null && 
            sampleRequest.Aquarius_Sample__c && 
            aquarius == null) {
            Sample_Request_Aquarius aq = new Sample_Request_Aquarius();
            aquarius = aq.getSra(sampleRequest.Id);
        }
        return null;
    }
    
    private void populate_AD_Carrier_Number(){
      if(Carrier != '' && Carrier!= null && SampleRequest.UPS_Fed_Ex_Number__c != null){
            SampleRequest.UPS_Fed_Ex_Number__c = Carrier + ' ' + SampleRequest.UPS_Fed_Ex_Number__c;
      }
   }
   
   

//Test Methods are in Sample_Request_Controller_Test class 

//The End
  }