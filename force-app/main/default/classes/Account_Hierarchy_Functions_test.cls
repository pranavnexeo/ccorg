@istest

public class Account_Hierarchy_Functions_test{
 //public static final String DELIM = CISRelationships_Functions.DELIM;
    
    public static testmethod void accheirfunc(){
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
        test.starttest();
        Account a = new Account(name ='Test Account');
        insert a;
        string acctId = a.Id;
        Account b = new Account(name ='Test Account',ParentId = acctId,AccountNumber = 'P1234');
        insert b;
        string acctId1 = b.Id; 
        List<id> idlist=new List<id>();
        idlist.add(b.id);
        
     XmlStreamWriter xsw = new XmlStreamWriter();
     Map<Id, Account> amap = new Map<Id, Account>();
     
        Set<Id> accountIds = new Set<Id>();
        accountIds.add(acctId1);
        Map<Id, Map<String, List<Id>>> pmap;
        pmap = CISRelationships_Functions.getPartnerIds(accountIds); 
        
       // LIst<Account> att = [select Id from Account where Id = '001E000000BubGl'];
                Account_Hierarchy_Functions.AccountClass con=new Account_Hierarchy_Functions.AccountClass(acctId,acctId1);
         Account_Hierarchy_Functions.CHerkyAccount cont =new Account_Hierarchy_Functions.CHerkyAccount(acctId,acctId1);
         Account_Hierarchy_Functions.CHerkyAccount cont1 =new Account_Hierarchy_Functions.CHerkyAccount();
         Account_Hierarchy_Functions.SoldToAccount contt=new Account_Hierarchy_Functions.SoldToAccount(acctId,acctId1);
         Account_Hierarchy_Functions.SoldToAccount contt1=new Account_Hierarchy_Functions.SoldToAccount();   
         Account_Hierarchy_Functions.ShipToAccount controller=new Account_Hierarchy_Functions.ShipToAccount(acctId,acctId1);
         Account_Hierarchy_Functions.ShipToAccount controller1=new Account_Hierarchy_Functions.ShipToAccount();
         Account_Hierarchy_Functions.debug('test');
         Account_Hierarchy_Functions.notNull('test');
         Account_Hierarchy_Functions.ReturnClass return1 = new Account_Hierarchy_Functions.ReturnClass(); 
         Account_Hierarchy_Functions.setAccountInfo('test',con,amap,xsw);
         Account_Hierarchy_Functions.setAccountsInfo(cont,amap);
        
         test.stoptest();
       
    }
   
    
     public static testmethod void accheirfunc1FGG(){
       Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    test.starttest();
     Account att1 = new Account(Name = 'test');
         
         insert att1;
         
         Account att = new Account(Name = 'test1', ParentId = att1.Id,SAP_Partner_Functions__c = 'Ship To');
         
         insert att;
         List<Id> idlists=new List<Id>();
         List<String> listValues= new List<String>();
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');         
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');        
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');         
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');         
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         listValues.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         idlists.add(att.Id);
         
         Map<Id, Account> amap = new Map<Id, Account>();
         Map<Id, Account> amap2 = new Map<Id, Account>();
        
         XmlStreamWriter xsw = new XmlStreamWriter();
         Set<String> aset = new Set<String>();
         aset.add('test1:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test2:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test3:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test4:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test5:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test6:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test7:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test8:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test9:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test10:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test11:values:test1:values:test1:values:test1:values:test1:values:test1:values:');
         aset.add('test11:values:test1:values:test1:values:test1:values:test1:values:test1:values:');         
         Map<String, List<Id>> tmap = new Map<String, List<Id>>();
         tmap.put(CISRelationships_Functions.SHIPTO, idlists);
         tmap.put(CISRelationships_Functions.SOLDTO, idlists);
       
         List<String> plist = new List<String>();
         
        Account_Hierarchy_Functions.getAccountHierarchyXml(att.Id );
         
         Account_Hierarchy_Functions.getAccountKeyId(att.Id,amap );
        Account_Hierarchy_Functions.isNotNull('true');
        Account_Hierarchy_Functions.getString(att);
       try{
        Account_Hierarchy_Functions.writeAttribute(xsw,'test','test1');
        }catch(exception e){}
         Account_Hierarchy_Functions.CHerkyAccount cherkyAccount= new Account_Hierarchy_Functions.CHerkyAccount();
         
         Map<Id,Account> accountMaps= new Map<Id,Account>();
         
         accountMaps.put(att.Id, att);
        Account_Hierarchy_Functions.setAccountsInfo(cherkyAccount,accountMaps);
         
   
         
        Account_Hierarchy_Functions.getAccountList('att.id',aset);
         aset.clear();
         aset.add('test1:values:test1:values');
        Account_Hierarchy_Functions.getAccountList('att.id',aset);         
         
         aset.clear();
         aset.add('test1:values:');
        Account_Hierarchy_Functions.getAccountList('att.id',aset);         
        Account_Hierarchy_Functions.getAccountSet(tmap,amap);        
        //Account_Hierarchy_Functions.getCHerkyAccounts('att.id',plist);    
        Account_Hierarchy_Functions.getCHerkyAccounts(String.valueOf(att.id), listValues); 
        Account_Hierarchy_Functions.writeElement(xsw,'test','test1');
        Account_Hierarchy_Functions.writeStartElement(xsw,'test');
        Account_Hierarchy_Functions.writeEmptyElement(xsw,'test');

         Account_Hierarchy_Functions.getAccountHierarchy(att.Id);
         //Account_Hierarchy_Functions.DELIM= ';';     
   
         
                // if uncomment this code decrease the code coverage.
         Account_Hierarchy_Functions.AccountClass AccountCl;         
         
         AccountCl = new Account_Hierarchy_Functions.AccountClass('true', att.Id);
         AccountCl.accountId=att.Id;
         AccountCl.accountName=att.Name;
         AccountCl.accountNumber=att.Account_Number__c;
         AccountCl.accountType=att.Type;
         AccountCl.isSourceAcc=true;
         AccountCl.isViewngAcc=false;         
         AccountCl.sourceAccId=att.id;       

       try{  
        Account_Hierarchy_Functions.setAccountInfo(att.Type,AccountCl, accountMaps,xsw);
        }catch(exception e){}
    test.stoptest();
    
    }
   
    
    public static testmethod void accheirfunc1(){
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt1', Email='nn@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
        TimeZoneSidKey='America/Los_Angeles', UserName='ksbc@gorg.com', IsActive = true);
        insert u;
    test.starttest();
     Account att1 = new Account(Name = 'test');
         
