public class send_afe_test{

public integer q1{get; set;}
public integer q2{get; set;}
public send_afe_test(){
    q1 =  [SELECT count() FROM ProcessInstanceStep where ProcessInstance.TargetObject.Type = 'Authorization_for_Expenditure__c' and StepStatus = 'Pending'];
    q2 = [SELECT count() from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObject.Type = 'Authorization_for_Expenditure__c'];
}

public void send_afe(){
SendAFE_ApprovalMail_Batch clsBatchSync = new SendAFE_ApprovalMail_Batch();
        ID idBatch = Database.executeBatch(clsBatchSync);
}

}