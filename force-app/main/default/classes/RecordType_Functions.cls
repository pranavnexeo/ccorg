public class RecordType_Functions {
    
    public static final String OBJECT_TYPE_ACCOUNT = 'Account';

    public static final String AAFI = 'AAFI'; 
    public static final String AHWT = 'AHWT'; 
    public static final String DISTRIBUTION = 'Distribution'; 
    public static final String PERFORMANCE_MATERIALS = 'Performance Materials'; 
    public static final String VALVOLINE = 'Valvoline'; 
    
    public static final Map<String, String> ACCOUNT_BUSINESS_MAP = new Map<String, String> {
        'Aqualon Customer' => AAFI, 
        'Aqualon Prospect' => AAFI, 
        'Aqualon Other Account' => AAFI,

        'Drew Customer' => AHWT, 
        'Water Prospect' => AHWT,

        'Distribution Customer' => DISTRIBUTION, 
        'Distribution Other Account' => DISTRIBUTION, 
        'Distribution Prospect' => DISTRIBUTION, 
        'Distribution Prospect-Plastics' => DISTRIBUTION,

        'Performance Materials Customer' => PERFORMANCE_MATERIALS, 
        'Performance Materials Other Account' => PERFORMANCE_MATERIALS, 
        'Performance Materials Prospect-CAST' => PERFORMANCE_MATERIALS, 
        'Performance Materials Prospect-CP' => PERFORMANCE_MATERIALS, 
        'Performance Materials Prospect-SPA' => PERFORMANCE_MATERIALS,

        'Valolvine Customer' => VALVOLINE, 
        'Valvoline DIFM EMEA Prospect' => VALVOLINE, 
        'Valvoline DIFM Prospect' => VALVOLINE, 
        'Valvoline DIY Prospect' => VALVOLINE, 
        'Valvoline Other DIFM Account' => VALVOLINE, 
        'Valvoline Other DIY Account' => VALVOLINE
    };
    
    public static String getBusinessNameForAccountType(Id accountRecordTypeId) {
        String businessName = '';
        Map<Id,String> amap = RetrieveRecordTypeIdMap(OBJECT_TYPE_ACCOUNT);
        String accountRecordType = '';
        if (amap.containsKey(accountRecordTypeId)) {
            accountRecordType = amap.get(accountRecordTypeId);
            if (ACCOUNT_BUSINESS_MAP.containsKey(accountRecordType)) {
                businessName = ACCOUNT_BUSINESS_MAP.get(accountRecordType);
            }
        }
        return businessName;
    }
    
  public static String LookupRecordTypeName(Id RecordTypeId) {

    RecordType recType;
    String RecordTypeName = '';

    if (RecordTypeId != null)
      {
        try {
              recType = [select Id, 
                                Name
                           from RecordType where Id = :RecordTypeId];
            }  
        catch (Exception e) 
            {
            //Most likely, no record was returned
            }
      }
    if (recType != null) {RecordTypeName = recType.Name;}
    return RecordTypeName;
  }

  public static Map<String, Id> RetrieveRecordTypeNameMap(String ObjectType) {
    
    return Schema_Functions.getRecordTypeNameMap(ObjectType);

/*
    Map<String,Id> results = new Map<String,Id>();

    List<RecordType> recTypes;

    try {
        recTypes = [select Id, Name
                      from RecordType 
                     where isActive = true 
                       and sObjectType = :ObjectType];
    } catch (Exception e) {
        //Most likely, no record was returned
    }

    if (recTypes != null) {
        for(RecordType r:recTypes) {
            results.put(r.Name,r.Id);
        }
    }

    return results;
*/
  }

  public static Map<String, Id> RetrieveRecordTypeNameMap() {

    Map<String,Id> results = new Map<String,Id>();

    List<RecordType> recTypes;

    try {
          recTypes = [select Id, 
                            Name,
                            sObjectType
                       from RecordType];
        } 
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }

    if (recTypes != null)
      {
        for(RecordType r:recTypes)
          {
            results.put(r.Name + '-' + r.sObjectType,r.Id);
          }
      }

    return results;
  }

  public static Map<Id,String> RetrieveRecordTypeIdMap(String ObjectType) {

    return Schema_Functions.getRecordTypeIdMap(ObjectType);

/*
    Map<Id,String> results = new Map<Id,String>();

    List<RecordType> recTypes;

    try {
          recTypes = [select Id, Name
                        from RecordType 
                       where isActive = true 
                         and sObjectType = :ObjectType];
    } catch (Exception e) {
        //Most likely, no record was returned
    }

    if (recTypes != null) {
        for(RecordType r:recTypes) {
            results.put(r.Id,r.Name);
        }
    }

    return results;
*/    
  }


  public static String LookupRecordTypeId(String RecordTypeName,String sObjectType) {

    String RecordTypeId = '';
    if ((RecordTypeName != null) && (sObjectType != null)) {
        Map<String, Id> rtnmap = RetrieveRecordTypeNameMap(sObjectType);
        if (rtnmap.containsKey(RecordTypeName)) {
            RecordTypeId = rtnmap.get(RecordTypeName);
        }
    }

/*
    RecordType recType;
    if ((RecordTypeName != null) && (sObjectType != null))
      {
        try {
              recType = [select Id, 
                                Name
                           from RecordType where Name = :RecordTypeName AND sObjectType = :sObjectType];
            } 
        catch (Exception e) 
            {
            //Most likely, no record was returned
            }
      }
    if (recType != null) {RecordTypeId = recType.Id;}
*/
    return RecordTypeId;
  }
  
  public static Map<Id, String> RetrieveAccRecordTypeMap() 
  {
      //Map to hold Account Record Type Ids and their values Customer/Vendor and Prospect/Other
      Map<Id, String> results = new Map<Id, String>();
      //List to hold all Account Record Types
      List<RecordType> accRecTypes = new List<RecordType>();
//*      
      Map<String, Id> rtmap = RetrieveRecordTypeNameMap('Account');
      for (String s : rtmap.keySet()) {
        if (s == 'KNA1' || s == 'Material Holder Account' || s == 'Partner Account') {
            continue;
        }
        accRecTypes.add(new RecordType(Id = rtmap.get(s), Name = s));
      }
//*/
      
/*      
      try
      {
          //Querying all active Account Record Types excluding KNA1, Material Holder Account and Partner Account
          accRecTypes = [Select Id, Name from RecordType where SobjectType = 'Account' AND IsActive = True AND Name <> 'KNA1' AND Name <> 'Material Holder Account' AND Name <> 'Partner Account'];
      }
      catch (Exception e)
      {
          //Most likely, no record was returned
      }
//*/      
      
      //logic to classify Record Types as Customer/Vendor or Prospect/Other
      if(accRecTypes != null)
      {
          for (Integer i=0;i<accRecTypes.size();i++) 
          {
              if (accRecTypes[i].Name.contains('Customer') || accRecTypes[i].Name.contains('Vendor')) 
              {
                  if (!(accRecTypes[i].Name.contains('Prospect') || accRecTypes[i].Name.contains('Other'))) 
                  {
                      results.put(accRecTypes[i].Id, 'Customer/Vendor');
                  }
              }
              else if (accRecTypes[i].Name.contains('Prospect') || accRecTypes[i].Name.contains('Other')) 
              {
                  results.put(accRecTypes[i].Id, 'Prospect/Other');
              }    
          }
      }
      
      return results;
  }
  
    public static Map<String, Map<String, Id>> getRecordTypeNameMap(List<String> objectNames) {
        return Schema_Functions.getRecordTypeNameMap(objectNames);
    }
    
    public static Map<String, Map<Id, String>> getRecordTypeIdMap(List<String> objectNames) {
        return Schema_Functions.getRecordTypeIdMap(objectNames);
    }
    
     public static String getDefaultRecordTypeId(schema.SobjectType objType){
    String toReturn = '';
    List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
    // If there are 2 or more RecordTypes...
    if (infos.size() > 1) {
        for (RecordTypeInfo i : infos) {
           if (i.isDefaultRecordTypeMapping() && i.isAvailable())
                toReturn = i.getRecordTypeId();
        }
    } 
    // Otherwise there's just the Master record type,
    // so add it in, since it MUST always be available
    else toReturn = infos[0].getRecordTypeId();
    return toReturn;
    }
     public static List<String> GetAvailableRecordTypeNamesForSObject(Schema.SObjectType objType) {
    List<String> names = new List<String>();
    List<RecordTypeInfo> infos = objType.getDescribe().getRecordTypeInfos();
    // If there are 2 or more RecordTypes...
    if (infos.size() > 1) {
        for (RecordTypeInfo i : infos) {
           if (i.isAvailable() 
           // Ignore the Master Record Type, whose Id always ends with 'AAA'.
           // We check the Id because Name can change depending on the user's language.
            && !String.valueOf(i.getRecordTypeId()).endsWith('AAA'))
                names.add(i.getName());
        }
    } 
    // Otherwise there's just the Master record type,
    // so add it in, since it MUST always be available
    else names.add(infos[0].getName());
    return names;
}
//The End
}