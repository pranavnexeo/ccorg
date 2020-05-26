//@LAB Project
//@Rajeev
//Called by "Update_R_D_OwnerAndCheckHistory" trigger.

public class R_D_Object_Functions{
    
    //Method called by trigger 
    public static void ProcessBefore(List<R_D_Requests__c> RDlist,Map<Id,R_D_Requests__c> oldmap,boolean isUpdate){
        UpdateOwner(Rdlist,oldmap);
        GetApprovalRejectionDetails(RDlist,isUpdate);
        UpdateSalesDirector(RDlist);
    }

    
    //Method to fetch a map of available Record Types for this object.
    public static Map<String,Id> getRecordTypes(){
        return RecordType_Functions.RetrieveRecordTypeNameMap('R_D_Requests__c');
    }
    
    //Method to udpate Sales Director Field
    public static void UpdateSalesDirector(List<R_D_Requests__c> reqs){
      
      Set<Id> CustomerIds = new set<Id>();
      Set<Id> OwnerIds = new set<Id>();
       
      for(R_D_Requests__c rd:reqs)
        if(Rd.Customer__c  != null)
          CustomerIds.add(rd.Customer__c);
     
      Map<Id, Account> amap = new Map<Id, Account>([select id, OwnerId, Owner.ManagerId, Owner.Manager.ManagerId,Owner.Manager.Manager.IsActive from Account where Id IN :CustomerIds]);
      
      for(R_D_Requests__c rd:reqs){
      if(rd.customer__c != null)
        if(amap.containskey(rd.customer__c))
           if(amap.get(rd.customer__c).Owner.ManagerId != null)
            if(amap.get(rd.customer__c).Owner.Manager.Manager.IsActive)
              rd.Sales_Director__c = amap.get(rd.customer__c).Owner.Manager.ManagerId;
      }
     }   
    //Method to change owner and update "killed at stage" field.
    public static void UpdateOwner(List<R_D_Requests__c> RDlist,Map<Id,R_D_Requests__c> oldmap){
    Map<String,Id> RecTypeNameMap = getRecordTypes();
    for(R_D_Requests__c rd : RDlist){
       if((RecTypeNameMap.get('Customer – Stage 0 Pending Approval') == rd.RecordTypeId) && (rd.Technical_Manager__c != null)){
         rd.ownerid = rd.Technical_Manager__c;
       }
       else if((RecTypeNameMap.get('Customer – Stage 1 Pending Approval') == rd.RecordTypeId) && (rd.Technical_Manager__c != null)){
         rd.ownerid = rd.Technical_Manager__c;
       }
       else if((RecTypeNameMap.get('Customer – Stage 2 Pending Approval') == rd.RecordTypeId) && (rd.Technical_Manager__c != null)){
         rd.ownerid = rd.Technical_Manager__c;
       }
       else if((RecTypeNameMap.get('Innovation – Stage 0 Pending Approval') == rd.RecordTypeId) && (rd.Marketing_Manager__c != null) && (rd.Subtype__c == 'Blend Development')){
             rd.ownerid = rd.Marketing_Manager__c;      
       }
       else if((RecTypeNameMap.get('Innovation – Stage 0 Pending Approval') == rd.RecordTypeId) && (rd.Technical_Manager__c != null) &&
             ((rd.Subtype__c == 'Formulary Development') || (rd.Subtype__c == 'Products of Focus'))){
             rd.ownerid = rd.Technical_Manager__c;      
       }
       else if((RecTypeNameMap.get('Innovation – Stage 1 Pending Approval') == rd.RecordTypeId) && (rd.Technical_Manager__c != null) && (rd.Subtype__c == 'Blend Development')){
             rd.ownerid = rd.Technical_Manager__c;
       }
       else if((RecTypeNameMap.get('Innovation – Stage 1 Pending Approval') == rd.RecordTypeId) && (rd.Technical_Manager__c != null) &&
             ((rd.Subtype__c == 'Formulary Development') || (rd.Subtype__c == 'Products of Focus'))){
             rd.ownerid = rd.Technical_Manager__c;
       }
       else if((RecTypeNameMap.get('Innovation – Stage 2 Pending Approval') == rd.RecordTypeId) && (rd.Marketing_Manager__c != null) && (rd.Subtype__c == 'Blend Development')){
             rd.ownerid = rd.Marketing_Manager__c;
       }
       else if((RecTypeNameMap.get('Innovation – Stage 2 Pending Approval') == rd.RecordTypeId) && (rd.Technical_Manager__c != null) &&
             ((rd.Subtype__c == 'Formulary Development') || (rd.Subtype__c == 'Products of Focus'))){
             rd.ownerid = rd.Technical_Manager__c;
       }
       else if((RecTypeNameMap.get('Innovation – Stage 3 Pending Approval') == rd.RecordTypeId) && (rd.Marketing_Manager__c != null) && (rd.Subtype__c == 'Blend Development')){
             rd.ownerid = rd.Marketing_Manager__c;
       }
       else if((RecTypeNameMap.get('Innovation – Stage 3 Pending Approval') == rd.RecordTypeId) && (rd.Technical_Manager__c != null) &&
             ((rd.Subtype__c == 'Formulary Development') || (rd.Subtype__c == 'Products of Focus'))){
             rd.ownerid = rd.Technical_Manager__c;
       }


       if(rd.Stage__c ==  'Stage 4 - Closed Dead' || rd.Stage__c ==  'Stage 3 - Closed Dead'){
           if((oldmap.get(rd.id).stage__c) != null){
            rd.Killed_At_Stage__c = oldmap.get(rd.id).stage__c;
           }
        }
      }
    }
   
