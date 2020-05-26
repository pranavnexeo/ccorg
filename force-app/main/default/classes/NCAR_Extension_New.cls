/***********************************************************************************************************************
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        18/01/2012
*    Author:             Matthew Rumschlag
*    Last Modified:      03/08/2016
*   Last Modified By:    Sneha Likhar
*   **********************************************************************************************************************/

public class NCAR_Extension_New {

private string id;
public string validformat{get; set;}
public string invalidformat{get; set;}
public boolean firstload{get; set;}
public boolean displaycontactpopup{get; set;}
public string selectedcontact{get; set;}
public list<selectoption> contacts{get; set;}
public Contact contact{get; set;}               
public NCAR_Cases__c mycase{get; set;}
public string salesorder{get; set;}
public list<wrapper> orders{Get; set;}
public list<NCAR_Line_Item__c> lines{get; set;}
public list<wrapper> selectedorders{get; set;}
public string subtitle{get ;set;}
public boolean rendertitle{get; set;}
public Account account{get; set;}
public String comments{get; set;}
public boolean isreturn{get; set;}
public Nested_Dependancy ND{get ;set;}
public string returl{get; set;}
private string originaltype{get; set;}
Public boolean isApprover{get; set;}
Public boolean isSubmitted{get; set;}
public boolean isCDC{get; set;}
public boolean csserror{Get; set;}
public boolean displayrequestmoreinfoerror{get; set;}
public boolean displayactionstaken{get; set;}
public string retUrlold{get; set;}
public String CSS{ get; set; }
public List<SelectOption> CSSName{ get; set;} 

    public NCAR_Extension_New(ApexPages.StandardController controller) {
    CSSName= new list<SelectOption>();
    CSS='';
    List<NCAR_CSS__c> CSSlist= NCAR_CSS__c.getall().values();
    CSSName.add(new selectoption('','--None--'));
    
    List<String> css_list = new list<string>();
    for(NCAR_CSS__c c:CSSlist)
      css_list.add(c.name);
    
    css_list.sort();
    for(string c:css_list)
        CSSName.add(new selectoption(c,c));
        
        csserror = false;
        mycase = new NCAR_Cases__c();
        mycase.acknowledgement_format__c = null;
       
        orders = new list<wrapper>();  
        selectedorders = new list<wrapper>(); 
        
        lines = new list<NCAR_Line_Item__c>();        
        Account  = new Account();
        
        firstload = true; 
         
        if(apexpages.currentpage().getparameters().containskey('aid'))
            mycase.Account__c = apexpages.currentpage().getparameters().get('aid');
        
        if(apexpages.currentpage().getparameters().containskey('cid')){
            string c = apexpages.currentpage().getparameters().get('cid');
            mycase.Account__c = [select id, accountid, Firstname, LastName, Name, Email, Fax, Phone, mobilephone, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry from Contact where id = :c limit 1].accountid;
        }

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
        
        Map<String, Schema.RecordTypeInfo> RTMap = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
                  
        contacts = new list<selectoption>();
        contacts.add(new selectoption('', '--None--'));
        contacts.add(new selectoption('New', '--Create New Contact--' ));
        selectedcontact = '';
    
        id = apexpages.currentpage().getparameters().get('id');
     
        if(id != null){ 
        rendertitle = true;
        
        mycase = getCase(id);
        if(mycase.customer_servicesupervisor__c != null)
          css = mycase.customer_servicesupervisor__c;
        mycase.Send_Customer_Acknowledgement__c = true;
        OriginalType = mycase.Type__c;
        displayactionstaken = (mycase.Formal_Corrective_Action_Response_Req1__c == 'Yes');

        if(mycase.Draft_NCAR_Comments__c != null){ comments = mycase.Draft_NCAR_Comments__c; }
        
        lines = [select id, 
        NCAR_Cases__c, 
        Open_Orders__c,
        open_orders__r.sales_order_Number__c, 
        open_orders__r.created_Date__c, 
        open_orders__r.delivery_date__c, 
        open_orders__r.material__c,
        open_orders__r.Line_Item_Number__c,
        open_orders__r.Ordered_Qty_in_LB__c,
        Open_Orders__r.Plant_Desc__c,
        open_orders__r.plant__r.plant_code__c,
        open_orders__r.plant__c, 
        open_orders__r.Billed_Qty_in_LB__c,
        credit_Number__c,
        debit_Number__c,
        Category__c,
        Courtesy_Return__c,
        Import_Export__c,
        Material__c,
        Directions_for_Plant__c,
        Restocking_Fee__c,
        Returned_Quantity__c,
        Return_Freight__c,
        Return_Qty_UoM__c,
        Ship_from_Plant__c,
        Shipped_Qty_in_LB__c,
        Subcategory__c,
        SubCategory_Details__c,
        SAP_Return_Number__c,
        Actual_Return_Qty__c,
        Actual_Returned_Qty_UoM_c__c,
        Invoice_Unit__c,
        Invoiced_Price_Per_Unit__c,
        Corrected_Price_Per_Unit__c,
        Corrected_Unit__c     
        from NCAR_Line_Item__c where NCAR_Cases__c = :mycase.id];
  
        for(NCAR_Line_Item__c l:lines)
           selectedorders.add(new wrapper(l));
        
        selectedcontact = mycase.Contact__c; 
        if(mycase.contact__C != null)
        Contact = [select id, firstname, lastname, phone, fax, email, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry from Contact where id = :selectedcontact];       
        else
        Contact = new Contact();
        isapprover = Approval_Functions.isapprover(userinfo.getuserid(), mycase.id);
        issubmitted = Approval_Functions.issubmitted(mycase.id);
        displayrequestmoreinfoerror =(!isapprover && issubmitted);
              
        isreturn = (mycase.recordtypeid == RTMap.get('Nexeo Return').getrecordtypeid());
        iscdc = (mycase.recordtypeid == RTMAP.get('Nexeo Credit Debit Claim').getrecordtypeid());
       
        if(isreturn)
        {
          subtitle = 'Return Case ' + mycase.Name; 
          ND = new Nested_Dependancy('Revised_Category__c', 'Revised_Subcategory__c', 'Revised_Subcategory_details__c', 'Rev_Subcategory_Final_Details__c', 'Nexeo Return', 'Case');
        }
        else if(iscdc)
        { 
          subtitle = 'Credit Debit Claim Case ' + mycase.Name;      
          ND = new Nested_Dependancy('Revised_Category__c', 'Revised_Subcategory__c', 'Revised_Subcategory_details__c', 'Rev_Subcategory_Final_Details__c', 'Nexeo Credit Debit Claim', 'Case');
        }
        else
        { 
          subtitle = 'Standard Incident Case ' + mycase.Name; 
          ND = new Nested_Dependancy('Revised_Category__c', 'Revised_Subcategory__c', 'Revised_Subcategory_details__c', 'Rev_Subcategory_Final_Details__c', 'Nexeo Standard Incident', 'Case');
        }
        
        Field1init();
        Field2Changed();
        if(mycase.revised_Category__C != null){ revField1init(); }
        if(mycase.revised_Subcategory__c != null) {revField2Changed(); }
        if(mycase.revised_Subcategory_details__c != null) {revField3Changed(); }
        }
        else{
        isapprover = false;
        issubmitted = false;
        displayrequestmoreinfoerror = false;
        
        if(isreturn){
        myCase.recordtypeid = RTMap.get('Nexeo Return').getrecordtypeid();
        subtitle = 'New Return Case';
        }
        else if(isCDC){
        myCase.recordtypeid = RTMap.get('Nexeo Credit Debit Claim').getrecordtypeid();
        subtitle = 'New Credit Debit Claim';
        }
        else{ 
        myCase.recordtypeid = RTMap.get('Nexeo Standard Incident').getrecordtypeid();
        subtitle = 'New Standard Incident';
        }
        
        ND = new Nested_Dependancy('Category__c', 'Subcategory__c', 'subcategory_details__c', 'Nexeo Standard Incident', 'Case');
        system.debug('@@@@@@before update240'+mycase.Status__c);
        mycase.Status__c = 'New';
        system.debug('@@@@@@after update242'+mycase.Status__c);
        mycase.priority__c = 'Medium'; 
        Contact = new contact();    
        }
 
        if(mycase.Account__c != null){        
        account = [select id, ownerid, owner.managerid, recordtypeid, name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c, SAP_Division_Desc__c, SAP_Sales_Group_Desc__c from Account where id = :mycase.Account__c limit 1];             
        contact.accountid = mycase.Account__c;
        mycase.seller__C = account.ownerid;
        mycase.district_manager__c = account.owner.managerid;
        List<Contact> contactlist = [select id, firstname, lastname, phone, email,fax from Contact where accountid = :mycase.Account__c order by lastname limit 1000];
        
        for(Contact c:contactlist){
           contacts.add(new selectoption(c.id, c.lastname + ', ' + c.firstname ));
        }
        }         
}

