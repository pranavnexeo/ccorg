public with sharing class caseRedirect {

private ApexPages.StandardController controller;
public String retURL {get; set;}
public String saveNewURL {get; set;}
public String rType {get; set;}
public String cancelURL {get; set;}
public String ent {get; set;}
public String confirmationToken {get; set;}
public String accountID {get; set;}
public String contactID {get; set;}
public case mycase{get; set;}
Map<String, Schema.RecordTypeInfo> RTMap{get; set;}

public caseRedirect(ApexPages.StandardController controller) {

this.controller = controller;
mycase = (case)controller.getrecord();
RTMap = Case.sObjectType.getDescribe().getRecordTypeInfosByName();
retURL = ApexPages.currentPage().getParameters().get('retURL');
rType = ApexPages.currentPage().getParameters().get('RecordType');
cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
ent = ApexPages.currentPage().getParameters().get('ent');
confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
accountID = ApexPages.currentPage().getParameters().get('def_account_id');
contactID = ApexPages.currentPage().getParameters().get('def_contact_id');

}

public PageReference redirect(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page

IF(rType == RTMap.get('Nexeo Standard Incident').getrecordtypeid()) {
  if(accountid != null){
     returnURL = new PageReference('/apex/NCAR?aid=' + accountid);
  } else{
     returnURL = new PageReference('/apex/NCAR');
  }
}

else if(rtype == RTMAP.get('Nexeo Return').getrecordtypeid()){
  if(accountid != null){
     returnURL = new PageReference('/apex/NCAR_Return?aid=' + accountid + '&r=1');
  } else{
     returnURL = new PageReference('/apex/NCAR_Return?r=1');
  }
}

else if(rtype == RTMAP.get('Nexeo Credit Debit Claim').getrecordtypeid()){
  if(accountid != null){
     returnURL = new PageReference('/apex/NCAR_CDC?aid=' + accountid + '&c=1');
  } else{
     returnURL = new PageReference('/apex/NCAR_CDC?c=1');
  }
}

ELSE {

returnURL = new PageReference('/500/e');
returnURL.getParameters().put('retURL', retURL);
returnURL.getParameters().put('RecordType', rType);
returnURL.getParameters().put('cancelURL', cancelURL);
returnURL.getParameters().put('ent', ent);
returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
returnURL.getParameters().put('save_new_url', saveNewURL);
returnURL.getParameters().put('nooverride', '1');

IF (accountID != null){

returnURL.getParameters().put('def_account_id', accountID);

}

IF (contactID != null){

returnURL.getParameters().put('def_contact_id', contactID);

}

}
returnURL.setRedirect(true);
return returnURL;

}

public PageReference redirectedit(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page

rtype = [select recordtypeid from case where id = :mycase.id].recordtypeid;
IF(rType == RTMap.get('Nexeo Standard Incident').getrecordtypeid()) {
returnURL = new PageReference('/apex/NCAR?id=' + mycase.id);
}

else if(rtype == RTMAP.get('Nexeo Return').getrecordtypeid()){
returnURL = new PageReference('/apex/NCAR_Return?id=' + mycase.id + '&r=1');
}

else if(rtype == RTMAP.get('Nexeo Credit Debit Claim').getrecordtypeid()){
returnURL = new PageReference('/apex/NCAR_CDC?id=' + mycase.id + '&c=1');
}

ELSE {
returnURL = new PageReference('/' + mycase.id + '/e');
returnURL.getParameters().put('retURL', retURL);
returnURL.getParameters().put('nooverride', '1');
}
returnURL.setRedirect(true);
return returnURL;

}

public PageReference redirectview(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page

rtype = [select recordtypeid from case where id = :mycase.id].recordtypeid;

IF(rType == RTMap.get('Nexeo Standard Incident').getrecordtypeid()) {
returnURL = new PageReference('/apex/NCAR?id=' + mycase.id);
}

else if(rtype == RTMAP.get('Nexeo Return').getrecordtypeid()){
returnURL = new PageReference('/apex/NCAR_Return?id=' + mycase.id + '&r=1');
}

ELSE {
returnURL = new PageReference('/' + mycase.id);
returnURL.getParameters().put('nooverride', '1');
}
returnURL.setRedirect(true);
return returnURL;

}

}