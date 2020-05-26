public with sharing class caseRedirect_New {

private ApexPages.StandardController controller;
public String retURL {get; set;}
public String saveNewURL {get; set;}
public String rType {get; set;}
public String cancelURL {get; set;}
public String ent {get; set;}
public String confirmationToken {get; set;}
public String accountID {get; set;}
public String contactID {get; set;}
public NCAR_Cases__c mycase{get; set;}
Map<String, Schema.RecordTypeInfo> RTMap{get; set;}
Public Account a{get; set;}

public caseRedirect_New(ApexPages.StandardController controller) {

this.controller = controller;
mycase = (NCAR_Cases__c)controller.getrecord();
RTMap = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
retURL = ApexPages.currentPage().getParameters().get('retURL');
rType = ApexPages.currentPage().getParameters().get('RecordType');
cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
ent = ApexPages.currentPage().getParameters().get('ent');
confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');

accountID = retURL.substring(1,retURL.length());//ApexPages.currentPage().getParameters().get('CF00NE0000000lB93_lkid')

system.debug('accountID: ' + accountID);

if(accountID != null && accountID.startswith('001')){
    
        a = [select id, name from Account where id = :AccountID]; 
    
}
system.debug('returl: ' + ApexPages.currentPage().getParameters().get('returl'));

if(ApexPages.currentPage().getparameters().containskey('id')){
   String i = ApexPages.currentpage().getparameters().get('id');
   mycase = [select id from NCAR_Cases__c where id = :i limit 1];
}
}

public PageReference redirect(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page
IF(rType == RTMap.get('Nexeo Standard Incident').getrecordtypeid()) {
  if(accountID != null && accountID.startswith('001')){
     returnURL = new PageReference('/apex/NCAR2?aid=' + accountid);
  } else{
      system.debug('come here===');
     returnURL = new PageReference('/apex/NCAR2');
  }
}

else if(rtype == RTMAP.get('Nexeo Return').getrecordtypeid()){
  if(accountID != null && accountID.startswith('001')){
     returnURL = new PageReference('/apex/NCAR_Return2?aid=' + accountid + '&r=1');
  } else{
     returnURL = new PageReference('/apex/NCAR_Return2?r=1');
  }
}

else if(rtype == RTMAP.get('Nexeo Credit Debit Claim').getrecordtypeid()){
  if(accountID != null && accountID.startswith('001')){
     returnURL = new PageReference('/apex/NCAR_CDC2?aid=' + accountid + '&c=1');
  } else{
     returnURL = new PageReference('/apex/NCAR_CDC2?c=1');
  }
}

ELSE {

string strPrefix = NCAR_Cases__c.sobjecttype.getDescribe().getKeyPrefix();
    returnURL = new PageReference('/'+strPrefix+'/e');//new PageReference('/a45/e');
returnURL.getParameters().put('retURL', retURL);
returnURL.getParameters().put('RecordType', rType);
returnURL.getParameters().put('cancelURL', cancelURL);
returnURL.getParameters().put('ent', ent);
returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
returnURL.getParameters().put('save_new_url', saveNewURL);
returnURL.getParameters().put('nooverride', '1');

IF (accountID != null && accountID.startswith('001') ){

returnURL.getParameters().put('CF00NE0000000lB93_lkid', accountID);

returnURL.getParameters().put('CF00NE0000000lB93', a.name);

}

}
returnURL.setRedirect(true);
return returnURL;

}

public PageReference redirectedit(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page

rtype = [select recordtypeid from NCAR_Cases__c where id = :mycase.id].recordtypeid;

IF(rType == RTMap.get('Nexeo Standard Incident').getrecordtypeid()) {
returnURL = new PageReference('/apex/NCAR2?id=' + mycase.id);
}

else if(rtype == RTMAP.get('Nexeo Return').getrecordtypeid()){
returnURL = new PageReference('/apex/NCAR_Return2?id=' + mycase.id + '&r=1');
}

else if(rtype == RTMAP.get('Nexeo Credit Debit Claim').getrecordtypeid()){
returnURL = new PageReference('/apex/NCAR_CDC2?id=' + mycase.id + '&c=1');
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

rtype = [select recordtypeid from NCAR_Cases__c where id = :mycase.id].recordtypeid;

IF(rType == RTMap.get('Nexeo Standard Incident').getrecordtypeid()) {
returnURL = new PageReference('/apex/NCAR2?id=' + mycase.id);
}

else if(rtype == RTMAP.get('Nexeo Return').getrecordtypeid()){
returnURL = new PageReference('/apex/NCAR_Return2?id=' + mycase.id + '&r=1');
}

ELSE {
returnURL = new PageReference('/' + mycase.id);
returnURL.getParameters().put('nooverride', '1');
}
returnURL.setRedirect(true);
return returnURL;

}

}