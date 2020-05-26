/**
 * Created by C751352 on 2/7/2019.
 */

public with sharing class MSDSSiteMaterialDetailController {

    public MSDSResponse sdsDocuments {get; private set;}
    public String materialName {get; private set;}
    public String materialNumber {get; private set;}
    public Boolean renderTable {get; private set;}

    public MSDSSiteMaterialDetailController (){

        //Call service to get Material documents
        materialNumber = apexpages.currentpage().getparameters().get('materialNumber');
        materialName = MSDSSiteMaterialDetailHelper.getMaterialName(materialNumber);//'POLYETHYL GLYCOL 600 TECH';
        if (materialName != Label.MSDSMaterialNumberNotFound) {
            sdsDocuments = getSDSDocuments(materialNumber);

            if (sdsDocuments.Status != '200') {
                renderTable = false;
            } else {
                renderTable = true;
            }
        }
    }


    public static MSDSResponse getSDSDocuments(String materialNumber) {
        MSDSResponse documentsList = MSDSSiteMaterialDetailHelper.getSDSDocumentsList(materialNumber);
        return documentsList;
    }

    @RemoteAction
    public static String getSDSDocument(String materialNumber, String renchNumber, String dockey) {
        MSDSResponse document = MSDSSiteMaterialDetailHelper.getSDSDocument(materialNumber, renchNumber);
        if (document.Status != '200') {
            return null;
        } else {
            String documentId = MSDSSiteHomeHelper.createMSDSDocument(document.documents.get(0), dockey);
            return documentId;
        }

    }

    //When user has clicked MaterialSearch
    public PageReference goToMaterialSearch() {
        System.debug('goToMaterialSearch');
        PageReference pageRef = new PageReference('/apex/MSDSIntSiteHome');
        pageRef.setRedirect(true);
        return pageRef;

    }
}