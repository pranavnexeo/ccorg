public class Supplier_Page_Controller{

    Public String suppOptions{get; set;} 
    Public Static List<Opportunity> display_list = new List<Opportunity>();
    Public Static List<Opportunity> display_list1 = new List<Opportunity>();
    Public Static List<Material_Sales_Data2__c> display_list2 = new List<Material_Sales_Data2__c>();
    Public Static List<Sample_Request__c> display_list3 = new List<Sample_Request__c>();
    Public Static List<Supplier_Contact__c> display_list4 = new List<Supplier_Contact__c>();
    Public Static List<Attachment> display_list5 = new List<Attachment>();
    Public Static List<Nexeo_Competitor__c> display_list6 = new List<Nexeo_Competitor__c>();
    Public Static List<Sample_Material__c> display_list8 = new List<Sample_Material__c>();
    
    Public Static String supName{get; set;}
    public String iframeSource { get; set; }
    
    
    Public Static String supId{ get; set; }
    Public Static String supcode{ get; set; }
    
    Public Supplier_Page_Controller(){
    supId = '';
    supcode = '';
    
    supName = ApexPages.currentPage().getParameters().get('supname');
    supId = ApexPages.currentPage().getParameters().get('supid');
    supcode = ApexPages.currentPage().getParameters().get('supcode');
    
    suppOptions= '';
    iframeSource ='';
    
    for(Nexeo_Competitor__c s:[select id, Name  from Nexeo_Competitor__c where Competitor_or_Supplier__c = 'Supplier' and Status__c = 'Active' and Supplies_To__c = 'Chemicals' order by Name])
    {   suppOptions += '<option class="supp" ';
        suppOptions += 'value="' + string.valueof(s.id).substring(0, 15) + '">' + s.Name + '</option>';
    }
    
    if(supcode!= null && supcode != ''){
    //Nexeo_Competitor__c sc = [select id, Name, suppliercode__c  from Nexeo_Competitor__c where Id = :supId];
    
     iframeSource = 'https://qlikplas.nexeosolutions.com/QvAJAXZfc/opendoc.htm?document=qa%5Csales%20reports2.0%20-%20na.qvw&host=QVS%40CDCVQLKQ01&Select=LB526,3&Select=LB552,Supplier&Select=LB556,'+supcode;
    //iframeSource = system.label.Supplier_page_QV_Iframe+supcode;
    }
    
    
    
    }


    
@remoteaction
    public static List<Nexeo_Competitor__c> getAllRecords() {
          return [SELECT Id, Name, suppliercode__c, Web_Site__c, Competitor_or_Supplier__c, Supplies_To__c, Status__c, Call_Report__c,Product_Line_Manager__c,Product_Line_Manager__r.name,Product_Specialist__c,Product_Specialist__r.name,Technical_Service_Representative__c,Technical_Service_Representative__r.name FROM Nexeo_Competitor__c where Competitor_or_Supplier__c = 'Supplier' and Status__c = 'Active' and Supplies_To__c = 'Chemicals'];
    }  
    
   
    
@RemoteAction
Public static combogriddata getSingleOptions(String fname, List<String> ids, string q, string obj, string fields, string filters, string orderby, string mylimit){ 
List<sobject> records = new list<SObject>();
List<String> OrgsG2 = new List<String>();
String Ownermatch='';
string qstring; 
system.debug('Ids are:'+ids);
system.debug('Field is:'+fname);
system.debug('q is:'+q);
system.debug('fields are:'+fields);
system.debug('filters are:'+filters);
system.debug('obj is:'+obj);
 

if(obj != '' && fields != '')
{
  String query = '\'%' + q + '%\'';
  system.debug('filters***'+filters);
  string f = fields.replaceall('-id', '');
  
  qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id NOT IN :ids';  
    
  if(filters != null && filters != '')
    qstring += ' and ' + filters;

  /*List<String> myfields = fields.split(',');
  if(q != null && q != '' && myfields.size() > 0)
  {
    qstring += ' and (';
    for(integer i=0; i<myfields.size(); i++)
    { string s = myfields.get(i);
      if(!s.contains('-id'))
      {
      if(i != 0)
        qstring += ' OR ';
      qstring += s + ' LIKE ' + query;
      }
    }
    qstring += ')';
  }*/
  if(orderby != '' && orderby != null)
    qstring += ' ORDER BY ' + orderby;
  else
    qstring += ' ORDER BY Name ';
  qstring += ' LIMIT ' + mylimit;
  
  system.debug('getSelectOptions query is:'+qstring);
  records = database.query(qstring);
}
 combogriddata data = new combogriddata(records);
 system.debug('size: ' + records.size());
  
    
    
 return data;
}

@RemoteAction
public static combogriddata getData(List<formData> data){
Map<String, string> wheres = new Map<String, String>();
system.debug('data is:'+data);
for(formData fd:data){
    wheres.put(fd.name, fd.value);
}
system.debug('wheres##'+wheres);

String q = 'SELECT Name, Supplies_To__c, Web_Site__c, Call_Report__c,Product_Line_Manager__c,Product_Line_Manager__r.name,Product_Specialist__c,Product_Specialist__r.name,Technical_Service_Representative__c,Technical_Service_Representative__r.name FROM Nexeo_Competitor__c where Competitor_or_Supplier__c = \'Supplier\' and Status__c = \'Active\'';
  
String suppId;
  
 if(wheres.get('SearchBy') == 'Supplier'){
    suppId = wheres.get('SupplierName'); 
    q += 'and id =: suppId ';
  }
  else if(wheres.get('SearchBy') == 'SupplierContact'){
    String suppContactId = wheres.get('SupplierContact'); 
    List<Supplier_Contact__c> sc = [Select Competitor_Supplier_or_OEM__c from Supplier_Contact__c where id = : suppContactId];
    suppId = sc.get(0).Competitor_Supplier_or_OEM__c;
    q += 'and id =: suppId';
  }
  else if(wheres.get('SearchBy') == 'SAPMaterial'){
    String matId = wheres.get('SAP_Material'); 
    List<Material_Sales_Data2__c> mat = [Select PH4_Supplier__c from Material_Sales_Data2__c where id = : matId];
    
    q += 'and Name LIKE \'%' + mat.get(0).PH4_Supplier__c + '%\'';
  }

combogriddata cdata = new combogriddata(database.query(q));

return cdata;  

}


@RemoteAction
   Public Static List<Opportunity> getRecordsToDisplay(String paramid) {
        
        
        //Current Fiscal Year-   1st October 2017 to  30 september 2018
        //Next Fiscal year -  1st October 2018 to 30 september 2019
        //Previous Fiscal year - 1st october 2016 to 30 september 2017
        
        /*Date CurrentFiscalYearStart    = date.parse('10/01/'+Date.Today().Year());
        Date CurrentFiscalYearEnd      = date.parse('09/30/'+(Date.Today().Year()+1));
        Date NextFiscalYearStart       = date.parse('10/01/'+(Date.Today().Year()+1));
        Date NextFiscalYearEnd         = date.parse('09/30/'+(Date.Today().Year()+2));
        Date PreviousFiscalYearStart   = date.parse('10/01/'+(Date.Today().Year()-1));
        Date PreviousFiscalYearEnd     = date.parse('09/30/'+Date.Today().Year());*/
        
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        //SupplierPageSetting__c suppSetting = SupplierPageSetting__c.getValues('OpportunityOpenDate');
        //Date DateRange = suppSetting.Opportunity_Date_Range__c; 
        //system.debug('OpptyDateRange##:'+DateRange);
        //Added By Abhinay for (Enh- Res 7115)Open Opportunity – Limit to open opportunities created in current fiscal year or open with close date in next fiscal year 
        //display_list = [select id, name, accountid, Account_Name__c, StageName, Requested_Supplier__c, Requested_Supplier__r.Name, SAP_Material__c, SAP_Material__r.Name, Opportunity_Owner_Manager__c, Account_Type__c,Target__c,CloseDate,Recent_Call_Report_Notes_Date__c,Overview__c,createddate,Potential_CM__c, Annual_Usage__c, Owner.name  from opportunity where Requested_Supplier__c =:paramid and (NOT stagename  like 'Closed%') and createddate >=: DateRange ORDER BY StageName]; //Date.Today().addyears(-1)];
        //display_list = [select id, name, accountid, Account_Name__c, StageName, Requested_Supplier__c, Requested_Supplier__r.Name, SAP_Material__c, SAP_Material__r.Name, Opportunity_Owner_Manager__c, Account_Type__c,Target__c,CloseDate,Recent_Call_Report_Notes_Date__c,Overview__c,createddate,Potential_CM__c, Annual_Usage__c, Owner.name  from opportunity where (NOT stagename  like 'Closed%') AND (NOT stagename  like '%Closed%') AND (createddate >=: PreviousFiscalYearStart) AND (createddate <=: PreviousFiscalYearEnd) AND (CloseDate >=: PreviousFiscalYearStart) AND (CloseDate <=: PreviousFiscalYearEnd) AND  Requested_Supplier__c =:paramid ORDER BY StageName]; //((CloseDate >=: CurrentFiscalYearStart AND CloseDate <=: CurrentFiscalYearEnd) OR (CloseDate >=: NextFiscalYearStart AND CloseDate <=: NextFiscalYearEnd)) AND
        display_list = [select id, name, accountid, Account_Name__c, 
                        StageName, Requested_Supplier__c, Requested_Supplier__r.Name, 
                        SAP_Material__c, SAP_Material__r.Name, Opportunity_Owner_Manager__c, 
                        Account_Type__c,Target__c,CloseDate,Recent_Call_Report_Notes_Date__c,
                        Overview__c,createddate,Potential_CM__c, Annual_Usage__c, Owner.name  
                        from opportunity 
                        where (NOT stagename  like 'Closed%') 
                                AND (NOT stagename  like '%Closed%') 
                                AND (createddate = THIS_FISCAL_YEAR) 
                                AND ((CloseDate = THIS_FISCAL_YEAR) 
                                    OR (CloseDate = NEXT_FISCAL_YEAR) )
                                AND  Requested_Supplier__c =:paramid ORDER BY StageName];
        
        return display_list;

}

@RemoteAction
   Public Static List<Opportunity> getRecordsToDisplayClose(String paramid) {
        
        //Current Fiscal Year-   1st October 2017 to  30 september 2018
        //Next Fiscal year -  1st October 2018 to 30 september 2019
        //Previous Fiscal year - 1st october 2016 to 30 september 2017
        Date CurrentFiscalYearStart    = date.parse('10/01/'+Date.Today().Year());
        Date CurrentFiscalYearEnd      = date.parse('09/30/'+(Date.Today().Year()+1));
        Date NextFiscalYearStart       = date.parse('10/01/'+(Date.Today().Year()+1));
        Date NextFiscalYearEnd         = date.parse('09/30/'+(Date.Today().Year()+2));
        Date PreviousFiscalYearStart   = date.parse('10/01/'+(Date.Today().Year()-1));
        Date PreviousFiscalYearEnd     = date.parse('09/30/'+Date.Today().Year());
        
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        //system.debug( Date.Today().addyears(-1));
        SupplierPageSetting__c suppSetting = SupplierPageSetting__c.getValues('OpportunityClosedDate');
        Date DateRange = suppSetting.Opportunity_Date_Range__c; 
        //Added By Abhinay for (Enh-Res 7115)Closed Opportunity – Limit to closed opportunities with close date in current fiscal year or last fiscal year   
        //system.debug('OpptyClosedDateRange##:'+DateRange);
        //display_list1 = [select id, name, accountid, Account_Name__c, StageName, Requested_Supplier__c, Requested_Supplier__r.Name, SAP_Material__c, SAP_Material__r.Name, Opportunity_Owner_Manager__c, Account_Type__c,Target__c,CloseDate,Recent_Call_Report_Notes_Date__c,Overview__c,createddate,Potential_CM__c, Annual_Usage__c, Owner.name  from opportunity where Requested_Supplier__c =:paramid and (stagename  like 'Closed%') and closedate >=: DateRange ]; //Date.Today().addYears(-1) ];
        display_list1 = [select id, name, accountid, Account_Name__c, StageName, Requested_Supplier__c, Requested_Supplier__r.Name, SAP_Material__c, SAP_Material__r.Name, Opportunity_Owner_Manager__c, Account_Type__c,Target__c,CloseDate,Recent_Call_Report_Notes_Date__c,Overview__c,createddate,Potential_CM__c, Annual_Usage__c, Owner.name  from opportunity where Requested_Supplier__c =:paramid and (stagename  like 'Closed%') AND ((CloseDate >=: CurrentFiscalYearStart AND CloseDate <=: CurrentFiscalYearEnd) OR (CloseDate >=: PreviousFiscalYearStart AND CloseDate <=: PreviousFiscalYearEnd )) and Requested_Supplier__c =:paramid]; //Date.Today().addYears(-1) ];
        
       
       return display_list1;

}

@RemoteAction
   Public Static List<Material_Sales_Data2__c> getRecordsToDisplayProduct(String paramid) {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        String sup_name = [SELECT id, Name FROM Nexeo_Competitor__c where id=: paramid].name;
        //system.debug('@@@Name@@' +sup_name);
        display_list2 = [select id, Name, Material_Number__c, Sales_Org_Code__c,Material_Base_Code__c, Material_Base_Code_Desc__c, Container_Desc_del__c, PH4_Supplier__c, Division_Desc__c, Marked_for_Deletion__c, Division_Code__c from Material_Sales_Data2__c where PH4_Supplier__c =: sup_name and (NOT Name LIKE '%DO NOT%') and Division_Code__c LIKE '31'and Marked_for_Deletion__c != 'true'];// and 
        //system.debug('@@@Material@@' +display_list2[0].Material_Number__c);
       
       return display_list2;

}

/*@RemoteAction
   Public Static List<Sample_Request__c> getRecordsToDisplaySample(String paramid) {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        
        display_list3 = [select id, name, ownerid, owner.name, Account__c,Account__r.name, Account_Owner_Name__c,Opportunity__c, Opportunity__r.name,createddate,Status__c, Supplier__c,Supplier__r.name from Sample_Request__c where Supplier__c =:paramid order by Name];
        
       
       return display_list3;

}*/

@RemoteAction
   Public Static List<Sample_Material__c> getRecordsToDisplaySampleMaterial(String paramid) {
        
        //Current Fiscal Year-   1st October 2017 to  30 september 2018
        //Next Fiscal year -  1st October 2018 to 30 september 2019
        //Previous Fiscal year - 1st october 2016 to 30 september 2017
        Date CurrentFiscalYearStart    = date.parse('10/01/'+Date.Today().Year());
        Date CurrentFiscalYearEnd      = date.parse('09/30/'+(Date.Today().Year()+1));
        Date NextFiscalYearStart       = date.parse('10/01/'+(Date.Today().Year()+1));
        Date NextFiscalYearEnd         = date.parse('09/30/'+(Date.Today().Year()+2));
        Date PreviousFiscalYearStart   = date.parse('10/01/'+(Date.Today().Year()-1));
        Date PreviousFiscalYearEnd     = date.parse('09/30/'+Date.Today().Year());
        
        
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        
        String sup_name = [SELECT id, Name FROM Nexeo_Competitor__c where id=: paramid].name;
        
        //Updated By Abhinay for (Enh-Res 7115)
        //display_list8 = [select id, name, Sample_Request__c,Sample_Request__r.Name,Sample_Request__r.Owner.name,SAP_Material_MSD2__c,SAP_Material_MSD2__r.Name, Requested_Supplier2__c, Sample_Request__r.Account__c,Sample_Request__r.Account__r.name, Sample_Request__r.Account_Owner_Name__c,  Opportunity__c, Opportunity__r.name,Sample_Request__r.Status__c,Sample_Request__r.CreatedDate from Sample_Material__c where Requested_Supplier2__c =:sup_name order by Name];
        display_list8 = [select id, name, Sample_Request__c,Sample_Request__r.Name,Sample_Request__r.Owner.name,SAP_Material_MSD2__c,SAP_Material_MSD2__r.Name, Requested_Supplier2__c, Sample_Request__r.Account__c,Sample_Request__r.Account__r.name, Sample_Request__r.Account_Owner_Name__c,  Opportunity__c, Opportunity__r.name,Sample_Request__r.Status__c,Sample_Request__r.CreatedDate from Sample_Material__c where ((Sample_Request__r.CreatedDate >=: CurrentFiscalYearStart AND Sample_Request__r.CreatedDate <=: CurrentFiscalYearEnd) OR (Sample_Request__r.CreatedDate >=: PreviousFiscalYearStart AND Sample_Request__r.CreatedDate <=: PreviousFiscalYearEnd )) AND Requested_Supplier2__c =:sup_name order by Name];
        
       
       return display_list8;

}

@RemoteAction
   Public Static List<Supplier_Contact__c> getRecordsToDisplaySupplierContact(String paramid) {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        
        display_list4 = [select id, name, Address_line_1__c, Address_line_2__c, Call_Report_Contact__c,City__c,Comments__c,Email__c,Fax__c,First_Name__c,Last_Name__c,Mobile_Phone__c,Phone__c,State_Providence__c, Competitor_Supplier_or_OEM__c,Competitor_Supplier_or_OEM__r.name,Title__c,Website__c,Zip__c from Supplier_Contact__c where Competitor_Supplier_or_OEM__c =:paramid];
        
       
       return display_list4;

}

@RemoteAction
   Public Static List<Attachment> getRecordsToDisplayAttachment(String paramid) {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        
        display_list5 = [select Id, name,ContentType,OwnerId,owner.name,LastModifiedDate from Attachment where parentId =: paramid order By LastModifiedDate DESC];
        
       
       return display_list5;

}

@RemoteAction
   Public Static List<Nexeo_Competitor__c > getRecordsToDisplayEmail(String paramid) {
        
        List<Nexeo_Competitor__c > display_list7 = new List<Nexeo_Competitor__c >();
        display_list7 = [SELECT (SELECT Id, ActivityDate, Subject, Description from ActivityHistories) from Nexeo_Competitor__c WHERE id=:paramid];
        
        //system.debug('display_list7 :'+display_list7[0].ActivityHistories[0].ActivityDate);
       
       return display_list7;

}

@RemoteAction
   Public Static List<Nexeo_Competitor__c> getRecordsToDisplaySupplier(String paramid) {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        
        display_list6 = [SELECT Id, Name, Web_Site__c,Competitor_or_Supplier__c, Supplies_To__c, Status__c, Call_Report__c,Product_Line_Manager__c,Product_Line_Manager__r.name,Product_Specialist__c,Product_Specialist__r.name,Technical_Service_Representative__c,Technical_Service_Representative__r.name FROM Nexeo_Competitor__c where id=:paramid];
        
       
       return display_list6;

}



@RemoteAction
Public Static String getSDSDocument(String materialId,Id sfid)
{    
    cc_mn_json_MSDSResponse sdsResponse = new cc_mn_json_MSDSResponse();

          String httpResponseCodeString;

          try
          {
               //String storeFrontName = ccrz.cc_CallContext.storefront;

               //cc_imp_StorefrontSettings__C storefrontSettings =  cc_imp_StorefrontSettings__C.getInstance(storeFrontName);
             
               cc_imp_util_Http request = new cc_imp_util_Http();
               request.method = cc_imp_util_Http.REQUEST_TYPE.POST;

               //String msdsEndpointPath = storefrontSettings.MSDSEndpointURLPath__c;
               request.endpoint = ('callout:Nexeo_SAP_SDS_Endpoint//sap/bc/zsd_get_msds') ;
               //request.endpoint = ('https://sfwss-qa.nexeosolutions.com:8152/sap/bc/zsd_get_msds?sap-client=020') ;

               request.addQueryParameter('sap-client', '020');
            
               cc_mn_json_MSDSRequest sdsRequest = new cc_mn_json_MSDSRequest();
               sdsRequest.material = materialId;

               String formattedRequestBody = cc_imp_util_Storefront.formatSerializedJSONRequest(sdsRequest.serialize());

               request.body =  formattedRequestBody ;

                HttpResponse httpResponse = request.submitRequest();

                httpResponseCodeString = String.valueOf(httpResponse.getStatusCode() );
                system.debug('httpResponseCodeString @@:'+httpResponseCodeString );
                
                String responseBody =  httpResponse.getBody(); 
                system.debug('responseBody @@:'+responseBody);
                
               if(httpResponse.getStatusCode() == 200 )
               {
                if (String.isNotBlank(responseBody))
                {
                    String formattedResponseBody =  cc_imp_util_Storefront.formatJSONResponse(responseBody);

                    sdsResponse = cc_mn_json_MSDSResponse.parse(formattedResponseBody);
                    system.debug('formattedResponseBody:'+formattedResponseBody);
                    system.debug('sdsResponse :'+EncodingUtil.base64Decode(sdsResponse.document));
                }
                sdsResponse.responseCode  = httpResponseCodeString;
                sdsResponse.success = true;
              }
              else
              {
                sdsResponse.success = false;
                sdsResponse.responseCode  = httpResponseCodeString;
              }
         }
        catch(Exception e)
         {
            sdsResponse.success = false;
            sdsResponse.message = e.getMessage() ;
            sdsResponse.responseCode  = httpResponseCodeString;
         }

        /*if (!String.isBlank(sdsResponse.document)) {
            cc_imp_hlpr_RemoteActionHelper.buildResponseData(response, sdsCallOutResponse.success, 
            new Map<String,Object>{'success' => sdsCallOutResponse.success,'sdsData' => theId,'message' => sdsCallOutResponse.message
        });
        }*/
        String theId = null;
        if (!String.isBlank(sdsResponse.document)) {
            Attachment attach = new Attachment(Name = materialId + '.pdf', Description = 'SDS', ParentId = sfid);
            attach.body = EncodingUtil.base64Decode(sdsResponse.document);
            insert attach;
            theId = attach.Id;
            
        }
        
        if(theId != null){
            List<Attachment> attachments = [SELECT Id FROM Attachment WHERE Description =:'SDS' and CreatedDate < :DateTime.now().addMinutes(-2)];
            delete attachments;        
        }

        return theId;
}

@RemoteAction
Public Static void deleteDocuments(){
List<Document> docs = [SELECT Id, body FROM Document WHERE Folder.Name ='Supplier Page documents'];// and Id != :doc.Id]; // and CreatedDate < :DateTime.now().addMinutes(-2)];
    
    //system.debug('@@@@List doc@@@' +docs.size()+'first:'+docs[0].Id);
    
    if(docs.size()>0)
        delete docs;

}

/*@RemoteAction
   Public Static List<Nexeo_Competitor__c> SendEmail(String paramid) {
        Set<String> record_ids = new Set<String>(); //set for holding distinct Ids
        
       List<Nexeo_Competitor__c> comps = new List<Nexeo_Competitor__c>();
       
       comps = [select id, Send_Email__c from Nexeo_Competitor__c where id =: paramid];
       for(Nexeo_Competitor__c co: comps){
        if(co.Send_Email__c != true)
        {    co.Send_Email__c=true;
        
        }
       }
       update comps;
       
       return null;

   } */
   

Public static string getDateFormat(){
      date d = Date.valueof('1999-01-22');
      string dformat = d.format();
      string f = '';
    
      if(dformat.indexof('22') < dformat.indexof('01'))
        f = 'dd/mm';
      else
        f = 'mm/dd';
      if(dformat.indexof('01') < dformat.indexof('1999'))
        f = f + '/yy';
      else
        f = 'yy/' + f;
      return f;
      
  }
  
   
      
}