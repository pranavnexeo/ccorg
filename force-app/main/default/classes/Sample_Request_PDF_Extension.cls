public class Sample_Request_PDF_Extension {

    private final Sample_Request__c sampleRequest_from_Controller;
    public Sample_Request__c sampleRequest;
    public List<Sample_Material__c> sampleMaterials;
    private static final Map<Id,String> ACCOUNT_RECTYPES = RecordType_Functions.RetrieveRecordTypeIdMap('Account');
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
    private string accountRecordType;
    
    // The extension constructor initializes the private member
    // variable sampleRequest by using the getRecord method from the standard
    // controller.
    public Sample_Request_PDF_Extension(ApexPages.StandardController stdController) {
        this.sampleRequest_from_Controller = (Sample_Request__c)stdController.getRecord();
        
        getsampleRequest_AdditionalFields();
        accountRecordType = ACCOUNT_RECTYPES.get(samplerequest.Account__r.recordtypeid);
        
    }

    public Sample_Request__c getsampleRequest() {
        
        return sampleRequest;
    }

    public Sample_Request__c getsampleRequest_AdditionalFields() {
        
        if (sampleRequest == null)
            {
            sampleRequest = [SELECT 
                                Id, 
                                OwnerId, 
                                Owner.Name,
                                Name, 
                                RecordTypeId, 
                                Account__c,
                                Account__r.Name,
                                Account__r.AccountNumber,
                                Account__r.recordtypeid, 
                                AD_Compound__c, 
                                Additional_Comments__c, 
                                Address_Line_1__c, 
                                Address_Line_2__c, 
                                Address_Line_3__c, 
                                Address_Line_4__c, 
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
                                Opportunity__r.Name,
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
                                Contact_First_Name__c, 
                                Contact_Last_Name__c, 
                                Create_Contact_Record_on_Account__c, 
                                Tracking_Air_Bill__c, 
                                Carrier_Type_for_Sample_Delivery__c, 
                                Sample_Approver__c, 
                                Sample_Coordinator__c,
                                Sample_Coordinator__r.Name, 
                                Ship_To_Address_Type__c, 
                                Number_of_Items__c, 
                                Total_Value_of_Sample__c, 
                                Total_Potential_Annual_Value_of_Sample__c, 
                                Most_Valuable_Item_Value__c, 
                                Available_Actions__c, 
                                Cancellation_Reason__c, 
                                On_Hold_Reason__c, 
                                CSR_Responsible_for_Order_Entry__c, 
                                CSR_Responsible_for_Order_Entry__r.Name, 
                                Product_Development__c, 
                                AST_Sample__c,
                                Oak_Creek__c, 
                                Approval_Process__c, 
                                New_Prospect_Account__c, 
                                Contains_Material_Greater_Than_5_Gallons__c,
                                Material_Summary__c,
                                Account_Region__c,
                                PAC_Summary__c,
                                Material_Plant__C,
                                UPS_Fed_Ex_Number__c
                               FROM Sample_Request__c 
                              WHERE Id = :sampleRequest_from_Controller.Id];
                                                     
            }
            
        return sampleRequest;
        
    }

  public List<Sample_Material__c> getSampleMaterials() {

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
                                  Sample_Quantity__c, 
                                  Sample_UOM__c, 
                                  Estimated_Sample_Value__c, 
                                  Potential_Annual_Value__c, 
                                  Ship_From_Location__c, 
                                  Date_Required_By__c, 
                                  AD_Compound__c, 
                                  Tectyl_Product__c, 
                                  Estimated_Arrival_Date__c, 
                                  Estimated_Ship_Date__c, 
                                  Actual_Ship_Date__c, 
                                  Sample_Request__c, 
                                  Shipping_Result__c, 
                                  Customer_Expectations_Met_on_Delivery__c, 
                                  Tracking_Air_Bill__c, 
                                  Shipping_Carrier__c, 
                                  Track_Shipment__c, 
                                  SAP_Material__c,
                                  SAP_Material__r.Name, 
                                  SAP_Material_Number__c,
                                  SAP_Material_MSD2__c,
                                  SAP_Material_MSD2__r.name, 
                                  Existing_Material_in_SAP__c, 
                                  Material_Must_Ship_From_Location__c, 
                                  Product_Line__c,
                                  PAC_Industry_Segment__c,
                                  material__C
                                  FROM Sample_Material__c WHERE Sample_Request__c = :sampleRequest.Id];
        }
    }
    return sampleMaterials;
  }    

  public List<Note> sampleNotes;
  public Integer sampleNotesSize;
  
  // Get/Set Functions
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


    public String getHeaderDetailLine() {
    
        String result;
        
        result = 'Information as of ' + getLongDate();
        
        return result;
        
    }


    String LongDate = ' ';

    // Init cLongDate with the current Datetime in long date format    
    public String getLongDate() {
        Datetime cDT = System.now();
        LongDate = cDT.format('EEEE, MMMM d, yyyy');
        return LongDate;
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

//******************
//Test Method 
//******************

    static testMethod void TestMe() {
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Map<String, Id> AccountRecordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');

        Account TestAccount1a  = new Account(Name='Test1a',AccountNumber='Prospect',
                                     SAP_Sales_Org__c='0315',
                                     //RecordTypeId=AccountRecordTypeMap.get('Aqualon Other Account'));
                                     RecordTypeId=AccountRecordTypeMap.get('Distribution Customer'));
        insert TestAccount1a;

        Sample_Request__c TestSample1a  = new Sample_Request__c(Account__c= TestAccount1a.Id);
        insert TestSample1a;
    
        Sample_Material__c TestMaterial1a  = new Sample_Material__c(Sample_Request__c= TestSample1a.Id,
                                                 AD_Compound__c=false,Tectyl_Product__c=false);
        insert TestMaterial1a;

        Sample_Request__c sr = null;
        try {
            sr = [SELECT Id FROM Sample_Request__c LIMIT 1];
        } catch(Exception e) {}
        if (sr == null) {return;}

        ApexPages.StandardController sc = new ApexPages.StandardController(sr);
        Sample_Request_PDF_Extension cls = new Sample_Request_PDF_Extension(sc);
        cls.getisDistribution();

        Sample_Request__c sr_test = cls.getsampleRequest();
    
        Sample_Request__c sr_test2 = cls.getsampleRequest_AdditionalFields();
        
        List<Sample_Material__c> materials = cls.getSampleMaterials();
        
        Integer notessize = cls.getSampleNotesSize();
        
        String header = cls.getHeaderDetailLine();
        
        String address = cls.getSampleRequestAddress();
        
    }

//The End    
 

}