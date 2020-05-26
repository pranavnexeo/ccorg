@isTest
    Private Class UserSapSellerNumbersBatchable_test{
  
        Public static testmethod void TestUserSapSellerNumbersBatchable(){
        list<SObject> objs=new  list<SObject>();
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            List<user> ulist = new List<user>(); 
            User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Testing1', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbhdc@gorg.com', IsActive = true);
             ulist.add(u);
             insert ulist;
          try{
        Test.startTest();
         
            UserSapSellerNumbersBatchable con = new UserSapSellerNumbersBatchable(); 
            Id batchId = Database.executeBatch(con);           
            con.execute(null,ulist);    
            con.finish(null);                           
       Test.stoptest();
        }
        catch(exception e){}
        
       }
   }