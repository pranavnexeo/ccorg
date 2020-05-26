trigger AuthorizationforExpenditureApprovalSubReqMeet on Authorization_for_Expenditure__c (before insert, before update) {
     
        //if(Recursion.authorizationforExpenditureApprovalSubReqMeet)
        //  return;
        //Recursion.authorizationforExpenditureApprovalSubReqMeet = true;
     
        String execs;
        List<Authorization_for_Expenditure_CS__c> execs_cs = Authorization_for_Expenditure_CS__c.getall().values();
        
      
        
          if (execs_cs[0].AFE_C_Level_Approvers__c != null) {
                execs = execs_cs[0].AFE_C_Level_Approvers__c;
           }
            
      //  Set<String> sTest = new Set<String>{'David Bradley', 'Ross Crane', 'Mike Farnell'};
        Set<String> s1 = new Set<String>();
        List<String> lstExecs = execs.split(',');
        
        s1.addAll(lstExecs); 
        
        Integer c_approvalCountReq = s1.size(); 
        
        //original
        Set<Id> c_approvers = new Set<Id>(New Map<Id, User>([SELECT Id FROM USER WHERE Name IN :s1]).keySet());
        //close original
        //new 
        
        Set<User> c_approvers2 = new Set<User>([Select id from User Where Name IN :s1]);
        List<User> lUser = new List<User>([Select id from User Where Name IN :lstExecs]);
        
        for(Authorization_for_Expenditure__c afe : Trigger.new) {
            Integer cLevelApprovalCount=0;
            //if not approved and over 1,000,000 afe amount
            if (afe.Approval_Status__c=='New'  && afe.USD_Total_Amount__c >= 1000000) {
                Boolean inApprovalSet; 
                Set<Id> selectedApprovers;
                
                inApprovalSet = c_approvers.contains(afe.Approver1__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver2__c);
                if (inApprovalSet == true) { 
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver3__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver4__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver5__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver6__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver7__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver8__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver9__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver10__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver11__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver12__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver13__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver14__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                inApprovalSet = c_approvers.contains(afe.Approver15__c);
                if (inApprovalSet == true) {
                    cLevelApprovalCount = cLevelApprovalCount + 1;
                    inApprovalSet = false;
                }
                
                if (c_approvalCountReq == cLevelApprovalCount) {
                    afe.Approval_Submission_Requirements_Meet__c = true;
                }
              
                else {
                 afe.Approval_Submission_Requirements_Meet__c = false;
              }  
                
            } //close > 1000000 checl
            
            if (afe.Approval_Status__c=='New'  && afe.USD_Total_Amount__c < 1000000) {
                
                afe.Approval_Submission_Requirements_Meet__c = false;
                
                Map<Id, Decimal> employeeLimitMap = new Map<Id,Decimal>();    
                for (Category_Master__c cm : [select Employee__c, Limit__c from Category_Master__c WHERE Employee__c != NULL AND Category__c = '006' LIMIT 50000]) {
                    employeeLimitMap.put(cm.Employee__c, cm.Limit__c);  
                }
                System.debug(' afe.Approver1__c ' + afe.Approver1__c);
                System.debug(' employeeLimitMap ' + employeeLimitMap);
                System.debug(' employeeLimitMap.size() ' + employeeLimitMap.size());
                if (afe.Approver1__c != null && employeeLimitMap.containsKey(afe.Approver1__c)) {
                    System.Debug('Right after first approver test');
                        Decimal ap1limit = employeeLimitMap.get(afe.Approver1__c);
                        System.Debug('ap1Limit is ' + ap1Limit);
                        if (ap1Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                    } 
                                System.debug(' afe.Approver2__c ' + afe.Approver2__c);
                System.debug(' employeeLimitMap ' + employeeLimitMap);
                System.debug(' employeeLimitMap.size() ' + employeeLimitMap.size());
                  if (afe.Approver2__c != null && employeeLimitMap.containsKey(afe.Approver2__c)) {
                        Decimal ap2limit = employeeLimitMap.get(afe.Approver2__c);
                        if (ap2Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                    } 
                
                
                if (afe.Approver3__c != null && employeeLimitMap.containsKey(afe.Approver3__c)) {
                        Decimal ap3limit = employeeLimitMap.get(afe.Approver3__c);
                        if (ap3Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                    }  
                
                
                if (afe.Approver4__c != null && employeeLimitMap.containsKey(afe.Approver4__c)) {
                        Decimal ap4limit = employeeLimitMap.get(afe.Approver4__c);
                        if (ap4Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                    } 
                
                
                if (afe.Approver5__c != null && employeeLimitMap.containsKey(afe.Approver5__c)) {
                        Decimal ap5limit = employeeLimitMap.get(afe.Approver5__c);
                        if (ap5Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver6__c != null && employeeLimitMap.containsKey(afe.Approver6__c)) {
                        Decimal ap6limit = employeeLimitMap.get(afe.Approver6__c);
                        if (ap6Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver7__c != null && employeeLimitMap.containsKey(afe.Approver7__c)) {
                        Decimal ap7limit = employeeLimitMap.get(afe.Approver7__c);
                        if (ap7Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver8__c != null && employeeLimitMap.containsKey(afe.Approver8__c)) {
                        Decimal ap8limit = employeeLimitMap.get(afe.Approver8__c);
                        if (ap8Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver9__c != null && employeeLimitMap.containsKey(afe.Approver9__c)) {
                        Decimal ap9limit = employeeLimitMap.get(afe.Approver9__c);
                        if (ap9Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                 if (afe.Approver10__c != null && employeeLimitMap.containsKey(afe.Approver10__c)) {
                        Decimal ap10limit = employeeLimitMap.get(afe.Approver10__c);
                        if (ap10Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver11__c != null && employeeLimitMap.containsKey(afe.Approver11__c)) {
                        Decimal ap11limit = employeeLimitMap.get(afe.Approver11__c);
                        if (ap11Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver12__c != null && employeeLimitMap.containsKey(afe.Approver12__c)) {
                        Decimal ap12limit = employeeLimitMap.get(afe.Approver12__c);
                        if (ap12Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver13__c != null && employeeLimitMap.containsKey(afe.Approver13__c)) {
                        Decimal ap13limit = employeeLimitMap.get(afe.Approver13__c);
                        if (ap13Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver14__c != null && employeeLimitMap.containsKey(afe.Approver14__c)) {
                        Decimal ap14limit = employeeLimitMap.get(afe.Approver14__c);
                        if (ap14Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                
                
                if (afe.Approver15__c != null && employeeLimitMap.containsKey(afe.Approver15__c)) {
                        Decimal ap15limit = employeeLimitMap.get(afe.Approver15__c);
                        if (ap15Limit >= afe.USD_Total_Amount__c) {
                            afe.Approval_Submission_Requirements_Meet__c = true;
                        }
                }
                 
                //else {
                //  afe.Approval_Submission_Requirements_Meet__c = false;
                //  }  
                        
            } // close > 1000000
        } //close trigger for  
}