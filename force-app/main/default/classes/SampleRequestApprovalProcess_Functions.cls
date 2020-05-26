global class SampleRequestApprovalProcess_Functions {

  public static List<Sample_Request_Approval_Process__c> approvalProcesses;

  public static Id lookup_ApprovalProcessId(String ApprovalProcess) {
    Id result = null;
    try {
        result = [SELECT Id FROM Sample_Request_Approval_Process__c 
                   WHERE Process_Name__c = :ApprovalProcess].Id;
    } catch(Exception e) {}
    return result;
  }

  public static String lookup_ApprovalProcessName(Id ApprovalProcessId) {
    String result = '';
    try {
        result = [SELECT Process_Name__c FROM Sample_Request_Approval_Process__c 
                   WHERE Id = :ApprovalProcessId].Process_Name__c;
    } catch(Exception e) {}
    return result;
  }

  WebService static String Sync_Users_on_ApprovalProcess(Id approvalProcessId,Boolean processGroupandQueue) {
    String result = '';
    List<String> results = new List<String>();
    String approvalProcessName = lookup_ApprovalProcessName(approvalProcessId);
    Sample_Request_Approval_Process__c approvalProcess = null;
    try { 
        approvalProcess = [SELECT Id, 
                                  Queues_Approver_Queue_Name__c, 
                                  Queues_Approver_Queue_2_Name__c, 
                                  Queues_Approver_Queue_3_Name__c, 
                                  Queues_Coordinator_Queue_Name__c, 
                                  Queues_Notification_Queue_Name__c,
                                  Sync_Errors__c,
                                  Sync_Errors_Occurred__c 
                             FROM Sample_Request_Approval_Process__c 
                            WHERE Id = :approvalProcessId];
    } catch(Exception e) {}
    if (approvalProcess == null) {return 'Approval Process not found';}
    Id approverQueueId = null;
    Id approverQueue2Id = null;
    Id approverQueue3Id = null;
    Id approverPublicGroupId = null;
    Id approverPublicGroup2Id = null;
    Id approverPublicGroup3Id = null;
    Id coordinatorQueueId = null;
    Id coordinatorPublicGroupId = null;
    Id notificationQueueId = null;
    Id notificationPublicGroupId = null;

    if (approvalProcess.Queues_Approver_Queue_Name__c != null)
      {
      approverQueueId = Public_Group_Functions.LookupQueueId(approvalProcess.Queues_Approver_Queue_Name__c);
      if (approverQueueId == null) {results.add('Approver Queue <' + approvalProcess.Queues_Approver_Queue_Name__c + '> not found.');}
      
      approverPublicGroupId = Public_Group_Functions.LookupPublicGroupId(approvalProcess.Queues_Approver_Queue_Name__c);
      if (approverPublicGroupId == null) {results.add('Approver Public Group <' + approvalProcess.Queues_Approver_Queue_Name__c + '> not found.');}
      }

    if (approvalProcess.Queues_Approver_Queue_2_Name__c != null)
      {
      approverQueue2Id = Public_Group_Functions.LookupQueueId(approvalProcess.Queues_Approver_Queue_2_Name__c);
      if (approverQueueId == null) {results.add('Approver Queue 2 <' + approvalProcess.Queues_Approver_Queue_2_Name__c + '> not found.');}
      
      approverPublicGroup2Id = Public_Group_Functions.LookupPublicGroupId(approvalProcess.Queues_Approver_Queue_2_Name__c);
      if (approverPublicGroupId == null) {results.add('Approver Public Group 2 <' + approvalProcess.Queues_Approver_Queue_2_Name__c + '> not found.');}
      }

    if (approvalProcess.Queues_Approver_Queue_3_Name__c != null)
      {
      approverQueue3Id = Public_Group_Functions.LookupQueueId(approvalProcess.Queues_Approver_Queue_3_Name__c);
      if (approverQueue3Id == null) {results.add('Approver Queue 3 <' + approvalProcess.Queues_Approver_Queue_3_Name__c + '> not found.');}
      
      approverPublicGroup3Id = Public_Group_Functions.LookupPublicGroupId(approvalProcess.Queues_Approver_Queue_3_Name__c);
      if (approverPublicGroup3Id == null) {results.add('Approver Public Group 3 <' + approvalProcess.Queues_Approver_Queue_3_Name__c + '> not found.');}
      }
    
    if (approvalProcess.Queues_Coordinator_Queue_Name__c != null)
      {
      coordinatorQueueId = Public_Group_Functions.LookupQueueId(approvalProcess.Queues_Coordinator_Queue_Name__c);
      if (coordinatorQueueId == null) {results.add('Coordinator Queue <' + approvalProcess.Queues_Coordinator_Queue_Name__c + '> not found.');}
      
      coordinatorPublicGroupId = Public_Group_Functions.LookupPublicGroupId(approvalProcess.Queues_Coordinator_Queue_Name__c);
      if (coordinatorPublicGroupId == null) {results.add('Coordinator Public Group <' + approvalProcess.Queues_Coordinator_Queue_Name__c + '> not found.');}
      }
    
    if (approvalProcess.Queues_Notification_Queue_Name__c != null)
      {
      notificationQueueId = Public_Group_Functions.LookupQueueId(approvalProcess.Queues_Notification_Queue_Name__c);
      if (notificationQueueId == null) {results.add('Notification Queue <' + approvalProcess.Queues_Notification_Queue_Name__c + '> not found.');}
      
      notificationPublicGroupId = Public_Group_Functions.LookupPublicGroupId(approvalProcess.Queues_Notification_Queue_Name__c);
      if (notificationPublicGroupId == null) {results.add('Notification Public Group <' + approvalProcess.Queues_Notification_Queue_Name__c + '> not found.');}
      }

    List<String> approvers = return_Approver_Queue_as_List(approvalProcessName);
    List<String> approvers2 = return_Approver_Queue_2_as_List(approvalProcessName);
    List<String> approvers3 = return_Approver_Queue_3_as_List(approvalProcessName);
    List<String> backupApprovers = return_Backup_Approver_Queue_as_List(approvalProcessName);
    List<String> coordinators = return_Coordinator_Queue_as_List(approvalProcessName);
    List<String> notifications = return_Notification_Queue_as_List(approvalProcessName);

    Id newUserId;
    Map<String,Id> newUserIds;

    List<Sample_Request_Approval_Process_User__c> currentUsers;
    List<Sample_Request_Approval_Process_User__c> newUsers = new List<Sample_Request_Approval_Process_User__c>();

    //Clear existing users
    try {currentUsers = [SELECT User__c FROM Sample_Request_Approval_Process_User__c WHERE Sample_Request_Approval_Process__c = :approvalProcessId];}
    catch (Exception e) {currentUsers = new List<Sample_Request_Approval_Process_User__c>();}

    if (processGroupandQueue == false)
        {
        if (currentUsers.size() > 0)
          {//delete currentUsers;
          }
        }
    
    newUserId = null;
    newUserIds = User_Functions.LookupActiveUsersbyFullName(approvers);
    for (String newUser:approvers)
      {
      newUserId = newUserIds.get(newUser);      
      if (newUserId != null)
        {newUsers.add(new Sample_Request_Approval_Process_User__c(Sample_Request_Approval_Process__c=approvalProcessId,
                                                                                             user__c=newUserId,
                                                                                            Queue__c='Approver',
                                                                                       Queue_Name__c=approvalProcess.Queues_Approver_Queue_Name__c,
                                                                                         Queue_Id__c=approverQueueId,
                                                                                  Public_Group_Id__c=approverPublicGroupId));}
      else
        {results.add('No User Found for Approver: <' + newUser + '>');}  
      }

    newUserId = null;
    newUserIds = User_Functions.LookupActiveUsersbyFullName(backupApprovers);
    for (String newUser:backupApprovers)
      {
      newUserId = newUserIds.get(newUser);      
      if (newUserId != null)
        {newUsers.add(new Sample_Request_Approval_Process_User__c(Sample_Request_Approval_Process__c=approvalProcessId,user__c=newUserId,Queue__c='Backup Approver',
                                                                                                 Queue_Name__c=approvalProcess.Queues_Approver_Queue_Name__c,
                                                                                         Queue_Id__c=approverQueueId,
                                                                                  Public_Group_Id__c=approverPublicGroupId));}
      else
        {results.add('No User Found for Backup Approver: <' + newUser + '>');}  
      }

    newUserId = null;
    newUserIds = User_Functions.LookupActiveUsersbyFullName(approvers2);
    for (String newUser:approvers2)
      {
      newUserId = newUserIds.get(newUser);      
      if (newUserId != null)
        {newUsers.add(new Sample_Request_Approval_Process_User__c(Sample_Request_Approval_Process__c=approvalProcessId,
                                                                                             user__c=newUserId,
                                                                                            Queue__c='Approver 2',
                                                                                       Queue_Name__c=approvalProcess.Queues_Approver_Queue_2_Name__c,
                                                                                         Queue_Id__c=approverQueue2Id,
                                                                                  Public_Group_Id__c=approverPublicGroup2Id));}
      else
        {results.add('No User Found for Approver 2: <' + newUser + '>');}  
      }

    newUserId = null;
    newUserIds = User_Functions.LookupActiveUsersbyFullName(approvers3);
    for (String newUser:approvers3)
      {
      newUserId = newUserIds.get(newUser);      
      if (newUserId != null)
        {newUsers.add(new Sample_Request_Approval_Process_User__c(Sample_Request_Approval_Process__c=approvalProcessId,
                                                                                             user__c=newUserId,
                                                                                            Queue__c='Approver 3',
                                                                                       Queue_Name__c=approvalProcess.Queues_Approver_Queue_3_Name__c,
                                                                                         Queue_Id__c=approverQueue3Id,
                                                                                  Public_Group_Id__c=approverPublicGroup3Id));}
      else
        {results.add('No User Found for Approver 3: <' + newUser + '>');}  
      }


    newUserId = null;
    newUserIds = User_Functions.LookupActiveUsersbyFullName(coordinators);
    for (String newUser:coordinators)
      {
      if ((newUser != null) && (newUser != ''))
        {
          newUserId = newUserIds.get(newUser);      
          if (newUserId != null)
            {newUsers.add(new Sample_Request_Approval_Process_User__c(Sample_Request_Approval_Process__c=approvalProcessId,user__c=newUserId,Queue__c='Coordinator',
                                                                                                     Queue_Name__c=approvalProcess.Queues_Coordinator_Queue_Name__c,
                                                                                             Queue_Id__c=coordinatorQueueId,
                                                                                      Public_Group_Id__c=coordinatorPublicGroupId));}
          else
            {results.add('No User Found for Coordinator: <' + newUser + '>');}  
        }
      }

    newUserId = null;
    newUserIds = User_Functions.LookupActiveUsersbyFullName(notifications);
    for (String newUser:notifications)
      {
      newUserId = newUserIds.get(newUser);      
      if (newUserId != null)
        {newUsers.add(new Sample_Request_Approval_Process_User__c(Sample_Request_Approval_Process__c=approvalProcessId,user__c=newUserId,Queue__c='Notification',
                                                                                                 Queue_Name__c=approvalProcess.Queues_Notification_Queue_Name__c,
                                                                                         Queue_Id__c=notificationQueueId,
                                                                                  Public_Group_Id__c=notificationPublicGroupId));}
      else
        {results.add('No User Found for Notification: <' + newUser + '>');}  
      }

    if (processGroupandQueue == false)
        {
        if (newUsers.size() > 0)
            {//insert newUsers;
            }
        }    
  
      
  
   //Sync the Public Groups, if no errors above



    if (processGroupandQueue == true)
      {

      if (results.size() > 0)
        {results.add('Public Groups will be synced with successful users, even though there were errors.');}

//      if (results.size() == 0)
//        {
        Map<String,Id> newApproverQueueMap;
        Map<String,Id> newApproverQueue2Map;
        Map<String,Id> newApproverQueue3Map;
        Map<String,Id> newCoordinatorQueueMap;
        Map<String,Id> newNotificationQueueMap;

        if ((approverQueueId == null) && (approverPublicGroupId == null) && (approvalProcess.Queues_Approver_Queue_Name__c != null)) 
          {
            newApproverQueueMap=Public_Group_Functions.CreateSampleRequestQueueGroup(approvalProcess.Queues_Approver_Queue_Name__c);
            approverQueueId = newApproverQueueMap.get('QueueId');
            approverPublicGroupId = newApproverQueueMap.get('GroupId');
          }
        if ((approverQueue2Id == null) && (approverPublicGroup2Id == null) && (approvalProcess.Queues_Approver_Queue_2_Name__c != null)) 
          {
            newApproverQueue2Map=Public_Group_Functions.CreateSampleRequestQueueGroup(approvalProcess.Queues_Approver_Queue_2_Name__c);
            approverQueue2Id = newApproverQueue2Map.get('QueueId');
            approverPublicGroup2Id = newApproverQueue2Map.get('GroupId');
          }
        if ((approverQueue3Id == null) && (approverPublicGroup3Id == null) && (approvalProcess.Queues_Approver_Queue_3_Name__c != null)) 
          {
            newApproverQueue3Map=Public_Group_Functions.CreateSampleRequestQueueGroup(approvalProcess.Queues_Approver_Queue_3_Name__c);
            approverQueue3Id = newApproverQueue3Map.get('QueueId');
            approverPublicGroup3Id = newApproverQueue3Map.get('GroupId');
          }
        if ((coordinatorQueueId == null) && (coordinatorPublicGroupId == null) && (approvalProcess.Queues_Coordinator_Queue_Name__c != null)) 
          {
            newCoordinatorQueueMap=Public_Group_Functions.CreateSampleRequestQueueGroup(approvalProcess.Queues_Coordinator_Queue_Name__c);
            coordinatorQueueId = newCoordinatorQueueMap.get('QueueId');
            coordinatorPublicGroupId = newCoordinatorQueueMap.get('GroupId');
          }
        if ((notificationQueueId == null) && (notificationPublicGroupId == null) && (approvalProcess.Queues_Notification_Queue_Name__c != null)) 
          {
            newNotificationQueueMap=Public_Group_Functions.CreateSampleRequestQueueGroup(approvalProcess.Queues_Notification_Queue_Name__c);
            notificationQueueId = newNotificationQueueMap.get('QueueId');
            notificationPublicGroupId = newNotificationQueueMap.get('GroupId');
          }
        
        
        //Add GroupMembers
        Id TestUserGroupId;
        TestUserGroupId = Public_Group_Functions.LookupPublicGroupId('Sample Request Admin Group');
    
        List<GroupMember> currentGroupMembers;
        List<GroupMember> newGroupMembers = new List<GroupMember>();
        
        //Erase Existing Members - Approver Public Group
        try {currentGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :approverPublicGroupId AND UserOrGroupId != :TestUserGroupId];}
        catch (Exception e) {currentGroupMembers = new List<GroupMember>();}
        if (currentGroupMembers.size() > 0)
          {delete currentGroupMembers;}

        //Erase Existing Members - Approver 2 Public Group
        try {currentGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :approverPublicGroup2Id AND UserOrGroupId != :TestUserGroupId];}
        catch (Exception e) {currentGroupMembers = new List<GroupMember>();}
        if (currentGroupMembers.size() > 0)
          {delete currentGroupMembers;}

        //Erase Existing Members - Approver 3 Public Group
        try {currentGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :approverPublicGroup3Id AND UserOrGroupId != :TestUserGroupId];}
        catch (Exception e) {currentGroupMembers = new List<GroupMember>();}
        if (currentGroupMembers.size() > 0)
          {delete currentGroupMembers;}

        //Erase Existing Members - Coordinator Public Group
        try {currentGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :coordinatorPublicGroupId AND UserOrGroupId != :TestUserGroupId];}
        catch (Exception e) {currentGroupMembers = new List<GroupMember>();}
        if (currentGroupMembers.size() > 0)
          {delete currentGroupMembers;}

        //Erase Existing Members - Notification Public Group
        try {currentGroupMembers = [SELECT UserOrGroupId FROM GroupMember WHERE GroupId = :notificationPublicGroupId AND UserOrGroupId != :TestUserGroupId];}
        catch (Exception e) {currentGroupMembers = new List<GroupMember>();}
        if (currentGroupMembers.size() > 0)
          {delete currentGroupMembers;}

    
        if (approvalProcess.Queues_Approver_Queue_Name__c != null)
          {
          for (String newUser:approvers)
            {
            newUserId = User_Functions.LookupActiveUserbyFullName(newUser);
            if (newUserId != null) {newGroupMembers.add(new GroupMember(GroupId=approverPublicGroupId,UserOrGroupId=newUserId));}
            }    
          }
    
        if (approvalProcess.Queues_Approver_Queue_Name__c != null)
          {
          for (String newUser:backupApprovers)
            {
            newUserId = User_Functions.LookupActiveUserbyFullName(newUser);
            if (newUserId != null) {newGroupMembers.add(new GroupMember(GroupId=approverPublicGroupId,UserOrGroupId=newUserId));}
            }    
          }        

        if (approvalProcess.Queues_Approver_Queue_2_Name__c != null)
          {
          for (String newUser:approvers2)
            {
            newUserId = User_Functions.LookupActiveUserbyFullName(newUser);
            if (newUserId != null) {newGroupMembers.add(new GroupMember(GroupId=approverPublicGroup2Id,UserOrGroupId=newUserId));}
            }    
          }

        if (approvalProcess.Queues_Approver_Queue_3_Name__c != null)
          {
          for (String newUser:approvers3)
            {
            newUserId = User_Functions.LookupActiveUserbyFullName(newUser);
            if (newUserId != null) {newGroupMembers.add(new GroupMember(GroupId=approverPublicGroup3Id,UserOrGroupId=newUserId));}
            }    
          }
    
        if (approvalProcess.Queues_Coordinator_Queue_Name__c != null)
          {
          for (String newUser:coordinators)
            {
            newUserId = User_Functions.LookupActiveUserbyFullName(newUser);
            if (newUserId != null) {newGroupMembers.add(new GroupMember(GroupId=coordinatorPublicGroupId,UserOrGroupId=newUserId));}
            }    
          }
    
        if (approvalProcess.Queues_Notification_Queue_Name__c != null)
          {
          for (String newUser:notifications)
            {
            newUserId = User_Functions.LookupActiveUserbyFullName(newUser);
            if (newUserId != null) {newGroupMembers.add(new GroupMember(GroupId=notificationPublicGroupId,UserOrGroupId=newUserId));}
            }    
          }
    
    
        if (newGroupMembers.size() > 0)
          {insert newGroupMembers;}
