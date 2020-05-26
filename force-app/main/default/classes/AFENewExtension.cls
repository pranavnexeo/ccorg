public with sharing class AFENewExtension {

   public boolean displayPopup {get; set;} 
   Public boolean displayList {get;set;}
   public String numberOfLevel{get;set;}
   public integer counter{get;set;}
   public String approverView{get;set;}
   public Map<integer,List<Id>> approversMap; 
   public Boolean isChangeField{get;set;}
   public Authorization_for_Expenditure__c AFE{get;set;}
   public List<Budget_Item__c> BudgetList= new List<Budget_Item__c>();
   public List<AFE_approvers__c> afeAppList;
    public ApexPages.StandardController controller{get;set;}
    public Authorization_for_Expenditure__c authForExp{get;set;}   
    public Authorization_for_Expenditure__c authForExp1{get;set;} 
    private final ApexPages.StandardController AFEController;
    public Integer Total = 0;
    public Integer supplementNumCount = 1;
    public String check{get;set;}
    public AFENewExtension(){ }

    
    public String projectCharter{get;set;}
    public String businessCase{get;set;}
    public String wbsStruct{get;set;}
    public String otherSupportDoc{get;set;}
    
    public Blob projectCharterBody{get;set;}
    public Blob businessCaseBody{get;set;}
    public Blob wbsStructBody{get;set;}
    public Blob otherSupportDocBody{get;set;}
    
    private List<Attachment> attachedDocs {get;set;}
    
      public void saveAttachment(Id parent){
       List<Attachment> files  = new  List<Attachment>(); 
       System.debug('*****************Inside Save Attachment***************');
        if(projectCharter!=null && projectCharterBody!=null){
             System.debug('*****************Inside project charter Save***************');
            files.add(createAttachmentObject(projectCharterBody,'Project Charter',parent));
        }
        if(businessCase!=null && businessCaseBody!=null){
             files.add(createAttachmentObject(businessCaseBody,'Business Case Justification',parent));
        }
        if(wbsStruct!=null && wbsStructBody!=null){
            files.add(createAttachmentObject(wbsStructBody,'WBS Structure',parent));
        }
        if(otherSupportDoc!=null && otherSupportDocBody!=null){
            files.add(createAttachmentObject(otherSupportDocBody,'Other Supporting Document',parent));
        }
      upsert files;
    }
    
    public Attachment createAttachmentObject(Blob filebody,String fileName,Id parent){
         System.debug('*****************Inside Create attachement object***************');
        if(attachedDocs==null){
             System.debug('*****************Inside new Attachment, attachedDocs=NULL***************');
            Attachment file = new Attachment();
            file.Body=filebody;
            file.Name=fileName;
            file.ParentId=parent;
        return file;
        }else {
        //Boolean found = false;
         System.debug('*****************Inside attachedDocs ! NULL***************');
           for(Attachment file : attachedDocs){
               if(file.Name==fileName){
                    file.Body=filebody;
                   // found=true;
                    System.debug('*****************Inside Save Attachment FOUND FILE***************');
                    return file;
               }
           }
            Attachment file = new Attachment();
            file.Body=filebody;
            file.Name=fileName;
            file.ParentId=parent;
             System.debug('*****************Inside Save Attachment FILE NOT FOUND CREATE NEW***************');
        return file;
        }
    }
 
    
     public AfeNewExtension(ApexPages.StandardController controller) {
           this.controller=controller;
           afeAppList = new List<AFE_approvers__c>();
       this.authForExp=(Authorization_for_Expenditure__c)controller.getRecord();
      
       ID id = ApexPages.currentPage().getParameters().get('id');
       AFEController = controller;
        numberOfLevel='1';
        approversMap = new Map<integer,List<Id>>();
        authForExp.AFE_Class1__c='Non-Budgeted';
        if(id!=null){
        AFE = [Select authFE.Prior_AFEs_Approved__c, authFE.Prior_AFEs_Pending_Approval__c,authFE.Total_Prior_AFE_Amount__c, authFE.AFE_Class1__c,authFE.Budget_Number__c,authFE.Levels_Of_Approval_Required__c, authFE.Approver1__c, authFE.Approver2__c, authFE.Approver3__c,authFE.Approver4__c, authFE.Approver5__c, authFE.Approver6__c, authFE.Approver7__c, authFE.Approver8__c, authFE.Approver9__c, authFE.Approver10__c, authFE.Approver11__c, authFE.Approver12__c, authFE.Approver13__c, authFE.Approver14__c, authFE.Approver15__c from Authorization_for_Expenditure__c authFE where authFE.Id = :id]; 
        authForExp = AFE;
        authForExp.AFE_Class1__c=AFE.AFE_Class1__c;
        if(AFE.Budget_Number__c!=null)
        //authForExp.AFE_Class1__c='Budgeted';
            displayList =true;
        afeAppList = [Select a.Level__c, a.Key__c, a.Id, a.Authorization_for_Expenditure__c, a.Approver_5__c, a.Approver_4__c, a.Approver_3__c, a.Approver_2__c, a.Approver_1__c From AFE_approvers__c a where a.Authorization_for_Expenditure__c=:id];
        numberOfLevel=AFE.Levels_Of_Approval_Required__c;
        populateApproverMapforEdit();
        retrieveApproversFromMap(1);
        try{
            attachedDocs = [Select a.ParentId, a.Name, a.Id From Attachment a where a.ParentId = :id ];
            System.debug('*****************Saved Attachment***************'+ attachedDocs );
           }catch (system.queryexception ex){
                System.debug('*****************Inside Attachment Query Exception***************');
            }
        }
        counter=1;
     
    }
    
    
    
    
        public List<Authorization_for_expenditure__c> getSupNumRec(){
                String AfeNum=Apexpages.currentPage().getParameters().get('AfeSup'); 
                System.debug('---@@@@Inside Get Rec@@@-----');
                system.debug('---@@@value of recnUm----@@@@'+AfeNum);
                // Get the supplement AFE record using record name
               try{
               Authorization_for_expenditure__c selectedSupplementAFE = [SELECT ID, NAME,AFE_For_suppliment__c, Supplement__c, Origination_type__c, Status__c FROM Authorization_for_expenditure__c where Authorization_for_expenditure__c.Name= :AfeNum LIMIT 1];
                
                System.debug('----@@@@count is----@@@@'+selectedSupplementAFE );
                //for(Authorization_for_expenditure__c AuthEx: AFEcheck){
                System.debug('----@@@AF.Suppliment@@@@----'+selectedSupplementAFE.AFE_for_Suppliment__c);
                    
                //Check the current AFE record, to see if it is supplement for any other AFE
                    List<Authorization_for_expenditure__C> AFEasSupplementList = [SELECT ID, NAME,AFE_For_suppliment__c, Supplement__c, Origination_type__c, Status__c, USD_Total_Amount__c, Prior_Supps_Approved__c,AFE_Class1__c,This_AFE_Amount__c   FROM Authorization_for_expenditure__c where Authorization_for_expenditure__c.AFE_for_Suppliment__c= :selectedSupplementAFE.ID];
                
                // Count the number of such AFE's whose  supplement is the currently selected AFE
                
                    supplementNumCount = [select Count() from Authorization_for_Expenditure__c where Status__c != 'Cancelled' AND Origination_Type__c = 'Supplement' AND Authorization_for_expenditure__c.AFE_for_Suppliment__c= :selectedSupplementAFE.ID];
                    System.debug('----@@@@count is----@@@@'+AFEasSupplementList   );
                        if(supplementNumCount == 0){
                            supplementNumCount = 1;
                         }
                    //
                   // For each AFE using selected AFE as supplement check if it is Rejected or Cancelled
                   // If yes then throw error
                   // else 
                   // if it is Approved or Completed & Accepted or Pending Close out Approval
                   // then add the value of USD total Amount
                  //         
                      for(Authorization_for_expenditure__c AFEusingThisSupplement : AFEasSupplementList){          
                          if(AFEusingThisSupplement.Origination_type__c == 'Supplement'){
                                if(AFEusingThisSupplement.Status__c == 'Rejected' || AFEusingThisSupplement.Status__c == 'Cancelled'){
                                    System.Debug('----@@@@@inside if for getsup----@@@@@');
                                    //AFEusingThisSupplement.addError('An UnApproved Supplement is already in process.  You must first have that supplement approved before creating a new supplement');
                                    sendPageMessage('An UnApproved Supplement is already in process.  You must first have that supplement approved before creating a new supplement');
                                    return null;
                                } 
                                else{
                                    System.Debug('Suppliment after increment'+authForExp.Supplement__c);
                            
                                    if(AFEusingThisSupplement.Status__c == 'Approved' || AFEusingThisSupplement.Status__c == 'Completed & Accepted'|| AFEusingThisSupplement.Status__c == 'Pending CloseOut Approval' ){
                                         Total = Total + Integer.valueOf(AFEusingThisSupplement.This_AFE_Amount__c); 
                                         authForExp.Prior_Supps_Approved__c = Total;
                                         System.Debug('######Total is ####'+Total);
                                    }
                                }
                           }
                            System.debug('++++++++Final Total is++++++ '+Total);
                            System.debug('++++++++Final Prior sup++++++ '+AFEusingThisSupplement.Prior_Supps_Approved__c);
                     }
                //}    
                }catch(System.QueryException ex){
                }                
              return null;
        }
      
      
        
        
       public PageReference saveSupplement()
        {
            getAFEClassRec();
            AFEController.save();
            return null;
         }
      
      public PageReference getAFEClassRec(){
        
        String BudgetNum=Apexpages.currentPage().getParameters().get('BudgetItem'); 
        
                if(check==null || check=='')
                 authForExp.AFE_Class1__c='Non-Budgeted';
                else
                 authForExp.AFE_Class1__c='Budgeted';
       /*try{         
       Budget_Item__c budgetItem = [select Id from Budget_Item__c where name = : BudgetNum]; 
       calculatePriorFields(budgetItem.Id);
       
       }catch(System.QueryException e){
       } */        
                 
                 
                 
                system.debug('%%%%%%%%%%%%%%%AFECLASSS%%%%%%%%%'+ authForExp.AFE_Class1__c);
                return null;
        }
        
      /* This function will calculate the prior fields in AFE depending on the selected Budget Item*/
      public void calculatePriorFields(Id budgetId){
      System.debug('*****************Inside Calculate Prior fields******************************');
          try{
          /*Get the list of AFE which are related to the selected budget Item */
              List<Authorization_for_Expenditure__c> priorAFEapprovedList = [select a.USD_Total_Amount__c,a.Status__c from Authorization_for_Expenditure__c a where a.Budget_Number__c = : budgetId and a.Id != : authForExp.Id];
          /*For each record check its status and do the necessary calculations */ 
          authForExp.Prior_AFEs_Approved__c=0; 
          authForExp.Prior_AFEs_Pending_Approval__c=0;
          
              for(Authorization_for_Expenditure__c priorAFEapproved : priorAFEapprovedList){
              
                                    
         /*calculate Prior AFEs Approved*/        
                  if(priorAFEapproved.Status__c=='Approved'||priorAFEapproved.Status__c=='Completed & Accepted'){
                      System.debug('*****************Inside Status approved******************************');
                      authForExp.Prior_AFEs_Approved__c = authForExp.Prior_AFEs_Approved__c+priorAFEapproved.USD_Total_Amount__c;
                  }
         /*calculate Prior AFEs pending approval*/  
                  if(priorAFEapproved.Status__c=='Pending Approval'){
                      System.debug('*****************Inside Status pending******************************');
                      authForExp.Prior_AFEs_Pending_Approval__c=authForExp.Prior_AFEs_Pending_Approval__c+priorAFEapproved.USD_Total_Amount__c;
                  }
       
              }
              
          /*calculate Total prior AFE amount*/ 
          authForExp.Total_Prior_AFE_Amount__c=0;
             authForExp.Total_Prior_AFE_Amount__c = authForExp.Prior_AFEs_Approved__c + authForExp.Prior_AFEs_Pending_Approval__c;
             System.debug('*****************Total_Prior_AFE_Amount__c ,authForExp.Prior_AFEs_Approved__c, authForExp.Prior_AFEs_Pending_Approval__c******************************');
             System.debug(authForExp.Total_Prior_AFE_Amount__c+authForExp.Prior_AFEs_Approved__c+authForExp.Prior_AFEs_Pending_Approval__c);
          }catch(System.QueryException ex){
          }
    
      }
      
        
      public PageReference getNumRecord(){
        
        String BudgetNum=Apexpages.currentPage().getParameters().get('BudgetItem'); 

                
                
                Integer bs  = [SELECT Count() FROM Authorization_for_expenditure__c where Budget_Number__r.Name = :BudgetNum];
                
                if(bs > 0){
                    
                    displayList = TRUE;
                  
                }
                else{
                  
                    displayList = FALSE;
                
                  
                }
                
                return null;
        }
      
    
    public void closePopup() {        
        displayPopup = false;    
    }     
    public void showPopup() {        

        displayPopup = true;    
        /*PageReference p = ApexPages.currentPage();
      p.getParameters().put('success','true');
      p.getParameters().put('id',Apexpages.currentPage().getParameters().get('id'));
      
       p.setRedirect(true);
       return p;*/
    }
    
  
    
   
    public PageReference saveRecord(){
        authForExp.Levels_Of_Approval_Required__c=numberOfLevel;
            if(checkIsBlank()){
        ID id = ApexPages.currentPage().getParameters().get('id');
        authForExp.Prior_Supps_Approved__c = Total;
        authForExp.Supplement__c = supplementNumCount;
        System.debug('In save rec testing total'+total);
        System.debug('In save rec testing Priorsupps'+authForExp.Prior_Supps_Approved__c);
        
        
        authForExp.increaseCounter__C = true;
        try{
        if(id!=null){
           System.debug('$$$$$$$$If in ID$$$$$$$'+AFE);     
           
            AFEController.save();
                if(authForExp.Budget_Number__c!=null)
                    calculatePriorFields(authForExp.Budget_Number__c);
                update authForExp;
                update AFE;
                //Re-arranging the DML statements. Putting delete at the end to avoid null pointer exception. @Rajeev
                //Dated - 25th Sep 2014
                delete afeAppList;
                saveAttachment(authForExp.Id);
                saveAFEapprovers();
       
        }else{
                insert authForExp;
                if(authForExp.Budget_Number__c!=null){
                    calculatePriorFields(authForExp.Budget_Number__c);
                    update authForExp;
                  }
                saveAttachment(authForExp.Id);
                saveAFEapprovers();
        }
        }catch(DmlException ex){
            ApexPages.addMessages(ex);
        }
        return (new ApexPages.Standardcontroller(authForExp)).view();
            }
        else{
            sendPageMessage('Please Select at least one approver.');
            return null;
        }
     }
     

     
     public void saveAFEapprovers(){
        AFE_approvers__c afeApprovers;
        List<AFE_approvers__c> afeApproversList = new List<AFE_approvers__c>();
        List<Id> approvers = new List<Id>();
  
        loadApproversInMap(counter);
        for(integer i =1;i<=Integer.valueOf(numberOfLevel);i++){
            if(approversMap.containsKey(i)){
            afeApprovers = new AFE_approvers__c();
            afeApprovers.Authorization_for_Expenditure__c = authForExp.Id;
            approvers =approversMap.get(i);
            afeApprovers.Approver_1__c=approvers.get(0);
            afeApprovers.Approver_2__c=approvers.get(1);
            afeApprovers.Approver_3__c=approvers.get(2);
            afeApprovers.Approver_4__c=approvers.get(3);
            afeApprovers.Approver_5__c=approvers.get(4);
            afeApprovers.Key__c=approvers.get(5);
            afeApprovers.Level__c=String.valueOf(i);    
            afeApproversList.add(afeApprovers); 
            }               
        }
        insert afeApproversList;
    
    }
     
    /*
     public void addLevel(){
        numberOfLevel=numberOfLevel+1;
     }
 
     public PageReference removeLevel(){
        SObject invObj = authForExp;
        invObj.put('Approver'+numberOfLevel+'__c', '');
        numberOfLevel=numberOfLevel-1;
     return null;   
     }*/
     
     public List<SelectOption> getLevels(){
         List<SelectOption> options = new List<SelectOption>();
         Schema.DescribeFieldResult fieldResult = Authorization_for_Expenditure__c.Levels_Of_Approval_Required__c.getDescribe();
         List<Schema.PicklistEntry> pEntryList = fieldResult.getPicklistValues();
         for(Schema.PicklistEntry pEntry :  pEntryList){
             options.add(new SelectOption(pEntry.getLabel(),pEntry.getValue()));
             System.debug('************************View OPTIONS **********'+ pEntry.getLabel()+pEntry.getValue());
             }
             
         return options;
     }
     //-------------------------------Original--------------------------------
 /*   
     public Component.Apex.PageBlockSection getDynamicForm(){

        System.debug('************************View LEVEL **********'+numberOfLevel);

          Integer level;
      
          level = Integer.valueOf(numberOfLevel);
          Component.Apex.PageBlockSection dPageBlockSection = new Component.Apex.PageBlockSection(columns=1,id='dynamic_id');
               
               for(Integer i=1;i<=level&&i<16;i++){
                    Component.Apex.InputField approverInField = new Component.Apex.InputField();
                                        ID id = ApexPages.currentPage().getParameters().get('id');        
                                        System.debug('dynamic component'+id);       
                                        if(id!=null){
                                                System.debug('dynamic component'+id);
                    approverInField.expressions.value = '{!AFE.Approver'+i+'__c}';
                                        }else{
                                                 approverInField.expressions.value = '{!Authorization_for_Expenditure__c.Approver'+i+'__c}';
                                        }
                    //approverInField.expressions.value = {!AFE.Approver1__c}';
                    approverInField.id = 'Approver'+i;
                    approverInField.label = 'Approver : '+i;
                                
                    dPageBlockSection.childComponents.add(approverInField);

                }
    
        return dPageBlockSection;
     }*/
     //----------------------- Code for updating approvers ----------------------------
     
     public void populateApproverMapforEdit(){
        List<Id> approvers;
        for(AFE_approvers__c levelapprovers : afeAppList ){
            approvers = new List<Id>();
            approvers.add((Id)levelapprovers.Approver_1__c);
            approvers.add((Id)levelapprovers.Approver_2__c);
            approvers.add((Id)levelapprovers.Approver_3__c);
            approvers.add((Id)levelapprovers.Approver_4__c);
            approvers.add((Id)levelapprovers.Approver_5__c);
            approvers.add((Id)levelapprovers.Key__c);
            approversMap.put(Integer.valueOf(levelapprovers.Level__c),approvers);           
        }           
     }

     
     
     
     //----------------------- Modified for multi-level approvers----------------------
        
        public ApexPages.Action setChangeField(){
                
                isChangeField=true;
                return null;
        }
        
        public void previousCounterSet(){
          //  if(counter>0&&counter<Integer.valueOf(numberOfLevel))
               if(counter<=Integer.valueOf(numberOfLevel) && counter >1)
                retrieveApproversFromMap(counter-1);
                if(counter>1)
                counter = counter-1;

              }
        
        public void retrieveApproversFromMap(Integer level){
                List<Id> approvers = approversMap.get(level);
                system.debug('approvers is : '+approvers );
                authForExp.Approver1__c =approvers.get(0);
                authForExp.Approver2__c=approvers.get(1);
                authForExp.Approver3__c=approvers.get(2);
                authForExp.Approver4__c=approvers.get(3);
                authForExp.Approver5__c=approvers.get(4);
                approverView=approvers.get(5);
            }
     
        public void nextCounterSet(){
              //  if(counter<Integer.valueOf(numberOfLevel))
                             // if(counter<=Integer.valueOf(numberOfLevel)){
              if(numberOfLevel!=null)
              {              
                if(checkIsBlank()){
                    if(counter<Integer.valueOf(numberOfLevel) ){
                        loadApproversInMap(counter); 
                           
                        clearApproversFields();
                            if(approversMap.containsKey(counter+1))
                                    retrieveApproversFromMap(counter+1);
                               
                        }
                    if(counter<Integer.valueOf(numberOfLevel))
                        counter = counter+1;
                }
                else{
                    sendPageMessage('Please Select at least one approver.');
                }
           }else{
            sendPageMessage('Please Select the number of levels.');
           }
      }
       
       public PageReference sendPageMessage(String message){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,message);
            ApexPages.addMessage(myMsg);
            return null;
       }        
               
       public Boolean checkIsBlank(){
            if(authForExp.Approver1__c==null&&authForExp.Approver2__c==null&&authForExp.Approver3__c==null&&authForExp.Approver4__c==null&&authForExp.Approver5__c==null)
            return false;
            else
            return true;
       }
                       
        public void clearApproversFields(){
                authForExp.Approver1__c=null;
                authForExp.Approver2__c=null;
                authForExp.Approver3__c=null;
                authForExp.Approver4__c=null;
                authForExp.Approver5__c=null;
        }
        
        public void loadApproversInMap(Integer level){
                List<Id> approver = new List<Id>();
        
                approver.add((Id) authForExp.Approver1__c);
                approver.add((Id)authForExp.Approver2__c);
                approver.add((Id)authForExp.Approver3__c);
                approver.add((Id)authForExp.Approver4__c);
                approver.add((Id) authForExp.Approver5__c);
                approver.add(getKey());
                approversMap.put(counter,approver);
                
        }
        
        public Id getKey(){
            if( authForExp.Approver1__c!= null)
                return authForExp.Approver1__c;
            else if(authForExp.Approver2__c!= null)
                return authForExp.Approver2__c;
            else if(authForExp.Approver3__c!= null)
                return authForExp.Approver3__c;
            else if(authForExp.Approver4__c!= null)
                return authForExp.Approver4__c;
            else 
                return authForExp.Approver5__c;
     }
     
     
     //---------------------- No longer needed -----------------------------------------
     
     /*     public Component.Apex.PageBlockSection getDynamicForm(){
        
        System.debug('************************View LEVEL **********'+numberOfLevel+'******'+counter);
                ApproversDTO approvers = new ApproversDTO();
                
          Integer level;
      
          level = Integer.valueOf(numberOfLevel);
          
          approvers.level=String.valueOf(level);
          
          Component.Apex.PageBlockSection dPageBlockSection = new Component.Apex.PageBlockSection(columns=1,id='dynamic_id');
             if(level>=counter){
               for(Integer i=1;i<=5;i++){
                    Component.Apex.InputField approverInField = new Component.Apex.InputField();
                    ID id = ApexPages.currentPage().getParameters().get('id');        
                    System.debug('dynamic component'+id);       
                    if(id!=null){
                        System.debug('dynamic component'+id);
                        approverInField.expressions.value = '{!AFE.Approver'+i+'__c}';
                    }else{
                        approverInField.expressions.value = '{!Authorization_for_Expenditure__c.Approver'+i+'__c}';
                     }
                    //approverInField.expressions.value = {!AFE.Approver1__c}';
                    approverInField.id = 'Approver'+i;
                    approverInField.label = 'Approver : '+i;
                                
                    dPageBlockSection.childComponents.add(approverInField);

                        }
               }
        return dPageBlockSection;
     }
     */
     
     
     

}