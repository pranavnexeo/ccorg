public class Sample_Material_Functions { 

  public static Boolean List_Contains_Material_Greater_Then_5_Gallons(List<Sample_Material__c> materials) {
    Boolean result = false;
    
    for(Sample_Material__c material:materials)
      {
      if (UOM_Conversion_Functions.UOMQty_Greater_Than_5_Gallons(material.Sample_UOM__c, material.Sample_Quantity__c) == true)
        {
        result = true;
        }
      }
      
    return result;      
  }

  public static List<Sample_Material__c> Populate_SAP_Material_Number_from_Materials_Table(List<Sample_Material__c> materials) {
    
    List<Sample_Material__c> results = new List<Sample_Material__c>();

    if (materials != null)
      {    
      List<Id> materialIds = new List<Id>();
      List<Id> materialSD2Ids = new List<Id>();
      
      for(Sample_Material__c material:materials)
        {materialIds.add(material.SAP_Material__c);
         materialSD2IDs.add(material.SAP_Material_MSD2__c);}
  
      Map<Id,CIS_Materials__c> materialMap = new Map<Id,CIS_Materials__c>([SELECT Id, Material_Number__c FROM CIS_Materials__c WHERE Id IN :materialIds]);
      Map<Id,Material_Sales_Data2__c> materialSD2Map = new map<Id,Material_Sales_Data2__c>([select id, Material_Number__c FROM Material_Sales_Data2__c WHERE Id IN:materialSD2Ids]);
      
      Sample_Material__c newMaterial;
      for(Sample_Material__c material:materials)
        {
          newMaterial = material;
               if(newmaterial.SAP_Material_MSD2__c != null){
                 newMaterial.SAP_Material_Number__c = String_Functions.removeLeadingZeros(materialSD2Map.get(newMaterial.SAP_Material_MSD2__c).Material_Number__c); 
               }
               else{
                 newMaterial.SAP_Material_Number__c = null; 
               }        
            
          results.add(newMaterial);
          System.debug('Material Id = ' + newMaterial.SAP_Material__c + ' - Number = ' + newMaterial.SAP_Material_Number__c);
          System.debug('SAP Material Id = ' + newMaterial.SAP_Material_MSD2__c + ' - Number = ' + newMaterial.SAP_Material_Number__c);
        }
      }  
      
    return results;
  }

//********************************************
//Remove Blank Rows from Material List
//********************************************

  public static List<Sample_Material__c> Remove_Blank_Rows_From_Material_List(List<Sample_Material__c> sampleMaterials) {

      List<Sample_Material__c> sampleMaterials_hold = new List<Sample_Material__c>();

      //Move the good records to the hold
      for (Sample_Material__c sampleMaterial : sampleMaterials)
        if (((sampleMaterial.name != '') && (sampleMaterial.name != null)) ||
            ((sampleMaterial.material__c != '') && (sampleMaterial.material__c != null))) {
            sampleMaterials_hold.add(sampleMaterial);
          }
    return sampleMaterials_hold;
    
  }

//********************************************
//Delete Materials no longer related to Sample
//********************************************
  public static void Delete_Sample_Materials_Not_In_List(Sample_Request__c sampleRequest,List<Sample_Material__c> sampleMaterials) {
  
    List<Sample_Material__c> existingMaterials;
    Boolean materialsStillExists = false;
    
    try {
          existingMaterials = [SELECT id
                                 FROM Sample_Material__c
                                WHERE Sample_Request__c = :sampleRequest.Id];
        } 
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
                             
    if (existingMaterials != null)
      {
        //Loop through materials that are in Salesforce
        for(Sample_Material__c existingMaterial:existingMaterials)
          {
            materialsStillExists = false;

            //Loop over materials that need to be on Sample based on current save
            for(Sample_Material__c sampleMaterial:sampleMaterials)
              {
                if (existingMaterial.Id == sampleMaterial.Id) {materialsStillExists = true;}
              }

            //If the material should no longer exist, remove it
            if (materialsStillExists == false) {delete existingMaterial;}
          }
      }                           
    
    
  }
  


//********************************************
//Material Field Availability based on Account
//********************************************

  static Account CurrentAccount;
  
  public static void populateCurrentAccount(Id accountId) {
    
    Boolean reloadAccount = false;
    
    
    if (CurrentAccount == null) {reloadAccount = true;}
    else 
        {
        if (CurrentAccount.id != accountId) {reloadAccount = true;}
        }
    
    if (reloadAccount == true)
        {
        CurrentAccount = [SELECT id, RecordTypeId, RecordType.Name, SAP_SALES_ORG__C, SAP_Sales_District_Desc__c, SAP_Sales_Group_Desc__c, SAP_Division_Desc__c, SalesOffice__c FROM Account WHERE Id = :accountId];  
        }

    system.Debug('reloadAccount = ' + reloadAccount);
    system.Debug('accountId = ' + accountId);
    system.Debug('CurrentAccount.id = ' + CurrentAccount.id);

  }


  public static Boolean SupportsTectylProducts(Id accountId) {

    Boolean result = false;
    
    populateCurrentAccount(accountId);
    
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(CurrentAccount.RecordTypeId);

    string region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(CurrentAccount.SAP_SALES_ORG__C);

    //Tectyl Products are only available in Valvoline EMEA
    if ((business == 'Valvoline') && ((region == 'EMEA')))
      {
      result = true;
      }

    return result;
  }


  public static Boolean SupportsProductLine(Id accountId) {

    Boolean result = false;
    
    populateCurrentAccount(accountId);
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(CurrentAccount.RecordTypeId);

    string region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(CurrentAccount.SAP_SALES_ORG__C);

    //Product Lines are only available in Valvoline Americas
        if ((business == 'Valvoline') && ((region == 'USA') || (region == 'CANADA') || (region == 'MEXICO') || (region == 'SOUTH AMERICA')))
      {
      result = true;
      }

    return result;

  }

  public static Boolean SupportsPMCastingsProductLine(Id accountId) {

    Boolean result = false;
    
    populateCurrentAccount(accountId);
    
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(CurrentAccount.RecordTypeId);

    string accountType = '';
    accountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(CurrentAccount.RecordTypeId);


    //Show Product Lines When the following is true
    if (
        (business == 'Performance Materials') && 
        (
          ((accountType == 'Customer') && (CurrentAccount.SAP_Division_Desc__c == 'Casting Solutions')) 
          || 
          ((accountType == 'Prospect') && (CurrentAccount.RecordType.Name == 'Performance Materials Prospect - CAST' || CurrentAccount.RecordType.Name == 'ASK Prospect'))
          ||
          ((accountType == 'Customer') && (CurrentAccount.SAP_Division_Desc__c == 'ASK Chemicals'))         
        )
       )
      {
      result = true;
      }

    return result;

  }


    public static Boolean SupportsAHWTProductLine(Id accountId) {

    Boolean result = false;
    
    populateCurrentAccount(accountId);
    
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(CurrentAccount.RecordTypeId);

    //Show Product Lines When the following is true
    if (
        (business == 'Water')   
       )
      {
      result = true;
      }

    
    return result;
  }
  
  public static Boolean SupportsADCompoundProducts(Id accountId) {

    Boolean result = false;
    
    populateCurrentAccount(accountId);
    
    string business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(CurrentAccount.RecordTypeId);

    string region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(CurrentAccount.SAP_SALES_ORG__C);

    //Product Lines are only available in Valvoline Americas
        if ((business == 'Distribution') && (region == 'EMEA'))
      {
      result = true;
      }

    return result;

  }

  public static Boolean SupportsProductDevelopment(Id accountId) {

    Boolean result = false;
    
    populateCurrentAccount(accountId);
    
    String recordTypeName = RecordType_Functions.LookupRecordTypeName(CurrentAccount.RecordTypeId);

    String business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(CurrentAccount.RecordTypeId);

    String region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(CurrentAccount.SAP_SALES_ORG__C);
    
    String prospectRegion = '';
    if ((CurrentAccount.SalesOffice__c == '2150-> CM NORTH') || 
        (CurrentAccount.SalesOffice__c == '2160-> CM SOUTH') || 
        (CurrentAccount.SalesOffice__c == '2170 ->CM SPECIALTY')) 
       {prospectRegion = 'EMEA';}

    if ((recordTypeName == 'Valvoline DIFM EMEA Prospect') &&
        (
         (CurrentAccount.SAP_Sales_Group_Desc__c == 'CENTRAL CHINA') || 
         (CurrentAccount.SAP_Sales_Group_Desc__c == 'EAST CHINA') || 
         (CurrentAccount.SAP_Sales_Group_Desc__c == 'SOUTHEAST CHINA') || 
         (CurrentAccount.SAP_Sales_Group_Desc__c == 'SOUTHWEST CHINA') || 
         (CurrentAccount.SAP_Sales_Group_Desc__c == 'WEST CHINA') || 
         (CurrentAccount.SAP_Sales_Group_Desc__c == 'NORTH CHINA') 
        )
       ) 
       {prospectRegion = 'CHINA';}
       
    if (
        ((business == 'Valvoline') && (prospectRegion != 'CHINA') && (Region != 'CHINA')) ||
        ((recordTypeName == 'Performance Materials Prospect - CP') && (prospectRegion == 'EMEA')) ||
        ((recordTypeName == 'Performance Materials Customer') && (Region == 'EMEA'))
       )
      {
      result = true;
      }

    return result;
  }
  
  public static Boolean SupportsASTSamples() {
    Boolean result = false;
    //Id currentUserId;
    //currentUserId = UserInfo.getUserId();
    //User currentUser = [SELECT Id, AST_Sample_User__c FROM User WHERE Id = :currentUserId];
    //result = currentUser.AST_Sample_User__c;
    
    result = true;
    return result;
  }

  public static Boolean SupportsOakCreek(Id accountId) {

    Boolean result = false;
    populateCurrentAccount(accountId);
    
    String recordTypeName = RecordType_Functions.LookupRecordTypeName(CurrentAccount.RecordTypeId);

    String business = '';
    business = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(CurrentAccount.RecordTypeId);

    Boolean SPA_Division = false;
    if (CurrentAccount.SAP_Division_Desc__c == 'Specialty Poly & Adh')
      {SPA_Division = true;}

    if (recordTypeName == 'Performance Materials Prospect - SPA')
      {SPA_Division = true;}

    String region = '';
    region = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(CurrentAccount.SAP_SALES_ORG__C);
    
    String prospectRegion = '';
    if ((CurrentAccount.SAP_Sales_District_Desc__c == 'ASIA REGION')) 
       {prospectRegion = 'CHINA';}
       
    if ((business == 'Performance Materials') && (SPA_Division == true) && (region != 'CHINA') && (prospectRegion != 'CHINA'))
      {result = true;}

    return result;
  }


//**********************************
//Material Field Validation Routines
//**********************************

  public static String Validate_Ship_From_Location(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Ship From Location</u> is required on material';}
    
    return result;
  }
  
/*  public static String Validate_Nanjing(boolean isNanjing, string NanjingMaterial){
     string result = '';
     if(isNanjing == true && (NanjingMaterial == null || NanjingMaterial == '')){
        result = '<u>Nanjing Material Number</u> is required';}
     if(isNanjing == false && NanjingMaterial != null && NanjingMaterial != ''){
        result = '<u>Nanjing Material</u> must equal true when Nanjing Material Number equals ' + NanjingMaterial;}
     return ''; 
  }*/
  
  public static String Validate_Name(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
    {     result = '<u>Material Name</u> is required on material';}

    return result;
  }

  public static String Validate_Estimated_Ship_Date(Date dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Estimated Ship Date</u> is required on material';}

    return result;
  }

  public static String Validate_Estimated_Arrival_Date(Date dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Estimated Arrival Date</u> is required on material';}

    return result;
  }

  public static String Validate_Actual_Ship_Date(Date dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Shipping Plant</u> is required on material';}

    return result;
  }

  public static String Validate_Material_Must_Ship_From_Location(Boolean dataIn, String Ship_From_Location, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == true))  
        {
        if ((Ship_From_Location == '') || (Ship_From_Location == null))
                {
                 result = '<u>Ship From Location</u> is required when "Material Must Ship From Location" is selected on material';
                }
        }
    return '';
  }

  public static String Validate_Shipping_Carrier(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Shipping Carrier</u> is required on material';}

    return result;
  }

  public static String Validate_Product_Line(String dataIn, Id accountId, Boolean required) {
    String result = '';

    if ((required == true) && SupportsProductLine(accountId) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Product Line</u> is required on material';}

    return '';
  }

  public static String Validate_PM_Castings_Product_Line(String dataIn, Id accountId, Boolean required) {
    String result = '';

    //if ((required == true) && SupportsPMCastingsProductLine(accountId) && ((dataIn == '') || (dataIn == null)))
    //  {result = '<u>Product Line</u> is required on material';}

    return '';
  }


  public static String Validate_Sample_UOM(String dataIn, Boolean required) {
    String result = '';

    if ((required == true) && ((dataIn == '') || (dataIn == null)))
      {result = '<u>Sample UOM</u> is required on material';}

    return result;
  }
  
  public static String Validate_Opportunity(String OppId, boolean required) {
    String result = '';

    if ((required == true) && ((OppId == '') || (OppId == null)))
      {result = '<u>Opportunity</u> is required on material';}

    return result;
  }

  public static String Validate_Date_Required_By(Date dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Date Required By</u> is required on material';}

    return result;
  }

  public static String Validate_Sample_Quantity(Decimal dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Sample Quantity</u> is required on material';}

    return result;
  }

  public static String Validate_Estimated_Sample_Value(Decimal dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Estimated Sample Value</u> is required on material';}

    return '';
  }

  public static String Validate_Potential_Annual_Value(Decimal dataIn, Boolean required) {
    String result = '';

    if ((required == true) && (dataIn == null)) 
      {result = '<u>Potential Annual Value</u> is required on material';}

    return '';
  }

  public static String Validate_Material_Plant(String FirstPlant, String CurrentPlant) {
    String result = '';

    if (FirstPlant != '' && FirstPlant != CurrentPlant) 
      {result = '<u>All Material Plants</u> must be the same' ;}

    return result;
  }
  
  public static String Validate_Material_Picklist(String Plant, String Material) {
    String result = '';

    if((plant != '' && plant != null) && (Material == '' || Material == null)){
      result = '<u>Material</u> Required When Material Plant equals ' + Plant;}

    return result;
  }
  
  public static String Validate_PAC(String PAC, String Business) {
    String result = '';

    if((PAC == null || PAC == '' ) && Business == 'Aqualon'){
      result = '<u>PAC Industry Segment</u> is Required';}

    return '';
  }

  public static String Validate_Same_Pac(String FirstPAC, String CurrentPAC) {
    String result = '';

    if (FirstPAC != '' && FirstPAC != CurrentPAC) 
      {result = '<u>All PAC Industry Segments</u> must be the same' ;}

    return '';
  }

  //*********************
  //Material Validators
  //*********************

  public static List<String> Validate_Materials(List<Sample_Material__c> materials, Id accountId, String validationProcess, Boolean AddNameasSuffix, String Business) {
    
    String ErrorSuffix;
    List<String> allErrors = new List<String>();
    List<String> errors;
    String FirstPlant = '';
    String FirstPAC = '';
    
    for (Sample_Material__c material:materials)
      {
      if((material.material_Plant__c != null && material.material_plant__c != '')&&
         (FirstPlant == null || FirstPlant == '')){
       
         FirstPlant = material.material_Plant__c;  }
      if((material.PAC_Industry_Segment__c != null && material.PAC_Industry_Segment__c != '')&&
         (FirstPAC == null || FirstPAC == '')){
       
         FirstPAC = material.PAC_Industry_Segment__c;  }   
         
      }
      
      for (Sample_Material__c material:materials)
      {
      if (AddNameasSuffix == true) {ErrorSuffix = material.Name;} else {ErrorSuffix = '';}
      errors = Validate_Material(FirstPlant, FirstPAC, material, accountId, validationProcess, ErrorSuffix, business);
      if (errors.size() > 0)
          {
            for (String err:errors)
              {
                allErrors.add(err);
              }
          }
      }
      
    return allErrors;      
  }
  

  public static List<String> Validate_Material(String FirstPlant, String FirstPAC, Sample_Material__c material, Id accountId, String validationProcess, String business) {
    return Validate_Material(FirstPlant, FirstPAC, material, validationProcess,'', business);
  }

  public static List<String> Validate_Material(String FirstPlant, String FirstPAC, Sample_Material__c material, Id accountId, String validationProcess, String ErrorSuffix, String Business) {
    List<String> results = new List<String>();
    String errorMessage = '';
    String suffix = '';
    
    //Set up the suffix if necessary
    if (ErrorSuffix != '') {suffix = ':' + ErrorSuffix;}
    
    if (validationProcess == 'InitialEntry')
      {
        errorMessage = Validate_Same_PAC(FirstPAC, material.PAC_Industry_Segment__c);
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      
        errorMessage = Validate_PAC(material.PAC_Industry_Segment__c, business);
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      
        errorMessage = Validate_Material_Plant(FirstPlant, material.material_plant__c);
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      
        errorMessage = Validate_Material_Picklist(material.material_plant__c, material.material__c);
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      
     //   errorMessage = Validate_Nanjing(material.nanjing_material__c, material.nanjing_material_number__c);
      //  if(errorMessage != '') {results.add(ErrorMessage + suffix);}
       
        if(material.material__c != '' && material.material__c != null && (material.name == null || material.name == '')){
         material.name = material.material__c;}
         
        errorMessage = Validate_Name(material.Name, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Sample_Quantity(material.Sample_Quantity__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Sample_UOM(material.Sample_UOM__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
       
        errorMessage = Validate_Product_Line(material.Product_Line__c, accountId, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_PM_Castings_Product_Line(material.PM_Castings_Product_Line__c, accountId, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Date_Required_By(material.Date_Required_By__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        //errorMessage = Validate_Estimated_Sample_Value(material.Estimated_Sample_Value__c, true); 
        //if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        //errorMessage = Validate_Potential_Annual_Value(material.Potential_Annual_Value__c, true); 
        //if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      }

    if (validationProcess == 'AssignOrderEntrytoCSR')
      {
        errorMessage = Validate_Name(material.Name, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Material_Must_Ship_From_Location(material.Material_Must_Ship_From_Location__c, material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      }
      
    if (validationProcess == 'OrderEntry-CSR')
      {
        errorMessage = Validate_Name(material.Name, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
        errorMessage = Validate_Ship_From_Location(material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
        errorMessage = Validate_Estimated_Ship_Date(material.Estimated_Ship_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Estimated_Arrival_Date(material.Estimated_Arrival_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Material_Must_Ship_From_Location(material.Material_Must_Ship_From_Location__c, material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      }
      
    if (validationProcess == 'OrderEntry-Coordinator')
      {
        errorMessage = Validate_Name(material.Name, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
        errorMessage = Validate_Ship_From_Location(material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
          
        errorMessage = Validate_Estimated_Ship_Date(material.Estimated_Ship_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Estimated_Arrival_Date(material.Estimated_Arrival_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
        
        errorMessage = Validate_Material_Must_Ship_From_Location(material.Material_Must_Ship_From_Location__c, material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      }

    if (validationProcess == 'OrderShipped')
      {
        errorMessage = Validate_Actual_Ship_Date(material.Actual_Ship_Date__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Ship_From_Location(material.Ship_From_Location__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}

        errorMessage = Validate_Shipping_Carrier(material.Shipping_Carrier__c, true); 
        if(errorMessage != '') {results.add(ErrorMessage + suffix);}
      }
    
    return results;
  }


  public static Map<String, Map<Id,String>> SummarizeMaterialsonSampleRequests(List<Id> sampleRequestIds) {
    
    Map<Id,String> materialresults = new Map<Id,String>();
    Map<Id,String> productlineresults = new Map<Id,String>();
    Map<ID,String> shippingresults = new Map<Id, String>();
    Map<ID,String> PACresults = new Map<Id, String>();
     
    Map<String, MAP<ID, String>> returnmap = new map<string, map<id, string>>();
    String result = '';
    String plresult = '';
    String sresult = '';
    String pacresult = '';
    
    List<Sample_Material__c> sampleMaterials = Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequestIds);
    
    for(Id sampleRequestId:sampleRequestIds)
        {
        result = '';
        plresult = '';
        sresult = '';
        pacresult = '';
        for(Sample_Material__c sampleMaterial:sampleMaterials)
            {
            if (sampleMaterial.Sample_Request__c == sampleRequestId)
                {
                result += 'Material: ' + sampleMaterial.Name;
                if (sampleMaterial.SAP_Material_Number__c!=null) {result += ' (' + sampleMaterial.SAP_Material_Number__c +')';}
                result += ' : ' + sampleMaterial.Sample_Quantity__c + ' ' + sampleMaterial.Sample_UOM__c;
                result += '\n';
                if (sampleMaterial.AHWT_Product_Line__c != null){
                plresult += sampleMaterial.AHWT_Product_Line__c + ';'; }
                if (sampleMaterial.PAC_Industry_Segment__c != null && !pacresult.contains(sampleMaterial.PAC_Industry_Segment__c)){
                pacresult += sampleMaterial.PAC_Industry_Segment__c + ';'; }
                sresult += 'Material: ' + sampleMaterial.name + '\n' + 'Tracking / Air Bill #: ';
                if(samplematerial.Tracking_Air_Bill__c != null){sresult += samplematerial.Tracking_Air_Bill__c;}
                sresult += '\n' + 'Carrier: ';
                if(samplematerial.shipping_carrier__c != null){sresult += samplematerial.shipping_carrier__c;}
                sresult += '\n' + 'Estimated Ship Date: ';
                if(samplematerial.estimated_ship_date__c != null){ sresult += samplematerial.estimated_ship_date__c.format();}
                sresult += '\n' + 'Actual Ship Date: ';
                if(samplematerial.actual_ship_date__c != null){ sresult += samplematerial.actual_ship_date__c.format();}
                sresult += '\n' + 'Estimated Arrival Date: ';
                if(samplematerial.estimated_arrival_date__c != null){ sresult += samplematerial.estimated_arrival_date__c.format(); }
                sresult += '\n' + 'Date Required: ';
                if(samplematerial.date_required_by__c != null){ sresult += samplematerial.date_required_by__c.format();}
                sresult += '\n\n';
                

                }
            }
        materialresults.put(sampleRequestId,result);
        productlineresults.put(sampleRequestID, plresult);
        shippingresults.put(sampleRequestID, sresult);
        pacresults.put(sampleRequestID, pacresult);
        } 



    returnmap.put('Material', materialresults);
    returnmap.put('Product Line', productlineresults);
    returnmap.put('Shipping Info', shippingresults);
    returnmap.put('PAC Info', pacresults);
    return returnmap;
  }




  public static List<Sample_Material__c> Select_All_Fields_Based_on_Sample_Request_Ids(Id sampleRequestId) {
    List<Id> sampleRequestIds = new List<Id>();
    sampleRequestIds.add(sampleRequestId);
    return Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequestIds);
  }

  public static List<Sample_Material__c> Select_All_Fields_Based_on_Sample_Request_Ids(List<Id> sampleRequestIds) {
        List<Sample_Material__c> sampleMaterials = [SELECT 
                                  Id, 
                                  Name,
                                  CurrencyIsoCode, 
                                  RecordTypeId, 
                                  CreatedDate, 
                                  CreatedById, 
                                  LastModifiedDate, 
                                  LastModifiedById, 
                                  SystemModstamp, 
                                  AD_Compound__c, 
                                  AHWT_Product_Line__c, 
                                  Actual_Ship_Date__c, 
                                  Customer_Expectations_Met_on_Delivery__c, 
                                  Date_Required_By__c, 
                                  Estimated_Arrival_Date__c, 
                                  Estimated_Sample_Value__c, 
                                  Estimated_Ship_Date__c, 
                                  Existing_Material_in_SAP__c, 
                                  Material_Must_Ship_From_Location__c,
                                  Nanjing_Material__c,
                                  Material__c,
                                  Material_Plant__c,
                                  PM_Castings_Product_Line__c,
                                  Potential_Annual_Value__c, 
                                  Product_Line__c,
                                  SAP_Material_Number__c, 
                                  SAP_Material__c,
                                  SAP_Material_MSD2__c, 
                                  Sample_Quantity__c, 
                                  Sample_Request__c, 
                                  Sample_UOM__c, 
                                  Ship_From_Location__c, 
                                  Shipping_Carrier__c, 
                                  Shipping_Result__c, 
                                  Tectyl_Product__c, 
                                  Track_Shipment__c, 
                                  Tracking_Air_Bill__c,
                                  Requested_Supplier__c,
                                  PAC_Industry_Segment__c
                                  FROM Sample_Material__c WHERE Sample_Request__c IN :sampleRequestIds];
    return sampleMaterials;                                                        
  }

//The End
}