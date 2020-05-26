public class SCPR{

    public static final Set<String> LOG_A_CALL_TASK_TYPES = new Set<String> {
        'Email',
        'Entertainment',
        'Fax',
        'Follow Up',
        'Inquiry',
        'Mailing',
        'Meeting',
        'Other',
        'Phone Call',
        'Physical',
        'Project',
        'Sales Call',
        'Technical Service Call',
        'Trial'
    };
    //Start Account Summary Info
    public Account_Summary_Information accountSummaryInformation = new Account_Summary_Information();
    public List<Account_Sales_Figure__c> acctSalesFigures;
    public List<Account_Sales_Summary__c> acctSalesSummary{get; set;}
    public string fid;
    public list<document> docs{get; set;}
    public boolean renderdocs{get; set;}
    //added by annes on 21 oct 2011
    transient public List<Task> lstTask {get; set;}
    transient public List<Event> lstevent {get; set;}
    transient public List<opportunity> lstopp {get; set;}
    transient public List<Contract> lstcontract{get; set;}
    transient public List<Sample_Request__c> lstsmplrqst{get; set;}
    transient public List<Consumption__c> lstconsumption{get; set;}
    transient public List<Call_Report__c> lstcallreport{get; set;}
    transient public List<Opportunity_Call_Report__c> lstcallreportNotes{get; set;}
    transient public List<Sample_Material__c> lstSampMat{get;set;}
    public List<openactivity> lstopenactivity{get; set;}
    public List<activityhistory> lstacthistory{get; set;}
    transient public List<Open_Orders__c> lstopenorder{get; set;}
    transient public List<Business_Contract__c> lstbuscontract{get; set;}
    transient public List<Price_Request_Transaction__c> lstPRT{get;set;}
    //End added by Annes
    
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
    
    public Account_Summary_Information getAccountSummaryInformation() {
      return accountSummaryInformation;
    }
        public Boolean getFYTDvsPFYTD_Volume_in_LB_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_LB_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Down;}
    public Boolean getFYTDvsPFYTD_Volume_in_KG_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_KG_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Down;}
    public Boolean getFYTDvsPFYTD_Amount_Up() {return accountSummaryInformation.FYTDvsPFYTD_Amount_Up;}
    public Boolean getFYTDvsPFYTD_Amount_Down() {return accountSummaryInformation.FYTDvsPFYTD_Amount_Down;}
    public Boolean getFYTDvsPFYTD_GM_Up() {return accountSummaryInformation.FYTDvsPFYTD_GM_Up;}
    public Boolean getFYTDvsPFYTD_GM_Down() {return accountSummaryInformation.FYTDvsPFYTD_GM_Down;}
    public Boolean getFYTDvsPFYTD_GMpct_Up() {return accountSummaryInformation.FYTDvsPFYTD_GMpct_Up;}
    public Boolean getFYTDvsPFYTD_GMpct_Down() {return accountSummaryInformation.FYTDvsPFYTD_GMpct_Down;}
    //End Account Summary Info
    /* Property value that controls the truncation of comments */
    public boolean Contacts_ShowInactive { get; private set; }
    public boolean OpenActivities_FullComments { get; private set; }
    public String  OpenActivities_NextXDays { get; set; }
    public boolean CallReports_FullComments { get; private set; }
    public string Acct_team{get;set;}
    public String  CallReports_LastXDays { get; set; }
    public boolean CallReports_LimittoOwner { get; set; }
    public String  Call_Reports_LastXDays { get; set; }
    public boolean Call_Reports_LimittoOwner { get; set; }
    public String  Opportunities_Stage { get; set; }
    public List<Contract> conList {get;set;} 
    public List<ID> conListIds = new List<ID>();
    public Integer countName {get;set;}
    public Integer countStatus {get;set;}
    public Integer countCSP{get;set;}
    public Boolean isSortByStatus {get;set;}
    public Boolean isSortByName {get;set;}
    public String selectedStatus {get;set;}
    public String businessName {get;set;}
    public Boolean isDistribution {get;set;}
    public Boolean isPerformanceMaterials {get;set;}
    public Boolean isValvoline {get;set;}
    public Boolean isWater {get;set;}
    public Boolean isAqualon {get;set;}
    public boolean isNorthAmerica {get; set;}
    public boolean isES{get; set;}
    public boolean isCSP{get; set;}
    public String  OpenOrders_NextXDays { get; set; }
    public String  Contacts_Type { get; set; }
    public String  ContactsActStat { get; set; }
    public String  BusinessContracts { get; set; }
    public String  SampleRequest_LastXDays { get; set; }
    public String  OrderHistory{ get; set; }
    public String  CSPSelect{ get; set; }
    
    public boolean volumeLBUp{get;set;}
    public boolean volumeLBDown{get;set;}
    public boolean volumeKGUp{get;set;}
    public boolean volumeKGDown{get;set;}
    public boolean AmountUp{get;set;}   
    public boolean AmountDown{get;set;}  
    
    public Boolean renderSR{get;set;}
    public Boolean renderOA{get;set;}
    public Boolean renderCL{get;set;}
    public Boolean renderCR{get;set;}
    public Boolean renderOPP{get;set;}
    public Boolean renderOO{get;set;}
    public Boolean renderCSP{get;set;}
    public Boolean renderCon{get;set;}
    public Boolean renderBusCon{get;set;}
    public Boolean renderOH{get;set;}
    
    
    public Boolean NotIncludeCR{get;set;}
    public Boolean NotIncludeOO{get;set;}
    public Boolean NotIncludeOP{get;set;}
    public Boolean NotIncludeOH{get;set;}
    public Boolean NotIncludeSR{get;set;}
    public Boolean NotIncludeBC{get;set;}
    public Boolean NotIncludeCL{get;set;}
    public Boolean NotIncludeCSP{get;set;}
    public Boolean NotIncludeOA{get;set;}
    public Boolean NotIncludeCA{get;set;}
    public Boolean NotIncludeCDF{get;set;}
   
    public boolean ClosedActivities_FullComments { get; private set; }
    public String  ClosedActivities_NextXDays { get; set; }
    public Boolean renderCA{get;set;}
    public String  contentType{get;set;}
    
    public decimal AmountDiff{get;set;}
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
        
    private final Account acct;
    
    private Double Volume_in_KG_Variance{ get{if (( CFYTD_VolumeKG == null) || (PFYTD_VolumeKG == null)) {return null;} 
                                                           else {return CFYTD_VolumeKG - PFYTD_VolumeKG ;} } }
                                             
    public String CFYTDvsPFYTD_Volume_in_KG_Direction{ get{if (Volume_in_KG_Variance == null) {return 'equal';}
                                             else if (Volume_in_KG_Variance > 0.0) {return 'up';}
                                             else if (Volume_in_KG_Variance< 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean CFYTDvsPFYTD_Volume_in_KG_Up { get{if (CFYTDvsPFYTD_Volume_in_KG_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean CFYTDvsPFYTD_Volume_in_KG_Down { get{if (CFYTDvsPFYTD_Volume_in_KG_Direction=='down') {return true;} else {return false;}}}             
          
    private Double Volume_in_LB_Variance { get{if (( CFYTD_VolumeLB == null) || (PFYTD_VolumeLB == null)) {return null;} 
                                                           else {return CFYTD_VolumeLB - PFYTD_VolumeLB;} } }  
                                                           
    public String FYTDvsPFYTD_Volume_in_LB_Direction{ get{if (Volume_in_LB_Variance == null) {return 'null';}
                                                     else if (Volume_in_LB_Variance > 0.0) {return 'up';}
                                                     else if (Volume_in_LB_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_Volume_in_LB_Up { get{if (FYTDvsPFYTD_Volume_in_LB_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Volume_in_LB_Down { get{if (FYTDvsPFYTD_Volume_in_LB_Direction=='down') {return true;} else {return false;}}}                                                    

    private Double FYTDvsPFYTD_Amount_Variance { get{if (( CFYTD_Amount == null) || (PFYTD_Amount == null)) {return null;} 
                                                           else {return CFYTD_Amount - PFYTD_Amount;} } }
    public String FYTDvsPFYTD_Amount_Direction{ get{if (FYTDvsPFYTD_Amount_Variance == null) {return 'null';}
                                               else if (FYTDvsPFYTD_Amount_Variance > 0.0) {return 'up';}
                                               else if (FYTDvsPFYTD_Amount_Variance < 0.0) {return 'down';} else {return 'equal';}} }
    public Boolean FYTDvsPFYTD_Amount_Up { get{if (FYTDvsPFYTD_Amount_Direction=='up') {return true;} else {return false;}}}                                                    
    public Boolean FYTDvsPFYTD_Amount_Down { get{if (FYTDvsPFYTD_Amount_Direction=='down') {return true;} else {return false;}}}                                                    
                                                       
                                                           
    // The extension constructor initializes the private member
    // variable \by using the getRecord method from the standard
    // controller.
    public SCPR(ApexPages.StandardController stdController) {
        this.acct = (Account)stdController.getRecord();
        docs = new list<document>();
        fid = apexpages.currentpage().getparameters().get('fid');
        if(fid == null){fid = '';}
        docs = [select url, name from document where folderid = :fid];
        renderdocs = (fid.length() > 0);
        

        //start Account Summary Information
     /*                   acctSalesFigures = [SELECT 
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
          }*/
        
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
                        
              
        /*
        CFYTD_VolumeKG = acctSalesSummary[0].Current_Fiscal_Quantity_KGs__c;
        CFYTD_VolumeLB = acctSalesSummary[0].Current_Fiscal_Quantity_LBs__c;
        PFYTD_VolumeKG = acctSalesSummary[0].Previous_Fiscal_Quantity_KGs__c;
        PFYTD_VolumeLB = acctSalesSummary[0].Previous_Fiscal_Quantity_LBs__c;
        CFYTD_Amount = acctSalesSummary[0].Current_Fiscal_Net_Revenue__c;
        PFYTD_Amount = acctSalesSummary[0].Previous_Fiscal_Net_Revenue__c;
        */
        //end Account Summary Information
        Contacts_ShowInactive        = false;
        OpenActivities_FullComments  = false;
        OpenActivities_NextXDays     = '30';
        CallReports_FullComments     = false;
        CallReports_LastXDays        = '90';
        CallReports_LimittoOwner     = false;
        Call_Reports_LastXDays       = '90';
        Call_Reports_LimittoOwner    = false;
        truncatedCommentLength       = 100;
        Opportunities_Stage          = 'All';
        OpenOrders_NextXDays         = 'All Open';
        Contacts_Type               = 'All';
        SampleRequest_LastXDays      = 'ALL';
        contentType = '';
        ClosedActivities_FullComments  = false;
        ClosedActivities_NextXDays     = '30';
        ContactsActStat                = 'All';
        BusinessContracts              = 'All';
//      OrderHistory                   = 'All';
        OrderHistory                   = '30'; 
        CSPSelect                       = 'All';
        renderSR = true;
        renderOA = true;
        renderCL = true;
        renderCR = true;
        renderOPP = true;
        renderOO = true;
        renderCSP = true;
        renderCA = true;
        renderCon = True;
        renderBusCon = true;
        renderOH = true;
        
        
        NotIncludeOO = true;
        NotIncludeOH = true; 
        NotIncludeOA = true; 
        NotIncludeCA = true; 
        NotIncludeOP = true; 
        NotIncludeCSP = true; 
        NotIncludeBC = true; 
        NotIncludeCR = true; 
        NotIncludeCL = true; 
        NotIncludeSR = true;      
        NotIncludeCDF = true;


        if(ApexPages.currentPage().getparameters().get('c_si') != null) 
            {if (ApexPages.currentPage().getparameters().get('c_si') == 'true') {Contacts_ShowInactive=true;} else {Contacts_ShowInactive=false;}}

        if(ApexPages.currentPage().getparameters().get('oa_fc') != null) 
            {if (ApexPages.currentPage().getparameters().get('oa_fc') == 'true') {OpenActivities_FullComments=true;} else {OpenActivities_FullComments=false;}}
            
        if(ApexPages.currentPage().getparameters().get('oa_nxd') != null) 
            {OpenActivities_NextXDays = ApexPages.currentPage().getparameters().get('oa_nxd');}

        if(ApexPages.currentPage().getparameters().get('cr_fc') != null) 
            {if (ApexPages.currentPage().getparameters().get('cr_fc') == 'true') {CallReports_FullComments=true;} else {CallReports_FullComments=false;}}

        if(ApexPages.currentPage().getparameters().get('cr_lxd') != null) 
            {CallReports_LastXDays = ApexPages.currentPage().getparameters().get('cr_lxd');}
            
       if(ApexPages.currentPage().getparameters().get('opp_stage') != null) 
            {Opportunities_Stage = ApexPages.currentPage().getparameters().get('opp_stage');}

        if(ApexPages.currentPage().getparameters().get('cr_lto') != null) 
            {if (ApexPages.currentPage().getparameters().get('cr_lto') == 'true') {CallReports_LimittoOwner=true;} else {CallReports_LimittoOwner=false;}}
        
        if(ApexPages.currentPage().getparameters().get('c_r_lto') != null) 
            {if (ApexPages.currentPage().getparameters().get('c_r_lto') == 'true') {Call_Reports_LimittoOwner=true;} else {Call_Reports_LimittoOwner=false;}}
            
         if(ApexPages.currentPage().getparameters().get('Op_Order_NXdays') != null) 
            {
                OpenOrders_NextXDays = ApexPages.currentPage().getparameters().get('Op_Order_NXdays');
            }
            
         
       /* public void getAccountOwner(){
        Acct_team = ApexPages.currentPage().getparameters().get('acTeam');
        //List<Account> acc = [select id,name,AccountType,CIS_Prospect_Number__c,]
        }*/
         
        if(ApexPages.currentPage().getparameters().get('acTeam') != null) 
            {
                Acct_team = ApexPages.currentPage().getparameters().get('acTeam');
            } 
         
        if(ApexPages.currentPage().getparameters().get('Order_His_NXdays') != null) 
            {
                OrderHistory = ApexPages.currentPage().getparameters().get('Order_His_NXdays');
            }

        
        if(ApexPages.currentPage().getparameters().get('Cs_type') != null) 
            {
                Contacts_Type = ApexPages.currentPage().getparameters().get('Cs_type');
            }

        
            
        if(ApexPages.currentPage().getparameters().get('Sa_req__LXdays') != null) 
            {
                SampleRequest_LastXDays = ApexPages.currentPage().getparameters().get('Sa_req__LXdays');
            }
        if(ApexPages.currentPage().getparameters().get('ca_fc') != null) 
            {if (ApexPages.currentPage().getparameters().get('ca_fc') == 'true') {ClosedActivities_FullComments=true;} else {ClosedActivities_FullComments=false;}}        
        if(ApexPages.currentPage().getparameters().get('rn_sr') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_sr') == 'true') {renderSR=true;} else {renderSR=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_OA') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OA') == 'true') {renderOA=true;} else {renderOA=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_CL') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_CL') == 'true') {renderCL=true;} else {renderCL=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_CR') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_CR') == 'true') {renderCR=true;} else {renderCR=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_OPP') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OPP') == 'true') {renderOPP=true;} else {renderOPP=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_OO') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OO') == 'true') {renderOO=true;} else {renderOO=false;}}
         if(ApexPages.currentPage().getparameters().get('rn_CSP') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_CSP') == 'true') {renderCSP=true;} else {renderCSP=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_con') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_con') == 'true') {rendercon=true;} else {rendercon=false;}}
        if(ApexPages.currentPage().getparameters().get('rn_buscon') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_buscon') == 'true') {renderbuscon=true;} else {renderbuscon=false;}}
            
        

        if(ApexPages.currentPage().getparameters().get('rn_OH') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_OH') == 'true') {renderOH=true;} else {renderOH=false;}}
        if(ApexPages.currentPage().getparameters().get('dwnld_exl') != null) 
            {if (ApexPages.currentPage().getparameters().get('dwnld_exl') == 'true') {contentType ='application/vnd.ms-excel#test.xls';} else {contentType = '';}}
        if(ApexPages.currentPage().getparameters().get('rn_CA') != null) 
            {if (ApexPages.currentPage().getparameters().get('rn_CA') == 'true') {renderCA=true;} else {renderCA=false;}}
        conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract WHERE AccountId = :acct.Id ORDER BY EndDate DESC];
        for(Integer i=0;i<conList.size();i++)
            conListIds.add(conList[i].Id);
        countName = 0;
        countStatus = 0;
        selectedStatus = 'All';
    }

   @TestVisible private Boolean isLogCallType(String t) {
        return (t == null || t == '' || LOG_A_CALL_TASK_TYPES.contains(t));
    }

    /* Returns string value with respect to Active and Inactive contects*/
    public String getContacts_Desc() {
        String result = '';
        
        if (Contacts_ShowInactive == true)
            {result = '(Includes Active and Inactive Contacts)';}
        
        return result;
    }    
    
    /* Returns string value which contains date range. */
    public String getOpenActivities_Desc()
    {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        if(OpenActivities_NextXDays =='Not Include'){
            NotIncludeOA = false;
            return null;
        }
        else{
            startDate = String.ValueOf(System.today());
            endDate = String.ValueOf(System.today().addDays((Integer.valueOf(OpenActivities_NextXDays) * 1)));
            
            result = '(Date Range = ' + startDate + ' - ' + endDate + ')';
            
            return result;
        }
        
    }

    /* Returns string value which contains date range. */
        public String Activities_Desc()
    {
        String result = '';
        String startDate = '';
        String endDate = '';
        if(closedActivities_NextXDays=='Not Include'){
            NotIncludeCA = false;
            return null;
        }
        else{
            startDate = String.ValueOf(System.today());
            endDate = String.ValueOf(System.today().addDays((Integer.valueOf(closedActivities_NextXDays) * 1)));
            
            result = '(Date Range = ' + startDate + ' - ' + endDate + ')';
            
            return result;
        }
        
    }
    
    /* Returns string value which contains date on basis of current date and the selected value of dropdown for Call Reports
       and Call report limit.*/
    public String getCallReports_Desc() {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        if(CallReports_LastXDays == 'Not Include'){
            NotIncludeCR = false;
            return null;
        }
        else{
        startDate = String.ValueOf(System.today().addDays((Integer.valueOf(CallReports_LastXDays) * -1)));
        endDate = String.ValueOf(System.today());
        
        result = '(Date Range = ' + startDate + ' - ' + endDate;

        if (CallReports_LimittoOwner == true)
            {result += ' - Limited to Call Reports Created by Account Owner)';}
        else 
            {result += ')';}

        
        return result;
      }
    }
    
    public String getOppStage_Desc()
    {
        String result = '';
        result = '(Stage = ' + Opportunities_Stage + ')';
        return result;
    }
    
    public String getCDFStatus_Desc()
    {
        String result = '';
        result = '(Status = ' + selectedStatus + ')';
        return result;
    }
       
    public String getOpenOrder_Desc() {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        if (OpenOrders_NextXDays == 'All Open') {
                result = '(Status = All)';
            } else {
                endDate = String.ValueOf(System.today().addDays((Integer.valueOf(OpenOrders_NextXDays) * (1))));
                startDate = String.ValueOf(System.today());
                result = '(Date Range = ' + startDate + ' - ' + endDate + ')';
            }
            return result;
    }
    
    
    public String getOrderHistory_Desc() {
    String result = '';
        String startDate = '';
        String endDate = '';
        
        if (OrderHistory == 'All') {
                result = '(Status = All)';
            } else {
                endDate = String.ValueOf(System.today().addDays((Integer.valueOf(OrderHistory) * (-1))));
                startDate = String.ValueOf(System.today());
                result = '(Date Range = ' + endDate + ' - ' + startDate + ')';
            }
            return result;
    }
    
       
    public String getSampleRequest_Desc() {
        String result = '';
        result = '(Status = ' + SampleRequest_lastXdays + ')';
        return result;
        
    }
    
    public String getCSP_Desc() {
    String result = '';
        String startDate = '';
        String endDate = '';
        
        if (CSPSelect== 'All') {
                result = '(Status = All)';
            } else {
                endDate = String.ValueOf(System.today().addDays((Integer.valueOf(CSPSelect) * (-1))));
                startDate = String.ValueOf(System.today());
                result = '(Date Range = ' + endDate + ' - ' + startDate + ')';
            }
            return result;
    }
    
    public String getCnct_Desc() {
        String result = '';

        If (ContactsActStat=='All') {
            result = '(Status = All)';
        } else if (ContactsActStat=='Active') {
            result = '(Status = Active)';
        } else if (ContactsActStat=='Active') {
            result = '(Status = Active)';
        } else {
            result = '(Status = '+ ContactsActStat + ')';
        }        
        return result;
    }   
    
    public String getClosedActivities_Desc()
    {
        String result = '';
        String startDate = '';
        String endDate = '';
        
        startDate = String.ValueOf(System.today());
        endDate = String.ValueOf(System.today().addDays((Integer.valueOf(closedActivities_NextXDays) * -1)));
        
        result = '(Date Range = ' + endDate + ' - ' + startDate + ')';
        
        return result;
        
    }
 

    /* Action method for toggling the fullComments property */
    public void toggleContacts_ShowInactive() { Contacts_ShowInactive = !Contacts_ShowInactive; }
    public void toggleOpenActivities_FullComments() { OpenActivities_FullComments = !OpenActivities_FullComments; }
    public void toggleCallReports_FullComments() { CallReports_FullComments = !CallReports_FullComments; }
    public void toggleCallReports_LimittoOwner() { CallReports_LimittoOwner = !CallReports_LimittoOwner; }
    public void toggleCall_Reports_LimittoOwner() { Call_Reports_LimittoOwner = !Call_Reports_LimittoOwner; }
    public void toggleClosedActivities_FullComments() { ClosedActivities_FullComments = !ClosedActivities_FullComments; }

    /* Action method for navigating the user back to the case page. */
    public PageReference backToAccount() {
        return new ApexPages.StandardController(a).view();
    }

    public PageReference Printable_View() {
        PageReference result = null;    
        PageReference PrintableView = Page.Sales_Call_Prep_Report_Print;
        PrintableView.getparameters().put('accountId',accountId);
        PrintableView.getparameters().put('c_si',String.valueOf(Contacts_ShowInactive));
        PrintableView.getparameters().put('oa_fc',String.valueOf(OpenActivities_FullComments));
        PrintableView.getParameters().put('oa_nxd',OpenActivities_NextXDays);
        PrintableView.getparameters().put('cr_fc',String.valueOf(CallReports_FullComments));
        PrintableView.getparameters().put('cr_lxd',CallReports_LastXDays);
        PrintableView.getparameters().put('acTeam',String.ValueOf(Acct_team));
        PrintableView.getParameters().put('opp_stage', Opportunities_Stage);
        PrintableView.getparameters().put('cr_lto',String.valueOf(CallReports_LimittoOwner));
        PrintableView.getparameters().put('c_r_lto',String.valueOf(Call_Reports_LimittoOwner));
        PrintableView.getparameters().put('Op_Order_NXdays',String.valueOf(OpenOrders_NextXDays));  
        PrintableView.getparameters().put('Sa_req__LXdays',String.valueOf(SampleRequest_LastXDays));  
        PrintableView.getparameters().put('Cs_type',String.valueOf(Contacts_Type)); 
        PrintableView.getparameters().put('Order_His_NXdays',String.valueOf(OrderHistory));                
        
        PrintableView.getparameters().put('rn_sr',String.valueOf(renderSR));
        PrintableView.getParameters().put('rn_OA', String.valueOf(renderOA));
        PrintableView.getparameters().put('rn_CL',String.valueOf(renderCL));
        PrintableView.getparameters().put('rn_CR',String.valueOf(renderCR));
        PrintableView.getparameters().put('rn_OPP',String.valueOf(renderOPP));  
        PrintableView.getparameters().put('rn_OO',String.valueOf(renderOO)); 
        PrintableView.getparameters().put('rn_CSP',String.valueOf(renderCSP)); 
        PrintableView.getParameters().put('rn_CA', String.valueOf(renderCA));
        PrintableView.getParameters().put('rn_con', String.valueOf(rendercon));
        PrintableView.getParameters().put('rn_buscon', String.valueOf(renderbuscon));
        PrintableView.getParameters().put('rn_OH', String.valueOf(renderOH));

        result = PrintableView;
        return page.Sales_Call_Prep_Report_Print;
    
    }
    /*
    public PageReference Download_excel() {
        PageReference downloadView = Page.Contact_Report_excel;
        downloadView.getparameters().put('scontrolCaching','1');
        downloadView.getparameters().put('id',a.id);
        downloadView.getparameters().put('dwnld_exl','true');
        return downloadView;
    }*/
    
    public PageReference  reRenderSR(){
        renderSR = !(renderSR);
        return null;
    }
    
    public PageReference  reRendercon(){
        rendercon = !(rendercon);
        return null;
    }
    
    public PageReference  reRenderbuscon(){
        renderbuscon = !(renderbuscon);
        return null;
    }

    
    public PageReference  reRenderOA(){
        renderOA = !(renderOA);
        return null;
    }

    public PageReference  reRenderCA(){
        renderCA = !(renderCA);
        return null;
    }
    
    public PageReference  reRenderCL(){
        renderCL = !(renderCL);
        return null;
    }
    
    public PageReference  reRenderCR(){
        renderCR = !(renderCR);
        return null;
    }
    
    public PageReference  reRenderOpp(){
        renderOPP = !(renderOPP);
        return null;
    }
    
    public PageReference  reRenderOO(){
        renderOO = !(renderOO);
        return null;
    }
       
    
    public PageReference  reRenderCSP(){
        renderCSP = !(renderCSP);
        return null;
    }
    
    public PageReference  reRenderOH(){
        renderOH = !(renderOH);
        return null;
    }
        
    public List<SelectOption> getOpenOrders_NextXDays_items()
    {
        List<SelectOption> openActivitiesOptions = new List<SelectOption>();
        openActivitiesOptions.add(new SelectOption('All Open', 'All Open'));
        openActivitiesOptions.add(new SelectOption('30', 'Next 30 Days'));
        openActivitiesOptions.add(new SelectOption('60', 'Next 60 Days'));
        openActivitiesOptions.add(new SelectOption('90', 'Next 90 Days'));
        openActivitiesOptions.add(new SelectOption('120', 'Next 120 Days'));
        openActivitiesOptions.add(new SelectOption('180', 'Next 180 Days'));
        openActivitiesOptions.add(new SelectOption('Not Include', 'Do not Include'));
        return openActivitiesOptions;
    }
    
    
    public List<SelectOption> getAccountTeam_items()
    {
        List<SelectOption> acctTeam = new List<SelectOption>();
        /*Account ac = [select Ownerid from account where id =:'001E000000CUaXo'];
        user ur = [select name from user where id =: ac.ownerid];
        string owner = ur.name;
        acctTeam.add(new SelectOption(Owner,Owner));*/
        List<AccountTeamMember> team = [select id,userID from AccountTeamMember where AccountId =: accountID];
        set<id> usrid = new Set<id>();
        for(AccountTeamMember t: team)
            usrid.add(t.userID);
        List<user> usr = [select name from user where id in : usrid];
        for(user u: usr)
            acctTeam.add(new SelectOption(u.name, u.name));
        return acctTeam;
    }
    public List<SelectOption> getSampleRequest_LastXDays_items()
    {
        List<SelectOption> openActivitiesOptions = new List<SelectOption>();
        openActivitiesOptions.add(new SelectOption('All', 'All'));
        openActivitiesOptions.add(new SelectOption('Draft', 'Draft'));
        openActivitiesOptions.add(new SelectOption('In Approval Process', 'In Approval Process'));
        openActivitiesOptions.add(new SelectOption('Approved', 'Approved'));
        openActivitiesOptions.add(new SelectOption('Waiting for Order Creation', 'Waiting for Order Creation'));
        openActivitiesOptions.add(new SelectOption('Order Created for Sample Request', 'Order Created for Sample Request'));
        openActivitiesOptions.add(new SelectOption('Request Completed', 'Request Completed'));
        openActivitiesOptions.add(new SelectOption('Rejected', 'Rejected'));
        openActivitiesOptions.add(new SelectOption('Cancelled', 'Cancelled'));
        openActivitiesOptions.add(new SelectOption('On-Hold', 'On-Hold'));
        openActivitiesOptions.add(new SelectOption('Not Include', 'Do not Include'));
        return openActivitiesOptions;
    }
    
    public List<SelectOption> getContactsActStat_items()
    {
        List<SelectOption> openActivitiesOptions = new List<SelectOption>();
        openActivitiesOptions.add(new SelectOption('All', 'All'));
        openActivitiesOptions.add(new SelectOption('Active', 'Active'));
        openActivitiesOptions.add(new SelectOption('Inactive', 'Inactive'));        
        openActivitiesOptions.add(new SelectOption('10', 'Last 10'));
        openActivitiesOptions.add(new SelectOption('20', 'Last 20'));
        openActivitiesOptions.add(new SelectOption('50', 'Last 50'));
        openActivitiesOptions.add(new SelectOption('100', 'Last 100'));
        openActivitiesOptions.add(new SelectOption('Not Include', 'Do not Include'));
        return openActivitiesOptions;
    }
    
    public List<SelectOption> getOpenActivities_NextXDays_items()
    {
        List<SelectOption> openActivitiesOptions = new List<SelectOption>();
        openActivitiesOptions.add(new SelectOption('30', 'Next 30 Days'));
        openActivitiesOptions.add(new SelectOption('90', 'Next 90 Days'));
        openActivitiesOptions.add(new SelectOption('183', 'Next 6 Months'));
        openActivitiesOptions.add(new SelectOption('365', 'Next 12 Months'));
        openActivitiesOptions.add(new SelectOption('Not Include', 'Do not Include'));
        return openActivitiesOptions;
    }
    
    public List<SelectOption> getClosedActivities_NextXDays_items()
    {
        List<SelectOption> closedActivitiesOptions = new List<SelectOption>();
        closedActivitiesOptions.add(new SelectOption('30', 'Last 30 Days'));
        closedActivitiesOptions.add(new SelectOption('90', 'Last 90 Days'));
        closedActivitiesOptions.add(new SelectOption('183', 'Last 6 Months'));
        closedActivitiesOptions.add(new SelectOption('365', 'Last 12 Months'));
        closedActivitiesOptions.add(new SelectOption('Not Include', 'Do not Include'));
        return closedActivitiesOptions;
    }
        
    public List<SelectOption> getPRT_CSP_LastXDays_items()
    {
        List<SelectOption> options= new List<SelectOption>();
        options.add(new SelectOption('All','All'));
        options.add(new SelectOption('30','Last 30 Days'));
        options.add(new SelectOption('60','Last 60 Days'));
        options.add(new SelectOption('90','Last 90 Days'));
        options.add(new SelectOption('183','Last 6 Months'));
        options.add(new SelectOption('365','Last 1 Year'));
        options.add(new SelectOption('Not Include', 'Do not Include'));
        return options;
    }

    public List<SelectOption> getCallReports_LastXDays_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('30','Last 30 Days'));
        options.add(new SelectOption('60','Last 60 Days'));
        options.add(new SelectOption('90','Last 90 Days'));
        options.add(new SelectOption('183','Last 6 Months'));
        options.add(new SelectOption('365','Last Year'));
        options.add(new SelectOption('Not Include', 'Do not Include'));
        return options;
    }
    public List<SelectOption> getCall_Report_notes_LastXDays_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('30','Last 30 Days'));
        options.add(new SelectOption('60','Last 60 Days'));
        options.add(new SelectOption('90','Last 90 Days'));
        options.add(new SelectOption('183','Last 6 Months'));
        options.add(new SelectOption('365','Last Year'));
        options.add(new SelectOption('Not Include', 'Do not Include'));
        return options;
    }
    
    public List<SelectOption> getCall_Reports_LastXDays_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('30','Last 30 Days'));
        options.add(new SelectOption('60','Last 60 Days'));
        options.add(new SelectOption('90','Last 90 Days'));
        options.add(new SelectOption('183','Last 6 Months'));
        options.add(new SelectOption('365','Last Year'));
        options.add(new SelectOption('Not Include', 'Do not Include'));
        return options;
    }
    
    public List<SelectOption> getOpportunities_Stage_items()
    {
        List<SelectOption> stageOptions = new List<SelectOption>();
        stageOptions.add(new SelectOption('All', 'All'));
        stageOptions.add(new SelectOption('Open', 'Open'));
        stageOptions.add(new SelectOption('Closed', 'Closed'));
        stageOptions.add(new SelectOption('Hold', 'Hold'));
        stageOptions.add(new SelectOption('Not Include', 'Do not Include'));
        return stageOptions;
    }
    
    public List<SelectOption> getBusinessContracts_items()
    {
        List<SelectOption> stageOptions = new List<SelectOption>();
        stageOptions.add(new SelectOption('All', 'All'));
        stageOptions.add(new SelectOption('Active', 'Active'));
        stageOptions.add(new SelectOption('Inactive', 'Inactive'));
        stageOptions.add(new SelectOption('Not Include', 'Do not Include'));
        return stageOptions;
    }

    public List<SelectOption> getOrderHistory_items()
    {
        List<SelectOption> stageOptions = new List<SelectOption>();
        stageOptions.add(new SelectOption('All', 'All'));
        stageOptions.add(new SelectOption('30', 'Last 30 days'));
        stageOptions.add(new SelectOption('60', 'Last 60 days'));
        stageOptions.add(new SelectOption('90', 'Last 90 days'));
        stageOptions.add(new SelectOption('120', 'Last 120 days'));
        stageOptions.add(new SelectOption('180', 'Last 180 days'));
        stageOptions.add(new SelectOption('Not Include', 'Do not Include'));
        return stageOptions;
    }


    Integer contacts_Count;
    Integer opportunties_Count;
    Integer contracts_Count;
    Integer inactive_Contacts_Count;
    Integer Sample_Requests_Count;
    Integer Consumption_Count;
    Integer callReports_Count;
    Integer call_Reports_Count;

    Account currentAccount;
    List<Task> indirectTasks;
    List<Event> indirectEvents;

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
            
        result = [SELECT Id, Name,SAP_Industry_Key_Desc__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, 
                       SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, OwnerID, Owner.Name, RecordTypeId, RecordType.Name, Type, SAP_Sales_Org__c, SAP_DivisionCode__c, 
                       (SELECT Id, Salutation, FirstName, LastName, WV_Contact_Status__c, Title, Phone, Fax, Email, OwnerId, Owner.Name, CreatedDate FROM Contacts ORDER BY LastName ASC, FirstName ASC, CreatedDate DESC),
                       //(SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Tasks ORDER BY ActivityDate DESC limit 100),
                       //(SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Events WHERE IsChild = false ORDER BY StartDateTime DESC),
                       //(SELECT Id, Name, Amount, Probability, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunities ORDER BY CloseDate DESC),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from OpenActivities),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from ActivityHistories ORDER BY ActivityDate DESC limit 100)
                       //(SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contracts WHERE RecordTypeId = '012300000000a6U' ORDER BY EndDate DESC),
                       //(SELECT Id, Name, Material_Summary__c , Material__r.Name, Status__c, CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM SampleRequest_to_Account__r WHERE Sample_State__c = 'Active'),
                       //(SELECT Id, Name, secondary_volume__c, description__c, product_group__c, SAP_Material__c, distribution_volume__c, comments__c, competitor_volume__c, container__c, current_supplier_producer_other__c, family__c, family_other__c,  offsite_waste_management__c, onsite_waste_Management__c, price__c, product_tradename__c, product_Type__c, Related_Account_Name__c, segment_Class__c, Source_Code__c, Source_description__c, sum_all_Volumes__c, technology_activity__c, Tons_Generated__c, Tons_Managed_Onsite__c, tons_managed_Offsite__c, type__c, waste_form_code__c, Waste_form_Description__c,  application__c, direct_volume__c, Material__c, Ashland_Material_in_Use__c, Status__c, CreatedDate, Annual_Usage_Volume__c, Product_Group_FAMILY__c, Market__c, Technology__c, Annual_Usage_T_Y__c,  distributor__c, Annual_Volume__c, Unit_of_Measure__c, Current_Supplier_Producer__c, channel_To_Market__c, base_code_Other__c, product_description__c, MFI__c, CreatedById, Distribution__c, of_Filler_Content_or_Comonomer__c, agent_area__c, CreatedBy.Name FROM Consumptions__r WHERE Status__c = 'Active' ORDER BY SAP_Material__r.name ),
                       //(SELECT Id, Name, CreatedById, CreatedBy.Name, Title__c, Reason_for_Visit__c, Date__c, Date_of_Call__c, Start_Date__c, End_Date__c, Discussion__C, purpose__c from CallReports__r),
                       //(Select id, ShipTo_Desc__c, Material__c, Ordered_Qty__c, Goods_Issue_Date2__c, Reason_Rejected_Code__c, Reason_Rejected_Desc__c, Requested_Delivery_Date2__c, Expected_Ship_Date2__c, Created_Date2__c, Customer_PO_Number__c, Sales_Order_Number__c, Ordered_Qty_in_LB__c, Unit_Price_per_LB__c, Plant_Desc__c from Open_Orders_ShipTo__r ORDER BY Expected_Ship_Date2__c DESC limit 225 ),
                       //(select id, Name, Customer_Name__r.name, Contract_Type__c, Effective_Date__c, Expiration_Date__c, Comments__c, Status__c from Business_Contracts__r)
                    FROM Account  
                   WHERE id = :accountId]; 
                   
        //Added by Annes on 21 oct 2011
        //lstTask=[SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Task where AccountId = :accountId ORDER BY ActivityDate DESC limit 100];
        populateListTask();
        populateListEvent();
        //lstevent =[SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Event WHERE IsChild = false and AccountId = :accountId ORDER BY StartDateTime DESC];
        //lstopp= [SELECT Id, Name, Amount, Probability,Annual_Usage__c,Requested_Supplier__r.Name, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunity where AccountId = :accountId ORDER BY CloseDate DESC];
        populateListOpp();
        //set<id> oppId = new set<id>();
        //for(Opportunity o: lstopp)
        //    oppId.add(o.id);
        //lstcontract=[SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract WHERE AccountId = :accountId ORDER BY EndDate DESC];
        populateListContract();
        populateListSampleRequest();
        //lstsmplrqst=[SELECT Id, Name, Material_Summary__c , Material__r.Name, Status__c, CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Sample_Request__c WHERE Account__c = :accountId];
        //set<id> srId = new set<id>();
        //for(Sample_Request__c sr: lstsmplrqst)
         //   srId.add(sr.id);
        //lstSampMat = [select id,name,Sample_Request__r.CreatedDate,Sample_Request__r.Status__c,Sample_Request__r.Material_Summary__c from Sample_Material__c where Sample_Request__c in : srID];
        populateListSampleMaterial();
        //lstconsumption= [SELECT Id,Name,Material__c,Market__c,Product_Group_FAMILY__c,MFI__c,Product_Description__c,Description__c,Current_Supplier_Producer__c,Status__c,Annual_Usage_Volume__c,Technology__c,Product_Group__c,SAP_Material__c,Base_Code_Other__c,Distribution_Volume__c,Direct_Volume__c,Secondary_Volume__c,Annual_Volume__c,Unit_of_Measure__c,Distributor__c FROM Consumption__c WHERE Account_Name__c = :accountId and Status__c = 'Active' ORDER BY SAP_Material__r.name LIMIT 450];
        lstconsumption = new List<consumption__c>();
        //lstcallreport = [SELECT Id, Name, CreatedById, CreatedBy.Name, Title__c, Reason_for_Visit__c, Date__c, Date_of_Call__c, Start_Date__c, End_Date__c, Discussion__C, purpose__c from Call_Report__c where Account__c = :accountId];
        populateListCallReport();
        populateListCallReportNotes(); 
       //lstcallreportnotes = [SELECT id,name,Opportunity__r.name,CreatedDate from Opportunity_Call_Report__c where Opportunity__c in : oppid];
       // lstopenorder= [Select id, ShipTo_Desc__c, Material__c, Ordered_Qty__c, Goods_Issue_Date2__c, Reason_Rejected_Code__c, Reason_Rejected_Desc__c, Requested_Delivery_Date2__c,Delivery_Date__c, Expected_Ship_Date2__c, Created_Date2__c, Customer_PO_Number__c, Sales_Order_Number__c, Ordered_Qty_in_LB__c, Unit_Price_per_LB__c, Plant_Desc__c from Open_Orders__c where ShipTo__c = :accountid ORDER BY Expected_Ship_Date2__c DESC limit 225];
        populateListOpenOrders();
        populateListBusinessContract();
        //lstbuscontract= [select id, Name, Customer_Name__r.name, Contract_Type__c, Effective_Date__c, Expiration_Date__c, Comments__c, Status__c from Business_Contract__c where Account_Owner__c = :accountid];
        //lstPRT = [select id,Type__c,Name,SAP_Material__r.name,Price__c,Requested_Effective_Date__c,Requested_Expiration_Date__c,PLM__c,Approver__r.name from Price_Request_Transaction__c where Ship_To__c =: accountid];
        populateListCSP();
        //End Added by Annes

        currentAccount = result;
        
        businessName = RecordType_Functions.getBusinessNameForAccountType(currentAccount.RecordTypeId);
        
        isNorthAmerica = (result.SAP_Sales_Org__c == '1000' || result.SAP_Sales_Org__c == '1800' || result.SAP_Sales_Org__c == '1700'); 
        isDistribution = (businessName == RecordType_Functions.DISTRIBUTION);
        isPerformanceMaterials = (businessName == RecordType_Functions.PERFORMANCE_MATERIALS);
        isValvoline = (businessName == RecordType_Functions.VALVOLINE);
        isWater = (businessName == RecordType_Functions.AHWT);
        isAqualon = (businessName == RecordType_Functions.AAFI);
        isES = (currentAccount.SAP_DivisionCode__c == '34');
        
        indirectTasks = [SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                           FROM Task
                          WHERE AccountId = :accountId AND WhatId = null
                          ORDER BY ActivityDate DESC];

        indirectEvents = [SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name 
                            FROM Event
                           WHERE IsChild = false AND AccountId = :accountId AND WhatId = null
                           ORDER BY StartDateTime DESC];
                
        contacts_Count = result.Contacts.size();
       // opportunties_Count = result.Opportunities.size();//commented by annes
        opportunties_Count =lstopp.size();//added by annes
        //contracts_Count = result.Contracts.size();
        contracts_Count = lstcontract.size();//added by annes
        //Sample_Requests_Count = result.SampleRequest_to_Account__r.size();
        Sample_Requests_Count = lstsmplrqst.size();//added by annes
        //Consumption_Count = result.Consumptions__r.size();
        Consumption_Count = lstconsumption.size();//added by annes
        //callReports_Count = result.CallReports__r.size();
        callReports_Count = lstcallreport.size();//added by annes
        
        inactive_Contacts_Count = 0;
        for (Contact c:result.Contacts)
            {
            if (c.WV_Contact_Status__c != 'Active') {inactive_Contacts_Count++;}
            }   
        }
        else {result = currentAccount;}
        
                
        return result; 
    }
    
    
    
    
    public Integer getContacts_Count() {return contacts_Count;}
    public Integer getOpportunities_Count() {return opportunties_Count;}
    public Integer getContracts_Count() {return contracts_Count;}
    public Integer getInactiveContacts_Count() {return inactive_Contacts_Count;}
    public Integer getSample_Requests_Count() {return Sample_Requests_Count;}
    public Integer getConsumption_Count() {return Consumption_Count;}
    public Integer getCallReports_Count() {return callReports_Count;}
    public Integer getCall_Reports_Count() {return call_Reports_Count;}

/*
    public Integer getOpenActivities_Count() {return openActivities.size();}
    public Integer getCallReports_Count() {return callReports.size();}
*/    
    public List<Opportunity> getOpportunities()
    {
        List<Opportunity> opp = new List<Opportunity>();
        //for (Opportunity o:a.Opportunities)
        //Adde by annes on 21 oct 2011
        if (Opportunities_Stage == 'Not Include'){
            NotIncludeOP = false;
            return null;
        }
        else{
            NotIncludeOP = true;
			populateListOpp();
            for (Opportunity o:lstopp)
            {
                if(Opportunities_Stage == 'All')
                opp.add(o);
                else if((Opportunities_Stage == 'Open') && ((!o.StageName.contains('Closed')) && (!o.StageName.contains('Hold'))))
                opp.add(o);
                else if((Opportunities_Stage == 'Hold') && (o.StageName.contains('Hold')))
                opp.add(o);
                else if((Opportunities_Stage == 'Closed') && (o.StageName.contains('Closed')))
                opp.add(o);
                else if((Opportunities_Stage == 'None'))
                {
                }
            }
            return opp;
        }
    }
    
    public Contact[] getContactstoDisplay() {
    System.debug('Entering into method' +ContactsActStat);
        List<Contact> contacts = new List<Contact>();
        if(ContactsActStat == 'All')
            return a.Contacts;
        else if(ContactsActStat == 'Active')
        {
            for (Contact c:a.Contacts) {
                //if ((Contacts_ShowInactive) || (c.WV_Contact_Status__c == 'Active'))
                //    {contacts.add(c);}
                if(c.WV_Contact_Status__c == 'Active') {
                    contacts.add(c);
                }
            }
        }
        else if (ContactsActStat == 'Inactive') 
        {
            for (Contact c:a.Contacts) {
            if(c.WV_Contact_Status__c != 'Active') {
                contacts.add(c);
            }
            }
        }    
        else {
            Integer i =  Integer.valueOf(ContactsActStat);
            i = ( i < a.contacts.size())? i : a.contacts.size() ;
            for(integer j=0;j<i;j++)    
                contacts.add(a.contacts[j]);
        }
        System.debug('&****' + ContactsActStat  + '****' +contacts);  
        return contacts;
    }
    
    public Business_Contract__c[] getBusContactstoDisplay() {
        System.debug('Entering into method getBusContactstoDisplay' +BusinessContracts);
        List<Business_Contract__c> contract = new List<Business_Contract__c>();
        if (BusinessContracts == 'Not Include'){
            NotIncludeBC = false;
            return null;
        }
        else{
            NotIncludeBC = true;
            populateListBusinessContract();
            if(BusinessContracts == 'All')
                  return lstbuscontract;
            //    return a.Business_Contracts__r;
            else if(BusinessContracts == 'Active')
            {
                //for (Business_Contract__c c:a.Business_Contracts__r) {
                //Added by annes on 21 oct 2011
                for (Business_Contract__c c:lstbuscontract) {
                    if(c.Status__c == 'Activated') {
                        contract.add(c);
                    }
                }
            }
            else
            {
                System.debug('Entering into else'+BusinessContracts);
                //for (Business_Contract__c c:a.Business_Contracts__r) {
                //Added by annes on 21 oct 2011
                for (Business_Contract__c c:lstbuscontract) {
                if(c.Status__c != 'Activated') {
                    contract.add(c);
                }
            }
            } 
            return contract;
        }
    }

    
    
    /* This accessor provides the page with the ordered collection of history (apex) objects for display in the page. 
       it also processes the truncation of case comments as specified by the fullComments property value.*/
    public SCPR_Call_Report[] getCallReports() {
        SCPR_Call_Report[] callReports = new SCPR_Call_Report[]{};
        if(CallReports_LastXDays == 'Not Include'){
            NotIncludeCL = false;
            return null;
        }
        else{
            NotIncludeCL = true;
            Date BeginDate = System.today().addDays((Integer.valueOf(CallReports_LastXDays) * -1));
    
            //for (Task t:a.tasks) { 
            //Added by annes on 21 oct 2011
            populateListTask();
            for (Task t:lstTask) {
                if (isLogCallType(t.Type)
                    && (t.ActivityDate >= BeginDate)
                    && (t.ActivityDate <= System.today())
                    && (t.Description != null)
                    && ((CallReports_LimittoOwner == false) || (a.OwnerId == t.CreatedById)) 
                   ) {
                    datetime dt = DateTime.newInstance(t.ActivityDate.year(),t.ActivityDate.month(),t.ActivityDate.day(), 0, 0, 0);
                    addCallReport(callReports, new SCPR_Call_Report(t.Id, t.CreatedById, t.CreatedBy.Name, dt, t.Subject, truncateValue(t.Description,'CallReports'))); 
                }
            }
    
            //for (Event e:a.events)
            populateListEvent();
            for (Event e:lstevent)
                 if (e.ActivityDateTime != null)
                    { 
                     date ActivityDate = Date.newInstance(e.ActivityDateTime.year(),e.ActivityDateTime.month(),e.ActivityDateTime.day());
                     if (
                           (ActivityDate >= BeginDate)
                        && (ActivityDate <= System.today())
                        && (e.Description != null)
                        && ((CallReports_LimittoOwner == false) || (a.OwnerId == e.CreatedById)) 
                        )
                            { 
                            addCallReport(callReports, new SCPR_Call_Report(e.Id, e.CreatedById, e.CreatedBy.Name, e.ActivityDateTime, e.Subject, truncateValue(e.Description,'CallReports'))); 
                            }
                    }
    
            for (Task t:indirectTasks) { 
                if (isLogCallType(t.Type)
                    && (t.ActivityDate >= BeginDate)
                    && (t.ActivityDate <= System.today())
                    && (t.Description != null)
                    && ((CallReports_LimittoOwner == false) || (a.OwnerId == t.CreatedById)) 
                   ) {
                    datetime dt = DateTime.newInstance(t.ActivityDate.year(),t.ActivityDate.month(),t.ActivityDate.day(), 0, 0, 0);
                    addCallReport(callReports, new SCPR_Call_Report(t.Id, t.CreatedById, t.CreatedBy.Name, dt, t.Subject, truncateValue(t.Description,'CallReports'))); 
                }
            }
    
            for (Event e:indirectEvents)
                 if (e.ActivityDateTime != null)
                    { 
                     date ActivityDate = Date.newInstance(e.ActivityDateTime.year(),e.ActivityDateTime.month(),e.ActivityDateTime.day());
                     if (
                           (ActivityDate >= BeginDate)
                        && (ActivityDate <= System.today())
                        && (e.Description != null)
                        && ((CallReports_LimittoOwner == false) || (a.OwnerId == e.CreatedById)) 
                        )
                            { 
                            addCallReport(callReports, new SCPR_Call_Report(e.Id, e.CreatedById, e.CreatedBy.Name, e.ActivityDateTime, e.Subject, truncateValue(e.Description,'CallReports'))); 
                            }
                    }
    
            
            return callReports;
        }
    }
    
    /* This method adds the newHistory object to the given histories collection in the appropriate order. 
       The order provided here places the oldest records at the front of the list, i.e. by date ascending. */
   @TestVisible private void addCallReport(SCPR_Call_Report[] callReports, SCPR_Call_Report newCallReport) {
        Integer position = callReports.size();
        for (Integer i = 0; i < callReports.size(); i++) {
            if (newCallReport.CallReportDate > callReports[i].CallReportDate) {
                position = i;
                break;
            }
        }
        
        if (position == callReports.size()) {
            callReports.add(newCallReport);
        } else {
            callReports.add(position, newCallReport);
        }
    }

    public SCPR_Call_Report[] getCall_Reports() {
        SCPR_Call_Report[] call_Reports = new SCPR_Call_Report[]{};
        SCPR_Call_Report scr;
        
        if (Call_Reports_LastXDays == 'Not Include'){
            NotIncludeCR = false;
            return null;
        }
        else{
            NotIncludeCR = true;
            Date beginDate = System.today().addDays((Integer.valueOf(Call_Reports_LastXDays) * -1));
            Date d; 
            String p;
            //for (Call_Report__c cr : a.CallReports__r) {
            //Added by Annes on 21 oct 2011
            populateListCallReport();
            for (Call_Report__c cr : lstcallreport) {
                d = getCallReportDate(cr);
                if (d == null) {d = beginDate;}
                p = getCallPurpose(cr);
                DateTime dt = DateTime.newInstance(d.year(), d.month(), d.day());
                if (d <= System.today() &&
                    d >= beginDate &&
                   (Call_Reports_LimittoOwner == false || 
                    a.OwnerId == cr.CreatedById)
                   ) {
                    scr = new SCPR_Call_Report(cr.Id, cr.CreatedById, 
                                               cr.CreatedBy.Name, 
                                               dt, cr.Title__c, p,cr.discussion__c);
                    addCallReport(call_Reports, scr);
                }
            }
    
            return call_Reports;
        }
    }
    
   @TestVisible private Date getCallReportDate(Call_Report__c cr) {
        Date d = null;
        if (isDistribution ||
            isPerformanceMaterials ||
            isValvoline) {
            d = cr.Start_Date__c;
        } else if (isWater) {
            d = cr.Date_of_Call__c;
        } else if (isAqualon) {
            d = cr.Date__c;
        }
        return d;
    }
    
    
        
   @TestVisible private String getCallPurpose(Call_Report__c cr) {
        String p = cr.Reason_for_Visit__c;
        if (isDistribution) {
            p = cr.Purpose__c; 
        }
        return p;
    }
    
    /* This accessor provides the page with the ordered collection of history (apex) objects for display in the page. 
       it also processes the truncation of case comments as specified by the fullComments property value.*/
   /* public SCPR_Open_Activity[] getOpenActivities() {
        SCPR_Open_Activity[] openActivities = new SCPR_Open_Activity[]{};

        for (Task t:a.tasks) 
            { 
            if (t.Status != 'Completed')
                {
                addOpenActivity(openActivities, new SCPR_Open_Activity(t.Id, t.ActivityDate, t.OwnerId, t.Owner.Name, t.Subject, truncateValue(t.Description,'OpenActivities')));
                }
            }

        for (Task t:indirectTasks) 
            { 
            if (t.Status != 'Completed')
                {
                addOpenActivity(openActivities, new SCPR_Open_Activity(t.Id, t.ActivityDate, t.OwnerId, t.Owner.Name, t.Subject, truncateValue(t.Description,'OpenActivities')));
                }
            }

        return openActivities;
    }*/
    
    public SCPR_Open_Activity[] getOpenActivities() {
        SCPR_Open_Activity[] openActivities = new SCPR_Open_Activity[]{};
        
        if (OpenActivities_NextXDays == 'Not Include'){
            NotIncludeOA = false;
            return null;
            
        }
        else{
            NotIncludeOA = true;
            Date EndDate = System.today().addDays((Integer.valueOf(OpenActivities_NextXDays) * 1));
            for (OpenActivity opActy:a.OpenActivities) 
                { 
                    if(opActy.ActivityDate >= System.today() && opActy.ActivityDate <= EndDate)
                    {
                        Date dt = Date.newInstance(opActy.ActivityDate.year(),opActy.ActivityDate.month(),opActy.ActivityDate.day());
                        addOpenActivity(openActivities, new SCPR_Open_Activity(opActy.Id, dt, opActy.OwnerId, opActy.Owner.Name, opActy.Subject, truncateValue(opActy.Description,'OpenActivities'), opActy.WhoId, opActy.Who.Name, opActy.WhatId, opActy.What.Name,opActy.Status));
                        system.debug('OA: ' + opActy);
                    }               
                }
    
            return openActivities;
        }
    }
    
     public list<activityHistory> getcloseActivities() {     
       
        /*list<activityHistory> closeActivities = new list<activityHistory>();    
        List<activityHistory> returncloseactivities = new list<activityHistory>();
        Date EndDate = System.today().addDays((Integer.valueOf(ClosedActivities_NextXDays) * (-1)));
        for (ActivityHistory clActy:closeActivities) 
            { 
                if(clActy.ActivityDate >= System.today() && clActy.ActivityDate <= EndDate)
                {
                   //Date dt = Date.newInstance(clActy.ActivityDate.year(),clActy.ActivityDate.month(),clActy.ActivityDate.day());
                   //addOpenActivity(closedActivities, new SCPR_Open_Activity(clActy.Id, dt, clActy.OwnerId, clActy.Owner.Name, clActy.Subject, truncateValue(clActy.Description,'OpenActivities'), clActy.WhoId, clActy.Who.Name, clActy.WhatId, clActy.What.Name,clActy.Status));
                   returncloseactivities.add(clActy);
                }               
            }
        return a.activityHistories;*/
            
        //list<activityHistory> closeActivities = new list<activityHistory> ();
        List<activityHistory> returncloseactivities = new list<activityHistory>();
       
       if (ClosedActivities_NextXDays == 'Not Include'){
           NotIncludeCA = false;
           return null;
       }
       else{
            NotIncludeCA = true;
            Date EndDate = System.today().addDays((Integer.valueOf(ClosedActivities_NextXDays) * (-1)));
    
            for (ActivityHistory clActy:a.activityHistories ) 
                { 
                    if(clActy.ActivityDate <= System.today() && clActy.ActivityDate >= EndDate)
                    {
                        returncloseactivities.add(clActy);                   
                    }               
                }
    
                            System.Debug('Render val--->'+renderCA);
                return returncloseactivities;
            }

    }
    
       public list<Open_Orders__c> getOpenOrders() {
           list<Open_Orders__c> open_orders = new list<Open_Orders__c>();
           
           populateListOpenOrders();
           
           if (OpenOrders_NextXDays == 'Not Include'){
                NotIncludeOO = False;
                return null;
            }
            else{            
            
                if (OpenOrders_NextXDays == 'All Open') {
                    //for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
                    //Added by annes on 21 oct 2011
                    for(Open_Orders__c tempOpenOrder : lstopenorder)
                    {
                         if(tempOpenOrder.Goods_Issue_Date2__c ==null && tempOpenOrder.Reason_Rejected_Code__c == null  && tempOpenOrder.Reason_Rejected_Desc__c == null)
                            open_orders.add(tempOpenOrder);
                    }
                } else {
                    Date EndDate = System.today().addDays((Integer.valueOf(OpenOrders_NextXDays) * (1)));
                    Date CurrentDate = System.today();
                    //for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
                    //Added by annes on 21 oct 2011
                    for(Open_Orders__c tempOpenOrder : lstopenorder)
                    {
                         if(tempOpenOrder.Requested_Delivery_Date2__c > System.Today() && tempOpenOrder.Requested_Delivery_Date2__c < Enddate && tempOpenOrder .Goods_Issue_Date2__c ==null && tempOpenOrder.Reason_Rejected_Code__c == null  && tempOpenOrder.Reason_Rejected_Desc__c == null)
                            open_orders.add(tempOpenOrder);
                    }
                }
                return open_orders ;
            }
       }
 //Added by Shwetha on 26th oct 2015       
        public list<Price_Request_Transaction__c> getCSPtoDisplay() {
            countCSP = 0;
            list<Price_Request_Transaction__c> CSPList = new list<Price_Request_Transaction__c>();
            if (CSPSelect=='Not Include'){
                NotIncludeCSP = false;
                return null;
            }
            
            else{   
                NotIncludeCSP = true;
                populateListCSP();
                for(Price_Request_Transaction__c tempCSP : lstPRT)
                { 
                    if(tempCSP.Type__C =='CSP'){
                        isCSP=true;
                        countCSP++;
                        if (CSPSelect== 'All') { 
                        
                        CSPList .add(tempCSP);
                    }
                 else {
                    Date EndDate =  System.today().addDays((Integer.valueOf(CSPSelect) * (-1)));
                    Date CurrentDate = System.today();
             //       for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
               //Added by annes on 21 oct 2011
                   
                        if(tempCSP.Requested_Effective_Date__c< System.Today() && tempCSP.Requested_Effective_Date__c> Enddate)                        
                        CSPList.add(tempCSP);
                    }
                }
                }
                if (countCSP==0)
                    isCSP = false;
                    
                return CSPList;
            }
       } 
       
       public list<Open_Orders__c> getOrderHistorytoDisplay() {
            list<Open_Orders__c> OrderHistoryList = new list<Open_Orders__c>();
            if (OrderHistory =='Not Include'){
                NotIncludeOH = false;
                return null;
            }
            
            else{
                populateListOpenOrders();
                if (OrderHistory == 'All') {
               //     for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
               //Added by annes on 21 oct 2011
                    for(Open_Orders__c tempOpenOrder : lstopenorder)
                    {
                        if(tempOpenOrder .Goods_Issue_Date2__c !=null || tempOpenOrder.Reason_Rejected_Code__c != null  || tempOpenOrder.Reason_Rejected_Desc__c != null)
                        OrderHistoryList.add(tempOpenOrder);
                    }
                } else {
                    Date EndDate =  System.today().addDays((Integer.valueOf(OrderHistory) * (-1)));
                    Date CurrentDate = System.today();
             //       for(Open_Orders__c tempOpenOrder : a.Open_Orders_ShipTo__r)
               //Added by annes on 21 oct 2011
                    for(Open_Orders__c tempOpenOrder : lstopenorder)
                    {
                        if(tempOpenOrder.Requested_Delivery_Date2__c < System.Today() && tempOpenOrder.Requested_Delivery_Date2__c > Enddate && (tempOpenOrder .Goods_Issue_Date2__c !=null || tempOpenOrder.Reason_Rejected_Code__c != null  || tempOpenOrder.Reason_Rejected_Desc__c != null))                        
                        OrderHistoryList.add(tempOpenOrder);
                    }
                }
                return OrderHistoryList;
            }
       } 
        
        public list<Sample_Material__c > getSampleRequest() {
            list<Sample_Material__c> sample_request = new list<Sample_Material__c>();
            if (SampleRequest_lastXdays == 'Not Include'){
                NotIncludeSR = false;
                return null;
            }
            else{
                NotIncludeSR = true;
            	populateListSampleMaterial();
                System.debug(' lstSampMat ' + lstSampMat);
                for(Sample_Material__c tempsr : lstSampMat)
                {
                    if(SampleRequest_lastXdays== 'All')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'Draft' && SampleRequest_lastXdays == 'Draft')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'In Approval Process' && SampleRequest_lastXdays == 'In Approval Process')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'Approved' && SampleRequest_lastXdays == 'Approved')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'Waiting for Order Creation' && SampleRequest_lastXdays == 'Waiting for Order Creation')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'Order Created for Sample Request' && SampleRequest_lastXdays == 'Order Created for Sample Request')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'Request Completed' && SampleRequest_lastXdays == 'Request Completed')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'Rejected' && SampleRequest_lastXdays == 'Rejected')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'Cancelled' && SampleRequest_lastXdays == 'Cancelled')
                        sample_request.add(tempsr);
                    else if(tempsr.Sample_Request__r.Status__c== 'On-Hold' && SampleRequest_lastXdays == 'On-Hold')
                        sample_request.add(tempsr);
                }
                           // open_orders = [Select id,ShipTo_Desc__c,Material__c,Ordered_Qty__c,Requested_Delivery_Date2__c,Expected_Ship_Date2__c,Created_Date2__c,Customer_PO_Number__c from Open_Orders__c where shipto__c =: a.id and Requested_Delivery_Date2__c < :Enddate and Requested_Delivery_Date2__c >:CurrentDate];
                return sample_request;
            }
        }
        
    
   @TestVisible private void addOpenActivity(SCPR_Open_Activity[] openActivities, SCPR_Open_Activity newOpenActivity) {
        Integer position = openActivities.size();
        for (Integer i = 0; i < openActivities.size(); i++) {
            if (newOpenActivity.ActivityDate > openActivities[i].ActivityDate) {
                position = i;
                break;
            }
        }
        
        if (position == openActivities.size()) {
            openActivities.add(newOpenActivity);
        } else {
            openActivities.add(position, newOpenActivity);
        }
    }

        
    /* Returns the truncated string value if that is specified in the current state (!fullComments)
       and the current length is greater than the value of the private truncatedCommentLength property. */
   @TestVisible private String truncateValue(String s, String valueType) {
        
        Boolean fullComments = false;
        
        if (valueType == 'OpenActivities') {fullComments = OpenActivities_FullComments;}
        if (valueType == 'CallReports') {fullComments = CallReports_FullComments;}
        
        if (s != null)
            {
            if (!fullComments && s.length() > truncatedCommentLength) 
                {
                s = s.substring(0,truncatedCommentLength) + '...';
                }
            }
        
        return s;
    }
    
    /* The ID value of the case that will be used by the getCase() method to query for the related
       objects used to generate the ordered history collection. The value will be based on the request 
       parameter, if available. */
   @TestVisible private Id accountId { 
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
   @TestVisible private Account a { 
        get { return getAccount(); }
//        get { return acct; }
        set; 
    }
    
    /* The length of "Short Comments" which is used by the truncateValue method in this class to
       truncate case comments when specified by the user. */
   @TestVisible private Integer truncatedCommentLength { get; set; }
    
    
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
    
/*
    public void determineBusinessType() {
        String BusinessType = '';

        isDistribution = false;
        isPerformanceMaterials = false;
        isValvoline = false;
        isWater = false;

        BusinessType = RecordType_Relationship_Functions.GetBusinessType_Based_on_AccountRecordTypeId(a.recordTypeId);
        if (BusinessType == 'Distribution') isDistribution = true;
        if (BusinessType == 'Performance Materials') isPerformanceMaterials = true;
        if (BusinessType == 'Valvoline') isValvoline = true;
        if (BusinessType == 'Water') isWater = true;
    }

    public Boolean getisDistribution() {
        if (isDistribution == null) {determineBusinessType();}
        return isDistribution;
    }

    public Boolean getisPerformanceMaterials() {
        if (isPerformanceMaterials == null) {determineBusinessType();}
        return isPerformanceMaterials;
    }

    public Boolean getisValvoline() {
        if (isValvoline == null) {determineBusinessType();}
        return isValvoline;
    }

    public Boolean getisWater() {
        if (isWater == null) {determineBusinessType();}
        return isWater;
    }
    
*/
    public String getAccountAddress() {

        String AccountAddress = '';     

        List <String> addressLines = new List <String>();
        addressLines.add(a.SAP_Street__c);
        addressLines.add(a.SAP_StreetSuppl1__c);
        addressLines.add(a.SAP_StreetSuppl2__c);
        addressLines.add(a.SAP_StreetSuppl3__c);
          
        AccountAddress = Address_Functions.FormatAddressforWebDisplay(addressLines,
                                                                      a.SAP_City__c,
                                                                      a.SAP_State__c,
                                                                      a.SAP_Zip_Code__c,
                                                                      a.SAP_Country__c);
                                                                      
        return AccountAddress;
                                                                            
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
    
    public List<SelectOption> getStatus(){
        List<SelectOption> status = new List<SelectOption>();
        status.add(new SelectOption('All','All'));
        status.add(new SelectOption('Draft','Draft'));
        status.add(new SelectOption('In Approval Process','In Approval Process'));
        status.add(new SelectOption('Rejected','Rejected'));
        status.add(new SelectOption('Activated','Activated'));
        status.add(new SelectOption('Expired/Canceled','Expired / Canceled'));
        status.add(new SelectOption('Not Include','Do Not Include'));
        return status;
    }
    
    public PageReference sortByName(){
        isSortByName = true;
        isSortByStatus  = false;
        countStatus = 0;
        
        if(selectedStatus == 'Not Include'){
           NotIncludeCDF = false;
           return null;
        }
        else{
            NotIncludeCDF = true;
            if(math.mod(countName,2)==0)
                if(selectedStatus=='All')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY Name];
                else if(selectedStatus=='Draft')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Draft' ORDER BY Name];
                else if(selectedStatus=='In Approval Process')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'In Approval Process' ORDER BY Name];
                else if(selectedStatus=='Rejected'){
                    String temp = '%'+'Rejected'+'%';
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status Like :temp ORDER BY Name];
                }
                else if(selectedStatus=='Activated')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Activated' ORDER BY Name];
               
                else if(selectedStatus=='Expired/Canceled')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and (status = 'Expired' or status = 'Canceled') ORDER BY Name];
                
            if(math.mod(countName,2)==1)
                if(selectedStatus=='All')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY Name desc];
                else if(selectedStatus=='Draft')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Draft' ORDER BY Name desc];
                else if(selectedStatus=='In Approval Process')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'In Approval Process' ORDER BY Name desc];
                else if(selectedStatus=='Rejected'){
                    String temp = '%'+'Rejected'+'%';
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status Like :temp ORDER BY Name desc];
                }
                else if(selectedStatus=='Activated')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Activated' ORDER BY Name desc];
               
                else if(selectedStatus=='Expired/Canceled')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and (status = 'Expired' or status = 'Canceled') ORDER BY Name desc];
                
            countName++;
            return null;
        }
    }
    
    public PageReference sortByStatus(){
        isSortByStatus = true;
        isSortByName = false;
        countName = 0;
         if(selectedStatus == 'Not Include'){
           NotIncludeCDF = false;
           return null;
        }
        else{
            NotIncludeCDF = true;
            if(math.mod(countStatus,2)==0)
                if(selectedStatus=='All')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY Status];
                else if(selectedStatus=='Draft')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Draft' ORDER BY Status];
                else if(selectedStatus=='In Approval Process')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'In Approval Process' ORDER BY Status];
                else if(selectedStatus=='Rejected'){
                    String temp = '%'+'Rejected'+'%';
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status Like :temp ORDER BY Status];
                }
               else if(selectedStatus=='Activated')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Activated' ORDER BY Status];
               
                else if(selectedStatus=='Expired/Canceled')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and (status = 'Expired' or status = 'Canceled') ORDER BY Status];
                
            if(math.mod(countStatus,2)==1)
                if(selectedStatus=='All')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY Status desc];
                else if(selectedStatus=='Draft')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Draft' ORDER BY Status desc];
                else if(selectedStatus=='In Approval Process')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'In Approval Process' ORDER BY Status desc];
                else if(selectedStatus=='Rejected'){
                    String temp = '%'+'Rejected'+'%';
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status Like :temp ORDER BY Status desc];
                }
               else if(selectedStatus=='Activated')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Activated' ORDER BY Status desc];
               
                else if(selectedStatus=='Expired/Canceled')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and (status = 'Expired' or status = 'Canceled') ORDER BY Status desc];
                
            countStatus++;
            return null;
        }
    }
    
    public PageReference filterByStatus(){
        countName = 0;
        countStatus = 0;
        isSortByStatus = false;
        isSortByName = false;
         if(selectedStatus == 'Not Include'){
           NotIncludeCDF = false;
           return null;
        }
        else{
            NotIncludeCDF = true;
            if(selectedStatus=='All')
                conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds ORDER BY EndDate desc];
                else if(selectedStatus=='Draft')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Draft' ORDER BY EndDate desc];
                else if(selectedStatus=='In Approval Process')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'In Approval Process' ORDER BY EndDate desc];
                else if(selectedStatus=='Rejected'){
                    String temp = '%'+'Rejected'+'%';
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status Like :temp ORDER BY EndDate desc];
                }
               else if(selectedStatus=='Activated')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and Status = 'Activated' ORDER BY EndDate desc];
               
                else if(selectedStatus=='Expired/Canceled')
                    conList = [SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract where Id in :conListIds and (status = 'Expired' or status = 'Canceled') ORDER BY EndDate desc];
                
            return null;
        }
    }
	
    // in order to get open orders
    public void populateListOpenOrders() {
        try {
        	lstopenorder = [Select id, ShipTo_Desc__c, Material__c, Ordered_Qty__c, Goods_Issue_Date2__c, Reason_Rejected_Code__c, Reason_Rejected_Desc__c, Requested_Delivery_Date2__c,Delivery_Date__c, Expected_Ship_Date2__c, Created_Date2__c, Customer_PO_Number__c, Sales_Order_Number__c, Ordered_Qty_in_LB__c, Unit_Price_per_LB__c, Plant_Desc__c from Open_Orders__c where ShipTo__c = :accountid ORDER BY Expected_Ship_Date2__c DESC limit 225];
        } catch (Exception ex) {
            System.debug('Sales Call report open orders Ex ' + ex.getMessage());
        }
    }
    
    // in order to get Price Request Transaction
    public void populateListCSP() {
        try {
            lstPRT = [select id,Type__c,Name,SAP_Material__r.name,Price__c,Requested_Effective_Date__c,Requested_Expiration_Date__c,PLM__c,Approver__r.name from Price_Request_Transaction__c where Ship_To__c =: accountid];
        } catch (Exception ex) {
            System.debug('Sales Call report CSP Ex ' + ex.getMessage());
        }
    }
    
    // in order to get Opportunities
    public void populateListOpp() {
        try {
            lstopp = [SELECT Id, Name, Amount, Probability,Annual_Usage__c,Requested_Supplier__r.Name, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunity where AccountId = :accountId ORDER BY CloseDate DESC];
        } catch (Exception ex) {
            System.debug('Sales Call report opps. Ex ' + ex.getMessage());
        }
    }

    // in order to get task
    public void populateListTask() {
        try {
        	lstTask=[SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Task where AccountId = :accountId ORDER BY ActivityDate DESC limit 100];
        } catch (Exception ex) {
            System.debug('Sales Call report tasks Ex ' + ex.getMessage());
        }
    }
    
    // in order to get events
    public void populateListEvent() {
        try {
        	lstevent =[SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Event WHERE IsChild = false and AccountId = :accountId ORDER BY StartDateTime DESC];
        } catch (Exception ex) {
            System.debug('Sales Call report events Ex ' + ex.getMessage());
        }
    }

    // in order to get Contract
    public void populateListContract() {
        try {
        	lstcontract=[SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract WHERE AccountId = :accountId ORDER BY EndDate DESC];
        } catch (Exception ex) {
            System.debug('Sales Call report Contract Ex ' + ex.getMessage());
        }
    }

    // in order to get Sample requests
    public void populateListSampleRequest() {
        try {
			lstsmplrqst = [SELECT Id, Name, Material_Summary__c , Material__r.Name, Status__c, CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Sample_Request__c WHERE Account__c = :accountId];
        } catch (Exception ex) {
            System.debug('Sales Call report Sample requests Ex ' + ex.getMessage());
        }
    }

    // in order to get Call Report
    public void populateListCallReport() {
        try {
        	lstcallreport = [SELECT Id, Name, CreatedById, CreatedBy.Name, Title__c, Reason_for_Visit__c, Date__c, Date_of_Call__c, Start_Date__c, End_Date__c, Discussion__C, purpose__c from Call_Report__c where Account__c = :accountId];
        } catch (Exception ex) {
            System.debug('Sales Call report Call Report Ex ' + ex.getMessage());
        }
    }

    // in order to get Call Report Notes
    public void populateListCallReportNotes() {
        try {
				if (null == lstopp) {
                    populateListOpp();
                }
            
                set<id> oppId = new set<id>();
                for(Opportunity o: lstopp) {
                    oppId.add(o.id);
                }
            
            
        	lstcallreportnotes = [SELECT id,name,Opportunity__r.name,CreatedDate from Opportunity_Call_Report__c where Opportunity__c in : oppid];
        } catch (Exception ex) {
            System.debug('Sales Call report Call Report Notes Ex ' + ex.getMessage());
        }
    }

    // in order to get Sample Material
    public void populateListSampleMaterial() {
        try {

                if (null == lstsmplrqst) {
                    populateListSampleRequest();
                }
            
        		set<id> srId = new set<id>();
                for(Sample_Request__c sr: lstsmplrqst) {
                    srId.add(sr.id);
                }
            System.debug('srId ' + srId);
        		lstSampMat = [select id,name,Sample_Request__r.CreatedDate,Sample_Request__r.Status__c,Sample_Request__r.Material_Summary__c from Sample_Material__c where Sample_Request__c in : srId];        
        	} catch (Exception ex) {
            	System.debug('Sales Call report Sample Material Ex ' + ex.getMessage());
        }
    }
    
    // in order to get Business Contract
    public void populateListBusinessContract() {
        try {
        	lstbuscontract= [select id, Name, Customer_Name__r.name, Contract_Type__c, Effective_Date__c, Expiration_Date__c, Comments__c, Status__c from Business_Contract__c where Account_Owner__c = :accountid];
        } catch (Exception ex) {
            System.debug('Sales Call report Business Contract Ex ' + ex.getMessage());
        }
    }
    
    
