//Added Comments
public class ProcurementContractExtension {
    
    private final Procurement_Contract__c contract;
    
    public ProcurementContractExtension(ApexPages.StandardController controller) {
    
        contract=(Procurement_Contract__c)controller.getRecord();

    }
    
        
    public void recordAudit(){
        
        System.debug('Record Audit--------');
        
        Procurement_Contract__c contractObj = [select Id,Audit_History__c,Last_Audit_Due__c from Procurement_Contract__c where Id = :contract.Id];
        
        String currentValue =  contractObj.Audit_History__c;
        
        if(currentValue ==null){
            currentValue ='';
        }
        
        contractObj.Audit_History__c= currentValue +' '+ UserInfo.getName()+' : '+System.Now();
        contractObj.Last_Audit_Due__c= System.Today();
        
        update contractObj;
    } 
    
 }