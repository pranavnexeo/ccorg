/**
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class MSD2LookupController_Test {

    static Material_Sales_Data2__c msd2;
    
    static testMethod void myUnitTest() {
        Test.startTest();
        msd2= new Material_Sales_Data2__c(Name='mate1332',Material_Number__c='12345',Sales_Org_Code__c='1000',Dist_Channel_Code__c='31',Material_Base_Code__c='Mat-1234',Material_Base_Code_Desc__c='TestbasecodeMat-1234',Record_Key__c='121212owerw');
        insert msd2;     
        
        apexpages.currentpage().getparameters().put('lksrch',msd2.material_base_code__c);
        
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(msd2);
         MSD2LookupController  CR = new MSD2LookupController ();
         CR.getFormTag();
         CR.getTextBox();
         cr.searchString =msd2.Material_Base_Code__c;    
        pagereference pg = cr.search();
        pg = cr.sortResults();        
    }   

}