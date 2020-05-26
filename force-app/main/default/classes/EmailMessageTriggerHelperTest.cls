@IsTest
public class EmailMessageTriggerHelperTest {
    Public Static Testmethod void Method1(){
        
        Case ac= new Case();
        ac.Status = 'Open';
        ac.Priority = 'Low';
        ac.Origin = 'Email';
        ac.Subject = 'Test';
        ac.Description = 'Test';
        Insert ac;
        
        EmailMessage[] newEmail = new EmailMessage[0];
        newEmail.add(new EmailMessage(FromAddress = 'test@abc.org', Incoming = True, ToAddress= 'hello@gmail.com', Subject = 'Test email', TextBody = '23456 ', ParentId = ac.Id)); 
        insert newEmail;
        
        Attachment a = new Attachment();
        a.name = 'test attachment';
        a.body = blob.valueof('attachment body');
        a.parentid = ac.Id;

        insert a;   
        
        Set<Id> Ids = new Set<Id>();
        Map<Id, Id> paMap = new Map<Id, Id>();
        paMap.put(ac.id, ac.id);
        Ids.add(ac.id); 
        EmailMessageTriggerHelper.insertAttachements(Ids, paMap);
        
    }
}