//        } else {results.add('Public Groups will not be synced due to previous errors.');}   
      }
  
      
   if (results.size() > 0)
    {
      for(String r:results) {result += (r + '\n');}
    }      
   
   if (results.size() > 0) {approvalProcess.Sync_Errors__c = 'Approval Process = ' + approvalProcessName + '\n' + result + '\n----------';approvalProcess.Sync_Errors_Occurred__c = true;}
   else {if (processGroupandQueue = true) {approvalProcess.Sync_Errors__c = 'Public Groups Updated Successfully!';approvalProcess.Sync_Errors_Occurred__c = false;}}
   approvalProcess.Last_Sync_Date__c = (System.now() + 0.00005787);

    if (processGroupandQueue == false)
        {
           update approvalProcess;
        }


      
   return result;   
  }

  public static String lookup_Approver_Queue(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Approver_Queue__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Approver_Queue__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }

  public static String lookup_Approver_Queue_2(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Approver_Queue_2__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Approver_Queue_2__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }

  public static String lookup_Approver_Queue_3(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Approver_Queue_3__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Approver_Queue_3__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }

  public static String lookup_Backup_Approver_Queue(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Backup_Approver_Queue__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Backup_Approver_Queue__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }

  public static String lookup_Coordinator_Queue(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Coordinator_Queue__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Coordinator_Queue__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }

  public static String lookup_Notification_Queue(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Notification_Queue__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Notification_Queue__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }




  public static String lookup_Approver_Queue_Name(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Approver_Queue_Name__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Approver_Queue_Name__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }


  public static String lookup_Approver_Queue_2_Name(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Approver_Queue_2_Name__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Approver_Queue_2_Name__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }

  public static String lookup_Approver_Queue_3_Name(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Queues_Approver_Queue_3_Name__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Queues_Approver_Queue_3_Name__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;
  }


  public static List<String> return_Approver_Queue_as_List(String approvalProcess) {
    List<String> results = null;
    try {results = String_Functions.trimAllStringsinListString(lookup_Approver_Queue(approvalProcess).split('\n',0));} catch (Exception e) {results = new List<String>();}
    return results;
  }

  public static List<String> return_Backup_Approver_Queue_as_List(String approvalProcess) {
    List<String> results = null;
    try {results = String_Functions.trimAllStringsinListString(lookup_Backup_Approver_Queue(approvalProcess).split('\n',0));} catch (Exception e) {results = new List<String>();}
    return results;
  }

  public static List<String> return_Approver_Queue_2_as_List(String approvalProcess) {
    List<String> results = null;
    try {results = String_Functions.trimAllStringsinListString(lookup_Approver_Queue_2(approvalProcess).split('\n',0));} catch (Exception e) {results = new List<String>();}
    return results;
  }


  public static List<String> return_Approver_Queue_3_as_List(String approvalProcess) {
    List<String> results = null;
    try {results = String_Functions.trimAllStringsinListString(lookup_Approver_Queue_3(approvalProcess).split('\n',0));} catch (Exception e) {results = new List<String>();}
    return results;
  }


  public static List<String> return_Coordinator_Queue_as_List(String approvalProcess) {
    List<String> results = null;
    try {results = String_Functions.trimAllStringsinListString(lookup_Coordinator_Queue(approvalProcess).split('\n',0));} catch (Exception e) {results = new List<String>();}
    return results;
  }

  public static List<String> return_Notification_Queue_as_List(String approvalProcess) {
    List<String> results = null;
    try {results = String_Functions.trimAllStringsinListString(lookup_Notification_Queue(approvalProcess).split('\n',0));} catch (Exception e) {results = new List<String>();}
    return results;
  }


  public static String lookup_Approval_Requirements(String ApprovalProcess) {

    String results = '';
    try {
            results = [SELECT Approval_Requirements__c 
                                 FROM Sample_Request_Approval_Process__c
                                WHERE Process_Name__c = :ApprovalProcess].Approval_Requirements__c;
        }                           
    catch (Exception e) 
        {
        //Most likely, no record was returned
        }
    
    return results;

  }

