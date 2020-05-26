public class SampleRequestSplitter{

private list<Sample_Material__c> samplematerials {get; set;}
private set<ID> matids{get; set;}
private String SampleRequestId{get; set;}
private Sample_Request__C SampleRequest {get; set;}

public SampleRequestSplitter(ApexPages.standardsetcontroller ssc){
  matids = new set<ID>();
  samplematerials = (List<Sample_Material__c>)ssc.getselected();
  for(sample_material__c sm:samplematerials){
    matids.add(sm.id);
  }

  samplematerials = [select id, sample_request__c from sample_material__c where id IN :matids];
  SampleRequestId = '';
  for(sample_material__c sm:samplematerials){
    SampleRequestId = sm.sample_request__c;
  }
  samplematerials = getSampleMaterials();
}

public pagereference split(){
  
  List<sample_material__c> mats = new list<Sample_Material__c>();
  SampleRequest = getSampleRequest();
  Sample_Request__c newSampleRequest = SampleRequest.clone(false);
  newsamplerequest.split_from__c = sampleRequest.id;
  insert newSampleRequest;
  
  for(sample_material__c sm:samplematerials){  
    Sample_material__c newsm = sm.clone(false);
    newsm.sample_request__c = newsamplerequest.id;
    mats.add(newsm);
  }
    insert mats;
    delete samplematerials;
    
    Approval_Functions.submitrecord(newsamplerequest.id, 'Submitting Samples Split from Sample Request ' + sampleRequest.Name);
    return new pagereference('/'+newSampleRequest.id);
}

  private Sample_Request__c getSampleRequest() {

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
                                Material_Plant__C
                                FROM Sample_Request__c WHERE Id = :sampleRequestId];

    return sampleRequest;
  }
  
  private List<Sample_Material__c> getSampleMaterials() {
    //Make sure we have a sampleRequest object
    getSampleRequest();
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
                                  Requested_Supplier__c,
                                  SAP_Material_MSD2__c
                                  FROM Sample_Material__c WHERE id IN :matids];

    return sampleMaterials;
  }    
}