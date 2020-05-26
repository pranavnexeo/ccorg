public class Opportunity_RecordType_Selection{



public String recordtypelist{get; set;}
public List<RecordType> recordtypes{get; set;}
public boolean autoRedirect{get; set;}
public string autoRedirectId{Get; set;}

public string rtype{get; set;}

public Opportunity_RecordType_Selection(ApexPages.standardcontroller sc){
  
   recordtypelist = '';
   set<id> recordtypeids = new set<id>();
   Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
   for(string s:RecordType_Functions.GetAvailableRecordTypeNamesForSObject(sc.getRecord().getSobjectType()))
   {  recordtypeids.add(RTMap.get(s).getrecordtypeid());
      recordtypelist += '<option class="rectypeoption" value="' + RTMap.get(s).getrecordtypeid() + '">' + s + '</option>';
   }
   recordtypes = [select id, name, description from recordtype where id IN :recordtypeids];
   autoRedirect= (recordtypes.size() == 1);
   autoRedirectId = '';
   if(autoRedirect)
     autoRedirectId = recordtypes.get(0).Id;
}



@RemoteAction
public static string getURL(string rType, string accountid, string contactid, string churnid, string returl, string cancelurl, string conftoken){

   string baseurl = '';
   Map<String, Schema.RecordTypeInfo> RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
   
   
   if(rType == RTMap.get('Distribution Plastics').getrecordtypeid())
     baseurl = '/apex/OpportunityNewPlastics?rid=' + rType;
   else if (rType == RTMap.get('Distribution Targets').getrecordtypeid())
     baseurl = '/apex/OpportunityComposite?rid=' + rType;
   else if (rType == RTMap.get('Distribution Environmental Services').getrecordtypeid())
     baseurl = '/apex/OpportunityEnvService?rid=' + rType;
   else if(rType == RTMap.get('Distribution Chemicals').getrecordtypeid())
     baseurl = '/apex/OpportunityArchwayChemicals?rid=' + rType;    
   else
     baseurl = '/006/e?ent=Opportunity&nooverride=1&RecordType=' + rtype;
   
   return baseurl + accountid + contactid + churnid + conftoken + cancelurl + returl ;
   
}
}