public class AccntPlan{

    //Start Account Summary Info
    public Account_Summary_Information accountSummaryInformation = new Account_Summary_Information();
    public List<Account_Sales_Figure__c> acctSalesFigures;
    public List<Account_Sales_Summary__c> acctSalesSummary{get; set;}
    public boolean isPlastics{get; set;}
    public boolean isChemicals{get; set;}
    public List<opportunity> lstopp {get; set;}
    public List<opportunity> lstclosedwonopp {get; set;}
    public List<Nexeo_Competitor_to_Account__c> lstcompetitior {get; set;}
    public List<Supplier_to_Account__c> lstsupplier {get; set;}
    public user currentuser{get;set;}
    
    public Account_Summary_Information getAccountSummaryInformation() {
      return accountSummaryInformation;
    }
  //      public Boolean getFYTDvsPFYTD_Volume_in_LB_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Up;}
  //  public Boolean getFYTDvsPFYTD_Volume_in_LB_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Down;}
   // public Boolean getFYTDvsPFYTD_Volume_in_KG_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Up;}
   // public Boolean getFYTDvsPFYTD_Volume_in_KG_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Down;}
   // public Boolean getFYTDvsPFYTD_Amount_Up() {return accountSummaryInformation.FYTDvsPFYTD_Amount_Up;}
   // public Boolean getFYTDvsPFYTD_Amount_Down() {return accountSummaryInformation.FYTDvsPFYTD_Amount_Down;}
    public Boolean getFYTDvsPFYTD_GM_Up() {return accountSummaryInformation.FYTDvsPFYTD_GM_Up;}
    public Boolean getFYTDvsPFYTD_GM_Down() {return accountSummaryInformation.FYTDvsPFYTD_GM_Down;}
    public Boolean getFYTDvsPFYTD_GMpct_Up() {return accountSummaryInformation.FYTDvsPFYTD_GMpct_Up;}
    public Boolean getFYTDvsPFYTD_GMpct_Down() {return accountSummaryInformation.FYTDvsPFYTD_GMpct_Down;}
    //End Account Summary Info
 
    public String  ContactsActStat { get; set; } 

    public Boolean renderOPP{get;set;}
    public Boolean renderOPP1{get;set;}
    public Boolean renderCon{get;set;}
    public String  contentType{get;set;}

        
    private final Account acct;
    
    public Double CFYTD_VolumeKG{get;set;}
    public Double CFYTD_VolumeLB{get;set;}
    public Double PFYTD_VolumeKG{get;set;}
    public Double PFYTD_VolumeLB{get;set;}        
    Public decimal CFYTD_Amount{get;set;}
    Public decimal PFYTD_Amount{get;set;}
    Public string Currncy{get;set;}
    private Date CFYTD_StartDate;
    private Date PFYTD_StartDate;
    private Date CFYTD_EndDate;
    private Date PFYTD_EndDate;
    
    Map<Integer,String> MonthLabels = new Map<Integer,String>{1 => 'JAN',
                                                              2 => 'FEB',
                                                              3 => 'MAR',
                                                              4 => 'APR',
                                                              5 => 'MAY',
                                                              6 => 'JUN',
                                                              7 => 'JUL',
                                                              8 => 'AUG',
                                                              9 => 'SEP',
                                                             10 => 'OCT',
                                                             11 => 'NOV',
                                                             12 => 'DEC'};
    
