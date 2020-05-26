//***This class is used to redirect PriceSupportRequest pages based on RecordType selection.
//*** Author @Rajeev

public with sharing class PriceSupportRequest_Redirect {
private ApexPages.StandardController controller;
public String retURL {get; set;}
public String rid {get; set;}
Map<String, Schema.RecordTypeInfo> RTMap{get; set;}
Public Price_Support_Request__c psr{get; set;}

public PriceSupportRequest_Redirect(ApexPages.StandardController controller) {
    this.controller = controller;
    psr = (Price_Support_Request__c)controller.getrecord();
    RTMap = Price_Support_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    }
public PageReference redirect(){
system.debug('Inside redirect');
    PageReference returnURL;
    rid = ApexPages.currentPage().getParameters().get('RecordType');
    system.debug('rid is: '+rid);
    retURL = ApexPages.currentPage().getParameters().get('retURL');
  if(ApexPages.currentPage().getParameters().containskey('RecordType')){
  system.debug('Inside loop');
    if(rid == RTMap.get('Rebate').getrecordtypeid()){
    returnURL = new PageReference('/apex/PriceSupportRequestRebate?rid='+rid+'&returl='+retURL);
    }
  else if(rid == RTMap.get('Upfront').getrecordtypeid()){
    returnURL = new PageReference('/apex/PriceSupportRequestUpfront?rid='+rid+'&returl='+retURL);
  }
  else{
    returnURL = null;
    }
   }
  return returnURL;
 }
 
//**** This method is used to override "View" on Price Support Request Object 
public PageReference ViewRedirect(){
    PageReference returnURL;
    rid = psr.recordtypeid;
    //returl = ApexPages.currentPage().getParameters().get('returl');
    returl= '%2Fa5i%2Fo';
  if(rid == RTMap.get('Rebate').getrecordtypeid()){   
    returnURL = new PageReference('/apex/PriceSupportRequestRebateView?id='+psr.id+'&rid='+rid+'&returl='+returl);
    }
  else if(rid == RTMap.get('Upfront').getrecordtypeid()){
    returnURL = new PageReference('/apex/PriceSupportRequestUpfrontView?id='+psr.id+'&rid='+rid+'&returl='+returl);
    }
  else{
    returnURL = null;
   }
  return returnURL;
 }
}