   //Method to share record
   public static Map<Id, String> ShareRDRequests(List<R_D_Requests__c> reqs){
    
    map<Id, String> errormap = new map<id, String>();
        // Create a new list of sharing objects for Job
        List<R_D_Requests__Share> shares = new List<R_D_Requests__Share>();
        List<R_D_Requests__Share> deleteshares = [select id, rowcause from R_D_Requests__Share where ParentID IN :reqs and rowcause != 'Owner'];

        if(deleteshares.size() > 0)
          delete deleteshares;
          
        Set<Id> accountids = new set<Id>();
        
        // Declare variables for recruiting and hiring manager sharing
        R_D_Requests__Share seller;
        R_D_Requests__Share MktMgr;
        R_D_Requests__Share TSS;
        R_D_Requests__Share Chemist;
        R_D_Requests__Share RD_Manager;
        R_D_Requests__Share Requestor;
        R_D_Requests__Share SalesDir;
        R_D_Requests__Share Tech_Manager;

        for(R_D_Requests__c req : reqs){
          if(req.Customer__c != null)
            accountids.add(req.Customer__c);
        }
        
        Map<Id, Account> amap = new map<Id, Account>([select id, ownerid from Account where id IN :accountids]);
        
        
        for(R_D_Requests__c req : reqs){
            
            // Instantiate the sharing objects
            seller = new R_D_Requests__Share();
            MktMgr = new R_D_Requests__Share();
            TSS = new R_D_Requests__Share();
            Chemist = new R_D_Requests__Share();
            RD_Manager = new R_D_Requests__Share();
            Requestor = new R_D_Requests__Share();
            SalesDir = new R_D_Requests__Share();
            Tech_Manager = new R_D_Requests__Share(); 
            
            // Set the ID of record being shared
            seller.ParentId = req.Id; 
            MktMgr.ParentId = req.Id;
            TSS.ParentId = req.Id;
            Chemist.ParentId = req.Id;
            RD_Manager.ParentId = req.Id;
            Requestor.ParentId = req.Id;
            SalesDir.ParentId = req.Id;
            Tech_Manager.ParentId = req.Id;
            
            // Set the access level
            seller.AccessLevel = 'read';
            MktMgr.AccessLevel = 'edit';
            TSS.AccessLevel = 'read';
            Chemist.AccessLevel = 'edit';
            RD_Manager.AccessLevel = 'edit';
            Requestor.AccessLevel = 'read';
            SalesDir.AccessLevel = 'read';
            Tech_manager.AccessLevel = 'edit';
              
            // Set the Apex sharing reason 
            seller.RowCause = Schema.R_D_Requests__Share.RowCause.Seller__c;
            MktMgr.RowCause = Schema.R_D_Requests__Share.RowCause.Marketing_Manager__c;
            TSS.RowCause = Schema.R_D_Requests__Share.RowCause.Technical_Sales_Rep__c;
            Chemist.RowCause = Schema.R_D_Requests__Share.RowCause.Chemist__c;
            RD_Manager.RowCause = Schema.R_D_Requests__Share.RowCause.R_D_Manager__c;
            Requestor.RowCause = Schema.R_D_Requests__Share.RowCause.Requestor__c;
            SalesDir.RowCause = Schema.R_D_Requests__Share.RowCause.Sales_Director__c;
            Tech_Manager.RowCause = Schema.R_D_Requests__Share.RowCause.Technical_Manager__c;
            
            // Set the ID of user or group being granted access
            //if req has customer
            If(req.customer__c != null){
              if(amap.containskey(req.customer__c)){
                   // Instantiate the sharing objects
                  // Set the ID of record being shared
                  seller.UserOrGroupId = amap.get(req.customer__c).ownerid;
                  shares.add(seller);
              }
            }
            
            //if req has Marketing_Manager__c
            if(req.Marketing_Manager__c != null)
            {   MktMgr.UserOrGroupId = req.Marketing_Manager__c;
                shares.add(MktMgr);
            }
               
            //if req has TSS
            if(req.Technical_Sales_Rep_User__c != null)
            {
               TSS.UserOrGroupId = req.Technical_Sales_Rep_User__c;
               shares.add(TSS);
            }
               
            //if req has chemist
            if(req.Chemist__c != null)
            {
               Chemist.UserOrGroupId = req.Chemist__c;
               shares.add(chemist);
            }
               
            //if req has RD Manager
            if(req.R_D_Manager__c != null)
            {
               RD_Manager.UserOrGroupId = req.R_D_Manager__c;
               shares.add(RD_Manager);
            }
               
            //if req has Requestor
            if(req.Requestor__c != null)
            {
               Requestor.UserOrGroupId = req.Requestor__c;
               shares.add(requestor);
            }
               
            //if req has Sales Director
            if(req.Sales_Director__C != null)
            {
               SalesDir.UserOrGroupId = req.Sales_Director__c;
               shares.add(SalesDir);
            }
               
            //if req has Tech Manager
            if(req.Technical_Manager__c  != null)
            {
               Tech_Manager.UserOrGroupId = req.Technical_manager__c;
               shares.add(Tech_Manager);
            }

        }
        
        // Insert sharing records and capture save result 
        // The false parameter allows for partial processing if multiple records are passed 
        // into the operation 
        Database.SaveResult[] lsr = Database.insert(shares,false);
        
        // Create counter
        Integer i=0;
        
        // Process the save results
        for(Database.SaveResult sr : lsr){
            if(!sr.isSuccess()){
                // Get the first save result error
                Database.Error err = sr.getErrors()[0];
                
                // Check if the error is related to a trivial access level
                // Access levels equal or more permissive than the object's default 
                // access level are not allowed. 
                // These sharing records are not required and thus an insert exception is 
                // acceptable. 
                if(!(err.getStatusCode() == StatusCode.FIELD_FILTER_VALIDATION_EXCEPTION  
                                               &&  err.getMessage().contains('AccessLevel'))){
                    // Throw an error when the error is not related to trivial access level.
                    errormap.put(shares[i].ParentId,
                       'Unable to grant sharing access due to following exception: '
                       + err.getMessage());
                }
            }
            i++;
        }   
    return errormap;
    
}
   
   //Method to get map of approver comments
   public static void GetApprovalRejectionDetails(List<R_D_Requests__c> Rlist,boolean isUpdate){
       //Runs only on update event
       if(isUpdate){
        Set<Id> recordIds = new Set<Id>();
          for(R_D_Requests__c obj : Rlist){
            if(obj.id != null){
             recordIds.add(obj.Id);
             }
            } 
        
        //Pass set of record ids to get comments map
        Map<ID,String> AppRejMap = new Map<ID,String>();
         if(!recordIds.isEmpty()){
           AppRejMap = Approval_Functions.getLastApproversComments(recordIds);
          }
       
       //Finally, modify the record before getting saved in database
       for(R_D_Requests__c obj : Rlist){
          if(Rlist != null && Rlist.size()>0){
            if(AppRejMap.containsKey(obj.Id)){
             if(AppRejMap.get(obj.Id) != null)
              obj.Approval_Rejection_Comments__c = AppRejMap.get(obj.Id);
           }
         }
       }
     } 
   }
}