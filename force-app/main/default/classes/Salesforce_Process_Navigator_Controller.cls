public class Salesforce_Process_Navigator_Controller {

    private List<Salesforce_Process> Salesforce_Processes;

    public String getHTML_Line_Break() {return '<BR>';}
    public String getHTML_Line() {return '<HR>';}
    public String getHTML_CenterOn() {return '<CENTER>';}
    public String getHTML_CenterOff() {return '</CENTER>';}
    public String getHTML_BoldOn() {return '<B>';}
    public String getHTML_BoldOff() {return '</B>';}
    public String getHTML_nbsp() {return '&nbsp';}
    
    public List<String> Businesses { get; set; }
    public List<String> Rollout_Regions { get; set; }
    public List<String> Salesforce_Objects { get; set; }
    public List<String> User_Roles { get; set; }
    public boolean showDescriptions { get; private set; }
    public boolean showCategories { get; private set; }
    public boolean limittoProcesseswithMetrics { get; private set; }
    
    
    public Salesforce_Process_Navigator_Controller() {
        
        /*
        Businesses = new List<String>();
        Rollout_Regions = new List<String>();
        Salesforce_Objects = new List<String>();
        User_Roles = new List<String>();
        
        for(SelectOption item:getBusiness_items()) {Businesses.add(item.getLabel());}
        for(SelectOption item:getRollout_Region_items()) {Rollout_Regions.add(item.getLabel());}
        for(SelectOption item:getSalesforce_Object_items()) {Salesforce_Objects.add(item.getLabel());}
        for(SelectOption item:getUser_Role_items()) {User_Roles.add(item.getLabel());}
        */
        
        selectAllBusinesses();
        selectAllRollout_Regions();
        selectAllSalesforce_Objects();
        selectAllUser_Roles();
        
        showDescriptions   = false;
        showCategories     = true;
        limittoProcesseswithMetrics = false;
    }

    public void toggle_showDescriptions() { showDescriptions = !showDescriptions; }
    public void toggle_showCategories() { showCategories = !showCategories; }
    public void toggle_limittoProcesseswithMetrics() { limittoProcesseswithMetrics = !limittoProcesseswithMetrics; }

    public void selectAllBusinesses() {Businesses = new List<String>();for(SelectOption item:getBusiness_items()) {Businesses.add(item.getLabel());}}
    public void selectAllRollout_Regions() {Rollout_Regions = new List<String>();for(SelectOption item:getRollout_Region_items()) {Rollout_Regions.add(item.getLabel());}}
    public void selectAllSalesforce_Objects() {Salesforce_Objects = new List<String>();for(SelectOption item:getSalesforce_Object_items()) {Salesforce_Objects.add(item.getLabel());}}
    public void selectAllUser_Roles() {User_Roles = new List<String>();for(SelectOption item:getUser_Role_items()) {User_Roles.add(item.getLabel());}}

    public void populateSalesforce_Processes() {

        if (Salesforce_Processes == null) 
            {

            Salesforce_Processes = new List<Salesforce_Process>();

            List<Salesforce_Process__c> recs;
            
                
            recs = [SELECT  Id,
                            SFDC_Functionality_Name__c,
                            AI_Mega_Process__c,
                            AI_Process__c,
                            Business__c,
                            Detailed_Description__c,
                            Importance__c,
                            Link_to_Example__c,
                            Link_to_Metrics_1__c,
                            Link_to_Metrics_2__c,
                            Measurable__c,
                            Metric_1_Description__c,
                            Metric_2_Description__c,
                            Rollout_Area__c,
                            Salesforce_Objects__c,
                            User_Roles__c
                       FROM Salesforce_Process__c];
                           
            for(Salesforce_Process__c rec:recs)
                {

                String formatted_Businesses = rec.Business__c;
                String formatted_Rollout_Areas = rec.Rollout_Area__c;
                String formatted_User_Roles = rec.User_Roles__c;
                String formatted_Salesforce_Objects = rec.Salesforce_Objects__c;
/*                  
                if (rec.Business__c != null)           {formatted_Businesses = rec.Business__c.replaceAll(';','<BR>');}
                if (rec.Rollout_Area__c != null)       {formatted_Rollout_Areas = rec.Rollout_Area__c.replaceAll(';','<BR>');}
                if (rec.User_Roles__c != null)         {formatted_User_Roles = rec.User_Roles__c.replaceAll(';','<BR>');}
                if (rec.Salesforce_Objects__c != null) {formatted_Salesforce_Objects = rec.Salesforce_Objects__c.replaceAll(';','<BR>');}
*/                  
                Salesforce_Processes.add(new Salesforce_Process(rec,
                                                                formatted_Businesses,
                                                                formatted_Rollout_Areas,
                                                                formatted_User_Roles,
                                                                formatted_Salesforce_Objects)
                                        );
                }                      
                
            }
            
    }



    public List<Salesforce_Process> getProcessRecordstoDisplay() {

        List<String> Businesses_on_Process = new List<String>();
        List<String> Rollout_Regions_on_Process = new List<String>(); 
        List<String> Salesforce_Objects_on_Process = new List<String>();
        List<String> User_Roles_on_Process = new List<String>();
        
        populateSalesforce_Processes();
        
        List<Salesforce_Process> processes = new List<Salesforce_Process>();
        for (Salesforce_Process process:Salesforce_Processes)
            {
            Boolean Businesses_OK = false;
            Boolean Rollout_Regions_OK = false;
            Boolean Salesforce_Objects_OK = false;
            Boolean User_Roles_OK = false;

            //Format Multi Select Picklists based on Selection
            String formatted_Businesses = process.SF_Process.Business__c;
            String formatted_Rollout_Areas = process.SF_Process.Rollout_Area__c;
            String formatted_User_Roles = process.SF_Process.User_Roles__c;
            String formatted_Salesforce_Objects = process.SF_Process.Salesforce_Objects__c;
                
            //First, change the semi-colons to <BR> new lines
            if (formatted_Businesses != null)         {formatted_Businesses = formatted_Businesses.replaceAll(';','<BR>');}
            if (formatted_Rollout_Areas != null)      {formatted_Rollout_Areas = formatted_Rollout_Areas.replaceAll(';','<BR>');}
            if (formatted_User_Roles != null)         {formatted_User_Roles = formatted_User_Roles.replaceAll(';','<BR>');}
            if (formatted_Salesforce_Objects != null) {formatted_Salesforce_Objects = formatted_Salesforce_Objects.replaceAll(';','<BR>');}


            if (process.SF_Process.Business__c != null) {Businesses_on_Process = process.SF_Process.Business__c.split(';');} else {Businesses_on_Process = new List<String>();}
             
            for(String item:Businesses_on_Process)
                {
                for(String selected:Businesses)
                    {if (item == selected) 
                        {
                        formatted_Businesses = formatted_Businesses.replaceAll(selected,'<span style="font-weight:bold; font-size: 1.25em;">' + selected + '</span>');
                        Businesses_OK = true;
                        }
                    }
                } 
            process.formatted_Businesses = formatted_Businesses;

            if (process.SF_Process.Rollout_Area__c != null) {Rollout_Regions_on_Process = process.SF_Process.Rollout_Area__c.split(';');} else {Rollout_Regions_on_Process = new List<String>();}
             
            for(String item:Rollout_Regions_on_Process)
                {for(String selected:Rollout_Regions)
                    {if (item == selected) 
                        {
                        formatted_Rollout_Areas = formatted_Rollout_Areas.replaceAll(selected,'<span style="font-weight:bold; font-size: 1.25em;">' + selected + '</span>');
                        Rollout_Regions_OK = true;
                        }
                    }
                } 
            process.formatted_Rollout_Areas = formatted_Rollout_Areas;

            if (process.SF_Process.Salesforce_Objects__c != null) {Salesforce_Objects_on_Process = process.SF_Process.Salesforce_Objects__c.split(';');} else {Salesforce_Objects_on_Process = new List<String>();}
             
            for(String item:Salesforce_Objects_on_Process)
                {for(String selected:Salesforce_Objects)
                    {if (item == selected) 
                        {
                        formatted_Salesforce_Objects = formatted_Salesforce_Objects.replaceAll(selected,'<span style="font-weight:bold; font-size: 1.25em;">' + selected + '</span>');
                        Salesforce_Objects_OK = true;
                        }
                    }
                } 
            process.formatted_Salesforce_Objects = formatted_Salesforce_Objects;

            if (process.SF_Process.User_Roles__c != null) {User_Roles_on_Process = process.SF_Process.User_Roles__c.split(';');} else {User_Roles_on_Process = new List<String>();}
             
            for(String item:User_Roles_on_Process)
                {for(String selected:User_Roles)
                    {if (item == selected) 
                        {
                        formatted_User_Roles = formatted_User_Roles.replaceAll(selected,'<span style="font-weight:bold; font-size: 1.25em;">' + selected + '</span>');
                        User_Roles_OK = true;
                        }
                    }
                }  
            process.formatted_User_Roles = formatted_User_Roles;

            
            if ( 
                ((limittoProcesseswithMetrics == false) ||
                ((limittoProcesseswithMetrics == true) && (process.SF_Process.Link_to_Metrics_1__c <> null))) &&
                (Businesses_OK) &&
                (Rollout_Regions_OK) &&
                (Salesforce_Objects_OK) &&
                (User_Roles_OK) 
               )
                
                {
                
                processes.add(process);}
            }   
        return processes;
    }
    


  public String getTopText() {
    String txt = '';
    txt = '';
    //txt += '<CENTER><B>Salesforce Process Navigator Instructions</B></CENTER<BR><BR>';
    txt += 'The Process Navigator allows for browsing of all Ashland Saleforce Processes.  These processes can be filtered by Business, Rollout Region, Business Role, and Salesforce Object. Processes that have metrics or examples will have links to open these in a new window.  An option to only show processes that have Metrics is also available.<BR><BR>';

    return txt;
  }

    public List<SelectOption> getBusiness_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Distribution','Distribution'));
        options.add(new SelectOption('Performance Materials','Performance Materials'));
        options.add(new SelectOption('Valvoline','Valvoline'));
        options.add(new SelectOption('Water','Water'));
        options.add(new SelectOption('Environmental Services','Environmental Services'));
        return options;
    }

    public List<SelectOption> getUser_Role_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Sales','Sales'));
        options.add(new SelectOption('Customer Service','Customer Service'));
        options.add(new SelectOption('Marketing','Marketing'));
        options.add(new SelectOption('Sourcing','Sourcing'));
        options.add(new SelectOption('Purchasing','Purchasing'));
        return options;
    }

    public List<SelectOption> getRollout_Region_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('US','US'));
        options.add(new SelectOption('EMEA','EMEA'));
        options.add(new SelectOption('CHINA','CHINA'));
        return options;
    }

    public List<SelectOption> getSalesforce_Object_items() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Account',                                           'Account'));
        options.add(new SelectOption('Account_Group__c',                                  'Account_Group__c'));
        options.add(new SelectOption('Account_Plan__c',                                   'Account_Plan__c'));
        options.add(new SelectOption('ActivityHistory',                                   'ActivityHistory'));
        options.add(new SelectOption('Asset',                                             'Asset'));
        options.add(new SelectOption('AssignmentRule',                                    'AssignmentRule'));
        options.add(new SelectOption('Attachment',                                        'Attachment'));
        options.add(new SelectOption('Business_Volume__c',                                'Business_Volume__c'));
        options.add(new SelectOption('BusinessHours',                                     'BusinessHours'));
        options.add(new SelectOption('BusinessProcess',                                   'BusinessProcess'));
        options.add(new SelectOption('CallCenter',                                        'CallCenter'));
        options.add(new SelectOption('Campaign',                                          'Campaign'));
        options.add(new SelectOption('CampaignMember',                                    'CampaignMember'));
        options.add(new SelectOption('CampaignMemberStatus',                              'CampaignMemberStatus'));
        options.add(new SelectOption('CampaignShare',                                     'CampaignShare'));
        options.add(new SelectOption('Case',                                              'Case'));
        options.add(new SelectOption('CaseComment',                                       'CaseComment'));
        options.add(new SelectOption('CaseContactRole',                                   'CaseContactRole'));
        options.add(new SelectOption('CIS_Case_Material__c',                              'CIS_Case_Material__c'));
        options.add(new SelectOption('CIS_Customer_Information_Packets__c',               'CIS_Customer_Information_Packets__c'));
        options.add(new SelectOption('CIS_Drew_Account_Group__c',                         'CIS_Drew_Account_Group__c'));
        options.add(new SelectOption('CIS_Drew_Account_Group__Share',                     'CIS_Drew_Account_Group__Share'));
        options.add(new SelectOption('CIS_Drew_Account_Group_Member__c',                  'CIS_Drew_Account_Group_Member__c'));
        options.add(new SelectOption('CIS_Groups_Members__c',                             'CIS_Groups_Members__c'));
        options.add(new SelectOption('CIS_Materials__c',                                  'CIS_Materials__c'));
        options.add(new SelectOption('CIS_Materials__History',                            'CIS_Materials__History'));
        options.add(new SelectOption('CIS_PM_Call_Reports__c',                            'CIS_PM_Call_Reports__c'));
        options.add(new SelectOption('CISExpense__c',                                     'CISExpense__c'));
        options.add(new SelectOption('CISRelationships__c',                               'CISRelationships__c'));
        options.add(new SelectOption('Competitor__c',                                     'Competitor__c'));
        options.add(new SelectOption('Competitor_to_Account__c',                          'Competitor_to_Account__c'));
        options.add(new SelectOption('Competitor_to_Opportunity__c',                      'Competitor_to_Opportunity__c'));
        options.add(new SelectOption('Contact',                                           'Contact'));
        options.add(new SelectOption('Contract',                                          'Contract'));
        options.add(new SelectOption('Core_Review_Item__c',                               'Core_Review_Item__c'));
        options.add(new SelectOption('Customer_Text__c',                                  'Customer_Text__c'));
        options.add(new SelectOption('DatedConversionRate',                               'DatedConversionRate'));
        options.add(new SelectOption('Delivery_Cities__c',                                'Delivery_Cities__c'));
        options.add(new SelectOption('Document',                                          'Document'));
        options.add(new SelectOption('DocumentAttachmentMap',                             'DocumentAttachmentMap'));
        options.add(new SelectOption('Electronic_Connection_Request__c',                  'Electronic_Connection_Request__c'));
        options.add(new SelectOption('Electronic_Documents__c',                           'Electronic_Documents__c'));
        options.add(new SelectOption('Email_Destination_Lookup__c',                       'Email_Destination_Lookup__c'));
        options.add(new SelectOption('EmailStatus',                                       'EmailStatus'));
        options.add(new SelectOption('EmailTemplate',                                     'EmailTemplate'));
        options.add(new SelectOption('Event',                                             'Event'));
        options.add(new SelectOption('EventAttendee',                                     'EventAttendee'));
        options.add(new SelectOption('FiscalYearSettings',                                'FiscalYearSettings'));
        options.add(new SelectOption('Folder',                                            'Folder'));
        options.add(new SelectOption('ForecastShare',                                     'ForecastShare'));
        options.add(new SelectOption('Group',                                             'Group'));
        options.add(new SelectOption('GroupMember',                                       'GroupMember'));
        options.add(new SelectOption('HQ_Customer_Relationship__c',                       'HQ_Customer_Relationship__c'));
        options.add(new SelectOption('Label_Request__c',                                  'Label_Request__c'));
        options.add(new SelectOption('Lead',                                              'Lead'));
        options.add(new SelectOption('MailmergeTemplate',                                 'MailmergeTemplate'));
        options.add(new SelectOption('Material_by_Plant__c',                              'Material_by_Plant__c'));
        options.add(new SelectOption('Note',                                              'Note'));
        options.add(new SelectOption('NoteAndAttachment',                                 'NoteAndAttachment'));
        options.add(new SelectOption('Operations_Checklist__c',                           'Operations_Checklist__c'));
        options.add(new SelectOption('Opportunity',                                       'Opportunity'));
        options.add(new SelectOption('Opportunity_Material_Name__c',                      'Opportunity_Material_Name__c'));
        options.add(new SelectOption('OpportunityCompetitor',                             'OpportunityCompetitor'));
        options.add(new SelectOption('Period',                                            'Period'));
        options.add(new SelectOption('Profile',                                           'Profile'));
        options.add(new SelectOption('Purchase_Training_Days__c',                         'Purchase_Training_Days__c'));
        options.add(new SelectOption('Quarterly_Ckecklists__c',                           'Quarterly_Ckecklists__c'));
        options.add(new SelectOption('Request_for_Traffic_Service__c',                    'Request_for_Traffic_Service__c'));
        options.add(new SelectOption('Request_for_Traffic_Service_Carrier__c',            'Request_for_Traffic_Service_Carrier__c'));
        options.add(new SelectOption('Request_for_Traffic_Service_Container__c',          'Request_for_Traffic_Service_Container__c'));
        options.add(new SelectOption('Request_for_Traffic_Service_Equipment__c',          'Request_for_Traffic_Service_Equipment__c'));
        options.add(new SelectOption('Request_for_Traffic_Service_Tank__c',               'Request_for_Traffic_Service_Tank__c'));
        options.add(new SelectOption('Role_Category__c',                                  'Role_Category__c'));
        options.add(new SelectOption('Sales_Forecast__c',                                 'Sales_Forecast__c'));
        options.add(new SelectOption('Sample_Material__c',                                'Sample_Material__c'));
        options.add(new SelectOption('Sample_Request__c',                                 'Sample_Request__c'));
        options.add(new SelectOption('Sample_Request_Approval_Process__c',                'Sample_Request_Approval_Process__c'));
        options.add(new SelectOption('SAP_Sales_Org_Lookup__c',                           'SAP_Sales_Org_Lookup__c'));
        options.add(new SelectOption('Shipping_Instruction__c',                           'Shipping_Instruction__c'));
        options.add(new SelectOption('Shipping_Instruction_Product__c',                   'Shipping_Instruction_Product__c'));
        options.add(new SelectOption('Solution',                                          'Solution'));
        options.add(new SelectOption('Strategy__c',                                       'Strategy__c'));
        options.add(new SelectOption('Strategy2Opp__c',                                   'Strategy2Opp__c'));
        options.add(new SelectOption('Tank_Inspection__c',                                'Tank_Inspection__c'));
        options.add(new SelectOption('Tank_Requirement__c',                               'Tank_Requirement__c'));
        options.add(new SelectOption('Task',                                              'Task'));
        options.add(new SelectOption('TaskPriority',                                      'TaskPriority'));
        options.add(new SelectOption('TaskStatus',                                        'TaskStatus'));
        options.add(new SelectOption('Training_Assessment_Information__c',                'Training_Assessment_Information__c'));
        options.add(new SelectOption('Training_Class__c',                                 'Training_Class__c'));
        options.add(new SelectOption('Training_Created_By_Change__c',                     'Training_Created_By_Change__c'));
        options.add(new SelectOption('Training_Environment__c',                           'Training_Environment__c'));
        options.add(new SelectOption('Training_Field_Override__c',                        'Training_Field_Override__c'));
        options.add(new SelectOption('Training_History__c',                               'Training_History__c'));
        options.add(new SelectOption('Training_Information__c',                           'Training_Information__c'));
        options.add(new SelectOption('Training_Outline__c',                               'Training_Outline__c'));
        options.add(new SelectOption('Training_Ownership_Change__c',                      'Training_Ownership_Change__c'));
        options.add(new SelectOption('Training_Participants__c',                          'Training_Participants__c'));
        options.add(new SelectOption('Training_Profile__c',                               'Training_Profile__c'));
        options.add(new SelectOption('Training_Record_to_Copy__c',                        'Training_Record_to_Copy__c'));
        options.add(new SelectOption('Training_Session_Detail__c',                        'Training_Session_Detail__c'));
        options.add(new SelectOption('Training_User__c',                                  'Training_User__c'));
        options.add(new SelectOption('Training_User_Role__c',                             'Training_User_Role__c'));
        options.add(new SelectOption('UOM_Conversion__c',                                 'UOM_Conversion__c'));
        options.add(new SelectOption('User',                                              'User'));
        options.add(new SelectOption('User_Detail__c',                                    'User_Detail__c'));
        options.add(new SelectOption('UserAccountTeamMember',                             'UserAccountTeamMember'));
        options.add(new SelectOption('UserLicense',                                       'UserLicense'));
        options.add(new SelectOption('UserPreference',                                    'UserPreference'));
        options.add(new SelectOption('UserRole',                                          'UserRole'));
        options.add(new SelectOption('UserTeamMember',                                    'UserTeamMember'));
        options.add(new SelectOption('W_Value_Delivered_Project__c',                      'W_Value_Delivered_Project__c'));
        options.add(new SelectOption('WebLink',                                           'WebLink'));
        options.add(new SelectOption('WebLinkLocalization',                               'WebLinkLocalization'));
        options.add(new SelectOption('xtma_Email_Result__c',                              'xtma_Email_Result__c'));
        options.add(new SelectOption('xtma_Individual_Email_Result__c',                   'xtma_Individual_Email_Result__c'));
        options.add(new SelectOption('xtma_Link_Detail__c',                               'xtma_Link_Detail__c'));
        options.add(new SelectOption('N/A',                                               'N/A'));
        return options;
    }

   //******************
   //Test Method 
   //******************
   static testMethod void TestMe() {

       Salesforce_Process_Navigator_Controller cls = new Salesforce_Process_Navigator_Controller();  
    
       String StringTester = '';
    
       StringTester = cls.getHTML_Line_Break();
       StringTester = cls.getHTML_Line();
       StringTester = cls.getHTML_CenterOn();
       StringTester = cls.getHTML_CenterOff();
       StringTester = cls.getHTML_BoldOn();
       StringTester = cls.getHTML_BoldOff();
       cls.getHTML_nbsp();
       cls.toggle_showDescriptions();
       cls.toggle_showCategories();
       cls.toggle_limittoProcesseswithMetrics();
    
       List<SelectOption> holdBusiness_Items = cls.getBusiness_items();
       List<Salesforce_Process> processes = cls.getProcessRecordstoDisplay();
    
       StringTester = cls.getTopText();
   }


}