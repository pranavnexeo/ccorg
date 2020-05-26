@IsTest
public class MSDSSiteDocumentController_Test {
    
    public static testMethod void MSDSSiteDocumentController() {
        ApexPages.CurrentPage().getParameters().put('sfid', '5467');
        MSDSSiteDocumentController newInstance = new MSDSSiteDocumentController();
        newInstance.ViewMSDSDoc();
        System.assert(null != newInstance.docId);
    }

}