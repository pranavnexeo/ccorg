public class Account_Team_Functions{
        
        
        public static void createSharingRecordsNeXpriceCPI(List<AccountTeamMember> Members,boolean isInsert){
             
             List<Account_Material__share> AccountMaterialshares = new List<Account_Material__share>();
             Account_Material__share accountMaterials;
             Set<Id> accountIds = new Set<Id>();
             Set<Id> userIds = new Set<Id>();
             Set<String> teamset = new set<String>();
             Map<Id, List<Account_Material__c>> ammap = new Map<Id, List<Account_Material__c>>();
            
             
             for(AccountTeamMember team : Members){
                         accountIds.add(team.AccountId);
                         userIds.add(team.UserId);
                     teamset.add('' + team.AccountId + team.UserId);
                     if(!ammap.containskey(team.AccountId))
                       ammap.put(team.AccountId, new List<Account_Material__c>());
             
             }

             /*Query all the related Account Material records*/
             Map<Id, Account_Material__c> amRecords = new Map<Id, Account_material__c>([Select Id, Account__c, Material__c from Account_Material__c where Account__c In :accountIds]);
             for(Account_Material__c am:amRecords.values())
               ammap.get(am.Account__c).add(am);
             
             /*Delete exisitng Account shares if Update*/
             if(!IsInsert){
             
             /*Delete exisitng Account materials shares*/
             List<Account_Material__share> deletesharesAccountMatOnUpdate = new List<Account_Material__share>();
             
             for(Account_Material__share ams:[Select Id, RowCause, UserOrGroupId, ParentId from Account_Material__share where (ParentId IN :amrecords.keyset()) and RowCause != 'Owner' and RowCause != 'Rule' and (UserOrGroupId In :userIds)]){
                 if(teamset.contains('' + amRecords.get(ams.Parentid).Account__c + ams.UserOrGroupId))
                   deletesharesAccountMatOnUpdate.add(ams);
             }
                 
              if(deletesharesAccountMatOnUpdate != null && deletesharesAccountMatOnUpdate.size()>0){
                delete deletesharesAccountMatOnUpdate;
              }
           }//end if
           
            for(AccountTeamMember nat:Members){
            
                
              /*Get AccountMaterials id from the map based on AccountId*/
              if(ammap.containskey(nat.accountId)){
              for(account_material__c am:ammap.get(nat.AccountId)){
              
                /*Instantiate Account material shares*/
                accountMaterials = new Account_Material__share();
                accountMaterials.ParentId = am.Id;
                accountMaterials.AccessLevel = 'Edit';
                accountMaterials.UserOrGroupId = nat.UserId;
                accountMaterials.RowCause = Schema.Account_Material__share.RowCause.Nexprice_Team_Member__c;
                AccountMaterialshares.add(accountMaterials);
 
               }
            }
         }
              
              Database.SaveResult[] AccountMaterialsharesResults = Database.insert(AccountMaterialshares,false);
            
 
        }
        
       @Future
       public static void createSharingRecordsBusinessContractFuture(Set<Id> ids, boolean isinsert, string sessionid){
         List<AccountTeamMember> team = [Select Id, AccountAccessLevel, AccountId, TeamMemberRole, UserId, IsDeleted from AccountTeamMember where AccountId in : Ids];
         createSharingRecordsBusinessContract(team, isinsert);
         
       }
       public static void createSharingRecordsBusinessContract(List<AccountTeamMember> Members,boolean isInsert){

        List<Business_Contract__share> BusinessContractshares = new List<Business_Contract__share>();
             Business_Contract__share BusinessContract;
             Set<Id> accountIds = new Set<Id>();
             Set<Id> userIds = new Set<Id>();
             Set<String> teamset = new set<String>();
             Map<Id, List<Business_Contract__c>> bcmap = new Map<Id, List<Business_Contract__c>>();
            
             for(AccountTeamMember team : Members){
                         accountIds.add(team.AccountId);
                         userIds.add(team.UserId);
                         teamset.add('' + team.AccountId + team.UserId);
                         if(!bcmap.containskey(team.AccountId))
                            bcmap.put(team.AccountId, new List<Business_Contract__c>());
             
             }
             
             /*Query all the related Business Contract records*/
             Map<Id, Business_Contract__c> bcRecords = new Map<Id, Business_Contract__c>([Select Id, Customer_Name__c from Business_Contract__c where Customer_Name__c In :accountIds]);
                 for(Business_Contract__c bc:bcRecords.values())
                     bcmap.get(bc.Customer_Name__c).add(bc);
             
              /*Delete exisitng Business Contract shares if Update*/
                if(!IsInsert){
                     List<Business_Contract__share> deletesharesBusinessContractOnUpdate = new List<Business_Contract__share>();
             
                     for(Business_Contract__share bcs:[Select Id, RowCause, UserOrGroupId, ParentId from Business_Contract__share where (ParentId IN :bcrecords.keyset()) and RowCause != 'Owner' and RowCause != 'Rule' and (UserOrGroupId In :userIds)]){
                         if(teamset.contains('' + bcRecords.get(bcs.Parentid).Customer_Name__c + bcs.UserOrGroupId))
                           deletesharesBusinessContractOnUpdate.add(bcs);
                 }
                 
                  if(deletesharesBusinessContractOnUpdate != null && deletesharesBusinessContractOnUpdate.size()>0){
                    delete deletesharesBusinessContractOnUpdate;
                  }
           }//end if
           
           for(AccountTeamMember nat:Members){
  
              /*Get Business Contract id from the map based on AccountId*/
              if(bcmap.containskey(nat.accountId)){
                  for(Business_Contract__c bc:bcmap.get(nat.AccountId)){
                  
                    /*Instantiate Business Contractl shares*/
                    BusinessContract = new Business_Contract__share();
                    BusinessContract.ParentId = bc.Id;
                    BusinessContract.AccessLevel = 'Edit';
                    BusinessContract.UserOrGroupId = nat.UserId;
                    BusinessContract.RowCause = Schema.Business_contract__share.RowCause.Account_Team__c;
                    BusinessContractShares.add(BusinessContract);
 
                   }
            }
         }
              
         Database.SaveResult[] BusinessContractsharesResults = Database.insert(BusinessContractshares,false);
  
 
     }
        
     public static void createSharingRecordsRDRequest(List<AccountTeamMember> Members,boolean isInsert){
                List<R_D_Requests__share> rdshares = new List<R_D_Requests__share>();
                R_D_Requests__share RDRequest;
                Set<Id> accountIds = new Set<Id>();
                Set<Id> userIds = new Set<Id>();
                Set<String> teamset = new set<String>();
                Map<Id, List<R_D_Requests__c>> ammap= new Map<Id, List<R_D_Requests__c>>();
            
             
                 for(AccountTeamMember team : Members){
                       accountIds.add(team.AccountId);
                       userIds.add(team.UserId);
                       teamset.add('' + team.AccountId + team.UserId);
                       if(!ammap.containskey(team.AccountId))
                          ammap.put(team.AccountId, new List<R_D_Requests__c>());
             
                 }

             
             Map<Id, R_D_Requests__c> amRecords = new Map<Id, R_D_Requests__c>([Select Id, Customer__c from R_D_Requests__c where Customer__c In :accountIds]);
                 for(R_D_Requests__c am:amRecords.values())
                   ammap.get(am.Customer__c).add(am);
             
             if(!IsInsert){

                 List<R_D_Requests__share> deletesharesrdrequest = new List<R_D_Requests__share>();
             
                 for(R_D_Requests__share ams:[Select Id, RowCause, UserOrGroupId, ParentId from R_D_Requests__share where (ParentId IN :amrecords.keyset()) and RowCause != 'Owner' and RowCause != 'Rule' and (UserOrGroupId In :userIds)]){
                     if(teamset.contains('' + amRecords.get(ams.Parentid).customer__c + ams.UserOrGroupId))
                       deletesharesrdrequest.add(ams);
                 }
                 
                  if(deletesharesrdrequest != null && deletesharesrdrequest.size()>0){
                    delete deletesharesrdrequest;
                  }
            }//end if
           
            for(AccountTeamMember nat:Members){
                 if(ammap.containsKey(nat.accountId)){
                    for(R_D_Requests__c am:ammap.get(nat.AccountId)){
                        RDRequest = new R_D_Requests__share();
                        RDRequest.ParentId = am.Id;
                        RDRequest.AccessLevel = 'Edit';
                        RDRequest.UserOrGroupId = nat.UserId;
                        RDRequest.RowCause = Schema.R_D_Requests__share.RowCause.Nexprice_Team_Member__c;
                        rdshares.add(RDRequest);
 
                   }
                }
         }
              
          Database.SaveResult[] rdsharesResults = Database.insert(rdshares,false);
            
 
        }
        
        public static void createSharingRecordsChemLabReport(List<AccountTeamMember> Members,boolean isInsert){
             
             List<Competitive_Analysis_Report__share> clrshares = new List<Competitive_Analysis_Report__share>();
             Competitive_Analysis_Report__share clRep;
             
             
             Set<Id> accountIds = new Set<Id>();
             Set<Id> userIds = new Set<Id>();
             Set<String> teamset = new set<String>();
             Map<Id, List<Competitive_Analysis_Report__c>> ammap= new Map<Id, List<Competitive_Analysis_Report__c>>();
            
             
             for(AccountTeamMember team : Members){
                   accountIds.add(team.AccountId);
                   userIds.add(team.UserId);
                   teamset.add('' + team.AccountId + team.UserId);
                   if(!ammap.containskey(team.AccountId))
                        ammap.put(team.AccountId, new List<Competitive_Analysis_Report__c>());
             }

             Map<Id, Competitive_Analysis_Report__c> amRecords = new Map<Id, Competitive_Analysis_Report__c>([Select Id, Lab_Number__r.Customer__c from Competitive_Analysis_Report__c where Lab_Number__r.Customer__c In :accountIds]);
                 for(Competitive_Analysis_Report__c am:amRecords.values())
                   ammap.get(am.Lab_Number__r.Customer__c).add(am);
             
             if(!IsInsert){
             
             List<Competitive_Analysis_Report__share> deletesharesrdrequest = new List<Competitive_Analysis_Report__share>();
                 for(Competitive_Analysis_Report__share ams:[Select Id, RowCause, UserOrGroupId, ParentId from Competitive_Analysis_Report__share where (ParentId IN :amrecords.keyset()) and RowCause != 'Owner' and RowCause != 'Rule' and (UserOrGroupId In :userIds)]){
                     if(teamset.contains('' + amRecords.get(ams.Parentid).Lab_Number__r.customer__c + ams.UserOrGroupId))
                       deletesharesrdrequest.add(ams);
             }
                 
              if(deletesharesrdrequest != null && deletesharesrdrequest.size()>0){
                delete deletesharesrdrequest;
              }
           }
           
            for(AccountTeamMember nat:Members){
            
                 
              if(ammap.containsKey(nat.accountId)){
                for(Competitive_Analysis_Report__c am:ammap.get(nat.AccountId)){
                    clRep = new Competitive_Analysis_Report__share();
                    clRep.ParentId = am.Id;
                    clRep.AccessLevel = 'Edit';
                    clRep.UserOrGroupId = nat.UserId;
                    clRep.RowCause = Schema.Competitive_Analysis_Report__share.RowCause.Account_Team__c;
                    clrshares.add(clRep);
 
               }
            }
         }
              
         Database.SaveResult[] rdsharesResults = Database.insert(clrshares,false);
            
 
        }
        
        public static void createSharingRecordsSampleAnalysisReq(List<AccountTeamMember> Members,boolean isInsert){
             
             List<Sample_Analysis_Request__share> clrshares = new List<Sample_Analysis_Request__share>();
             Sample_Analysis_Request__share clRep;
             
             
             Set<Id> accountIds = new Set<Id>();
             Set<Id> userIds = new Set<Id>();
             Set<String> teamset = new set<String>();
             Map<Id, List<Sample_Analysis_Request__c>> ammap= new Map<Id, List<Sample_Analysis_Request__c>>();
            
             
             for(AccountTeamMember team : Members){
                   accountIds.add(team.AccountId);
                   userIds.add(team.UserId);
                   teamset.add('' + team.AccountId + team.UserId);
                   if(!ammap.containskey(team.AccountId))
                        ammap.put(team.AccountId, new List<Sample_Analysis_Request__c>());
             }

             Map<Id, Sample_Analysis_Request__c> amRecords = new Map<Id, Sample_Analysis_Request__c>([Select Id, Customer__c from Sample_Analysis_Request__c where Customer__c In :accountIds]);
                 for(Sample_Analysis_Request__c am:amRecords.values())
                   ammap.get(am.Customer__c).add(am);
             
             if(!IsInsert){
             
             List<Sample_Analysis_Request__share> deletesharesrdrequest = new List<Sample_Analysis_Request__share>();
                 for(Sample_Analysis_Request__share ams:[Select Id, RowCause, UserOrGroupId, ParentId from Sample_Analysis_Request__share where (ParentId IN :amrecords.keyset()) and RowCause != 'Owner' and RowCause != 'Rule' and (UserOrGroupId In :userIds)]){
                     if(teamset.contains('' + amRecords.get(ams.Parentid).customer__c + ams.UserOrGroupId))
                       deletesharesrdrequest.add(ams);
             }
                 
              if(deletesharesrdrequest != null && deletesharesrdrequest.size()>0){
                delete deletesharesrdrequest;
              }
           }
           
            for(AccountTeamMember nat:Members){
            
                 
              if(ammap.containsKey(nat.accountId)){
                for(Sample_Analysis_Request__c am:ammap.get(nat.AccountId)){
                    clRep = new Sample_Analysis_Request__share();
                    clRep.ParentId = am.Id;
                    clRep.AccessLevel = 'Edit';
                    clRep.UserOrGroupId = nat.UserId;
                    clRep.RowCause = Schema.Sample_Analysis_Request__share.RowCause.Account_Team__c;
                    clrshares.add(clRep);
 
               }
            }
         }
              
         Database.SaveResult[] rdsharesResults = Database.insert(clrshares,false);
            
 
        }
        
        public static void createSharingRecordsSalesChurn(List<AccountTeamMember> Members,boolean isInsert){
             
             List<SalesChurn__share> clrshares = new List<SalesChurn__share>();
             SalesChurn__share clRep;
             
             
             Set<Id> accountIds = new Set<Id>();
             Set<Id> userIds = new Set<Id>();
             Set<String> teamset = new set<String>();
             Map<Id, List<SalesChurn__c>> ammap= new Map<Id, List<SalesChurn__c>>();
            
             
             for(AccountTeamMember team : Members){
                   accountIds.add(team.AccountId);
                   userIds.add(team.UserId);
                   teamset.add('' + team.AccountId + team.UserId);
                   if(!ammap.containskey(team.AccountId))
                        ammap.put(team.AccountId, new List<SalesChurn__c>());
             }

             Map<Id, SalesChurn__c> amRecords = new Map<Id, SalesChurn__c>([Select Id, Account_Number__c from SalesChurn__c where Account_Number__c In :accountIds]);
                 for(SalesChurn__c am:amRecords.values())
                   ammap.get(am.Account_Number__c).add(am);
             
             if(!IsInsert){
             
             List<SalesChurn__share> deletesharesrdrequest = new List<SalesChurn__share>();
                 for(SalesChurn__share ams:[Select Id, RowCause, UserOrGroupId, ParentId from SalesChurn__share where (ParentId IN :amrecords.keyset()) and RowCause != 'Owner' and RowCause != 'Rule' and (UserOrGroupId In :userIds)]){
                     if(teamset.contains('' + amRecords.get(ams.Parentid).Account_Number__c + ams.UserOrGroupId))
                       deletesharesrdrequest.add(ams);
             }
                 
              if(deletesharesrdrequest != null && deletesharesrdrequest.size()>0){
                delete deletesharesrdrequest;
              }
           }
           
            for(AccountTeamMember nat:Members){
            
                 
              if(ammap.containsKey(nat.accountId)){
                for(SalesChurn__c am:ammap.get(nat.AccountId)){
                    clRep = new SalesChurn__share();
                    clRep.ParentId = am.Id;
                    clRep.AccessLevel = 'Edit';
                    clRep.UserOrGroupId = nat.UserId;
                    clRep.RowCause = Schema.SalesChurn__share.RowCause.Account_Team__c;
                    clrshares.add(clRep);
 
               }
            }
         }
              
         Database.SaveResult[] rdsharesResults = Database.insert(clrshares,false);
            
 
        }
        
      }