    // The extension constructor initializes the private member
    // variable \by using the getRecord method from the standard
    // controller.
    public AccntPlan(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        currentuser=new User();
        currentuser=[Select Id,Name,Email from User where Id=:userinfo.getuserId()];

        //start Account Summary Information
        /*Commenting as the Account_Sales_Figure__c object is deprecated
                        acctSalesFigures = [SELECT 
                         Id, 
                         Name, 
                         CurrencyIsoCode, 
                         CreatedDate, 
                         CreatedById, 
                         LastModifiedDate, 
                         LastModifiedById, 
                         SystemModstamp, 
                         Account__c, 
                         Date_Range_Label__c, 
                         Start_Date__c, 
                         End_Date__c, 
                         Sales_Volume_in_LBs__c, 
                         Sales_Vol_in_KGs__c,
                         Sales_Volume_in_UNs__c, 
                         Sales_Volume_in_GALs__c, 
                         Sales_Volume_in_PTs__c, 
                         Sales_Amount__c, 
                         GM__c, 
                         GMpct__c
                  FROM Account_Sales_Figure__c
                  WHERE Account__c = :Acct.Id
                  ];
        
                
        for(Account_Sales_Figure__c f:acctSalesFigures)
          {
          accountSummaryInformation.addData(f.Date_Range_Label__c,
                                    f.Start_Date__c,
                                    f.End_Date__c,
                                    f.Sales_Volume_in_LBs__c,
                                    f.Sales_Vol_in_KGs__c,
                                    f.Sales_Volume_in_UNs__c,
                                    f.Sales_Volume_in_GALs__c,
                                    f.Sales_Volume_in_PTs__c,
                                    f.Sales_Amount__c,
                                    f.GM__c,
                                    f.GMpct__c,
                                    f.CurrencyIsoCode
                            );
          }
        */
         acctSalesSummary = [SELECT 
                         Id, 
                         Name, 
                         CurrencyIsoCode, 
                         CreatedDate, 
                         CreatedById, 
                         LastModifiedDate, 
                         LastModifiedById, 
                         SystemModstamp, 
                         Account__c, 
                         Date_Range_Label__c, 
                         Current_Fiscal_Beginning_Period__c,
                         Current_Fiscal_Ending_Period__c,
                         Current_Fiscal_Net_Revenue__c,
                         Current_Fiscal_Quantity_KGs__c,
                         Current_Fiscal_Quantity_LBs__c,
                         Current_FYTD_Begin_Date__c,
                         Current_FYTD_End_Date__c,
                         Previous_Fiscal_Beginning_Period__c,
                         Previous_Fiscal_Ending_Period__c,
                         Previous_Fiscal_Net_Revenue__c,
                         Previous_Fiscal_Quantity_KGs__c,
                         Previous_Fiscal_Quantity_LBs__c,
                         Previous_FYTD_Begin_Date__c,
                         Previous_FYTD_End_Date__c                         
                  FROM Account_Sales_Summary__c
                  WHERE Account__c = :Acct.Id
                  ];
        if(acctSalesSummary.size() >0){       
        if(acctSalesSummary[0].Current_Fiscal_Quantity_KGs__c != null){CFYTD_VolumeKG = acctSalesSummary[0].Current_Fiscal_Quantity_KGs__c;}
        if(acctSalesSummary[0].Current_Fiscal_Quantity_LBs__c != null){CFYTD_VolumeLB = acctSalesSummary[0].Current_Fiscal_Quantity_LBs__c;}
        if(acctSalesSummary[0].Previous_Fiscal_Quantity_KGs__c != null){PFYTD_VolumeKG = acctSalesSummary[0].Previous_Fiscal_Quantity_KGs__c;}
        if(acctSalesSummary[0].Previous_Fiscal_Quantity_LBs__c != null){PFYTD_VolumeLB = acctSalesSummary[0].Previous_Fiscal_Quantity_LBs__c;}
        if(acctSalesSummary[0].Current_Fiscal_Net_Revenue__c != null){CFYTD_Amount = acctSalesSummary[0].Current_Fiscal_Net_Revenue__c;}
        if(acctSalesSummary[0].Previous_Fiscal_Net_Revenue__c != null){PFYTD_Amount = acctSalesSummary[0].Previous_Fiscal_Net_Revenue__c;}
        if(acctSalesSummary[0].CurrencyIsoCode != null){Currncy = acctSalesSummary[0].CurrencyIsoCode;}
        if(acctSalesSummary[0].Current_FYTD_Begin_Date__c != null){CFYTD_StartDate = acctSalesSummary[0].Current_FYTD_Begin_Date__c;}
        if(acctSalesSummary[0].Previous_FYTD_Begin_Date__c != null){PFYTD_StartDate = acctSalesSummary[0].Previous_FYTD_Begin_Date__c;}else{PFYTD_StartDate = null;}
        if(acctSalesSummary[0].Current_FYTD_End_Date__c != null){CFYTD_EndDate = acctSalesSummary[0].Current_FYTD_End_Date__c;}
        if(acctSalesSummary[0].Previous_FYTD_End_Date__c != null){PFYTD_EndDate = acctSalesSummary[0].Previous_FYTD_End_Date__c;} else{PFYTD_EndDate = null;}
        }           
        //end Account Summary Information
        ContactsActStat                = 'All'; 

        renderOPP = true;
        renderCon = true;
        renderOpp1 = true;

        


   /*    
        if(ApexPages.currentPage().getparameters().get('rn_OPP') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OPP') == 'true') {renderOPP=true;} else {renderOPP=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_OPP1') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OPP1') == 'true') {renderOPP1=true;} else {renderOPP1=false;}}            
        if(ApexPages.currentPage().getparameters().get('rn_con') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_con') == 'true') {rendercon=true;} else {rendercon=false;}} */

    } 



