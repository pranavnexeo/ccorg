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
private class MultiAdd_Test {
/*Commented whole class as created a new test class.
 *@Rajeev - 1st July 2014
    //static Test_Name_del__c  TND;
    //static Test_Case2_del__c TND2;
    //static Sample_Analysis_Request__c SAR;*/
  public static testMethod void testmultiadddata() {  
  try{
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
       User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
  Account acc = new Account(name = 'test',ownerid = u.id );
  insert acc;  
 Sample_Analysis_Request__c SAR=new Sample_Analysis_Request__c(Requested_by__c= u.id,Buisness_Group__c='Inside Sales',Customer__c=acc.id,Sample_Name__c='Test',Number_of_Samples__c=1,Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
   insert SAR;
   //apexpages.currentpage().getparameter().put('',sar.id);
   ApexPages.currentPage().getParameters().put('00Nc0000000Sthg_lkid',sar.id);
Test_Case2_del__c TND2=new Test_Case2_del__c(Name='Test',CurrencyIsoCode = 'USD',Test_Type__c = 'Internal',Ownerid = u.id,Our_Charge__c=12,Analytical_Cost__c=12,Testing_Facility__c='12',Amount_Charged__c=13);
insert TND2;
Test_Case_del__c TND=new Test_Case_del__c(CurrencyIsoCode = 'AUD',Test_Name_del__c=SAR.Id,Test_Case2_del__c=TND2.Id,Amount_Charge__c = 12,Analytical_Co__c = 12,Customer_Save__c = 13,Test_Completed__c = 'test');
insert TND;
   ApexPages.Standardcontroller con = new ApexPages.Standardcontroller(TND);
   MultiAdd ext=new MultiAdd(con );
   PageReference pageRef = Page.SampleViewCustomerService;
   

  // Test.setCurrentPage(pageRef);

   //MultiAdd controller = new MultiAdd(con);
   ext.addMore();
   
   ext.save();
  ext.Add();
  ext.Del();
  }
  catch (exception e){
  
  }
   }
   }