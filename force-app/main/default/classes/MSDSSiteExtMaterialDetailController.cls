public class MSDSSiteExtMaterialDetailController {
 	
    public MSDSResponse sdsDocuments {get; private set;}
    public String materialName {get; private set;}
    public String materialNumber {get; private set;}
    public Boolean renderTable {get; private set;}

    public MSDSSiteExtMaterialDetailController (){

        //Call service to get Material documents
        materialNumber = apexpages.currentpage().getparameters().get('materialNumber');
        materialName = MSDSSiteMaterialDetailHelper.getMaterialName(materialNumber);//'POLYETHYL GLYCOL 600 TECH';
        if (materialName != Label.MSDSMaterialNumberNotFound) {
            sdsDocuments = getSDSDocuments(materialNumber);

            if (sdsDocuments.Status != '200' || sdsDocuments.documents.size() < 1) {
                materialName = Label.MSDSMaterialNumberNotFound;
                renderTable = false;
            } else {
                renderTable = true;
            }
        }
    }


    public static MSDSResponse getSDSDocuments(String materialNumber) {
        MSDSResponse documentsList = MSDSSiteExtMaterialDetailHelper.getSDSDocumentsList(materialNumber);
        return documentsList;
    }

    @RemoteAction
    public static String getSDSDocument(String materialNumber, String renchNumber, String dockey) {
        MSDSResponse document = MSDSSiteExtMaterialDetailHelper.getSDSDocument(materialNumber, renchNumber);
        if (document.Status != '200') {
            return null;
        } else {
            String documentId = MSDSSiteExtMaterialDetailHelper.createMSDSDocument(document.documents.get(0), dockey);
            return documentId;
        }

    }

    //When user has clicked MaterialSearch
    public PageReference goToMaterialSearch() {
        System.debug('goToMaterialSearch');
        PageReference pageRef = new PageReference('/apex/MSDSSiteHome');
        pageRef.setRedirect(true);
        return pageRef;

    }
}