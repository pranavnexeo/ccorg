public with sharing class Price_Req_Appr_Controller {
 
 
     
 Public Price_Req_Appr_Controller(){  }
  
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
  @RemoteAction
    public static List<Price_Request_Transaction__c> FetchApprovalTable(){
    string currentuid = userinfo.getuserid();
    Date YEAR_AGO = system.today()-365;

    List<Price_Request_Transaction__c> approvalPRTList = [select Id, Owner.Name,
    Inner_Table__c,Name,
    Approval_Status__c,   
    Approval_Level__c,
    Approver__r.name,
    Approver__c,
    Approval_Backup__c,
    Approver_Match__c,
    Type__c,
    additional_dates__c,
    Ship_To__r.Owner.Name,
    SAP_SoldTo_Account__c,
    SAP_ShipTo_Account__c,
    SAP_Material__r.Name,
    plant__c,
    Requested_Effective_Date__c,
    Requested_Effective_Date_Text__c,
    Requested_Expiration_Date__c,
    Requested_Expiration_Date_Text__c,
    quantity__c,
    Estimated_Order_Qty__c,
    volume__c,
    Requested_UoM__c,
    price__c,
    Requested_Price_UoM__c,
    TPI__c,
    Price_Protection_Changed_Value__c,
    comments__c,
    Approval_Rejection_Comments__c,
    Coordinator_Comments__c,
    Competitor__r.Name,
    Competitor__c,        
    Prospect_Material__c,
    Material__c,
    Freight_Terms__c,
    Price_Support_Exist__c,
    CM_Value__c,
    Material_Cost__c,
    Variable_Delivery__c,
    Variable_Warehouse__c,CM_Flag__c, Unit_Contribution_Margin__c, OEM__c
    from Price_Request_Transaction__c where (Approver__c =: currentuid OR Approval_Backup__c =: currentuid)
                                             AND
                                             CreatedDate >= :YEAR_AGO 
                                             AND Type__c != 'Price Letter'  
                                             AND (Approval_Status__c = 'Submitted'
                                             OR Approval_Status__c = 'Pending Supplier')                
                                             order by Requested_Effective_Date__c desc];
                                             
    system.debug('Output PRT is:'+approvalPRTList);
      return approvalPRTList;
    
    }
    
   @RemoteAction
   Public Static List <Price_Request_Transaction__c> SimulateForm(List<String> RequestIds, List<formData> data, String Operation, String type){
        List <Price_Request_Transaction__c> PRT = new List <Price_Request_Transaction__c>();
        Map<String, string> wheres = new Map<String, String>();
        List<String> mat = new List<String>();
        system.debug('Operation:'+Operation);
        system.debug('type:'+type);
        system.debug(data);
        for(formData fd:data){
            wheres.put(fd.name, fd.value);
        }
            system.debug('Inside RemoteActionPRT');

                  system.debug('request ids: ' + requestids);
                  List<Price_Request_Transaction__c> toReject = [Select Id,approval_status__c, 
                  Approval_Level__c,
                  Approver__r.name,
                  Approver__c,
                  Approval_Backup__c,
                  Approver_Match__c,
                  Type__c,
                  additional_dates__c,
                  Ship_To__r.Owner.Name,
                  SAP_SoldTo_Account__c,
                  SAP_ShipTo_Account__c,
                  SAP_Material__r.Name,
                  plant__c,
                  Requested_Effective_Date__c,
                  Requested_Effective_Date_Text__c,
                  Requested_Expiration_Date__c,
                  Requested_Expiration_Date_Text__c,
                  quantity__c,
                  Volume__c,
                  Requested_UoM__c,
                  Price__c,
                  Requested_Price_UoM__c,
                  average_order_qty__c,
                  Average_Order_Qty_UoM__c,
                  Estimated_Order_Qty_UoM__c,
                  TPI__c,
                  Comments__c,
                  Approval_Rejection_Comments__c,
                  Coordinator_Comments__c,
                  Competitor__r.Name, 
                  Competitor__c,                                                                        
                  Account_Material__c,
                  prospect_material__c,
                  SAP_Data__c, Requested_Tiers__c, CSP_Tiers__c, Ship_To__r.SAP_DivisionCode__c, Freight_Terms__c from  Price_Request_Transaction__c where Id in : requestids];
                  system.debug('toreject: ' + toreject);
                  
                  if(Operation == 'simulate'){
                      system.debug('Controller Simulate');
                          if(toreject[0].prospect_material__c == true){
                              PRT = Account_Material_Functions.getTransactionsrfq(toReject , wheres, 'reject',false); 
                          }
                          else{
                              System.debug('not rfq!!!');    
                              PRT = Account_Material_Functions.getTransactions(toReject , wheres);       
                              
                              }
                  }        
                  if(Operation == 'savesubmit'){
                      system.debug('Controller SaveSubmit');
                          if(toreject[0].prospect_material__c == true){   
                              PRT = Account_Material_Functions.upsertTransactionsrfq2(toReject, wheres, 'rejectAlt', mat,false);    
                          }
                          else{
                              PRT = Account_Material_Functions.upsertTransactions(toReject , wheres, 'Approver');
                              System.debug('not rfq type!!!'+type);   
                           }    
                  }        
        system.debug('Simulate PRT is:'+PRT);
        
        return PRT;
    }
    
    
    
    @RemoteAction
    public static void pendingsupplier(string RequestId){
      if(RequestId != null && RequestId != '')
         {
              Price_Request_Transaction__c[] prts = new List<Price_Request_Transaction__c>();
              for(Price_Request_Transaction__c c : [Select Id,Ship_To__r.SAP_DivisionCode__c,Ship_To__r.SAP_Customer_Group_5__c,Sold_To__r.SAP_DivisionCode__c, type__c, approval_status__c, Approval_Rejection_Comments__c from  Price_Request_Transaction__c where Id in :RequestId.replaceall('Ids=', '').split('&')]){
                   if(c.Approval_status__c != 'Pending Supplier')   
                   {                
                   c.Approval_status__c = 'Pending Supplier';
                   prts.add(c);
                   }                
                }
                if(prts.size()>0)
                Database.Update(prts,false);              
              
                
         }
    
    
    }       
 //////////////Reject PRT//////////////////////////////////////   
    @RemoteAction
      public static void rejectprt(String RequestId,String comments){
         if(RequestId != null && RequestId != '')
          {
              RequestId = RequestId.replaceall('Ids=', '');
              List<String> splitstrings = RequestId.split('&');               
        
              Price_Request_Transaction__c[] prts = new List<Price_Request_Transaction__c>();
              for(Price_Request_Transaction__c c : [Select Id,Ship_To__r.SAP_DivisionCode__c,Ship_To__r.SAP_Customer_Group_5__c,Sold_To__r.SAP_DivisionCode__c, type__c, approval_status__c, Approval_Rejection_Comments__c from  Price_Request_Transaction__c where Id in :splitstrings]){
                if(c.approval_status__c == 'Submitted' || c.approval_status__c == 'Pending Supplier'){
                    c.Approval_status__c = 'Rejected';
                    c.Approval_Rejection_Comments__c = comments;
                    prts.add(c);
                }    
              }
              if(prts.size()>0)
                Database.Update(prts,false);
                
                
            }
            
            
        }
    
    
//////////////////////////////Retrive price support data from prt/////////////////////
@RemoteAction
Public Static List<Id> pricesupportdata(List<id> aaSelected){

List<Id> ams = new List<Id>();
List<Id> spslist = new List<Id>();
List<Price_Request_Transaction__c> prts = [Select id, Account_Material__c from Price_Request_Transaction__c where id = :aaSelected];

    for(Price_Request_Transaction__c prt1: prts){
      ams.add(prt1.Account_Material__c);
    }
   List<Price_Support_Junction__c> psjs = [Select id, Nexprice_CPI__c, SAP_Price_Support__c from Price_Support_Junction__c where Nexprice_CPI__c = :ams];
      for(Price_Support_Junction__c psj1: psjs){
       spslist.add(psj1.SAP_Price_Support__c);
    }
  if(spslist.size() > 0){
    return spslist;
  }else
  return null;

}

///////////////////////////////Retrive price support data from prt end/////////////////
    
/////////////////// Send email supplier////////////////////////

@RemoteAction
public Static void sendemailsupplier(String plForm, String iframesrc){
  
  
  List<String> plFormItemsEncoded = plForm.split('&');
  Map<String, string> plFormItems = new Map<String, String>();
  
  for(String s:plFormItemsEncoded)
  { List<String> aItem = s.split('=');
    if(aItem.size() > 1)
    {  
       plFormItems.put(aItem.get(0), EncodingUtil.URLDecode(aItem.get(1), 'UTF-8'));
    }
  }

  string cid = plFormitems.get('plemails').trim();  
  String plId = plFormitems.get('hiddenplid');
  system.debug('plId is:'+plId);
  
  List<Price_Request_Transaction__c> prt = [Select id, Account_Material__c, 
  Account_Material__r.Account__r.id from Price_Request_Transaction__c where id = :plId];

  
    List<String> plAccount = new List<String>();
    for(Price_Request_Transaction__c acc:prt) 
    {
        plAccount.add(acc.Account_Material__r.Account__r.id); 
    }
   system.debug('placcount are:'+plAccount);
    
      string subject = plFormitems.get('plsubject');
      string body = plFormitems.get('plbody');
      boolean issentto = False;
      cid = cid.replaceall('\n', ',');
      List<String> emails = new list<string>();
      for(string s:cid.split(','))
        if(s != '')
          emails.add(s);
       if(emails.size() > 0)
        isSentto = True;  
      
    
    Boolean result = true;                         

    try {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        if (emails.size() > 0) {mail.setToAddresses(emails);}
        mail.setReplyTo(userinfo.getUserName());
        mail.setSenderDisplayName(userinfo.getName());
        mail.setSubject(subject);
        //mail.setBccSender(true);
        mail.setUseSignature(true);
        mail.setPlainTextBody(body);
        blob b = PDF_Functions.CreatePDFBlobFromPageReference('/apex/'+iframesrc, plId);
        Messaging.EmailFileAttachment EFA = new Messaging.EmailFileAttachment();
        EFA.setBody(b); 
        EFA.setFileName('Price_Support.pdf');
        EFA.setContentType('application/pdf');
        EFA.setInline(false);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{EFA});
        
       
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(new Messaging.Email[] { mail });
        if (results.get(0).isSuccess()){
            
      List<Price_Request_Transaction__c> prtran = new List<Price_Request_Transaction__c>();
      
      prtran = [select id,SendEmailSupplierFlag__c,name from Price_Request_Transaction__c where id =: plId];
      system.debug('----'+prtran);
      if(prtran.size()>0){
          prtran[0].SendEmailSupplierFlag__c = true;
          
        }
        Update prtran;
        system.debug('----'+prtran);
        price_support_letter__c p = new price_support_letter__c (name = 'PS Letter for : '+prtran[0].name,PRT__c = plId,mail_sent_to__c = cid);
        insert p;
        
        Attachment a = new Attachment(); 
        a.Body = b; 
        a.ParentID = p.id; 
        a.Name = 'PS Letter for : '+prtran[0].name+'.pdf';         
        insert a;
        
        p.AttachmentId__c = a.id;        
        update p;
        
        }
        }
    catch (Exception e) {result = false;}
    
    
    

  
}




