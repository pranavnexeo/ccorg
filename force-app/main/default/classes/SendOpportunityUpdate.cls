public class SendOpportunityUpdate{

public List<WrapperClass> contacts{Get; set;}
public Opportunity_Call_Report__c ou{get; set;}
private Opportunity opp{Get; set;}
private string templateid{get; set;}
public SendOpportunityUpdate(apexpages.standardcontroller sc){
  templateid = apexpages.currentpage().getparameters().get('tid');
  ou = [select id, Opportunity__c from Opportunity_Call_Report__c where id = :sc.getrecord().id limit 1];
  opp  = [select id, Requested_Supplier__c from Opportunity where id = :ou.Opportunity__c limit 1];
  contacts = new List<WrapperClass>();
  for(Supplier_Contact__c c:[select id, first_name__c, Last_Name__c, email__c, Comments__c from Supplier_Contact__c where Competitor_Supplier_or_OEM__c = :opp.Requested_Supplier__c and Call_Report_Contact__c = True and email__c != null]){
    contacts.add(new wrapperclass(c));
  }
}

public class wrapperclass{
  public boolean selected{get; set;}
  public Supplier_Contact__c sc{get; set;}
  public wrapperclass(Supplier_Contact__c sc){
    this.sc = sc;
    selected = false;
  }
}

public pagereference sendEmail(){

  List<String> emails = new list<String>();
  
  for(WrapperClass w:contacts){
    if(w.selected)
      emails.add(w.sc.email__c);
  }
  EmailTemplate etemp = [Select Id From EmailTemplate Where id = :templateid];

  string url = '/_ui/core/email/author/EmailAuthor?p3_lkid=' + ou.Id + '&retURL=%2F' + ou.Id + '&p24=' + String.join(emails, ',') + '&template_id='+etemp.id;
  return new pagereference(url);
}
}