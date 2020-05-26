@isTest
private class Supplier_Authorized_GeographyTest {

    static testMethod void myUnitTest() {
        Supplier_Authorized_Geography_Map__c SAGM = new Supplier_Authorized_Geography_Map__c();
        SAGM.Name = 'Test';
        SAGM.DocumentId__c = '0150x000000EFEy';
        SAGM.SupplierId__c = '0150x000000EFEy';
        
        insert SAGM;
        
        apexpages.currentpage().getparameters().put('supid','0150x000000EFEy');
        Supplier_Authorized_GeographyController SAGC = new Supplier_Authorized_GeographyController();
        SAGC.IsNoDocumentFound = true;
        SAGC.getSupplierDoument();
        
    }
   
}