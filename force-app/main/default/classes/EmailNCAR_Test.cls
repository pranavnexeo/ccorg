@isTest(SeeAllData=FALSE)
private class EmailNCAR_Test{
    
    static testMethod void EmailNCAR1() {
            Id devRecordTypeId = Schema.SObjectType.NCAR_Cases__c.getRecordTypeInfosByName().get('Nexeo DZ').getRecordTypeId();

        	Account newAccount = new Account(Name = 'Test Account');
        	insert newAccount;
        	
        	Contact newContact = new Contact(LastName = 'Bob', AccountId = newAccount.id, Email = 'bob@nexeotestsolutions.com');
        	insert newContact;
        	
        	NCAR_Cases__c newNcar = new NCAR_Cases__c( Account__c = newAccount.Id, RecordTypeId = devRecordTypeId, Contact__c = newContact.id);
        	insert newNcar;
        
        
            NCAR_Cases__c c = [Select id, Account__c, Contact__c, RecordTypeId from NCAR_Cases__c where Account__c != null AND Contact__c != null AND RecordTypeID=:devRecordTypeId LIMIT 1];
            
            id con = c.Contact__c;
            
            apexpages.currentpage().getparameters().put('id', c.id);  
            apexpages.currentpage().getparameters().put('cid', con);  
            apexpages.currentpage().getparameters().put('fid', '00l5A000001feBT'); 
            apexpages.currentpage().getparameters().put('tid', '00XE0000000guGT'); 
            
            Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
            m.setSenderDisplayName('cccccccc');
            m.setReplyTo('abc@xyz.com');
            m.setSaveAsActivity(true);
            m.setwhatID(c.id);
            m.settargetobjectid(con);
            m.settemplateid('00X5A000000fS4t');
            m.setBccAddresses(new String[] {'def@ert.com'});
            m.setCcAddresses(new String[] {'wer@poi.com','wer@poit.com'});
           
            ApexPages.standardController sc = new ApexPages.standardcontroller(c);
            
            Test.startTest();
            
            EmailNCAR nc = new EmailNCAR(sc);
            
            nc.getrenderPreview();
            nc.sendEmail();
            nc.SendAndSave();
            nc.Cancel();
         //   nc.pdfpage();       
         //   nc.complete();
            nc.geturl();
        	nc.complete();
            nc.templatechanged();
        	nc.showtemplateerror();
        	nc.updaterecord();
          //  nc.updaterecord();
          //  nc.templatechanged();
          //  nc.showtemplateerror();
          //  nc.newtext = 'test';
            
            Test.stopTest();
       
    }
    /*
    static testMethod void EmailNCAR2() {
        
        
            Id devRecordTypeId = Schema.SObjectType.NCAR_Cases__c.getRecordTypeInfosByName().get('Nexeo Standard Incident').getRecordTypeId();
        
            NCAR_Cases__c c = [Select id, Account__c, Contact__c, RecordTypeId from NCAR_Cases__c where Account__c != null AND Contact__c != null AND RecordTypeID=:devRecordTypeId LIMIT 1];
            
            id con = c.Contact__c;
            
            apexpages.currentpage().getparameters().put('id', c.id);  
            apexpages.currentpage().getparameters().put('cid', con);  
            apexpages.currentpage().getparameters().put('fid', '00lE0000000hGwb'); 
            apexpages.currentpage().getparameters().put('tid', '00XE0000000guGT'); 
            
            ApexPages.standardController sc = new ApexPages.standardcontroller(c);
            
            Test.startTest(); 
            
            EmailNCAR nc = new EmailNCAR(sc);
            nc.getrenderPreview();
            nc.showtemplateerror();
            nc.newtext = 'test';
            
            Test.stopTest();
            
       
    }
    
    /*
    static testMethod void myTest1(){
        
        Account acc = new Account(Name = 'TestAccount');
        Insert acc; 
                           
        contact c = new contact(Accountid = acc.id, firstname = 'abc', lastname = 'xyz', email = 'abc.xyz@wipro.com');
        insert c; 
        
        NCAR_Cases__c cas = new NCAR_Cases__c();
        cas.Account__c = acc.id;
        cas.Collectible__c= true;
        cas.Contact__c = c.id;
        cas.Actions_Taken__c = 'Actions Taken';
        cas.Immediate_Action__c = 'Immediate Action';
        cas.Root_Cause__c = 'Root cause';
        cas.Problem_Statement__c = 'Problem Statement';
        cas.Problem_Statement_Customer_Facing__c = '';
        cas.Immediate_Action_Customer_Facing__c = '';
        cas.Root_Cause_Customer_Facing__C = '';
        cas.Route_To__c = '';
        cas.Status__c = 'New';
        cas.Email_Comments__c = 'Email Comments';
        
        insert cas; 
        
        apexpages.currentpage().getparameters().put('id', cas.id);  
        apexpages.currentpage().getparameters().put('cid', c.id);  
        apexpages.currentpage().getparameters().put('fid', '00lE0000000hGwb'); 
        apexpages.currentpage().getparameters().put('tid', '00XE0000000guGT'); 
        
        Messaging.SingleEmailMessage m = new Messaging.SingleEmailMessage();
        m.setSenderDisplayName('cccccccc');
        m.setReplyTo('abc@xyz.com');
        m.setSaveAsActivity(true);
        m.setwhatID(cas.id);
        m.settargetobjectid(c.id);
        m.settemplateid('00XE0000000guGT');
        m.setBccAddresses(new String[] {'def@ert.com'});
        m.setCcAddresses(new String[] {'wer@poi.com','wer@poit.com'});
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(cas);
        
        Test.startTest(); 
        
        EmailNCAR nc = new EmailNCAR(sc);
        nc.getrenderPreview();
        nc.sendEmail();
        nc.SendAndSave();
        nc.Cancel();
        nc.pdfpage();       
        nc.complete();
        nc.geturl();
        nc.updaterecord();
        nc.templatechanged();
        nc.showtemplateerror();
        nc.newtext = 'test';
        
        Test.stopTest();
      
    }
    
    static testMethod void myTest2(){
        
        Account acc = new Account(Name = 'TestAccount');
        insert acc; 
                           
        contact c = new contact(Accountid = acc.id, firstname = 'abc', lastname = 'xyz', email = 'abc.xyz@wipro.com');
        insert c;  
        
        NCAR_Cases__c cas = new NCAR_Cases__c();
        cas.Account__c = acc.id;
        cas.Collectible__c= true;
        cas.Contact__c = c.id;
        cas.Actions_Taken__c = 'Actions Taken';
        cas.Immediate_Action__c = 'Immediate Action';
        cas.Root_Cause__c = 'Root cause';
        cas.Problem_Statement__c = 'Problem Statement';
        cas.Problem_Statement_Customer_Facing__c = '';
        cas.Immediate_Action_Customer_Facing__c = '';
        cas.Root_Cause_Customer_Facing__C = '';
        cas.Email_Comments__c = 'Email Comments';
        cas.Status__c = 'New';
        insert cas; 
        
        apexpages.currentpage().getparameters().put('id', cas.id);  
        apexpages.currentpage().getparameters().put('cid', c.id);  
        apexpages.currentpage().getparameters().put('fid', '00lE0000000hGwb'); 
        apexpages.currentpage().getparameters().put('tid', '00XE0000000guGT'); 
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(cas);
        
        Test.startTest(); 
        
        EmailNCAR nc = new EmailNCAR(sc);
        nc.getrenderPreview();
        nc.showtemplateerror();
        nc.newtext = 'test';
        
        Test.stopTest();
        
    }
    */
    
}