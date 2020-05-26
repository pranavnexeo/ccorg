public class DispatcherContactEditController {
    
    Map<String, Schema.RecordTypeInfo> RTMap{get; set;}//Added for LAB project
    private final ApexPages.StandardController controller;
    public Sample_Analysis_Request__c myRec{get; set;}
    public String rid{get;set;}
    public DispatcherContactEditController(ApexPages.StandardController controller) {
        this.controller = controller;
        myRec = (Sample_Analysis_Request__c)controller.getrecord();
    }
    
    /*Modified under LAB Project
     *Overriden View button on Sample Analysis Request Object
     *@Rajeev
    */ 
    public PageReference getRedir(){
        List<Sample_Analysis_Request__c> c = [Select id, recordtypeid,RecordTypeName__c From Sample_Analysis_Request__c Where Id = :myRec.Id];
        PageReference newPage;

        if (c[0].RecordTypeName__c == 'Sample Analysis Request') {
            newPage = Page.SampleView;
 
        } 
        else if (c[0].RecordTypeName__c == 'Sample Analysis After Approval') {
            newPage = Page.SampleViewApproval;
 
        } 
        else if (c[0].RecordTypeName__c == 'Sample Analysis Request After Rejections') {
            newPage = Page.SampleViewReject;
 
        } 
        else if (c[0].RecordTypeName__c == 'Sample Analysis For Customer Service Analysis Type') {
            newPage = Page.SampleViewCustomerService;
 
        } 
        else if (c[0].RecordTypeName__c == 'Sample Analysis For Customer Service After Approval') {
            newPage = Page.SampleViewCustomerServiceAfterApproval;
 
        } 
        else if (c[0].RecordTypeName__c == 'Sample Analysis For Customer Service After Rejection  ') {
            newPage = Page.SampleViewCustomerServiceAfterRejection;
 
        } 
        else if (c[0].RecordTypeName__c == 'Customer Competitive') {
            newPage = Page.SampleViewCustomerCompetitive;
 
        }
        else if (c[0].RecordTypeName__c == 'Customer Complaint') {
            newPage = Page.SampleViewCustomerComplaint;
 
        } 
        else if (c[0].RecordTypeName__c == 'Customer Value Add') {
            newPage = Page.SampleViewCustomerValueAdd;
 
        }
        else if (c[0].RecordTypeName__c == 'Plant') {
            newPage = Page.SampleViewPlant;
 
        }
        else if (c[0].RecordTypeName__c == 'Supplier') {
            newPage = Page.SampleViewSupplier;
 
        }       
        else {
            newPage = new PageReference('/' + c[0].id + '/e');
        }
 
        newPage.getParameters().put('id',c[0].id);
        
        return newPage.setRedirect(true);
    }
 
    //Added for LAB Project.
    //Method used to override "Edit" button on Sample analysis object to redirect according to record type.
    //Author @Rajeev
    public PageReference getRedirEdit() {
 
        List<Sample_Analysis_Request__c> c = [Select id, recordtypeid,RecordTypeName__c,ent__c From Sample_Analysis_Request__c Where Id = :myRec.Id];
        PageReference newPage;
        String retURL = ApexPages.currentPage().getParameters().get('retURL');
        
        if (c[0].RecordTypeName__c == 'Customer Competitive') {
            newPage = new PageReference('/apex/SampleEditCustomerCompetitive?rid='+c[0].recordtypeid+'&returl='+retURL+'&ent='+c[0].ent__c+'&id='+c[0].id);
           }
        else if(c[0].RecordTypeName__c == 'Customer Value Add'){
            newPage = new PageReference('/apex/SampleEditCustomerValueAdd?rid='+c[0].recordtypeid+'&returl='+retURL+'&ent='+c[0].ent__c+'&id='+c[0].id);
           }
        else if(c[0].RecordTypeName__c == 'Supplier'){
            newPage = new PageReference('/apex/SampleEditSupplier?rid='+c[0].recordtypeid+'&returl='+retURL+'&ent='+c[0].ent__c+'&id='+c[0].id);
           }        
        else if(c[0].RecordTypeName__c == 'Customer Complaint'){
            newPage = new PageReference('/apex/SampleEditCustomerComplaint?rid='+c[0].recordtypeid+'&returl='+retURL+'&ent='+c[0].ent__c+'&id='+c[0].id);
           }  
        else if(c[0].RecordTypeName__c == 'Plant'){
            newPage = new PageReference('/apex/SampleEditPlant?rid='+c[0].recordtypeid+'&returl='+retURL+'&ent='+c[0].ent__c+'&id='+c[0].id);
           }
        else{
            newPage = new PageReference('/'+c[0].id+'/e?retURL='+retURL+'&nooverride=1');            
          }
        newPage.setRedirect(true);
        return newPage;
    }
 
    
    
    //Added for LAB project. Method is overriden by New button on Sample request analysis object.
    //Used to redirect to new page based on record types.
    //Author @Rajeev
    public pagereference redirectToCustComp(){
        rid = myRec.recordtypeid;
         PageReference returnURL;
          String retURL = ApexPages.currentPage().getParameters().get('retURL');
          String ent = ApexPages.currentPage().getParameters().get('ent');
        
        if(ApexPages.currentPage().getParameters().containskey('RecordType')){
         if(rid == SampleButtonHide.checkRecordType('Customer Competitive')){
           returnURL = new PageReference('/apex/sampleeditcustomercompetitive?rid='+rid+'&returl='+retURL+'&ent='+ent);
            }else if(rid == SampleButtonHide.checkRecordType('Customer Value Add')){
              returnURL = new PageReference('/apex/SampleEditCustomerValueAdd?rid='+rid+'&returl='+retURL+'&ent='+ent);
                }else if(rid == SampleButtonHide.checkRecordType('Supplier')){
                  returnURL = new PageReference('/apex/SampleEditSupplier?rid='+rid+'&returl='+retURL+'&ent='+ent);
                  }else if(rid == SampleButtonHide.checkRecordType('Customer Complaint')){
                   returnURL = new PageReference('/apex/SampleEditCustomerComplaint?rid='+rid+'&returl='+retURL+'&ent='+ent);
                    }else if(rid == SampleButtonHide.checkRecordType('Plant')){
                   returnURL = new PageReference('/apex/SampleEditPlant?rid='+rid+'&returl='+retURL+'&ent='+ent);
                  }
            else{
                  Schema.DescribeSObjectResult R = Sample_Analysis_Request__c.SObjectType.getDescribe();
                returnURL = new PageReference('/'+R.getKeyPrefix()+'/e?RecordType='+rid+'&retURL='+retURL+'&nooverride=1');  
            }
        }else 
       returnURL = null;
      returnURL.setRedirect(true);
    return returnURL;
   }
}