   public void toggledisplayactionstaken(){
     String yesno = ApexPages.currentpage().getparameters().get('yesno');
     displayactionstaken = (yesno == 'Yes');
     system.debug('test' + yesno); 
   }
     
   public void accountchanged(){
     if(mycase.Account__c != null){
       account = [select id, ownerid, recordtypeid, name, full_Address__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_City__c, SAP_state__c, SAP_ZIP_Code__c, SAP_Country__c, SAP_Division_Desc__c, SAP_Sales_Group_Desc__c from Account where id = :mycase.Account__c limit 1];             
       contact.accountid = mycase.Account__c;
       mycase.seller__c = account.ownerid;
       List<Contact> contactlist = [select id, firstname, lastname, phone, email,fax from Contact where accountid = :mycase.Account__c order by lastname limit 1000];       
       for(Contact c:contactlist){
          contacts.add(new selectoption(c.id, c.lastname + ', ' + c.firstname ));
       }
     }   
   }
  
   private boolean gettypechanged()
   {
     system.debug('Original: ' + OriginalType + ' New Type: ' + mycase.type__c);
     return (OriginalType != '' && OriginalType != null && OriginalType != mycase.Type__c);
   }
   
   public void refreshcontact(){
   
      if(selectedcontact != 'New' && selectedcontact != '' && selectedcontact != null)
      { 
         Contact = [select id, accountid, Firstname, LastName, Name, Email, Fax, Phone, mobilephone, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry  from Contact where id = :selectedcontact];
         mycase.Contact__c = contact.id;
      }
      else if(selectedcontact == 'New')
      { 
         showcontactpopup();
      }
      else
      {
         Contact = new contact();
      }
   }
   
   public void showcontactpopup(){
   
      displaycontactpopup = true;
      system.debug('SelectedContact: ' + selectedcontact);
      if(selectedcontact != 'New')
      { 
         Contact = [select id, accountid, Firstname, LastName, Name, Email, Fax, Phone, mobilephone, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry  from Contact where id = :selectedcontact];
      }
      else
      {
         contact = new contact();
         contact.accountid = mycase.Account__c;
      }
   }
   public pagereference hidecontactpopup(){displaycontactpopup = false; return null;}
 
