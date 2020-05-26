public with sharing class OppRedirect_New {

private ApexPages.StandardController controller;
public String retURL {get; set;}
public String saveNewURL {get; set;}
public String rType {get; set;}
public String cancelURL {get; set;}
public String ent {get; set;}
public String quote {get; set;}
public String confirmationToken {get; set;}
public String accountID {get; set;}
public String contactID {get; set;}
public Opportunity myopp{get; set;}
public String churnid;
public String entType;
public string chruntype;
public String CloneRec{get; set;}
Map<String, Schema.RecordTypeInfo> RTMap{get; set;}
Public Account a{get; set;}

public OppRedirect_New(ApexPages.StandardController controller) {
CloneRec = ApexPages.currentPage().getParameters().get('Clone');
churnid = apexpages.currentpage().getparameters().get('churnId');
system.debug('-------churnId-----'+churnid);
this.controller = controller;
myopp = (Opportunity)controller.getrecord();
system.debug('---myopp---'+myopp );
RTMap = Opportunity.sObjectType.getDescribe().getRecordTypeInfosByName();
system.debug('---RTMap ---'+RTMap );
retURL = ApexPages.currentPage().getParameters().get('retURL');
system.debug('---retURL---'+retURL);
rType = ApexPages.currentPage().getParameters().get('RecordType');
system.debug('---rtype---'+rType);
cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
system.debug('---cancelURL ---'+cancelURL );
ent = ApexPages.currentPage().getParameters().get('ent');
system.debug('---ent ---'+ent );
quote = ApexPages.currentPage().getParameters().get('quote');

system.debug('quote: ' + quote );
confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');
system.debug('---confirmationToken ---'+confirmationToken );
saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
system.debug('---saveNewURL ---'+saveNewURL );
accountID = ApexPages.currentPage().getParameters().get('accid');
system.debug('---accountID ---'+accountID);
contactID = ApexPages.currentPage().getParameters().get('conid');
system.debug('---contactID ---'+contactID);
chruntype=  ApexPages.currentPage().getParameters().get('enttype');
system.debug('enttype'+chruntype);
if(accountID != null){ a = [select id, name from Account where id = :AccountID]; }
system.debug('returl: ' + ApexPages.currentPage().getParameters().get('returl'));
system.debug('All Parameters: ' + apexPages.currentPage().getParameters());

if(ApexPages.currentPage().getparameters().containskey('id')){
system.debug('Inside 54');



   String i = ApexPages.currentpage().getparameters().get('id');
   system.debug('----i------' +i);

   myopp = [select id from Opportunity where id = :i limit 1];
   system.debug('----myopp ------' +myopp );
}
}

public PageReference redirectClone(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page

rtype = [select recordtypeid from Opportunity where id = :myopp.id].recordtypeid;
  system.debug('----rtype ------' +rtype);

IF(rType == RTMap.get('Distribution Plastics').getrecordtypeid() ||
   rType == RTMap.get('Distribution Plastics - TAG').getrecordtypeid()){
   returnURL = new PageReference('/apex/OpportunityNewPlastics?cf=' + myopp.id + '&rid=' + rType); 
  }  
ELSE IF(rType == RTMap.get('Distribution Targets').getrecordtypeid() ||
   rType == RTMap.get('Distribution Targets - TAG').getrecordtypeid()){
   returnURL = new PageReference('/apex/OpportunityComposite?cf=' + myopp.id + '&rid=' + rType); 
  }  
ELSE IF(rType == RTMap.get('Distribution Environmental Services').getrecordtypeid()){
   returnURL = new PageReference('/apex/OpportunityEnvService?cf=' + myopp.id + '&rid=' + rType);
  }
ELSE IF(rType == RTMap.get('Distribution Chemicals').getrecordtypeid()){
   returnURL = new PageReference('/apex/OpportunityArchwayChemicals?id=' + myopp.id + '&rid=' + rType + '&Clone=Yes');
  }

  
 
ELSE {

returnURL = new PageReference('/' + myopp.id + '/e');
returnURL.getParameters().put('clone', '1');
returnURL.getParameters().put('retURL', retURL);
returnURL.getParameters().put('nooverride', '1');
}
returnURL.setRedirect(true);
return returnURL;

}
public PageReference redirect(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page

if(ApexPages.currentPage().getParameters().containskey('RecordType')){
IF(rType == RTMap.get('Distribution Plastics').getrecordtypeid() ||
   rType == RTMap.get('Distribution Plastics - TAG').getrecordtypeid()){
  if(accountid != null && contactid != null){ returnURL = new PageReference('/apex/OpportunityNewPlastics?aid=' + accountid + '&rid=' + rType + '&cid=' + contactID +'&returl=' +retURL);}
  else{
  if(accountid != null){ returnURL = new PageReference('/apex/OpportunityNewPlastics?aid=' + accountid + '&rid=' + rType + '&returl=' +retURL);}
  else{ returnURL = new PageReference('/apex/OpportunityNewPlastics?rid=' + rType); }
  }
  }  
ELSE IF(rType == RTMap.get('Distribution Targets').getrecordtypeid() ||
   rType == RTMap.get('Distribution Targets - TAG').getrecordtypeid()){
  if(accountid != null && contactid != null){ returnURL = new PageReference('/apex/OpportunityComposite?aid=' + accountid + '&rid=' + rType + '&cid=' + contactID +'&returl=' +retURL +'&quote=' +quote);}
  else{
  if(accountid != null){ returnURL = new PageReference('/apex/OpportunityComposite?aid=' + accountid + '&rid=' + rType + '&returl=' +retURL +'&quote=' +quote);}
  else{ returnURL = new PageReference('/apex/OpportunityComposite?rid=' + rType); }
  }
  }  
ELSE IF(rType == RTMap.get('Distribution Environmental Services').getrecordtypeid()){
  if(accountid != null && contactid != null){ returnURL = new PageReference('/apex/OpportunityEnvService?aid=' + accountid + '&rid=' + rType + '&cid=' + contactID +'&returl=' +retURL);}
  else{
  if(accountid != null){ returnURL = new PageReference('/apex/OpportunityEnvService?aid=' + accountid + '&rid=' + rType + '&returl=' +retURL);}
  else{ returnURL = new PageReference('/apex/OpportunityEnvService?rid=' + rType); }
  }
}
ELSE IF(rType == RTMap.get('Distribution Plastics EMEA').getrecordtypeid()){
   returnURL = new PageReference('/006/e?retURL=%2F006%2Fo&RecordType=012E0000000LBl4&ent=Opportunity&nooverride=1');
  }
ELSE {
 
 if(accountid != null && ContactId != null){ 
     returnURL = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Opportunity&retURL=' + retURL + '&save_new_url=%2F006%2Fe%3FretURL%3D%252F006%252Fo&accid=' + AccountId + '&conid=' + ContactId);
 }
 else if(accountid != null){ 
    returnURL = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Opportunity&retURL=' + retURL + '&save_new_url=%2F006%2Fe%3FretURL%3D%252F006%252Fo&accid=' + AccountId);
    returnURL.getParameters().put('accid', AccountId);
 }
 else{ returnURL = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Opportunity&retURL=' + retURL + '&save_new_url=%2F006%2Fe%3FretURL%3D%252F006%252Fo'); }
}
}

/**ELSE {
returnURL = new PageReference('/006/e');
returnURL.getParameters().put('retURL', retURL);
returnURL.getParameters().put('RecordType', rType);
returnURL.getParameters().put('cancelURL', cancelURL);
returnURL.getParameters().put('ent', ent);
returnURL.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
returnURL.getParameters().put('save_new_url', saveNewURL);
returnURL.getParameters().put('nooverride', '1');
IF (accountID != null){ returnURL.getParameters().put('accid', accountID);}



ELSE {
 
 if(accountid != null && ContactId != null){ 
     returnURL = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Opportunity&retURL=' + retURL + '&save_new_url=%2F006%2Fe%3FretURL%3D%252F006%252Fo&accid=' + AccountId + '&conid=' + ContactId);
 }
 else if(accountid != null){ 
    returnURL = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Opportunity&retURL=' + retURL + '&save_new_url=%2F006%2Fe%3FretURL%3D%252F006%252Fo&accid=' + AccountId);
    returnURL.getParameters().put('accid', AccountId);
 }
 else{ returnURL = new PageReference('/setup/ui/recordtypeselect.jsp?ent=Opportunity&retURL=' + retURL + '&save_new_url=%2F006%2Fe%3FretURL%3D%252F006%252Fo'); }
}
}**/

if((ApexPages.currentPage().getParameters().containskey('RecordType'))&& churnid!='' && chruntype =='churn'){
IF(rType == RTMap.get('Distribution Plastics').getrecordtypeid() ||
   rType == RTMap.get('Distribution Plastics - TAG').getrecordtypeid()){
  if(accountid != null && contactid != null){ returnURL = new PageReference('/apex/OpportunityNewPlastics?aid=' + accountid + '&rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype + '&cid=' + contactID +'&returl=' +retURL);}
  else{
  if(accountid != null){ returnURL = new PageReference('/apex/OpportunityNewPlastics?aid=' + accountid + '&rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype + '&returl=' +retURL);}
  else{ returnURL = new PageReference('/apex/OpportunityNewPlastics?rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype + '&returl=' +retURL); }
  }
  }  
ELSE IF(rType == RTMap.get('Distribution Targets').getrecordtypeid() ||
   rType == RTMap.get('Distribution Targets - TAG').getrecordtypeid()){
  if(accountid != null && contactid != null){ returnURL = new PageReference('/apex/OpportunityComposite?aid=' + accountid + '&rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype + '&cid=' + contactID +'&returl=' +retURL);}
  else{
  if(accountid != null){ returnURL = new PageReference('/apex/OpportunityComposite?aid=' + accountid + '&rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype +'&returl=' +retURL);}
  else{ returnURL = new PageReference('/apex/OpportunityComposite?rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype +'&returl=' +retURL); }
  }
  }  
ELSE IF(rType == RTMap.get('Distribution Environmental Services').getrecordtypeid()){
  if(accountid != null && contactid != null){ returnURL = new PageReference('/apex/OpportunityEnvService?aid=' + accountid + '&rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype + '&cid=' + contactID +'&returl=' +retURL);}
  else{
  if(accountid != null){ returnURL = new PageReference('/apex/OpportunityEnvService?aid=' + accountid + '&rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype + '&returl=' +retURL);}
  else{ returnURL = new PageReference('/apex/OpportunityEnvService?rid=' + rType  + '&churnid=' + churnid + '&chruntype=' + chruntype + '&returl=' +retURL); }
  }
  }  

}

returnURL.setRedirect(true);
system.debug('Return URL: ' + returl);
return returnURL;

}

public PageReference redirectedit(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page

boolean issubmitted = Approval_Functions.issubmitted(myopp.id);
boolean isapprover = true; 
if(issubmitted == true){ isapprover = approval_functions.isapprover(userinfo.getuserid(), myopp.id); }
system.debug('----------------210---'+userinfo.getuserid());
system.debug('----------------211---'+myopp.id);
system.debug('issubmitted: ' + issubmitted);
system.debug('isapprover: ' + isapprover);
if(rType==''|| rType==null){
rtype = [select recordtypeid from Opportunity where id = :myopp.id].recordtypeid;
system.debug('Record Type: ' + rtype);
}
IF(rType == RTMap.get('Distribution Plastics').getrecordtypeid() ||
   rType == RTMap.get('Distribution Plastics - TAG').getrecordtypeid()){
  if(isapprover == false){ returnURL = new pagereference('/' + myopp.id + '&rid=' + rType); }
else{ returnURL = new PageReference('/apex/OpportunityNewPlastics?id=' + myopp.id + '&rid=' + rType);  }
  }  
ELSE IF(rType == RTMap.get('Distribution Targets').getrecordtypeid() ||
   rType == RTMap.get('Distribution Targets - TAG').getrecordtypeid()){
  if(isapprover == false){ returnURL = new pagereference('/' + myopp.id + '&rid=' + rType); }
else{ returnURL = new PageReference('/apex/OpportunityComposite?id=' + myopp.id + '&rid=' + rType);  }
  }  
ELSE IF(rType == RTMap.get('Distribution Environmental Services').getrecordtypeid()){
  if(isapprover == false){ returnURL = new pagereference('/' + myopp.id + '&rid=' + rType); }
else{ returnURL = new PageReference('/apex/OpportunityEnvService?id=' + myopp.id + '&rid=' + rType);  }
  }
else if(rType == RTMap.get('Distribution Chemicals').getrecordtypeid()){
    returnURL = new pagereference('/apex/OpportunityArchwayChemicals?id=' + myopp.id + '&rid=' + rType);
}  
  
ELSE {
returnURL = new PageReference('/' + myopp.id + '/e');
returnURL.getParameters().put('retURL', retURL);
returnURL.getParameters().put('nooverride', '1');
returnURL.getParameters().put('RecordType',rType);
}
returnURL.setRedirect(true);
return returnURL;

}

public PageReference redirectview(){

PageReference returnURL;

// Redirect if Record Type corresponds to custom VisualForce page

rtype = [select recordtypeid from Opportunity where id = :myopp.id].recordtypeid;

IF(rType == RTMap.get('Distribution Plastics').getrecordtypeid() ||
   rType == RTMap.get('Distribution Plastics - TAG').getrecordtypeid()){
   returnURL = new pagereference('/apex/OpportunityPlasticView?id=' + myopp.id + '&retURL=' + rType); 
  }  
ELSE IF(rType == RTMap.get('Distribution Targets').getrecordtypeid() ||
   rType == RTMap.get('Distribution Targets - TAG').getrecordtypeid()){
   returnURL = new pagereference('/apex/OpportunityCompView?id=' + myopp.id + '&retURL=' + rType); 
  }  
ELSE IF(rType == RTMap.get('Distribution Environmental Services').getrecordtypeid()){
   returnURL = new pagereference('/apex/OpportunityEnvSerView?id=' + myopp.id + '&retURL=' + rType); 
  }
ELSE {
returnURL = new PageReference('/' + myopp.id);
returnURL.getParameters().put('nooverride', '1');
}
returnURL.setRedirect(true);
return returnURL;
}

}