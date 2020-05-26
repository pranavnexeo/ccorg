/*Nexprice CPI Security Project
 *This class shares AccountMaterial, Account and Opportunity records with Sellers
 *Author @Rajeev
 *Test method in "nexpriceCPI_security" class.
 */
public class Nexprice_Account_Team_Functions{
        
        
        public static void createSharingRecords(List<Nexeo_Account_Team__c> nexpriceMembers,boolean isInsert){
             /*Initialzing variables*/
             List<AccountShare> Accountshares = new List<AccountShare>();
             List<Account_Material__share> AccountMaterialshares = new List<Account_Material__share>();
             AccountShare accounts;
             Account_Material__share accountMaterials;
             Set<Id> accountIds = new Set<Id>();
             Set<Id> userIds = new Set<Id>();
             Set<String> teamset = new set<String>();
             Map<Id, List<Account_Material__c>> ammap = new Map<Id, List<Account_Material__c>>();
            
             
             /*Loop over the records to capture related Account Ids*/
             for(Nexeo_Account_Team__c team : nexpriceMembers){
               /*Set of Account Ids will have only one element as 'nexpriceMembers' will have same AccountId for all the records*/
                     accountIds.add(team.Account__c);
               /*UserId is captured to find the users with whom the record will be shared*/      
                     userIds.add(team.User__c);
                     teamset.add('' + team.Account__c + team.User__c);
                     if(!ammap.containskey(team.Account__c))
                       ammap.put(team.Account__c, new List<Account_Material__c>());
             
             }

             /*Query all the related Account Material records*/
             Map<Id, Account_Material__c> amRecords = new Map<Id, Account_material__c>([Select Id, Account__c, Material__c from Account_Material__c where Account__c In :accountIds]);
             for(Account_Material__c am:amRecords.values())
               ammap.get(am.Account__c).add(am);
             
             /*Delete exisitng Account shares if Update*/
             if(!IsInsert){
              List<AccountShare> deletesharesOnUpdate = new List<AccountShare>();
             
              //Make sure that the Account Share is for the combination of Account and User. 
              for(AccountShare acctshare:[Select Id, UserOrGroupId, AccountId, RowCause from AccountShare where (AccountId IN :accountIds) and rowCause = 'Manual' and (UserOrGroupId In :userIds)]){
                 if(teamset.contains('' + acctshare.AccountId + acctshare.UserOrGroupId))
                    deletesharesOnUpdate.add(acctshare);  
              }
                    
              if(deletesharesOnUpdate != null && deletesharesOnUpdate.size()>0){
                   delete deletesharesOnUpdate;
              }
             
             /*Delete exisitng Account materials shares*/
             List<Account_Material__share> deletesharesAccountMatOnUpdate = new List<Account_Material__share>();
             
             for(Account_Material__share ams:[Select Id, RowCause, UserOrGroupId, ParentId from Account_Material__share where (ParentId IN :amrecords.keyset()) and RowCause = 'Nexprice_Team_Member__c' and (UserOrGroupId In :userIds)]){
                 if(teamset.contains('' + amRecords.get(ams.Parentid).Account__c + ams.UserOrGroupId))
                   deletesharesAccountMatOnUpdate.add(ams);
             }
                 
              if(deletesharesAccountMatOnUpdate != null && deletesharesAccountMatOnUpdate.size()>0){
                delete deletesharesAccountMatOnUpdate;
              }
           }//end if
              
              
            /*Loop over the records being inserted/updated. Create sharing records.*/ 
            for(Nexeo_Account_Team__c nat:nexpriceMembers){
            
                /*Instantiate share objects*/
                accounts = new AccountShare();
                
                /*create shares for Account*/
                accounts.AccountId = nat.Account__c;
                accounts.AccountAccessLevel = 'Edit';
                accounts.UserOrGroupId = nat.User__c;
               if(nat.Opportunity_Access__c != null){
                accounts.OpportunityAccessLevel = nat.Opportunity_Access__c;
                }
                
                Accountshares.add(accounts);
                
                
                /*Create shares for Account material records*/
                /*Get AccountMaterials id from the map based on AccountId*/
                 
              if(ammap.containskey(nat.account__c)){
              for(account_material__c am:ammap.get(nat.Account__c)){
              
                /*Instantiate Account material shares*/
                accountMaterials = new Account_Material__share();
                accountMaterials.ParentId = am.Id;
                accountMaterials.AccessLevel = 'Edit';
                accountMaterials.UserOrGroupId = nat.User__c;
                accountMaterials.RowCause = Schema.Account_Material__share.RowCause.Nexprice_Team_Member__c;
                AccountMaterialshares.add(accountMaterials);
 
               }
            }
         }
            
            /*Insert sharing records*/
            
            Database.SaveResult[]  AccountsharesResults = Database.insert(Accountshares,false);
            Database.SaveResult[] AccountMaterialsharesResults = Database.insert(AccountMaterialshares,false);
            
 
        }
        
        
        /*Method to delete share records on delete of Nexprice Account Team record*/
        public static void deleteSharingRecords(List<Nexeo_Account_Team__c> nexpriceMembersToDelete){
            
            Set<Id> AccountIds = new Set<Id>();
            Set<Id> UserIds = new Set<Id>();
            Set<String> teamset = new set<String>();
            
            for(Nexeo_Account_Team__c nat : nexpriceMembersToDelete){
                AccountIds.add(nat.Account__c);
                UserIds.add(nat.User__c);
                teamset.add('' + nat.Account__c + nat.User__c);
            }
            
            Map<Id, Account_Material__c> amRecordsToDelete = new Map<Id, Account_Material__c>([Select Id,Account__c from Account_Material__c where Account__c In :AccountIds]);

            List<AccountShare> deleteAccountShares = new List<AccountShare>();
            
            for(AccountShare acctshare:[Select Id, AccountId, RowCause, UserOrGroupId from AccountShare where (AccountId IN :AccountIds) and rowCause = 'Manual' and (UserOrGroupId In :UserIds)])
                 if(teamset.contains('' + acctshare.AccountId + acctshare.UserOrGroupId))
                    deleteAccountShares.add(acctshare);
            
            if(deleteAccountShares != null && deleteAccountShares.size()>0)
            delete deleteAccountShares;
            
            List<Account_Material__share> deletesharesAccountMat = new List<Account_Material__share>();
            
            for(Account_Material__share amshare:[Select Id, RowCause, ParentId, UserOrGroupId from Account_Material__share where (ParentId IN :amRecordsToDelete.keyset()) and (RowCause != 'Owner' and RowCause = 'Nexprice_Team_Member__c') and (UserOrGroupId In :UserIds)])
                if(teamset.contains('' + amRecordsToDelete.get(amshare.ParentId).Account__c + amshare.UserOrGroupId))
                   deletesharesAccountMat.add(amshare);
            
            if(deletesharesAccountMat != null && deletesharesAccountMat.size()>0)
            delete deletesharesAccountMat;
             
        }
        
 }