   public pagereference searchorders(){
   
   orders.clear();
   
   if(salesorder != null)
   {
   
      for(integer i=salesorder.length(); i<10; i++)
      {
        salesorder = '0' + salesorder;
      }
   
      List<Open_Orders__c> lstord = new list<Open_Orders__c>();     
      if(isreturn){
         string pc = [select id, site from Account where id = :mycase.nexeo_plant__c limit 1].site;
         
         Set<String> pcs = new Set<string>();  
           
         for(string p:pc.split(',')){ 
            pcs.add(p.substring(1).trim()); 
            pcs.add(p.substring(1).trim()+ 'G2');          
         }
         system.debug('pcs: ' + pcs);
         system.debug('Accountid: ' + mycase.account__c);
         system.debug('sales order: ' + salesorder.trim());
         
         
         lstord = [select id, Ordered_Qty_in_LB__c, Billed_Qty_in_LB__c, sales_Order_Number__c, material__c, created_date__c, delivery_date__c, Plant_Desc__c, Line_Item_Number__c, Plant__r.Plant_Code__c from Open_Orders__C where shipto__c =  :mycase.account__c and sales_order_Number__c = :salesorder.trim() and plant__r.plant_code__c IN :pcs  order by Agreed_Ship_Date2__c DESC limit 1000];
      }
      else
      {
         lstord = [select id, Ordered_Qty_in_LB__c, Billed_Qty_in_LB__c, sales_Order_Number__c, material__c, created_date__c, delivery_date__c, Plant_Desc__c, Line_Item_Number__c, plant__r.plant_code__c from Open_Orders__C where shipto__c =  :mycase.Account__c and sales_order_Number__c = :salesorder.trim() order by Agreed_Ship_Date2__c DESC limit 1000];
      }
  
      for(Open_Orders__c o:lstord){
        orders.add(new wrapper(o));
      }  
   }
   return null;
   }
   
   public pagereference addorders(){
   
     for(wrapper w:orders){
       if(w.selected == true){
       NCAR_Line_Item__c cl = new NCAR_Line_Item__c();
       cl.Open_Orders__c= w.order.id;
       cl.Open_Orders__r= w.order;
       system.debug('Line: ' + cl);
       lines.add(cl);
       selectedorders.add(new wrapper(cl));
       w.selected = false;
       }
     }
     
      for(NCAR_Line_Item__c cl:lines){
           system.debug('Case Line Item: ' + cl);
      }  
   
      return null;
   }
   
   public pagereference removelines(){
      
      for(integer i = 0; i < selectedorders.size(); i++){
         if(selectedorders.get(i).selected == true){
            NCAR_Line_Item__c so = selectedorders.remove(i).line;
            NCAR_Line_Item__c c = lines.remove(i);          
            if(c.id != null && so.id == c.id){ delete c; } 
            system.debug(so.id + ' == ' + c.id);          
         }
       }
 
       return null;
   }
   
   public pagereference createcontact(){
     
      upsert contact;
      displaycontactpopup = false;
      mycase.Contact__c = contact.id;
      if(selectedcontact == 'New'){
      Contacts.add(New selectoption(contact.id, Contact.LastName + ', ' + contact.Firstname));}
      selectedcontact = contact.id;
      
      return null;
   }
   
   public boolean getiscontactvalid(){
   
      if(selectedContact != '' && selectedContact != null){
        Contact = [select id, firstname, lastname, phone, fax, email, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry from Contact where id = :selectedcontact];
        mycase.Contact__c = selectedContact;
      }
      if(selectedcontact == '' || selectedcontact == null || Contact.id == null || mycase.Contact__c == null){
         return false;}
      else{
         return true;}  
   }
  
