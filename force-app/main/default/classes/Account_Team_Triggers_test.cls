@isTest

public class Account_Team_Triggers_test{
    
    public static testMethod void testMe(){
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
        set<id> accid = new set<id>();
        list<id> aid = new list<id>();
         
             
             system.runas(u){
             
             User u1 = new User(Alias = 'standt', Email='ooo1@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc1@gorg.com', IsActive = false);
             insert u1;
              User u2 = new User(Alias = 'stand1', Email='oo21@testorg.com',EmailEncodingKey='UTF-8', LastName='1Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhc1@gorg.com', IsActive = true);
             insert u2;
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u2.id);
             insert s; 
             SAP_Seller__c s1 = new SAP_Seller__c(Name = 'test1', user__c = u.id);
             insert s1;
             SAP_Seller__c s2 = new SAP_Seller__c(Name = 'test2');
             insert s2;
               list<SAP_Sales_DOG__c> SDogsList = new List<SAP_Sales_DOG__c>();
             SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c(name = 'test', YD_Partner__c = s.id, Record_Key__c = '1234', YO_Partner__c = s.id,YV_Partner__c = s.id);
             SDogsList.add(ssd);
             SAP_Sales_DOG__c ssd1 = new SAP_Sales_DOG__c(name = 'test1', YD_Partner__c = s1.id, Record_Key__c = '12345', YO_Partner__c = s1.id,YV_Partner__c = s1.id);
             SDogsList.add(ssd1);
             insert SDogsList;
             SAP_Territory__c st = new SAP_Territory__c(name = 'test',ZS_Partner__c=s.id,YS_Partner__c=s.id,Record_Key__c = ssd.id);
             insert st;
             SAP_Territory__c st1 = new SAP_Territory__c(name = 'test',ZS_Partner__c=s1.id,YS_Partner__c=s1.id,Record_Key__c = ssd1.id);
             insert st1;
             Territory2Model m = new Territory2Model(Name = 'test123',DeveloperName = 'test123');
             insert m;
             List<Territory2Type> t2t = new List<Territory2Type>();
             t2t = [select id from Territory2Type limit1];
             // Territory2Type t2t = new Territory2Type(DeveloperName = 'test123');
             //insert t2t;
             Territory2 tt = new Territory2(Name = 'test123',DeveloperName = 'test123',Territory2Model=m,Territory2ModelId = m.id,Parent_Id__c = m.id,Territory2Typeid = t2t[0].id);
             insert tt;
             List<Account> la = new List<Account>();
             Account acc = new Account(name = 'test',YI_Partner__c = st.id,SAP_Customer_Group_2__c = 'COM',ZH_Partner__c=s.id,YY_Partner__c = st.id,YZ_Partner__c = st.id);
             Account acc1 = new Account(name = 'test1',YI_Partner__c = st1.id,SAP_Customer_Group_2__c = 'SPC',ZH_Partner__c=s1.id);
             Account acc2 = new Account(name = 'tes21',YI_Partner__c = st.id,ZH_Partner__c=s2.id);

             la.add(acc);
             la.add(acc1);
             la.add(acc2);
             insert la;
             Set<ID> conids = new Set<ID>();
             Contact con = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = la[0].id);
             insert con;
             conids.add(con.id);
             Contact con1 = new Contact(firstName='john',lastName='smith',Email='user1@acme.com',HasOptedOutOfEmail=true,Accountid = la[1].id);
             insert con1;
             conids.add(con1.id);
             Contact con2 = new Contact(firstName='john',lastName='smith',Email='user2@acme.com',HasOptedOutOfEmail=true,Accountid = la[2].id);
             insert con2;
             conids.add(con2.id);
             List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
             AccountTeamMember atm = new AccountTeamMember(AccountId = la[0].id, UserId = u2.id,TeamMemberRole = 'Informational Seller');
             AccountTeamMember atm1 = new AccountTeamMember(AccountId = la[1].id, UserId = u.id,TeamMemberRole = 'Seller (Comm/Gen)');
             AccountTeamMember atm2 = new AccountTeamMember(AccountId = la[2].id, UserId = u2.id,TeamMemberRole = 'DZ Analyst');
             atmlist.add(atm);
             atmlist.add(atm1);
             atmlist.add(atm2);
             insert atmlist;
             accid.add(la[0].id);
             accid.add(la[1].id);
             accid.add(la[2].id);
             
             aid.add(la[0].id);
             aid.add(la[1].id);
             aid.add(la[2].id);
             
             set<id> sdId = new set<id>();
             sdId.add(SDogsList[0].id);
             sdId.add(SDogsList[1].id);
             
              set<id> stId = new set<id>();
             stId.add(st.id);
             stId.add(st1.id);
             
             account a = new account(name = 'test');
             insert a;
                    AccountShare AccShare = new AccountShare(AccountId = a.id, 
                    AccountAccessLevel = 'Edit', 
                    OpportunityAccessLevel = 'Read',   
                    CaseAccessLevel = 'Read', 
                    UserOrGroupId = u2.id);
                    Insert AccShare;
                    

