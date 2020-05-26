public class Account_Show_Rolling_Product_Extension {

    private final static Integer PRODUCTS_PER_PAGE = 15;

    private final static String DIST_CHAN_AAFI = '50';
    private final static String DIST_CHAN_AHWT = '10';
    private final static String DIST_CHAN_VALV = '40';
    private final static String DIST_CHAN_ASKC = 'Y0';
    
    private Account Account_from_stdController;
    List<Rolling_Product_Sales_Info__c> rollingProductSalesInfo;
	List<Account_Sales_Figure__c> acctSalesFigures;
    Account_Summary_Information accountSummaryInformation;
    
    public Boolean isAAFI {
    	get {
    		return (DIST_CHAN_AAFI.equals(Account_from_stdController.SAP_DistChannel__c));
    	}
    }

    public Boolean isAHWT {
    	get {
            return (DIST_CHAN_AHWT.equals(Account_from_stdController.SAP_DistChannel__c));
    	}
    }
    
    public Boolean isVALV {
        get {
            return (DIST_CHAN_VALV.equals(Account_from_stdController.SAP_DistChannel__c));
        }
    }
    
    public Boolean isASKC {
        get {
            return (DIST_CHAN_ASKC.equals(Account_from_stdController.SAP_DistChannel__c));
        }
    }
    
    public Boolean isAHWT_China {
        get {
            return (SAP_Queries_Functions.isAHWT_China(Account_from_stdController));
        }
    }
    
    public Boolean showGMs {
        get {return (!isAAFI && !isVALV && !isASKC && !isAHWT_China);}
    }

    public Boolean showLBs {get {return (true);}}
    public Boolean showKGs {get {return (!isVALV);}}
    public Boolean showUNs {get {return (isVALV);}}
    public Boolean showGLs {get {return (isVALV);}}
    public Boolean showPTs {get {return (isVALV);}}

    public Integer accountSummaryColumns {get {
    	Integer n = 3;
    	if (showKGs) n++; if (showUNs) n++; if (showGLs) n++; if (showPTs) n++; 
        if (showGMs) n += 2; return n;
    }}

    public Boolean Show_NoData_Message {get; set;}
    public Boolean Show_NoData_Message_JS() { return Show_NoData_Message;}
    
    public Boolean Show_BWData_being_Updated_Message {get; set;}
    public Boolean Show_BWData_being_Updated_Message_JS() { return Show_BWData_being_Updated_Message;}

    public Boolean Show_Data {get; set;}
    
    public Boolean getFYTDvsPFYTD_Volume_in_LB_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_LB_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_LB_Down;}
    public Boolean getFYTDvsPFYTD_Volume_in_KG_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_KG_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_KG_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_KG_Down;}
    public Boolean getFYTDvsPFYTD_Volume_in_UN_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_UN_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_UN_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_UN_Down;}
    public Boolean getFYTDvsPFYTD_Volume_in_GL_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_GL_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_GL_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_GL_Down;}
    public Boolean getFYTDvsPFYTD_Volume_in_PT_Up() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_PT_Up;}
    public Boolean getFYTDvsPFYTD_Volume_in_PT_Down() {return accountSummaryInformation.FYTDvsPFYTD_Volume_in_PT_Down;}
    public Boolean getFYTDvsPFYTD_Amount_Up() {return accountSummaryInformation.FYTDvsPFYTD_Amount_Up;}
    public Boolean getFYTDvsPFYTD_Amount_Down() {return accountSummaryInformation.FYTDvsPFYTD_Amount_Down;}
    public Boolean getFYTDvsPFYTD_GM_Up() {return accountSummaryInformation.FYTDvsPFYTD_GM_Up;}
    public Boolean getFYTDvsPFYTD_GM_Down() {return accountSummaryInformation.FYTDvsPFYTD_GM_Down;}
    public Boolean getFYTDvsPFYTD_GMpct_Up() {return accountSummaryInformation.FYTDvsPFYTD_GMpct_Up;}
    public Boolean getFYTDvsPFYTD_GMpct_Down() {return accountSummaryInformation.FYTDvsPFYTD_GMpct_Down;}
    
    Map<Integer,List<Rolling_Product_Sales_Info_Line>> Paged_rollingProductSalesInfo = new Map<Integer,List<Rolling_Product_Sales_Info_Line>>();
    
    List<Rolling_Product_Sales_Info_Line> Rolling_Product_Sales_Info_Line_Items = new List<Rolling_Product_Sales_Info_Line>();
    
    public String labelMonth01 {get; set;}
    public String labelMonth02 {get; set;}
    public String labelMonth03 {get; set;}
    public String labelMonth04 {get; set;}
    public String labelMonth05 {get; set;}
    public String labelMonth06 {get; set;}
    public String labelMonth07 {get; set;}
    public String labelMonth08 {get; set;}
    public String labelMonth09 {get; set;}
    public String labelMonth10 {get; set;}
    public String labelMonth11 {get; set;}
    public String labelMonth12 {get; set;}
    public String labelMonth13 {get; set;}

    public String materialId   {get; set;}
    public String materialName {get; set;}
    public List<SelectOption> materialOptions {get; private set;}
    
    public Boolean show_Volume_in_LBs {get; set;}
    public Boolean show_Volume_in_KGs {get; set;}
    public Boolean show_Volume_in_UNs {get; set;}
    public Boolean show_Volume_in_GLs {get; set;}
    public Boolean show_Volume_in_PTs {get; set;}
    public Boolean show_Amounts {get; set;}
    public Boolean show_GMs {get; set;}
    public Boolean show_GMpcts {get; set;}

    public Integer currentPage {get; set;}
    public Integer pageCount {get; set;}

	public Boolean getshow_NextPageButton() {
		if (currentPage < pageCount) {return true;} else {return false;}
	} 
	public Boolean getshow_PreviousPageButton() {
		if (currentPage > 1) {return true;} else {return false;}
	} 

	public void previousPage() {
		if (currentPage > 1) {currentPage = currentPage - 1;}
	}
    
	public void nextPage() {
		if (currentPage < pageCount) {currentPage += 1;}
	}
    
	public void goToPage()
	{
		Integer pageNumber = Integer.valueOf(System.currentPageReference().getParameters().get('pageNumber'));
		if ((pageNumber > 0) && (pageNumber <= pageCount)) {currentPage = pageNumber;}
	}
	
	public void searchByMaterialId() {
        materialName = null;
        InitialActions();
	}
    
    public void searchByMaterialName() {
        materialId = null;
        InitialActions();
    }
    
    public String getPageInfo() {
		return 'Page ' + currentPage + ' of ' + pageCount;    	
    }
    
    public List<Integer> getpages() {
    	List<Integer> results = new List<Integer>();
    	for(Integer i=1;i <=pageCount; i++) {results.add(i);}
    	return results;
    }
    
    public String getRollingTitle() {
		String result = '';
    	if(show_Volume_in_LBs) {result = 'Volume in Pounds';}
    	if(show_Volume_in_KGs) {result = 'Volume in KGs';}
        if(show_Volume_in_GLs) {result = 'Volume in Gallons';}
        if(show_Volume_in_PTs) {result = 'Volume in Points';}
        if(show_Volume_in_UNs) {result = 'Volume in Units';}
    	if(show_Amounts) {result = 'Amount';}
    	if(show_GMs) {result = getGmGpLabelLong();}
    	if(show_GMpcts) {result = getGmGpLabelLong()+' Percent';}
    	return result;
    }
    
    public String getGmGpLabel() {
        String s = 'GM';
        if (isAHWT) {s = 'GP';}
        return s;
    }
    
    private String getGmGpLabelLong() {
    	String s = 'Gross Margin';
    	if (isAHWT) {s = 'Gross Profit';}
    	return s;
    }
    
    public Account_Show_Rolling_Product_Extension(ApexPages.StandardController Controller) {
        this.Account_from_stdController = (Account)Controller.getRecord();
        setAccount();
        InitialActions();
    }

	public void InitialActions() {
		pageCount = 1;		
		currentPage = 1;

 		Show_NoData_Message = false;
    	Show_BWData_being_Updated_Message = false;
    	Show_Data = true;
        rollingProductSalesInfo = null;
        
        getRolling_Product_Sales_Info();
        if (isVALV) 
             {button_Show_Volume_in_UNs();}
        else {button_Show_Volume_in_LBs();}
	}
	
	private void setAccount() {
		Id accId = Account_from_stdController.Id;
		try {
			Account_from_stdController = [select Id, Name,
			                                     SAP_DistChannel__c,
			                                     SAP_Sales_Org__c
			                                from Account
			                               where Id = :accId
			                             ];
            materialOptions = Rolling_Product_Sales_Info_Functions2.getMaterialSelectOptions(accId);
		} catch (Exception e) {System.debug(e.getMessage());}
	}

	public void button_Show_Volume_in_LBs() {
        show_Volume_in_LBs = true;
        show_Volume_in_KGs = false;
        show_Volume_in_UNs = false;
        show_Volume_in_GLs = false;
        show_Volume_in_PTs = false;
        show_Amounts = false;
        show_GMs = false;
        show_GMpcts = false;
        for (Rolling_Product_Sales_Info_Line r:Rolling_Product_Sales_Info_Line_Items) {r.ValueType = 'VolumeinLB';}
	}

	public void button_Show_Volume_in_KGs() {
        show_Volume_in_LBs = false;
        show_Volume_in_KGs = true;
        show_Volume_in_UNs = false;
        show_Volume_in_GLs = false;
        show_Volume_in_PTs = false;
        show_Amounts = false;
        show_GMs = false;
        show_GMpcts = false;
        for (Rolling_Product_Sales_Info_Line r:Rolling_Product_Sales_Info_Line_Items) {r.ValueType = 'VolumeinKG';}
	}

    public void button_Show_Volume_in_UNs() {
        show_Volume_in_LBs = false;
        show_Volume_in_KGs = false;
        show_Volume_in_UNs = true;
        show_Volume_in_GLs = false;
        show_Volume_in_PTs = false;
        show_Amounts = false;
        show_GMs = false;
        show_GMpcts = false;
        for (Rolling_Product_Sales_Info_Line r:Rolling_Product_Sales_Info_Line_Items) {r.ValueType = 'VolumeinUN';}
    }

    public void button_Show_Volume_in_GLs() {
        show_Volume_in_LBs = false;
        show_Volume_in_KGs = false;
        show_Volume_in_UNs = false;
        show_Volume_in_GLs = true;
        show_Volume_in_PTs = false;
        show_Amounts = false;
        show_GMs = false;
        show_GMpcts = false;
        for (Rolling_Product_Sales_Info_Line r:Rolling_Product_Sales_Info_Line_Items) {r.ValueType = 'VolumeinGL';}
    }

    public void button_Show_Volume_in_PTs() {
        show_Volume_in_LBs = false;
        show_Volume_in_KGs = false;
        show_Volume_in_UNs = false;
        show_Volume_in_GLs = false;
        show_Volume_in_PTs = true;
        show_Amounts = false;
        show_GMs = false;
        show_GMpcts = false;
        for (Rolling_Product_Sales_Info_Line r:Rolling_Product_Sales_Info_Line_Items) {r.ValueType = 'VolumeinPT';}
    }

	public void button_Show_Amounts() {
        System.debug('Beginning of button Call for Amount');
        show_Volume_in_LBs = false;
        show_Volume_in_KGs = false;
        show_Volume_in_UNs = false;
        show_Volume_in_GLs = false;
        show_Volume_in_PTs = false;
        show_Amounts = true;
        show_GMs = false;
        show_GMpcts = false;
        System.debug('End of button Call for Amount');
        for (Rolling_Product_Sales_Info_Line r:Rolling_Product_Sales_Info_Line_Items) {r.ValueType = 'Amount';}
	}

	public void button_Show_GMs() {
        show_Volume_in_LBs = false;
        show_Volume_in_KGs = false;
        show_Volume_in_UNs = false;
        show_Volume_in_GLs = false;
        show_Volume_in_PTs = false;
        show_Amounts = false;
        show_GMs = showGMs;
        show_GMpcts = false;
        for (Rolling_Product_Sales_Info_Line r:Rolling_Product_Sales_Info_Line_Items) {r.ValueType = 'GM';}
	}

	public void button_Show_GMpcts() {
        show_Volume_in_LBs = false;
        show_Volume_in_KGs = false;
        show_Volume_in_UNs = false;
        show_Volume_in_GLs = false;
        show_Volume_in_PTs = false;
        show_Amounts = false;
        show_GMs = false;
        show_GMpcts = showGMs;
        for (Rolling_Product_Sales_Info_Line r:Rolling_Product_Sales_Info_Line_Items) {r.ValueType = 'GMpct';}
	}
	
    public Account_Summary_Information getAccountSummaryInformation() {
        if (accountSummaryInformation == null) {
            accountSummaryInformation = new Account_Summary_Information();
            try {
                acctSalesFigures = [
                    SELECT Id, Name, 
                           Account__c, 
                           CreatedById, 
                           CreatedDate, 
                           CurrencyIsoCode, 
                           Date_Range_Label__c, 
                           End_Date__c, 
                           GM__c, 
                           GMpct__c,
                           LastModifiedById, 
                           LastModifiedDate, 
                           Sales_Amount__c, 
                           Sales_Vol_in_KGs__c,
                           Sales_Volume_in_LBs__c, 
                           Sales_Volume_in_UNs__c, 
                           Sales_Volume_in_GALs__c, 
                           Sales_Volume_in_PTs__c, 
                           Start_Date__c, 
                           SystemModstamp 
                      FROM Account_Sales_Figure__c
                     WHERE Account__c = :Account_from_stdController.Id
                       AND Start_Date__c >= :accountSummaryInformation.getPFYStartDate()
                       AND End_Date__c <= :accountSummaryInformation.getCFYEndDate()
                ];
                for(Account_Sales_Figure__c f:acctSalesFigures) {
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
                                                      f.CurrencyIsoCode);
                }                                           
            } catch (Exception e) {System.debug('Error - getAccountSummaryInformation - ' + e);}
        }
        return accountSummaryInformation;
    }
    
    public List<Rolling_Product_Sales_Info_Line> getRolling_Product_Sales_Info() {
        
        if (rollingProductSalesInfo == null) {
            Rolling_Product_Sales_Info_Line_Items = new List<Rolling_Product_Sales_Info_Line>();
            Paged_rollingProductSalesInfo = new Map<Integer,List<Rolling_Product_Sales_Info_Line>>();
            try {
                rollingProductSalesInfo = Rolling_Product_Sales_Info_Functions2.getRollingProductSalesInfo(
                                          Account_from_stdController.Id, materialId, materialName);
	            if (rollingProductSalesInfo.size() > 0)	{
					labelMonth01 = rollingProductSalesInfo[0].Label_Month_01__c.replace('-','<BR>');	   
					labelMonth02 = rollingProductSalesInfo[0].Label_Month_02__c.replace('-','<BR>');	                               
					labelMonth03 = rollingProductSalesInfo[0].Label_Month_03__c.replace('-','<BR>');	                               
					labelMonth04 = rollingProductSalesInfo[0].Label_Month_04__c.replace('-','<BR>');	                               
					labelMonth05 = rollingProductSalesInfo[0].Label_Month_05__c.replace('-','<BR>');	                               
					labelMonth06 = rollingProductSalesInfo[0].Label_Month_06__c.replace('-','<BR>');	                               
					labelMonth07 = rollingProductSalesInfo[0].Label_Month_07__c.replace('-','<BR>');	                               
					labelMonth08 = rollingProductSalesInfo[0].Label_Month_08__c.replace('-','<BR>');	                               
					labelMonth09 = rollingProductSalesInfo[0].Label_Month_09__c.replace('-','<BR>');	                               
					labelMonth10 = rollingProductSalesInfo[0].Label_Month_10__c.replace('-','<BR>');	                               
					labelMonth11 = rollingProductSalesInfo[0].Label_Month_11__c.replace('-','<BR>');	                               
					labelMonth12 = rollingProductSalesInfo[0].Label_Month_12__c.replace('-','<BR>');	                               
					labelMonth13 = rollingProductSalesInfo[0].Label_Month_13__c.replace('-','<BR>');	                               
	
					for (Rolling_Product_Sales_Info__c r:rollingProductSalesInfo) {
					    Rolling_Product_Sales_Info_Line newRPSILine = new Rolling_Product_Sales_Info_Line(r.Id,r,r.Material2__r.Name);
					    Rolling_Product_Sales_Info_Line_Items.add(newRPSILine);
					}
						
					//Populate the Paged Version
					Integer pageNumber = 1;
					Integer recCount = 0;
					List<Rolling_Product_Sales_Info_Line> newPage;
					
					for (Rolling_Product_Sales_Info_Line li:Rolling_Product_Sales_Info_Line_Items) {
						recCount += 1;
						if (recCount > PRODUCTS_PER_PAGE) {
							pageNumber += 1;
							recCount = 1;
						}
						
						if (recCount == 1) {
							//Id recCount = 1, make a new map and add it to the pages
							newPage = new List<Rolling_Product_Sales_Info_Line>();
							Paged_rollingProductSalesInfo.put(pageNumber,newPage);
						}
						newPage.add(li);
						Paged_rollingProductSalesInfo.put(pageNumber,newPage);
					}
					
					currentPage = 1;
					pageCount = pageNumber;	
	           	}					
            } catch (Exception e) {System.debug('Error - getRolling_Product_Sales_Info - ' + e);}

            getAccountSummaryInformation();

        }
        //return Rolling_Product_Sales_Info_Line_Items;


 		Show_NoData_Message = false;
    	Show_BWData_being_Updated_Message = false;
    	Show_Data = true;

		if (acctSalesFigures == null || (acctSalesFigures.size() == 0)) {  
		    Show_NoData_Message = true;Show_Data = false;
		} else {
			Show_NoData_Message = false;Show_Data = true;
		}
		
        Boolean updatingBWData = CustomSettings_Functions.getBW_Data_Updating();
        
    	String userProfileName = '';
    	try { userProfileName = [SELECT Name FROM Profile WHERE id = :UserInfo.getProfileId()].Name;}
    	catch (Exception e) {} 
    	
    	Boolean userIsAdmin = false; 
    	if ((userProfileName == 'System Administrator') || (userProfileName == 'System Administrator - SSO Enabled'))
    		{userIsAdmin = true;}
        
        if (updatingBWData && !userIsAdmin)
        	{Show_BWData_being_Updated_Message = true;Show_NoData_Message = false;Show_Data = false;}
        	
        if (updatingBWData && userIsAdmin)
        	{Show_BWData_being_Updated_Message = false;Show_NoData_Message = false;Show_Data = true;}
        
        if ((currentPage != null) && (Paged_rollingProductSalesInfo != null))
        	return Paged_rollingProductSalesInfo.get(currentPage);
        else
        	return null;
    }

}