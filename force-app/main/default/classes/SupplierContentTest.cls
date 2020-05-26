@isTest
public class SupplierContentTest {
    
    static testmethod void SupplierContentTest()
    {
        Nexeo_Competitor__c objSupplier = new Nexeo_Competitor__c ();
        objSupplier.name='test';
        insert objSupplier;
        ApexPages.currentPage().getParameters().put('pid',objSupplier.id);
        SupplierContent obj = new SupplierContent();
        obj.Redirect();
         obj.RedirectManageContent();
    }
}