@isTest
public class cc_imp_mon_testUtils {
	
    static Map<String, SObject> resultMap;    

    public static Map<String, SObject> initData() {
        Id ProfileId = [select id from Profile where name= 'System Administrator'].Id;
        User nexeoIntegrationUser = new User(Alias = 'tAstroS3', Email='ooo@testorg2.com',EmailEncodingKey='UTF-8', LastName='User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = ProfileId, 
              TimeZoneSidKey='America/Los_Angeles', UserName='testusernexeo3@gorg2.com', IsActive = true,Ashland_Employee_Number__c = 'A123002', FirstName = 'Nexeo_Integration');
        insert nexeoIntegrationUser;
        Account payerTestAccount = new Account(name = 'Monitoring Test Account');
        payerTestAccount.SAP_Customer_Number__c = '0000165798';
		payerTestAccount.SAP_Sales_Org__c = '1000';
		payerTestAccount.SAP_DivisionCode__c = '32';
        payerTestAccount.SAP_DistChannel__c = '30';
        insert payerTestAccount;
        
        Account testAccount = new Account(name = 'Monitoring Test Account');
        testAccount.SAP_Customer_Number__c = '0000165798';
		testAccount.SAP_Sales_Org__c = '1000';
		testAccount.SAP_DivisionCode__c = '32';
        testAccount.SAP_DistChannel__c = '30';
        testAccount.SAP_Payer_Account_Id__c = payerTestAccount.Id;
        insert testAccount;
        
        resultMap = new Map<String,SObject>();
        resultMap.put('monoAccount', testAccount);
        resultMap.put('payerAccount', payerTestAccount);
        
        List<CC_SFDC_Settings__c> customSettings = createNexeoCustomSettingList();
        insert customSettings;
        
        return resultMap;
    }
    
    
    public static List<CC_SFDC_Settings__c> createNexeoCustomSettingList() {
    	List <CC_SFDC_Settings__c > settings = new List <CC_SFDC_Settings__c>();

    	settings.add(createSFDCSettingsMonitoring());
    	
    	return settings;
    }
    
    public static CC_SFDC_Settings__c createSFDCSettingsMonitoring(){
        Account monoAccount = (Account) resultMap.get('monoAccount');
        
        CC_SFDC_Settings__c customSettings = new CC_SFDC_Settings__c(
            name='Monitoring',
            CC_WS_Mon_Account_Id__c = monoAccount.Id,
            CC_WS_Mon_Batch_Number__c = 'NTL1042',
            CC_WS_Mon_Customer_Profile__c = true,
            CC_WS_Mon_Email_Exception__c = 'IGonzalez@nexeosolutions.com',
            CC_WS_Mon_ES_Account_Id__c = '0000083979',
            CC_WS_Mon_ES_Document__c = 'W0004048',
            CC_WS_Mon_Invoice__c = true,
            CC_WS_Mon_Invoice_Id__c = '0047855177',
            CC_WS_Mon_MAN_BOL_COA__c = true,
            CC_WS_Mon_Material_Id_COFA__c = '000000000000506551',
            CC_WS_Mon_Material_Number__c = '000000000000069595',
            CC_WS_Mon_MSDS__c = true,
            CC_WS_Mon_Profile_Load_Doc__c = true,
            CC_WS_Mon_Store_Front_Name__c = 'mynexeo',
            CC_WS_Mon_Track_and_Trace__c = true,
            CC_WS_Mon_Track_and_Trace_Document_Id__c = '0008120743',
            CC_WS_Mon_View_Credit__c = true

        );
        
        return customSettings;
    }
}