    public PageReference Printable_View() {
        PageReference result = null;    
        PageReference PrintableView = Page.Account_Plan_Summary_PDF;
        PrintableView.getparameters().put('accountId',accountId);
      /*   
        PrintableView.getparameters().put('rn_OPP',String.valueOf(renderOPP));  
        PrintableView.getParameters().put('rn_con', String.valueOf(rendercon)); */

        result = PrintableView;
        return page.Account_Plan_Summary_PDF;
    
    }
    
    
    public PageReference  reRendercon(){
        rendercon = !(rendercon);
        return null;
    }
    
  
    public PageReference  reRenderOpp(){
        renderOPP = !(renderOPP);
        return null;
    }
    
    public PageReference  reRenderOpp1(){
        renderOPP1 = !(renderOPP1);
        return null;
    }     
    
    
    Account currentAccount;

    /* Accessor for retrieving the case object and its related items. If the cid property is null this
       method will return a new, empty case object. The functionality in this method could have been placed
       in the get property accessor for the private property named 'c' below but for simplicity of the page
       author in referencing the current case object this method was created because it is not possible to
       create a variable named 'case' since it is a reserved term in Apex.*/
    public Account getAccount() { 
        
        Account result;
        
        
        System.debug('accountId = ' + accountId);
        
        //if(accountId == null) return new Account();
        if (currentAccount == null)
        {
            
        //We need to get a list of contact Ids because some Tasks/Events may be indirectly related to the Account via the contact record.
            
        result = [SELECT Id,Account_Number__c, Name,ParentId, Parent.Name,Strengths__c,Account_Plan_Owner__c,Comments_Gain_Loss__c,weaknesses__c, opportunities__c, threats__c, LOB_Synergies__c,SAP_Customer_Group_Desc__c,Executive_Overview__c,Tarnell__c,                  
                  ActionPlan_Objective_1__c,ActionPlan_Objective_2__c,ActionPlan_Objective_3__c,ActionPlan_Objective_4__c,ActionPlan_Objective_5__c,Objective_1__c,Objective_2__c,Objective_3__c,Objective_4__c,Objective_5__c,
                  Objective_1_Chemicals__c,Objective_2_Chemicals__c,Objective_3_Chemicals__c,Objective_4_Chemicals__c,Objective_5_Chemicals__c,
                  SAP_Industry_Key_Desc__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c,SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, OwnerID, Owner.Name, 
                  RecordTypeId, RecordType.Name, Type, SAP_Sales_Org__c, SAP_DivisionCode__c, 
                  (SELECT Id,Name ,Role__c,Description,Account_Plan__c,Salutation, FirstName, LastName, WV_Contact_Status__c, Title, Phone, Fax, Email, OwnerId, Owner.Name, CreatedDate FROM Contacts where Account_Plan__c = True  and WV_Contact_Status__c ='Active' ORDER BY LastName ASC, FirstName ASC, CreatedDate DESC)
                   FROM Account  
                   WHERE id = :accountId]; 
                   
        
        lstopp= [SELECT Id, Name,Market__c, Annual_Usage__c ,Opportunity_Revenue__c,Amount, Probability,Description, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunity where AccountId = :accountId and isclosed = false ORDER BY CloseDate DESC];
        lstclosedwonopp= [SELECT Id, Name,Market__c, Annual_Usage__c ,Opportunity_Revenue__c,Amount, Probability,Description, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunity where AccountId = :accountId and StageName LIKE '%won%' and isclosed = true and CloseDate = THIS_FISCAL_YEAR ORDER BY CloseDate DESC]; 
        lstcompetitior=[SELECT Id, Account__c,Nexeo_Competitor__r.Name,Nexeo_Competitor__c,Comments__c FROM Nexeo_Competitor_to_Account__c where Account__c = :accountId ORDER BY CreatedDate DESC];
        lstsupplier=[SELECT Id, Account__c,Supplier__r.Name,Supplier__c,Comments__c FROM Supplier_to_Account__c where Account__c = :accountId ORDER BY CreatedDate DESC];
        
        currentAccount = result;
        
        isPlastics = (currentAccount.SAP_DivisionCode__c == '32');
        isChemicals = (currentAccount.SAP_DivisionCode__c == '31');
            
        }
        else {result = currentAccount;}
        
                
        return result; 
    }
    
    public List<Opportunity> getOpportunities()
    {
        List<Opportunity> opp = new List<Opportunity>();
        //for (Opportunity o:a.Opportunities)
        //Adde by annes on 21 oct 2011
        getAccount();
        system.debug('opport'+lstopp);
        
        for (Opportunity o:lstopp)
        {
           opp.add(o);
        }
        return opp;

    }
    
    public List<Opportunity> getclosedOpportunities()
    {
        List<Opportunity> opp1 = new List<Opportunity>();
        getAccount();
        system.debug('closedopport'+lstclosedwonopp);
        
        for (Opportunity o:lstclosedwonopp)
        {
           opp1.add(o);
        }
        return opp1;

    }    
 