//**********************************************************************************************************************************
// lookup Approval Process functions
//**********************************************************************************************************************************
    public static String lookup_Approval_Process(sample_Request__c sampleRequest) {
    return lookup_Approval_Process(sampleRequest, new List<Sample_Material__c>());
  }
      
    //Lookup Approval Process based on Criteria
    public static String lookup_Approval_Process(sample_Request__c sampleRequest, List<sample_Material__c> sampleMaterials) {
    String result = '';

    if (sampleRequest.Id != null)
      {
      result = lookup_Approval_Process(sampleRequest.Id);
      }
    else
      {
      Sample_Request__c Temp_sampleRequest = sampleRequest.clone(false);
      List<Sample_Material__c> Temp_sampleMaterials = sampleMaterials.deepClone(false);
        
      Savepoint sp = Database.setSavepoint();
      temp_sampleRequest.Opportunity__c = null;
      temp_sampleRequest.Opportunity__r = null;
      insert Temp_sampleRequest;
      if (Temp_sampleMaterials.size() > 0)
        {
          for(sample_Material__c sampleMaterial:Temp_sampleMaterials) {sampleMaterial.sample_Request__c = Temp_sampleRequest.Id;}
          insert Temp_sampleMaterials;
          }
        System.debug('sampleRequestId='+sampleRequest.Id);
        System.debug('Temp_sampleRequestId='+Temp_sampleRequest.Id);
      result = lookup_Approval_Process(Temp_sampleRequest.Id);
        System.debug('result='+result);
      Database.rollback(sp);
      System.debug('sampleRequestId after Rollback:'+sampleRequest.Id);
      System.debug('Temp_sampleRequestId after Rollback:'+Temp_sampleRequest.Id);
      }
      
      return result;
    }

    public static String lookup_Approval_Process(Id sampleRequestId) {
       List<Id> sampleRequestIds = new List<Id>();
       sampleRequestIds.add(sampleRequestId);
       Map<Id,String> results = lookup_Approval_Process(sampleRequestIds);
       return results.get(sampleRequestId);
    }

  //*******************************************************
    //Lookup Approval Process based on Criteria
  //*******************************************************
    public static Map<Id,String> lookup_Approval_Process(List<Id> sampleRequestIds) {
        
        Integer DebugLogThreshhold = 5;
        
        Map<Id,String> approvalProcessesIdentified = new Map<Id,String>();
        
        //Create some Maps
        List<Sample_Request__c> sampleRequests;
        List<Sample_Material__c> sampleMaterials;
        List<Account> accounts;
    
    sampleRequests = Sample_Request_Functions.Select_All_Fields(sampleRequestIds);
    sampleMaterials = Sample_Material_Functions.Select_All_Fields_Based_on_Sample_Request_Ids(sampleRequestIds);
    System.debug(LoggingLevel.INFO, sampleMaterials);
    Map<Id, List<Sample_Material__c>> sampleMaterialsMap  = new Map<Id, List<Sample_Material__c>>();
    List<Sample_Material__c> sampleMaterials_hold;
    for(Sample_Request__c sampleRequest:sampleRequests)
      {
      sampleMaterials_hold = new List<Sample_Material__c>();
      for(Sample_Material__c sampleMaterial:sampleMaterials)
        {
        if (sampleMaterial.Sample_Request__c == sampleRequest.Id) 
          {sampleMaterials_hold.add(sampleMaterial);}
        }
        
      sampleMaterialsMap.put(sampleRequest.Id, sampleMaterials_hold);
      }
    
    List<Id> accountIds = new List<Id>();
    
    for(Sample_Request__c sampleRequest:sampleRequests)
      {
        if (sampleRequest.Account__c != null)
          {accountIds.add(sampleRequest.Account__c);}
      }
    
    accounts = Account_Functions.Select_Fields_Needed_for_Sample_Requests(accountIds);
    Map<Id, Account> accountMap = new Map<Id, Account>();
    Map<Id,String> accountTypeMap = new Map<Id,String>(); 
        List<String> SAP_Sales_Orgs = new List<String>();
        List<String> RecordTypeIds = new List<String>();
    for (Account acc:accounts) {
      accountMap.put(acc.Id,acc);
      SAP_Sales_Orgs.add(acc.SAP_Sales_Org__c);
      RecordTypeIds.add(acc.RecordTypeId);
      accountTypeMap.put(acc.Id,'Customer');
      if (acc.AccountNumber != null &&
          acc.AccountNumber.startsWith('P')) {
        accountTypeMap.put(acc.Id,'Prospect');
      }
    }
        
        Map<String,String> account_Region_Map = SAP_Sales_Org_Lookup_Functions.lookup_Region_from_Sales_Org(SAP_Sales_Orgs);
        //Map<Id,String> account_Type_Map = RecordType_Relationship_Functions.GetAccountType_Based_on_AccountRecordTypeId(RecordTypeIds);

    String account_Region = '';
    String account_Type = '';
    Account account;

    Boolean sampleRequest_AD_Compounds = false;
    Integer AD_Compounds_Count = 0;
    Boolean sampleRequest_Tectyl_Products = false;
    Integer Tectyl_Products_Count = 0;
    String sampleRequest_Product_Line = '';
    Decimal sampleRequest_Product_Line_Value = -1;
    Boolean requestForNanjingMaterials = false;
    String MaterialPlantRequest = '';
    

    for (Sample_Request__c sampleRequest:sampleRequests)
      {
      //Initialize the Map  
      approvalProcessesIdentified.put(sampleRequest.Id,'');
        
      //**********************************************************
      //Check for AD Compounds, Tectyl Products, and Product Line
      //**********************************************************
      sampleRequest_AD_Compounds = false;
      AD_Compounds_Count = 0;
      sampleRequest_Tectyl_Products = false;
      Tectyl_Products_Count = 0;
      sampleRequest_Product_Line = '';
      sampleRequest_Product_Line_Value = -1;
      requestForNanjingMaterials = false;
      MaterialPlantRequest = '';
      
      account = accountMap.get(sampleRequest.Account__c);
      account_Region = account_Region_Map.get(account.SAP_Sales_Org__c);
      //account_Type = account_Type_Map.get(account.RecordTypeId);
      account_Type = accountTypeMap.get(account.Id);
      
      for (Sample_Material__c sampleMaterial:sampleMaterialsMap.get(sampleRequest.Id))
        {
          //AD Compounding
          if(sampleMaterial.AD_Compound__c == true) {AD_Compounds_Count += 1;sampleRequest_AD_Compounds = true;}
          //Tectyl Products
          if(sampleMaterial.Tectyl_Product__c == true) {Tectyl_Products_Count += 1;sampleRequest_Tectyl_Products = true;}
          //Product Line
          if ((sampleMaterial.Product_Line__c != null) && 
              (sampleMaterial.Estimated_Sample_Value__c != null)) {
            if (sampleMaterial.Estimated_Sample_Value__c > sampleRequest_Product_Line_Value) {
              sampleRequest_Product_Line = sampleMaterial.Product_Line__c;
              sampleRequest_Product_Line_Value = sampleMaterial.Estimated_Sample_Value__c;
            }
          }
          
          //Nanjing Materials
          if (sampleMaterial.Nanjing_Material__c) {
            requestForNanjingMaterials = sampleMaterial.Nanjing_Material__c;
          }
          
          
            MaterialPlantRequest = sampleMaterial.material_Plant__c;
          
        }

      if (sampleRequestIds.size() <= DebugLogThreshhold)
        {
        System.Debug('account_Region = [' + account_Region + ']');
        System.Debug('account_RecordTypeName = [' + account.RecordType.Name + ']');
        System.Debug('account_Type = [' + account_Type + ']');
        System.Debug('SAP_Division_Desc__c = [' + account.SAP_Division_Desc__c + ']');
        System.Debug('SAP_Sales_District_Desc__c = [' + account.SAP_Sales_District_Desc__c + ']');
        System.Debug('SAP_Sales_Org__c = [' + account.SAP_Sales_Org__c + ']');
        System.Debug('SAP_Sales_Office_Desc__c = [' + account.SAP_Sales_Office_Desc__c + ']');
        System.Debug('SAP_Sales_Group_Desc__c = [' + account.SAP_Sales_Group_Desc__c + ']');
        System.Debug('SalesOffice__c = [' + account.SalesOffice__c + ']');
        System.Debug('SAP_Sales_Group_Desc__c = [' + account.SAP_Sales_Group_Desc__c + ']');
        System.Debug('sampleRequest_AD_Compounds = [' + sampleRequest_AD_Compounds + ']');
        System.Debug('sampleRequest_Tectyl_Products = [' + sampleRequest_Tectyl_Products + ']');
        System.Debug('sampleRequest.AST_Sample__c = [' + sampleRequest.AST_Sample__c + ']');
        System.Debug('sampleRequest.Product_Development__c = [' + sampleRequest.Product_Development__c + ']');
        System.Debug('sampleRequest_Product_Line = [' + sampleRequest_Product_Line + ']');
        System.Debug('sampleRequest_Product_Line_Value = [' + sampleRequest_Product_Line_Value + ']');
      }      
  
        if (approvalProcesses == null)
          {
            approvalProcesses = [SELECT Process_Number__c, Process_Name__c,
                                                          Cust_Criteria_RecordType_Name__c,
                                                          Cust_Criteria_SAP_Division_Desc__c,
                                                          Cust_Criteria_SAP_Sales_District_Desc__c,
                                                          Cust_Criteria_SAP_Sales_Office_Desc__c,
                                                          Cust_Criteria_SAP_Sales_Group_Desc__c,
                                                          Cust_Criteria_SAP_Sales_Org_Region__c,
                                                          Cust_Criteria_SAP_Customer_Group__c,
                                                          Cust_Criteria_SAP_Customer_Group_1__c,
                                                          Cust_Criteria_SAP_Customer_Group_2__c,
                                                          Cust_Criteria_SAP_Customer_Group_3__c,
                                                          Cust_Criteria_SAP_Customer_Group_4__c,
                                                          Cust_Criteria_SAP_Customer_Group_5__c,
                                                          Prospect_Criteria_RecordType_Name__c,
                                                          Prospect_Criteria_SalesOffice__c,
                                                          Prospect_Criteria_SAP_Sales_District_Des__c,
                                                          Prospect_Criteria_SAP_Sales_Office_Desc__c,
                                                          Prospect_Criteria_SAP_Sales_Group_Desc__c,
                                                          Prospect_Criteria_SAP_Sales_Org_Region__c,
                                                          Prospect_Criteria_SAP_Customer_Group__c,
                                                          Prospect_Criteria_SAP_Customer_Group_1__c,
                                                          Prospect_Criteria_SAP_Customer_Group_2__c,
                                                          Prospect_Criteria_SAP_Customer_Group_3__c,
                                                          Prospect_Criteria_SAP_Customer_Group_4__c,
                                                          Prospect_Criteria_SAP_Customer_Group_5__c,
                                                          Sample_Criteria_AD_Compounding__c,
                                                          Sample_Criteria_AST_Sample__c,
                                                          Sample_Criteria_Product_Development__c,
                                                          Sample_Criteria_Tectyl_Product__c,
                                                          Sample_Criteria_Product_Line__c,
                                                          Sample_Criteria_Oak_Creek__c,
                                                          Sample_Criteria_Aqualon_Hazardous_Matl__c,
                                                          Sample_Criteria_Aquarius_Sample__c,
                                                          Sample_Criteria_Nanjing_Material__c,
                                                          Sample_Criteria_Material_Plant__c,
                                                          Active__c, Name
                                                     FROM Sample_Request_Approval_Process__c
                                                    WHERE Active__c = true
                                                   ORDER BY Process_Number__c];
        }                                                  
  
      Boolean matchFound = false;

      //Customer Match Fields
      Boolean match_Cust_RecordType_Name = false;
      Boolean match_Cust_SAP_Division_Desc = false;
      Boolean match_Cust_SAP_Sales_District_Desc = false;
      Boolean match_Cust_SAP_Sales_Office_Desc = false;
      Boolean match_Cust_SAP_Sales_Group_Desc = false;
      Boolean match_Cust_SAP_Sales_Org_Region = false;
      Boolean match_Cust_SAP_Customer_Group = false;
      Boolean match_Cust_SAP_Customer_Group_1 = false;
      Boolean match_Cust_SAP_Customer_Group_2 = false;
      Boolean match_Cust_SAP_Customer_Group_3 = false;
      Boolean match_Cust_SAP_Customer_Group_4 = false;
      Boolean match_Cust_SAP_Customer_Group_5 = false;
      
      //Prospect Match Fields
      Boolean match_Prospect_RecordType_Name = false;
      Boolean match_Prospect_SalesOffice = false;
      Boolean match_Prospect_SAP_Sales_District_Desc = false;
      Boolean match_Prospect_SAP_Sales_Office_Desc = false;
      Boolean match_Prospect_SAP_Sales_Group_Desc = false;
      Boolean match_Prospect_SAP_Sales_Org_Region = false;
      Boolean match_Prospect_SAP_Customer_Group = false;
      Boolean match_Prospect_SAP_Customer_Group_1 = false;
      Boolean match_Prospect_SAP_Customer_Group_2 = false;
      Boolean match_Prospect_SAP_Customer_Group_3 = false;
      Boolean match_Prospect_SAP_Customer_Group_4 = false;
      Boolean match_Prospect_SAP_Customer_Group_5 = false;

      //Sample Match Fields
      Boolean match_Sample_AD_Compounding = false;
      Boolean match_Sample_AST_Sample = false;
      Boolean match_Sample_Product_Development = false;
      Boolean match_Sample_Tectyl_Product = false; 
      Boolean match_Sample_Product_Line = false;
      Boolean match_Sample_Oak_Creek = false;
      Boolean match_Sample_Aqualon_Hazardous = false;
      Boolean match_Sample_Aquarius = false;
      Boolean match_Sample_Nanjing_Material = false;
      Boolean match_Sample_Material_Plant = false;

      //Specific Customer Criteria      
      List<String> Cust_RecordType_Names = new List<String>();
      List<String> Cust_SAP_Division_Descs = new List<String>();
      List<String> Cust_SAP_Sales_District_Descs = new List<String>();
      List<String> Cust_SAP_Sales_Office_Descs = new List<String>();
      List<String> Cust_SAP_Sales_Group_Descs = new List<String>();
      List<String> Cust_SAP_Sales_Org_Regions = new List<String>();
      List<String> Cust_SAP_Customer_Groups = new List<String>();
      List<String> Cust_SAP_Customer_Groups_1 = new List<String>();
      List<String> Cust_SAP_Customer_Groups_2 = new List<String>();
      List<String> Cust_SAP_Customer_Groups_3 = new List<String>();
      List<String> Cust_SAP_Customer_Groups_4 = new List<String>();
      List<String> Cust_SAP_Customer_Groups_5 = new List<String>();
      
      //Specific Prospect Criteria
      List<String> Prospect_RecordType_Names = new List<String>();
      List<String> Prospect_SalesOffices = new List<String>();
      List<String> Prospect_SAP_Sales_District_Descs = new List<String>();
      List<String> Prospect_SAP_Sales_Office_Descs = new List<String>();
      List<String> Prospect_SAP_Sales_Group_Descs = new List<String>();
      List<String> Prospect_SAP_Sales_Org_Regions = new List<String>();
      List<String> Prospect_SAP_Customer_Groups = new List<String>();
      List<String> Prospect_SAP_Customer_Groups_1 = new List<String>();
      List<String> Prospect_SAP_Customer_Groups_2 = new List<String>();
      List<String> Prospect_SAP_Customer_Groups_3 = new List<String>();
      List<String> Prospect_SAP_Customer_Groups_4 = new List<String>();
      List<String> Prospect_SAP_Customer_Groups_5 = new List<String>();

      //Sample Criteria      
      List<String> Sample_Product_Lines = new List<String>();
        
      for (Sample_Request_Approval_Process__c approvalProcess : approvalProcesses)
        {
            System.debug(LoggingLevel.INFO, 'Process Number: ' + approvalProcess.Process_Number__c + ' - ' + approvalProcess.Process_Name__c);
            
          if (matchFound == false)
            {

            Cust_RecordType_Names             = approvalProcess.Cust_Criteria_RecordType_Name__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_RecordType_Name__c.split('\n',0));
                                    
            Cust_SAP_Division_Descs           = approvalProcess.Cust_Criteria_SAP_Division_Desc__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Division_Desc__c.split('\n',0));
                                      
            Cust_SAP_Sales_District_Descs     = approvalProcess.Cust_Criteria_SAP_Sales_District_Desc__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Sales_District_Desc__c.split('\n',0));
                                            
            Cust_SAP_Sales_Office_Descs       = approvalProcess.Cust_Criteria_SAP_Sales_Office_Desc__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Sales_Office_Desc__c.split('\n',0));
                                          
            Cust_SAP_Sales_Group_Descs        = approvalProcess.Cust_Criteria_SAP_Sales_Group_Desc__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Sales_Group_Desc__c.split('\n',0));
                                         
            Cust_SAP_Sales_Org_Regions        = approvalProcess.Cust_Criteria_SAP_Sales_Org_Region__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Sales_Org_Region__c.split('\n',0));

            Cust_SAP_Customer_Groups          = approvalProcess.Cust_Criteria_SAP_Customer_Group__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Customer_Group__c.split('\n',0));

            Cust_SAP_Customer_Groups_1        = approvalProcess.Cust_Criteria_SAP_Customer_Group_1__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Customer_Group_1__c.split('\n',0));

            Cust_SAP_Customer_Groups_2        = approvalProcess.Cust_Criteria_SAP_Customer_Group_2__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Customer_Group_2__c.split('\n',0));

            Cust_SAP_Customer_Groups_3        = approvalProcess.Cust_Criteria_SAP_Customer_Group_3__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Customer_Group_3__c.split('\n',0));

            Cust_SAP_Customer_Groups_4        = approvalProcess.Cust_Criteria_SAP_Customer_Group_4__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Customer_Group_4__c.split('\n',0));

            Cust_SAP_Customer_Groups_5        = approvalProcess.Cust_Criteria_SAP_Customer_Group_5__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Cust_Criteria_SAP_Customer_Group_5__c.split('\n',0));


            Prospect_RecordType_Names         = approvalProcess.Prospect_Criteria_RecordType_Name__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_RecordType_Name__c.split('\n',0));

            Prospect_SalesOffices             = approvalProcess.Prospect_Criteria_SalesOffice__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SalesOffice__c.split('\n',0));

            Prospect_SAP_Sales_District_Descs = approvalProcess.Prospect_Criteria_SAP_Sales_District_Des__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Sales_District_Des__c.split('\n',0));

            Prospect_SAP_Sales_Office_Descs   = approvalProcess.Prospect_Criteria_SAP_Sales_Office_Desc__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Sales_Office_Desc__c.split('\n',0));

            Prospect_SAP_Sales_Group_Descs    = approvalProcess.Prospect_Criteria_SAP_Sales_Group_Desc__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Sales_Group_Desc__c.split('\n',0));

            Prospect_SAP_Sales_Org_Regions    = approvalProcess.Prospect_Criteria_SAP_Sales_Org_Region__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Sales_Org_Region__c.split('\n',0));

            Prospect_SAP_Customer_Groups      = approvalProcess.Prospect_Criteria_SAP_Customer_Group__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Customer_Group__c.split('\n',0));

            Prospect_SAP_Customer_Groups_1    = approvalProcess.Prospect_Criteria_SAP_Customer_Group_1__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Customer_Group_1__c.split('\n',0));

            Prospect_SAP_Customer_Groups_2    = approvalProcess.Prospect_Criteria_SAP_Customer_Group_2__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Customer_Group_2__c.split('\n',0));

            Prospect_SAP_Customer_Groups_3    = approvalProcess.Prospect_Criteria_SAP_Customer_Group_3__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Customer_Group_3__c.split('\n',0));

            Prospect_SAP_Customer_Groups_4    = approvalProcess.Prospect_Criteria_SAP_Customer_Group_4__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Customer_Group_4__c.split('\n',0));

            Prospect_SAP_Customer_Groups_5    = approvalProcess.Prospect_Criteria_SAP_Customer_Group_5__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Prospect_Criteria_SAP_Customer_Group_5__c.split('\n',0));

            Sample_Product_Lines              = approvalProcess.Sample_Criteria_Product_Line__c == null ? new List<String>() : String_Functions.trimAllStringsinListString(
                                                approvalProcess.Sample_Criteria_Product_Line__c.split('\n',0));

            //Initialize Customer Match fields
            match_Cust_RecordType_Name = false;
            match_Cust_SAP_Division_Desc = false;
            match_Cust_SAP_Sales_District_Desc = false;
            match_Cust_SAP_Sales_Office_Desc = false;
            match_Cust_SAP_Sales_Group_Desc = false;
            match_Cust_SAP_Sales_Org_Region = false;
            match_Cust_SAP_Customer_Group = false;
            match_Cust_SAP_Customer_Group_1 = false;
            match_Cust_SAP_Customer_Group_2 = false;
            match_Cust_SAP_Customer_Group_3 = false;
            match_Cust_SAP_Customer_Group_4 = false;
            match_Cust_SAP_Customer_Group_5 = false;

            //Initialize Prospect Match fields
            match_Prospect_RecordType_Name = false;
            match_Prospect_SalesOffice = false;
            match_Prospect_SAP_Sales_District_Desc = false;
            match_Prospect_SAP_Sales_Office_Desc = false;
            match_Prospect_SAP_Sales_Group_Desc = false;
            match_Prospect_SAP_Sales_Org_Region = false;
            match_Prospect_SAP_Customer_Group = false;
            match_Prospect_SAP_Customer_Group_1 = false;
            match_Prospect_SAP_Customer_Group_2 = false;
            match_Prospect_SAP_Customer_Group_3 = false;
            match_Prospect_SAP_Customer_Group_4 = false;
            match_Prospect_SAP_Customer_Group_5 = false;
            
            //Initialize Sample Match fields
            match_Sample_AD_Compounding = false;
            match_Sample_AST_Sample = false;
            match_Sample_Product_Development = false;
            match_Sample_Tectyl_Product = false;
            match_Sample_Product_Line = false;
            match_Sample_Oak_Creek = false;
            match_Sample_Aqualon_Hazardous = false;
            match_Sample_Aquarius = false;
            match_Sample_Nanjing_Material = false;
      
            //Check for Customer Matches
                if (account_Type == 'Customer')
                    {
              if ((approvalProcess.Cust_Criteria_RecordType_Name__c == null) || (approvalProcess.Cust_Criteria_RecordType_Name__c == 'N/A')) {match_Cust_RecordType_Name = true;}
              else {for (String itemValue : Cust_RecordType_Names) {if(itemValue == account.RecordType.Name) {match_Cust_RecordType_Name = true;}}}
                
              if ((approvalProcess.Cust_Criteria_SAP_Division_Desc__c == null) || (approvalProcess.Cust_Criteria_SAP_Division_Desc__c == 'N/A')) {match_Cust_SAP_Division_Desc = true;}
              else {for (String itemValue : Cust_SAP_Division_Descs) {if(itemValue == account.SAP_Division_Desc__c) {match_Cust_SAP_Division_Desc = true;}}}
      
              if ((approvalProcess.Cust_Criteria_SAP_Sales_District_Desc__c == null) || (approvalProcess.Cust_Criteria_SAP_Sales_District_Desc__c == 'N/A')) {match_Cust_SAP_Sales_District_Desc = true;}
              else {for (String itemValue : Cust_SAP_Sales_District_Descs) {if(itemValue == account.SAP_Sales_District_Desc__c) {match_Cust_SAP_Sales_District_Desc = true;}}}
      
              if ((approvalProcess.Cust_Criteria_SAP_Sales_Office_Desc__c == null) || (approvalProcess.Cust_Criteria_SAP_Sales_Office_Desc__c == 'N/A')) {match_Cust_SAP_Sales_Office_Desc = true;}
              else {for (String itemValue : Cust_SAP_Sales_Office_Descs) {if(itemValue == account.SAP_Sales_Office_Desc__c) {match_Cust_SAP_Sales_Office_Desc = true;}}}
    //System.debug('itemValue=[' + itemValue + '] account.SAP_Sales_Office_Desc__c = [' + account.SAP_Sales_Office_Desc__c + ']')
    //System.debug('match=' + match_Cust_SAP_Sales_Office_Desc);

              if ((approvalProcess.Cust_Criteria_SAP_Sales_Group_Desc__c == null) || (approvalProcess.Cust_Criteria_SAP_Sales_Group_Desc__c == 'N/A')) {match_Cust_SAP_Sales_Group_Desc = true;}
              else {for (String itemValue : Cust_SAP_Sales_Group_Descs) {if(itemValue == account.SAP_Sales_Group_Desc__c) {match_Cust_SAP_Sales_Group_Desc = true;}}}

              if ((approvalProcess.Cust_Criteria_SAP_Sales_Org_Region__c == null) || (approvalProcess.Cust_Criteria_SAP_Sales_Org_Region__c == 'N/A')) {match_Cust_SAP_Sales_Org_Region = true;}
              else {for (String itemValue : Cust_SAP_Sales_Org_Regions) {if(itemValue == account_Region) {match_Cust_SAP_Sales_Org_Region = true;}}}

              if ((approvalProcess.Cust_Criteria_SAP_Customer_Group__c == null) || (approvalProcess.Cust_Criteria_SAP_Customer_Group__c == 'N/A')) {match_Cust_SAP_Customer_Group = true;}
              else {for (String itemValue : Cust_SAP_Customer_Groups) {if(itemValue == account.SAP_Customer_Group__c) {match_Cust_SAP_Customer_Group = true;}}}

              if ((approvalProcess.Cust_Criteria_SAP_Customer_Group_1__c == null) || (approvalProcess.Cust_Criteria_SAP_Customer_Group_1__c == 'N/A')) {match_Cust_SAP_Customer_Group_1 = true;}
              else {for (String itemValue : Cust_SAP_Customer_Groups_1) {if(itemValue == account.SAP_Customer_Group_1__c) {match_Cust_SAP_Customer_Group_1 = true;}}}

              if ((approvalProcess.Cust_Criteria_SAP_Customer_Group_2__c == null) || (approvalProcess.Cust_Criteria_SAP_Customer_Group_2__c == 'N/A')) {match_Cust_SAP_Customer_Group_2 = true;}
              else {for (String itemValue : Cust_SAP_Customer_Groups_2) {if(itemValue == account.SAP_Customer_Group_2__c) {match_Cust_SAP_Customer_Group_2 = true;}}}

              if ((approvalProcess.Cust_Criteria_SAP_Customer_Group_3__c == null) || (approvalProcess.Cust_Criteria_SAP_Customer_Group_3__c == 'N/A')) {match_Cust_SAP_Customer_Group_3 = true;}
              else {for (String itemValue : Cust_SAP_Customer_Groups_3) {if(itemValue == account.SAP_Customer_Group_3__c) {match_Cust_SAP_Customer_Group_3 = true;}}}

              if ((approvalProcess.Cust_Criteria_SAP_Customer_Group_4__c == null) || (approvalProcess.Cust_Criteria_SAP_Customer_Group_4__c == 'N/A')) {match_Cust_SAP_Customer_Group_4 = true;}
              else {for (String itemValue : Cust_SAP_Customer_Groups_4) {if(itemValue == account.SAP_Customer_Group_4__c) {match_Cust_SAP_Customer_Group_4 = true;}}}

              if ((approvalProcess.Cust_Criteria_SAP_Customer_Group_5__c == null) || (approvalProcess.Cust_Criteria_SAP_Customer_Group_5__c == 'N/A')) {match_Cust_SAP_Customer_Group_5 = true;}
              else {for (String itemValue : Cust_SAP_Customer_Groups_5) {if(itemValue == account.SAP_Customer_Group_5__c) {match_Cust_SAP_Customer_Group_5 = true;}}}

              match_Prospect_RecordType_Name = true;
              match_Prospect_SalesOffice = true;
              match_Prospect_SAP_Sales_District_Desc = true;
              match_Prospect_SAP_Sales_Office_Desc = true;
              match_Prospect_SAP_Sales_Group_Desc = true;
              match_Prospect_SAP_Sales_Org_Region = true;
              match_Prospect_SAP_Customer_Group = true;
              match_Prospect_SAP_Customer_Group_1 = true;
              match_Prospect_SAP_Customer_Group_2 = true;
              match_Prospect_SAP_Customer_Group_3 = true;
              match_Prospect_SAP_Customer_Group_4 = true;
              match_Prospect_SAP_Customer_Group_5 = true;
                  }

            //Check for Prospect Matches
                if (account_Type == 'Prospect')
                    {

                System.debug('approvalProcess.Prospect_Criteria_RecordType_Name__c = '+approvalProcess.Prospect_Criteria_RecordType_Name__c);
                System.debug('Prospect_RecordType_Names = '+Prospect_RecordType_Names);
                System.debug('approvalProcess.Prospect_Criteria_SalesOffice__c = '+approvalProcess.Prospect_Criteria_SalesOffice__c);
                System.debug('Prospect_SalesOffices = '+Prospect_SalesOffices);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Sales_District_Des__c = '+approvalProcess.Prospect_Criteria_SAP_Sales_District_Des__c);
                System.debug('Prospect_SAP_Sales_District_Descs = '+Prospect_SAP_Sales_District_Descs);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Sales_Office_Desc__c = '+approvalProcess.Prospect_Criteria_SAP_Sales_Office_Desc__c);
                System.debug('Prospect_SAP_Sales_Office_Descs = '+Prospect_SAP_Sales_Office_Descs);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Sales_Group_Desc__c = '+approvalProcess.Prospect_Criteria_SAP_Sales_Group_Desc__c);
                System.debug('Prospect_SAP_Sales_Group_Descs = '+Prospect_SAP_Sales_Group_Descs);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Sales_Org_Region__c = '+approvalProcess.Prospect_Criteria_SAP_Sales_Org_Region__c);
                System.debug('Prospect_SAP_Sales_Org_Regions = '+Prospect_SAP_Sales_Org_Regions);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Customer_Group__c = '+approvalProcess.Prospect_Criteria_SAP_Customer_Group__c);
                System.debug('Prospect_SAP_Customer_Groups = '+Prospect_SAP_Customer_Groups);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Customer_Group_1__c = '+approvalProcess.Prospect_Criteria_SAP_Customer_Group_1__c);
                System.debug('Prospect_SAP_Customer_Groups_1 = '+Prospect_SAP_Customer_Groups_1);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Customer_Group_2__c = '+approvalProcess.Prospect_Criteria_SAP_Customer_Group_2__c);
                System.debug('Prospect_SAP_Customer_Groups_2 = '+Prospect_SAP_Customer_Groups_2);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Customer_Group_3__c = '+approvalProcess.Prospect_Criteria_SAP_Customer_Group_3__c);
                System.debug('Prospect_SAP_Customer_Groups_3 = '+Prospect_SAP_Customer_Groups_3);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Customer_Group_4__c = '+approvalProcess.Prospect_Criteria_SAP_Customer_Group_4__c);
                System.debug('Prospect_SAP_Customer_Groups_4 = '+Prospect_SAP_Customer_Groups_4);
                System.debug('approvalProcess.Prospect_Criteria_SAP_Customer_Group_5__c = '+approvalProcess.Prospect_Criteria_SAP_Customer_Group_5__c);
                System.debug('Prospect_SAP_Customer_Groups_5 = '+Prospect_SAP_Customer_Groups_5);

              if ((approvalProcess.Prospect_Criteria_RecordType_Name__c == null) || (approvalProcess.Prospect_Criteria_RecordType_Name__c == 'N/A')) {match_Prospect_RecordType_Name = true;}
              else {for (String itemValue : Prospect_RecordType_Names) {if(itemValue == account.RecordType.Name) {match_Prospect_RecordType_Name = true;}}}
                
              if ((approvalProcess.Prospect_Criteria_SalesOffice__c == null) || (approvalProcess.Prospect_Criteria_SalesOffice__c == 'N/A')) {match_Prospect_SalesOffice = true;}
              else {for (String itemValue : Prospect_SalesOffices) {if(itemValue == account.SalesOffice__c) {match_Prospect_SalesOffice = true;}}}
      
              if ((approvalProcess.Prospect_Criteria_SAP_Sales_District_Des__c == null) || (approvalProcess.Prospect_Criteria_SAP_Sales_District_Des__c == 'N/A')) {match_Prospect_SAP_Sales_District_Desc = true;}
              else {for (String itemValue : Prospect_SAP_Sales_District_Descs) {if(itemValue == account.SAP_Sales_District_Desc__c) {match_Prospect_SAP_Sales_District_Desc = true;}}}
      
              if ((approvalProcess.Prospect_Criteria_SAP_Sales_Office_Desc__c == null) || (approvalProcess.Prospect_Criteria_SAP_Sales_Office_Desc__c == 'N/A')) {match_Prospect_SAP_Sales_Office_Desc = true;}
              else {for (String itemValue : Prospect_SAP_Sales_Office_Descs) {if(itemValue == account.SAP_Sales_Office_Desc__c) {match_Prospect_SAP_Sales_Office_Desc = true;}}}
    
              if ((approvalProcess.Prospect_Criteria_SAP_Sales_Group_Desc__c == null) || (approvalProcess.Prospect_Criteria_SAP_Sales_Group_Desc__c == 'N/A')) {match_Prospect_SAP_Sales_Group_Desc = true;}
              else {for (String itemValue : Prospect_SAP_Sales_Group_Descs) {if(itemValue == account.SAP_Sales_Group_Desc__c) {match_Prospect_SAP_Sales_Group_Desc = true;}}}
    
              if ((approvalProcess.Prospect_Criteria_SAP_Sales_Org_Region__c == null) || (approvalProcess.Prospect_Criteria_SAP_Sales_Org_Region__c == 'N/A')) {match_Prospect_SAP_Sales_Org_Region = true;}
              else {for (String itemValue : Prospect_SAP_Sales_Org_Regions) {if(itemValue == account_Region) {match_Prospect_SAP_Sales_Org_Region = true;}}}

              if ((approvalProcess.Prospect_Criteria_SAP_Customer_Group__c == null) || (approvalProcess.Prospect_Criteria_SAP_Customer_Group__c == 'N/A')) {match_Prospect_SAP_Customer_Group = true;}
              else {for (String itemValue : Prospect_SAP_Customer_Groups) {if(itemValue == account.SAP_Customer_Group__c) {match_Prospect_SAP_Customer_Group = true;}}}

              if ((approvalProcess.Prospect_Criteria_SAP_Customer_Group_1__c == null) || (approvalProcess.Prospect_Criteria_SAP_Customer_Group_1__c == 'N/A')) {match_Prospect_SAP_Customer_Group_1 = true;}
              else {for (String itemValue : Prospect_SAP_Customer_Groups_1) {if(itemValue == account.SAP_Customer_Group_1__c) {match_Prospect_SAP_Customer_Group_1 = true;}}}

              if ((approvalProcess.Prospect_Criteria_SAP_Customer_Group_2__c == null) || (approvalProcess.Prospect_Criteria_SAP_Customer_Group_2__c == 'N/A')) {match_Prospect_SAP_Customer_Group_2 = true;}
              else {for (String itemValue : Prospect_SAP_Customer_Groups_2) {if(itemValue == account.SAP_Customer_Group_2__c) {match_Prospect_SAP_Customer_Group_2 = true;}}}

              if ((approvalProcess.Prospect_Criteria_SAP_Customer_Group_3__c == null) || (approvalProcess.Prospect_Criteria_SAP_Customer_Group_3__c == 'N/A')) {match_Prospect_SAP_Customer_Group_3 = true;}
              else {for (String itemValue : Prospect_SAP_Customer_Groups_3) {if(itemValue == account.SAP_Customer_Group_3__c) {match_Prospect_SAP_Customer_Group_3 = true;}}}

              if ((approvalProcess.Prospect_Criteria_SAP_Customer_Group_4__c == null) || (approvalProcess.Prospect_Criteria_SAP_Customer_Group_4__c == 'N/A')) {match_Prospect_SAP_Customer_Group_4 = true;}
              else {for (String itemValue : Prospect_SAP_Customer_Groups_4) {if(itemValue == account.SAP_Customer_Group_4__c) {match_Prospect_SAP_Customer_Group_4 = true;}}}

              if ((approvalProcess.Prospect_Criteria_SAP_Customer_Group_5__c == null) || (approvalProcess.Prospect_Criteria_SAP_Customer_Group_5__c == 'N/A')) {match_Prospect_SAP_Customer_Group_5 = true;}
              else {for (String itemValue : Prospect_SAP_Customer_Groups_5) {if(itemValue == account.SAP_Customer_Group_5__c) {match_Prospect_SAP_Customer_Group_5 = true;}}}

              match_Cust_RecordType_Name = true;
              match_Cust_SAP_Division_Desc = true;
              match_Cust_SAP_Sales_District_Desc = true;
              match_Cust_SAP_Sales_Office_Desc = true;
              match_Cust_SAP_Sales_Group_Desc = true;
              match_Cust_SAP_Sales_Org_Region = true;
              match_Cust_SAP_Customer_Group = true;
              match_Cust_SAP_Customer_Group_1 = true;
              match_Cust_SAP_Customer_Group_2 = true;
              match_Cust_SAP_Customer_Group_3 = true;
              match_Cust_SAP_Customer_Group_4 = true;
              match_Cust_SAP_Customer_Group_5 = true;
                  }
                
            //Perform General Sample Match Field Checks
            if (
                ((sampleRequest_AD_Compounds == true) && (approvalProcess.Sample_Criteria_AD_Compounding__c == 'Yes')) ||
                ((sampleRequest_AD_Compounds == false) && (approvalProcess.Sample_Criteria_AD_Compounding__c == 'No')) ||
                (approvalProcess.Sample_Criteria_AD_Compounding__c == 'N/A')
               )
              {match_Sample_AD_Compounding = true;}

            if (
                ((sampleRequest.AST_Sample__c == true) && (approvalProcess.Sample_Criteria_AST_Sample__c == 'Yes')) ||
                ((sampleRequest.AST_Sample__c == false) && (approvalProcess.Sample_Criteria_AST_Sample__c == 'No')) ||
                (approvalProcess.Sample_Criteria_AST_Sample__c == 'N/A')
               )
              {match_Sample_AST_Sample = true;}

            if (
                ((sampleRequest.Product_Development__c == true) && (approvalProcess.Sample_Criteria_Product_Development__c == 'Yes')) ||
                ((sampleRequest.Product_Development__c == false) && (approvalProcess.Sample_Criteria_Product_Development__c == 'No')) ||
                (approvalProcess.Sample_Criteria_Product_Development__c == 'N/A')
               )
              {match_Sample_Product_Development = true;}

            if (
                ((sampleRequest_Tectyl_Products == true) && (approvalProcess.Sample_Criteria_Tectyl_Product__c == 'Yes')) ||
                ((sampleRequest_Tectyl_Products == false) && (approvalProcess.Sample_Criteria_Tectyl_Product__c == 'No')) ||
                (approvalProcess.Sample_Criteria_Tectyl_Product__c == 'N/A')
               )
              {match_Sample_Tectyl_Product = true;}

            if ((approvalProcess.Sample_Criteria_Product_Line__c == null) || (approvalProcess.Sample_Criteria_Product_Line__c == 'N/A'))
              {match_Sample_Product_Line = true;}
            else
              {for (String itemValue : Sample_Product_Lines) {if(itemValue == sampleRequest_Product_Line) {match_Sample_Product_Line = true;}}}

            if (
                ((sampleRequest.Oak_Creek__c == true) && (approvalProcess.Sample_Criteria_Oak_Creek__c == 'Yes')) ||
                ((sampleRequest.Oak_Creek__c == false) && (approvalProcess.Sample_Criteria_Oak_Creek__c == 'No')) ||
                (approvalProcess.Sample_Criteria_Oak_Creek__c == 'N/A')
               )
              {match_Sample_Oak_Creek = true;}

            match_Sample_Aqualon_Hazardous = (sampleRequest.Aqualon_Hazardous_Material__c &&
                                              approvalProcess.Sample_Criteria_Aqualon_Hazardous_Matl__c) ||
                                            (!sampleRequest.Aqualon_Hazardous_Material__c &&
                                             !approvalProcess.Sample_Criteria_Aqualon_Hazardous_Matl__c);
                                              
            match_Sample_Aquarius = (sampleRequest.Aquarius_Sample__c && 
                                     approvalProcess.Sample_Criteria_Aquarius_Sample__c) ||
                                   (!sampleRequest.Aquarius_Sample__c && 
                                    !approvalProcess.Sample_Criteria_Aquarius_Sample__c);

            match_Sample_Nanjing_Material = (requestForNanjingMaterials == 
                                             approvalProcess.Sample_Criteria_Nanjing_Material__c);
                                            
            match_Sample_Material_Plant = (materialplantrequest == 
                                             approvalProcess.Sample_Criteria_Material_Plant__c);
            
            
        //if (sampleRequestIds.size() <= DebugLogThreshhold)
        if(approvalProcess.Process_Number__c == 121 || approvalProcess.Process_Number__c == 1)
          {
            System.debug('SRAP Name: ' + approvalprocess.process_name__c);
            System.debug('match_Cust_RecordType_Name = ' +             match_Cust_RecordType_Name);            
            System.debug('match_Cust_SAP_Division_Desc = ' +           match_Cust_SAP_Division_Desc);          
            System.debug('match_Cust_SAP_Sales_District_Desc = ' +     match_Cust_SAP_Sales_District_Desc);    
            System.debug('match_Cust_SAP_Sales_Office_Desc = ' +       match_Cust_SAP_Sales_Office_Desc);      
            System.debug('match_Cust_SAP_Sales_Group_Desc = ' +        match_Cust_SAP_Sales_Group_Desc);      
            System.debug('match_Cust_SAP_Sales_Org_Region = ' +        match_Cust_SAP_Sales_Org_Region);       
            System.debug('match_Cust_SAP_Customer_Group = ' +          match_Cust_SAP_Customer_Group);         
            System.debug('match_Cust_SAP_Customer_Group_1 = ' +        match_Cust_SAP_Customer_Group_1);       
            System.debug('match_Cust_SAP_Customer_Group_2 = ' +        match_Cust_SAP_Customer_Group_2);       
            System.debug('match_Cust_SAP_Customer_Group_3 = ' +        match_Cust_SAP_Customer_Group_3);       
            System.debug('match_Cust_SAP_Customer_Group_4 = ' +        match_Cust_SAP_Customer_Group_4);       
            System.debug('match_Cust_SAP_Customer_Group_5 = ' +        match_Cust_SAP_Customer_Group_5);       
                                                                                                        
            System.debug('match_Prospect_RecordType_Name = ' +         match_Prospect_RecordType_Name);        
            System.debug('match_Prospect_SalesOffice = ' +             match_Prospect_SalesOffice);      
            System.debug('match_Prospect_SAP_Sales_District_Desc = ' + match_Prospect_SAP_Sales_District_Desc);
            System.debug('match_Prospect_SAP_Sales_Office_Desc = ' +   match_Prospect_SAP_Sales_Office_Desc);  
            System.debug('match_Prospect_SAP_Sales_Group_Desc = ' +    match_Prospect_SAP_Sales_Group_Desc);  
            System.debug('match_Prospect_SAP_Sales_Org_Region = ' +    match_Prospect_SAP_Sales_Org_Region);   
            System.debug('match_Prospect_SAP_Customer_Group = ' +      match_Prospect_SAP_Customer_Group);         
            System.debug('match_Prospect_SAP_Customer_Group_1 = ' +    match_Prospect_SAP_Customer_Group_1);       
            System.debug('match_Prospect_SAP_Customer_Group_2 = ' +    match_Prospect_SAP_Customer_Group_2);       
            System.debug('match_Prospect_SAP_Customer_Group_3 = ' +    match_Prospect_SAP_Customer_Group_3);       
            System.debug('match_Prospect_SAP_Customer_Group_4 = ' +    match_Prospect_SAP_Customer_Group_4);       
            System.debug('match_Prospect_SAP_Customer_Group_5 = ' +    match_Prospect_SAP_Customer_Group_5);       
                                                                                                        
            System.debug('match_Sample_AD_Compounding = ' +            match_Sample_AD_Compounding);           
            System.debug('match_Sample_AST_Sample = ' +                match_Sample_AST_Sample);               
            System.debug('match_Sample_Product_Development = ' +       match_Sample_Product_Development);      
            System.debug('match_Sample_Tectyl_Product = ' +            match_Sample_Tectyl_Product);           
            System.debug('match_Sample_Product_Line = ' +              match_Sample_Product_Line);             
            System.debug('match_Sample_Oak_Creek = ' +                 match_Sample_Oak_Creek);               
            System.debug('match_Sample_Aqualon_Hazardous = ' +         match_Sample_Aqualon_Hazardous);               
            System.debug('match_Sample_Aquarius = ' +                  match_Sample_Aquarius);               
            System.debug('match_Sample_Nanjing_Material = ' +          match_Sample_Nanjing_Material); 
            System.debug('match_Sample_Material_PLant  = ' +           match_Sample_Material_PLant );
            system.debug('match_Sample_Material_Plant ==> ' + materialplantrequest + ' = ' + approvalProcess.Sample_Criteria_Material_Plant__c);                
          }
          if (
              match_Cust_RecordType_Name &&            
              match_Cust_SAP_Division_Desc &&          
              match_Cust_SAP_Sales_District_Desc &&    
              match_Cust_SAP_Sales_Office_Desc &&      
              match_Cust_SAP_Sales_Group_Desc &&      
              match_Cust_SAP_Sales_Org_Region &&       
              match_Cust_SAP_Customer_Group &&         
              match_Cust_SAP_Customer_Group_1 &&       
              match_Cust_SAP_Customer_Group_2 &&       
              match_Cust_SAP_Customer_Group_3 &&       
              match_Cust_SAP_Customer_Group_4 &&       
              match_Cust_SAP_Customer_Group_5 &&       
              match_Prospect_RecordType_Name &&        
              match_Prospect_SalesOffice &&      
              match_Prospect_SAP_Sales_District_Desc &&
              match_Prospect_SAP_Sales_Office_Desc &&  
              match_Prospect_SAP_Sales_Group_Desc &&  
              match_Prospect_SAP_Sales_Org_Region &&   
              match_Prospect_SAP_Customer_Group &&         
              match_Prospect_SAP_Customer_Group_1 &&       
              match_Prospect_SAP_Customer_Group_2 &&       
              match_Prospect_SAP_Customer_Group_3 &&       
              match_Prospect_SAP_Customer_Group_4 &&       
              match_Prospect_SAP_Customer_Group_5 &&       
              match_Sample_AD_Compounding &&           
              match_Sample_AST_Sample &&               
              match_Sample_Product_Development &&      
              match_Sample_Tectyl_Product &&           
              match_Sample_Product_Line &&
              match_Sample_Oak_Creek &&  
              match_Sample_Aqualon_Hazardous &&             
              match_Sample_Aquarius &&              
              match_Sample_Nanjing_Material &&
              match_Sample_Material_PLant               
             )          
              {
                matchFound = true;
                approvalProcessesIdentified.put(sampleRequest.Id,approvalProcess.Process_Name__c);
              }  
            }   
            }       
      }         
        return approvalProcessesIdentified;
      }

