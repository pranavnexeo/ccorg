Public with Sharing Class Nexprice{

Public String StateOptions{get; set;}
Public String UserOptions{Get; set;}
Public String ReporteeOptions{get; set;}
Public String OrgOptions{get; set;} 
Public String DivOptions{get; set;}
Public String IndOptions{Get; set;}
Public String OfficeOptions{get; set;}
Public String GroupOptions{Get; set;}
Public String MatGroups{get; set;}
Public String Containers{Get; set;}
Public String PH4s{get; set;}
Public String PH5s{get; set;}
Public String PH6s{get; set;}
Public String PH7s{get; set;}
Public String PriceProtections{Get; set;}

Public Set<String> PH4_set{Get; set;}
Public Set<String> PH5_set{get; set;}
Public Set<String> PH6_set{get; set;}
Public Set<String> PH7_set{get; set;}
Public String cpiflag{get; set;}
Public String PH6_Options{get; set;}
Public String PH7_Options{get; set;}
Public String OwnerOptions{get; set;}
Public String MaterialTypeOptions{get; set;}
private nexprice_mobileSetPrice ctrl;
public User_Defaults__c defaults{get; set;}
Public string myEmpId {get; set;}


Public Nexprice(){

User User = [select id, name, nexPrice_Disregard_Hierarchy__c, userroleid, Ashland_Employee_Number__c from User where id = :userinfo.getuserid() limit 1];
myEmpId = User.Ashland_Employee_Number__c;
List<Role_Data__c> roledata = new List<Role_Data__c>();

if(User.nexPrice_Disregard_Hierarchy__c == false)
roledata = [select id, data__c, type__c, API_Field_Name__c, role_id__c from Role_Data__c where role_id__c = :user.userroleid and type__c = 'Account'];
else
roledata = [select id, data__c, type__c, API_Field_Name__c, role_id__c from Role_Data__c where role_name__c = 'AD Sales' and type__c = 'Account'];


PH6_Options = getph6();
PH7_Options = '[{ label: "--None--", value: "--None--"}]';

Set<String> fields = new Set<String>{'SAP_Sales_Org__c', 'SAP_DivisionCode__c', 'SAP_Industry_Key__c',  'HQ_Sales_Office__c', 'SAP_SalesGroup__c', 'SAP_Sold_To_Account_Owner__c'};
Map<String, List<String>> options = new Map<String, List<String>>();

for(string f:fields)
  options.put(f, new List<String>());

for(Role_Data__c rd:roledata)
  if(rd.data__c != null && rd.data__c != '' && fields.contains(rd.api_field_name__c))
    options.get(rd.api_field_name__c).addall(rd.data__c.split('; '));


UserOptions = '';
UserOptions += '<option class="user" value="'+ string.valueof(user.id).substring(0, 15) + '">'+ user.name + '</option>';
for(Role_Reportee__c r:[select id, user__c, user__r.name, Full_Name__c  from role_reportee__c where role__c = 'AD Sales' order by user__r.name limit 2000])
{   UserOptions += '<option class="user" ';
    UserOptions += 'value="' + string.valueof(r.user__r.id).substring(0, 15) + '">' + r.user__r.name + '</option>';
}

ReporteeOptions = '';
ReporteeOptions += '<option class="user" selected="selected" value="'+ user.Ashland_Employee_Number__c + '">'+ user.name + '</option>';
if(User.nexPrice_Disregard_Hierarchy__c)
  for(Role_Reportee__c r:[select id, user__c, user__r.name, user__r.Ashland_Employee_Number__c, Full_Name__c from role_reportee__c where role__c = 'AD Sales' order by user__r.name limit 2000])
  {
    if(r.user__c != userinfo.getuserid()){
    ReporteeOptions += '<option ';
    //if(r.user__c == userinfo.getuserid())
    //  ReporteeOptions += 'selected = "selected" ';
    ReporteeOptions += 'class="soldseller" value="' + r.user__r.Ashland_Employee_Number__c + '">' + r.user__r.name + '</option>';
    }
  }   
else
  for(Role_Reportee__c r:[select id, user__c, user__r.name, user__r.Ashland_Employee_Number__c, Full_Name__c from role_reportee__c where role_id__c = :user.userroleid order by user__r.name limit 2000])
  {
    if(r.user__c != userinfo.getuserid()){
    ReporteeOptions += '<option ';
   // if(r.user__c == userinfo.getuserid())
   //   ReporteeOptions += 'selected = "selected" ';
     ReporteeOptions += 'class="soldseller" value="' + r.user__r.Ashland_Employee_Number__c  + '">' + r.user__r.name + '</option>';
     }
  }

defaults = User_Defaults__c.getInstance(userinfo.getuserroleid());
MaterialTypeOptions = '';
List<String> types = new List<String>{'COMMODITY', 'SPECIALTY'};

for(integer i=0; i<types.size();i++){
    MaterialTypeOptions += '<option ';
    //if(types.get(i) == defaults.Classification__c)
    //    MaterialTypeOptions += 'selected = "selected" ';
    MaterialTypeOptions += 'value="' + types.get(i) + '">' + types.get(i) + '</option>';
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
 
cpiflag = '';
  
Set<String> contcodes = new Set<String>();
Containers = '';
  for(Material_Container_Code__c c:[select id,  Material_Container_ISO__c from Material_Container_Code__c ])
     if(!contcodes.contains(c.material_Container_ISO__c))
     {   Containers += '<option class="cont" value="' + c.Material_Container_Iso__c + '">' + c.Material_Container_Iso__c + '</option>';
         contcodes.add(c.Material_Container_ISO__c);
     }


if(!apexpages.currentpage().getURL().contains('12'))
OrgOptions = '<option value="All Sales Orgs">All Sales Orgs</option>';

  for(SAP_Sales_Org__c org:[select Sales_Org_Code__c, Sales_Org_Description__C,  Sales_Org_Code_w_o_G2__c  from SAP_Sales_Org__c where  Sales_Org_Code_w_o_G2__c IN :options.get('SAP_Sales_Org__c') order by Sales_org_description__c limit 500])
     OrgOptions += '<option class="salesorg" value="' + org.Sales_Org_Code_w_o_G2__c + '">' + org.Sales_Org_Code_w_o_G2__c + ' - ' + org.Sales_Org_Description__c.escapeEcmaScript() + '</option>';

if(!apexpages.currentpage().getURL().contains('12'))
DivOptions = '<option value="All Divisions">All Divisions</option>';
  for(SAP_Sales_Division__c div:[select id, Sales_Division_Code__c, Sales_Division_Description__C from SAP_Sales_Division__c where Sales_Division_Description__c LIKE '%Nexeo%' and Sales_Division_code__c IN :options.get('SAP_DivisionCode__c')limit 10])
     DivOptions += '<option class="salesdiv" value="' + div.sales_division_Code__c + '">' + div.sales_division_Code__c + ' - ' + Div.Sales_Division_Description__c.escapeEcmaScript() + '</option>';

if(!apexpages.currentpage().getURL().contains('12'))
IndOptions = '<option value="--None--">--None--</option>';

  for(SAP_Industry_Name__c ind:[select industry_code__c, Industry_Name__c from SAP_Industry_Name__c where Industry_Code__c IN :options.get('SAP_Industry_Key__c') order by Industry_name__c limit 2000])
     IndOptions += '<option class="industry" value="' + ind.Industry_Code__c + '">' + Ind.Industry_Name__c + '</option>';

OfficeOptions = '';
  for(SAP_Sales_Office__c off:[select id, Sales_Office_Code__c, Sales_Office_Name__c from SAP_Sales_Office__C where Sales_Office_Name__c != 'Masked' and Sales_Office_Code__c IN :options.get('HQ_Sales_Office__c') order by Sales_Office_Name__c limit 2000])
     OfficeOptions += '<option class="office" value="' + off.Sales_Office_Name__c + '">' + off.Sales_Office_Name__c + '</option>';
     
GroupOptions = '';
  for(SAP_Sales_Group__c g:[select id, Sales_Group_Code__c, Sales_Group_Name__c from SAP_Sales_Group__c where Sales_Group_Name__c != 'Masked' and Sales_Group_code__c IN :options.get('SAP_SalesGroup__c') order by Sales_Group_Name__c limit 2000])
     GroupOptions += '<option class="grp" value="' + g.Sales_Group_Name__c + '">' + g.Sales_Group_Name__c + '</option>';

MatGroups = '';
  for(Material_Pricing_Group1__c mg1:[select Material_Pricing_Group1_Code__c, Material_Pricing_Group1_Description__C from Material_Pricing_Group1__c where Material_Pricing_Group1_Description__C != 'MASKED' limit 5000])
     MatGroups += '<option class="mgrp" value="' + mg1.Material_Pricing_Group1_Code__c + '">' + mg1.Material_Pricing_Group1_Description__C + '</option>';

PH4_Set = new set<String>();
PH5_Set = new set<String>();
PH6_Set = new set<String>();
PH7_Set = new set<String>();
PH4s = '';
PH5s = '';
if(!apexpages.currentpage().getURL().contains('12'))
PH6s = '<option value="--None--">--None--</option>';
if(!apexpages.currentpage().getURL().contains('12')) 
PH7s = '<option value="--None--">--None--</option>';


for(Product_Hierarchy2__c ph2:[select PH4__c, 
                                      Product_Hierarchy4__r.Product_Hierarchy_description__c, 
                                      PH5__c,
                                      Product_Hierarchy5__r.Product_Hierarchy_description__c, 
                                      PH6__c,
                                      Product_Hierarchy6__r.Product_Hierarchy_description__c, 
                                      PH7__c,
                                      Product_Hierarchy7__r.Product_Hierarchy_description__c
                                      from Product_Hierarchy2__c where Product_Hierarchy1__r.Product_Hierarchy_Description__c = 'DISTRIBUTION' limit 10000])
                                      {
                                        if(!PH4_set.contains(ph2.PH4__c) && ph2.PH4__c != null && ph2.Product_Hierarchy4__r.Product_Hierarchy_description__c != null )
                                        {  PH4s += '<option class="PH4" value="' + ph2.PH4__c + '">' + ph2.Product_Hierarchy4__r.Product_Hierarchy_Description__c + '</option>';
                                           PH4_set.add(ph2.PH4__c);
                                        }
                                        if(!PH5_set.contains(ph2.PH5__c) && ph2.PH5__c != null && ph2.Product_Hierarchy5__r.Product_Hierarchy_description__c != null)
                                        {  PH5s += '<option class="PH5" value="' + ph2.PH5__c + '">' + ph2.Product_Hierarchy5__r.Product_Hierarchy_Description__c + '</option>';
                                           PH5_set.add(ph2.PH5__c);
                                        }
                                        if(!PH6_set.contains(ph2.PH6__c) && ph2.PH6__c != null && ph2.Product_Hierarchy6__r.Product_Hierarchy_description__c != null)
                                        {  PH6s += '<option class="PH6" value="' + ph2.PH6__c + '">' + ph2.Product_Hierarchy6__r.Product_Hierarchy_Description__c + '</option>';
                                           PH6_set.add(ph2.PH6__c);
                                        }
                                        if(!PH7_set.contains(ph2.PH7__c) && ph2.PH7__c != null && ph2.Product_Hierarchy7__r.Product_Hierarchy_description__c != null)
                                        {  PH7s += '<option class="PH7" value="' +  ph2.PH7__c + '">' + ph2.Product_Hierarchy7__r.Product_Hierarchy_Description__c + '</option>';
                                           PH7_set.add(ph2.PH7__c);
                                        }
                                      }


     PriceProtections = '';
     List<String> protections = new list<String>();

     for(Price_Protection_Codes__c p:Price_Protection_Codes__c.getall().values())
     {
       protections.add(p.code__c + ' - ' + p.name);

     }
     protections.sort();
     for(String s:protections)
        PriceProtections +=  '<option class="priceprot" value="' + s + '" label="' + s + '" >' + s + '</option>';

     stateoptions = '<option value="--None--">--None--</option>';    
     List<String> holder = new list<String>();
     List<US_States__C> states = US_States__c.getall().values();
     for(US_States__c s:states)
       holder.add(s.name);
       holder.sort(); 
     For(integer i=0; i<holder.size(); i++)
       stateoptions += '<option value="' + holder.get(i) + '">' + holder.get(i) + '</option>';
       
     

}

Public Nexprice(nexprice_mobileSetPrice controllerParam){
   ctrl=controllerParam;   
   
}

Public string getPH6(){
     string ph6 = '';
     set<string> uniquephs = new set<string>();
     List<String> Holder = new List<String>();
     List<PH6_PH7__C> phs = PH6_PH7__c.getall().values();
     system.debug('size is : '+phs  );
     for(PH6_PH7__c ph:phs)
     {  
      if(!uniquephs.contains(ph.ph6__c))
      { holder.add(ph.ph6__c);
        uniquephs.add(ph.ph6__c);
      }
     }
       holder.sort(); 
     ph6 = '[{ label: "--None--", value: "--None--"}';
     For(integer i=0; i<holder.size(); i++)
     {
         string sLabel = String.escapesinglequotes(holder.get(i));
         ph6 += ',{ label: "' + sLabel + '", value: "' + sLabel + '"}';

     }
     ph6 += ']';
     return ph6;
}

@RemoteAction
Public static accountdata FetchMyAccounts(string ownerid, string soldtosearch, string flag, string q){
  accountdata data = new accountdata(ownerid, soldtosearch, flag, q);
  return data;
}



@RemoteAction 
Public static combogriddata getAccountDetails(List <string> corp, List <String> soldTo, List <string> shipTo){
List<Account> accts = new List <Account>();
system.debug('Corp:'+corp);
system.debug('SoldTo:'+soldTo);
system.debug('ShipTo:'+shipTo);

if(shipTo != null)
    accts = [select ParentId, SAP_DivisionCode__c, SAP_Division_Desc__c, SAP_Sales_Org__c, SAP_Partner_Functions__c, SAP_Corporate_Account_Id__c, SAP_Sold_To_Account_Id__c, AccountNumber, name, id, SAP_Corporate_Account__c, SAP_Sold_To_Account__c from Account where (NOT Name LIKE '%DO NOT%') AND Inactive_Account__c != true AND id IN :shipTo];
else if(soldTo != null)
    accts = [select ParentId, SAP_DivisionCode__c, SAP_Division_Desc__c, SAP_Sales_Org__c, SAP_Partner_Functions__c, SAP_Corporate_Account_Id__c, SAP_Sold_To_Account_Id__c, AccountNumber, name, id, SAP_Corporate_Account__c, SAP_Sold_To_Account__c from Account where (NOT Name LIKE '%DO NOT%') AND Inactive_Account__c != true AND (SAP_Sold_To_Account_Id__c IN :soldTo OR Id IN :soldTo)];  
else if(corp != null)
    accts = [select ParentId, SAP_DivisionCode__c, SAP_Division_Desc__c, SAP_Sales_Org__c, SAP_Partner_Functions__c, SAP_Corporate_Account_Id__c, SAP_Sold_To_Account_Id__c, AccountNumber, name, id, SAP_Corporate_Account__c, SAP_Sold_To_Account__c from Account where (NOT Name LIKE '%DO NOT%') AND Inactive_Account__c != true AND (SAP_Corporate_Account_Id__c IN :corp)];

system.debug('Accounts are:'+accts);
combogriddata data = new combogriddata(accts);
return data;
}

@RemoteAction
Public static List<Account_Material__c> FromAccount(String aid){
 return Account_material_functions.getAccountMaterialsFromAccounts(new list<String>{aid});
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
Public static String  getForms(List<String> ids, String Type){   
   String toreturn =  Account_Material_Functions.getForms(ids, type); 
   return toReturn;
}

@RemoteAction
Public static string FetchPH7(String ph6){
     system.debug('ph6 is : '+ph6);
     string ph7 = '';
     set<string> uniquephs = new set<string>();
     List<String> Holder = new List<String>();
     List<PH6_PH7__C> phs = PH6_PH7__c.getall().values();
     for(PH6_PH7__c ph:phs)
     {  
      
      if(!uniquephs.contains(ph.ph7__c) && ph.ph6__c == ph6)
      { holder.add(ph.ph7__c);
        uniquephs.add(ph.ph7__c);
      }
     }
       holder.sort(); 
     ph7 = '<option value="">--None--</option>';
     For(integer i=0; i<holder.size(); i++)
     {
         string sLabel = holder.get(i);
         ph7 += '<option value="' + sLabel + '">' + sLabel + '</option>';
     }
     
     system.debug('ph7 is : '+ph7);
     neXprice_tracker__c ntk = new neXprice_tracker__c();
     ntk.Operation__c = 'Multisearch Field';
     ntk.SearchField__c = 'PH6';
     ntk.SearchValue__c = ph6;
     ntk.TabName__c = 'Price Maintenance';
     insert ntk;
     
     return ph7;
}

@RemoteAction
Public static List<Price_Request_Transaction__c> SubmitForm(List<String> amids, List<formData> data, string operation){
    Boolean CMflag = false;
 Map<String, string> wheres = new Map<String, String>();
 for(formData fd:data)
   wheres.put(fd.name, fd.value);
 
List<Account_Material__c> ams = Account_Material_Functions.getAccountMaterials(amids);
if(operation == 'simulate')
return Account_Material_Functions.getTransactions(ams, wheres, CMflag);
else
{
  List<Price_Request_Transaction__c> transactions = Account_Material_Functions.insertTransactions(ams, wheres, CMflag);
  for(Price_Request_Transaction__c t:transactions)
    t.approval_Status__c = 'Draft';
  
  upsert transactions;

  List<Approval.ProcessSubmitRequest> reqs = new List<Approval.ProcessSubmitRequest>();
  for(Price_Request_Transaction__c t:transactions)
  {    Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
       req1.setComments(t.comments__c);
       req1.setObjectId(t.id);  
       reqs.add(req1);
  } 
  List<approval.ProcessResult> results = Approval.process(reqs); 
    
  return transactions;
}
}

@RemoteAction
Public Static Boolean ValidateStartDate(List<String> amids, List<formData> data, string operation)
{
    Boolean Valid;
    Date prteffdate = null;
    Date cspeffdate = null;
    Date cspexdate = null;
    Set<Boolean> Values = new Set<Boolean>();
        
    for(formData fd:data)
    {
        if(fd.name == 'effdate')
        {        
        //system.debug('fd.value1 is:'+long.valueof(fd.value));
        //system.debug('fd.value2 is:'+ datetime.newinstance(long.valueof(fd.value)).dategmt());
           prteffdate = datetime.newinstance(long.valueof(fd.value)).dategmt(); 
        //system.debug('prteffdate is:'+prteffdate);
         }
    }       
       List<Account_Material__c> ams = [Select SAP_Data__c from Account_Material__c where id IN :amids];
       CSP_JSON_Response response;
   
       for(Account_Material__c am: ams)
       {
           Valid = False;
           if(am.SAP_Data__c != null)
               response = (CSP_JSON_Response)JSON.deserialize(am.SAP_Data__c, CSP_JSON_Response.class);
            
             //system.debug('CSPs are:'+ response);
             //system.debug('csp size: ' + response.tbl_CSP_prices.size());
             if(response.tbl_CSP_prices.size() > 0){
                 for(integer i=0; i< response.tbl_CSP_prices.size(); i++)
                 {
                    CSP_JSON_Response.tbl_CSP_prices CSP = response.tbl_CSP_prices.get(i);
                    //system.debug('csp.csp_effective_date:'+csp.csp_effective_date);
                    //system.debug('csp.csp_Expiration_date:'+csp.csp_Expiration_date);
                    
                    cspeffdate = Account_Material_Functions.stringtodate(csp.csp_effective_date);
                    //system.debug('cspeffdate:'+cspeffdate);
                    cspexdate = Account_Material_Functions.stringtodate(csp.csp_Expiration_date);
                    //system.debug('cspexdate:'+cspexdate); 
                    
                    if(Valid == False)  
                      if((cspeffdate != null && cspexdate != null)&&(prteffdate >= cspeffdate && prteffdate <= cspexdate))
                          Valid = True;
                      else
                          Valid = False;
                }
            }
            Values.add(Valid);
            //System.debug('AM1:'+Valid);
       }          
       //System.debug('Values:'+Values);
       if(Values.contains(False))
          Valid = False;
       else
          Valid = True;
       
   return Valid;
}

@RemoteAction
Public static List<Price_Request_Transaction__c> SubmitForm12(Boolean sforcecheck, String deviceType, List<String> amids, List<formData> data, string operation, Boolean CMflag){
    Map<String, string> wheres = new Map<String, String>();
    for(formData fd:data)
        wheres.put(fd.name, fd.value);
    
    List<Account_Material__c> ams = Account_Material_Functions.getAccountMaterials(amids);
    system.debug('amids:'+amids);
    system.debug('amsize:'+ams.size());
    system.debug('amids:'+ams[0].id);
    List<Account_Material__c> inputams = new List<Account_Material__c>();
    
    for(Account_Material__c am :ams)
    {
        if(am.has_open_prt__c != true)
            inputams.add(am);
        system.debug('am material:'+am.Material_Name__c);
        system.debug('am has open prt:'+am.has_open_prt__c);
    }
    
    if(operation == 'simulate')
        return Account_Material_Functions.getTransactions(inputams, wheres, CMflag);
    else{
        List<Price_Request_Transaction__c> transactions = Account_Material_Functions.insertTransactions(inputams, wheres, CMflag);
        List<User> toaddressespertransaction = new List<User>();
        List<PRT_Movement_Settings__c> PRTMovmntSett = PRT_Movement_Settings__c.getall().values();
        Map<String,Boolean> customSettMap = new Map<String,Boolean>();
        Map<String,Boolean> CustGrpSettMap = new Map<String,Boolean>();
        
        List<User> userMail = new List<User>();
        Map<Id,String> userEmailMap = new Map<Id,String>();
        userMail = [SELECT Id,Email FROM User WHERE IsActive = true];
        
        for(User userVar : userMail){
            userEmailMap.put(userVar.Id,userVar.Email);
        }
        
        for(PRT_Movement_Settings__c PRTsett : PRTMovmntSett){
            customSettMap.put(PRTsett.Name,PRTsett.Switch__c);
            CustGrpSettMap.put(PRTsett.Name,PRTsett.CG5__c);
        }
        
        Map<String, List<String>> IdToAddresses = new Map<String, List<String>>();
        List<Id> PRTIds = new List<Id>();
        String divCode;
        for(Price_Request_Transaction__c t:transactions){ 
            
            List<String> UserEmail = new List<String>();
            Set<String> toemail = new Set<String>();
        
            if(t.Ship_To__r.SAP_DivisionCode__c != null){
                divCode = t.Ship_To__r.SAP_DivisionCode__c;
                }
            else if (t.Sold_To__r.SAP_DivisionCode__c != null){
                divCode = t.Sold_To__r.SAP_DivisionCode__c;
                }
                 
            if(t.approval_level__c != 'Auto-Approved'){

                if(t.approver__c != null)
                    toemail.add(t.approver__c);
                if(t.approval_backup__c != null)
                    toemail.add(t.approval_backup__c);
             
                 for(String s: toemail){
                    String EmailId = userEmailMap.get(s);
                    UserEmail.add(EmailId);
                 }
                                                  
                IdToAddresses.put(t.id,UserEmail); 
                PRTIds.add(t.id);
            }else{
            if(t.type__c == 'CSP'){
            
            
            
                if(customSettMap.get(divCode) == true){
                    if(CustGrpSettMap.get(divCode) == true){
                        t.approval_Status__c = 'SAP Transfer Open';
                    }
                    else{
                        if(t.Ship_To__r.SAP_Customer_Group_5__c == '11' || t.Ship_To__r.SAP_Customer_Group_5__c == '12' || t.Ship_To__r.SAP_Customer_Group_5__c == '13'){
                            t.approval_Status__c = 'Pending Entry';
                        }
                        else{
                            t.approval_Status__c = 'SAP Transfer Open';
                        }
                    }
                }
                else
                    t.approval_Status__c = 'Pending Entry';
                }
            else 
                t.approval_Status__c = 'Approved';
            }
            if(customSettMap.get(divCode) == true){
             if(CustGrpSettMap.get(divCode) == true){
                 t.PRT_Movement_Switch__c = true;
             }
             else
             {
             if(t.Ship_To__r.SAP_Customer_Group_5__c == '11' || t.Ship_To__r.SAP_Customer_Group_5__c == '12' || t.Ship_To__r.SAP_Customer_Group_5__c == '13'){
                            t.PRT_Movement_Switch__c = false;
                        }
                        else{
                             t.PRT_Movement_Switch__c = true;
                        }
             
             
             }
             
             }
              t.sforce__c = sforcecheck;
             t.DeviceUserAgent__c = deviceType;
        }
        upsert transactions;
        //Calling Email Functions to send email to aprover  
        if(PRTIds.size()>0){
            nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
            system.debug('ns.Email__c is : '+ns.Email__c);
            system.debug('IdToAddresses is : '+IdToAddresses);
            if(ns.Email__c != null && ns.Email__c != '')
                Email_Functions.sendEmailwithTemplate(IdToAddresses,PRTIds,'Template_To_Approver_Level1_12',ns.Email__c);  
            
        }
       
        for(Account_Material__c am :inputams)
            {
                am.has_open_prt__c = true;
                
            }
            update inputams;
        
        return transactions;
    }
    
}

/*added for rfq form*/

@RemoteAction
Public static List<Price_Request_Transaction__c> SubmitFormrfq(List<String> amids, List<formData> data, string operation){
    System.debug('inside SubmitFormrfq -------');
    Map<String, string> wheres = new Map<String, String>();
    for(formData fd:data)
        wheres.put(fd.name, fd.value);
    
    List<Account_Material__c> ams = Account_Material_Functions.getAccountMaterials(amids);
    List<Account_Material__c> inputams = new List<Account_Material__c>();
    
    for(Account_Material__c am :ams)
    {
        if(am.has_open_prt__c != true)
            inputams.add(am);
        system.debug('am material:'+am.Material_Name__c);
        system.debug('am has open prt:'+am.has_open_prt__c);
    }
    
 
            
        List<Price_Request_Transaction__c> transactions = Account_Material_Functions.insertTransactionsrfq(inputams, wheres);
        System.debug('transactions from insertransactions'+transactions );
        List<User> toaddressespertransaction = new List<User>();
        Map<String, List<String>> IdToAddresses = new Map<String, List<String>>();
        List<Id> PRTIds = new List<Id>();
        
        for(Price_Request_Transaction__c t:transactions){  
            if(t.approval_level__c != 'Auto-Approved'){
                List<String> UserEmail = new List<String>();
                Set<String> toemail = new Set<String>();
                if(t.approver__c != null)
                    toemail.add(t.approver__c);
                if(t.approval_backup__c != null)
                    toemail.add(t.approval_backup__c);
             
                toaddressespertransaction = [Select email from User where id IN :toemail];
             
                for(User u: toaddressespertransaction)
                 UserEmail.add(u.email);
                  
                IdToAddresses.put(t.id,UserEmail); 
                PRTIds.add(t.id);
            }else{
            if(t.type__c == 'CSP')
                t.approval_Status__c = 'Pending Entry';
            else
                t.approval_Status__c = 'Approved';
            }
        }
        upsert transactions;
        //Calling Email Functions to send email to aprover  
        if(PRTIds.size()>0){
            nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
            system.debug('ns.Email__c is : '+ns.Email__c);
            if(ns.Email__c != null && ns.Email__c != '')
                Email_Functions.sendEmailwithTemplate(IdToAddresses,PRTIds,'Template_To_Approver_Level1_12',ns.Email__c);  
        }
        
        return transactions;
    
    
}

@RemoteAction
Public Static List <Price_Request_Transaction__c> SimulateForm(List<String> RequestIds, List<formData> data, String Operation, String Option, List<String> mat, Boolean CMFlag){
        List <Price_Request_Transaction__c> PRT = new List <Price_Request_Transaction__c>();
        Map<String, string> wheres = new Map<String, String>();
        system.debug('Operation:'+Operation);
        system.debug('Option Selected is:'+Option);
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
                  Type__c,
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
                  TPI__c,
                  Comments__c,
                  Approval_Rejection_Comments__c,
                  Coordinator_Comments__c, 
                  Account_Material__c,
                  SAP_Data__c, Requested_Tiers__c, CSP_Tiers__c,
                  Prospect_Material__c,
                  CSP_Currency__c,
                  Inner_Table__c, CM_Percent__c
                  from  Price_Request_Transaction__c where Id in : requestids];
                  system.debug('toreject: ' + toreject);
                  
                  if(Operation == 'simulate'){
                      
                          PRT = Account_Material_Functions.getTransactionsrfq(toReject , wheres, Option, CMFlag);
                          system.debug('Simulated PRT:'+PRT);
                              
                      
                   }
                  if(Operation == 'savesubmit'){
                      
                          PRT = Account_Material_Functions.upsertTransactionsrfq2(toReject , wheres, Option, mat, CMFlag);
                          
                          system.debug('SaveSubmit PRT:'+PRT);
                  
                          List<User> toaddressespertransaction = new List<User>();
                          Map<String, List<String>> IdToAddresses = new Map<String, List<String>>();
                          List<Id> PRTIds = new List<Id>();
                            
                          for(Price_Request_Transaction__c t:PRT){  
                                if(t.approval_level__c != 'Auto-Approved'){
                                    List<String> UserEmail = new List<String>();
                                    Set<String> toemail = new Set<String>();
                                    if(t.approver__c != null)
                                        toemail.add(t.approver__c);
                                    if(t.approval_backup__c != null)
                                        toemail.add(t.approval_backup__c);
                                 
                                    toaddressespertransaction = [Select email from User where id IN :toemail];
                                 
                                    for(User u: toaddressespertransaction)
                                        UserEmail.add(u.email);
                                      
                                    IdToAddresses.put(t.id,UserEmail); 
                                    PRTIds.add(t.id);
                                }else{
                                if(t.type__c == 'CSP')
                                    t.approval_Status__c = 'Pending Entry';
                                else
                                    t.approval_Status__c = 'Approved';
                                }
                            }
                            upsert PRT;
                            //Calling Email Functions to send email to aprover  
                            if(PRTIds.size()>0){
                                nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
                                system.debug('ns.Email__c is : '+ns.Email__c);
                                if(ns.Email__c != null && ns.Email__c != '')
                                    Email_Functions.sendEmailwithTemplate(IdToAddresses,PRTIds,'Template_To_Approver_Level1_12',ns.Email__c);  
                            }
                 }
        return PRT;
}

@RemoteAction
Public static List<Account_Material__c>  getPricing(List<String> aiDisplay, List<String> aids){
   system.debug(aiDisplay);
   List<Account_Material__c> toreturn =  Account_Material_Functions.getPricing(aiDisplay, aids); 
   return toReturn;
}

@RemoteAction
Public static List<Account_Material__c>  getProspectMaterial(List<String> aiDisplay, List<String> aids){
   system.debug(aiDisplay);
  // List<Account_Material__c> toreturn2 =  [select id, Has_Open_PRT__c from Account_material__c where id = :aids]; 
   String q = 'select id , Material__c,Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Material_Segment__c, Material_SubSegment__c, Material_Base_Code__c,';
         q += ' Account__r.Name, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c,';
         q += ' CSP__c, CSP_Effective_Date__c, CSP_Currency__c, CSP_Expiration_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Unit__c, Target_UoM__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c, Supplier__c, Container_for_new_material__c,Material_Description__c, Prospect_Material__c ';
         q += 'from Account_Material__c where id in :aids';
     List<Account_material__c> toreturn = database.query(q);
   return toReturn;
}


@RemoteAction
Public static Account FetchAccount(String AccountId)
{  return [select id, name, SAP_Sales_Org__c, SAP_DivisionCode__c from Account where id = :AccountId limit 1]; }

@RemoteAction
Public static Account FetchAccountFromAccountMaterial(String AccountMaterialId)
{  Account_material__c am = [select id, name, Account__r.SAP_Sales_Org__c, Account__r.SAP_DivisionCode__c from Account_material__c where id = :AccountMaterialId limit 1];
   Account a = null;
   if(am != null)
     if(am.Account__c != null)
       a = am.Account__r; 
   return a;
}

@RemoteAction
Public static String FetchAccountSelect(List<String> accountmaterialids)
{
  String toReturn = '<select class="easyui-combobox" id="add_acct" name="add_acct" data-label="Account_Name__c" data-value="Account__c" style="width:225px;">';

  set<string> aids = new set<string>();
  for(account_material__c am:[select id, Account__c, Account__r.name from Account_material__c where id IN :accountmaterialids])
  {  if(!aids.contains(am.Account__c))
      toReturn += '<option value="' + am.account__c + '">' + am.account__r.name + '</option>';
     aids.add(am.account__c);
  }
  toReturn += '</select>';
  return toreturn;
}

@RemoteAction
Public static List<comboData> FetchAccountOptions(List<String> accountmaterialids)
{
  List<comboData> toreturn = new List<comboData>();
  set<string> aids = new set<string>();
  for(account_material__c am:[select id, Account__c, Account__r.name from Account_material__c where id IN :accountmaterialids])
  {  if(!aids.contains(am.Account__c))
      toreturn.add(new comboData(am.account__r.name, am.account__c));
     aids.add(am.account__c);
  }
  return toreturn;
}

@RemoteAction
Public static boolean ReleaseQuote(List<String> quoteids){
  List<Price_request_transaction__c> quotes = [select id, type__c,PRT_Movement_Switch__c, approval_status__c from Price_Request_Transaction__c where id IN :quoteids];
  for(Price_Request_Transaction__c q:quotes)
  { 
    system.debug('status: ' + q.approval_status__c);
    q.type__c = 'CSP';
    if(q.approval_status__c == 'Approved')
        if(q.PRT_Movement_Switch__c)
            q.approval_status__c = 'SAP Transfer Open';
        else
            q.approval_status__c = 'Pending Entry';
  }
  update quotes;
  return (quotes.size() > 0);
}
@RemoteAction
Public static List<CSP_JSON_Request_Item>  getRequests(List<Integer> aiDisplay, List<String> aids){
   system.debug(aiDisplay);
   List<CSP_JSON_Request_Item> toreturn =  Account_Material_Functions.getRequests(aiDisplay, aids); 
   return toReturn;
}

@RemoteAction
Public static List<Account_Material__c> getCPIs(List<String> list0, List<String> list1, List<String> list2, List<String> List3, List<String> List4, List<String> list5, List<String> list6,
                                                List<String> list7, List<String> list8, List<String> list9, List<String> List10, List<String> List11, List<String> List12, List<String> List13, List<String> List14, List<String> List15,
                                                List<String> list16, List<String> list17){

    return Account_Material_Functions.getCPIs(list0,list1,list2,list3,list4,list5,list6,list7,list8,list9,list10,list11,list12,list13,list14,list15,list16,list17);
}
@RemoteAction
Public static List<Price_Request_Transaction__c> getQuotes(List<String> ownerid){
    neXprice_tracker__c ntk = new neXprice_tracker__c();
    ntk.Operation__c = 'getQuotes';
    ntk.TabName__c = 'neXprice-Price Quotes';
    insert ntk;
  return  Account_material_functions.generateAuditMapNew(ownerid, new List<string>{'Quote', 'RFQ'}, new List<String>{'Submitted', 'Approved', 'Rejected-Alternate', 'Rejected', 'Expired', 'Rejected By Approver'});
}
@RemoteAction
Public static List<Price_Request_Transaction__c> getAudit(List<String> ownerids){
  Account_material_functions.SFDC_Maps maps =  Account_material_functions.generateAuditMap(ownerids, new List<string>{'Quote', 'CSP', 'RFQ'}, new List<String>{'Rejected', 'Complete', 'Rejected By Approver'});
  Return maps.price_request_map.values();
}
@RemoteAction
Public static List<Price_Request_Transaction__c> getAuditnew(List<String> ownerids){
    neXprice_tracker__c ntk = new neXprice_tracker__c();
    ntk.Operation__c = 'getAudit';
    ntk.TabName__c = 'neXprice-SFDC Price Audit';
    insert ntk;
  return  Account_material_functions.generateAuditMapnew(ownerids, new List<string>{'Quote', 'CSP', 'RFQ'}, new List<String>{'Rejected', 'Complete', 'Rejected By Approver'});
}
    @RemoteAction
    public static List<Price_Request_Transaction__c> fetchPendingWithSeller(Integer index,  List<String> ownerids){
        String toAdd = '';
        set<string> statuses;
        List<String> EmployeeIds = new List<String>();
        List<User> users = [Select id, Ashland_Employee_Number__c from User where Ashland_Employee_Number__c LIKE : ownerids];
        for(User u:users)
            EmployeeIds.add(u.id);
        system.debug('EmployeeIds:'+EmployeeIds);
            
        if(index == 2){
            statuses =  new set<string>{'Pending Entry', 'Submitted', 'Pending Supplier', 'Approved'};
            toAdd = ' createdbyid in: EmployeeIds OR ship_to__r.Team_Employee_Ids__c  LIKE: ownerids  ';
        }else{
            statuses =  new set<string> {'Rejected-Alternate'};
            toAdd = '  ownerid in: ownerids OR ownerid in: EmployeeIds ';
        }
    
        set<string> types =  new set<string>{'Quote', 'CSP', 'RFQ'};
        
        String query = 'select Id,Inner_Table__c, Name, Inner_Table_For_Seller__c,';
        query+= 'Approval_Status__c,Approval_Level__c, ';
        query+= 'Approver__r.Name, Type__c,';
        query+= 'Sold_To_Account_Number__c,SAP_SoldTo_Account__c,SAP_ShipTo_Account__c,';
        query+= 'Ship_To_Account_Number__c,sap_material__r.name, requested_effective_date__c, ';
        query+= 'Requested_Effective_Date_Text__c,requested_expiration_date__c, Volume__c, Requested_UoM__c,';
        query+= 'Requested_Expiration_Date_Text__c,Price__c, Requested_Price_UoM__c, ';
        query+= 'requested_price_Protection__c, TPI__c,comments__c,Approval_Rejection_Comments__c, Material__c '; 
        query+= 'from Price_Request_Transaction__c ';
        query+= 'where Approval_Status__c in: statuses and  Type__c in: types ';
       
        if(toAdd != '')
            query += ' and ( ' +toAdd+ ' )';
        
        query += ' order by requested_effective_date__c desc';
        system.debug('fetch query is:'+query);
        List<Price_Request_Transaction__c> pendingRecords = Database.query(query);
        
        neXprice_tracker__c ntk = new neXprice_tracker__c();
        ntk.Operation__c = 'fetchPendingWithSeller';
        ntk.TabName__c = 'Index'+index;
        insert ntk;
        
        return pendingRecords;
    }
    
    @RemoteAction
    public static void approveRejectChange(String RequestId,String comments, String approvereject){
        
        if(RequestId != null && RequestId != ''){
            
            RequestId = RequestId.replaceall('SelectedAudit=', '');
            List<String> splitstrings = RequestId.split('&');
            Set<Id> PRTIds = new Set<Id>();
            //Approving Rejecting the records 
            Map<String, Id> WorkItem_Map = new Map<String, Id>();
            List<ProcessInstanceWorkitem> PWIs = [select id, ProcessInstance.TargetObjectId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId IN :splitstrings and p.ActorID = :userinfo.getuserid()];
            
            for(ProcessInstanceWorkItem pwi:PWIs)
                WorkItem_Map.put(pwi.ProcessInstance.TargetObjectId, pwi.id);
            
            List<Approval.ProcessWorkitemRequest> PWIRs = new List<Approval.ProcessWorkitemRequest>();
            for(String s:splitstrings)
            {
               Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
               req2.setComments(comments);
               req2.setAction(approvereject);   
               req2.setWorkitemId(WorkItem_Map.get(s));    
               PWIRs.add(req2);
               PRTIds.add(s);
            }
            List<Approval.ProcessResult> results =  Approval.process(PWIRs);
            
            List<Price_request_transaction__c> prtlist = [select id from Price_request_transaction__c where id in : splitstrings];
            update prtlist;
        
         }
    } 
    
@RemoteAction
public static List<Account_Material__c> saveaccountmaterial(List<String> aid, List<string> mid){ 
    
    List<Account_Material__c> amList = new List<Account_Material__c>();
    List<Account_Material__c> ams = [select id,hidden__c, Account__c, SAP_Material__c, CPI_Deletion_Flag__c from Account_material__c where account__c = :aid.get(0) and SAP_Material__c = :mid.get(0) and CPI_Deletion_Flag__c!= 'X' and hidden__c = true limit 1];
    if(ams.size()>0){
        ams[0].hidden__c = false;
        update ams;
        amList.add(ams[0]);
    }
    else{
        
        List<Account> acctList = [Select Id,OwnerId from Account where id in : aid];
        Account_material__c am = new Account_Material__c(Account__c = aid.get(0), SAP_Material__c = mid.get(0));
        //am.OwnerId = acctList[0].ownerId;
        insert am; 
        amList.add(am);
    }
    
    neXprice_tracker__c ntk = new neXprice_tracker__c();
    ntk.Operation__c = 'Add Material';
    ntk.SearchField__c = 'Account'+aid.get(0);
    ntk.SearchValue__c = 'Supplier'+mid.get(0);
    ntk.TabName__c = 'Price Maintenance';
    insert ntk;
    
    ///// Added by Sneha Likhar to check if price support exist on account material while adding new material///////
    
    List<Account_Material__c> trans1 = new List<Account_Material__c>();
    List<String> sapPayer = new List<String>();
    List<SAP_Price_Support__c> priceSupports = new List<SAP_Price_Support__c>();
    List<String> sapSoldToPayer = new List<String>();
    String region = '';
    List<Price_Support_Junction__c> toInsertPS = new List<Price_Support_Junction__c>();
    Boolean updateFlag = False;

    trans1 = [select id,material_base__c, name, Account__c, Account__r.accountnumber, Account__r.name, Account__r.sap_sales_org__c, Account__r.SAP_DistChannel__c,
                                    Account__r.SAP_DivisionCode__c,Account__r.SAP_ShippingPlant__c,Account__r.SAP_Payer_Account_Id__c,Account__r.SAP_Sold_To_Account_Id__c,Material_Base_Code__c, 
                                    sap_material__r.name, CSP_Effective_Date__c, CSP_Expiration_Date__c, prospect_material__c 
                                    from Account_material__c where id = :amList[0].id];
      system.debug('@@@@@@@trans1'+trans1.size());                              
    if(trans1.size() > 0){
            if(trans1[0].Account__r.SAP_Payer_Account_Id__c != '' && trans1[0].Account__r.SAP_Payer_Account_Id__c != null)
               sapPayer = (trans1[0].Account__r.SAP_Payer_Account_Id__c).split(',');
        
            String PlantDiv = trans1[0].Account__r.SAP_ShippingPlant__c + trans1[0].Account__r.SAP_DivisionCode__c ;
            
            List <SAP_Plant_Region__c> PlantRegion = [Select Id,Division_Code__c,Plant_Division__c, SAP_Plant__r.Plant_Code__c, Region__r.Region_Code__c, Region__r.Region_Description__c  from SAP_Plant_Region__c where Plant_Division__c  =:PlantDiv];
            if(PlantRegion.size()>0)
                region = PlantRegion[0].Region__r.Region_Code__c;
            
            List<Account> soldToAcctList = [select SAP_Payer_Account_Id__c from account where Id =: trans1[0].Account__r.SAP_Sold_To_Account_Id__c];
            if(soldToAcctList.size()>0)
                if(soldToAcctList[0].SAP_Payer_Account_Id__c != '' && soldToAcctList[0].SAP_Payer_Account_Id__c != null)
                    sapSoldToPayer = (soldToAcctList[0].SAP_Payer_Account_Id__c).split(',');
            if(!trans1[0].prospect_material__c)
                priceSupports = [select id,Supplier_Supported_Price__c,X1st_Discount_Sell__c,Region_Code__c,
                                Effective_Date__c ,Expiration_Date__c , name,Agreement_Number__c,Supplier_Name__c,
                                Supplier_Number__c,Customer_Name__c,Material_Buying__c,Base_Material_Code_Buying__c,Deletion_Indicator__c from SAP_Price_Support__c where 
                                     ((Customer_Name__c =: trans1[0].Account__c And Material_Buying__c =: trans1[0].sap_material__c)  
                                     OR (Customer_Name__c =: trans1[0].Account__r.SAP_Sold_To_Account_Id__c And Material_Buying__c =: trans1[0].sap_material__c) 
                                     OR (Customer_Name__c IN: sapSoldToPayer And Material_Buying__c =: trans1[0].sap_material__c and(region_code__c = 'ALL' OR region_code__c =:region)) 
                                     OR (Customer_Name__c IN :sapPayer And Material_Buying__c =: trans1[0].sap_material__c and(region_code__c = 'ALL' OR region_code__c =:region) ) 
                                     OR (Customer_Name__c =: trans1[0].Account__c And Base_Material_Code_Buying__c =: trans1[0].material_base__c )  
                                     OR (Customer_Name__c =: trans1[0].Account__r.SAP_Sold_To_Account_Id__c And Base_Material_Code_Buying__c =: trans1[0].material_base__c ) 
                                     OR (Customer_Name__c IN: sapSoldToPayer And Base_Material_Code_Buying__c =: trans1[0].material_base__c  and(region_code__c = 'ALL' OR region_code__c =:region)) 
                                     OR (Customer_Name__c IN :sapPayer And Base_Material_Code_Buying__c =: trans1[0].material_base__c and(region_code__c = 'ALL' OR region_code__c =:region) ))
                                     and Effective_Date__c <=: trans1[0].CSP_Effective_Date__c and 
                                     (Expiration_Date__c >=: trans1[0].CSP_Effective_Date__c OR Expiration_Date__c = null) ];
                                 
         } 
         system.debug('@@@@@@@priceSupports'+priceSupports.size());
          for(SAP_Price_Support__c ps :priceSupports)
        {
            updateFlag = False;
            if(ps.Customer_Name__c == trans1[0].Account__c && ps.Material_Buying__c == trans1[0].SAP_Material__c)
                updateFlag = True;
            else if(ps.Customer_Name__c == trans1[0].Account__r.SAP_Sold_To_Account_Id__c && ps.Material_Buying__c == trans1[0].SAP_Material__c)
                updateFlag = True;
            else if(ps.Customer_Name__c == trans1[0].Account__c && ps.Base_Material_Code_Buying__c == trans1[0].Material_Base__c )
                updateFlag = True;
            else if(ps.Customer_Name__c == trans1[0].Account__r.SAP_Sold_To_Account_Id__c && ps.Base_Material_Code_Buying__c == trans1[0].Material_Base__c )
                updateFlag = True;
            else if(trans1[0].Account__r.SAP_Payer_Account_Id__c != null && trans1[0].Account__r.SAP_Payer_Account_Id__c != ''){
                    if((trans1[0].Account__r.SAP_Payer_Account_Id__c).contains(ps.Customer_Name__c) && ps.Base_Material_Code_Buying__c == trans1[0].Material_Base__c  && (ps.region_code__c == 'ALL' || ps.region_code__c == region ))
                    {updateFlag = True;}
                    else if((trans1[0].Account__r.SAP_Payer_Account_Id__c).contains(ps.Customer_Name__c) && ps.Material_Buying__c == trans1[0].SAP_Material__c && (ps.region_code__c == 'ALL' || ps.region_code__c == region ))
                    {updateFlag = True;}
                  } 
                  }
                  
              if(updateFlag == True){
                if(priceSupports[0].Expiration_Date__c < system.today() || priceSupports[0].Effective_Date__c > system.today() || priceSupports[0].Deletion_Indicator__c == 'X')
                {    
                    trans1[0].Price_Support_Indicator__c = 'No';
                     update trans1[0];
                    
                }
                else if(priceSupports[0].Effective_Date__c <= system.today() || priceSupports[0].Expiration_Date__c == null)
                {
                    trans1[0].Price_Support_Indicator__c = 'Yes';
                     update trans1[0];
                     
                    Price_Support_Junction__c p = new Price_Support_Junction__c();
                    p.Nexprice_CPI__c = trans1[0].id;
                    p.SAP_Price_Support__c = priceSupports[0].id;
                    Insert p;
                                     
                                       
                }
             }        

/////////////////////////////////////////////////////////////////END///////////////////////////////////////////////////////////
    
    return amList;

}

@RemoteAction
public static List<Account_Material__c> CheckDuplicateAM(List<String> aid, List<string> mid){ 
    List<Account_Material__c> ams = [select id, Account__c, SAP_Material__c, CPI_Deletion_Flag__c from Account_material__c where account__c = :aid.get(0) and SAP_Material__c = :mid.get(0) and CPI_Deletion_Flag__c!= 'X' and hidden__c = false limit 1];
    return ams;
}

@RemoteAction
public static List<Account_Material__c> saveaccountwomaterial(List<String> aid, string mid , string did, string cid)
{
    System.debug('inside saveaccwomaterial');
    List<Account_Material__c> addedAM = new List<Account_Material__c>();
    List<Account_Material__c> ams = [select id, Account__c, supplier__c ,CPI_Deletion_Flag__c from Account_material__c where account__c = :aid.get(0) and supplier__c =:mid limit 1];
    System.debug('ams is!!!'+ams);
    List<Account> acctList = [Select Id,OwnerId from Account where id in : aid];

    Account_material__c am = new Account_Material__c(Account__c = aid.get(0), supplier__c = mid , Material_Description__c = did , Container_for_new_material__c = cid ,ownerId = acctList[0].ownerId);
    if(am.account__c != null && am.supplier__c!= null)
    {  
        am.Prospect_Material__c = true;
        upsert am;  addedAM.add(am); 
        System.debug('addedAM!!!'+addedAM);
    }
    neXprice_tracker__c ntk = new neXprice_tracker__c();
    ntk.Operation__c = 'Add Material-Prospect';
    ntk.SearchField__c = 'Account'+aid.get(0);
    ntk.SearchValue__c = 'Supplier'+mid;
    ntk.TabName__c = 'Price Maintenance';
    insert ntk;

    return addedAM;
}



@RemoteAction
Public static combogriddata getSingleOptions(String fname, List<String> ids, string q, string obj, string fields, string filters, List<String>Ownerid, List<String>Orgs, List<String>Divs, string orderby, string mylimit){ 
List<sobject> records = new list<SObject>();
List<String> OrgsG2 = new List<String>();
String Ownermatch='';
string qstring; 
system.debug('Ids are:'+ids);
system.debug('Ownerid are:'+Ownerid);
system.debug('Orgs are:'+Orgs);
system.debug('Divs are:'+Divs);
system.debug('Field is:'+fname);
system.debug('q is:'+q);
system.debug('fields are:'+fields);
system.debug('filters are:'+filters);
system.debug('obj is:'+obj);
for(string s :Orgs)
 {   OrgsG2.add(s);
     s=s+'G2';
     OrgsG2.add(s);
 }


        
for(integer i=0; i<Ownerid.size();i++)
 {
   Ownermatch+= '\'%' + Ownerid.get(i) +'%\'';
   if(i < (Ownerid.size()-1))
       Ownermatch+= ' and Team_Employee_Ids__c LIKE \'%' +Ownerid.get(i)+'%\'';
}

system.debug('Orgs List G2:'+OrgsG2);

if(obj != '' && fields != '')
{
  String query = '\'%' + q + '%\'';
  system.debug('filters***'+filters);
  string f = fields.replaceall('-id', '');
  if(fname == 'Account')
    if(Ownerid != null)
        qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id NOT IN :ids and Team_Employee_Ids__c LIKE '+Ownermatch;
    else
        qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id NOT IN :ids';
  if(fname == 'SAP Material')
    qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id NOT IN :ids and Sales_Org_Code__c IN :OrgsG2 and Division_Code__c IN :Divs';  
    
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
  
  system.debug('getSelectOptions query is:'+qstring);
  records = database.query(qstring);
}
 combogriddata data = new combogriddata(records);
 system.debug('size: ' + records.size());
  
    neXprice_tracker__c ntk = new neXprice_tracker__c();
    ntk.Operation__c = 'Add Material Popup SingleSearch Fields';
    ntk.SearchField__c = fname;
    ntk.SearchValue__c = q;
    ntk.SearchObject__c = obj;
    ntk.TabName__c = 'Price Maintenance';
    insert ntk;
    
 return data;
}

@RemoteAction
Public static combogriddata getSingleOptions2(String fname, string q, string obj, string fields, string filters, string orderby, string mylimit){ 
List<sobject> records = new list<SObject>();
system.debug('Field is:'+fname);
system.debug('q are:'+q);
system.debug('obj are:'+obj);
system.debug('fields are:'+fields);
system.debug('filters are:'+filters);
string qstring; 

if(obj != '' && fields != '')
{
  String query = '\'%' + q + '%\'';

  string f = fields.replaceall('-id', '');
 
  if(fname == 'RFQ Material')
    qstring = 'SELECT id, ' + f + ' from ' + obj + ' where ';  
    
    if(filters != null && filters != '')
    qstring += filters;
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
  
  system.debug('getSelectOptions2 query is:'+qstring);
  records = database.query(qstring);
}
 combogriddata data = new combogriddata(records);
 system.debug('size: ' + records.size());
 
    neXprice_tracker__c ntk = new neXprice_tracker__c();
    ntk.Operation__c = 'Add Material Popup SingleSearch Fields';
    ntk.SearchField__c = fname;
    ntk.SearchValue__c = q;
    ntk.SearchObject__c = obj;
    ntk.TabName__c = 'Price Maintenance';
    insert ntk;
    
 return data;
}

@RemoteAction
Public static combogriddata getSelectOptions(List<String> ids, string q, string obj, string fields, string filters, string orderby, string mylimit){ 
system.debug('ids:'+ids);
system.debug('q are:'+q);
system.debug('obj are:'+obj);
system.debug('fields are:'+fields);
system.debug('filters are:'+filters);
List<sobject> records = new list<SObject>();
if(obj != '' && fields != '')
{
  String query = '\'%' + q + '%\'';
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
 
    neXprice_tracker__c ntk = new neXprice_tracker__c();
    ntk.Operation__c = 'MultiSearch Fields';
    ntk.SearchField__c = obj;
    ntk.SearchValue__c = q;
    ntk.SearchObject__c = obj;
    ntk.TabName__c = 'Price Maintenance';
    insert ntk;
    
 return data;
}

@RemoteAction
Public static combogriddata getComboGridData(string q, string obj, string fields, string filters, string orderby, string mylimit, string aSel){ 
 
  List<String> prtids = new List<String>();
  Set<String> division = new Set<String>();
  if(aSel != null && aSel !='')
  prtids = aSel.split('-');
  system.debug('prtids is:'+prtids);
  List<Price_Request_Transaction__c> prtdiv = [Select id, Ship_To_Division__c from Price_Request_Transaction__c where id IN :prtids];
  for(Price_Request_Transaction__c prt :prtdiv)      
          division.add(prt.Ship_To_Division__c);
  
  system.debug('division::'+division);
  String slist = '';
  List<String> slist2 = new List<String>();

    for (String s: division) {
    slist2.add('\'' + s + '\''); }
      
    slist = String.join(slist2, ',');
  
    system.debug('slist ::'+slist );
    
   
List<sobject> records = new list<SObject>();
if(obj != '' && fields != '')
{
  String query = '\'%' + q + '%\'';
  system.debug('filters***'+filters);
  string f = fields.replaceall('-id', '');
  string qstring;
  qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id != null';
  if(obj == 'Nexeo_Competitor__c')
      qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id != null';
      
  if(slist != '')
    qstring += ' and competes_with__c INCLUDES (' + slist + ')';
  
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
  system.debug(qstring);
  records = database.query(qstring);
}
 combogriddata data = new combogriddata(records);
 
 return data;
}
@RemoteAction
public static Integer getRowCount(string aid){
  return [select count() from Account_material__c where Account__c = :aid or account__r.SAP_Sold_To_Account_Id__c = :aid or 
           account__r.parentid = :aid or account__r.SAP_Corporate_Account_Id__c = :aid limit 50000];
}
/*
@RemoteAction
public static List<Account_material__c> getRows2(string aid, string offset){
String q = 'select id , Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Material_Segment__c, Material_SubSegment__c, Material_Base_Code__c,';
         q += 'Account__r.SAP_Sold_To_Account__c, Account__r.Name, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c,';
         q += ' CSP__c, CSP_Effective_Date__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c ';
         q += ' from Account_material__c where ';
         q += ' Account__c = :aid or account__r.SAP_Sold_To_Account_Id__c = :aid or ';
         q += ' account__r.parentid = :aid or account__r.SAP_Corporate_Account_Id__c = :aid order by Account__r.Name, Account__r.SAP_City__c, SAP_Material__r.name ';
         nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
         q += ' limit ';
         
         List<Account_material__c> result= new list<Account_material__c>();

         integer off = integer.valueof(offset);
         integer low = Integer.valueof(Integer.valueof(off * ns.Salesforce_Record_Limit__c));
         integer  high = integer.valueof((off+1) * ns.Salesforce_Record_Limit__c);
         q += high;
         
         integer i=0;
         for(Account_material__c am:database.query(q))
         { 
           if(i<high && i>= low)
             result.add(am);
           if(i>= high)
             break;
           i = i+1;
         }

         return result;
        
              
}
*/
@RemoteAction
public static List<Account_material__c> getRows(string aid, string offset){
String q = 'select id , Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Competitive_UoM__c, Created_From_CPI__c, Material_Supplier__c, Material_Family__c, Material_Segment__c, Material_SubSegment__c, Material_Base_Code__c,';
         q += 'Account__r.SAP_Sold_To_Account__c, Account__r.Name, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c,';
         q += ' CSP__c, CSP_Effective_Date__c, CSP_Currency__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c,supplier__c,Material_Description__c,Container_for_new_material__c';
         q += ' from Account_material__c where ';
         q += ' Account__c = :aid or account__r.SAP_Sold_To_Account_Id__c = :aid or ';
         q += ' account__r.parentid = :aid or account__r.SAP_Corporate_Account_Id__c = :aid order by Account__r.Name, Account__r.SAP_City__c, SAP_Material__r.name ';
         nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();
         q += ' limit 40000';
         
         List<Account_material__c> toreturn = new list<Account_material__c>();
         List<Account_material__c> results = database.query(q);
         
         integer off = integer.valueof(offset);
         system.debug(Integer.valueof(off * ns.Salesforce_Record_Limit__c));
         system.debug((off+1) * ns.Salesforce_Record_Limit__c);
         integer low = Integer.valueof(Integer.valueof(off * ns.Salesforce_Record_Limit__c));
         integer high = results.size();
         if( high > (off+1) * ns.Salesforce_Record_Limit__c)
           high = integer.valueof((off+1) * ns.Salesforce_Record_Limit__c);
         for(integer i=low; i<high; i++)
           if(i<results.size())
             toreturn.add(results.get(i));
         system.debug(q);
         system.debug(results.size());
         return toreturn ;
        
              
}

@RemoteAction
public static Integer getDataCount(List<formData> data){
String q = 'select id from Account_material__c where (NOT Account__r.name LIKE \'%DO NOT%\') AND Account__r.Inactive_Account__c != true ';
                
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
qstring +=  ' and hidden__c = false and (created_from_cpi__c = null OR created_from_Cpi__r.deletion_indicator__c != \'X\')';
q += qstring ;
q += ' order by Account__r.name, SAP_Material__r.name limit 25000';
system.debug('getdatacount q:'+q);
return Database.query(q).size();
}
@RemoteAction 
Public static Account getAccount(string id){
List<Account> accts = [select ParentId, SAP_DivisionCode__c, SAP_Sales_Org__c, SAP_Partner_Functions__c, SAP_Corporate_Account_Id__c, SAP_Corporate_Account__c, SAP_Sold_To_Account_Id__c, SAP_Sold_To_Account__c, name, AccountNumber, id from Account where id = :id limit 1];
system.debug(accts);
if(accts.size() > 0)
  return accts.get(0);
else
  return null;
  
}

@RemoteAction
public static combogriddata getData(List<String> existingids, List<formData> data, string lmt, string off ){

if(off == '')
  off = '0';
nexprice_settings__c ns = nexprice_settings__c.getOrgDefaults();         
integer offset = integer.valueof(off);

string e = 'select id from Account_material__c where id != null ';
string t = 'select count() from Account_material__c where id != null ';
String q = 'select id , Material_Division__c, Account_Number__c, Account_City__c, UoMs__c, CSP_UoM__c, currencyisocode, Has_Unit_Options__c, Account_Name__c, has_open_prt__c, Has_CSP__c, Account_Sales_Org_Code__c, Inner_Table__c, Account_Division_Code__c, Account_Industry_Code__c, Account_Sold_To_Id__c,  Account_Sold_To__c, Account_Sold_To_Owner_Id__c, Account_Corp_Account_Id__c, Account_Corp_Account_Owner_Id__c, Account_Owner_Id__c, Account_Sales_Org__c, Account_Division__c, Account_Industry__c, Account_HQ_Sales_Office__c, Account_SAP_Sales_Group__c, Account_Sold_To_Seller__c,';
         q += 'Material_Container_Code__c,  CSP_Tier_UoM__c, Material_Base__c, material_group_1__c, Material_Product_Class__c, Competitive_UoM__c, Created_From_CPI__c,Customer_Material_Number__c,Plant_Code__c, Material_Supplier__c, Material_Family__c, Material_Segment__c, Material_SubSegment__c, Material_Base_Code__c,';
         q += 'Account__r.SAP_Sold_To_Account__c, Account__r.Name, Account__c, PH4__c, PH5__c, PH6__c, PH7__c, SAP_Material__c, iDisplayindex__c, Account_Owner_Name__c, Material_Name__c, Avg_Order__c,  Avg_Order_Qty__c, Avg_Order_Qty_Uom__c, Estimated_Order_Qty__c, Estimated_Order_Qty_uom__c, Estimated_Order_Quantity__c,';
         q += ' CSP__c, CSP_Effective_Date__c, CSP_Currency__c, Days_Since_Last_SAP_Data_Refresh__c, SAP_Data_Refreshed__c, TPI__c,  CSP_Effective_Date_Text__c, CSP_Tier__c, CSP_Price__c,   Target__c,  Target_Price__c, Target_Tier__c, Drum_Deposit__c, Price_Protection__c, Prospect_Material__c ';
         q +=' from Account_material__c where (NOT Id IN :existingids) and (NOT Account__r.name LIKE \'%DO NOT%\') AND Account__r.Inactive_Account__c != true  and hidden__c = false and (created_from_cpi__c = null OR created_from_Cpi__r.deletion_indicator__c != \'X\')';
         
List<neXprice_tracker__c> ntrack = new List<neXprice_tracker__c>();
Map<String, List<string>> wheres = new Map<String, List<String>>();
system.debug('data is:'+data);
for(formData fd:data){
  if(wheres.containskey(fd.name))
    wheres.get(fd.name).add(fd.value);
  else{
    wheres.put(fd.name, new List<String>{fd.value});
    neXprice_tracker__c ntk = new neXprice_tracker__c();
    ntk.Operation__c = 'Start Search';
    ntk.SearchField__c = fd.name;
    ntk.SearchValue__c = fd.value;
    ntk.TabName__c = 'Price Maintenance';
    ntrack.add(ntk);}
}
insert ntrack;
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
  //if(s != 'Team_Employee_Ids__c')
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

e += qstring;
q += qstring;
t += qstring;
system.debug(e);

e += ' order by Account__r.name, SAP_Material__r.name limit ' + Integer.valueof(offset);
q += ' order by Account__r.name, SAP_Material__r.name limit ' + Integer.valueof(ns.Salesforce_Record_Limit__c);
t += 'limit 25000';
system.debug('getdata query is:'+q);
List<Account_material__c> exclude = new List<Account_material__c>();
//if(offset > 0)
//  exclude = database.query(e);

combogriddata cdata = new combogriddata(database.query(q));
cdata.total = database.countquery(t);

return cdata;

}

/*@RemoteAction
public static List<Material_popup__c> getsuppliers(){
    
    List<Material_popup__c> mps = Material_popup__c.getall().values();  
    System.debug('mps !!!'+mps);
    return mps;
}*/
@RemoteAction
public static List<Nexeo_Competitor__c> getsuppliers(){
    System.debug('inside getsuppliers');
    List<Nexeo_Competitor__c> ncc = [Select Id, Name, Nexprice_flag__c from Nexeo_Competitor__c where Nexprice_flag__c = true];  
    System.debug('ncc!!!'+ncc);
    return ncc;
}

@RemoteAction
public static List<Price_Support_Junction__c> getpsrsuppliers(String amIds){
    List<String> am = new List<String>();
    if(amIds != null && amIds != '')
       am = amIds.split('-');
    System.debug('inside getpsrsuppliers:'+amIds);
    List<Price_Support_Junction__c> psrsupp = [Select Id, Name, Supplier_Name__c, SAP_Price_Support__r.Supplier_Name__c, SAP_Price_Support__r.Supplier_Number__c from Price_Support_Junction__c where Nexprice_CPI__c IN :am];  
    System.debug('psrSupplier size!!!'+psrsupp.size());
    
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
Public static Boolean getPermission(){
List<PermissionSetAssignment> psa = [Select Id, AssigneeId FROM PermissionSetAssignment where AssigneeId = :UserInfo.getUserId() and PermissionSet.Name LIKE '%Approver%'];
    if(psa.size() > 0)
        return true;
    else 
        return false;
}

}