         insert att1;
         
         Account att = new Account(Name = 'test1', ParentId = att1.Id,SAP_Partner_Functions__c = 'Ship To');
         
         insert att;
         Map<Id, Account> amap = new Map<Id, Account>();
         XmlStreamWriter xsw = new XmlStreamWriter();
         Set<String> aset = new Set<String>();
         Map<String, List<Id>> tmap = new Map<String, List<Id>>();
         List<String> plist = new List<String>();
         
        Account_Hierarchy_Functions.getAccountHierarchyXml(att.Id );
        Account_Hierarchy_Functions.getAccountKeyId(att.Id,amap );
        Account_Hierarchy_Functions.isNotNull('true');
        Account_Hierarchy_Functions.getString(att);
       try{
        Account_Hierarchy_Functions.writeAttribute(xsw,'test','test1');
        }catch(exception e){}
        
        Account_Hierarchy_Functions.getAccountList('att.id',aset);
        Account_Hierarchy_Functions.getAccountSet(tmap,amap);
        try{
        Account_Hierarchy_Functions.getCHerkyAccounts('att.id',plist);
        }catch(exception e){}
        Account_Hierarchy_Functions.writeElement(xsw,'test','test1');
        Account_Hierarchy_Functions.writeStartElement(xsw,'test');
        Account_Hierarchy_Functions.writeEmptyElement(xsw,'test');

         Account_Hierarchy_Functions.getAccountHierarchy(att.Id);
         //Account_Hierarchy_Functions.DELIM= ';';     
   
    test.stoptest();
    
    }
    
}