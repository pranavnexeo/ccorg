public with sharing class viewApproversExtension {
  public Id lineItemID;
    public Integer numberOfLevel{get;set;}
        public ApexPages.StandardController controller{get;set;}
    public Authorization_for_Expenditure__c authForExp{get;set;}    
       public integer counter{get;set;}
          public Map<integer,List<Id>> approversMap; 
          public List<AFE_approvers__c> afeAppList;   
          
          
    public viewApproversExtension(){
    
    }
                             
    public viewApproversExtension(ApexPages.StandardController controller) {
       this.controller=controller;
        this.authForExp=(Authorization_for_Expenditure__c)controller.getRecord();
        lineItemID = ApexPages.currentPage().getParameters().get('id');
         approversMap = new Map<integer,List<Id>>();
        if(lineItemID==null){
            authForExp = new  Authorization_for_Expenditure__c();
           }
        else{
            authForExp = [Select a.submitted_date__c, a.isEmailSend__c, a.energy_Improvement__c, a.WBS__c, a.Usage_Codes__c, a.USD_Total_Amount__c, a.Type_of_Project__c, a.Tracking_Control_Number__c, a.Target_Completion_Date__c, a.Status__c, a.State_Province__c, a.Short_form__c, a.Responsible_Buyer__c, a.Region__c, a.Priority_Level__c, a.Prepared_By__c, a.Physical_Location__c, a.PSM_Covered_Process__c, a.Origination_Type__c, a.No_of_days_del__c, a.Next_Approver__c, a.Name, a.Local_Currency__c, a.Local_Currency_Total_Amount__c, a.Levels_Of_Approval_Required__c, a.Internal_Number__c, a.Id, a.HSSE_Impact__c, a.For_Accounting_Use_Only__c, a.Expense_Amount__c, a.Expenditure_Class__c, a.Exchange_Rate__c, a.E_Number__c, a.Division_AFE_Coordinator__c, a.Date_Prepared__c, a.Current_Approval_Level__c, a.Country__c, a.Cost_Center_number__c, a.Confidential_AFE__c, a.Company_Code__c, a.Commercial_Unit__c, a.City__c, a.Business_Group__c, a.Budget__c, a.Budget_Number__c, a.Brief_Description__c, a.Asset_Type__c, a.Approver_comments__c, a.Approver9__c, a.Approver8__c, a.Approver7__c, a.Approver6__c, a.Approver5__c, a.Approver4__c, a.Approver3__c, a.Approver2__c, a.Approver1__c, a.Approver15__c, a.Approver14__c, a.Approver13__c, a.Approver12__c, a.Approver11__c, a.Approver10__c, a.Approved_for_Submittal_By__c, a.Approval_Routing_Priority__c, a.AFE_Title__c, a.AFE_Number__c, a.AFE_Class__c From Authorization_for_Expenditure__c a where a.Id = : lineItemID];
            afeAppList = [Select a.Level__c, a.Key__c, a.Id, a.Authorization_for_Expenditure__c, a.Approver_5__c, a.Approver_4__c, a.Approver_3__c, a.Approver_2__c, a.Approver_1__c From AFE_approvers__c a where a.Authorization_for_Expenditure__c=:lineItemID];
        numberOfLevel=Integer.valueOf(authForExp.Levels_Of_Approval_Required__c);
        populateApproverMapforEdit();
        retrieveApproversFromMap(1);
        }
                 counter=1;
                 
   }
   

         public PageReference saveRecord(){
        authForExp.Levels_Of_Approval_Required__c=String.valueOf(numberOfLevel);
        update authForExp;
        if(checkIsBlank()){
        delete afeAppList;
        saveAFEapprovers();
        return (new  ApexPages.Standardcontroller(authForExp)).view();
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
      public ApexPages.Action setChangeField(){

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
                authForExp.Approver1__c=approvers.get(0);
                authForExp.Approver2__c=approvers.get(1);
                authForExp.Approver3__c=approvers.get(2);
                authForExp.Approver4__c=approvers.get(3);
                authForExp.Approver5__c=approvers.get(4);
            
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
     
     
     
     
     
     /*
     
     public void addLevel(){
        numberOfLevel=numberOfLevel+1;
     }
 
     public PageReference removeLevel(){
        SObject invObj = authForExp;
        invObj.put('Approver'+numberOfLevel+'__c', '');
        numberOfLevel=numberOfLevel-1;
     return null;   
     }
 
 
     public Component.Apex.PageBlockSection getDynamicForm(){

        System.debug('************************View LEVEL **********'+numberOfLevel);
        if(numberOfLevel==null)numberOfLevel=3;
        Component.Apex.PageBlockSection dPageBlockSection = new Component.Apex.PageBlockSection(columns=1);
        for(Integer i=1;i<=numberOfLevel&&i<16;i++){
        
            Component.Apex.InputField approverInField = new Component.Apex.InputField();
            approverInField.expressions.value = '{!authForExp.Approver'+i+'__c}';
            approverInField.id = 'Approver'+i;
            approverInField.label = 'Approver : '+i;
    
            dPageBlockSection.childComponents.add(approverInField);

        }
    
        return dPageBlockSection;
     }
 
     public PageReference saveRecord(){
        authForExp.Levels_Of_Approval_Required__c=String.valueOf(numberOfLevel);
        update authForExp;
        return (new  ApexPages.Standardcontroller(authForExp)).view();
     }
     */
 
 }