    public List<Nexeo_Competitor_to_Account__c> getCompetitor()
    {
        List<Nexeo_Competitor_to_Account__c> comp= new List<Nexeo_Competitor_to_Account__c>();
        getAccount();
       
        for (Nexeo_Competitor_to_Account__c c:lstcompetitior)
        {
            comp.add(c);
        }
        return comp;

    } 
     
     public List<Supplier_to_Account__c> getSupplier()
    {
        List<Supplier_to_Account__c> suppl= new List<Supplier_to_Account__c>();
        getAccount();
        
        for (Supplier_to_Account__c c:lstsupplier)
        {
            suppl.add(c);
        }
        return suppl;

    }      
    public Contact[] getContactstoDisplay() {
    System.debug('Entering into method' +ContactsActStat);
    List<Contact> contacts = new List<Contact>();
        if(ContactsActStat == 'All'){
            return a.Contacts;}
   return contacts;
   }
    
   
    
    /* The ID value of the case that will be used by the getCase() method to query for the related
       objects used to generate the ordered history collection. The value will be based on the request 
       parameter, if available. */
    private Id accountId { 
        get {
            
            system.debug('acct.Id = ' + acct.id);
            system.debug('getparameters accountId = ' + ApexPages.currentPage().getparameters().get('accountId'));
            
            if (acct.Id==null)
                {
                if(ApexPages.currentPage().getparameters().get('accountId') != null) 
                    {
                    return ApexPages.currentPage().getparameters().get('accountId');
                    }
                else {return null;}
                }
            else
                {
                return acct.Id;
                }
        }
        set; 
//        { 
//            if(value != null) accountId = value;
//        }
    }
    
    /* The case object set by the getCase method and used by the getHistories method to acquire
       the related records.  */
    private Account a { 
        get { return getAccount(); }
//        get { return acct; }
        set; 
    }
    
    /* The length of "Short Comments" which is used by the truncateValue method in this class to
       truncate case comments when specified by the user. */
    private Integer truncatedCommentLength { get; set; }
    
    
    Boolean isCustomer = null;
    Boolean isProspect = null;

    public void determineAccountType() {
        String AccountType = '';
        isCustomer = false;
        isProspect = false;
        
        AccountType = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(a.recordTypeId);
        
        if (AccountType == 'Customer') isCustomer = true;
        if (AccountType == 'Prospect') isProspect = true;
    }

    public Boolean getisCustomer() {
        if(isCustomer==null) {determineAccountType();}
        return isCustomer;
    }

    public Boolean getisProspect() {
        if(isProspect==null) {determineAccountType();}
        return isProspect;
    }
    
    public pagereference refresh(){
      return null;
    }

    public String getAccountDetailSection_Header() {
        String result = '';
        
        result = 'for ';
        
        if (a.Type == 'Customer')
            {result += a.SAP_Customer_Number__c;}
        else
            {result += a.CIS_Prospect_Number__c;}
        
        result += ' - ' + a.Name;
            
        return result;  
    }
    
   /*
    public void logPDF(){
      audit_Log__c log = new audit_log__c(
         Audit_Note1__c = 'Create',
         Audit_Note2__c =  acct.Name,
         Object_Name__c = 'Account Plan PDF',
         Object_ID__c = Acct.Id
      );
      insert log;
    }
   
    /** Commenting as the object Audit_Log__c is going to be delete
    public static void logContactChanges(List<Contact> contacts, Map<id, Contact> oldmap){
      List<Audit_Log__c> logs = new List<Audit_Log__c>();
      for(Contact c:contacts){
        if(c.Account_Plan__c != oldmap.get(c.id).Account_Plan__c)
        {
          logs.add(new Audit_Log__c(
               Audit_Note1__c = 'Edit',
               Object_ID__c = c.id,
               Object_Name__c = 'Account Plan',
               Audit_Note2__c = 'Key Contact changed from ' + c.Account_Plan__c + ' to ' + oldmap.get(c.id).account_plan__c
          ));
        }
      }
      if(logs.size() > 0)
        insert logs;
    
    }
    
    public static void logAccountChanges(List<Account> accounts, Map<Id, Account> oldmap){
      
      List<Audit_Log__c> logs = new List<Audit_Log__c>();
      List<String> fields = new List<String>{
      'Tarnell__c',
      'LOB_Synergies__c',
      'Executive_Overview__c',
      'Comments_Gain_Loss__c'

      };
      MAP<String,Schema.SObjectField> fmap = Schema.sObjectType.Account.fields.getMap();
      Map<String,Schema.DescribeFieldResult> dmap = new Map<String, Schema.DescribeFieldResult>();
      
      for(string f:fields){
        dmap.put(f, fmap.get(f).getDescribe());
      }
      
      for(Account a:Accounts){
        for(string f:fields){
          if(a.get(f) != oldmap.get(a.id).get(f)){
            logs.add(new Audit_log__c(
               Audit_Note1__c = 'Edit',
               Object_ID__c = a.id,
               Object_Name__c = 'Account Plan',
               Audit_Note2__c = dmap.get(f).getLabel() + ' updated.'
            ));
          }//end if
        }//end for
      }//end for
      
      if(logs.size() > 0)
        insert logs;
    } **/
//Adding as the logic to use the Account Figure was removed
    public String PFYTD_Label { 
        get{if ((PFYTD_StartDate != null) && (PFYTD_EndDate != null))
            return 'PFYTD (' + MonthLabels.get(PFYTD_StartDate.month()) + '-' + PFYTD_StartDate.year() + ' - ' + MonthLabels.get(PFYTD_EndDate.month()) + '-' + PFYTD_EndDate.year() + ')';
        else return '';
        }
    }
    public String CFYTD_Label { 
        get{if ((CFYTD_StartDate != null) && (CFYTD_EndDate != null)) 
            return 'CFYTD (' + MonthLabels.get(CFYTD_StartDate.month()) + '-' + CFYTD_StartDate.year() + ' - ' + MonthLabels.get(CFYTD_EndDate.month()) + '-' + CFYTD_EndDate.year() + ')';
        else return '';
        } 
    }

