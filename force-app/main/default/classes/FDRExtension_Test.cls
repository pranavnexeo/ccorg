/**
* Description: Test for FDRExtension
* Date: 12 / 28 / 2017
* Developer: Ignacio Gonzalez
*/
@IsTest
public class FDRExtension_Test {	
    
    public static testMethod void newFDR() {
        ProjectTrackerTestUtils.initData();
      	Functional_Design_Registration__c FDRrecord = new Functional_Design_Registration__c();
      	ApexPages.StandardController standardController = new ApexPages.StandardController(FDRrecord);
        FDRExtension controllerExtension = new FDRExtension(standardController);  
    }
    
    public static testMethod void newFDRFromEnhancement() {
        ProjectTrackerTestUtils.initData();
        Enhancement__c newEnhancement = new Enhancement__c();
        newEnhancement.User_Contact__c = UserInfo.getUserId();
        //get the first value of the picklist Target Quarter in order to prevent
        //use a hard coded value that is not on the picklist
        DescribeFieldResult describe = Enhancement__c.Target_Quarter__c.getDescribe();
		List<PicklistEntry> availableValues = describe.getPicklistValues();
        newEnhancement.Target_Quarter__c = availableValues[0].getValue();
        insert newEnhancement;
        
      	Functional_Design_Registration__c FDRrecord = new Functional_Design_Registration__c();
        FDRrecord.OE_Enhancement_Number__c = newEnhancement.Id;
      	ApexPages.StandardController standardController = new ApexPages.StandardController(FDRrecord);
        FDRExtension controllerExtension = new FDRExtension(standardController);  
    }
    
    public static testMethod void testCancelOverride() {
        ProjectTrackerTestUtils.initData();
      	Functional_Design_Registration__c FDRrecord = new Functional_Design_Registration__c();
      	ApexPages.StandardController standardController = new ApexPages.StandardController(FDRrecord);
        FDRExtension controllerExtension = new FDRExtension(standardController);
        controllerExtension.cancel();
    }    

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
    
    public static testMethod void validateUserPermissions() {
        ProjectTrackerTestUtils.initData();
      	Functional_Design_Registration__c FDRrecord = new Functional_Design_Registration__c();
      	ApexPages.StandardController standardController = new ApexPages.StandardController(FDRrecord);
        FDRExtension controllerExtension = new FDRExtension(standardController);
        controllerExtension.validateUserPermissions();
    }

    public static testMethod void validateUserNoPermissions() {
        ProjectTrackerTestUtils.initData();
        
        Profile userNotSysProfile = [SELECT Id,Name FROM Profile WHERE Name Like 'Inactive Users%'	LIMIT 1];

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
        
        Functional_Design_Registration__c FDRrecord = new Functional_Design_Registration__c();
        ApexPages.StandardController standardController = new ApexPages.StandardController(FDRrecord);
        FDRExtension controllerExtension = new FDRExtension(standardController);
        
        System.runAs(currentUser) {

            controllerExtension.validateUserPermissions();
        }
    }     

}