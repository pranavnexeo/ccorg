public class Supplier_Authorized_GeographyController {
    
    public boolean IsNoDocumentFound { get; set; }
    
    public PageReference getSupplierDoument() {
        
        List<Supplier_Authorized_Geography_Map__c> DocList;
        String DocId = '';
        IsNoDocumentFound = False;
        String SupplierId = apexpages.currentpage().getparameters().get('supid');
        Try{
            DocList = Supplier_Authorized_Geography_Map__c.getall().values(); 
        }Catch(exception e){}
        If(DocList != null && DocList.size()>0){
            // Fix
            Map<Id, Supplier_Authorized_Geography_Map__c> mapBySupplier = new Map<Id, Supplier_Authorized_Geography_Map__c>(); 
            for (Supplier_Authorized_Geography_Map__c supplierMap:DocList) {
                mapBySupplier.put(supplierMap.SupplierId__c, supplierMap);
            }
            
            try {
                Supplier_Authorized_Geography_Map__c supplierMap = mapBySupplier.get(SupplierId);
                Document documentId = [SELECT Id FROM Document WHERE Id =: supplierMap.DocumentId__c];
                IsNoDocumentFound = True;
                DocId = supplierMap.DocumentId__c;
            } catch (exception e){
                
            }
            /*
            For(Supplier_Authorized_Geography_Map__c O:DocList){
                If(O.SupplierId__c == SupplierId){
                    IsNoDocumentFound = True;
                    DocId = O.DocumentId__c;
                }
            }*/
        }
        If(IsNoDocumentFound == True){
            PageReference pg = new PageReference('/servlet/servlet.FileDownload?file='+DocId+'#view=Fit');
            return pg;
        }
        return null;
    }

}