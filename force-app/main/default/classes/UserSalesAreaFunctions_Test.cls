/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UserSalesAreaFunctions_Test {

    static String langcode = '!';
    static Id profileId = [Select Id from Profile where Name = 'Standard User'].Id;
    static String usrname1 = 'testuser1@testuser.testuser';
    static String usrname2 = 'testuser2@testuser.testuser';
    static String empnum1 = 'empnum1';
    static String empnum2 = 'empnum2';
    
    static User usr;
    static SAP_Country_Name__c region;
    static SAP_Sales_Org__c salesorg;
    static SAP_Distribution_Channel__c distchan;
    static SAP_Sales_Division__c division;
    static SAP_Customer_Group__c custgrp;
    static SAP_Customer_Group1__c custgrp1; 
    static User_Sales_Area__c userSalesArea;
    static SAP_Sales_Area__c sapSalesArea;
    
    static testMethod void test01() {
        createTestData();
    	UserSalesAreaFunctions.getUserSalesAreas(usr.Id);
        createUser(usrname2, empnum2);
        UserSalesAreaFunctions.getUserSalesAreas(usr.Id);
    }
    
    static void createTestData() {
        getUser();
    	createUser(usrname1, empnum1);
    	createRegion();
    	createSalesOrg();
    	createDistChan();
    	createDivision();
    	createCustGrp();
    	createCustGrp1();
        createSapSalesArea();
    	createUserSalesArea();
    }

    static void getUser() {
        try {
            usr = [select Alias, Email, EmailEncodingKey, LanguageLocaleKey,
                          LocaleSidKey, TimeZoneSidKey, ProfileId, Username
                     from User where Username = 'kvadlamudi@ashland.com'
                    limit 1];
        } catch(Exception e) {}
        System.debug(usr);
    }
    
    static void createUser(String usrname, String empnum) {
        usr = new User();
        usr.Alias = 'tstusr';
        usr.Email = 'testuser@testuser.testuser';
        usr.EmailEncodingKey = 'ISO-8859-1';
        usr.LanguageLocaleKey = 'en_US';
        usr.LastName = 'testusr';
        usr.LocaleSidKey = 'en_US';
        usr.TimeZoneSidKey = 'America/New_York';
        usr.ProfileId = profileId;
        usr.Username = usrname;
        usr.Ashland_Employee_Number__c = empnum;
        insert usr;
    }   
     
    static void createRegion() {
    	region = new SAP_Country_Name__c();
    	region.Language_Code__c = langcode;
    	region.Country_Code__c = '@#';
    	region.Country_Name__c = 'testCountry';
    	insert region;
    }
    
    static void createSalesOrg() {
        salesorg = new SAP_Sales_Org__c();
        salesorg.Language_Code__c = langcode;
        salesorg.Sales_Org_Code__c = '0000';
        salesorg.Sales_Org_Description__c = 'testSalesOrg';
        insert salesorg;
    }
    
    static void createDistChan() {
    	distchan = new SAP_Distribution_Channel__c();
    	distchan.Language_Code__c = langcode;
    	distchan.Distribution_Channel_Code__c = '00';
    	distchan.Distribution_Channel_Description__c = 'testDistChan';
    	insert distchan;
    }
    
    static void createDivision() {
    	division = new SAP_Sales_Division__c();
    	division.Language_Code__c = langcode;
    	division.Sales_Division_Code__c = '00';
    	division.Sales_Division_Description__c = 'testDivision';
    	insert division;
    }
    
    static void createCustGrp() {
    	custgrp = new SAP_Customer_Group__c();
    	custgrp.Language_Code__c = langcode;
    	custgrp.Customer_Group_Code__c = '00';
    	custgrp.Customer_Group_Name__c = 'testCustGroup';
    	insert custgrp;
    }
    
    static void createCustGrp1() {
    	custgrp1 = new SAP_Customer_Group1__c();
    	custgrp1.Language_Code__c = langcode;
    	custgrp1.Customer_Group1_Code__c = '000';
    	custgrp1.Customer_Group1_Name__c = 'testCustGroup1';
    	insert custgrp1;
    }
    
    static void createSapSalesArea() {
    	sapSalesArea = new SAP_Sales_Area__c();
    	sapSalesArea.Distribution_Channel_Code__c = '00';
    	sapSalesArea.Record_Key__c = '00000000';
    	sapSalesArea.Sales_Division_Code__c = '00';
    	sapSalesArea.Sales_Org_Code__c = '0000';
    	insert sapSalesArea;
    }
    
    static void createUserSalesArea() {
        userSalesArea =  new User_Sales_Area__c();
        userSalesArea.SAP_Country_Name__c = region.Id;
        //userSalesArea.SAP_Customer_Group1__c = custgrp1.Id;
        //userSalesArea.SAP_Customer_Group__c = custgrp.Id;
        userSalesArea.SAP_Distribution_Channel__c = distchan.Id;
        userSalesArea.SAP_Sales_Division__c = division.Id;
        userSalesArea.SAP_Sales_Org__c = salesorg.Id;
        userSalesArea.User__c = usr.Id;
        insert userSalesArea;
    }
    
}