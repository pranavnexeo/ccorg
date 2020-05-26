/*@LAB Project
 *Author @ Rajeev S
 *Class to control all the VF pages related to R&D Requests object
 *Also contains wrapper class for displaying multiple look up fields on this object
 *Custom save
 *Cloned records
 *Custom button functionality
 *Defaultified values 
 *Test method in "R&D Object function test" class
 **START*****
*/

public with sharing class RDExtensionController {
    
    //***Initializing variables***
    public R_D_Requests__c myRec{get; set;}
    public String CloneRec{get; set;}
    public String  recTypeId {get; set;}
    public String pageName {get; set;}
    public ApexPages.StandardController controller{get; set;}
    public List<R_D_Material__c> lstAcct  = new List<R_D_Material__c>(); 
    public List<R_D_Material__c> SndAcct = new List<R_D_Material__c>();
    public List<R_D_Material__c> rdrList;
    public List<innerClass> lstInner{get;set;} //List of the inner class
    public boolean RequiredMaterial{get;set;} //Variable to make field required
    public String selectedRowIndex{get;set;} //Will indicate the row to be deleted
    public string isEdit; //To check if the record in new or existing 
    public Integer count; //no. of rows added/records in the inner class list
    public R_D_Requests__c myRecCloned;
    public string basecode{get;set;}
    
    /*Constructor
     *Pre-Initialize some values.
    */
    public RDExtensionController(ApexPages.StandardController controller) {
        this.controller = controller;
         myRec = (R_D_Requests__c)controller.getrecord();
          lstInner = new List<innerClass>(); //Initialize list of inner class
           rdrList = [Select Id, Request__c,Base_Code__c,Base_Code_Description__c, Base_Code__r.Material_Base_Code_Description__c from R_D_Material__c where Request__c = :myRec.Id]; //Get the list of child records already associated with the record.
            count = 0;
             if(rdrList != null && rdrList.size()>0){
              count = rdrList.size()-1;
            for(Integer i=0;i<rdrList.size();i++){
             innerClass objInner = new innerClass(i,rdrList[i]); //Initialize inner class
              lstInner.add(objInner);
            }
         }
        
        isEdit = ApexPages.currentPage().getParameters().get('edit'); //..to check if the record is new or old.
         if(isEdit == 'false'){
          addMore(); //..to show at least one material look up field on the page.
         }
        selectedRowIndex = '0';
        RequiredMaterial = true;
        
        /*For cloned records*/
        CloneRec = ApexPages.currentPage().getParameters().get('Clone'); //To check if the record in context is cloned
         recTypeId = ApexPages.currentPage().getParameters().get('rid');
        
          if(myrec.recordtypeid == null && recTypeId != null && recTypeId != '')
           myrec.recordtypeid = recTypeId;
            pageName = Apexpages.currentPage().getUrl();
          if(myrec.Requestor__c == null && myrec.id == null)
           myrec.requestor__c = userinfo.getuserid();   
           
         /*Used by custom button on Opportunity - Start
         *Pre-populates fields
        */  
        String OppId = ApexPages.currentPage().getParameters().get('OppId');
  
         if(OppId != null && myRec.Opportunity__c == null){
          populateDetails(OppId);
           
         }
         SYSTEM.DEBUG('lstInner IS :' +lstInner);
     }
    //***End Constructor***
    
    /*Populate important fields*/
    public void populateDetails(String OppId){ 
       myRec.Opportunity__c = OppId;
        Opportunity opprec = [Select Id,AccountId,SAP_Material__c, SAP_Material__r.Material_General_Data__r.Material_Base_Code__c from Opportunity where Id = :OppId];
         myRec.Customer__c = opprec.AccountId;
     if(opprec.SAP_Material__r.Material_General_Data__r.Material_Base_Code__c != null){
      for(Integer j = 0;j<lstInner.size();j++){
           lstInner[j].acct.Base_Code__c = opprec.SAP_Material__r.Material_General_Data__r.Material_Base_Code__c;
         }       
      }                                                             
    updateList();
    }
    
    /*Method to make Material lookup field required */
    public void MakeRequired(){
     String makerequired = ApexPages.currentPage().getParameters().get('makerequired');
      if(makerequired == 'true'){
       RequiredMaterial = false; 
        }else{
         RequiredMaterial = true;
       }
     }
    
    
    /*Method called by "Add Material" button*/
    //To open MultiLookUp fields
    public void Add(){
     count = count+1;
      addMore();      
    }
    
   
   /*Begin addMore*/
   public void addMore(){
     innerClass objInnerClass = new innerClass(count,null); //Call to the inner class constructor
       lstInner.add(objInnerClass); //Add the record to the inner class list        
    }
    
   
    /*Begin delete*/
    public void Del(){
     lstInner.remove(Integer.valueOf(selectedRowIndex));
      //Reordering Innerlist.
       for(Integer i=0;i<lstInner.size();i++){
         lstInner[i].recCount = String.ValueOf(i);
       }
          count = count - 1;
     }
   
   
    //***Method to query Base Code Description on change to material list
    public void updateList(){
       List<Id> basecodeids = new List<Id>();
       for(InnerClass ic : lstInner){
         if(ic.acct.base_code__c != null)
           basecodeids.add(ic.acct.base_code__c);
       }
       Map<Id, Material_Base_Code__c> bcmap = new Map<Id, Material_Base_Code__c>
          ([Select Id, Material_base_Code_Description__c from Material_Base_Code__c where id IN :basecodeids]);
       
       for(InnerClass ic:lstInner)
         if(bcmap.containskey(ic.acct.base_code__c))
         {
           ic.acct.Base_Code_Description__c = bcmap.get(ic.acct.base_code__c).Material_base_Code_Description__c;
         }
    }
    
    
    //***Custom save method***
    //Called by all the pages
    //Includes "clone" functionality also
     public pagereference customSave(){
      PageReference pr;
       if(CloneRec == 'Yes'){
           myRecCloned = myRec.Clone(false,true);
            if(pageName.contains('Customer')){
                 myRecCloned.Stage__c = 'Stage 0 - Initiate';
                  myRecCloned.recordtypeid = recTypeId;
                if(myRecCloned.Opportunity__c != null){
                  myRecCloned.Customer__c = [Select Id,AccountId from Opportunity where Id = :myRecCloned.Opportunity__c].AccountId;
                 }  
             }
            
            else if(pageName.contains('Innovation')) {
                 myRecCloned.Stage__c = 'Stage 0 - Concept';
                  myRecCloned.recordtypeid = recTypeId;
             }
        try{
         insert myRecCloned;
         }catch(DmlException e){
          System.debug('The following exception has occurred: ' + e.getMessage());
        }
        
        for(Integer j = 0;j<lstInner.size();j++){
           lstInner[j].acct.Request__c = myRecCloned.Id;
            lstAcct.add(lstInner[j].acct);
        }
       
        if(lstAcct != null && lstAcct.size()>0){  
          upsert lstAcct;
         }
        
        pr = new PageReference('/' + myRecCloned.Id); 
       }
      
      
      else{
       myRec.Recordtypeid = recTypeId;
        if((myRec.Opportunity__c != null) && (pageName.contains('Customer'))){
         myRec.Customer__c = [Select Id,AccountId from Opportunity where Id = :myRec.Opportunity__c].AccountId;
        }
      controller.save();
      SYSTEM.DEBUG('CONTROLLER ID IS: '+controller.getId()); 
      for(Integer j = 0;j<lstInner.size();j++){
       if(lstInner[j].acct.Request__c == null && lstInner[j].acct.Base_Code__c != null){
        lstInner[j].acct.Request__c = controller.getId();
         lstAcct.add(lstInner[j].acct);
          }else if((lstInner[j].acct.Base_Code__c != null) && lstInner[j].acct.Request__c != null){
            lstInner[j].acct.Request__c = controller.getId();
              SndAcct.add(lstInner[j].acct);
            }
          }
      if(lstAcct != null && lstAcct.size()>0){  
        insert lstAcct;
         }
      if(SndAcct != null && SndAcct.size()>0 ){
        update SndAcct;
         }   
        
      pr = new PageReference('/' + controller.getId());
     }
     
     pr.setRedirect(True);
     return pr;
     
    }

   
    //***Inner classs***
    public class innerClass{       
      //*recCount acts as a index for a row. This will be helpful to identify the row to be deleted */
       public String recCount{get;set;}
       public R_D_Material__c acct {get;set;}
       /*Inner Class Constructor*/
       public innerClass(Integer intCount,R_D_Material__c rmat){
          recCount = String.valueOf(intCount);
            if(rmat!=null){
                acct = rmat;
            }else{
                acct = new R_D_Material__c();   
            }
        }/*End Inner class Constructor*/    
    }/*End inner Class*/

}//***End Class***