/////////////////////////Send email supplier End//////////////////    
    
    
    
    @RemoteAction
    public static void approverecords(String RequestId,String comments){
     system.debug('Comments:'+comments);
     system.debug('RequestId:'+RequestId);
        if(RequestId != null && RequestId != '')
         {
              RequestId = RequestId.replaceall('Ids=', '');
              List<String> splitstrings = RequestId.split('&');
         
            
             system.debug('splitstrings:'+splitstrings);
            
         List<Price_Request_Transaction__c> toApprove = [Select Id,Ship_To__r.SAP_DivisionCode__c,Ship_To__r.SAP_Customer_Group_5__c,Sold_To__r.SAP_DivisionCode__c, type__c, approval_status__c, Approval_Rejection_Comments__c from  Price_Request_Transaction__c where Id in : splitstrings];
             List<PRT_Movement_Settings__c> PRTMovmntSett = PRT_Movement_Settings__c.getall().values();
             Map<String,Boolean> customSettMap = new Map<String,Boolean>();
             Map<String,Boolean> CustGrpSettMap = new Map<String,Boolean>();
             
             for(PRT_Movement_Settings__c PRTsett : PRTMovmntSett){
                customSettMap.put(PRTsett.Name,PRTsett.Switch__c);
                CustGrpSettMap.put(PRTsett.Name,PRTsett.CG5__c);
             }
             
             String divCode;
             
             for(Price_Request_Transaction__c prt:toApprove)
            {
               if(prt.approval_status__c == 'Submitted' || prt.approval_status__c == 'Pending Supplier'){                  
                
                if(prt.Ship_To__r.SAP_DivisionCode__c != null)
                    divCode = prt.Ship_To__r.SAP_DivisionCode__c;
                    
                else if (prt.Sold_To__r.SAP_DivisionCode__c != null)
                    divCode = prt.Sold_To__r.SAP_DivisionCode__c;
                    
        
                if(prt.type__c == 'CSP' && prt.approval_Status__c != 'complete'){
                   if(customSettMap.get(divCode) == true){
                   
                        if(CustGrpSettMap.get(divCode) == true){
                            prt.approval_Status__c = 'SAP Transfer Open';
                            
                        }
                        else{
                            if(prt.Ship_To__r.SAP_Customer_Group_5__c == '11' || prt.Ship_To__r.SAP_Customer_Group_5__c == '12' || prt.Ship_To__r.SAP_Customer_Group_5__c == '13'){
                                prt.approval_Status__c = 'Pending Entry';
                                
                            }
                            else{
                                prt.approval_Status__c = 'SAP Transfer Open';
                                
                            }
                        }
                    }
                    else{
                        prt.approval_Status__c = 'Pending Entry';
                        
                    }
                }
                else if(prt.type__c != 'CSP')
                    prt.approval_Status__c = 'Approved';
                
                system.debug('Comments:'+comments);
                prt.Approval_Rejection_Comments__c = comments;
                system.debug('prt.Approval_Rejection_Comments__c:'+prt.Approval_Rejection_Comments__c);
            }
               
            } 
            update toApprove;
        }
    }
    
    @RemoteAction
    Public static combogriddata getComboGridData(string q, string obj, string fields, string filters, string orderby, string mylimit){ 
    List<sobject> records = new list<SObject>();
    if(obj != '' && fields != '')
    {
      String query = '\'%' + q.escapeEcmaScript() + '%\'';
      system.debug('filters***'+filters);
      string f = fields.replaceall('-id', '');
      string qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id != null';
      if(filters != null && filters != '')
        qstring += ' and ' + filters;
      
      List<String> myfields = fields.split(',');
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
      }
      if(orderby != '' && orderby != null)
        qstring += ' ORDER BY ' + orderby;
      else
        qstring += ' ORDER BY Name ';
      qstring += ' LIMIT ' + mylimit;
      
      records = database.query(qstring);
      
    }
     
    
     combogriddata data = new combogriddata(records);
     
     return data;
    }
    
    /*code for reassign appr*/
    
    @RemoteAction
    public static void reassignupdate(string RequestId, string comments){
        system.debug('Comments:'+comments);
        system.debug('RequestId:'+RequestId);
        String usrname;
        if(RequestId != null && RequestId != '')
         {
              RequestId = RequestId.replaceall('Ids=', '');
              List<String> splitstrings = RequestId.split('&');
         
            
             system.debug('splitstrings:'+splitstrings);
             String comment = comments;
             String email;
             List<String> co = new List<String>();
             co.add(comment);
             
             
             List<Price_Request_Transaction__c> newApprover = [Select Id, type__c, Approver__c from  Price_Request_Transaction__c where Id in : splitstrings];
         
             List<user> username = [Select id,email from user where Id in :co limit 1];
             
             System.debug('username is '+username);
             
             for(integer i = 0; i<username.size();i++){
                 usrname = username[i].id; 
                 email = username[i].email;
             }
             
             System.debug('usrname !!! '+usrname);
             System.debug('email !!! '+email);
             
             for(Price_Request_Transaction__c prt:newApprover)
            {                 
                prt.Approver__c = usrname;
                system.debug('-----prt.Approver__c ----:'+prt.Approver__c);
                

            }
            
            update newApprover;
                        
            /*send email*/
            
 
            
            List<User> toaddressespertransaction = new List<User>();
            Map<String, List<String>> IdToAddresses = new Map<String, List<String>>();                                   
            List<Id> PRTIds = new List<Id>();
          
            
            for(Price_Request_Transaction__c t:newApprover)
            { 
                List<String> UserEmail = new List<String>();
                System.debug('t.id!!! '+t.id);
              
                toaddressespertransaction = [Select email from User where id IN :username];
                for(User u: toaddressespertransaction)
                UserEmail.add(u.email);
                IdToAddresses.put(t.id,UserEmail);
                PRTIds.add(t.id);
            
            }                
              if(PRTIds.size()>0){
            nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
            system.debug('ns.Email__c is : '+ns.Email__c);
            if(ns.Email__c != null && ns.Email__c != '')
                Email_Functions.sendEmailwithTemplate(IdToAddresses,PRTIds,'Template_To_Approver_Level1_12',ns.Email__c);  
                
          
            }
         }
    
    }
    @RemoteAction
    Public static List<Price_Request_Approver__c> getApproversList(String q){ 
        
        String query = 'Approver_Name__c LIKE \'%' + q + '%\'';
        String qstring = 'select Approver_Name__c, Approver__c from Price_Request_Approver__c where User_Is_Active__c = \'true\' and ';
        qstring += query; 
        system.debug('qstring:'+qstring );
        
        List<Price_Request_Approver__c> dupprtrecords = database.query(qstring);
        List<Price_Request_Approver__c> distinctprtrecords = new List<Price_Request_Approver__c>();
   
        for(Price_Request_Approver__c record: dupprtrecords ){
            Boolean found = false;
            for(Price_Request_Approver__c disrecord: distinctprtrecords ){
                if(record.Approver_Name__c == disrecord.Approver_Name__c ){
                    found=true;
                    break;
                }
            }
            if(!found)
                distinctprtrecords.add(record);
        }
    
        return distinctprtrecords;

    }  

