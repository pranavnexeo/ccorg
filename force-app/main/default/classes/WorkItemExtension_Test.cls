@IsTest
public class WorkItemExtension_Test {

    public static testMethod void newWIQ() {
        ProjectTrackerTestUtils.initData();
        Work_Item__c WIQrecord = new Work_Item__c();
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController);  
    }
    
    public static testMethod void newWIQFromFDR() {
        ProjectTrackerTestUtils.initData();
        Functional_Design_Registration__c newFDR = new Functional_Design_Registration__c();
        insert newFDR;
        
        Work_Item__c WIQrecord = new Work_Item__c();
        WIQrecord.Functional_Design_Registration__c = newFDR.Id;
        ApexPages.CurrentPage().getParameters().put('functionaldesing', newFDR.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController); 
        controllerExtension.save();
        controllerExtension.save();
    }
    
    public static testMethod void newWIQFromFDRMaint() {
    
    
        ProjectTrackerTestUtils.initData();
        Functional_Design_Registration__c newFDR = new Functional_Design_Registration__c();
        Map<String, String> OECustomSettings = new Map<String, String>();
        for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
      
            OECustomSettings.put(thisValue.Name, thisValue.Value__c);
        }
        newFDR.RecordTypeId = OECustomSettings.get('FDR_Maintenance_Record_Type_Id_18__c');
        insert newFDR;
        
        Work_Item__c WIQrecord = new Work_Item__c();
        WIQrecord.Functional_Design_Registration__c = newFDR.Id;
        ApexPages.CurrentPage().getParameters().put('functionaldesing', newFDR.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController);  
    }

    public static testMethod void newWIQFromFDRPS() {
        ProjectTrackerTestUtils.initData();
        Functional_Design_Registration__c newFDR = new Functional_Design_Registration__c();
        Map<String, String> OECustomSettings = new Map<String, String>();
        for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
            OECustomSettings.put(thisValue.Name, thisValue.Value__c);
        }
        newFDR.RecordTypeId = OECustomSettings.get('FDR_PS_Type_Id_18__c');
        insert newFDR;
        
        Work_Item__c WIQrecord = new Work_Item__c();
        WIQrecord.Functional_Design_Registration__c = newFDR.Id;
        ApexPages.CurrentPage().getParameters().put('functionaldesing', newFDR.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController);  
    }    
    
    public static testMethod void renderOldWIQ() {
        ProjectTrackerTestUtils.initData();
        Work_Item__c WIQrecord = new Work_Item__c();
        
        Map<String, String> OECustomSettings = new Map<String, String>();
        for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
            OECustomSettings.put(thisValue.Name, thisValue.Value__c);
        }
        
        insert WIQrecord;
        WIQrecord = [SELECT Id, RecordTypeId FROM Work_Item__c WHERE Id =: WIQrecord.Id];
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController);  
    }
    
    public static testMethod void testCancelOverride() {
        ProjectTrackerTestUtils.initData();
        Work_Item__c WIQrecord = new Work_Item__c();
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController);
        controllerExtension.cancel();
    }
    
    public static testMethod void testCancelOverrideFromFDR() {
        ProjectTrackerTestUtils.initData();
        Work_Item__c WIQrecord = new Work_Item__c();
        Functional_Design_Registration__c newFDR = new Functional_Design_Registration__c();
        Map<String, String> OECustomSettings = new Map<String, String>();
        for(OE_Custom_Seeting__c thisValue: [SELECT Id,Value__c, Name FROM OE_Custom_Seeting__c]) {
            OECustomSettings.put(thisValue.Name, thisValue.Value__c);
        }
        newFDR.RecordTypeId = OECustomSettings.get('FDR_PS_Type_Id_18__c');
        insert newFDR;
        ApexPages.CurrentPage().getParameters().put('functionaldesing', newFDR.Id);
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController);
        controllerExtension.cancel();
    }    
/*
    public static testMethod void testCancelWithEnhancementOverride() {
        ProjectTrackerTestUtils.initData();
        Enhancement__c newEnhancement = new Enhancement__c();
        newEnhancement.User_Contact__c = UserInfo.getUserId();
        //get the first value of the picklist Target Quarter in order to prevent
        //use a hard coded value that is not on the picklist
        DescribeFieldResult describe = Enhancement__c.Target_Quarter__c.getDescribe();
        List<PicklistEntry> availableValues = describe.getPicklistValues();
        newEnhancement.Target_Quarter__c = availableValues[0].getValue();
        
        describe = Enhancement__c.IT_Owner__c.getDescribe();
        availableValues = describe.getPicklistValues();
        newEnhancement.IT_Owner__c = availableValues[0].getValue();
        
        describe = Enhancement__c.Risk__c.getDescribe();
        availableValues = describe.getPicklistValues();
        newEnhancement.Risk__c = availableValues[0].getValue();
        
        insert newEnhancement;
        
        Functional_Design_Registration__c FDRrecord = new Functional_Design_Registration__c();
        FDRrecord.OE_Enhancement_Number__c = newEnhancement.Id;
        ApexPages.StandardController standardController = new ApexPages.StandardController(FDRrecord);
        FDRExtension controllerExtension = new FDRExtension(standardController);  
        controllerExtension.cancel();
    }
       */
    public static testMethod void validateUserPermissions() {
        ProjectTrackerTestUtils.initData();
        Work_Item__c WIQrecord = new Work_Item__c();
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController);
        controllerExtension.validateUserPermissions();
    }

    public static testMethod void validateUserNoPermissions() {
        ProjectTrackerTestUtils.initData();
        
        Profile userNotSysProfile = [SELECT Id,Name FROM Profile WHERE Name Like 'Inactive Users%'  LIMIT 1];

        String username = 'username' + String.valueOf(DateTime.now().getTime()) + '@email.com.test';
        User currentUser = new User(
            FirstName         = 'firstName',
            LastName          = 'lastName',
            Email             = username,
            Alias             = 'alias1',
            Username          = username,
            LocaleSidKey      = 'en_US',
            TimeZoneSidKey    = 'GMT',
            ProfileID         = userNotSysProfile.id,

            LanguageLocaleKey = 'en_US',
            EmailEncodingKey  = 'UTF-8'
        );
        insert currentUser;
        
        Work_Item__c WIQrecord = new Work_Item__c();
        ApexPages.StandardController standardController = new ApexPages.StandardController(WIQrecord);
        WorkItemExtension controllerExtension = new WorkItemExtension(standardController);
        
        System.runAs(currentUser) {

            controllerExtension.validateUserPermissions();
        }
    }  
}