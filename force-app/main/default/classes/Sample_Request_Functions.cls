global class Sample_Request_Functions {

  public static String Validate_SAP_Order_Number(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
      {result = 'The Order Number needs to be populated to Save';}

    return result;
  }

  WebService static void AssignMyselfasCoordinator(String SampleRequestId) {
    Sample_Request__c sampleRequest = [SELECT Id, Sample_Coordinator__c
    FROM Sample_Request__c WHERE Id = :SampleRequestId];
    sampleRequest.Sample_Coordinator__c = UserInfo.getUserId();
    String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Waiting for Order Creation','Sample_Request__c');
    sampleRequest.RecordTypeId = NewRecordTypeId;
    sampleRequest.Status__c = 'Waiting for Order Creation';
    sampleRequest.On_Hold_Reason__c = '';
    sampleRequest.Cancellation_Reason__c = '';
  
    update sampleRequest;
  }

  WebService static void RemoveRequestfromHold(String SampleRequestId) {
    Sample_Request__c sampleRequest = [SELECT Id, Sample_Coordinator__c
    FROM Sample_Request__c WHERE Id = :SampleRequestId];

    if (sampleRequest.Sample_Coordinator__c == UserInfo.getUserId())
      {
      String NewRecordTypeId = RecordType_Functions.LookupRecordTypeId('Waiting for Order Creation','Sample_Request__c');
      sampleRequest.RecordTypeId = NewRecordTypeId;
      sampleRequest.Status__c = 'Waiting for Order Creation';
      sampleRequest.On_Hold_Reason__c = '';
      sampleRequest.Cancellation_Reason__c = '';

      update sampleRequest;
      }
    else
      {
      //Display an Error Message - assert?
      }
  }


  WebService static void Update_Approval_Process(String sampleRequestId) {
    Sample_Request__c sampleRequest;
    List<Sample_Material__c> sampleMaterials;
    Account account;
    
    sampleRequest = Sample_Request_Functions.Select_All_Fields(sampleRequestId);
    sampleMaterials = Sample_Material_Functions.Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequestId);
    account = Account_Functions.Select_Fields_Needed_for_Sample_Requests(sampleRequest.Account__c);

    sampleRequest.Approval_Process__c = SampleRequestApprovalProcess_Functions.lookup_Approval_Process(sampleRequest, sampleMaterials);
    sampleRequest.New_Prospect_Account__c = Account_Functions.isNewProspect(sampleRequest.Account__c);
    sampleRequest.Contains_Material_Greater_Than_5_Gallons__c = Sample_Material_Functions.List_Contains_Material_Greater_Then_5_Gallons(sampleMaterials);
    sampleRequest.Parent_Account_Name__c = account.Name;
    sampleRequest.Parent_Account_Owner__c = account.OwnerId;
    sampleRequest.Account_Region__c = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(account.SAP_Sales_Org__c);

    update sampleRequest;
  }

  public static Sample_Request__c Select_All_Fields(Id sampleRequestId) {
    List<Id> sampleRequestIds = new List<Id>();
    sampleRequestIds.add(sampleRequestId);
    List<Sample_Request__c> sampleRequests = Select_All_Fields(sampleRequestIds);
    return sampleRequests[0];
  }

  public static List<Sample_Request__c> Select_All_Fields(List<Id> sampleRequestIds) {
        List<Sample_Request__c> sampleRequests = [SELECT 
                                                        Id, 
                                                        OwnerId, 
                                                        Name, 
                                                        RecordTypeId, 
                                                        AD_Compound_Count__c, 
                                                        AD_Compound__c, 
                                                        AST_Sample__c, 
                                                        Account_Region__c,
                                                        Account__c, 
                                                        Additional_Comments__c, 
                                                        Address_Line_1__c, 
                                                        Address_Line_2__c, 
                                                        Address_Line_3__c, 
                                                        Address_Line_4__c, 
                                                        Approval_Date__c, 
                                                        Approval_Process__c, 
                                                        Aqualon_Hazardous_Material__c,
                                                        Aquarius_Sample__c,
                                                        Ashland_Requestor__c, 
                                                        Available_Actions__c, 
                                                        CSR_Responsible_for_Order_Entry__c, 
                                                        Cancellation_Reason__c, 
                                                        Carrier_Type_for_Sample_Delivery__c, 
                                                        City__c, 
                                                        Contact_First_Name__c, 
                                                        Contact_Last_Name__c, 
                                                        Contact_Phone_Number__c, 
                                                        Contact__c, 
                                                        Contains_Material_Greater_Than_5_Gallons__c,
                                                        Cost_Center__c,
                                                        Country__c, 
                                                        Create_Contact_Record_on_Account__c, 
                                                        Customer_Requestor__c, 
                                                        Customer_Ship_To_Contact__c, 
                                                        Date_Required_By__c, 
                                                        Dist_Channel_Desc__c, 
                                                        Dist_Channel__c, 
                                                        Division_Desc__c, 
                                                        Division__c, 
                                                        Estimated_Arrival_Date__c, 
                                                        Estimated_Sample_Value__c, 
                                                        Estimated_Ship_Date__c, 
                                                        If_unknown_product_description__c, 
                                                        Material_Summary__c,
                                                        Material__c, 
                                                        Most_Valuable_Item_Value__c,
                                                        Nanjing_Material__c,
                                                        New_Prospect_Account__c, 
                                                        Number_of_Items__c, 
                                                        OEM__c, 
                                                        Oak_Creek__c,
                                                        On_Hold_Reason__c, 
                                                        Opportunity__c, 
                                                        Parent_Account_Name__c, 
                                                        Parent_Account_Owner__c, 
                                                        Parent_Account_RecordType__c, 
                                                        Postal_Zip_Code__c, 
                                                        Potential_Annual_Volume_Quantifier__c, 
                                                        Potential_Annual_Volume__c, 
                                                        Product_Development__c, 
                                                        Reason_for_Sample__c, 
                                                        Region__c, 
                                                        SAP_Order_Number__c, 
                                                        SalesOffice__c, 
                                                        Sales_District_Desc__c, 
                                                        Sales_District__c, 
                                                        Sales_Group_Desc__c, 
                                                        Sales_Group__c, 
                                                        Sales_Office_Desc__c, 
                                                        Sales_Office__c, 
                                                        Sales_Org__c, 
                                                        Sample_Approver__c, 
                                                        Sample_Coordinator__c, 
                                                        Sample_Size_Other__c, 
                                                        Sample_Size__c, 
                                                        Ship_From_Location__c, 
                                                        Ship_To_Address_Type__c, 
                                                        State__c, 
                                                        Status__c, 
                                                        Tectyl_Product_Count__c, 
                                                        Tectyl_Product__c, 
                                                        Total_Potential_Annual_Value_of_Sample__c, 
                                                        Total_Value_of_Sample__c, 
                                                        Tracking_Air_Bill__c, 
                                                        Update_All_Information__c 
                                                        FROM Sample_Request__c WHERE Id IN :sampleRequestIds];
    return sampleRequests;                                                        
  }
  

//******************
//Test Method 
//******************
  static testMethod void TestMe() {
    Test.startTest();
    System.assertEquals('',Validate_SAP_Order_Number('', false));
    System.assertEquals('The Order Number needs to be populated to Save',Validate_SAP_Order_Number('', true));

    Sample_Request__c sampleRequest = new Sample_Request__c();
    insert sampleRequest;
    
    AssignMyselfasCoordinator(sampleRequest.Id);
    RemoveRequestfromHold(sampleRequest.Id);

    try {
        Update_Approval_Process([SELECT Id FROM Sample_Request__c WHERE Account__c != null LIMIT 1].Id);
    } catch(Exception e) {}
    Test.stopTest();
  }

//The End
}