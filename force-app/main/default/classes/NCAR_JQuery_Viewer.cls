Public with sharing Class NCAR_JQuery_Viewer{

public list<SelectOption> options{Get; set;}
public string selectedoption{get; set;} 
private static Map<String, Schema.RecordTypeInfo> RTMap{get; set;}
private set<ID> RTids{get; set;}
public Integer optionsSize{get; set;}

public NCAR_JQuery_Viewer(){
  
  Set<id> qmember = new set<ID>();
  Options = new list<selectoption>();
  Options.add(new selectOption('All', 'All NCARs Pending Approval'));
  Options.add(new SelectOption(UserInfo.getuserId(), UserInfo.GetName()));
  List<groupmember> membership = [select id, userorgroupid, groupid from groupmember where userorgroupid = :userinfo.getuserid() limit 1000];
  RTMap = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  RTids = new set<ID>();
  RTIds.add(RTMap.get('Nexeo Credit Debit Claim').getrecordtypeid());
  RTIds.add(RTMap.get('Nexeo Return').getrecordtypeid());
  RTIds.add(RTMap.get('Nexeo Standard Incident').getrecordtypeId());

  for(groupmember gm:membership){
    qmember.add(gm.groupid);
  }
  list<Group> Queues = [select id, name from group where type = 'Queue' and name like 'NCAR%' and id IN :qmember limit 100];
  for(Group g:queues){
    options.add(new selectoption(g.id, g.name));
  }
   optionsSize = options.size();
  
  if(apexpages.currentpage().getparameters().containskey('q')){
    selectedoption = apexpages.currentpage().getparameters().get('q');
    //queuechanged();
  } else {  selectedoption = 'All'; }

}


@RemoteAction
Public static List<NCAR_Cases__c> getNCARs(){
  List<NCAR_Cases__c> Cases = [select id, 
        createdby.name,
        Name,
        Status__c,
        Subject__c,
        customer_ServiceSupervisor__c,
        Account__c,
        Contact__c,
        Account__r.Name,
        Account__r.SAP_Sales_Org_Desc__c,
        Account__r.SAP_Sales_Org__c,
        RecordType.name,
        Type__c,
        Account__r.SAP_Sales_Group_Desc__c,
        Account__r.SAP_Division_Desc__c,
        Import_Export__c,
        Account__r.Ownerid,    
        createddate,
        Memo_CSR__c,
        Memo_Purchasing__c,
        Memo_Plant__c,
        Ship_To_Warehouse__r.Name,
        Nexeo_Plant__r.Name,
        (select id, 
        open_orders__r.sales_order_Number__c, 
        open_orders__r.material__r.Name,
        open_orders__r.PH4_Supplier__c
        from NCAR_Line_Items__r                 
        )

        from NCAR_Cases__c
        where Status__c != 'Closed'   
        order by CreatedDate DESC limit 2000];
        return cases;
}

@RemoteAction
Public static List<NCAR_Cases__c> getNewNCARs(String selectedoption){
  Set<ID> RTids1 = new set<ID>();
  Map<String, Schema.RecordTypeInfo> RTMap1;
  RTMap1 = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  RTIds1.add(RTMap1.get('Nexeo Credit Debit Claim').getrecordtypeid());
  RTIds1.add(RTMap1.get('Nexeo Return').getrecordtypeid());
  RTIds1.add(RTMap1.get('Nexeo Standard Incident').getrecordtypeId());
  
  Map<ID, String> NameMap = new Map<ID, String>();
  if(selectedoption != '-1'){
 
  Set<ID>TargetObjectIDs = new Set<ID>();
  List<ProcessInstanceWorkItem> items = new list<ProcessInstanceWorkItem>();
  
  if(selectedoption == 'All')
  {
      items = [select id, ProcessInstance.TargetObjectID, Actor.Name, Actorid from ProcessInstanceWorkItem p where p.ProcessInstance.TargetObject.Type = 'NCAR_Cases__c' and processinstance.status = 'Pending' order by createddate DESC limit 30000];
  }
  else
  {
      items = [select id, ProcessInstance.TargetObjectID, Actor.Name, Actorid from ProcessInstanceWorkItem p where ActorId = :selectedoption and p.ProcessInstance.TargetObject.Type = 'NCAR_Cases__c' and processinstance.status = 'Pending' order by createddate DESC limit 30000];
  }
  for(ProcessInstanceWorkItem p:items){
    TargetObjectIDs.add(p.ProcessInstance.TargetObjectID);
    NameMap.put(p.processinstance.TargetObjectID, p.actor.name);
  }
  
  List<NCAR_Cases__c> Cases = [select id, 
        Name,
        Status__c,
        customer_ServiceSupervisor__c,
        Origin__c,
        subject__C,
        Account__c,
        Contact__c,
        Account__r.Name,
        Account__r.SAP_Sales_Org_Desc__c,
        Account__r.SAP_Sales_Org__c,
        //RecordType.name,
        RecordTypeId,
        RecordType.name,
        Type__c,
        Account__r.SAP_Sales_Group_Desc__c,
        Account__r.SAP_Division_Desc__c,
        ownerid,
        Import_Export__c,
        Account__r.Ownerid,    
        createddate,
        CreatedBy.Name,
        Memo_CSR__c,
        Memo_Purchasing__c,
        Memo_Plant__c,
        Ship_To_Warehouse__r.Name,
        Nexeo_Plant__r.Name,
        (select id, 
        open_orders__r.sales_order_Number__c, 
        open_orders__r.material__r.Name,
        open_orders__r.PH4_Supplier__c
        from NCAR_Line_Items__r                 
        )   
        
        from NCAR_Cases__c where id IN :targetObjectIDs
        and Status__c != 'Closed'   
        and recordtypeid IN :RTIds1 
        order by CreatedDate DESC limit 2000];
        
        
        return Cases;
        }
        return null;

}

@RemoteAction
Public static String getRecType(String NCARId){

NCAR_Cases__c Ncar = [Select Id,RecordType.name from NCAR_Cases__c where Id=: NCARId];
return Ncar.RecordType.name;
}
}