   private pagereference createcase(){
   
      //Contact = [select id, firstname, lastname, phone, fax, email, mailingstreet, mailingcity, mailingstate, mailingpostalcode, mailingcountry from Contact where id = :selectedcontact];       
      firstload = false;
      boolean isvalid = true;
      if(getiscontactvalid() == false ){
        ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Contact Required'));
        isvalid = false;
      }
   
      if(mycase.category__C == null ){
        ND.rendererror1 = true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Tier 1 Required.'));
        isvalid = false;
      }
      if(mycase.subcategory__c == null ){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Tier 2 Required.'));
        ND.rendererror2 = true;
        isvalid = false;
      }
      if(mycase.subcategory_details__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Tier 3 Required.'));
        ND.rendererror3 = true;
        isvalid = false;
      }
      if(mycase.revised_category__C == null && !getdisplaynewlayout()){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Revised Tier 1 Required.'));
        ND.rendererror1 = true;
        isvalid = false;
      }
      if(mycase.revised_subcategory__c == null && !getdisplaynewlayout()){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Revised Tier 2 Required.'));
        ND.rendererror2 = true;
        isvalid = false;
      }
      if(mycase.revised_subcategory_details__c == null && !getdisplaynewlayout()){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Revised Tier 3 Required.'));
        ND.rendererror3 = true;
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.response_format__c == 'Email' && contact.email == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have an Email'));
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.response_format__c == 'Phone' && contact.phone == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have a Phone Number'));
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.response_required_by__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Response Required by Date requires a value.'));
        isvalid = false; 
      }
      if(mycase.description__C == null || mycase.description__c == ''){      
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Description is Required.'));
        isvalid = false;
      }

      /*if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.Problem_Statement__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Problem Statement requires a value.'));
        isvalid = false; 
      }*/
      
      if(getdisplayapproverlayout() == true && !iscdc && (mycase.actions_taken__c == '' || mycase.actions_taken__c == null)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Actions Taken is required.'));
        isvalid = false;
      } 
      /*   
      if(getdisplayapproverlayout() == true && !iscdc && (mycase.Effectiveness_Follow_up__c == '' || mycase.Effectiveness_Follow_up__c == null)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Effectiveness Follow-up is required.'));
        isvalid = false;
      } 
      */ 
      if(getdisplayapproverlayout() == true && !iscdc && (mycase.Problem_Statement__c == '' || mycase.Problem_Statement__c == null)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Problem Statement is required.'));
        isvalid = false;
      }
      if(getdisplayapproverlayout() == true && !iscdc && (mycase.Immediate_Action__c == '' || mycase.Immediate_Action__c == null)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Immediate Action is required.'));
        isvalid = false;
      }
      if(getdisplayapproverlayout() == true && !iscdc && (mycase.Root_Cause__c == '' || mycase.Root_Cause__c == null)){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Root Cause is required.'));
        isvalid = false;
      }
      
      if(css == '' || css == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Customer Service Supervisor is Required.'));
        csserror = true;
        isvalid = false; 
      }
      if((isreturn || iscdc) && lines.size() == 0){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'At least one Sales Order Required for Returns and Credit Debit Claims.'));
        isvalid = false; 
      }
      if(mycase.route_To__c == 'Plant' && lines.size() == 0){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'At least one Sales Order Required for Incidents involving a Plant.'));
        isvalid = false; 
      }
      if((mycase.subcategory_details__c == 'External Carrier' || mycase.revised_subcategory_details__c == 'External Carrier') && mycase.carrier__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Carrier Required'));
        isvalid = false;
      }
      if(mycase.case_to_clear_DZ__c == 'Yes' && mycase.DZ_Number__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'DZ Number Required when Case to Clear DZ'));
        isvalid = false;
      }
      if(mycase.case_to_clear_DZ__c == 'Yes' && mycase.DZ_Amount__c == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'DZ Amount Required when Case to Clear DZ'));
        isvalid = false;
      }
      /*
      if(mycase.Send_Customer_Acknowledgement__c == true && mycase.customer_response_required__c == false){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Customer Response Required is Required when Sending an Acknowledgement.'));
        isvalid = false; 
      }
      */
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.Acknowledgement_Format__c == 'Email' && contact.email == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have an Email'));
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.Acknowledgement_Format__c == 'Print/Mail' && contact.mailingstreet == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have a Mailing Street'));
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.Acknowledgement_Format__c == 'Print/Mail' && contact.mailingcity == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have a Mailing City'));
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.Acknowledgement_Format__c == 'Print/Mail' && contact.mailingstate == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have a Mailing State / Province'));
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.Acknowledgement_Format__c == 'Print/Mail' && contact.mailingpostalcode == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have a Mailing Postal Code'));
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.Acknowledgement_Format__c == 'Print/Mail' && contact.mailingcountry == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have a Mailing Country'));
        isvalid = false;
      }
      if(mycase.Formal_Corrective_Action_Response_Req1__c   == 'Yes' && mycase.Acknowledgement_Format__c == 'Fax' && contact.fax == null){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Contact must have a Fax Number'));
        isvalid = false;
      }
       
      system.debug('is valid: ' + isvalid);
      if(isvalid == true){
        csserror = false;
        if(selectedcontact == 'New'){
        system.debug('@@@@ inside 553');
           displaycontactpopup = true;
           return null; }
        else{
          system.debug('@@@@ inside 557');
          boolean newcase = false; 
          mycase.Contact__c = selectedcontact;
          
          list<User> usr = [Select Id from User where Name=:CSS limit 1];  
          if(usr.size() > 0 && usr != null)
             mycase.CSS_ID__c = usr[0].id;   
          mycase.Customer_ServiceSupervisor__c=CSS;
          
          if(mycase.id == null){ 
            system.debug('@@@@ inside 561');
            newcase = true;
            
            String k = 'NCAR:' + account.SAP_Sales_Group_Desc__c;
            List<User> u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
            if(u.size() > 0){
               mycase.employee__c = u.get(0).managerid;
            }
            List<Approval_Process_Email_Notification__c> APENs = [select id, key__c, user__c from Approval_Process_Email_Notification__c where key__c = :k limit 1];            
            if(Apens.size() > 0){
               mycase.employee__c = APENs.get(0).user__c;
            }  
            system.debug('@@@@@@@@@@beforeupdate575'+mycase.Status__c);   
            //mycase.Status__c = 'New';
            system.debug('@@@@@@@@@@afterupdate577'+mycase.Status__c);
           //Set to False to avoid sending Acknowledgment yet.
            mycase.Send_Customer_Acknowledgement__c = false;
            system.debug('before case insert @ line 576');
            /*if(lines!=null && lines.size()>0){
                for(NCAR_Line_Item__c cl:lines){
                    system.debug('@@@@@@'+cl.open_orders__r.plant__r.plant_code__c);
                    mycase.nexeo_plant_code__c = 'W' + cl.open_orders__r.plant__r.plant_code__c;
                    system.debug('Plant Code: ' + 'W' + cl.open_orders__r.plant__r.plant_code__c);
                    system.debug('Mycase.nexeo_plant_code__c: ' + mycase.nexeo_plant_code__c);
                    if(cl.id == null){
                        cl.NCAR_Cases__c = mycase.id;           
                    }
                }
                upsert lines;
            }*/
            for(NCAR_Line_Item__c cl:lines){
              mycase.nexeo_plant_code__c = 'W' + cl.open_orders__r.plant__r.plant_code__c;
          }
            insert mycase;                    
          }
          else{ 

          //Added by Annes for Making required field blank if customer response required is unchecked
          if(mycase.Formal_Corrective_Action_Response_Req1__c == 'No'){
           mycase.Response_Format__c='';
           mycase.Response_Required_By__c=null;
          }
          
          //Set to False to avoid sending Acknowledgment yet.
          mycase.Send_Customer_Acknowledgement__c = false;
          
          for(NCAR_Line_Item__c cl:lines){
              mycase.nexeo_plant_code__c = 'W' + cl.open_orders__r.plant__r.plant_code__c;
          }
          

          update mycase;

          } 
          
          
         if(lines!=null && lines.size()>0){
                for(NCAR_Line_Item__c cl:lines){
                    if(cl.id == null){
                        cl.NCAR_Cases__c = mycase.id;           
                    }
                }
                upsert lines;
            }

         //Set to back to True to send Acknowledgment with NCAR Line Items.
         mycase = getcase(mycase.id);
         mycase.Send_Customer_Acknowledgement__c = true;
         update mycase;


         if(newcase==true)
         {
         if(returl == null)
         {  
            return new pagereference('/apex/Make_PDF?id=' + mycase.id + '&PDF=NCAR_Acknoledgement_PDF&f=NCAR_ACKNOWLEDGEMENT' );
         }
         else
         {
            return new pagereference('/apex/Make_PDF?id=' + mycase.id + '&PDF=NCAR_Acknoledgement_PDF&f=NCAR_ACKNOWLEDGEMENT&returl=' + returl);
         }   
         }
         else
         {
         if(returl == null)
         {  
            return new pagereference('/' + mycase.id);
         }
         else
         {
            return new pagereference(returl);
         }     
         }
        }
      } else { return null; }        
   } 

   public pagereference cancel(){
    System.debug('returlcancel'+returl);
         if(returl == null){  
         return new pagereference('/' + mycase.id );
         }else{return new pagereference(returl);} 
   }
    
   public boolean getDisplayApproverLayout(){     
      return ( isapprover );
   }
   
   public boolean getDisplayReadOnlyLayout(){
      return (!getDisplaySubmitterLayout() && !getdisplaynewlayout() && !getdisplayapproverlayout()) ;
   }                 
   
   public boolean getDisplayDeliveryBlockRemovedButton(){
     return (mycase.status__c == 'Waiting on Delivery Block Release');
   }
   
   public pagereference DeliveryBlockRemoved(){
     mycase.status__c = 'Delivery Block Removed';
     update mycase;
     List<Task> tasks = [select id from task where subject like '%Delivery Block Release Required%' and isclosed = false and whatid = :mycase.id];
     for(Task t:tasks){
       t.status = 'Completed';
     }
       update tasks;
     return createcase(); 
   }
   
   public boolean getDisplaySubmitterLayout(){ 
     return (mycase.Status__c == 'Rejected' && mycase.reason_rejected__c == 'Tiers Dispute'); 
   }  
   
   public boolean getDisplayNewLayout(){
   system.debug('@@@@@@@@@@beforeupdate716'+mycase.Status__c);  
     return ((mycase.Status__c == 'New' || mycase.Status__c == 'Rejected') && !getdisplaysubmitterlayout());
   }
   
   public boolean getDisplayLevel1Approver(){
      if(!isreturn)
      {
      return (mycase.Status__c == 'Submitted to Approver' || mycase.Status__c == 'Submitted to CSS' || mycase.Status__c == 'Submitted to Quality');
      }
      else
      {
      return 
     (
      (mycase.Status__c == 'Submitted to Plant' && mycase.Type__c == 'Nexeo Paperwork Only Return' )||
      (mycase.Status__c == 'Submitted to Purchasing' && mycase.Type__c == 'Nexeo Physical Material Return') ||
      (mycase.Status__c == 'Submitted to Purchasing' && mycase.Type__c == 'Third Party Return' )
     );
      }
   }
   
   public boolean getDisplayLevel2Approver(){
     return 
    (
     (mycase.Status__c == 'Submitted for Evaluation') ||
     (mycase.Status__c == 'Waiting on Delivery Block Release' )||
     (mycase.status__c == 'Delivery Block Removed'  )
    );
   
   
   }
   
   public boolean getdisplayLevel3Approver(){
     return (mycase.Status__c == 'Approved by Purchasing' || mycase.Status__c == 'Approved by Plant');
   }
      
   public boolean getDisplayQOSApprover(){
     return (mycase.Status__c == 'Customer Response Required' || mycase.Status__c == 'Submitted to QOS');
   }
   
   public boolean getdisplayCSSApprover(){
     return (mycase.Status__c == 'Submitted to CSS' && isreturn);
   }
   
   public pagereference createsubmitIncident(){
     mycase.route_to__c = NCAR_Functions.determineRouteTo('Approver', mycase.category__c, mycase.subcategory__c, mycase.subcategory_details__c);
     system.debug('NCAR Route To: ' + NCAR_Functions.determineRouteTo('Approver', mycase.category__c, mycase.subcategory__c, mycase.subcategory_details__c));
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();      
     }
     else
     {
     system.debug('Route To: ' + mycase.route_to__c);
     if( p != null ){
      Map<String, Schema.RecordTypeInfo> RTMap1 = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
     if(mycase.RecordTypeId  == RTMap1.get('Nexeo DZ').getrecordtypeid() || mycase.RecordTypeId  == RTMap1.get('Nexeo Credit Debit Claim').getrecordtypeid())
     Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval');
     }
     }
     return P;
   }
   
   public pagereference createsubmitReturn(){
     system.debug('Status Check 1: ' + mycase.status__c);
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       system.debug('Status Check 2: ' + mycase.status__c);
       returntypechanged();
       system.debug('Status Check 3: ' + mycase.status__c);
     }
     else
     {
     system.debug('Status Check 4: ' + mycase.status__c);
     
     if( p != null ){
         Map<String, Schema.RecordTypeInfo> RTMap2 = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
         if(mycase.RecordTypeId  == RTMap2.get('Nexeo DZ').getrecordtypeid()|| mycase.RecordTypeId  == RTMap2.get('Nexeo Credit Debit Claim').getrecordtypeid())
         {  Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval');
            system.debug('Status Check 5: ' + mycase.status__c);
         }
     }
     system.debug('Status Check 6: ' + mycase.status__c);
     }
     system.debug('Status Check 7: ' + mycase.status__c);
     return p;
   }
   
   public pagereference createsubmitclaim(){   
        return createsubmitReturn();
   }  
   
   public pagereference savedraftIncident(){
      mycase.route_to__c = NCAR_Functions.determineRouteTo('Approver', mycase.category__c, mycase.subcategory__c, mycase.subcategory_details__c);
      system.debug('NCAR Route To: ' + NCAR_Functions.determineRouteTo('Approver', mycase.category__c, mycase.subcategory__c, mycase.subcategory_details__c)); 
      mycase.draft_NCAR_Comments__c = comments;
      MyCase.Saved_As_Draft__c = true;
      pagereference p = createcase();
      system.debug('Route To: ' + mycase.route_to__c);
      return p;
   }   
   
   public pagereference savedraftReturn(){
      mycase.draft_NCAR_Comments__c = comments;
      MyCase.Saved_As_Draft__c = true;         
      return createcase();
   }
   
   public pagereference savedraftClaim(){ 
      mycase.draft_NCAR_Comments__c = comments;  
      MyCase.Saved_As_Draft__c = true;      
      return createcase();
   }  
   
   public pagereference resubmitIncident(){
     
     if(!isreturn &&
        mycase.category__c == mycase.revised_category__c &&
        mycase.subcategory__c == mycase.revised_subcategory__c &&
        mycase.subcategory_details__c == mycase.revised_subcategory_details__c &&
        mycase.customer_Response_Required__c == false){
        mycase.Status__c = 'Submitter Agrees';
        mycase.route_to__c = '';
        MyCase.Saved_As_Draft__c = false;
        update mycase;
     }
     
     else if( !isreturn &&
        mycase.category__c == mycase.revised_category__c &&
        mycase.subcategory__c == mycase.revised_subcategory__c &&
        mycase.subcategory_details__c == mycase.revised_subcategory_details__c &&
        mycase.Formal_Corrective_Action_Response_Req1__c    == 'Yes'){
        mycase.Status__c = 'Customer Response Required';
        mycase.route_To__c = 'QOS';
        MyCase.Saved_As_Draft__c = false;
        update mycase;
     }
     
     else if(!isreturn){
        mycase.route_to__c = NCAR_Functions.determineRouteTo('Evaluator', mycase.category__c, mycase.subcategory__c, mycase.subcategory_details__c);
        MyCase.Saved_As_Draft__c = false;
        update mycase;
     }
     
     mycase.draft_NCAR_Comments__c = null;
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!= null)
     {
       Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval');
     }
     return p;  
   }
   
     public pagereference approversaveIncident(){
        pagereference returnvalue;
        if(mycase.category__c == mycase.revised_category__c &&
           mycase.subcategory__c == mycase.revised_subcategory__c &&
           mycase.subcategory_details__c == mycase.revised_subcategory_details__c){
           returnvalue = approverapproved();
        }
        else{
           returnvalue = approverrejected();
        }
        return returnvalue;
   } 
   
    public pagereference approverSaveReturn(){
      MyCase.Saved_As_Draft__c = false;
      pagereference p = createcase();
      if(gettypechanged() == true && p!= null)
      {
     
       returntypechanged();
      }
      else
      {
      if(p != null){
      if(mycase.css_Id__c != null){
      Task_Functions.createtaskandsendemails(mycase.css_id__c, 
                                            mycase.id, 
                                            'Delivery Block Release Required' , 
                                            'Link: ' + new pagereference(mycase.id).geturl(), 
                                            account); 
      }
   
         
         update mycase;
      if(mycase.Type__c == 'Nexeo Physical Material Return')
      {  
         mycase.draft_NCAR_Comments__c = ''; 
         if(mycase.Ship_To_Warehouse__c != null){
            mycase.Nexeo_Plant_Code__c = [select id, site from Account where id = :mycase.Ship_To_Warehouse__c limit 1].site;}
         system.debug('@@@@839'+mycase.Nexeo_Plant_Code__c);
         update mycase;
         
         Approval_Functions.ApproveReject(mycase.id, 'APPROVE', comments);
         if( Approval_Functions.issubmitted(mycase.id) == false){
         Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval');}
       }
      
      else
      {
         mycase.draft_NCAR_Comments__c = comments;
         mycase.Status__c = 'Waiting on Delivery Block Release';
         update mycase;
         
      }
     }
    }
    return p;  
   }
   
   public pagereference cancelandclose(){
    isapprover = Approval_Functions.isapprover(userinfo.getuserid(), mycase.id);
    issubmitted = Approval_Functions.issubmitted(mycase.id);
   
    if(mycase.id != null && isapprover)
    {
      if(issubmitted)
      { Approval_Functions.ApproveReject(mycase.id, 'REJECT', 'NCAR Cancelled\n\n' + comments);
        mycase.Reason_Rejected__c = 'Cancelled';
        update mycase;
        
      }
    }
    else if(mycase.id != null && !issubmitted){
      mycase.Reason_Rejected__c = 'Cancelled';
      mycase.Status__c = 'Rejected';
      update mycase;
      
     system.debug('Mycase.id: ' + mycase.id);
    }
    
    return new pagereference('/' + mycase.id);
   }  
   
   public void returntypechanged(){
   system.debug('inside 883');
     if(Approval_Functions.issubmitted(mycase.id) && Approval_Functions.isapprover(userinfo.getuserid(), mycase.id))
     {
     
     system.debug('inside 887');
        Approval_Functions.ApproveReject(mycase.id, 'REJECT', 'Return Type Changed'); 
     }
       system.debug('@@@@@@@@@@beforeupdate946'+mycase.Status__c);  
        mycase.Status__c = 'New';
        system.debug('@@@@@@@@@@afterupdate948'+mycase.Status__c);  
        update mycase;
        
    
    Map<String, Schema.RecordTypeInfo> RTMap3 = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    if(mycase.RecordTypeId  == RTMap3.get('Nexeo DZ').getrecordtypeid() || mycase.RecordTypeId  == RTMap3.get('Nexeo Credit Debit Claim').getrecordtypeid())
     Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval');
        Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval');
        
   }
   
   public pagereference ReturnProcessed(){ 
     mycase.draft_NCAR_Comments__c = null;
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p != null)
     {
     
     Approval_Functions.ApproveReject(mycase.id, 'APPROVE', comments);
     //Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval');
     
     }
     return p;
   }

   public pagereference CSSApprovedReturn(){   
      return approverapproved(); 
   }   

   private pagereference ApproverApproved(){

     mycase.draft_NCAR_Comments__c = null;
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!= null)
     {
       Approval_Functions.ApproveReject(mycase.id, 'APPROVE', comments);
       boolean issubmitted = Approval_Functions.issubmitted(mycase.id);
     
       if(mycase.Formal_Corrective_Action_Response_Req1__c  == 'Yes' && mycase.Status__c != 'Submitted to Quality' && !issubmitted){
          mycase.Status__c = 'Customer Response Required';
          mycase.route_to__c = 'QOS';
          p = createcase();
          Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval to QOS');
       }else{
           mycase.Status__c = checkNexeoStandardIncidentRecordType();
           If(mycase.Status__c == 'Submitted to Quality' && mycase.reason_rejected__c != '' && mycase.reason_rejected__c != null){
               mycase.reason_rejected__c = '';
           }
           p = createcase();
       }
     }
     return p;
   }
     
   private pagereference ApproverRejected(){
     mycase.draft_NCAR_Comments__c = null;
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!= null)
     {
      mycase.Reason_Rejected__c = 'Tiers Dispute';
      update mycase;
      
      Approval_Functions.ApproveReject(mycase.id, 'REJECT', 'Tiers Disputed.\n\n' + comments);
     }
     return p;
   }
     
   public pagereference Reject(){
     mycase.draft_NCAR_Comments__c = null;
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!= null)
     {
       Approval_Functions.ApproveReject(mycase.id, 'REJECT', comments);
     }
     return p;
   }
   
   public pagereference Approve(){
     mycase.draft_NCAR_Comments__c = null;
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!= null)
     {
       Approval_Functions.ApproveReject(mycase.id, 'APPROVE', comments);
     }
     return p;
   }
   
   public pagereference RequestMoreInfo(){
     
     pagereference p = new pagereference('/'+mycase.id);
     isapprover = Approval_Functions.isapprover(userinfo.getuserid(), mycase.id);
     issubmitted = Approval_Functions.issubmitted(mycase.id);
     system.debug('IsApprover? : ' + isapprover);
     system.debug('issubmitted? : ' + issubmitted);
     
     if(isapprover && issubmitted ){
     mycase.saved_as_draft__c = true;
     mycase.reason_rejected__c = 'More Information Required';
     mycase.revised_category__c = null;
     mycase.revised_subcategory__c = null;
     mycase.revised_subcategory_details__c = null;
     update mycase;
     
     Approval_Functions.ApproveReject(mycase.id, 'REJECT', 'More Information Required.\n\n' + comments);
     return p;
     }
     else if(!issubmitted){
     mycase.reason_rejected__c = 'More Information Required';
     mycase.Status__c = 'Rejected';
     mycase.revised_category__c = null;
     mycase.revised_subcategory__c = null;
     mycase.revised_subcategory_details__c = null;
     update mycase;
     
     return p;
     }
     else {
      return null;
     }
   }
   
   Public pagereference EvaluatorApprove(){
    // mycase.status = 'Approved by Evaluator';
    mycase.draft_NCAR_Comments__c = null;
     mycase.Reviewed_by_Evaluator__c = true;
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!= null)
     {
     Approval_Functions.ApproveReject(mycase.id, 'APPROVE', comments);
     if(mycase.Formal_Corrective_Action_Response_Req1__c    == 'Yes' && mycase.Status__c != 'Submitted to Quality'){
       mycase.Status__c = 'Customer Response Required';
       mycase.route_to__c = 'QOS';
       p = createcase();
       Approval_Functions.submitrecord(mycase.id, 'Submitting for Approval to QOS');
     }
     else {
         mycase.Status__c = checkNexeoStandardIncidentRecordType(); 
         If(mycase.Status__c == 'Submitted to Quality' && mycase.reason_rejected__c != '' && mycase.reason_rejected__c != null){
             mycase.reason_rejected__c = '';
         }
     }     
     }
     return p;
   }
     
   Public pagereference EvaluatorReject(){
     mycase.draft_NCAR_Comments__c = null;
     mycase.Reviewed_by_Evaluator__c = true;
     mycase.route_to__c = '';
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!= null)
     {
       Approval_Functions.ApproveReject(mycase.id, 'REJECT', comments);
     }
     return p;
   }
   
   public pagereference QOSapprove(){
     mycase.draft_NCAR_Comments__c = null;
     mycase.route_to__c = '';
     mycase.Status__c = checkNexeoStandardIncidentRecordType();
     If(mycase.Status__c == 'Submitted to Quality' && mycase.reason_rejected__c != '' && mycase.reason_rejected__c != null){
         mycase.reason_rejected__c = '';
     }
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!= null)
     {
       Approval_Functions.ApproveReject(mycase.id, 'Approve', comments);
     }
     return p;
   
   }
   
   public pagereference QOSreject(){
     mycase.draft_NCAR_Comments__c = null;
     mycase.route_to__c = '';
     mycase.Status__c = 'Rejected';
     mycase.reason_rejected__c = 'QOS';
     MyCase.Saved_As_Draft__c = false;
     pagereference p = createcase();
     if(gettypechanged() == true && p!= null)
     {
       returntypechanged();
     }
     if(gettypechanged() == false && p!=null)
     {
       Approval_Functions.ApproveReject(mycase.id, 'Reject', comments);
     }
     return p;
   }
   
   public void field1changed(){
        mycase.subcategory__c=null; 
        mycase.subcategory_details__c=null;  
     ND.field1Changed(mycase.category__c);
   }
  public void field1init(){
     ND.field1Changed(mycase.category__c);
   }
   
   public void field2changed(){
     ND.field2Changed(mycase.category__c, mycase.subcategory__c);
   }
   
   public void field3changed(){
     ND.field3Changed(mycase.category__c, mycase.subcategory__c, mycase.subcategory_details__c);
   }

   public void revfield1changed(){
     mycase.revised_subcategory__c = null;
     mycase.revised_subcategory_details__c = null;
     ND.field1Changed(mycase.revised_category__c);
   }
   public void revfield1init(){
     ND.field1Changed(mycase.revised_category__c);
   }
   
   public void revfield2changed(){
     ND.field2Changed(mycase.revised_category__c, mycase.revised_subcategory__c);
   }
   
   public void revfield3changed(){
     ND.field3Changed(mycase.revised_category__c, mycase.revised_subcategory__c, mycase.revised_subcategory_details__c);
   }
   public void revfield4changed(){
     ND.field4Changed(mycase.revised_category__c, mycase.revised_subcategory__c, mycase.revised_subcategory_details__c, mycase.Rev_Subcategory_Final_Details__c);
   }
   
   public static NCAR_Cases__c getCase(id id){
     return [select id, 
        Ownerid,
        recordtypeid,
        Name,
        Status__c,
        Description__c,
        Origin__C,
        subject__c,
        priority__c,
        Contact__c,
        Account__c,
        Customer_Response_Required__c,
        Formal_Corrective_Action_Response_Req1__c,
        Category__C,
        subcategory__c,
        Subcategory_Details__c,
        Type__c,
        SAP_Division_Desc__c,
        Account_Address__c,
        Revised_Category__c,
        Revised_SubCategory__c,
        Revised_Subcategory_Details__c,
        Directions_for_Plant__c,
        Final_Restocking_Fee__c,
        Final_Return_Freight_Fee__c,
        Material_Disposition_Instructions__c,
        Ship_To_Warehouse__c,
        Return_PO_Number__c,
        Restocking_Fee__c,
        Return_Freight__c,         
        Nexeo_Plant__c,
        Returned_Quantity__c,
        T_Unit_of_Measure__c,
        Courtesy_Return__c,
        SAP_Return_Number__c,
        Route_To__c,
        Rev_Subcategory_Final_Details__c,
        Import_Export__c,
        //Account.Ownerid,
        seller__c, 
        Response_Format__c,
        Response_Required_By__c,
        employee__c,
        Carrier__c,
        CAPA__c,
        SAP_Sales_Group_Desc__c,
        SAP_Reference_Number_s__c,
        DZ_Amount__c,
        Case_To_Clear_DZ__c,
        DZ_Number__c,
        Draft_NCAR_Comments__c,
        reason_rejected__c,
        Send_Customer_Acknowledgement__c,
        Acknowledgement_Format__c,
        Actions_Taken__c,
        Immediate_Action__c,
        Problem_Statement__c,
        Root_Cause__c,
        Memo_CSR__c,
        Memo_Plant__c,
        Memo_Purchasing__c,  
        Customer_Initiated1__c,
        css_id__c,
        Customer_ServiceSupervisor__c,
        Effectiveness_Follow_up__c
        
        From NCAR_Cases__c where id = :id limit 1];
   }
   
   
   public class wrapper{
   public boolean selected{get; set;}
   public Open_Orders__c order{get; set;}
   public NCAR_Line_Item__c Line{get; set;}
   
   public wrapper(Open_Orders__c oO){
     order = oO;
     selected = false;  
   }
   
   public wrapper(NCAR_Line_Item__c l){
     order = l.Open_Orders__r;
     selected = false;
     Line = l;
   }
   
 }
 
 //Added By Abhinay
 //Change Started
 private string checkNexeoStandardIncidentRecordType(){
     Map<String, Schema.RecordTypeInfo> RTMap3 = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
     ProcessInstanceStep processStep;
     string returnMessage = '';
     Boolean result = false;
     Try{
         processStep = [SELECT id FROM ProcessInstanceStep where ProcessInstance.TargetObjectId=:mycase.id and OriginalActor.Name='NCAR Quality Queue' AND StepStatus='Approved' LIMIT 1];
     }Catch(Exception e){}
     If(mycase != null && mycase.RecordTypeId == RTMap3.get('Nexeo Standard Incident').getrecordtypeid() && ((mycase.category__c == 'Product / Container Quality' &&
         mycase.subcategory__c == 'Product Contaminated' && mycase.subcategory_details__c != '' && mycase.subcategory_details__c != null) || (mycase.category__c == 'Documents (Not Including Invoices)' &&
         mycase.subcategory__c == 'Labels Incomplete/Not provided to Customer' && mycase.subcategory_details__c != '' && mycase.subcategory_details__c != ''))){
         returnMessage = 'Submitted to Quality';
         If(processStep != null && processStep.id != null){
             returnMessage = 'Closed';
         }
         
     }else{
         returnMessage = 'Closed';
     }
     return returnMessage;
 }
 //Change End
        
}