@RemoteAction
public static List<Price_Support_Junction__c> getpsrsuppliers(String amIds){
    System.debug('inside getpsrsuppliers');
    List<String> splitstrings = new List<String>();
    if(amIds!= null && amIds != '')
    {    amIds = amIds.replaceall('Ids=', '');
         splitstrings = amIds.split('&');}
    Price_Request_Transaction__c prt = [Select id, Account_Material__c from Price_Request_Transaction__c where id =: splitstrings[0]];
    
    List<Price_Support_Junction__c> psrsupp = [Select Id, Supplier_Name__c, SAP_Price_Support__r.Supplier_Name__c, SAP_Price_Support__r.Supplier_Number__c from Price_Support_Junction__c where Nexprice_CPI__c = :prt.Account_Material__c];  
    System.debug('psrSupplier!!!'+psrsupp);
    return psrsupp;
}
    
@RemoteAction
public static List<SAP_Plant__c> getsapplant(String q){
    System.debug('inside getsapplant');
    String query = '\'%' + q + '%\'';
    string qstring;
    qstring = 'Select Id, Plant_Code__c, Plant_Name__c from SAP_Plant__c where (NOT Plant_Name__c LIKE \'MASKED\') and (NOT Plant_Name__c LIKE \'DO NOT USE\')';  
    
    if(q != null && q != '')
        qstring += ' and Plant_Name__c LIKE'  + query;
    qstring += 'order by Plant_Name__c';
    List<SAP_Plant__c> sapplant = Database.query(qstring);
    System.debug('sapplant!!!'+sapplant);
    return sapplant;
}

