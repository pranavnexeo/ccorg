public class OpportunityNewPlasticExtension{

private Set<String> COMPOSITESRECTYPES = new set<String>{'Distribution Targets', 'Distribution Targets - TAG'};
private set<String> PLASTICRECTYPES = new set<String>{'Distribution Plastics', 'Distribution Plastics - TAG'};
private set<String> CHEMICALSRECTYPES = new set<String>{'Distribution Chemicals', 'Distribution Chemicals - TAG'};
private set<String> ESRECTYPES = new set<String>{'Distribution Environmental Services', 'Distribution Environmental Services - TAG'};
private String PRICINGCOORDINATORTEMPLATEID = '00XM0000000HwDN';

private Set<String> STAGE1 = new set<String>{'1. Identify', '2. Qualify', '3. Negotiate', 'Closed - Won', 'Closed - Lost'};
private Set<String> STAGE2 = new set<String>{'2. Qualify', '3. Negotiate', 'Closed - Won', 'Closed - Lost'};
private Set<String> STAGE3 = new set<String>{'3. Negotiate', 'Closed - Won', 'Closed - Lost'};
private Set<String> STAGE4 = new Set<String>{'Closed - Won', 'Closed - Lost'};
private Set<String> CLOSEDSTAGES = new Set<String>{'Closed - Won', 'Closed - Lost'};
private String STARTINGSTAGE = '1. Identify';
private Set<String> OTHERREASONS = new Set<String>{'Service - ADEOther'};
private Set<String> QUOTEVALUE = new Set<String>{'0. Quote'};
public boolean firstSave{get;set;}

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
public boolean flag;

private Map<String, OpportunityStage> stageMap{get; set;}
private boolean getSUBMITPRICING() { return false; }
private date originalTAGDate{get; set;}
public String recordtypename{get; set;}

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
public boolean error_Auto_Mot_Error_flag {get; set;}
public boolean error_Automotive_Application_Error_flag {get; set;}
public boolean error_Vehicle_US_flag {get; set;}
public boolean error_Parts_Vehicle_flag {get; set;}
public boolean error_Part_Weight_flag {get; set;}
public boolean error_of_Trim_Level_flag {get; set;}
public boolean IsAutomotiveFlag {get; set;}
public string AutomotiveFlagval {get; set;}

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
public boolean makeConceptFieldsrequired{get; set;}

public boolean issubmitted{get; set;}
public boolean isapprover{get; set;}
public boolean getrenderplastics(){ return PLASTICRECTYPES.contains(RecordTypeName); }
public boolean getisplastics(){ return PLASTICRECTYPES.contains(RecordTypeName); }
public boolean getischemicals(){return CHEMICALSRECTYPES.contains(RecordTypeName);}
public boolean getiscomposites(){return COMPOSITESRECTYPES.contains(RecordTypeName);}
public boolean getisEnvServices(){return ESRECTYPES.contains(RecordTypeName);}

public OpportunityNewPlasticExtension(ApexPages.standardController sc){
   
  string churnid= apexpages.currentpage().getparameters().get('churnid'); 
  makerequired=True;
  makeConceptFieldsrequired=true;
  flag = True;
  
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
  error_Vehicle_US_flag = false; 
  error_Parts_Vehicle_flag = false;
  error_of_Trim_Level_flag = false;
  error_Auto_Mot_Error_flag = false;
  error_Part_Weight_flag = false;
  IsAutomotiveFlag = false;
  error_Automotive_Application_Error_flag = false;

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
        Lead_Source_User__c,
        AccountNumber,
        Approval_Status__c,
        RecordtypeId
        from Account where id = :opp.accountid limit 1];
        //opp.leadsource_user__c = acc.lead_source_user__c;
        }
  
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
        lead_source_user__c,
        AccountNumber,
        Approval_Status__c,
        RecordtypeId
        from Account where id = :aid limit 1];
        opp.leadsource_user__c = acc.lead_source_user__c;
    }
    if(cid != '' && cid != null){
    Contact = [select id, name, firstname, lastname,email,phone, buying_role__c from Contact where id = :opp.contact__c limit 1];
    Opp.Buying_role__c = Contact.Buying_Role__c;
    }
  } //End OppId Equals Null
     
  refreshlists();
 if(opp.accountid != null && firstSave == true){
    Acc = [select id, Name,Account_Search_Phrase__c,SAP_City__c,SAP_Division_Desc__c,SAP_Sales_District_Desc__c,SAP_Sales_Group_Desc__c , SAP_Sales_Office_Desc__c,SAP_State__c,SAP_Zip_Code__c,Type,Lead_Source_User__c,AccountNumber,Approval_Status__c,RecordtypeId from Account where id = :opp.accountid limit 1];
        opp.leadsource_user__c = acc.lead_source_user__c;
        }
        
  
  
} //end constructor

   private void refreshlists(){

   Contacts.clear();
   
   string division = '';
   IF(PLASTICRECTYPES.contains(recordtypename)){ division = 'Plastics'; }
   IF(COMPOSITESRECTYPES.contains(recordtypename)){ division = 'Composites'; }
   IF(CHEMICALSRECTYPES.contains(recordtypename)){ division = 'Chemicals'; }
   IF(ESRECTYPES.contains(recordtypename)){ division = 'Environmental Services'; }

   Contacts.add(new SelectOption('-1', '--None--'));
  
  if(acc.id != null){
  for(Contact c:[select id, firstname, lastname, name, email, phone from Contact where accountid = :acc.id order by lastname ASC limit 999])
  {
    Contacts.add(new selectOption(c.id, c.name));
  }//end for loop
  if(Opp.Contact__c != null){ 
  cid = Opp.Contact__c; 
  contact = [select id, firstname, lastname, name, email, phone from Contact where id = :cid];
  }
  }//end aid != null
  }// end refreshlists function
   
   public pagereference showfull(){
     renderfull = true;
     if(getIsPlastics()){ return Page.OpportunityNewPlastics; }
     else if (getisEnvServices()){ return Page.OpportunityEnvService; }
     else if (getIsChemicals()){ return Page.OpportunityChem; }
     else if (getIsComposites()){ return Page.OpportunityComposite; }
     else { return null; }
   }

   public void stageOnChange(){
        OpportunityStage ostage; 
             System.debug('!!!!!!!!!!!!!!!!!!!!'+Opp.Name);
                if (stageMap.containsKey(Opp.StageName)) {
                    ostage = stageMap.get(Opp.StageName);
                    Opp.Probability = ostage.DefaultProbability;
                    System.debug('>>>>>>>> ' + ostage);
                    System.debug('>>>>>>>>prob ' + Opp.Probability);
                    //System.debug('>>>>>>>> ' + selOpps[i].Id + ':' + selOpps[i].Probability);
                }
                      
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
        Lead_Source_User__c,
        AccountNumber,
        Approval_Status__c,
        RecordtypeId
        from Account where id = :aid limit 1];             
        DC = [select id, state__c, Account__c, Account__r.id, Account__r.name, Account__r.site, name, default_plant__c, ship__c, mon__c, tues__c, wed__c, thur__c, fri__c from Delivery_Cities__c where (zip__c = :acc.SAP_Zip_Code__c) or (state__c = :acc.SAP_State__c and name = :acc.SAP_City__c) limit 1000];   
       dcsize=dc.size();
       opp.accountid = aid;
       if (flag == true){
       opp.leadsource_user__c = acc.lead_source_user__c;
       }
       refreshlists();
       }// end if aid != null
       
     system.debug('aid: ' + aid);
     system.debug('cid: ' + cid);
       
   }//end Account Changed Function

    public pagereference Save(){
      
      error_Automotive_Application_Error_flag = false;
      error_Parts_Vehicle_flag = false;
      error_of_Trim_Level_flag = false;
      error_Part_Weight_flag = false; 
      error_Vehicle_US_flag = false;   
      errorOEM = false;
      flag = false;
      boolean isvalid = true;
      if(cid != '-1' && cid != '' && cid != null)
      {
         Opp.Contact__c = cid; 
         system.debug('contact>>'+Opp.Contact__c);
      }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && Opp.T_Business_Type__c == null && recordtypename  == 'Distribution Environmental Services')
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Business Type: You Must Select a Value'));
        errorBusinessType = true; 
        isvalid = false;
        renderfull = true;
        errorStage2 = true;
      } else { errorBusinessType = false; } 


      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && isquotevalue && Opp.Expiration_Date__c == null  )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Expiration Date is required'));
        errorexpirationdate = true; 
        isvalid = false;
        renderfull = true;
        errorquotevalue= true;
      } else { errorexpirationdate = false; }    
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && isquotevalue && Opp.Expiration_Date__c != null && Opp.Expiration_Date__c >= system.Today()+90 )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Expiration Date Must be Within 90 Days'));
        errorexpirationdate = true; 
        isvalid = false;
        renderfull = true;
        errorquotevalue= true;
      } else { errorexpirationdate = false; }   
      
      //STAGE 2 REQURIED FIELDS
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && !isquotevalue && STAGE2.contains(Opp.StageName) && Opp.Market__c == null && !getisEnvServices() && Opp.T_Reason_Won_Lost__c != 'Cancelled' )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Market is required'));
        errorMarket = true; 
        isvalid = false;
        renderfull = true;
        errorStage2 = true;
      } else { errorMarket = false; }
      
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && recordtypename =='Distribution Plastics' && Opp.Market__c == 'Automotive' && Opp.T_Reason_Won_Lost__c != 'Cancelled' ){
          if(opp.Submarket__c   =='AfterMarket')
          {
             If(  Opp.Automotive_Application__c == '' || Opp.Automotive_Application__c == null )
              {       
                  error_Automotive_Application_Error_flag = true;
                  isvalid = false;
                  renderfull = true;
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Automotive Application is required'));  
              } 
          }
          else
          {
              If( Opp.OEM_1__c == '' || Opp.OEM_1__c == null )
              {     
                  errorOEM = true;
                  isvalid = false;
                  renderfull = true;
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'OEM is required'));  
              }    
              If( Opp.Automotive_Application__c == '' || Opp.Automotive_Application__c == null )
              {       
                  error_Automotive_Application_Error_flag = true;
                  isvalid = false;
                  renderfull = true;
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Automotive Application is required'));  
              }
              If(Opp.Vehicle_US__c == '' || Opp.Vehicle_US__c == null )
              {       
                  error_Vehicle_US_flag = true;
                  isvalid = false;
                  renderfull = true;
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Vehicle is required'));  
              }
              If( !(Opp.Part_Weight_kg__c > 0000.00 && Opp.Part_Weight_kg__c <= 9999.99) )
              {       
                  error_Part_Weight_flag = true;
                  isvalid = false;
                  renderfull = true;
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Part Weight (kg) is required and Value between 0000.01 and 9999.99'));  
              }
              If( !(Opp.Parts_Vehicle__c > 0 && Opp.Parts_Vehicle__c <= 9999) )
              {       
                  error_Parts_Vehicle_flag = true;
                  isvalid = false;
                  renderfull = true;
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Parts/Vehicle is required and Value between 1 and 9999'));  
              }
          
          // till here====================
          /*If( !(Opp.of_Trim_Level__c >= 0 && Opp.of_Trim_Level__c <= 100))
          {       
              error_of_Trim_Level_flag = true;
              isvalid = false;
              renderfull = true;
              ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'% of Trim Level is required and Value between 0 and 100'));  
          }*/
          }
      }
      
      // Added by Abhishek as per Tim Ciolli ticket INC000001627621 Date: 22nd Oct 2013
       if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && recordtypename =='Distribution Plastics' && !isquotevalue && STAGE2.contains(Opp.StageName) && Opp.Submarket__c == null && !getisEnvServices() && Opp.T_Reason_Won_Lost__c != 'Cancelled' )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Sub Market is required'));
        errorSubMarket = true; 
        isvalid = false;
        renderfull = true;
        errorStage2 = true;
      } else { errorSubMarket = false; }
    
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && STAGE4.contains(Opp.StageName) && Opp.Amount == null && getisEnvServices())
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Opportunity Revenue is required'));
        erroropprevenue = true; 
        isvalid = false;
        renderfull = true;
        errorStage4 = true;
      } else { erroropprevenue = false; }
      
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && recordtypename != 'Distribution Plastics' && !isquotevalue && STAGE3.contains(Opp.StageName) && Opp.Requested_Supplier_PL__c == null && !getisEnvServices() && Opp.T_Reason_Won_Lost__c != 'Cancelled')
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Requested Supplier is required'));
        errorRequestedSupplier = true; 
        isvalid = false;
        renderfull = true;
        errorStage3 = true;
      } 
      // else { errorRequestedSupplier = false; }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && recordtypename =='Distribution Plastics' && !isquotevalue && STAGE2.contains(Opp.StageName) && Opp.Requested_Supplier_PL__c == null && !getisEnvServices() && Opp.T_Reason_Won_Lost__c != 'Cancelled')
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Requested Supplier is required'));
        errorRequestedSupplier = true; 
        isvalid = false;
        renderfull = true;
        errorStage2 = true;
      }
      // else { errorRequestedSupplier = false; }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && !isquotevalue && STAGE3.contains(Opp.StageName) && Opp.Customer_Requested_Supplier__c == null && !getisEnvServices() )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Customer Mandated Supplier is required'));
        errorCustomerRequestedSupplier = true;
        isvalid = false;
        renderfull = true;
        errorStage3 = true;
      } else{ errorCustomerRequestedSupplier = false; }
      
   
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && (isquotevalue || STAGE3.contains(Opp.StageName)) && (Opp.Nexeo_Primary_Competitor_PL__c == null ) && Opp.T_Reason_Won_Lost__c != 'Cancelled')
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Competitor is required'));
        errorCompetitor = true; 
        isvalid = false;
        renderfull = true;
        errorStage3 = true;  
        system.debug('Nexeo Competitor: Error');      
      } else{ errorCompetitor = false; system.debug('Nexeo Competitor: OK'); }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && !isquotevalue && STAGE2.contains(Opp.StageName) && opp.Corporate_Bid__c == null && getisplastics() == true )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Corporate Bid is required'));
        errorCorpBid = true; 
        isvalid = false;
        renderfull = true;
        errorStage3 = true;        
      } else{ errorCorpBid = false; }
      //STAGE 4 REQUIRED FIELDS
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && !isquotevalue && STAGE3.contains(Opp.StageName) && Opp.Annual_Usage__c == null && !getisEnvServices()&& Opp.T_Reason_Won_Lost__c != 'Cancelled')
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Opportunity Volume is required'));
        errorOpportunityVolume = true; 
        isvalid = false;
        renderfull = true;
        errorStage4 = true;
      } else{ errorOpportunityVolume = false; }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && (isquotevalue || STAGE3.contains(Opp.StageName)) && Opp.Price_Unit_of_Measure__c == null && !getisEnvServices())
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Price Unit of Measure is required'));
        errorPriceUnitofMeasure = true; 
        isvalid = false;
        renderfull = true;
        errorStage4 = true;
      } else{ errorPriceUnitofMeasure = false; }

      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && isquotevalue && Opp.SAP_Material__c == null && !getisEnvServices()) 
      {     ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'SAP Material is required'));        
            errorSAPMaterial = true; 
            isvalid = false;
            renderfull = true;
            errorStage4 = true;
      } 
      else if(!isquotevalue && STAGE3.contains(Opp.StageName) && Opp.SAP_Material__c == null && Opp.Material_of_Interest__c == null && !getisEnvServices() && Opp.T_Reason_Won_Lost__c != 'Cancelled' && (opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won'))  
          { ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'SAP Material Code or Material (Not in SAP) is required'));        
            errorSAPMaterial = true; 
            isvalid = false;
            renderfull = true;
            errorStage4 = true;
          }
      else{ errorSAPMaterial = false; }  
        
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && Opp.Pricing_Approval_Status__c != 'Approved' && Opp.Pricing_Approval_Status__c != 'Submitted' && 
        (Opp.Transaction_Approved_Price__c != null && isPilot && !getisEnvServices())){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Approved Price should not be populated until Opportunity has been Approved.'));
        errorTransactionApprovedPricePopulated = true;
        isvalid = false;
      }  else{ errorTransactionApprovedPricePopulated = false; }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && (Opp.Pricing_Approval_Status__c == 'Approved' || Opp.Pricing_Approval_Status__c == 'Submitted' && !getIsEnvServices()) && 
         (Opp.Transaction_Approved_Price__c == null && isPilot)){
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Approved Price is Required after Opportunity has been Submitted for Approval.'));
         errorTransactionApprovedPriceRequired = true; 
         isvalid = false;
      } else { errorTransactionApprovedPriceRequired = false; }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && (isquotevalue ||STAGE3.contains(Opp.StageName)) && Opp.Requested_Price__c == null && isPilot)
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Requested Price is required'));
        errorRequestedPriceRequired = true; 
        isvalid = false;
        renderfull = true;
      } else{ errorRequestedPriceRequired = false; }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && Opp.StageName.contains('5.') && Opp.T_Reason_Won_Lost__C == 'Cancelled')
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Reason Won Lost Can Not Be Cancelled in this Stage')); 
        isvalid = false;
        renderfull = true;
      }
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && STAGE3.contains(Opp.StageName) && Opp.Transaction_Approved_Price__c == null && !isPilot && !getisEnvServices()&& Opp.T_Reason_Won_Lost__c != 'Cancelled')
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Approved Price is required.'));
        errorTransactionApprovedPriceRequired = true; 
        isvalid = false;
        renderfull = true;
      } else{ errorTransactionApprovedPriceRequired = false; }
      
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') &&  (isquotevalue || STAGE4.contains(Opp.StageName)) && Opp.Target_Price__c == null && isPilot)
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Target Price is required'));
        errorTargetPrice= true; 
        isvalid = false;
        renderfull = true;
        errorStage4 = true;
      } else{ errorTargetPrice = false; }
       
      //STAGE 5 REQUIRED FIELDS
      if(!isquotevalue && Opp.T_Reason_Won_Lost__c == null && CLOSEDSTAGES.contains(Opp.StageName) && (opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') ){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Reason Won/Lost is required'));
        isvalid = false;
        errorClose = true;
      }  
      
      //TAG REQUIRED FIELDS 
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && Opp.TAG_Opportunity__c && Opp.TAG_Date__c == null){       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'TAG Date is required'));
        errorTagDateRequired = true;
        isvalid = false;
      } else{ errorTagDateRequired = false; }
      
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && Opp.TAG_Date__c != OriginalTAGDate && Opp.TAG_Date__c != null &&
         Opp.TAG_Opportunity__c == true && Opp.TAG_Date__c <= system.today() ){       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'TAG Date must not be on or before Today\'s Date.'));
        TagErrorMsg = 'TAG Date must not be on or before Today\'s Date.';
        errorTagDateBeforeToday = true;
        isvalid = false;
      } else{ errorTagDateBeforeToday = false; }   
      
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && Opp.TAG_Opportunity__c == false && Opp.Tag_Date__c != null){
        errorTagOpportunity = true;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'TAG Date must be blank if TAG Opportunity is not checked.'));
        isvalid = false;
      } else{ errorTagOpportunity = false; }
      
      //OTHER REQUIRED FIELDS
      //if(Opp.Technical_Representative__c == 'No Value Supplied') // Updated new Lookup value insted of picklist 
      /*
      if(Opp.Technical_Representative1__c == null)
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You Must Provide A Technical Representatives Name or Change to --None--.'));
        errorTechRep = true;
        isvalid = false;
      } else{ errorTechRep = false; }
      */
      //if(Opp.ADE_Technical_Representative__c == 'No Value Supplied') // Updated new Lookup value insted of picklist 
      /*
      if(Opp.ADE_Technical_Representative1__c == null)
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You Must Provide an ADE Technical Representatives Name or Change to --None--.'));
        ErrorADERep = true;
        isvalid = false;
      }else{ errorADERep = false; }
      */
      if((opp.StageName =='2. Qualify' || opp.StageName =='3. Negotiate' || opp.StageName =='Closed - Won') && (Opp.Corporate_Bid__c == 'Yes' && opp.Auto_CAM1__c == null && opp.Plastics_CAM2__c == null && opp.Plastics_CAM1__c == null && getisplastics())) //Added new Lookup fields insted of Picklist fields
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'You must enter any one value in Auto CAM or Plastics CAM1 or Plastics CAM2 if Corporate Account Bid is Yes.'));
        errorCAM = true;
        isvalid = false;
      }else{ errorCAM = false; }
      
      if(Opp.Corporate_Bid__c == 'No' && getisplastics()) //Added new Lookup fields insted of Picklist fields
      {       
          opp.Auto_CAM1__c = null;
          opp.Plastics_CAM2__c = null;
          opp.Plastics_CAM1__c = null;
      }

      if(Opp.Won_Lost_Comments__c.length() > 250 )
      {       
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Won Lost Comments must be less than 250 Characters. Current Length: ' + Opp.Won_Lost_Comments__c.length()));
        errorWonLostComments = true; 
        isvalid = false;
        renderfull = true;
      } else { errorWonLostComments = false; }     

      system.debug('is valid: ' + isvalid);
      if(isvalid == true){ 
         AccountChanged();
         If(opp.Market__c == 'Automotive'){
            // opp.Application__c = opp.Automotive_Application__c;
         }else{
             Opp.Parts_Vehicle__c = null;
             Opp.of_Trim_Level__c = null;
             Opp.Part_Weight_kg__c = null;
             Opp.Automotive_Application__c = '';
             Opp.OEM_1__c = '';
             Opp.Specifier_Tier__c = null;
         }
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
   
   public pagereference submit(){ 
   boolean issubmitted = approval_functions.issubmitted(opp.id);
   if(issubmitted == false){ approval_functions.submitrecord(opp.id, 'Submitting for Approval');}
   return new pagereference('/' + opp.id);
   }
   public pagereference saveandsubmit(){
     pagereference p = save();
     if(p != null){ Approval_Functions.submitrecord(opp.id, 'Submitting for Approval'); }
     
     return p;
   }
   
   public void stagechanged(){
      String stage = apexpages.currentpage().getparameters().get('stage');
      //String quote = apexpages.currentpage().getparameters().get('quote');
      opp.t_reason_won_lost__c = null;
      opp.stagename = stage;
      makerequired = true;
      makeConceptFieldsrequired = true;
      
      if(opp.Corporate_Bid__c != 'Yes'){
          errorCAM = false;
      }
    
      if(stage=='Concept' || stage=='Closed - Concept'){
        makeConceptFieldsrequired = false;
      }

      isStage1 = stage1.contains(stage);
      isStage2 = stage2.contains(stage);
      isStage3 = stage3.contains(stage);
      isStage4 = stage4.contains(stage);
      
      isquotevalue = quotevalue.contains(stage);
      //If(Opp.Id!=null){isquotevalue=quotevalue.contains(Opp.Quote_Required__c);}
      //else {isquotevalue = quotevalue.contains(quote);}
      isclosed = closedstages.contains(stage);
      //system.debug('isquotevalue in stagechanged'+isquotevalue );

      TargetPriceRequired = ((isquotevalue || STAGE4.contains(stage)) && isPilot);
      RequestedPriceRequired =  ((isquotevalue || STAGE4.contains(stage)) && isPilot);
      if(ispilot)
      { ApprovedPriceRequired = (Opp.Pricing_Approval_Status__c == 'Approved' && isPilot && !getisenvservices()); }
      else
      { ApprovedPriceRequired = (STAGE4.contains(stage) && !isPilot && !getisenvservices()); }
      //if(isquotevalue){errorSAPMaterial = true;}
      //else{Opp.CloseDate=null}
      if(isStage3)
      { Top5opp= false;
          //errorTop5=true;
       system.debug('Top5Opp If'+ Top5opp); }
      else
      {  
        Opp.Top_five_Opportunity__c = false;
        Top5opp= true;    
        //errorTop5=false;
      system.debug('Top5Opp else'+ Top5opp); }
      
      
        
      
      if (Opp.T_Reason_Won_Lost__c=='Cancelled' && Opp.stageName=='5. Closed - Won'){
      system.debug('test Wonlost'+ Opp.T_Reason_Won_Lost__c);
      Opp.T_Reason_Won_Lost__c=null;
      system.debug('Top5Opp If'+ Top5opp);
      }
     
      system.debug('Top 5 Opportunity = ' + Opp.Top_five_Opportunity__c);
   
   }
 
   
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
  ADE_Technical_Representative__c, // Removed By Abhi
  ADE_Technical_Representative1__c,// Added By Abhi
  Application_Development_Required__c,
  Corporate_Bid__c,
  Medical_CAM__c, // need to remove
  Plastics_CAM1__c, //Added
  Auto_CAM__c,// need to remove
  Auto_CAM1__c, //Added
  Plastics_CAM__c,// need to remove
  Plastics_CAM2__c, //Added
  Related_HQ_Account__c,
  search_term__c,
  RecordType.Name,
  Nexeo_Quote__c,
  Technical_Representative__c,  // need to remove
  Technical_Representative1__c, //Added By Abhi
  Expected_Annual_Revenue__c,
  OEM_Competitor__c,
  LeadSource,
  LeadSource_User__c,
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
  account.Lead_Source_user__c,
  Amount,
  Sample_Sent__c,
  Expiration_Date__c,
  Top_Five_Opportunity__c,
  Internal_Opportunity_Source__c,
  Part_Weight_kg__c,
  Parts_Vehicle__c,
  of_Trim_Level__c,
  Specifier_Tier__c,
  Vehicle_US__c,
  Vehicle_EU__c,
  OEM_1__c,
  Automotive_Application__c,
  Opportunity_Type__c
  from Opportunity where id = :oid limit 1];
  
  isStage1 = stage1.contains(returnopp.stagename);
  isStage2 = stage2.contains(returnopp.stagename);
  isStage3 = stage3.contains(returnopp.stagename);
  isStage4 = stage4.contains(returnopp.stagename);
  isclosed = closedstages.contains(returnopp.stagename);
  isquotevalue=quotevalue.contains(returnopp.stagename);
  TargetPriceRequired = ((isquotevalue || STAGE4.contains(returnopp.stagename)) && isPilot);
  RequestedPriceRequired =  ((isquotevalue || STAGE4.contains(ReturnOpp.StageName)) && isPilot);
  if(ispilot)
  { ApprovedPriceRequired = (returnOpp.Pricing_Approval_Status__c == 'Approved' && isPilot && !ESRECTYPES.contains(returnOpp.recordtype.name)); }
  else
  { ApprovedPriceRequired = (STAGE4.contains(ReturnOpp.StageName) && !isPilot && !ESRECTYPES.contains(returnOpp.recordtype.name)); }
  if(isStage3)
      { Top5opp= false;
        //errorTop5=true;
       system.debug('Top5Opp If'+ Top5opp); }
      else
      { Top5opp= true;
        Opp.Top_five_Opportunity__c = false; 
      //errorTop5=false;
      system.debug('Top5Opp else'+ Top5opp); }
  if( isclosed &&  ReturnOpp.T_Reason_Won_Lost__c == 'Cancelled'){makerequired=False;}
  else{makerequired=True;} 
  return returnOpp;
 }
  public void fieldrequired(){
   String reasonwonlost = apexpages.currentpage().getparameters().get('reasonwonlost');
   opp.t_reason_won_lost__c = reasonwonlost;
   system.debug('---------reasonwonlost ---------'+reasonwonlost );
   makerequired=True;
   if(reasonwonlost=='Cancelled' && opp.stagename.contains('Closed - Lost') )
   {
   makerequired=False;
   }

   }
   
   public List<SelectOption> getCAM_1() {
        
        List<User> UserList;
        Try{
            UserList = [Select id, Name from User where Plastics_CAM_1__c = true AND IsActive=True LIMIT 10000];
        }Catch(Exception e){}
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        For(User O:UserList){
            options.add(new SelectOption(O.id,O.Name));
        }
        return options;
    }
    public List<SelectOption> getCAM_2() {
        List<User> UserList;
        Try{
            UserList = [Select id, Name from User where Plastics_CAM_2__c = true AND IsActive=True LIMIT 10000];
        }Catch(Exception e){}
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        For(User O:UserList){
            options.add(new SelectOption(O.id,O.Name));
        }
        return options;
    }
    public List<SelectOption> getAuto_CAM() {
        List<User> UserList;
        Try{
            UserList = [Select id, Name from User where Auto_CAM__c= true AND IsActive=True LIMIT 10000];
        }Catch(Exception e){}
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        For(User O:UserList){
            options.add(new SelectOption(O.id,O.Name));
        }
        return options;
    }
    public List<SelectOption> getTechnical_Representative() {
        List<User> UserList;
        Try{
            UserList = [Select id, Name from User where Technical_Representative__c = true AND IsActive=True LIMIT 10000];
        }Catch(Exception e){}
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        For(User O:UserList){
            options.add(new SelectOption(O.id,O.Name));
        }
        return options;
    }
    public List<SelectOption> getADE_Technical_Representative() {
        List<User> UserList;
        Try{
            UserList = [Select id, Name from User where ADE_Technical_Representative__c= true AND IsActive=True LIMIT 10000];
        }Catch(Exception e){}
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('','--None--'));
        For(User O:UserList){
            options.add(new SelectOption(O.id,O.Name));
        }
        return options;
    }
    
    public pagereference chageMarketval() {
        If(AutomotiveFlagval == 'Automotive'){
            IsAutomotiveFlag = true;
        }else{
            IsAutomotiveFlag = false;
        }
        return null;
    }
    public pagereference changeMarket(){
        return null;
    }
      
    
 
}