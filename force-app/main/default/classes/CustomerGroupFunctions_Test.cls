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
private class CustomerGroupFunctions_Test {

    static String langcode = '!';
    static SAP_Distribution_Channel__c distchan;
    static SAP_Customer_Group__c custgrp;
    static SAP_Customer_Group1__c custgrp1; 
    static Customer_Group__c customerGroup;
    
    static testMethod void test01() {
        createTestData();
        CustomerGroupFunctions.getCustomerGroups(distChan.Id);
        CustomerGroupFunctions.getCustomerGroups(null);
    }
    
    static void createTestData() {
        createDistChan();
        createCustGrp();
        createCustGrp1();
        createCustomerGroup();
    }

    static void createDistChan() {
        distchan = new SAP_Distribution_Channel__c();
        distchan.Language_Code__c = langcode;
        distchan.Distribution_Channel_Code__c = '00';
        distchan.Distribution_Channel_Description__c = 'testDistChan';
        insert distchan;
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
    
    static void createCustomerGroup() {
        customerGroup =  new Customer_Group__c();
        customerGroup.SAP_Customer_Group__c = custgrp.Id;
        customerGroup.SAP_Distribution_Channel__c = distchan.Id;
        insert customerGroup;
    }
    
}