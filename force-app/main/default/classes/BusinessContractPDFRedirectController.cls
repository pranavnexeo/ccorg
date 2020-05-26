public without sharing class BusinessContractPDFRedirectController {
    private final Business_Contract__c b;
    private final Business_Contract__c bus;
    
    //constructor
    public BusinessContractPDFRedirectController(ApexPages.StandardController standardPageController) {
        b = (Business_Contract__c)standardPageController.getRecord(); //instantiate the Account object for the current record
        bus = [Select Id,Name,Customer_Name__c, Agreement__c,Contract_Type__c from Business_Contract__c where Id =: b.Id Limit 1];
    }
    
    public PageReference generatePdf(){
        if(bus.Contract_Type__c != 'High Risk Inventory Agreement'){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'This option is only available for High Risk Inventory Agreements'));
        }
        else{
        PageReference pr = savePdf(bus.id, bus.Customer_Name__c, bus.Name, bus.Agreement__c);
        //PageReference pr = new PageReference('/apex/BusContPdfShrtTermMexico?id='+bus.id);
        return pr;
        }
        
        return null;
    }
    
    //@future(callout=true)
       public PageReference savePdf(id b, id a, string name, string agrType){
               //create pagereference object and set to your VF page.
               PageReference pr;
               if(agrType == 'Long Term US'){
                    pr = new PageReference('/apex/BusContPdfLongTermUS?id='+b);
               }
               else if(agrType == 'Long Term Mexico'){
                    pr = new PageReference('/apex/BusContPdfLongTermMexico?id='+b);
               }
               else if(agrType == 'Long Term Canada'){
                    pr = new PageReference('/apex/BusContPdfLongTermCanada?id='+b);
               }
               else if(agrType == 'Short Term US- 45 Days'){
                    pr = new PageReference('/apex/BusContPdfShrtTermUS?id='+b);
               }
               else if(agrType == 'Short Term Mexico- 45 Days'){
                    pr = new PageReference('/apex/BusContPdfshrtTermMexico?id='+b);
               }
               else if(agrType == 'Short Term Canada- 45 Days'){
                    pr = new PageReference('/apex/BusContPdfShrtTermCanada?id='+b);
               }
               
                //pr.getParameters().put('id',objId);
                //get the content as a PDF
                ContentVersion cv = new ContentVersion();
                cv.ContentLocation = 'S';
                cv.ContentDocumentId = null;
                if(!Test.IsRunningTest()){
                    cv.VersionData = pr.getContentAsPDF();
                }
                else if(Test.IsRunningTest()){
                    cv.VersionData = Blob.valueOf('Im here sir');
                }
                cv.Title = name;
                cv.PathOnClient = '.pdf';
                //cv.FileType = 'application/pdf';
                insert cv;
                
                ContentDocumentLink cdl = new ContentDocumentLink();
                cdl.ContentDocumentId = [SELECT Id, ContentDocumentId FROM ContentVersion WHERE Id =: cv.Id].ContentDocumentId;
                cdl.LinkedEntityId = a;
                cdl.ShareType = 'I';
                insert cdl;

            return pr;
        }
}