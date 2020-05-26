public with sharing class Material_Sales_Data2_Controller {
    private final Material_Sales_Data2__c msd;
    string id;
    private final String userProfileName;
    private final Set<String> allViewProfiles = new Set<String>{
        'CA Team - Tier 3 Support',
        'System Administrator',
        'System Administrator - SSO Enabled'
    };

    private final Set<String> baseCodeViewProfiles = new Set<String>{
        'W-Business Manager',
        'W-Business Manager - EMEA',
        'W-Business Manager - EMEA - NON SSO'
    };
    
    public Boolean showBaseCode {get; set;}
    
    public Material_Sales_Data2_Controller(ApexPages.StandardController stdController) {
        id = ApexPages.currentPage().getParameters().get('id');
        msd = (Material_Sales_Data2__c)stdController.getRecord();
        userProfileName = User_Functions.getLoggedInUserProfileName();
        showBaseCode = (allViewProfiles.contains(userProfileName) || 
                        baseCodeViewProfiles.contains(userProfileName));
        System.debug(userProfileName + ':' + showBaseCode);
    }

    public String getMaterial_Sales_Data2() {
        return 'Material_Sales_Data2__c ' + ' (' + msd + ')';
    }
    
    public String getMaterialNumber() {
        String matnum = String_Functions.removeLeadingZeros(msd.Material_Number__c);
        return matnum;
    }
    
    public List<Material_UOM2__c> getAltUOMs() {
        return Material_Sales_Data_Functions.getAltUOMs(msd);
    }
    
    public List<Material_Plant2__c> getPlants() {
        return Material_Sales_Data_Functions.getPlants(msd);
    }
    
    public List<Open_Orders__c> getAllOpenOrders(){
        DateTime currentDate = System.Now(); //our your fiscal year date2
        DateTime newFiscalYear = currentDate.addYears(-2);
        system.debug('newFiscalYear  ##:'+newFiscalYear);
        List<Open_Orders__c> allorders = [select id,name, Created_Date2__c, Ordered_Qty_in_LB__c,Reason_Rejected_Code__c ,createdDate,Unit_Price_per_LB__c,Goods_Issue_Date2__c,Agreed_Ship_Date2__c, Sales_Doc_Type__c, plant_code__c, Plant_desc__c from Open_Orders__c where Material__c =: id  and Sales_Doc_Type__c=: 'ZOR' and Reason_Rejected_Code__c = '' and CreatedDate >=: newFiscalYear order by CreatedDate desc limit 10];
        return allorders;
    }
    
/*
 **************************************************************
 Test Methods are in Material_Sales_Data2_Controller_Test class
 ************************************************************** 
 */    

}