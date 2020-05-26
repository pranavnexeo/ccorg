/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:         02/08/2016
*    Author:             Sneha Likhar
*   Short Description:  When Capa will create from NCAR then Ncar CAPA lookup will update with created CAPA 
*   **********************************************************************************************************************/


public without sharing class CreateCAPAupdateNCARController{

public NCAR_Cases__c ncar{get;set;}
public CAPA__c capa{get;set;}
List <NCAR_Cases__c> ncarlist = new List <NCAR_Cases__c>();
public id capaid{get;set;}
public id ncarid{get;set;}

    ApexPages.StandardController controller;
    public CreateCAPAupdateNCARController(ApexPages.StandardController controller) {
    this.controller = controller;
    this.capa= (CAPA__c)controller.getRecord();
    ncarid = apexpages.currentpage().getparameters().get('ncarid');
      
    }
    
  
    
    public pagereference customsave(){
            if(Approval.isLocked(ncarid)){
            PageReference pageRef = null;
            pageref = controller.save();
            capaid= controller.getId();
            ncarlist = [select id, CAPA__c from NCAR_Cases__c where id =:ncarid];  
            Approval.unLockResult[] lrList = Approval.unlock(ncarlist, false);   
            if(ncarlist.size()>0)
                   { 
                   ncarlist[0].CAPA__c = capaid;
                   update ncarlist;
                   Approval.LockResult[] lroList = Approval.lock(ncarlist, false);   
                   } 
            return pageref;
            }
            else if(!Approval.isLocked(ncarid)){
                PageReference pageRef = null;
                pageref = controller.save();
                capaid= controller.getId();
               
                if(ncarlist.size()>0)
                   { 
                   ncarlist[0].CAPA__c = capaid;
                   update ncarlist;         
                   } 
            return pageref;
           }
           else{
           return null;
           }
    }

}