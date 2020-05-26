/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        	03/22/2019
*    Author:             	Francisco Garcia
*   Last Modified:       
*   Last Modified By:    
*	Functional Consultant: 	Jamie Harry  UTN: 3411
*
*   Short Description:  Test Class for DataCleanupAccountTeamMembers, DataCleanupAccountTeamMembers_Scheduler.
*   **********************************************************************************************************************/


@isTest
private class DataCleanupAccountTeamMembers_Test {
    
    @isTest
    private static void testDataCleanupAccountTeamMembers(){
       
        Profile p=[select id from profile where name = 'System Administrator'];
        UserRole ur = new UserRole(Name = 'CIO');
        insert ur;
		User usr=new User(
            				username='testthis123@testplastics.com',
            				email='test@test.com',
            				alias='test',
            				FirstName='test',
            				Lastname='test',
            				ProfileId=p.Id,
        					LocaleSidKey= 'en_US',
        					TimeZoneSidKey='GMT',
        					UserRoleId=ur.Id,
            				LanguageLocaleKey = 'en_US',
            				EmailEncodingKey  = 'UTF-8',
        					isActive=True);
        Insert usr;
        User usrInactive=new User();
        	usrInactive.username='testthisinactive123@testplastics.com';
            usrInactive.email='test@test.com';
            usrInactive.alias='test';
            usrInactive.FirstName='test';
            usrInactive.Lastname='test';
            usrInactive.ProfileId=p.Id;
            usrInactive.LocaleSidKey= 'en_US';
            usrInactive.TimeZoneSidKey='GMT';
            usrInactive.UserRoleId=ur.Id;
            usrInactive.LanguageLocaleKey = 'en_US';
            usrInactive.EmailEncodingKey  = 'UTF-8';
            usrInactive.isActive=True;
        insert usrInactive;
        
        System.runAs(usr){
            List<Account> listAccounts1=new List<Account>();
            List<Account> listAccounts2=new List<Account>();
            List<Account> listAccounts=new List<Account>();
            for(integer i=0; i<100; i++){
        		Account acct=new Account(Name='Coats'+System.now());
                listAccounts1.add(acct);
            }
        insert listAccounts1;
            for(integer i=0; i<100; i++){
        		Account acct=new Account(Name='Coats'+System.now());
                listAccounts2.add(acct);
            }
        insert listAccounts2;
            listAccounts.addAll(listAccounts1);
            listAccounts.addAll(listAccounts2);
            List<AccountTeamMember> listATM=new List<AccountTeamMember>();
            for(Account acct:listAccounts){             
        	AccountTeamMember atm=new AccountTeamMember(
            				AccountId=acct.Id,
            				UserId=usrInactive.Id        
        					);                        
                listATM.add(atm);
            }   
        Insert listATM;
        usrInactive.IsActive=False;
        update usrInactive; 
            
        Test.startTest();
        System.assertEquals(listATM.size(), 200);
            
        String cron_exp = '0 0 12 ? * SAT *';
       	String jobId =System.schedule('ScheduledApexTest',cron_exp,new DataCleanupAccountTeamMembers_Scheduler());
        DataCleanupAccountTeamMembers_Scheduler sched=new DataCleanupAccountTeamMembers_Scheduler();
        sched.scheduleit();
        DataCleanupAccountTeamMembers atmClass=new DataCleanupAccountTeamMembers();
        Database.executebatch(atmClass,200);
        List<AccountTeamMember> atm=[SELECT ID,UserId FROM ACCOUNTTEAMMEMBER WHERE USER.iSaCTIVE=True];    
        System.assertEquals(atm.size(), 0);
        Test.stopTest();
       } 
       
    }
    
}