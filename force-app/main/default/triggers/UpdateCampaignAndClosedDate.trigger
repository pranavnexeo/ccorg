/*This trigger is used to populate "Primary Campaign Source" field on insert of a new Opportunity, based on value in 
  "Default Opportunity Campaign" field on Account. If "Default Opportunity Campaign" field is blank then the trigger looks
  in "Account related to camapaign", finds the appropriate CampaignId and populates that in "Primary Campaign Source" 
  field on Opportunity. 
  Covered as a part of EMEA enhancement.
  Also updates ClosedDate equal to Today's date based on some condition.
  @Author - Rajeev S
*/
trigger UpdateCampaignAndClosedDate on Opportunity (before insert,before update) {
    Set<Id> AccIdSet = new Set<Id>();
    Map<Id,String> accmap = new Map<Id,String>();
    Map<String,Id> CamMap = new Map<String,Id>();
    List<Account_Related_to_Campaign__c> RelatedAcc = new List<Account_Related_to_Campaign__c>(); 
    Set<Id> RelatedSet = new Set<Id>();
    Map<Id,Id> RelatedMap = new Map<Id,Id>(); 
    Map<String,Id> OppRecordTypes = new Map<String,Id>();//Added as an enhancement
    Map<String, OpportunityStage> stageMap = new Map<String, OpportunityStage>();
    
    //Added for enhancement @INC000002060705 - Rajeev
    OppRecordTypes = RecordType_Functions.RetrieveRecordTypeNameMap('Opportunity');//Getting record types
    StageMap = Opportunity_Functions.getOpportunityStageMap();//Getting map of all the Stages
    
    //Get all the related AccountIds used during creation of Opportunities.
    for(Opportunity opp:trigger.new){
        /*Added as an enhancement for Ticket @INC000002060705*/
        /**@Rajeev**/
         if((Trigger.isUpdate) && (OppRecordTypes.get('Distribution Plastics EMEA') == opp.RecordTypeId) 
             && (((stageMap.get(opp.StageName).MasterLabel == 'Closed Won')&& (trigger.oldMap.get(opp.Id).StageName!= 'Closed Won'))
             || ((stageMap.get(opp.StageName).MasterLabel == 'Closed - Not Awarded / Lost')&& (trigger.oldMap.get(opp.Id).StageName!= 'Closed - Not Awarded / Lost')))){
             opp.CloseDate = System.today();//End of enhancement
           }
             AccIdSet.add(opp.AccountId);
      }
    //Create a list of records based on above set of AccountIds. 
    List<Account> accList = [select Id,Default_Opportunity_Campaign__c from Account where id in:AccIdSet];
    
    //Check if "Default Oportunity Campaign" field is blank. If not, create a map of Id and field values.
    for(Account s:accList){
       If(s.Default_Opportunity_Campaign__c != '' && s.Default_Opportunity_Campaign__c != null){
            accmap.put(s.Id,s.Default_Opportunity_Campaign__c);
         }
    //If blank get set of all AccountIds with blank "Default Oportunity Campaign" field.
       else{
         RelatedSet.add(s.id);
         
       } 
     }
     //Query Account related to campaign object based on above queries. Order them by created date.
     RelatedAcc = [Select Account__c,Campaign__c from Account_Related_to_Campaign__c where Account__c In:RelatedSet
                                    and Campaign__r.Isactive = True order by CreatedDate DESC];
     
     //Create a map of CampaignId and AccountId by looping over RelatedAcc. Don't add AccountId if already present.
     for(Account_Related_to_Campaign__c arc:RelatedAcc){
                if(!RelatedMap.containskey(arc.Account__c))
                    RelatedMap.put(arc.Account__c,arc.Campaign__c);
        }
    
    //Query from Campaign for those Accounts which don't have blank "Default Oportunity Campaign" field & create a map.
    if(!accmap.IsEmpty()){
    List <Campaign> camList = [Select Id,Name from Campaign where Name in:accmap.values() and Isactive = true];
      for(Campaign c:camList){
       CamMap.put(c.Name,c.id);
      }
    }
     
     //Finally, populate the Primary campaign source field on Opportunity.
     for(Opportunity o:trigger.new){
       if(CamMap.get(accmap.get(o.AccountId)) != null){
           o.CampaignId = CamMap.get(accmap.get(o.AccountId));
         }
       else  
       if(RelatedMap.get(o.AccountId)!=null){
           o.CampaignId = RelatedMap.get(o.AccountId);
      }
     }
    }