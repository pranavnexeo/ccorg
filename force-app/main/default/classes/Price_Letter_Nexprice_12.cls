Public with Sharing Class Price_Letter_Nexprice_12{

Public String UserOptions{Get; set;}
Public String OwnerOptions{get; set;}
Public string myEmpId {get; set;}
Public String ReporteeOptions{get; set;}
public Static Map<id, Account_material__c> Account_Materials_Map{get; set;}
Public Static Set<String> sAIDs{Get; set;}
Public Static Set<String> sMIDs{get; set;}
Public Static String pages{Get; set;}
Public Static List<Price_Request_Transaction> currentrequests = new List<Price_Request_Transaction>();

Public Static Map<String, Double> currencymap{get; set;}
public Static String RoleOptions{Get; Set;}

Public Price_Letter_Nexprice_12(){
    
RoleOptions='';
List<String> ContactRole = new List<String>();
Schema.DescribeFieldResult F1 = Contact.Role__c.getDescribe();
List<Schema.PicklistEntry> values = F1.getPicklistValues();
    
for (Schema.PicklistEntry a :values)
    ContactRole.add(a.getLabel());
  
for(String s :ContactRole)
    RoleOptions +=  '<option value="' + s + '" label="' + s + '">' + s + '</option>'; 
    //System.debug('-----ContactRole--------:'+ContactRole); 

Account_Materials_Map = new Map<id, Account_material__c>();

CurrencyMap = new Map<String, Double>();
    for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
    {
       if(c.isocode != '' && c.isocode != null)
         CurrencyMap.put(c.IsoCode, C.ConversionRate);
    }

User User = [select id, name, nexPrice_Disregard_Hierarchy__c, userroleid, Ashland_Employee_Number__c from User where id = :userinfo.getuserid() limit 1];
myEmpId = User.Ashland_Employee_Number__c;
List<Role_Data__c> roledata = new List<Role_Data__c>();

if(User.nexPrice_Disregard_Hierarchy__c == false)
roledata = [select id, data__c, type__c, API_Field_Name__c, role_id__c from Role_Data__c where role_id__c = :user.userroleid and type__c = 'Account'];
else
roledata = [select id, data__c, type__c, API_Field_Name__c, role_id__c from Role_Data__c where role_name__c = 'AD Sales' and type__c = 'Account'];


Set<String> fields = new Set<String>{'SAP_Sales_Org__c', 'SAP_DivisionCode__c', 'SAP_Industry_Key__c',  'HQ_Sales_Office__c', 'SAP_SalesGroup__c', 'SAP_Sold_To_Account_Owner__c'};
Map<String, List<String>> options = new Map<String, List<String>>();

for(string f:fields)
  options.put(f, new List<String>());

for(Role_Data__c rd:roledata)
  if(rd.data__c != null && rd.data__c != '' && fields.contains(rd.api_field_name__c))
    options.get(rd.api_field_name__c).addall(rd.data__c.split('; '));


UserOptions = '';
UserOptions += '<option class="user" value="'+ string.valueof(user.id).substring(0, 15) + '">'+ user.name + '</option>';
for(Role_Reportee__c r:[select id, user__c, user__r.name, Full_Name__c  from role_reportee__c where role__c = 'AD Sales'  order by user__r.name limit 2000])
{   UserOptions += '<option class="user" ';
// added by Abhishek on 4Sept13 to avoid Null Pointer in Test Method
    if (r != null && r.user__r != null){
    UserOptions += 'value="' + string.valueof(r.user__r.id).substring(0, 15) + '">' + r.user__r.name.escapeEcmaScript() + '</option>';
    }
}

ReporteeOptions = '';
ReporteeOptions += '<option class="user" value="'+ string.valueof(user.id).substring(0, 15) + '">'+ user.name + '</option>';
if(User.nexPrice_Disregard_Hierarchy__c)
  for(Role_Reportee__c r:[select id, user__c, user__r.name, Full_Name__c from role_reportee__c where role__c = 'AD Sales' order by user__r.name limit 2000])
  {
    ReporteeOptions += '<option ';
    if(r.user__c == userinfo.getuserid())
      ReporteeOptions += 'selected = "selected" ';
    ReporteeOptions += 'class="soldseller" value="' + string.valueof(r.user__r.id).substring(0, 15) + '">' + r.user__r.name.escapeEcmaScript() + '</option>';
  }   
else
  for(Role_Reportee__c r:[select id, user__c, user__r.name, Full_Name__c from role_reportee__c where role_id__c = :user.userroleid order by user__r.name limit 2000])
  {
    ReporteeOptions += '<option ';
    if(r.user__c == userinfo.getuserid())
      ReporteeOptions += 'selected = "selected" ';
     ReporteeOptions += 'class="soldseller" value="' + string.valueof(r.user__r.id).substring(0, 15)  + '">' + r.user__r.name.escapeEcmaScript() + '</option>';
  }

OwnerOptions = '';
OwnerOptions += '<option class="user" value="'+ user.Ashland_Employee_Number__c + '">'+ user.name + '</option>';
for(User u:[select id, name, Ashland_Employee_Number__c from User where id IN (select userid from AccountTeamMember) limit 2000])
{
    if(u.id != userinfo.getuserid()){
    OwnerOptions += '<option ';
    OwnerOptions += 'class="soldseller" value="' + u.Ashland_Employee_Number__c + '">' + u.name + '</option>';
    }
}   
  

}

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
Public static accountdata FetchMyAccounts(string ownerid, string soldtosearch, string flag, string q){
  accountdata data = new accountdata(ownerid, soldtosearch, flag, q);
  return data;
}


@RemoteAction
Public static combogriddata getSelectOptions(List<String> ids, string q, string obj, string fields, string filters, string orderby, string mylimit){ 
List<sobject> records = new list<SObject>();
if(obj != '' && fields != '')
{
  String query = '\'%' + q.escapeEcmaScript() + '%\'';
  system.debug('filters***'+filters);
  string f = fields.replaceall('-id', '');
  string qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id NOT IN :ids ';
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
  system.debug('qstring is : '+qstring);
  records = database.query(qstring);
}
 combogriddata data = new combogriddata(records);
 system.debug('size: ' + records.size());
 
 return data;
}

@RemoteAction
Public static List<Account_Material__c>  getPricing(List<String> aiDisplay, List<String> aids){
   system.debug(aiDisplay);
   List<Account_Material__c> toreturn =  Account_Material_Functions.getPricing(aiDisplay, aids); 
   return toReturn;
}

@RemoteAction
public static Integer getDataCount(List<formData> data){
String q = 'select id from Account_material__c where id != null ';
                
Map<String, List<string>> wheres = new Map<String, List<String>>();
system.debug(data);
for(formData fd:data){
  if(wheres.containskey(fd.name))
    wheres.get(fd.name).add(fd.value);
  else
    wheres.put(fd.name, new List<String>{fd.value});
}
system.debug(wheres);
List<Account> sh = new List<Account>();
List<Account> so = new List<Account>();
List<Account> corp = new List<Account>();
set<string> excludes = new set<string>{'All Sales Orgs', 'All Divisions', '--None--', ''};
String qstring = '';
for(string s:wheres.keyset())
{ 
 if(wheres.get(s).size() > 0)
 if(!excludes.contains(wheres.get(s).get(0)))
 {
  if(s == 'Account__c' || s == 'Account_Sold_To_Id_Ext__c' || s == 'Account_Corp_Account_Id_Ext__c')
    qstring += ' and (' + s + ' IN ';
  else if(s == 'Team_Employee_Ids__c')
    qstring += ' and (' + s + ' LIKE ';
  else
    qstring += ' and ' + s + ' IN ';
  
  string vals;
  if(s == 'Team_Employee_Ids__c')
      vals = '\'%';
  else
      vals = '(';
  for(integer i=0; i<wheres.get(s).size(); i++)
  {  
     if(s == 'Team_Employee_Ids__c')
         vals += wheres.get(s).get(i) + '%\''; 
     else         
         vals += '\'' + wheres.get(s).get(i) + '\'';
    
     if((i < (wheres.get(s).size() -1)) && s == 'Team_Employee_Ids__c')
       vals+= ' or ' + s + ' LIKE \'%';
     else if((i < (wheres.get(s).size() -1)) && (s != 'Team_Employee_Ids__c'))
       vals+= ', ';
         
  }
  vals+= ') ';
  qstring += vals;
  if(s == 'Account__c')
  { sh = [select id from Account where id IN :wheres.get(s)];
   qstring += ' and Account__c IN :sh) ';
  }
  if(s == 'Account_Sold_To_Id_Ext__c')
  { so = [select id from Account where SAP_Sold_To_Account_Id__c IN :wheres.get(s)];
    qstring += ' and Account__c IN :so) ';
  }
  if(s == 'Account_Corp_Account_Id_Ext__c')
  { corp = [select id from Account where SAP_Corporate_Account_Id__c IN :wheres.get(s)];
    qstring += ' and Account__c IN :corp)';
  }
 }
}
qstring +=  ' and (created_from_cpi__c = null OR created_from_Cpi__r.deletion_indicator__c != \'X\')';
q += qstring ;
q += ' order by Account__r.name, SAP_Material__r.name limit 25000';
system.debug(q);
return Database.query(q).size();
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


@RemoteAction 
Public static Account getAccount(string id){
List<Account> accts = [select ParentId, SAP_DivisionCode__c, SAP_Sales_Org__c, SAP_Partner_Functions__c, SAP_Corporate_Account_Id__c, SAP_Sold_To_Account_Id__c, name, id from Account where id = :id limit 1];
system.debug(accts);
if(accts.size() > 0)
  return accts.get(0);
else
  return null;
  
}

@RemoteAction
public static combogriddata getData(List<String> existingids, List<formData> data, string lmt, string off ){

    return Nexprice.getData(existingids, data, lmt, off );
}


@RemoteAction 
Public static string savepriceletter(LIst<String> amids){

   List<Account_material__c> ams = Account_Material_Functions.getAccountMaterials(amids);
  //List<Price_Request_Transaction__c> quotePrt = new List<Price_Request_Transaction__c>();
  List<Price_Request_Transaction__c> prts = new List<Price_Request_Transaction__c>();
  List<Account_material__c> plAM = new List<Account_Material__c>();
  Map<Id, Id> quoteMap = new Map<Id, Id>();
  Map<Id, Id> cspMap = new Map<Id, Id>();
  
  List<String> ids = new List<String>();
  List<String> quoteid = new List<String>();
 
  Map<Id, price_request_transaction__c> quoteprtmap = new Map<Id, price_request_transaction__c>();
  List<price_request_transaction__c> quoteprt = [Select id, Account_Material__c, Requested_Tiers__c from Price_Request_Transaction__c where ((Account_Material__r.id IN :amids) and (Approval_Status__c='Approved' OR Approval_Status__c='SAP Transfer Open' OR Approval_Status__c='SAP Transfer Failed' OR Approval_Status__c='Pending Entry'))];
  system.debug('quote size is:'+quoteprt.size());
  for(price_request_transaction__c prt:quoteprt)
     if(!quoteprtmap.containskey(prt.account_material__c))
        quoteprtmap.put(prt.account_material__c, prt);
  
  for(Account_Material__c am :ams)
  {   
      //quotePrt = [Select id from Price_Request_Transaction__c where Account_Material__r.id =: am.id and Type__c='Quote' and Approval_Status__c='Approved'];
      //System.debug('quotePrt:'+quotePrt);
      if(quotePrtmap.containskey(am.id)) 
          quoteid.add(quotePrtmap.get(am.id).id);
      //else
          plAM.add(am);
  }
  //System.debug('quotePrt1:'+quotePrt);
  
  prts = priceletterPRT(plAM,quoteprtmap);
    
  for(Price_Request_Transaction__c prt:prts)
  {
    //prt.type__c = 'Price Letter';
    ids.add(prt.id);
  }
  upsert prts;
  //system.debug('ids are:'+ids);
  //system.debug('quoteid are:'+quoteid);
  
  Price_Letter__c pl = new Price_Letter__c();
  insert pl;
  //List<SAP_Price__c> quotesappr = [select id, Price_Request_Transaction__r.type__c, Price_Request_Transaction__r.account_material__c from SAP_Price__C where Price_Request_Transaction__c IN :quoteid and type__c ='Requested'];
  //List<SAP_Price__c> sappr = [select id, Price_Request_Transaction__r.type__c, Price_Request_Transaction__r.account_material__c from SAP_Price__C where Price_Request_Transaction__c IN :ids and type__c ='CSP'];
  //for(SAP_Price__c qpr:quotesappr)
  //    sappr.add(qpr);
  
  //System.debug('SAPPR:'+sappr);
  
  for(SAP_Price__c pr :[select id, type__c, Price_Request_Transaction__r.type__c, Price_Request_Transaction__r.account_material__c from SAP_Price__C where Price_Request_Transaction__c IN :ids and type__c ='Requested'])
  {
     if(!quoteMap.containskey(pr.Price_Request_Transaction__r.account_material__c))
        quoteMap.put(pr.Price_Request_Transaction__r.account_material__c, pr.id);
  }
  
  for(SAP_Price__c pr :[select id, type__c, Price_Request_Transaction__r.type__c, Price_Request_Transaction__r.account_material__c from SAP_Price__C where Price_Request_Transaction__c IN :ids and type__c ='CSP'])
  {
     if(!cspMap.containskey(pr.Price_Request_Transaction__r.account_material__c))
        cspMap.put(pr.Price_Request_Transaction__r.account_material__c, pr.id);
  }
  
  List<Price_Letter_Item__c> items = new List<Price_Letter_Item__c>();
  for(Account_Material__c am :ams)
  {
    Price_Letter_Item__c pli = new Price_Letter_Item__c();
    pli.price_Letter__c = pl.id;
    if(cspMap.containskey(am.id))
        pli.CSP_Tiers__c = cspMap.get(am.id);
    if(quoteMap.containskey(am.id))
        pli.Quote_Tiers__c = quoteMap.get(am.id);
    pli.account_material__c = am.id;
    
    items.add(pli);
    
  }
  insert items;
  update pl;

  return pl.id;

}

@RemoteAction
public static Contact FetchContact(string contactid){
  return [select id, name, firstname, lastname, email, accountid, account.name from contact where id = :contactid limit 1];
}

@RemoteAction
Public static contactdata FetchMyContacts(string q, string ownerid, String AccountId){
  contactdata data = new contactdata(ownerid, accountid, q);
  return data;
}

@RemoteAction
Public static contactdata FetchMyContacts_12(string q, string plId){
  List<Price_Letter_Item__c> plitem = [Select id, Price_Letter__c, Account_Material__c, 
    Account_Material__r.Account__r.id from Price_Letter_Item__c where Price_Letter__c = :plId];
 
    List<String> plAccount = new List<String>();
    for(Price_Letter_Item__c acc:plitem) 
    {
        plAccount.add(acc.Account_Material__r.Account__r.id); 
    }
    system.debug('plitem are:'+plAccount);
    
  contactdata data = new contactdata(q, plAccount);
  return data;
}

@RemoteAction 
Public static combogriddata getPLAccounts(string plid){
system.debug('plid is:'+plid);
/*
List<Account> plAccount = new List<Account>();
List<Price_Letter_Item__c> plitem = [Select id, Account_Material__c, Price_Letter__c from Price_Letter_Item__c where Price_Letter__c = :plid];
system.debug('plitem are:'+plitem);

for(Price_Letter_Item__c p:plitem)
{  
    Account_Material__c amid = [Select Account__c from Account_Material__c where id = :p.Account_Material__c];
    system.debug('Account Material are:'+amid);
    Account accts = [select SAP_DivisionCode__c, SAP_Division_Desc__c, SAP_Sales_Org__c, SAP_Partner_Functions__c, SAP_Corporate_Account_Id__c, SAP_Sold_To_Account_Id__c,AccountNumber, name, id from Account where id = :amid.Account__c];
    system.debug('Accounts are:'+accts);
    plAccount.add(accts);
}
system.debug('plAccount are:'+plAccount);
combogriddata data = new combogriddata(plAccount);
return data;
*/

List<Price_Letter_Item__c> plitem = [Select id, Price_Letter__c, Account_Material__c, 
Account_Material__r.Account__r.SAP_DivisionCode__c, 
Account_Material__r.Account__r.SAP_Sales_Org__c, 
Account_Material__r.Account__r.AccountNumber, 
Account_Material__r.Account__r.name, 
Account_Material__r.Account__r.id  
from Price_Letter_Item__c where Price_Letter__c = :plid];
system.debug('plitem are:'+plitem);
combogriddata data = new combogriddata(plitem);
return data;
  
}

@RemoteAction
Public Static void saveContact(String cform, List<String> ContactRole){
  //string cform = apexpages.currentpage().getParameters().get('cid');
 // system.debug('CID is:'+cform);
  
  List<String> filters = cform.split('&');
  Map<String, String> fieldmap = new map<String, String>();
 // system.debug('filters is:'+filters );
  for(string s:filters)
  { List<String> sl = s.split('=');
       if(sl.size() == 2)
       fieldmap.put(sl.get(0), EncodingUtil.URLDecode(sl.get(1), 'UTF-8'));
  }

  Contact c = new Contact();
  if(fieldmap.containskey('cform-id'))
  {
    List<Contact> contacts = [select id, name, firstname, lastname, email, accountid, Phone, Role__c from Contact where id = :fieldmap.get('cform-id') limit 1];
    if(contacts.size() == 1)
      c = contacts.get(0);
  }
  if(c.accountid == null && fieldmap.containskey('cform-acct'))
     c.accountid = fieldmap.get('cform-acct');
  if(fieldmap.containskey('cform-firstname'))
     c.firstname = fieldmap.get('cform-firstname');
  if(fieldmap.containskey('cform-lastname'))
     c.lastname = fieldmap.get('cform-lastname');
  if(fieldmap.containskey('cform-email'))
     c.email = fieldmap.get('cform-email');
  if(fieldmap.containskey('cform-phone'))
     c.phone = fieldmap.get('cform-phone');
  if(fieldmap.containskey('cform-role'))
   {  
      ContactRole.sort();
      String crole = String.join(ContactRole,';');
      c.Role__c = crole;
     //System.debug('crole:'+crole);
   }
     
  upsert c;
}

@RemoteAction
public Static void sendpriceletter(String plForm, String iframesrc){
  //String plForm = ApexPages.currentPage().getParameters().get('plForm');
  system.debug('iframesrc:'+iframesrc);
  System.debug('PlForm is:'+plForm);
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
  
  List<Price_Letter_Item__c> plitem = [Select id, Price_Letter__c, Account_Material__c, 
    Account_Material__r.Account__r.id from Price_Letter_Item__c where Price_Letter__c = :plId];
 
    List<String> plAccount = new List<String>();
    for(Price_Letter_Item__c acc:plitem) 
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
  List<Contact> contacts = [select id, name, email from Contact where email IN :emails and accountid IN :plAccount];
  system.debug('emails selected are:'+emails);
  system.debug('Contact:'+contacts);
  
  Set<String> foundcontacts = new Set<String>();
  Set<String> notfoundcontacts = new Set<String>();
  for(Integer i=0;i<emails.size();i++){
    Integer count = 0;
    for(Integer k =0;k<contacts.size();k++){
        if(emails[i].equals(contacts[k].email)){
            count++;
            
        }
        if(!foundcontacts.contains(contacts[k].Name))
            foundcontacts.add(contacts[k].Name);
      }
    if(count==0){
        notFoundContacts.add(emails[i]);
    }
  }
  String finalSentToList = '';
  for(String k :foundcontacts){
    finalSentToList += k + '\n'; 
  }
  for(String k:notfoundcontacts){
        finalSentToList += k+'\n';
    
  }
 // List<String> finalSentToList = new List<String>(foundcontacts);
 // finalSentToList.addall(notfoundcontacts) ;
  
    Boolean result = true;                         

    try {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

        if (emails.size() > 0) {mail.setToAddresses(emails);}
        mail.setReplyTo(userinfo.getUserName());
        mail.setSenderDisplayName(userinfo.getName());
        mail.setSubject(subject);
        mail.setBccSender(true);
        mail.setUseSignature(true);
        mail.setPlainTextBody(body);
        //blob b = PDF_Functions.CreatePDFBlobFromPageReference('/apex/price_letter', price_letter_id);
        //blob b = PDF_Functions.CreatePDFBlobFromPageReference('/apex/price_letter', plId);
        blob b = PDF_Functions.CreatePDFBlobFromPageReference('/apex/'+iframesrc, plId);
        Messaging.EmailFileAttachment EFA = new Messaging.EmailFileAttachment();
        EFA.setBody(b); 
        EFA.setFileName('Price_Letter.pdf');
        EFA.setContentType('application/pdf');
        EFA.setInline(false);
        mail.setFileAttachments(new Messaging.EmailFileAttachment[]{EFA});

        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }
    catch (Exception e) {result = false;}

  List<Price_Letter_Contact__c> plcontacts = new list<Price_Letter_Contact__c>();
  for(Contact c:contacts)
  { Price_letter_contact__C plc = new Price_letter_Contact__c();
    plc.price_letter__c = plId;
    //plc.price_letter__c = price_letter_id;
    plc.contact__c = c.id;
    plcontacts.add(plc);
    
  }
  if(plcontacts.size() > 0)
    upsert plcontacts;
    
    //List<Price_Letter__c> pl = [select Id from Price_Letter__c where Id =: price_letter_id];
    List<Price_Letter__c> pl = [select Id from Price_Letter__c where Id =: plId];
    if(pl.size()>0){
      pl[0].sent_to__c = finalsenttolist;
      pl[0].sent__c = isSentto ;
      pl[0].Language__c = iframesrc;
      system.debug('Upsert Done');
      update pl;
    }
}

Public Static List<Price_Request_Transaction__c> priceletterPRT(List<Account_Material__c> ams, Map<Id, Price_Request_Transaction__c> quoteprtmap)
{
List<Price_Request_Transaction__c> transactions = new list<Price_Request_Transaction__c>();
Set<String> aids = new Set<String>();
CurrencyMap = new Map<String, Double>();
  for(CurrencyType c:[select id, IsoCode, ConversionRate from CurrencyType])
  {
      if(c.isocode != '' && c.isocode != null)
         CurrencyMap.put(c.IsoCode, c.ConversionRate);
  }
 
 for(Account_material__c am:ams)
  {
    Price_Request_Transaction__c PRT = new Price_Request_Transaction__c();
    PRT.SAP_Data__c = am.SAP_Data__c;
    CSP_JSON_Response response = (CSP_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
    PRT.Approval_Status__c = 'Submitted';
    PRT.Approval_Level__c = 'Catch All';
    PRT.type__c = 'Price Letter';
    PRT.Account_Material__c = am.id;
    PRT.Account_Material__r = am;
    PRT.SAP_Material__c = am.SAP_Material__c;
    PRT.SAP_Material__r = am.SAP_Material__r;
    PRT.ship_to__c = am.Account__c;
    PRT.Ship_to_dm__c = am.Account__r.owner.managerid;
        
    PRT.ship_to__r = am.Account__r;
    if(am.Account_Sold_To_Id__c != null)
      aids.add(am.Account_Sold_To_Id__c);
    if(am.Account_Corp_Account_Id__c != null)
       aids.add(am.Account_Corp_Account_Id__c);
     system.debug('aids:'+aids);
    
        
    PRT.average_order_qty__c = am.Avg_Order_Qty__c;
    PRT.average_Order_Qty_UoM__c = am.Avg_Order_Qty_Uom__c;
    
    if(quoteprtmap.containskey(am.id))
        PRT.Requested_Tiers__c = quoteprtmap.get(am.id).Requested_Tiers__c;
        
    
    List<SAP_Price_Tier__c> CSPs = new List<SAP_Price_Tier__c>();
    List<SAP_Price_Tier__c> targets = new List<SAP_Price_Tier__c>();
    
    //If there are no CSP Tier present for Account Material
     if(response.tbl_CSP_prices.size() > 0)
        for(integer i=0; i<response.tbl_CSP_prices.size(); i++)       
        {
             CSP_JSON_Response.tbl_CSP_prices CSP = response.tbl_CSP_prices.get(i);
             SAP_Price_Tier__c t = new SAP_Price_Tier__c();
             if(csp.csp_price != '')
               t.Price__c = stringtodouble(CSP.csp_price);
             if(csp.csp_volume != '')
               t.Volume__c = stringtodouble(csp.csp_volume);
             if(csp.csp_currency != null)
               if(csp.csp_currency.length() > 3)
                 t.CurrencyIsoCode = csp.csp_currency.substring(0,3);
               else
                 t.currencyIsoCode = csp.csp_currency;
             if(csp.csp_price_unit != '')
               t.Price_Unit__c = stringtodouble(csp.csp_price_unit);
             if(csp.csp_uom != '')
                t.price_uom__c = csp.csp_uom; 
             if(csp.csp_scale_uom != '')
                t.volume_uom__c = csp.csp_scale_uom;             
                  
             if(csp.csp_expiration_date != '' && !csp.csp_expiration_date.contains('9999'))
              t.Expiration_Date__c = stringtodate(csp.csp_expiration_date);
             
             if(csp.csp_effective_date != '' && !csp.csp_effective_date.contains('9999'))
              t.Effective_Date__c = stringtodate(csp.csp_effective_date);      
             

             t.price_protection_code__c = csp.csp_price_protection_code;
             t.price_protection_desc__c = csp.csp_price_protection_desc;
             
                                 
             t.Condition_Number__c = csp.csp_condition_nbr;
             if(t.effective_date__c != null || t.expiration_date__c != null || t.volume__c != null || t.price__c != null)
             CSPs.add(t);
        }
        PRT.CSP_Tiers__c = JSON.serialize(CSPs);
    
       if(response.tbl_target_prices.size() > 0)
       for(CSP_JSON_Response.tbl_target_prices target:response.tbl_target_prices) 
        {         
             SAP_Price_Tier__c t = new SAP_Price_Tier__c();
             if(target.target_price != null && target.target_price != '')
             t.Price__c = stringtodouble(target.target_price);
             if(target.tier_volume != null && target.tier_volume != '')
             t.Volume__c = stringtodouble(target.tier_volume);
             if(target.target_price_currency != null)
               if(target.target_price_currency.length() > 3)
                 t.CurrencyIsoCode = target.target_price_currency.substring(0,3);
               else
                 t.currencyisocode = target.target_price_currency;
             t.Price_UoM__c =  target.target_price_uom;
             if(target.target_price_unit != null && target.target_price_unit != '')
             t.price_unit__c = stringtodouble(target.target_price_unit);
             t.volume_uom__c = target.target_scale_uom;
             if(target.exception1_price != null && target.exception1_price != '')
                t.exception_1_Price__c = stringtodouble(target.exception1_price);
             if(target.exception2_price != null && target.exception2_price != '')
                t.exception_2_Price__c = stringtodouble(target.exception2_price);
    
             if(target.total_target_price != null && target.total_target_price != '')
                t.total_target_price__c = stringtodouble(target.total_target_price);
             String dpl_currency = '';
             if(target.dpl_price_currency != null)
             if(target.dpl_price_currency.length() > 3)
                 dpl_currency = target.dpl_price_currency.substring(0,3);
             else
                 dpl_currency = target.dpl_price_currency;
             if(target.dpl_price != null && target.dpl_price != '' && dpl_currency != '' )
                t.dpl_price__c = convertcurrency(stringtodouble(target.dpl_price), dpl_currency , t.currencyisocode, currencymap);
    
             if(target.dpl_price_unit != null && target.dpl_price_unit != '')
                t.dpl_Price_unit__c = stringtodouble(target.dpl_price_unit);
             if(target.dpl_price_uom != null && target.dpl_price_uom != '')
                t.dpl_Price_uom__c = target.dpl_price_uom;
             
             if(t.price__c != null && t.price_Uom__c != null)
             targets.add(t);          
        }
        PRT.target_tiers__c = JSON.serialize(targets);
    
     transactions.add(PRT);
     system.debug('PRT Record is:'+transactions);
    }
    
    //Starting Insert Transactions
     
  Map<Id, Price_Request_Transaction__c> tmap = new map<Id, Price_Request_Transaction__c>();
  List<SAP_Price__c> sapprices = new List<SAP_Price__c>();
  if(transactions.size() > 0)
  Insert transactions;
  
  Map<Id, Account> accmap = new Map<id, Account>([select id from Account where id IN :aids]);
  for(Price_Request_Transaction__c t:transactions)
  {  
    
    if(accmap.containskey(t.Account_Material__r.Account_Sold_To_Id__c))
        t.Sold_To__c = accmap.get(t.Account_Material__r.Account_Sold_To_Id__c).id;
    if(accmap.containskey(t.Account_Material__r.Account_Corp_Account_Id__c))
        t.Corporate_Account__c = accmap.get(t.Account_Material__r.Account_Corp_Account_Id__c).id;
     tmap.put(t.id, t); 
     
     sap_price__c csp = new SAP_Price__c();
     sap_price__c tar = new SAP_Price__c();
     sap_price__c req = new SAP_Price__c();
     
     csp.Price_Request_Transaction__c = t.id;
     tar.Price_Request_Transaction__c = t.id;
     req.Price_Request_Transaction__c = t.id;
     
     csp.type__c = 'CSP';
     tar.type__c = 'Target';
     req.type__c = 'Requested';
     
     csp.Quantity__c = t.Quantity__c;
     tar.Quantity__c = t.Quantity__c;
     req.Quantity__c = t.Quantity__c;
     
     csp.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
     tar.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
     req.Estimated_Order_Qty_UoM__c = t.Estimated_Order_Qty_UoM__c;
     
     csp.PRT_Type__c = t.Type__c;
     tar.PRT_Type__c = t.Type__c;
     req.PRT_Type__c = t.Type__c;
     
     sapprices.add(csp);
     sapprices.add(tar);
     sapprices.add(req);
  }
  if(sapprices.size() > 0)
  insert sapprices;
  List<SAP_Price_Tier__c> alltiers = new List<SAP_Price_Tier__c>();
  for(SAP_Price__c pr:sapprices)
  {
    List<SAP_Price_Tier__c> tiers = new List<SAP_Price_Tier__c>();
    if(pr.type__c == 'CSP')
       if(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).CSP_tiers__c, List<SAP_Price_Tier__c>.class);
    if(pr.type__c == 'Target')
       if(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Target_tiers__c, List<SAP_Price_Tier__c>.class);
    
    if(pr.type__c == 'Requested')
       if(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c != null)
          tiers = (list<SAP_Price_Tier__c>)JSON.deserialize(tmap.get(pr.Price_Request_transaction__c).Requested_tiers__c, List<SAP_Price_Tier__c>.class);
    
    for(SAP_Price_Tier__c t:tiers)
       t.SAP_Price__c = pr.id;
    alltiers.addall(tiers);
  }
  if(alltiers.size() > 0)
  insert alltiers;
  
  if(transactions.size() > 0)
  upsert transactions;
    
  return transactions;
}
  
  
Public static Double ConvertCurrency(Double iValue, String sFrom, String sTo, Map<String, Double> conversionmap)
{
   if(conversionmap.containskey(sFrom) && conversionmap.containskey(sTo))
   {
   Double baseunit = iValue * conversionmap.get(sTo);
   return (baseunit / conversionmap.get(sFrom));
   }
   else
    return iValue;
}

public static Double Stringtodouble(Double d){ return d; }
public static Double Stringtodouble(Decimal d){ return Double.valueof(d); }
public static Double stringtodouble(String sIn){
  string temp = '';
  if(sIn != '' && sIn != null)
  {
    if(sIn.contains('-'))
    {  temp = sIn.replaceall('-', '');
       temp = '-' + temp;
    }
    else{ temp = sIn; }
    if(temp.contains(','))
      temp = temp.replaceall(',','');
    return double.valueof(temp);
  }
  else{ return null; }
}

Public static Date stringtodate(string s){
  
  date d = null;
  try{
    d = Date.valueof(s.substring(0, 4) + '-' + s.substring(4, 6) + '-' + s.substring(6)); 
  }catch(exception e){system.debug('***DATE CONVERT ERROR***: ' + s + ' ERROR: ' + e.getmessage());} 
  return d;
}

}