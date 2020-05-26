// Created by Warren Schembri (Emp No# e004371) - Nov 3, 2008

public class Case_Task_Hour_Functions  {

   // Get the Business Hours to be used of the the Owner of the Case
   public static Id getCaseBusinessHoursID(List<User>users, List<BusinessHours> bHours, Case c)  {
      Id hoursToUse;
      for (User u : users)  {
         if (u.Id == c.OwnerId)  {
            for (BusinessHours bh : bHours)  {
               String bhName = bh.Name;
               if (bhName.compareTo(u.TimeZoneSidKey) == 0)  {
                  hoursToUse = bh.Id;     
                  break; 
               }
            }
         }
      }
       
      // If a match is not found, get the detault Business Hours by calling the getDefaultBusinessHours() method
      if (hoursToUse == NULL)
         hoursToUse = getDefaultBusinessHours();
         
      return hoursToUse;   
   }

   // Get the Business Hours to be used of the the Owner of the Task   
   public static Id getTaskBusinessHoursID(List<User>users, List<BusinessHours> bHours, Task t)  {
      Id hoursToUse;   
      for (User u : users)  {
         if (u.Id == t.OwnerId)  {
            for (BusinessHours bh : bHours)  {
               String bhName = bh.Name;
               if (bhName.compareTo(u.TimeZoneSidKey) == 0)  {
                  hoursToUse = bh.Id;     
                  break; 
               }
            }
         }
      }

      // If a match is not found, get the detault Business Hours by calling the getDefaultBusinessHours() method
      if (hoursToUse == NULL)
         hoursToUse = getDefaultBusinessHours();
         
      return hoursToUse;   
   }         
   
   // Get the Default Business Hours
   public static Id getDefaultBusinessHours()  {
      BusinessHours defaultHours = [SELECT Id FROM BusinessHours WHERE IsDefault=true LIMIT 1];
      return defaultHours.Id;
   }
   
   // Get the Statuses that are needed. The three types are 'Pending', 'In Progress' and 'Completed/Closed'
   public static Set<String> getStatuses(String object_name, String status_type)  {
      Set<String> statusSet = new Set<String>();
      for (Object_Status__c status : [SELECT Status_Name__c FROM Object_Status__c WHERE Object__c = :object_name AND Status_Type__c = :status_type])
         statusSet.add(status.Status_Name__c);
      return statusSet;
   }
   
   
   // Get the time difference since the last change on either the Case or Task
   public static Double getTimeSinceLastChange(Id hoursToUse, DateTime lastStatusChange)  {
      Double timeSinceLastChange = BusinessHours.diff(hoursToUse, lastStatusChange, System.now())/3600000.0;
      return timeSinceLastChange;
   }   
   
   public static Task assignTimeToTask(List<User> usersWithTimeZone, List<BusinessHours> bHours, Task oldTask, Task updatedTask)  {
      // Determine which Business Hours should be used for this Task. Need to find a match between the
      // TimeZone of the AssignedTo/Owner of the old Task and the equivalent in the Business Hours table.
      Id hoursToUse = getTaskBusinessHoursID(usersWithTimeZone, bHours, oldTask);

      // The diff method comes back in milliseconds, so we divide by 3600000 to get hours.
      Double timeSinceLastStatus = getTimeSinceLastChange(hoursToUse, oldTask.Last_Status_Change__c);
      System.debug(timeSinceLastStatus);

      Set<String> pendingStatusSet = getStatuses('Task', 'Pending');
      Set<String> closedStatusSet = getStatuses('Task', 'Completed/Closed');      

      // We decide which bucket to add it to based on whether it was in a "Stop Status" before
      if (pendingStatusSet.contains(oldTask.Status))
         updatedTask.Task_Time_Pending__c += timeSinceLastStatus;
      else
         updatedTask.Task_Time_In_Progress__c += timeSinceLastStatus;

      // If Total Hours is null, set the field to 0.000. Will help prevent NullPointerExceptions
      if (updatedTask.Total_Hours__c == null)
         updatedTask.Total_Hours__c = 0.000;
         
      // If Task is completed and there is a value in the Total Hours field, use the value for the Total_Task_Time field
      if (closedStatusSet.contains(updatedTask.Status))  {
         if (updatedTask.Total_Hours__c != null && updatedTask.Total_Hours__c > 0)
            updatedTask.Total_Task_Time__c = updatedTask.Total_Hours__c;
         else
            updatedTask.Total_Task_Time__c = updatedTask.Task_Time_Pending__c + updatedTask.Task_Time_In_Progress__c;
      }
      
      return updatedTask;      

   }
   
   public static Case assignTimeToCase(List<User> usersWithTimeZone, List<BusinessHours> bHours, Case oldCase, Case updatedCase)  {
      // Determine which Business Hours should be used for this Task. Need to find a match between the
      // TimeZone of the AssignedTo/Owner of the old Task and the equivalent in the Business Hours table.
      Id hoursToUse = getCaseBusinessHoursID(usersWithTimeZone, bHours, oldCase);

      // The diff method comes back in milliseconds, so we divide by 3600000 to get hours.
      Double timeSinceLastStatus = getTimeSinceLastChange(hoursToUse, oldCase.Last_Status_Change__c);
      System.debug(timeSinceLastStatus);

      Set<String> pendingStatusSet = getStatuses('Case', 'Pending');
      Set<String> closedStatusSet = getStatuses('Case', 'Completed/Closed');

      // We decide which bucket to add it to based on whether it was in a "Stop Status" before
      if (pendingStatusSet.contains(oldCase.Status))
         updatedCase.Case_Time_Pending__c += timeSinceLastStatus;
      else
         updatedCase.Case_Time_In_Progress__c += timeSinceLastStatus;

      // If Total Hours is null, set the field to 0.000. Will help prevent NullPointerExceptions
      if (updatedCase.Total_Hours__c == null)
         updatedCase.Total_Hours__c = 0.000;

      // If the Case has been closed, calculate the various Total Times on the Case
      if (closedStatusSet.contains(updatedCase.Status))  {
         if (updatedCase.Total_Hours__c != null && updatedCase.Total_Hours__c > 0)
            updatedCase.Total_Case_Time__c = updatedCase.Total_Hours__c;
         else
            updatedCase.Total_Case_Time__c = updatedCase.Case_Time_Pending__c + updatedCase.Case_Time_In_Progress__c;
         if (updatedCase.Total_Task_Hours__c != null && updatedCase.Total_Task_Hours__c > 0)
            updatedCase.Total_Case_Hours__c = updatedCase.Total_Case_Time__c + updatedCase.Total_Task_Hours__c;
         else
            updatedCase.Total_Case_Hours__c = updatedCase.Total_Case_Time__c;
      }
      else
         updatedCase.Last_Status_Change__c = System.now();            
      
      return updatedCase;      
   }

}