public class NCAR_Queue_Viewer{
/*
public list<Wrapper> NCARs{get ;set;}
public list<Wrapper2> caselines {get; set;}
public list<SelectOption> options{Get; set;}
public string selectedoption{get; set;}
public string sortfield{get; set;}
private Sort_Helper SH{get;  set;}
private string prevsortfield{get;set;}
public String SortImage{get; set;}
public static final String SORT_ASC_IMG = '/img/sort_asc_arrow.gif'; 
public static final String SORT_DESC_IMG = '/img/sort_desc_arrow.gif'; 
private static Map<String, Schema.RecordTypeInfo> RTMap{get; set;}
private set<ID> RTids{get; set;}

public NCAR_Queue_Viewer(){

  SH = new Sort_Helper();
  Set<id> qmember = new set<ID>();
  NCARs = new list<Wrapper>();
  CaseLines = new list<Wrapper2>();
  Options = new list<selectoption>();
  Options.add(new SelectOption('-1', '--None--'));
  Options.add(new selectOption('All', 'All NCARs Pending Approval'));
  Options.add(new SelectOption(UserInfo.getuserId(), UserInfo.GetName()));
  List<groupmember> membership = [select id, userorgroupid, groupid from groupmember where userorgroupid = :userinfo.getuserid() limit 1000];
  RTMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();
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
  
    if(apexpages.currentpage().getparameters().containskey('q')){
    selectedoption = apexpages.currentpage().getparameters().get('q');
    queuechanged();
  } else {  selectedoption = '-1'; }

}

public pagereference queuechanged(){
  
  NCARs.clear();
  CaseLines.clear();
  Map<ID, String> NameMap = new Map<ID, String>();
  
  if(selectedoption != '-1'){

  Set<ID>TargetObjectIDs = new Set<ID>();
  List<ProcessInstanceWorkItem> items = new list<ProcessInstanceWorkItem>();
  
  if(selectedoption == 'All')
  {
      items = [select id, ProcessInstance.TargetObjectID, Actor.Name, Actorid from ProcessInstanceWorkItem p where p.ProcessInstance.TargetObject.Type = 'Case' limit 1000];
  }
  else
  {
      items = [select id, ProcessInstance.TargetObjectID, Actor.Name, Actorid from ProcessInstanceWorkItem p where ActorId = :selectedoption and p.ProcessInstance.TargetObject.Type = 'Case' limit 1000];
  }
  
  for(ProcessInstanceWorkItem p:items){
    TargetObjectIDs.add(p.ProcessInstance.TargetObjectID);
    NameMap.put(p.processinstance.TargetObjectID, p.actor.name);
  }
  
  List<Case> Cases = [select id, 
        casenumber,
        status,
        Origin,
        subject,
        contactid,
        accountid,
        Account.Name,
        Account.SAP_Sales_Org_Desc__c,
        Account.SAP_Sales_Org__c,
        RecordType.name,
        recordtypeid,
        type,
        Account.SAP_Sales_Group_Desc__c,
        createddate,
        ownerid,
        Import_Export__c,
        Account.Ownerid        
        
        from Case where id IN :targetObjectIDs
        and isclosed = false
        and Recordtypeid IN :RTIds
        order by createddate DESC limit 1000];
        
        sortimage = SORT_DESC_IMG;
        sortfield = 'CreatedDate';
        prevsortfield = '';
        
        List<Case_Line_Item__c> lines = [select id, 
        case__c, 
        Open_Order__c,
        open_order__r.sales_order_Number__c, 
        open_order__r.created_Date__c, 
        open_order__r.delivery_date__c, 
        open_order__r.material__c,
        open_order__r.Line_Item_Number__c,
        open_order__r.Ordered_Qty_in_LB__c,
        Open_Order__r.Plant_Desc__c,
        open_order__r.plant__r.plant_code__c,
        open_order__r.plant__c, 
        open_order__r.Billed_Qty_in_LB__c,
        open_order__r.PH4_Supplier__c,
        Import_Export__c,
        Material__c              
        from Case_Line_Item__c where case__c IN :TargetObjectIDs order by createddate DESC];
        
        
        for(Case c:Cases){
           List<Case_Line_Item__c> clines = new List<Case_Line_Item__c>();
           for(Case_Line_Item__c l:lines){
             if(l.case__c == c.id){
               clines.add(l);
               caselines.add(new wrapper2(c, l, namemap.get(c.id)));
             }
           }
           NCARs.add(new Wrapper(c, clines, namemap.get(c.id)));
           if(clines.size() == 0){ caselines.add(new wrapper2(c, namemap.get(c.id))); }
        }
        
        }
        return null;

}

public pagereference sort(){

Map<id, Wrapper> recordmap = new map<id, wrapper>();
List<Case> olist = new list<Case>();
for(wrapper w:NCARs){
  olist.add(w.thecase);
  recordmap.put(w.thecase.id, w);
}

/*This checks to see if the same header was click two times in a row, if so 
it switches the order.

 boolean ascsortorder = true;
 if(prevSortField == sortField){
    ascsortOrder = false;
    prevSortField = '';
    sortimage = SORT_DESC_IMG;
 }else{
    ascsortOrder = true;
    prevSortField = sortField;
    sortimage = SORT_ASC_IMG;
 }
 
List<Case> newlist = (List<case>)SH.getSortedList(olist, sortfield, ascsortorder);
NCARs.clear();
for(Case c:newlist){
  NCARs.add(recordmap.get(c.id));
}// end for

return null;
}

public class wrapper{

public Case theCase{get; set;}
public List<Case_Line_Item__c> lines{get; set;}
public String Approver{get; set;}

public wrapper(Case c, List<Case_Line_Item__c> l, string a){
theCase = c;
Lines = l;
approver = a;
}
}

public class wrapper2{

public case thecase{get; set;}
public Case_Line_Item__c line{get; set;}
public String Approver{get; set;}

public wrapper2(Case c, case_line_item__c cl, string a){
thecase = c;
line = cl;
Approver = a;
}

public wrapper2(case c, string a){
thecase = c;
line = new Case_Line_Item__c();
Approver = a;
}
}
*/
}