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
private class BaseCodeLookupController_Test {

    static Material_base_Code__c basecode;
    
    static testMethod void myUnitTest() {
        Test.startTest();
        basecode= new Material_base_Code__c(material_base_code__c='Mat-1234',material_base_Code_Description__c='TestbasecodeMat-1234');
        insert basecode;          
        
        apexpages.currentpage().getparameters().put('lksrch',basecode.material_base_code__c);
        
         ApexPages.standardcontroller sc = new ApexPages.standardcontroller(basecode);
         BaseCodeLookupController CR = new BaseCodeLookupController();
         cr.searchString =basecode.material_base_code__c;    
        pagereference p = cr.search();
        p = cr.sortResults();        
        CR.getFormTag();
        CR.getTextBox();
    }   

}