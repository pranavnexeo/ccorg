public class OpportunityExtensionArchway {
private Set<String> COMPOSITESRECTYPES = new set<String>{'Distribution Targets', 'Distribution Targets - TAG'};
private set<String> PLASTICRECTYPES = new set<String>{'Distribution Plastics', 'Distribution Plastics - TAG'};
private set<String> CHEMICALSRECTYPES = new set<String>{'Distribution Chemicals', 'Distribution Chemicals - TAG'};
private set<String> ESRECTYPES = new set<String>{'Distribution Environmental Services', 'Distribution Environmental Services - TAG'};
private String PRICINGCOORDINATORTEMPLATEID = '00XM0000000HwDN';

private Set<String> STAGE1 = new set<String>{'1. Prospect', '2. Validate', '3. Solve', '4. Present', '5. Closed - Won', '6. Closed - Lost', '7. Closed - Cancelled'};
private Set<String> STAGE2 = new set<String>{'2. Validate', '3. Solve', '4. Present', '5. Closed - Won', '6. Closed - Lost', '7. Closed - Cancelled'};
private Set<String> STAGE3 = new set<String>{'3. Solve', '4. Present', '5. Closed - Won', '6. Closed - Lost', '7. Closed - Cancelled'};
private Set<String> STAGE4 = new Set<String>{'4. Present', '5. Closed - Won', '6. Closed - Lost', '7. Closed - Cancelled'};
private Set<String> CLOSEDSTAGES = new Set<String>{'5. Closed - Won', '6. Closed - Lost', '7. Closed - Cancelled'};
private String STARTINGSTAGE = '1. Prospect';
private Set<String> OTHERREASONS = new Set<String>{'Service - ADEOther'};
private Set<String> QUOTEVALUE = new Set<String>{'0. Quote'};

private boolean IsStage1{get; set; }
private boolean IsStage2{get; set; }
private boolean IsStage3{get; set; }
private boolean IsStage4{get; set; }
private boolean isClosed{get; set; }
private boolean isquotevalue{get; set; }
List<SalesChurn__c> churnlist=new List<SalesChurn__c>();
public boolean getisstage1(){ return isstage1; }
public boolean getisstage2(){ return isstage2; }
public boolean getisstage3(){ return isstage3; }
public boolean getisstage4(){ return isstage4; }
public boolean getisclosed(){ return isclosed; }
public boolean getisquotevalue(){ return isquotevalue; }

public boolean ApprovedPriceRequired{get; set;}
public boolean TargetPriceRequired{get; set; }
public boolean RequestedPriceRequired{get; set;}

private Map<String, OpportunityStage> stageMap{get; set;}
private boolean getSUBMITPRICING(){ return false; }
private date originalTAGDate{get; set;}
private String recordtypename{get; set;}

Public Account Acc{get; set;}
Public Contact contact{get; set;}
Public Opportunity Opp{Get; set;}
Public String UserId{get; set;}
Private User User{get; set;}

Public String getOppId(){ If(Opp.Id == null) return ''; else return Opp.Id; }
Public String getAccountId(){ If(Opp.AccountId == null) return ''; else return Opp.AccountId; }
Public String getContactId(){ If(Opp.Contact__c == null || cid == '-1') return ''; else return Opp.Contact__c; }
Public String getAccountName(){ if(Opp.AccountId == null) return ''; else return Acc.Name; }
Public String getMaterialId(){if(Opp.SAP_Material__c == null) return ''; else return opp.SAP_Material__c; }
public String clonefrom{Get; set;}
Public Boolean isPilot{ get; set; }
Public String OppSubtitle{Get; set;}
public list<Delivery_Cities__c> DC{get; set;}

public integer dcsize{get;set;}
public boolean  notreqd{get; set;}
public boolean requiredAtQuote{get; set;}
public boolean requiredAtClose{get; set;}
public string returl{get; set;}
public string recordtypeid{get; set;}
public string aid{get; set;}
public string quote{get; set;}
public string cid{get; set;}
Public string OEMId{get; set;}

Public List<SelectOption> Contacts{get; set;}
Public Boolean renderFull{get; set;}
Public String TagErrorMsg{get; set;}
public Boolean Top5opp{get;set;}//Anis
//public Boolean errorTop5{get;set;}//Anis

public boolean errorCAM{get; set;}
public boolean errorOEM{get; set;}

//TAG ERRORS
public boolean errorTagDateBeforeToday{get; set;}
public boolean errorTagOpportunity{get; set;}
public boolean errorTagDateRequired{get; set;}
public boolean errorTag{get; set;}
//Quote Stage
public boolean errorexpirationdate{get; set;}
public boolean errorquotevalue{get; set;}
//STAGE 1 ERRORS
public boolean errorContact{get; set;}
public boolean errorStage1{get; set;}
//STAGE 2 ERRORS
public boolean errorCorpBid{get; set;}
public boolean errorBusinessType{get; set;}
public boolean errorOpportunityType{get; set;}
public boolean errorBusinessSolutions{get; set;}
public boolean errorMarket{Get; set;}
public boolean errorSubMarket{Get; set;} // Added by Abhishek as per Tim Ciolli ticket INC000001627621 Date: 22nd Oct 2013
public boolean errorStage2{get; set;}

//STAGE 3 ERRORS
public boolean errorValueAdd{get; set;}
public boolean errorRequestedSupplier{get; set;}
public boolean errorCustomerRequestedSupplier{get; set;}
public boolean errorCompetitor{Get; set;}
public boolean errorCompetitivePosition{get; set;}
public boolean errorTechRep{get; set;}
public boolean errorADERep{get; set;}

public boolean errorStage3{get; set;}



//STAGE 4 ERRORS
public boolean errorOpportunityVolume{get; set;}
Public boolean errorTransactionApprovedPricePopulated{get; set;}
Public boolean errortransactionapprovedpricerequired{get; set;}
Public boolean errorRequestedPriceRequired{get; set;}
Public boolean errorTargetPrice{get; set;}
public boolean errorOrderFrequency{Get; set;}
public boolean errorPriceUnitOfMeasure{get; set;}
public boolean errorSAPMaterial{get; set;}
public boolean errorBaseCode{get; set;}
public boolean errorStage4{get; set;}
public boolean errorawradstartdate{get; set;}
public boolean errorawradenddate{get; set;}
public boolean erroropprevenue{get; set;}

//CLOSED ERRORS
public boolean errorWonLostComments{get; set;}
public boolean errorClose{get; set;}
public boolean makerequired{get; set;}

public boolean issubmitted{get; set;}
public boolean isapprover{get; set;}
public boolean getrenderplastics(){ return PLASTICRECTYPES.contains(RecordTypeName); }
public boolean getisplastics(){ return PLASTICRECTYPES.contains(RecordTypeName); }
public boolean getischemicals(){return CHEMICALSRECTYPES.contains(RecordTypeName);}
public boolean getiscomposites(){return COMPOSITESRECTYPES.contains(RecordTypeName);}
public boolean getisEnvServices(){return ESRECTYPES.contains(RecordTypeName);}

public OpportunityExtensionArchway(ApexPages.standardController sc){
   
  string churnid= apexpages.currentpage().getparameters().get('churnid'); 
  makerequired=True; 
  
  Opp = (Opportunity)sc.getrecord();
  String id = '';
  id = opp.id;
  if(churnid !=null){
  churnlist =[select Id,Account_Number__c,Base_Code__c,ChurnOpportunity__c,Material_Code__c,Ownerid from SalesChurn__c where id=:churnid]; 
    }  
      if(churnlist.size()>0){
       if(churnlist.get(0).Material_Code__c !=null){
           Opp.SAP_Material__c = churnlist.get(0).Material_Code__c;
           }
       if(churnlist.get(0).Account_Number__c !=null){    
          Opp.AccountId = churnlist.get(0).Account_Number__c;
          }
          Opp.ownerid = churnlist.get(0).ownerid;
   }
   

  Acc = new Account();
  Contact = new Contact();
  returl = apexpages.currentpage().getparameters().get('returl');
  system.debug('returl: ' + returl);
  recordtypeid = apexpages.currentpage().getparameters().get('rid');

  Contacts = new List<SelectOption>();
  StageMap = Opportunity_Functions.getOpportunityStageMap();
  UserId = userinfo.getuserid();
  User = [select id, name, managerId, Business_Role__c, SKP_Pricing_User__c from User where id = :UserId limit 1];
  isPilot = User.SKP_Pricing_User__c;
  
  ApprovedPriceRequired = false;
  TargetPriceRequired = false;
  RequestedPriceRequired = false; 
  errorTransactionApprovedPricePopulated = false; 
  errortransactionapprovedpricerequired = false; 
  errorRequestedPriceRequired = false; 
  errorTagDateRequired = false; 
  errorPriceUnitOfMeasure = false; 
  errorOpportunityVolume = false; 
  errorSAPMaterial = false; 
  errorRequestedSupplier = false; 
  errorOrderFrequency = false; 
  errorValueAdd = false; 
  errorCompetitivePosition = false; 
  errorCompetitor = false; 
  errorMarket = false;
  errorSubMarket = false; // Added by Abhishek as per Tim Ciolli ticket INC000001627621 Date: 22nd Oct 2013
  errorContact = false; 
  errorTagDateBeforeToday = false;
  errorCAM = false;
  errorOEM = false; 
  errorWonLostComments = false;
  errorBusinessType = false;
  errorOpportunityType = false;
  errorBusinessSolutions = false;
  errorTargetPrice = false;
  errorTagOpportunity = false;
  errorBaseCode = false;
  errorCustomerRequestedSupplier  = false;
  errorTag = false;
  errorquotevalue=false;
  errorexpirationdate=false;
  errorStage1 = false;
  errorStage2 = false;
  errorStage3 = false;
  errorStage4 = false;
  errorClose = false;
  errorTechRep = false;
  errorADERep = false;
  errorawradstartdate = false;
  errorawradenddate = false;
  errorCorpBid = false;
  TagErrorMsg = '';
  Top5opp=true;  
  //errorTop5=false;
  erroropprevenue=false;

  if(ApexPages.currentpage().getparameters().containskey('aid')){aid = ApexPages.currentpage().getparameters().get('aid'); }
  if(ApexPages.currentpage().getparameters().containskey('quote')){quote = ApexPages.currentpage().getparameters().get('quote'); }
  if(ApexPages.currentpage().getparameters().containskey('cid')){cid = ApexPages.currentpage().getparameters().get('cid');}
  if(ApexPages.currentpage().getparameters().containskey('dl')){ ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Info,'You are not the approver. This Opportunity is Locked until Approved or Rejected.')); }
  if(ApexPages.currentpage().getparameters().containskey('q')){ renderFull = false;}
  if(ApexPages.currentpage().getparameters().containskey('cf')){ clonefrom = ApexPages.currentpage().getparameters().get('cf'); }
  if(aid != null && aid != ''){ Opp.accountid = aid; }
  if(cid != null && cid != ''){ Opp.contact__c = cid; }
  
  DC = new list<Delivery_Cities__c>();

  if((id != '' && id != null) || (CloneFrom != '' && CloneFrom != null)){
  renderFull = true;
  
  if(CloneFrom != null && CloneFrom != ''){
    Opp = getOpportunity(CloneFrom).clone(false);
    Opp.Pricing_Approval_Status__C = null;
    Opp.TAG_Approval__c = null;
    Opp.TAG_Date__C = null;
    Opp.TAG_Opportunity__c = false;
  }
  Else{
    Opp = getOpportunity(id);
  }
  recordtypename = Opp.recordtype.name;  

  if(Opp.Customer_Requested_Supplier__c == null){ Opp.Customer_Requested_Supplier__c = 'No';}
  originalTAGDate = opp.tag_Date__c;
  issubmitted = approval_functions.issubmitted(opp.id);
  isapprover = approval_functions.isapprover(UserId, opp.id);

  if(opp.contact__c != null && opp.buying_role__c == null){ opp.buying_role__c = opp.Contact__r.Buying_Role__c; }
  if(opp.accountid != null){
    Acc = [select id, 
        Name, 
        Account_Search_Phrase__c,
        SAP_City__c,
        SAP_Division_Desc__c,
        SAP_Sales_District_Desc__c,
        SAP_Sales_Group_Desc__c , 
        SAP_Sales_Office_Desc__c,
        SAP_State__c,
        SAP_Zip_Code__c,
        Type,
        AccountNumber,
        Approval_Status__c,
        RecordtypeId
        from Account where id = :opp.accountid limit 1];}
  
  if(Opp.contact__c != null){      
  Contact = [select id, name, firstname, lastname, buying_role__c from Contact where id = :opp.contact__c limit 1];
  if(Opp.buying_role__c == null){ opp.buying_role__c = Contact.Buying_Role__c; }
  }
  
  OppSubtitle = Opp.Name;
  DC = [select id, state__c, Account__c, Account__r.id, Account__r.name, Account__r.site, name, default_plant__c, ship__c, mon__c, tues__c, wed__c, thur__c, fri__c from Delivery_Cities__c where (zip__c = :Opp.Account.SAP_Zip_Code__c) or (state__c = :Opp.account.SAP_State__c and name = :Opp.account.SAP_City__c) limit 1000];   
  dcsize=dc.size();
  //Opp.Opportunity_Owners_manager__c = Opp.Owner.managerid;
  Opp.Opportunity_Owners_Business_Role__c = Opp.Owner.Business_role__c;
  requiredAtQuote = STAGE4.contains(Opp.StageName);
  requiredAtClose = CLOSEDSTAGES.contains(Opp.StageName);
  }
  
  //Else OppID Equals Null and Record is Not Being Cloned
  Else{
   // opp=new opportunity();
    requiredAtQuote = false;
    requiredAtClose = false;
    originalTAGDate = null;
    issubmitted = false;
    isapprover = false; 
    OppSubtitle = 'New Opportunity';
    dcsize=0;

    Opp.OwnerId = UserId;
    if(recordtypeid != null){ 
    Opp.recordtypeid = recordtypeid; 
    recordtypename = recordtype_functions.LookupRecordTypeName(recordtypeid);
    system.debug('Record type name'+recordtypename );
    }
    if(quote == 'yes' && (recordtypename =='Distribution Targets' || recordtypename =='Distribution Targets - TAG'))
    {
        Opp.StageName ='0. Quote';
        isquotevalue =true;
        Opp.CloseDate=system.today();
        RequestedPriceRequired =  true;
    }
    else
    {
      Opp.StageName = STARTINGSTAGE;
      isquotevalue =false;
      RequestedPriceRequired =  false;
    }
    //Opp.StageName = STARTINGSTAGE;
    Opp.Price_Unit_of_Measure__c='LB';
    Opp.Customer_Requested_Supplier__c = 'No';
    Opp.probability = stagemap.get(Opp.stagename).DefaultProbability;
    //Opp.Opportunity_Owners_Manager__c = user.ManagerId;
    Opp.Opportunity_Owners_Business_Role__c = user.Business_Role__c;
      
    if(aid != '' && aid != null){
    Acc = [select id, 
        Name, 
        SAP_City__c,
        SAP_Division_Desc__c,
        SAP_Sales_District_Desc__c,
        SAP_Sales_Group_Desc__c , 
        SAP_Sales_Office_Desc__c,
        SAP_State__c,
        SAP_Zip_Code__c,
        Account_Search_Phrase__c,
        Type,
        AccountNumber,
        Approval_Status__c,
        RecordtypeId
        from Account where id = :aid limit 1];
    }
    if(cid != '' && cid != null){
    Contact = [select id, name, firstname, lastname, buying_role__c from Contact where id = :opp.contact__c limit 1];
    Opp.Buying_role__c = Contact.Buying_Role__c;
    }
  } //End OppId Equals Null
     
  //refreshlists();
 
  
} //end constructor
//makerequired=True;
public void fieldrequired(){
   String reasonwonlost = apexpages.currentpage().getparameters().get('reasonwonlost');
   opp.t_reason_won_lost__c = reasonwonlost;
   system.debug('---------reasonwonlost ---------'+reasonwonlost );
   makerequired=True;
   if(reasonwonlost=='Cancelled' && opp.stagename.contains('6.') )
   {
   makerequired=False;
   }

   } 
   
   public void stagechanged(){
      String stage = apexpages.currentpage().getparameters().get('stage');
      opp.t_reason_won_lost__c = null;
      opp.stagename = stage;
      makerequired = true;
    
     
      isStage1 = stage1.contains(stage);
      isStage2 = stage2.contains(stage);
      isStage3 = stage3.contains(stage);
      isStage4 = stage4.contains(stage);
      
      isquotevalue = quotevalue.contains(stage);
      isclosed = closedstages.contains(stage);
      

      TargetPriceRequired = ((isquotevalue || STAGE4.contains(stage)) && isPilot);
      RequestedPriceRequired =  ((isquotevalue || STAGE4.contains(stage)) && isPilot);
      if(ispilot)
      { ApprovedPriceRequired = (Opp.Pricing_Approval_Status__c == 'Approved' && isPilot && !getisenvservices()); }
      else
      { ApprovedPriceRequired = (STAGE4.contains(stage) && !isPilot && !getisenvservices()); }
      
      if(isStage3)
      { Top5opp= false;
         
       system.debug('Top5Opp If'+ Top5opp); }
      else
      {  
        Opp.Top_five_Opportunity__c = false;
        Top5opp= true;    
        
      system.debug('Top5Opp else'+ Top5opp); }
      
      
        
      
      if (Opp.T_Reason_Won_Lost__c=='Cancelled' && Opp.stageName=='5. Closed - Won'){
      system.debug('test Wonlost'+ Opp.T_Reason_Won_Lost__c);
      Opp.T_Reason_Won_Lost__c=null;
      system.debug('Top5Opp If'+ Top5opp);}
     
      system.debug('Top 5 Opportunity = ' + Opp.Top_five_Opportunity__c);
   
   }
   private void refreshlists(){

   Contacts.clear();
   
   string division = 'Chemicals';
   
   Contacts.add(new SelectOption('-1', '--None--'));
  
  if(acc.id != null){
  for(Contact c:[select id, firstname, lastname, name, email, phone from Contact where accountid = :acc.id order by lastname ASC limit 999])
  {
    Contacts.add(new selectOption(c.id, c.name));
  }//end for loop
  if(Opp.Contact__c != null){ cid = Opp.Contact__c; }
  }//end aid != null
  }
   public pagereference Save(){
    
      boolean isvalid = true;
      if(cid != '-1' && cid != '' && cid != null)
      {
         Opp.Contact__c = cid; 
         system.debug('contact>>'+Opp.Contact__c);
      }

 
      if(isquotevalue && Opp.Expiration_Date__c == null  )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Expiration Date is required'));
        errorexpirationdate = true; 
        isvalid = false;
        renderfull = true;
        errorquotevalue= true;
      } else { errorexpirationdate = false; }    
      if(isquotevalue && Opp.Expiration_Date__c != null && Opp.Expiration_Date__c >= system.Today()+90 )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Expiration Date Must be Within 90 Days'));
        errorexpirationdate = true; 
        isvalid = false;
        renderfull = true;
        errorquotevalue= true;
      } else { errorexpirationdate = false; } 
      if(isvalid == true){ 
        AccountChanged();
        
         Opp.Buying_Role__c = Opp.Contact__r.Buying_Role__c;
         system.debug('Buying Role>>'+Opp.Buying_Role__c); 
         Opp.recordtypeid = recordtypeid;//added by Anis   
         system.debug('Record Type Change>>'+Opp.recordtypeid); 
         if(!getisEnvServices()){     
         opp.amount = opp.Opportunity_Revenue__c;}
         Opp.Probability = stagemap.get(opp.stagename).defaultprobability;
         system.debug('probabilty>>'+Opp.Probability);
         if(isquotevalue ==false){Opp.Expiration_Date__c=null;}
          if(churnlist.size()>0){
          opp.ChurnOpportunity__c=churnlist.get(0).id;
          }
         upsert opp; 
         //Opp.Probability = stagemap.get(opp.stagename).defaultprobability;
         //update opp;
         issubmitted = approval_functions.issubmitted(opp.id);
         
         if(issubmitted == false && opp.tag_approval__c != 'Approved' && opp.tag_approval__c != 'Submitted' &&      
            issubmitted == false && opp.tag_opportunity__c == true)
         { 
            approval_functions.submitrecord(opp.id, 'Submitting TAG Opportunity for Approval.');
         }  
         return new pagereference('/' + Opp.id ); 
      } else {return null;}
 }// end save  
      
 
 public pagereference cancel(){
    system.debug('retURL'+ returl);
         if(returl == null){  
         return new pagereference('/' + Opp.id );
         }else{return new pagereference('/006/o');} 
   }
   public void accountchanged(){
     
     system.debug('aid: ' + aid);
     system.debug('opp.accountid: ' + opp.accountid);
     system.debug('cid: ' + cid);
     if(opp.accountid != null){ aid = opp.accountid;}
     if(cid != '-1'){
     if(Opp.Contact__c != null && cid == Opp.Contact__c ){ cid = opp.contact__c; }} //added one more condition
           
     aid = opp.accountid;
     system.debug('aid - accountid: ' + aid);
     system.debug('cid: ' + cid);
     
     if(cid != '' && cid != null && cid != '-1'){  
       Contact c = [select id, accountid, buying_role__c from Contact where id = :cid limit 1];
       system.debug('++'+c);
       if(aid == null || aid == ''){aid = c.accountid; }
       Opp.Contact__c = cid; 
       }// end if cid != null
       else{Opp.Contact__c =null;}
     if(aid != '' && aid != null){    
       Acc = [select id, 
        Name, 
        SAP_City__c,
        SAP_Division_Desc__c,
        SAP_Sales_District_Desc__c,
        SAP_Sales_Group_Desc__c , 
        SAP_Sales_Office_Desc__c,
        SAP_State__c,
        SAP_Zip_Code__c,
        Account_Search_Phrase__c,
        Type,
        AccountNumber,
        Approval_Status__c,
        RecordtypeId
        from Account where id = :aid limit 1]; 
        system.debug('--'+Acc);            
        DC = [select id, state__c, Account__c, Account__r.id, Account__r.name, Account__r.site, name, default_plant__c, ship__c, mon__c, tues__c, wed__c, thur__c, fri__c from Delivery_Cities__c where (zip__c = :acc.SAP_Zip_Code__c) or (state__c = :acc.SAP_State__c and name = :acc.SAP_City__c) limit 1000];   
       dcsize=dc.size();
       opp.accountid = aid;
       refreshlists();
       }// end if aid != null
       
     system.debug('aid: ' + aid);
     system.debug('cid: ' + cid);
       
   }//end Account Changed Function
   
   private Opportunity getOpportunity(String oid){
   
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
  Submarket__c, // Added by Abhishek as per Tim Ciolli ticket INC000001627621 Date: 22nd Oct 2013
  OEM__c, // Added by Abhishek as per Tim Ciolli ticket INC000001627621 Date: 22nd Oct 2013
  Probability_picklist__c,// Added by Abhishek as per Tim Ciolli ticket INC000001637475 Date: 23rd Oct 2013
  T_Reason_Won_Lost__c,
  Name,
  Opportunity_Owners_Business_Role__c,
  //Opportunity_Owners_Manager__c, 
  //Opportunity_Owners_Manager__r.Name,
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
  makerequired=True;
   return returnOpp;
 }


}