@RemoteAction
public static List<Price_Request_Transaction__c> psrSubmitForm(String RequestIds, List<formData> data){
    System.debug('inside psrSubmitForm');
    
    List<String> splitstrings = new List<String>();
    if(RequestIds != null && RequestIds != '')
    {    RequestIds = RequestIds.replaceall('Ids=', '');
         splitstrings = RequestIds.split('&');}
    
    Map<String, string> amap = new Map<String, String>();
    for(formData fd:data)
       amap.put(fd.name, fd.value);
    
    approverecords(RequestIds, amap.get('psrappcomments'));
        
    List<Price_Request_Transaction__c> transactions = new List<Price_Request_Transaction__c>();
    transactions = [Select id, SAP_Material__c, ship_to__c  from Price_Request_Transaction__c where id IN :splitstrings];
    Map<Id, Price_Request_Transaction__c> prtMap = new Map<Id, Price_Request_Transaction__c>();
    
    List<Price_Support_Request__c> psr = new List<Price_Support_Request__c>();
    for(Price_Request_Transaction__c prt :transactions){
        prtMap.put(prt.id, prt);
        Price_Support_Request__c ps = new Price_Support_Request__c();
        if(amap.containskey('CUPS')){ ps.CUPS__c = amap.get('CUPS');}
        if(amap.containskey('psrsupplier')){ ps.Supplier_Name__c = amap.get('psrsupplier');}
        if(amap.containskey('aggrnum')){ ps.Agreement_Number__c = amap.get('aggrnum');}
        if(amap.containskey('sapplant')){ if(amap.get('sapplant') != null && amap.get('sapplant') != '') ps.SAP_Plant__c = amap.get('sapplant');}
        if(amap.containskey('psreffdate')){ ps.Effective_Date__c = datetime.newinstance(long.valueof(amap.get('psreffdate'))).dategmt();}
        if(amap.containskey('psrexpdate')){ ps.Expiration_Date__c = datetime.newinstance(long.valueof(amap.get('psrexpdate'))).dategmt();}
        if(amap.containskey('region')){ ps.Region_Code__c = amap.get('region');}
        if(amap.containskey('psrfreight')){ ps.Freight_Terms_Buying__c = amap.get('psrfreight');}
        if(amap.containskey('psrSuppPrice')){ ps.Supplier_Supported_Price__c = Account_Material_Functions.stringtodouble(amap.get('psrSuppPrice'));}
        if(amap.containskey('psruom')){ ps.UOM__c = amap.get('psruom');}
        if(amap.containskey('psrdisc1')){ ps.Support_Disc_1__c = Account_Material_Functions.stringtodouble(amap.get('psrdisc1'));}
        if(amap.containskey('psrdisc2')){ ps.Support_Disc_2__c = Account_Material_Functions.stringtodouble(amap.get('psrdisc2'));}
        if(amap.containskey('disc1type')){ ps.Disc1type__c = amap.get('disc1type');}
        if(amap.containskey('disc2type')){ ps.Disc2type__c = amap.get('disc2type');}
        if(amap.containskey('suppcomments')){ ps.Additional_Comments__c = amap.get('suppcomments');}
        ps.Material_Buying__c = prt.SAP_Material__c;
        ps.Customer_Name__c = prt.ship_to__c;
        ps.Status__c = 'Open';
        ps.Price_Request_Transaction__c = prt.id;
        RecordType rt = [select Id from RecordType where Name = 'PSR' and SobjectType = 'Price_Support_Request__c' limit 1];
        ps.RecordTypeId = rt.Id;
        psr.add(ps);
        
    }
     Insert psr;
     
     for(Price_Support_Request__c s :psr){
     if(prtMap.containskey(s.Price_Request_Transaction__c))
         prtMap.get(s.Price_Request_Transaction__c).Price_Support_Request__c = s.id;
     }
     update prtMap.values();
    return transactions;
}


}