    public String CFYTDvsPFYTD_Label { 
        get{
            return 'CFYTD vs PFYTD Variance';
        } 
    }
    
   @TestVisible private String styleNumber(Double num)
        {
        String result = '';
        if(num == 0.0) {result='text-align:center;';}
        else if (num < 0.0) {result='color:red;';}          
        return result;          
        }

   @TestVisible private String styleNumber(Decimal num)
        {
        String result = '';
        if(num == 0.0) {result='text-align:center;';}
        else if (num < 0.0) {result='color:red;';}          
        return result;          
        }

   @TestVisible private String styleNumber(Integer num)
        {
        String result = '';
        if(num == 0) {result='text-align:center;';}
        else if (num < 0) {result='color:red;'; }       
        return result;          
        }    

    public String FYTD_Volume_in_LB_style { get{return styleNumber(CFYTD_VolumeLB);} }     
    public String FYTD_Volume_in_KG_style { get{return styleNumber(CFYTD_VolumeKG);} }          
    public String FYTD_Amount_style { get{return styleNumber(CFYTD_Amount);} }         
    public String PFYTD_Volume_in_LB_style { get{return styleNumber(PFYTD_VolumeLB);} }     
    public String PFYTD_Volume_in_KG_style { get{return styleNumber(PFYTD_VolumeKG);} }         
    public String PFYTD_Amount_style { get{return styleNumber(PFYTD_Amount);} }     
    public String FYTDvsPFYTD_Volume_in_LB_Variance_style { get{return styleNumber(Volume_in_LB_Variance);} }     
    public String FYTDvsPFYTD_Volume_in_KG_Variance_style { get{return styleNumber(Volume_in_KG_Variance);} }         
    public String FYTDvsPFYTD_Amount_Variance_style { get{return styleNumber(FYTDvsPFYTD_Amount_Variance );} }     

private Double Volume_in_LB_Variance { get{if (( CFYTD_VolumeLB == null) || (PFYTD_VolumeLB == null)) {return null;} 
                                                           else {return CFYTD_VolumeLB - PFYTD_VolumeLB;} } }  
                                                           
    public String FYTDvsPFYTD_Volume_in_LB_Direction{ get{if (Volume_in_LB_Variance == null) {return 'null';}
                                                     else if (Volume_in_LB_Variance > 0.0) {return 'up';}
                                                     else if (Volume_in_LB_Variance < 0.0) {return 'down';} else {return 'equal';}} }    
    
        private Double Volume_in_KG_Variance{ get{if (( CFYTD_VolumeKG == null) || (PFYTD_VolumeKG == null)) {return null;} 
                                                           else {return CFYTD_VolumeKG - PFYTD_VolumeKG ;} } }
                                             
    public String CFYTDvsPFYTD_Volume_in_KG_Direction{ get{if (Volume_in_KG_Variance == null) {return 'equal';}
                                             else if (Volume_in_KG_Variance > 0.0) {return 'up';}
                                             else if (Volume_in_KG_Variance< 0.0) {return 'down';} else {return 'equal';}} }

