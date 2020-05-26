/**  
* @Name    authForExp_ApprovalProcess_Trigger 
* @Purpose This trigger is used in AFE Approval Process to Update the next approver field 
* @Modified Rajeev
* The trigger also populates "Division AFE Coordinator" based on a CustomSetting data. Please change the CustomSetting data
  if Division AFE Coordinator changes in future.
*/

trigger authForExpApprovalProcessTriggers on Authorization_for_Expenditure__c (Before insert, Before update) {
      
      List<User> UserData = new List<User>();
        
      if(trigger.isInsert){
        CustomSettings__c settings = Customsettings__c.getorgdefaults();
          if(settings.Divisional_AFE_Coordinator__c != null)
             UserData = [Select Id from User where Email = :settings.Divisional_AFE_Coordinator__c limit 1];
        
        }
        
        for(Authorization_for_Expenditure__c afe : Trigger.new)
        {
          if(trigger.isInsert && UserData.size()>0){
              afe.Division_AFE_Coordinator__c = UserData[0].Id; 
              
          }
              
          if(Trigger.isBefore){
                if(Trigger.isUpdate){
                    Authorization_for_Expenditure__c oldAfe = System.Trigger.oldMap.get(afe.Id);
                     if(afe.Status__c == 'New'){
                        afe.Supplement_counter__c = oldAfe.Supplement_counter__c + 1 ;
                        afe.Supplement__c = afe.Supplement_counter__c;
                        }else
                        {
                            if(afe.Status__c == 'Cancelled'){
                                afe.Supplement_counter__c = oldAfe.Supplement_counter__c - 1 ;
                                afe.Supplement__C = afe.Supplement_counter__c;
                            }
                        }
                        
                }
            }
            
            
      if(afe.Approval_Level__c==null){
       if(afe.Approval_Status__c == 'Submitted'){
                    afe.Next_Approver__c = afe.Division_AFE_Coordinator__c;
                    List<AFE_approvers__c> approver =[Select a.Level__c, a.Key__c, a.Id, a.Authorization_for_Expenditure__c, a.Approver_5__c, a.Approver_4__c, a.Approver_3__c, a.Approver_2__c,a.Approver_1__c From AFE_approvers__c a  where a.Authorization_for_Expenditure__c=: afe.Id and a.Level__c='1'];
                    afe.Approver1__c= checkNullApprover(approver[0].Approver_1__c,approver[0].Key__c);
                    afe.Approver2__c= checkNullApprover(approver[0].Approver_2__c,approver[0].Key__c);
                    afe.Approver3__c= checkNullApprover(approver[0].Approver_3__c,approver[0].Key__c);
                    afe.Approver4__c= checkNullApprover(approver[0].Approver_4__c,approver[0].Key__c);
                    afe.Approver5__c= checkNullApprover(approver[0].Approver_5__c,approver[0].Key__c);
                    
           }
      }
           
     if(afe.Approval_Level__c!=null){
            Integer current_approval_level = Integer.valueOf(afe.Approval_Level__c);
            Integer total_approval_level = Integer.valueOf(afe.Levels_Of_Approval_Required__c);
            SObject afeObj = afe;
            
             if(current_approval_level>total_approval_level)
                {
                    afe.Approval_Status__c='Limit';
                }
         
                if(current_approval_level>=1&&afe.Approval_Status__c=='Submitted'){
                   try{
                    AFE_approvers__c approver =[Select a.Level__c, a.Key__c, a.Id, a.Authorization_for_Expenditure__c, a.Approver_5__c, a.Approver_4__c, a.Approver_3__c, a.Approver_2__c,a.Approver_1__c From AFE_approvers__c a  where a.Authorization_for_Expenditure__c=: afe.Id and a.Level__c=:String.valueOf(afe.Approval_Level__c)];
                    afe.Approver1__c= checkNullApprover(approver.Approver_1__c,approver.Key__c);
                    afe.Approver2__c= checkNullApprover(approver.Approver_2__c,approver.Key__c);
                    afe.Approver3__c= checkNullApprover(approver.Approver_3__c,approver.Key__c);
                    afe.Approver4__c= checkNullApprover(approver.Approver_4__c,approver.Key__c);
                    afe.Approver5__c= checkNullApprover(approver.Approver_5__c,approver.Key__c);
                    
                    }catch(System.QueryException ex){
                  }
            }
         
        } 
    
     }
       
      public Id checkNullApprover(Id approver,Id Key){
        if(approver==null)
        return key;
        else 
        return approver;
      }
      
}