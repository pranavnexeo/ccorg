public class MSDSInternalSiteDocumentController {

        public String docId {get;set;}
    
    public pagereference ViewMSDSDoc() {
        docId = ApexPages.currentPage().getParameters().get('sfid');
        System.debug(' docId ' + docId);
        return null;
    }
}