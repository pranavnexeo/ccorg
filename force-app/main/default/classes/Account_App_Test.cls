@isTest
private class Account_App_Test {

static User TestUser;


  public static testMethod void testAccountApp() {
        
  			//Adding code to prevent have hardcoded IDs
  			Map<String, SObject> testData = NexeoTestUtils_Test.initData();

            Account account = (Account) testData.get('testGeneralAccount');            
             
            
            Account_App controller=new Account_App(new apexpages.standardcontroller(account));
            Account_App.Account_Entry a = new Account_App.Account_Entry('test',account,true);
            
             }
     }