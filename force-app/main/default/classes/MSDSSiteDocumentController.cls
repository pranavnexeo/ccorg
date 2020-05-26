public without sharing class MSDSSiteDocumentController {
    
    public String docId {get;set;}
    
    public pagereference ViewMSDSDoc() {
        docId = ApexPages.currentPage().getParameters().get('sfid');
        System.debug(' docId ' + docId);
        return null;
    }

}