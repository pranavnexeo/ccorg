public class OpportunityArchway {

private string id;
public string validformat{get; set;}
public string invalidformat{get; set;}
public boolean firstload{get; set;}
public boolean displaycontactpopup{get; set;}
public string selectedcontact{get; set;}
public list<selectoption> contacts{get; set;}
public Contact contact{get; set;}               
public Opportunity opp{get; set;}
public string salesorder{get; set;}

public boolean makerequired{get; set;}
public string subtitle{get ;set;}
public boolean rendertitle{get; set;}
public Account account{get; set;}

public boolean isreturn{get; set;}

public string returl{get; set;}
private string originaltype{get; set;}
Public boolean isApprover{get; set;}
Public boolean isSubmitted{get; set;}
public boolean isCDC{get; set;}

public boolean displayrequestmoreinfoerror{get; set;}
public boolean displayactionstaken{get; set;}
public string retUrlold{get; set;}



    public OpportunityArchway(ApexPages.StandardController controller) {
    makerequired=true;
    
    opp = new Opportunity();
    
    Account  = new Account();
        
        firstload = true; 
         
        
        
        displaycontactpopup = false;
        displayactionstaken = false;
        rendertitle = false;
        validformat = '';
        invalidformat = 'border-size:2px; border-color:red;border-style:solid;';
        returlold = apexpages.currentpage().getparameters().get('returl');
        if(returlold!=null)
            retUrl=returlold;
        System.debug('returl'+returl );
        isreturn = apexpages.currentpage().getparameters().get('r') == '1';
        system.debug('isreturn: ' + isreturn);
        isCDC = apexpages.currentpage().getparameters().get('c') == '1';
        
        contacts = new list<selectoption>();
        contacts.add(new selectoption('', '--None--'));
        contacts.add(new selectoption('New', '--Create New Contact--' ));
        selectedcontact = '';
    
        id = apexpages.currentpage().getparameters().get('id');
        
        selectedcontact = opp.Contact__c; 
        if(opp.contact__c != null)
        Contact = [select id, firstname, lastname, phone, fax, email, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry from Contact where id = :selectedcontact];       
        else
        Contact = new Contact();
        
        if(opp.Accountid != null){        
        account = [select id, ownerid, owner.managerid, recordtypeid, name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c, SAP_Division_Desc__c, SAP_Sales_Group_Desc__c from Account where id = :opp.Accountid limit 1];             
        contact.accountid = opp.Accountid;
        
         List<Contact> contactlist = [select id, firstname, lastname, phone, email,fax from Contact where accountid = :opp.Accountid order by lastname limit 1000];
        
        for(Contact c:contactlist){
           contacts.add(new selectoption(c.id, c.lastname + ', ' + c.firstname ));
        }
        }         
        
 }//Controller 
 
 public void toggledisplayactionstaken(){
     String yesno = ApexPages.currentpage().getparameters().get('yesno');
     displayactionstaken = (yesno == 'Yes');
     system.debug('test' + yesno); 
   }
   
   public void accountchanged(){
   system.debug('Accout changed');
     if(opp.Accountid != null){
       account = [select id, ownerid, recordtypeid, name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c, SAP_Division_Desc__c, SAP_Sales_Group_Desc__c from Account where id = :opp.Accountid limit 1];             
       contact.accountid = opp.Accountid;
       List<Contact> contactlist = [select id, firstname, lastname, phone, email,fax from Contact where accountid = :opp.Accountid order by lastname limit 1000];       
       for(Contact c:contactlist){
          contacts.add(new selectoption(c.id, c.lastname + ', ' + c.firstname ));
       }system.debug('Accout changed@@ ' +contacts);
     }   
   }    
   
   public void refreshcontact(){
      if(selectedcontact == 'New')
      { 
         showcontactpopup();
      }
      else
      {
         hidecontactpopup();
      }
   }  
   
   public void showcontactpopup(){
   
      displaycontactpopup = true;
      if(selectedcontact != 'New')
       {
      
         Contact = [select id, accountid, Firstname, LastName, Name, Email, Fax, Phone, mobilephone, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry  from Contact where id = :selectedcontact];
      }
      else
      {
         contact = new contact();
         contact.accountid = opp.Accountid;
      }
         
   }
   
   
   public pagereference hidecontactpopup(){displaycontactpopup = false; return null;}
   
   public pagereference createcontact(){
     
      upsert contact;
      displaycontactpopup = false;
      opp.Contact__c = contact.id;
      if(selectedcontact == 'New'){
      Contacts.add(New selectoption(contact.id, Contact.LastName + ', ' + contact.Firstname));}
      selectedcontact = contact.id;
      
      return null;
   }
   
   public boolean getiscontactvalid(){
   
      if(selectedContact != '' && selectedContact != null){
        Contact = [select id, firstname, lastname, phone, fax, email, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry from Contact where id = :selectedcontact];
        opp.Contact__c = selectedContact;
      }
      if(selectedcontact == '' || selectedcontact == null || Contact.id == null || opp.Contact__c == null){
         return false;}
      else{
         return true;}  
   }
   
  public Opportunity getOpportunity(String oid){ 
  Opportunity ReturnOpp = [select id, Accountid, 
  Account.Name, 
  account.SAP_City__c,
  Account.SAP_Division_Desc__c,
  Account.SAP_Sales_District_Desc__c,
  Account.SAP_Sales_Group_Desc__c , 
  Account.SAP_Sales_Office_Desc__c,
  account.SAP_State__c,
  Account.SAP_Zip_Code__c,
  Account.Account_Search_Phrase__c,
  Account.Type,
  Annual_Usage__c,
  Ashland_Supplier__c,
  CloseDate,
  Contact__c, 
  Contact__r.Name, 
  Contact__r.buying_role__c,
  Contact__r.Phone,
  Contact__r.MobilePhone,
  Contact__r.Email,
  Contact__r.title,
  CurrencyIsoCode,
  ExpectedRevenue,
  Market__c,
  Name,
  Opportunity_Owners_Business_Role__c,
  Opportunity_Search_Phrase__c,
  Order_Shipment_Frequency__c,
  Owner.Business_Role__c,
  Owner.Manager.Name,
  Owner.ManagerId,
  OwnerId,
  Price_Unit_of_Measure__c,
  Pricing_Approval_Status__c,
  RecordTypeId,
  Requested_Price__c,
  SAP_Material__c, 
  SAP_Material__r.Material_Group2_Desc__c,
  SAP_Material_Product_Supplier_PH4__c,
  SAP_material__r.material_base_code__c,
  SAP_material__r.material_base_code_desc__c,
  StageName, 
  TAG_Approval__c,
  TAG_Date__c,
  TAG_Opportunity__c,
  Target_Price__c,
  Transaction_Approved_price__c,
  Type,
  Deal_Type__c,
  Requested_Supplier_PL__c,
  Nexeo_Primary_Competitor_PL__c,
  base_code__c,
  base_code_Desc__c,
  NextStep,
  Nexeo_value_add__c,
  Nexeo_Competative_Position__c,
  Application__c,
  Award_Start_Date__c,
  Award_end_Date__c,
  Buying_role__c,
  bid_type__c,
  Ashland_Tech_Rep_Assistance__c,
  description,
  Won_Lost_Comments__c,
  Pricing_comments__c,
  Competitor_comments__c,
  lastmodifiedbyid,
  lastmodifiedby.name,
  lastmodifieddate,
  CreatedById,
  createdby.name,
  Createddate,
  Probability,
  ADE_Technical_Representative__c,
  Application_Development_Required__c,
  Corporate_Bid__c,
  Medical_CAM__c,
  Auto_CAM__c,
  Plastics_CAM__c,
  Related_HQ_Account__c,
  search_term__c,
  RecordType.Name,
  Nexeo_Quote__c,
  Technical_Representative__c,
  Expected_Annual_Revenue__c,
  OEM_Competitor__c,
  LeadSource,
  T_Business_Type__c,
  Business_solutions_Supported__c,
  Customer_Requested_Supplier__c,
  Material_of_Interest__c,
  CampaignId,
  Solution_Comments__c,
  Invalid_Duplicate__c,
  Last_Modified_By__c,
  Last_Modified_Date_Time__c,
  First_Order_date__c,
  Opportunity_Revenue__c,
  Amount,
  Expiration_Date__c,
  Top_Five_Opportunity__c,
  Internal_Opportunity_Source__c,
  Target__c,
  Target_Date__c  
  from Opportunity where id = :oid limit 1];
  return returnOpp;
  
  }
 }//end