        private Double FYTDvsPFYTD_Amount_Variance { get{if (( CFYTD_Amount == null) || (PFYTD_Amount == null)) {return null;} 
                                                           else {return CFYTD_Amount - PFYTD_Amount;} } }
    public String FYTDvsPFYTD_Amount_Direction{ get{if (FYTDvsPFYTD_Amount_Variance == null) {return 'null';}
                                               else if (FYTDvsPFYTD_Amount_Variance > 0.0) {return 'up';}
                                               else if (FYTDvsPFYTD_Amount_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    
        public String PFYTD_Volume_in_LB_formatted { get{return format_Volume(PFYTD_VolumeLB,'LB');} }     
    public String PFYTD_Volume_in_KG_formatted { get{return format_Volume(PFYTD_VolumeKG,'KG');} }  
    public String FYTD_Volume_in_LB_formatted { get{return format_Volume(CFYTD_VolumeLB,'LB');} }     
    public String FYTD_Volume_in_KG_formatted { get{return format_Volume(CFYTD_VolumeKG,'KG');} }     
    public String CFYTD_Amount_formatted { get{return format_Amount(CFYTD_Amount,Currncy);} }
    public String PFYTD_Amount_formatted { get{return format_Amount(PFYTD_Amount,Currncy);} }
    public String FYTDvsPFYTD_Volume_in_LB_Variance_formatted { get{return format_Volume(Volume_in_LB_Variance,'LB');} }     
    public String FYTDvsPFYTD_Volume_in_KG_Variance_formatted { get{return format_Volume(Volume_in_KG_Variance,'KG');} } 
public String FYTDvsPFYTD_Amount_Variance_formatted { get{return format_Amount(FYTDvsPFYTD_Amount_Variance ,Currncy);} } 

   @TestVisible private String format_Volume(Double valueIn, String uom) {
        String result = '';
        if (valueIn != null)
            {
            result = Math_Functions.formatNumber(valueIn,0,true,true);
            if (result != '0') {result += ' ' + uom;} else {result = '-';}
            }
        return result;
        
    }
        
   @TestVisible private String format_Amount(Decimal valueIn, String curr) {
        String result = '';
        if (valueIn != null)
            {
            result = Math_Functions.formatNumber(valueIn.doubleValue(),0,true,true);
            if (result != '0') {result += ' ' + curr;} else {result = '-';}
            }
        return result;
    }
    
    public Boolean CFYTDvsPFYTD_Volume_in_KG_Up { get{if (CFYTDvsPFYTD_Volume_in_KG_Direction=='up') {return true;} else {return false;}}}                                                    
        public Boolean CFYTDvsPFYTD_Volume_in_KG_Down { get{if (CFYTDvsPFYTD_Volume_in_KG_Direction=='down') {return true;} else {return false;}}}             
    public Boolean FYTDvsPFYTD_Volume_in_LB_Up { get{if (FYTDvsPFYTD_Volume_in_LB_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Volume_in_LB_Down { get{if (FYTDvsPFYTD_Volume_in_LB_Direction=='down') {return true;} else {return false;}}}   

    public Boolean FYTDvsPFYTD_Amount_Up { get{if (FYTDvsPFYTD_Amount_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Amount_Down { get{if (FYTDvsPFYTD_Amount_Direction=='down') {return true;} else {return false;}}}        
//******************
//Test Method 
//******************

    static testMethod void TestMe() {
    
        //Account testAcct = new Account(Name='TestAccount');
        //insert testAcct;
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        Id RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Distribution Customer').getRecordTypeId();
   Account testacct = new Account(Name = 'Test',RecordtypeId=RecordTypeId,SAP_Sales_Org__c = 'Test', SAP_DivisionCode__c = 'Test', SAP_Industry_Key__c ='Test',HQ_Sales_Office__c = 'Test', SAP_SalesGroup__c = 'Test');
   insert testacct;
        Map<Id, Contact> idConMap = new Map<Id, Contact>();
        Map<ID, Account> oldmap = new  Map<ID, Account>();
         List<Account> accl = new List<Account>();
       // Id contractRecordTypeId = RecordType_Functions.LookupRecordTypeId('CDF','Contract');
        
        try {
            testAcct = [SELECT Id, Name,SAP_Industry_Key_Desc__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, 
                       SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, OwnerID, Owner.Name, RecordTypeId, RecordType.Name, Type, SAP_Sales_Org__c, SAP_DivisionCode__c, 
                       (SELECT Id, Salutation, FirstName, LastName, WV_Contact_Status__c, Title, Phone, Fax, Email, OwnerId, Owner.Name, CreatedDate FROM Contacts ORDER BY LastName ASC, FirstName ASC, CreatedDate DESC),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from ActivityHistories limit 100)
                        FROM Account limit 1];
                   
        String accountid = testacct.id;      
               
        List<Opportunity> lstopp= [SELECT Id, Name, Amount, Probability, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunity where AccountId = :accountId ORDER BY CloseDate DESC];
        List<Opportunity> lstopp1= [SELECT Id, Name, Amount, Probability, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunity where AccountId = :accountId and StageName='5. Closed - Won' and CloseDate=THIS_FISCAL_YEAR ORDER BY CloseDate DESC];
        List<Nexeo_Competitor_to_Account__c> lstcompetitior=[SELECT Id, Account__c,Nexeo_Competitor__r.Name,Nexeo_Competitor__c,Comments__c FROM Nexeo_Competitor_to_Account__c where Account__c = :accountId ORDER BY CreatedDate DESC];
        List<Supplier_to_Account__c> lstsupplier=[SELECT Id, Account__c,Supplier__r.Name,Supplier__c,Comments__c FROM Supplier_to_Account__c where Account__c = :accountId ORDER BY CreatedDate DESC];
                  
        } catch(Exception e) {}
        
        if (testAcct == null) {return;} 
        
        Contact testContact = new Contact();
        testContact.FirstName= 'Chandra';
        testContact.Lastname = 'Test';
        testContact.Role__c='Accounting';
        testContact.WV_Contact_Status__c = 'Active';
        testContact.AccountId = testAcct.id;
        testContact.No_Email__c=false;
        testContact.Email='abc@gmail.com';
        insert testContact;
        
        Contact testContact2 = new Contact();
        testContact2.FirstName= 'Chandra';
        testContact2.Lastname = 'Test 2';
        testContact2.WV_Contact_Status__c = 'Inactive';
        testContact2.AccountId = testAcct.id;
        testContact2.No_Email__c=true;
        insert testContact2;

        Task testTask = new Task();
        testTask.Whatid = testAcct.Id;
        testTask.Type = 'Email';
        testTask.Description = 'Test';
        testTask.ActivityDate = System.today();
        insert testTask;

        Date Yesterday = System.today().addDays(-1);

        Task testTask2 = new Task();
        testTask2.Whatid = testAcct.Id;
        testTask2.Type = 'Email';
        testTask2.Description = 'Test';
        testTask2.ActivityDate = Yesterday;
        insert testTask2;

        Date Tomorrow = System.today().addDays(-1);

        Task testTask3 = new Task();
        testTask3.Whatid = testAcct.Id;
        testTask3.Type = 'Email';
        testTask3.Description = 'Test';
        testTask3.ActivityDate = Tomorrow;
        insert testTask3;

        Event testEvent = new Event();
        testEvent.Whatid = testAcct.Id;
        testEvent.Type = 'Email';
        testEvent.Total_Hours__c = 1;
        testEvent.DurationInMinutes = 59;
        testEvent.ActivityDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 0, 0);
        testEvent.StartDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 0, 0);
        testEvent.EndDateTime = DateTime.newInstance(System.today().year(),System.today().month(),System.today().day(), 0, 59, 0);
        testEvent.Description = 'Test';
        insert testEvent;
        
        date a = System.today();
        date b = System.today()+2;
        
       
        Account_Sales_Figure__c asf = new Account_Sales_Figure__c(Account__c = testAcct.id,Start_Date__c=a,End_Date__c=b,key__c = '1234567890');
        insert asf;
        
        Account_Sales_Summary__c aSalesSummary = new Account_Sales_Summary__c();
          aSalesSummary.CurrencyIsoCode = 'USD';
            aSalesSummary.Date_Range_Label__c = 'FYTD/PFYTD';
            aSalesSummary.Current_Fiscal_Beginning_Period__c = date.parse('10/1/2018');
            aSalesSummary.Current_Fiscal_Ending_Period__c = date.parse('7/1/2019');
            aSalesSummary.Current_Fiscal_Net_Revenue__c = 52398.27;
            aSalesSummary.Current_Fiscal_Quantity_KGs__c = 7499.04;
            aSalesSummary.Current_Fiscal_Quantity_LBs__c = 16532.564;
            aSalesSummary.Current_FYTD_Begin_Date__c = date.parse('10/1/2018');
            aSalesSummary.Current_FYTD_End_Date__c = date.parse('7/31/2019');
            aSalesSummary.Previous_Fiscal_Beginning_Period__c = date.parse('10/1/2017');
            aSalesSummary.Previous_Fiscal_Ending_Period__c = date.parse('7/1/2018');
            aSalesSummary.Previous_Fiscal_Net_Revenue__c = 140347.62;
            aSalesSummary.Previous_Fiscal_Quantity_KGs__c = 23538.624;
            aSalesSummary.Previous_Fiscal_Quantity_LBs__c = 51893.814;
            aSalesSummary.Previous_FYTD_Begin_Date__c = date.parse('10/1/2017');
            aSalesSummary.Previous_FYTD_End_Date__c = date.parse('7/31/2018');  
        	aSalesSummary.key__c = '76689';
            aSalesSummary.Account__c = testacct.id;
            insert aSalesSummary;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        AccntPlan cls = new AccntPlan(sc);
       
        String testString = '';
		String labelCFYTD = cls.CFYTD_Label;
        Boolean booleanFYTDvsPFYTD_Volume_in_LB_Up = cls.FYTDvsPFYTD_Volume_in_LB_Up;
        Boolean booleanFYTDvsPFYTD_Volume_in_LB_Down= cls.FYTDvsPFYTD_Volume_in_LB_Down;
        String labelFYTD_Volume_in_LB_style= cls.FYTD_Volume_in_LB_style;
        Boolean booleanCFYTDvsPFYTD_Volume_in_KG_Up = cls.CFYTDvsPFYTD_Volume_in_KG_Up;
        Boolean booleanCFYTDvsPFYTD_Volume_in_KG_Down= cls.CFYTDvsPFYTD_Volume_in_KG_Down;
        String labelFYTD_Volume_in_KG_style = cls.FYTD_Volume_in_KG_style;
        Boolean booleanFYTDvsPFYTD_Amount_Up = cls.FYTDvsPFYTD_Amount_Up;
        Boolean booleanFYTDvsPFYTD_Amount_Down = cls.FYTDvsPFYTD_Amount_Down;
        String labelFYTD_Amount_style =  cls.FYTD_Amount_style;
		String labelPFYTD_Volume_in_LB_formatted = cls.PFYTD_Volume_in_LB_formatted;     
    	String labelPFYTD_Volume_in_KG_formatted = cls.PFYTD_Volume_in_KG_formatted;
    	String labelFYTD_Volume_in_LB_formatted = cls.FYTD_Volume_in_LB_formatted;  
    	String labelFYTD_Volume_in_KG_formatted = cls.FYTD_Volume_in_KG_formatted;   
    	String labelCFYTD_Amount_formatted = cls.CFYTD_Amount_formatted; 
    	String labelPFYTD_Amount_formatted = cls.PFYTD_Amount_formatted; 
    	String labelFYTDvsPFYTD_Volume_in_LB_Variance_formattede = cls.FYTDvsPFYTD_Volume_in_LB_Variance_formatted;     
    	String labelFYTDvsPFYTD_Volume_in_KG_Variance_formatted = cls.FYTDvsPFYTD_Volume_in_KG_Variance_formatted;
		String labelFYTDvsPFYTD_Amount_Variance_formatted = cls.FYTDvsPFYTD_Amount_Variance_formatted;     


        //cls.logPDF();
        PageReference testPageReference2 = cls.Printable_View();
        
        Account testAcct2 = cls.getAccount();
        

        
        List<Opportunity> testOpp = cls.getOpportunities();
        List<Opportunity> testOpp1 = cls.getclosedOpportunities();
        List<Nexeo_Competitor_to_Account__c> testcomp = cls.getCompetitor();
        List<Supplier_to_Account__c> testsuppl = cls.getSupplier(); 
                       
        Contact[] testContacts = cls.getContactstoDisplay();
  
        Boolean testBoolean = cls.getisCustomer();
        testBoolean = cls.getisProspect();
        
        //testString = cls.getAccountAddress();
        testString = cls.getAccountDetailSection_Header();

        cls.getAccountSummaryInformation();
        //cls.getFYTDvsPFYTD_Amount_Down();
       // cls.getFYTDvsPFYTD_Amount_Up();
        cls.getFYTDvsPFYTD_GM_Down();
        cls.getFYTDvsPFYTD_GM_Up();
        cls.getFYTDvsPFYTD_GMpct_Down();
        cls.getFYTDvsPFYTD_GMpct_Up();
        //cls.getFYTDvsPFYTD_Volume_in_KG_Down();
        //cls.getFYTDvsPFYTD_Volume_in_KG_Up();
        //cls.getFYTDvsPFYTD_Volume_in_LB_Down();
        //cls.getFYTDvsPFYTD_Volume_in_LB_Up();
        cls.printable_view();



        cls.rerendercon();
        cls.rerenderOpp();
        cls.rerenderOpp1();
        cls.contentType = 'test';
        cls.refresh();
        /*
        AccntPlan.logAccountChanges(accl,oldmap);
        
       List<Audit_Log__C> logs = new LIst<Audit_Log__c>();
       List<Contact> con1 = new List<Contact>();  
       
       String objectName = 'Account Plan PDF';
       String objectId   = 'testAcct.id';
       String auditNote2 = 'PDF Generated for Account';


     Audit_Log__c log = new Audit_Log__c(object_id__c = objectId,
           object_name__C = objectName,audit_note2__c=auditNote2, 
           audit_note1__c = 'Create' );
     logs.add(log);
     
     insert logs;     
      
     
     idConMap.put(testContact.id,testContact);
          idConMap.put(testContact2.id,testContact2);
     
     con1.add(testContact);
     con1.add(testContact2);
     
     AccntPlan.logContactChanges(con1,idConMap);
        */
        
    }

}