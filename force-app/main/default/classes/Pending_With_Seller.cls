public with sharing class Pending_With_Seller {
    
    Public Pending_With_Seller(){}
    Public static string getDateFormat(){
	  date d = Date.valueof('1999-01-22');
	  string dformat = d.format();
	  string f = '';
	
	  if(dformat.indexof('22') < dformat.indexof('01'))
	    f = 'dd/mm';
	  else
	    f = 'mm/dd';
	  if(dformat.indexof('01') < dformat.indexof('1999'))
	    f = f + '/yy';
	  else
	    f = 'yy/' + f;
	  return f;
	  
	}
    @RemoteAction
    public static List<Price_Request_Transaction__c> fetchPendingWithSeller(Integer index,  String userId){
        String toAdd = '';
        set<string> statuses;
        if(userId == '')
            userId = userinfo.getuserid();
        
        if(index == 0){
            statuses =  new set<string>{'Pending Entry', 'Submitted', 'Approved'};
            toAdd = ' createdbyid = \''+userid+'\'  OR ship_to__r.ownerid =  \''+userid+'\'';
        }else{
            statuses =  new set<string> {'Rejected-Alternate'};
            toAdd = '  createdbyid =  \''+userid+'\'';
        }
    
        set<string> types =  new set<string>{'Quote', 'CSP'};
        
        String query = 'select Id,Inner_Table__c, Inner_Table_For_Seller__c,';
        query+= 'Approval_Status__c,Approval_Level__c, ';
        query+= 'Approver__r.Name, Type__c,';
        query+= 'Sold_To_Account_Number__c,SAP_SoldTo_Account__c,SAP_ShipTo_Account__c,';
        query+= 'Ship_To_Account_Number__c,sap_material__r.name, requested_effective_date__c, ';
        query+= 'Requested_Effective_Date_Text__c,requested_expiration_date__c, Volume__c, Requested_UoM__c,';
        query+= 'Requested_Expiration_Date_Text__c,Price__c, Requested_Price_UoM__c, ';
        query+= 'requested_price_Protection__c, TPI__c,comments__c,Approval_Rejection_Comments__c '; 
        query+= 'from Price_Request_Transaction__c ';
        query+= 'where Approval_Status__c in: statuses and  Type__c in: types ';
                        
        if(toAdd != '')
            query += ' and ( ' +toAdd+ ' )';
        
        query += ' order by requested_effective_date__c desc';
    
        List<Price_Request_Transaction__c> pendingRecords = Database.query(query);
        return pendingRecords;
    }
    
    
    @RemoteAction
    public static void approveRejectChange(String RequestId,String comments, String approvereject){
        
        if(RequestId != null && RequestId != ''){
            
            RequestId = RequestId.replaceall('SelectedAudit=', '');
            List<String> splitstrings = RequestId.split('&');
            Set<Id> PRTIds = new Set<Id>();
            //Approving Rejecting the records 
            Map<String, Id> WorkItem_Map = new Map<String, Id>();
            List<ProcessInstanceWorkitem> PWIs = [select id, ProcessInstance.TargetObjectId from ProcessInstanceWorkitem p where p.ProcessInstance.TargetObjectId IN :splitstrings and p.ActorID = :userinfo.getuserid()];
            
            for(ProcessInstanceWorkItem pwi:PWIs)
                WorkItem_Map.put(pwi.ProcessInstance.TargetObjectId, pwi.id);
            
            List<Approval.ProcessWorkitemRequest> PWIRs = new List<Approval.ProcessWorkitemRequest>();
            for(String s:splitstrings)
            {
               Approval.ProcessWorkitemRequest req2 = new Approval.ProcessWorkitemRequest();
               req2.setComments(comments);
               req2.setAction(approvereject);   
               req2.setWorkitemId(WorkItem_Map.get(s));    
               PWIRs.add(req2);
               PRTIds.add(s);
            }
            List<Approval.ProcessResult> results =  Approval.process(PWIRs);
            
            List<Price_request_transaction__c> prtlist = [select id from Price_request_transaction__c where id in : splitstrings];
            update prtlist;
        
         }
    } 
    
    /*
    private static void sellerApprovalActions(Set<Id> splitstrings,String comments, String approvereject){
    	if(approvereject == 'Approve'){
	            
            set<String>types = new set<String>{'Requested', 'Alternate'};
	            
	        List<SAP_Price__c> sapprices = [select id, type__c,Price_Request_Transaction__c from SAP_Price__c where Price_Request_Transaction__c IN :splitstrings and type__c IN :types];
	        for(String t:splitstrings){  
    
                for(Sap_Price__c pr:sapprices){ 
                    if(pr.Price_Request_Transaction__c == t){
                        if(pr.type__c == 'Alternate')
                            pr.type__c = 'Requested';
                        else
                            pr.type__c = pr.type__c + ' History';
                        
                    }
                }
            }   
            if(sapprices.size() > 0)
              upsert sapprices;
        }      
       
           
            
            //update the Approval Comments on PRT record
    		List<Price_Request_Transaction__c> prt = [select id, Reject_Alternate_Comments__c from Price_Request_Transaction__c where id IN :splitstrings];
        	for(Price_Request_Transaction__c t:prt){
            	t.Reject_Alternate_Comments__c = comments;
        	}
        	update prt;
    
	}
	
    */
    @RemoteAction
    Public static combogriddata getComboGridData(string q, string obj, string fields, string filters, string orderby, string mylimit){ 
        List<sobject> records = new list<SObject>();
        if(obj != '' && fields != '')
        {
          String query = '\'%' + q.escapeEcmaScript() + '%\'';
          string f = fields.replaceall('-id', '');
          string qstring = 'SELECT id, ' + f + ' from ' + obj + ' where id != null';
          if(filters != null && filters != '')
            qstring += ' and ' + filters;
        
          List<String> myfields = fields.split(',');
          if(q != null && q != '' && myfields.size() > 0)
          {
            qstring += ' and (';
            for(integer i=0; i<myfields.size(); i++)
            { string s = myfields.get(i);
              if(!s.contains('-id'))
              {
              if(i != 0)
                qstring += ' OR ';
              qstring += s + ' LIKE ' + query;
              }
            }
            qstring += ')';
          }
          if(orderby != '' && orderby != null)
            qstring += ' ORDER BY ' + orderby;
          else
            qstring += ' ORDER BY Name ';
          qstring += ' LIMIT ' + mylimit;
          
          records = database.query(qstring);
        }
         combogriddata data = new combogriddata(records);
         
         return data;
    }
    
}