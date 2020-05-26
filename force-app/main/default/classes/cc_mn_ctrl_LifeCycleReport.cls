/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        02/01/2018
*    Author:             Francisco Garcia
*   Last Modified:       
*   Last Modified By:    
*
*   Short Description:  Controller for LifeCycle report VFP.
*   
*   
*	
*   **********************************************************************************************************************/
global class cc_mn_ctrl_LifeCycleReport {
    public String email {get; set;}
    public String acct {get; set;}
    public String [] accts {get; set;}    
    public String extendedLifeCycleReportsJSON {get; set;}    
    public Id acctId {get; set;}

    public cc_mn_ctrl_LifeCycleReport(){
       email=ccrz.cc_CallContext.currContact.email;
       acct=ccrz.cc_CallContext.effAccount.Name+' ('+ccrz.cc_CallContext.effAccount.AccountNumber+')'; 
       accts=new List<String>();            
       this.extendedLifeCycleReportsJSON = JSON.serialize(buildExtendedLifeCycleMap());
       acctId=ccrz.cc_CallContext.effAccount.Id;
        Map<Id, Account> accounts=new Map<Id, Account>();
        accounts=cc_imp_ctrl_mn_EffectiveAccountSelector.queryAccessibleAccountsWithAddress();                
        for(Account item: accounts.values()){
        	accts.add(item.AccountNumber+' - '+item.Name);            
        }
    }
    @RemoteAction
    global static boolean saveRecord(String datefrom, String tofrom, Id effAcct, String accountswithNumbers, String accountIds){
       try{
            LifeCycle_Report_Request__c lcr = new LifeCycle_Report_Request__c();            
            Boolean isNotReportOnView = true;
            //Spliting by '-' the dates Format month - day - year (Integer year, Integer month, Integer date)
            List <String> startDateList = datefrom.split('-');
			List <String> endDateList = tofrom.split('-');
            Date startDate = Date.newInstance(Integer.valueOf(startDateList[2]), Integer.valueOf(startDateList[0]), Integer.valueOf(startDateList[1]));
            Date endDate = Date.newInstance(Integer.valueOf(endDateList[2]), Integer.valueOf(endDateList[0]), Integer.valueOf(endDateList[1]));
            //In order to verify if report current exists on the list that user can see at this moment
            List<LifeCycle_Report_Request__c> currentReportsOnView = buildExtendedLifeCycleMap();
            for (LifeCycle_Report_Request__c lifeReport:currentReportsOnView) {
                if (lifeReport.From_Date__c.isSameDay(startDate) && lifeReport.To_Date__c.isSameDay(endDate) && lifeReport.Account__c==effAcct) {
					//Already exists on view	
                    isNotReportOnView = false;                    
                }                
            }
            
            if (isNotReportOnView) {
                lcr.From_Date__c = startDate;
                lcr.To_Date__c = endDate;
                lcr.Status__c = 'Requested';
                System.debug('FGG '+ccrz.cc_CallContext.effAccount.Id);
                lcr.Account__c = effAcct;//ccrz.cc_CallContext.effAccount.Id;
                lcr.Contact__c = ccrz.cc_CallContext.currContact.Id;               
                lcr.Accounts_on_Report__c=accountswithNumbers.removeStart('<br>');
                lcr.Account_Numbers__c=accountIds;
                insert lcr;                
            } 
           
         return isNotReportOnView;

        }catch(Exception ex){
       		System.debug('CP-Exception: '+ex.getLineNumber()+' '+ex.getMessage());
			return false;
       }
    }
    
    /**
     *
     * retrieve LifeCycle_Report_Request__c
     *
     * @param: 
     * @return Map of LifeCycle Report SFDC ID 
     */
    public static List<LifeCycle_Report_Request__c> buildExtendedLifeCycleMap() {
        try{
            cc_imp_StorefrontSettings__c customSettings = cc_imp_StorefrontSettings__c.getInstance('mynexeo');
            Integer reportToShow = Integer.valueOf(customSettings.Waste_Summery_Reports_On_Page__c);
       	 	return new List<LifeCycle_Report_Request__c>([SELECT Id, CreatedDate, Status__c, From_Date__c, To_Date__c, Document_ID__c,Account__c,Accounts_on_Report__c FROM LifeCycle_Report_Request__c WHERE Account__c =: ccrz.cc_CallContext.effAccount.Id ORDER BY CreatedDate DESC LIMIT :reportToShow]);
        }catch(Exception ex){
            System.debug('CP-Exception: '+ex.getLineNumber()+' '+ex.getMessage());
            return new List<LifeCycle_Report_Request__c> ();
        }
    }
    

}