             Account_Team_Triggers.updateContactOwner(conids);
             Account_Team_Triggers.AccountTeamMembersSync(accid,'test');
             Account_Team_Triggers.SAP_Sales_DOG(accid);
             Account_Team_Triggers.SAP_Territories(accid);
             Account_Team_Triggers.Account(accid);
             Account_Team_Triggers.AccountTeamMembersSyncFromFlow(aid);
             
      }
    }
    public static testMethod void testMe1(){
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
        set<id> accid = new set<id>();
        list<id> aid = new list<id>();
         
             
             system.runas(u){
             test.starttest();
             
             User u1 = new User(Alias = 'standt', Email='ooo1@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc1@gorg.com', IsActive = false);
             insert u1;
              User u2 = new User(Alias = 'stand1', Email='oo21@testorg.com',EmailEncodingKey='UTF-8', LastName='1Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhc1@gorg.com', IsActive = True);
             insert u2;
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
             insert s; 
             SAP_Seller__c s1 = new SAP_Seller__c(Name = 'test1', user__c = u1.id);
             insert s1;
               list<SAP_Sales_DOG__c> SDogsList = new List<SAP_Sales_DOG__c>();
             SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c(name = 'test', YD_Partner__c = s.id, Record_Key__c = '123', YO_Partner__c = s.id,YV_Partner__c = s.id);
             SDogsList.add(ssd);
             SAP_Sales_DOG__c ssd1 = new SAP_Sales_DOG__c(name = 'test1', YD_Partner__c = s1.id, Record_Key__c = '0000152521', YO_Partner__c = s1.id,YV_Partner__c = s1.id);
             SDogsList.add(ssd1);
             insert SDogsList;
             SAP_Territory__c st = new SAP_Territory__c(name = 'test',ZS_Partner__c=s.id,YS_Partner__c=s.id,Record_Key__c ='1234',SAP_Sales_DOG__c= ssd.id);
             insert st;
             SAP_Territory__c st1 = new SAP_Territory__c(name = 'test1',ZS_Partner__c=s1.id,YS_Partner__c=s1.id,Record_Key__c = ssd1.id);
             insert st1;
             Territory2Model m = new Territory2Model(Name = 'test123',DeveloperName = 'T1234');
             insert m;
             List<Territory2Type> t2t = new List<Territory2Type>();
             t2t = [select id from Territory2Type limit1];
             // Territory2Type t2t = new Territory2Type(DeveloperName = 'test123');
             //insert t2t;
             Territory2 tt = new Territory2(Name = 'test123',DeveloperName = 'D123',Territory2Model=m,Territory2ModelId = m.id,Parent_Id__c = m.id,Territory2Typeid = t2t[0].id);
             insert tt;
             UserTerritory2Association uta = new UserTerritory2Association(Territory2id = tt.id, userId = u1.id,RoleInTerritory2 = 'Seller');
             insert uta;
             List<Account> la = new List<Account>();
             Account acc = new Account(name = 'test',YI_Partner__c = st.id,SAP_Customer_Group_2__c = 'SPC',ZH_Partner__c=s.id,YY_Partner__c = st.id,YZ_Partner__c = st.id);
             Account acc1 = new Account(name = 'test1',YI_Partner__c = st1.id,ZH_Partner__c=s1.id,YY_Partner__c = st1.id);

             la.add(acc);
             la.add(acc1);
             insert la;
             ObjectTerritory2Association ota = new ObjectTerritory2Association(territory2id=tt.id,objectid=la[0].id,AssociationCause = 'Territory2Manual');
             insert ota;
             try{
             AccountShare AccShare = new AccountShare(AccountId = la[0].Id,UserOrGroupId = u2.id, RowCause = 'Team', AccountAccessLevel = 'Read', OpportunityAccessLevel = 'Read');
             Insert AccShare;
             AccountShare AccShare1 = new AccountShare(AccountId = la[1].Id,UserOrGroupId = u2.id,AccountAccessLevel = 'Read', OpportunityAccessLevel = 'Read');
             Insert AccShare1;
             //}catch(exception e){}
             Contact con = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = la[0].id);
             insert con;
             Contact con1 = new Contact(firstName='john',lastName='smith1',Email='user1@acme.com',HasOptedOutOfEmail=true,Accountid = la[1].id);
             insert con1;
             List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
             AccountTeamMember atm = new AccountTeamMember(AccountId = la[0].id, UserId = u2.id,TeamMemberRole = 'VP of Sales (Comm/Gen)');
             AccountTeamMember atm1 = new AccountTeamMember(AccountId = la[1].id, UserId = u2.id,TeamMemberRole = 'DM (Spec)');
             atmlist.add(atm);
             atmlist.add(atm1);
             insert atmlist;
             
             accid.add(la[0].id);
             accid.add(la[1].id);
             
             aid.add(la[0].id);
             aid.add(la[1].id);
             
             set<id> sdId = new set<id>();
             sdId.add(SDogsList[0].id);
             sdId.add(SDogsList[1].id);
             Account_Team_Triggers.AccountTeamMembersSync(accid,'test');
             Account_Team_Triggers.SAP_Sales_DOG(accid);
             Account_Team_Triggers.SAP_Territories(accid);
             Account_Team_Triggers.Account(accid);
             Account_Team_Triggers.AccountTeamMembersSyncFromFlow(aid);
             }catch(exception e){}
             test.stoptest();
       }      
      }
      
      public static testMethod void testMe2(){
      Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
      
          User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             insert u;
        set<id> accid = new set<id>();
        list<id> aid = new list<id>();
         
             
             system.runas(u){
             test.starttest();
             User u1 = new User(Alias = 'standt', Email='ooo1@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc1@gorg.com', IsActive = false);
             insert u1;
              User u2 = new User(Alias = 'stand1', Email='oo21@testorg.com',EmailEncodingKey='UTF-8', LastName='1Testing', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhc1@gorg.com', IsActive = True);
             insert u2;
             SAP_Seller__c s = new SAP_Seller__c(Name = 'test', user__c = u.id);
             insert s; 
             SAP_Seller__c s1 = new SAP_Seller__c(Name = 'test1', user__c = u1.id);
             insert s1;
               list<SAP_Sales_DOG__c> SDogsList = new List<SAP_Sales_DOG__c>();
             SAP_Sales_DOG__c ssd = new SAP_Sales_DOG__c(name = 'test', YD_Partner__c = s.id, Record_Key__c = '123', YO_Partner__c = s.id,YV_Partner__c = s.id);
             SDogsList.add(ssd);
             SAP_Sales_DOG__c ssd1 = new SAP_Sales_DOG__c(name = 'test1', YD_Partner__c = s1.id, Record_Key__c = '0000152521', YO_Partner__c = s1.id,YV_Partner__c = s1.id);
            // SDogsList.add(ssd1);
             insert SDogsList;
             SAP_Territory__c st = new SAP_Territory__c(name = 'test',ZS_Partner__c=s.id,YS_Partner__c=s.id,Record_Key__c ='1234',SAP_Sales_DOG__c= ssd.id);
             insert st;
             SAP_Territory__c st1 = new SAP_Territory__c(name = 'test1',ZS_Partner__c=s1.id,YS_Partner__c=s1.id,Record_Key__c = ssd1.id);
             insert st1;
         
             List<Account> la = new List<Account>();
             Account acc = new Account(name = 'test',YI_Partner__c = st.id,SAP_Customer_Group_2__c = 'SPC',ZH_Partner__c=s.id,YY_Partner__c = st.id,YZ_Partner__c = st.id);
             Account acc1 = new Account(name = 'test1',YI_Partner__c = st1.id,ZH_Partner__c=s1.id,YY_Partner__c = st1.id);

             la.add(acc);
             la.add(acc1);
             insert la;
           
             AccountShare AccShare = new AccountShare(AccountId = la[0].Id,UserOrGroupId = u2.id,  AccountAccessLevel = 'Read', OpportunityAccessLevel = 'Read');
             //Insert AccShare;
             AccountShare AccShare1 = new AccountShare(AccountId = la[1].Id,UserOrGroupId = u2.id,AccountAccessLevel = 'Read', OpportunityAccessLevel = 'Read');
             //Insert AccShare1;
           
             Contact con = new Contact(firstName='john',lastName='smith',Email='user@acme.com',HasOptedOutOfEmail=true,Accountid = la[0].id);
             insert con;
             Contact con1 = new Contact(firstName='john',lastName='smith1',Email='user1@acme.com',HasOptedOutOfEmail=true,Accountid = la[1].id);
             insert con1;
             
             List<AccountTeamMember> atmlist = new List<AccountTeamMember>();
             AccountTeamMember atm = new AccountTeamMember(AccountId = la[0].id, UserId = u2.id,TeamMemberRole = 'VP of Sales (Comm/Gen)');
             AccountTeamMember atm1 = new AccountTeamMember(AccountId = la[1].id, UserId = u2.id,TeamMemberRole = 'DM (Spec)');
             atmlist.add(atm);
             atmlist.add(atm1);
             insert atmlist;
             
             accid.add(la[0].id);
             accid.add(la[1].id);
             aid.add(la[0].id);
             aid.add(la[1].id);
             set<id> sdId = new set<id>();
             sdId.add(SDogsList[0].id);
            // sdId.add(SDogsList[1].id);
             
              set<id> stId = new set<id>();
             stId.add(st.id);
             stId.add(st1.id);
             
            // Account_Team_Triggers.AccountTeamMembersSyncFromFlow(aid);
            // Account_Team_Triggers.SAP_Sales_DOG(sdId);
            // Account_Team_Triggers.SAP_Territories(stId);
            // Account_Team_Triggers.Account(accid);
             //Account_Team_Triggers.AccountTeamMembersSyncFromFlow(aid);
             test.stoptest();
             
       }      
      }
}