//******************
//Test Method 
//******************
/*
    static testMethod void TestMe() {
    
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        
        Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
    
        Id contractRecordTypeId = RecordType_Functions.LookupRecordTypeId('CDF','Contract');
        
        try {
            testAcct = [SELECT Id, Name,SAP_Industry_Key_Desc__c, SAP_Customer_Number__c, CIS_Prospect_Number__c, SAP_Street__c, SAP_StreetSuppl1__c, SAP_StreetSuppl2__c, SAP_StreetSuppl3__c, 
                       SAP_City__c, SAP_State__c, SAP_Zip_Code__c, SAP_Country__c, OwnerID, Owner.Name, RecordTypeId, RecordType.Name, Type, SAP_Sales_Org__c, SAP_DivisionCode__c, 
                       (SELECT Id, Salutation, FirstName, LastName, WV_Contact_Status__c, Title, Phone, Fax, Email, OwnerId, Owner.Name, CreatedDate FROM Contacts ORDER BY LastName ASC, FirstName ASC, CreatedDate DESC),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from OpenActivities),
                       (SELECT Id, Subject, OwnerId, Owner.Name, ActivityDate, Status, WhoId, Who.Name, WhatId, What.Name, Description from ActivityHistories limit 100)
                       
                    FROM Account limit 1];
                   
        String accountid = testacct.id;      
        //Added by Annes on 21 oct 2011
        List<Task> lstTask=[SELECT Id, Subject, ActivityDate, Description, Status, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Task where AccountId = :accountId ORDER BY ActivityDate DESC limit 100];
        
        List<Event> lstevent =[SELECT Id, StartDateTime, EndDateTime, ActivityDateTime, Subject, Description, Type, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Event WHERE IsChild = false and AccountId = :accountId ORDER BY StartDateTime DESC];
        List<Opportunity> lstopp= [SELECT Id, Name, Amount, Probability, Competition__c, Target_Price__c, CloseDate, StageName, CurrencyIsoCode, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Opportunity where AccountId = :accountId ORDER BY CloseDate DESC];
        List<Contract> lstcontract=[SELECT Id, Name, Status, Forecasted_Quantity__c, Stocking_Unit__c, Per__c, Order_Size__c, EndDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Contract WHERE AccountId = :accountId ORDER BY EndDate DESC];
        List<Sample_Request__c> lstsmplrqst=[SELECT Id, Name, Material_Summary__c , Material__r.Name, Status__c, CreatedDate, OwnerId, Owner.Name, CreatedById, CreatedBy.Name FROM Sample_Request__c WHERE Account__c = :accountId and Sample_State__c = 'Active'];
        //lstconsumption= [SELECT Id,Name,Material__c,Market__c,Product_Group_FAMILY__c,MFI__c,Product_Description__c,Description__c,Current_Supplier_Producer__c,Status__c,Annual_Usage_Volume__c,Technology__c,Product_Group__c,SAP_Material__c,Base_Code_Other__c,Distribution_Volume__c,Direct_Volume__c,Secondary_Volume__c,Annual_Volume__c,Unit_of_Measure__c,Distributor__c FROM Consumption__c WHERE Account_Name__c = :accountId and Status__c = 'Active' ORDER BY SAP_Material__r.name LIMIT 450];
        List<Consumption__c> lstconsumption = new List<consumption__c>();
        List<Call_Report__c> lstcallreport = [SELECT Id, Name, CreatedById, CreatedBy.Name, Title__c, Reason_for_Visit__c, Date__c, Date_of_Call__c, Start_Date__c, End_Date__c, Discussion__C, purpose__c from Call_Report__c where Account__c = :accountId];
        List<Open_Orders__c> lstopenorder= [Select id, ShipTo_Desc__c, Material__c, Ordered_Qty__c, Goods_Issue_Date2__c, Reason_Rejected_Code__c, Reason_Rejected_Desc__c, Requested_Delivery_Date2__c, Expected_Ship_Date2__c, Created_Date2__c, Customer_PO_Number__c, Sales_Order_Number__c, Ordered_Qty_in_LB__c, Unit_Price_per_LB__c, Plant_Desc__c from Open_Orders__c where ShipTo__c = :accountid ORDER BY Expected_Ship_Date2__c DESC limit 225];
        List<Business_Contract__c> lstbuscontract= [select id, Name, Customer_Name__r.name, Contract_Type__c, Effective_Date__c, Expiration_Date__c, Comments__c, Status__c from Business_Contract__c where Account_Owner__c = :accountid];
        //End Added by Annes            
                    
        } catch(Exception e) {}
        
        if (testAcct == null) {return;} 
        try{
        //apexpages.currentpage().getparameters().put('fid', '00lP0000000QrJC');
        Contact testContact = new Contact();
        testContact.FirstName= 'Chandra';
        testContact.Lastname = 'Test';
        testContact.WV_Contact_Status__c = 'Active';
        testContact.AccountId = testAcct.id;
        testContact.No_Email__c=true;
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
        
        
        
        } catch(Exception e) {}
        
        Call_Report__c crc = new Call_Report__c(Account__c = testAcct.id, Competitor__c= testAcct.id,AQ_Attendee_4__c = u.id,Title__c = 'abc');
        insert crc;
        
        SCPR_Open_Activity[] openActivities = new SCPR_Open_Activity[]{};
        
        ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        SCPR cls = new SCPR(sc);
//      SCPR cls = new SCPR();
        
        String testString = '';
        
        cls.Contacts_ShowInactive = false; 
        testString = cls.getContacts_Desc();        

        cls.Contacts_ShowInactive = true; 
        testString = cls.getContacts_Desc();    
        
        testString = cls.getOpenActivities_Desc();
        
        testString = cls.getCallReports_Desc();
        
        testString = cls.getOppStage_Desc();
        cls.styleNumber(19.23);
        cls.styleNumber(3.14159);
        cls.styleNumber(4);
        cls.format_Amount(12.34,'test');
        cls.format_Volume(12.3423,'test');
        
        testString = cls.getCDFStatus_Desc();

        cls.toggleContacts_ShowInactive();
        cls.toggleOpenActivities_FullComments();
        cls.toggleCallReports_FullComments();
        cls.toggleCallReports_LimittoOwner();

        testString = cls.getCallReports_Desc(); 
        
        //PageReference testPageReference1 = cls.backToAccount();
       // PageReference testPageReference2 = cls.Printable_View();
       // PageReference testPageReference3 = cls.sortByName();
       // PageReference testPageReference4 = cls.sortByStatus();
       // PageReference testPageReference5 = cls.filterByStatus();
 

        cls.toggleCallReports_LimittoOwner();
        
        List<SelectOption> testSelectOption1 = cls.getCallReports_LastXDays_items();
        
        List<SelectOption> testSelectOption2 = cls.getOpportunities_Stage_items();
        
        List<SelectOption> testSelectOption3 = cls.getOpenActivities_NextXDays_items();
        
        List<SelectOption> testSelectOption4 = cls.getStatus();
        
        Account testAcct2 = cls.getAccount();
        
        Integer testInt;
        testInt = cls.getContacts_Count();
        testInt = cls.getOpportunities_Count();
        testInt = cls.getContracts_Count();
        testInt = cls.getInactiveContacts_Count();
        testInt = cls.getSample_Requests_Count();
        testInt = cls.getConsumption_Count();

        cls.CallReports_LimittoOwner = false;
        
        List<Opportunity> testOpp = cls.getOpportunities();
        
        Contact[] testContacts = cls.getContactstoDisplay();
        SCPR_Call_Report[] testCallReports = cls.getCallReports();
        SCPR_Open_Activity[] testOpenActivities = cls.getOpenActivities();
  
        
        //cls.addOpenActivity

        cls.getcloseActivities();
        cls.getOpenOrders();
        cls.getBusContactstoDisplay();
        cls.getAccountSummaryInformation();
        cls.getFYTDvsPFYTD_Amount_Down();
        cls.getFYTDvsPFYTD_Amount_Up();
        cls.getFYTDvsPFYTD_GM_Down();
        cls.getFYTDvsPFYTD_GM_Up();
        cls.getFYTDvsPFYTD_GMpct_Down();
        cls.getFYTDvsPFYTD_GMpct_Up();
        cls.getFYTDvsPFYTD_Volume_in_KG_Down();
        cls.getFYTDvsPFYTD_Volume_in_KG_Up();
        cls.getFYTDvsPFYTD_Volume_in_LB_Down();
        cls.getFYTDvsPFYTD_Volume_in_LB_Up();
        cls.printable_view();

        cls.Activities_Desc();
        cls.getOpenOrder_Desc();
        cls.getOrderHistory_desc();
        cls.getSampleRequest_Desc();
        cls.getCnct_desc();
        cls.getClosedActivities_Desc();
        cls.rerenderSR();
        cls.rerendercon();
        cls.rerenderbuscon();
        cls.rerenderOA();
        cls.rerenderCA();
        cls.rerenderCL();
        cls.rerenderOpp();
        cls.rerenderCR();
        cls.rerenderOO();
        cls.rerenderCSP();
        cls.rerenderOH();
        cls.getOpenOrders_NextXDays_items();
        
        cls.getSampleRequest();
        cls.getBusinessContracts_Items();
        cls.getorderhistory_items();
        cls.getCallReports_count();
        cls.getCall_reports_Count();
        cls.getCall_Reports();
        cls.getClosedActivities_NextXDays_Items();
        cls.getCall_Reports_LastXDays_items();
        cls.getOrderHistory_Items();
        cls.getSampleRequest_LastXDays_Items();
        cls.getContactsActStat_Items();
        
    }
    static testMethod void TestMe1() {
    Account testAcct = new Account(Name='TestAccount');
        insert testAcct;
     ApexPages.StandardController sc = new ApexPages.StandardController(testAcct);
        SCPR cls = new SCPR(sc);
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        String testString = '';
        Call_Report__c crc = new Call_Report__c(Account__c = testAcct.id, Competitor__c= testAcct.id,AQ_Attendee_4__c = u.id,Title__c = 'abc');
        insert crc;
    PageReference testPageReference1 = cls.backToAccount();
        PageReference testPageReference2 = cls.Printable_View();
        PageReference testPageReference3 = cls.sortByName();
        PageReference testPageReference4 = cls.sortByStatus();
        PageReference testPageReference5 = cls.filterByStatus();
        
        Boolean testBoolean = cls.getisCustomer();
        testBoolean = cls.getisProspect();
        
        testString = cls.getAccountAddress();
        testString = cls.getAccountDetailSection_Header();
        
        cls.getCallReportDate(crc);
        cls.getCallPurpose(crc);
        cls.truncateValue('test','test1');
    
    } */

}