@IsTest
public class MSDSInternalSiteDocumentController_Test {
    
     public static testMethod void MSDSSiteDocumentController() {
        ApexPages.CurrentPage().getParameters().put('sfid', '5467');
        MSDSInternalSiteDocumentController newInstance = new MSDSInternalSiteDocumentController();
        newInstance.ViewMSDSDoc();
        System.assert(null != newInstance.docId);
    }

}