//******************
//Test Method - Test everything but Lookup Approval Process
//******************
  static testMethod void TestMe() {

    System.debug(return_Approver_Queue_as_List('PM CAST - EMEA'));
    Id ApprovalProcessId = lookup_ApprovalProcessId('PM CAST - EMEA');
    String ApprovalProcessName = lookup_ApprovalProcessName(ApprovalProcessId);
    System.debug('Name='+ApprovalProcessName);
    System.debug('Id=' + ApprovalProcessId);
    String result = Sync_Users_on_ApprovalProcess(ApprovalProcessId,true);
    System.debug('result='+result);

    Map<String, Id> AccountRecordTypeMap = RecordType_Functions.RetrieveRecordTypeNameMap('Account');


//    Account TestAccount33a = new Account(Name='Test33a',SAP_Sales_Org__c='0315',SAP_Division_Desc__c='',SAP_Sales_Office_Desc__c='',RecordTypeId=AccountRecordTypeMap.get('Valvoline Customer'));
//    insert TestAccount33a;
//    Sample_Request__c TestSample33a = new Sample_Request__c(Account__c=TestAccount33a.Id,Product_Development__c=false);
//    Sample_Material__c TestMaterial33a = new Sample_Material__c(AD_Compound__c=false,Tectyl_Product__c=false);
//    List<Sample_Material__c> TestMaterials33a = new List<Sample_Material__c>();
//    TestMaterials33a.add(TestMaterial33a);
//    String ApprovalProcessName2 = lookup_Approval_Process(TestSample33a,TestMaterials33a);
//    System.debug('Name='+ApprovalProcessName2);

//   Account TestAccount38b = new Account(Name='Test38b',SAP_Sales_Org__c='',SAP_Division_Desc__c='',SalesOffice__c='',RecordTypeId=AccountRecordTypeMap.get('Valvoline DIFM Prospect'));       
//    insert TestAccount38b;
//    Sample_Request__c TestSample38b = new Sample_Request__c(Account__c=TestAccount38b.Id,Product_Development__c=false);
//    Sample_Material__c TestMaterial38b = new Sample_Material__c(Product_Line__c='Carbrite',Estimated_Sample_Value__c=50,AD_Compound__c=false,Tectyl_Product__c=false);
//    List<Sample_Material__c> TestMaterials38b = new List<Sample_Material__c>();
//    TestMaterials38b.add(TestMaterial38b);
//    String ApprovalProcessName3 = lookup_Approval_Process(TestSample38b,TestMaterials38b);
//    System.debug('Name='+ApprovalProcessName3);
    
    

  }


//The End
}