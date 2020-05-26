public with sharing class EditWasteProfilesExtension{

public List<ES_Profile__c> Profiles{get; set;}
public List<attachment> attachments{get; set;}
public list<Wrapper> wrappers{get; set;}
public Opportunity opp{get ;set;}
public string oppid{get; set;}
public string submitid{get; set;}
public attachment attachment{get; set;}
public string profileid{get; set;}
public string attachmentid{get; set;}
public boolean displaypopup{get; set;}
public boolean displayattachmentscreen{get; set;}
public boolean displaynewattachmentbutton{get; set;}
public boolean displayupdateattachmentbutton{get; set;}
private attachment deleteattachment{get; set;}
Private Map<String, Id> RTMap{get; set;}
public Boolean noWasteProfiles = false; // Added by Abhishek on 6Sept2013

public EditWasteProfilesExtension(apexpages.standardcontroller std){

RTMap = Recordtype_Functions.RetrieveRecordTypeNameMap('ES_Profile__c');
displayattachmentscreen = false;
displaypopup = false;
Set<ID> profileids = new set<ID>();
map<ID, ES_Profile__c> Profilemap = new map<ID, ES_Profile__c>();
Set<ID> parentids = new set<ID>();
wrappers = new list<wrapper>();
submitid = '';

Oppid = apexpages.currentpage().getparameters().get('OppId');
Opp = [select id, name, ownerid, Account.ownerid, Accountid, Submitted_To_WMS__c from Opportunity where id = :oppid];
System.debug('Opporutnity EditWasteProfilesExtension ##### ' + opp);
Profiles = [select id, recordtype.name, recordtypeid, name, Account_Owner__c, Estimated_Price__c, Opportunity__c,  Price_Request__c,
            Price_Unit__c, Risk_Category__c, Stage__c, Customer_Status_Group__c, comments__c from ES_Profile__c where opportunity__r.id = :oppid];

noWasteProfiles = false; // Added by Abhishek on 6Sept2013
System.debug('Opporutnity EditWasteProfilesExtension noWasteProfiles  ##### ' + noWasteProfiles );
if(profiles.size() == 0){
    noWasteProfiles = true; // Added by Abhishek on 6Sept2013
  addprofile();
}

for(ES_profile__c p:profiles){
  profileids.add(p.id);   
  profilemap.put(p.id, p);       
}

attachments = [select id, name, parentid from attachment where parentid in :profileids];

for(ES_Profile__c p:profiles){
  List<attachment> alist = new list<attachment>();
  for(attachment a:attachments){
      if(a.parentid == p.id){ alist.add(a);}
  }
  wrapper w = new wrapper(p, alist); 
  wrappers.add(w); 
}
}


public pagereference addprofile(){
  ES_Profile__c p = new ES_Profile__c();
  p.stage__c = 'New Profile';
  p.recordtypeid = RTMap.get('New Profile');
  p.opportunity__c = opp.id;
  opp.submitted_to_WMS__c = false;
  System.debug('Opporutnity addprofile noWasteProfiles  ##### ' + noWasteProfiles );
  if(noWasteProfiles == false){ // Added by Abhishek on 6Sept2013
      System.debug('Opporutnity addprofile if(noWasteProfiles == false) ##### ' + opp);
      update opp; // Added to avoid Workflow rule mishap - Abhishek 30Aug2013
      // This is to make sure that Opportunity is not updated if there are no Waste Profiles
  }
  wrapper w = new wrapper(p, new list<attachment>());
  wrappers.add(w);
  System.debug('Opporutnity addprofile ##### ' + opp);
  // noWasteProfiles = false;
  return null;
}

public pagereference saveandcontinue(){
  pagereference p = saveprofiles();
  return null;
}

public pagereference saveprofiles(){
// update opp; Moving to the end of the class to wait for Waste Profiles to be updated - Abhishek 30Aug2013
for(wrapper w:wrappers){
  if(w.profile.stage__c == 'New Profile' && Opp.submitted_to_WMS__c == true){
      w.profile.stage__c = 'Submitted to WMS';
  }
  if(w.profile.recordtypeid != RTMap.get(w.profile.stage__c)){
     w.profile.recordtypeid = RTMap.get(w.profile.stage__c);
  }
  if(w.profile.stage__c != 'Pricing Submitted for Approval'){
  upsert w.profile;
  }

  
}
update opp;
return new pagereference('/' + opp.id);
}


public pagereference opennewattachmentscreen(){
attachment = new attachment();
displayattachmentscreen = true;
displaynewattachmentbutton = true;
displayupdateattachmentbutton = false;
return null;
}

public pagereference openupdateattachmentscreen(){

deleteattachment = [select id, body, name, parentid from attachment where id = :attachmentid]; 
deleteattachment.body = null;
attachment = new attachment();
displayattachmentscreen = true;
displayupdateattachmentbutton = true;
displaynewattachmentbutton = false;

return null;
}

public pagereference savenewattachment(){

attachment.parentid = profileid;
if(attachmentvalid()){
  insert attachment;
  attachment.body = null;
  for(wrapper w:wrappers){
    if(w.profile.id == profileid){
      w.attachments.add(attachment);
    }
  }
  displayattachmentscreen = false;
}
return null;
}

public pagereference savereplaceattachment(){

attachment.parentid = deleteattachment.parentid;
if(attachmentvalid()){  
  delete deleteattachment;
  insert attachment;
  attachment.body = null;
  deleteattachment.body = null;
  
  for(wrapper w:wrappers){
    List<attachment> holder = new list<attachment>();
    holder.clear();
    for(attachment a:w.attachments){
      if(a.id != attachmentid){
        holder.add(a);
      }
      else { holder.add(attachment); }
    }
    w.attachments = holder;
  }

  displayattachmentscreen = false;
}
return null;
}

public boolean attachmentvalid(){

boolean returnvalue = true;

if(attachment.name == null){ 
  apexpages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: Attachment Name is null. Try again.'));
  returnvalue = false;
}
if(attachment.body == null){ 
  apexpages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: Attachment Body is null. Try again.'));
  returnvalue = false;
}
if(attachment.parentid == null){ 
  apexpages.addmessage(new ApexPages.Message(ApexPages.severity.ERROR, 'Error: Attachment ParentId is null. Try again.'));
  returnvalue = false;
}



return returnvalue;
}  

public pagereference cancelattachment(){
attachment = new attachment();
displayattachmentscreen = false;
return null;
}

public boolean getEstimated_Price_Rendered(){
  boolean returnvalue = false;
  for(Wrapper w:wrappers){
    if(w.getEstimated_Price_Rendered() == true){
      returnvalue = true;
    }
  }
  return returnvalue;
}

public boolean getPrice_Request_Rendered(){
  boolean returnvalue = false;
  for(Wrapper w:wrappers){
    if(w.getPrice_Request_Rendered() == true){
      returnvalue = true;
    }
  }
  return returnvalue;
}

public boolean getPrice_Unit_Rendered(){
  boolean returnvalue = false;
  for(Wrapper w:wrappers){
    if(w.getPrice_Unit_Rendered() == true){
      returnvalue = true;
    }
  }
  return returnvalue;
}

public boolean getRisk_Category_Rendered(){
  boolean returnvalue = false;
  for(Wrapper w:wrappers){
    if(w.getRisk_Category_Rendered() == true){
      returnvalue = true;
    }
  }
  return returnvalue;
}

public pagereference submitforapproval(){
if(submitid != ''){
  for(wrapper w:wrappers){
    if(w.profile.id == submitid){
    update w.profile;
    w.profile.stage__c = 'Pricing Submitted for Approval';
    w.profile.recordtypeid = RecordType_Functions.LookupRecordTypeId('Pricing Submitted for Approval', 'ES_Profile__c');
    }
  }
  Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
  req1.setComments('Submitting request for approval'); 
  req1.setObjectId(submitid);
  Approval.ProcessResult result = Approval.process(req1);
  submitid = '';
}
  return null;
}

public pagereference closepopup(){
  displaypopup = false;
  for(wrapper w:wrappers){
    if(w.profile.id == submitid){
      w.profile = [select id, recordtype.name, name, Account_Owner__c, Estimated_Price__c, Opportunity__c,  Price_Request__c,
            Price_Unit__c, Risk_Category__c,  Stage__c, Customer_Status_Group__c from ES_Profile__c where id = :submitid];
    }
  }
  submitid = '';
  return null;
  
}

public pagereference openpopup(){
  displaypopup = true;
  return null;
}

public class wrapper{

public ES_Profile__c profile{get; set;}
public List<Attachment> attachments{Get; set;}
public Attachment newattachment{get; set;}
private Set<String> PricingReadOnlyStages;
private Set<String> PricingRenderedStages;
public boolean getEstimated_Price_ReadOnly(){return (PricingReadOnlyStages.contains(profile.stage__c));}
public boolean getPrice_Request_ReadOnly(){return (PricingReadOnlyStages.contains(profile.stage__c));}
public boolean getPrice_Unit_ReadOnly(){return (PricingReadOnlyStages.contains(profile.stage__c));}
public boolean getRisk_Category_ReadOnly(){return (profile.stage__c == 'New Profile' || profile.stage__c == 'Pricing Submitted for Approval' || profile.stage__c == 'Pricing Approved' || profile.stage__c == 'Material Setup in SAP' || profile.stage__c == 'Pricing Rejected');}
public boolean getStage_ReadOnly(){return (profile.stage__c == 'Material Setup in SAP' || profile.stage__c == 'Pricing Submitted for Approval');}

public boolean getEstimated_Price_Rendered(){return (PricingRenderedStages.contains(profile.stage__c));}
public boolean getPrice_Request_Rendered(){return (PricingRenderedStages.contains(profile.stage__c));}
public boolean getPrice_Unit_Rendered(){return (PricingRenderedStages.contains(profile.stage__c));}
public boolean getRisk_Category_Rendered(){return (profile.Stage__c != 'New Profile');}

public boolean getRenderSubmit(){return (profile.stage__c == 'Profile Approved');}
public boolean getRenderApprove(){return (profile.stage__c == 'Pricing Submitted for Approval');}

public wrapper(ES_Profile__c p, List<attachment> a){

  profile = p;
  attachments = a;
  newattachment = new attachment();
  newattachment.parentid = p.id;
  PricingReadOnlyStages = new Set<String>{'Material Setup in SAP', 'Pricing Approved', 'Pricing Submitted for Approval', 'Submitted to WMS', 'New Profile', 'Profile Sent to Customer', 'Submitted to TSDF'};
  PricingRenderedStages = new Set<String>{'Material Setup in SAP', 'Profile Approved', 'Pricing Approved', 'Pricing Submitted for Approval'};
}

}

}