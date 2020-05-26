/*LAB Project
*@Sample Request Analysis
*@Rajeev
*/

public with sharing class SampleButtonHide{
       
       /*Initializing varibales*/
       String advID=' ';
       public Boolean ShowButton{get;set;}
       public ApexPages.StandardController controller;
       public Sample_Analysis_Request__c sar{get;set;}
       public string items{get;set;}
       public string items1{get;set;}
       public boolean checkopp{get;set;}
       public boolean checkopp1{get;set;}
       public boolean checktrue1{get;set;} 
       public boolean checktrue2{get;set;}  
       public boolean showList{get;set;}
       public boolean checkmaterial{get;set;}
       public boolean checksamplename{get;set;}
       public boolean requiresamplename{get;set;}
       public boolean requirematerial{get;set;}
       public string recordTypeIdOfRecord;
       

   // *Constructor*
   //@Rajeev
   public SampleButtonHide(ApexPages.StandardController controller){                             
       this.controller = controller;
        if(!test.isRunningtest()){
          controller.addFields(new List<String>{'Status__c','Sample_Tracking_Number__c','Material__c'});
        }
       
       sar = (Sample_Analysis_Request__c)controller.getRecord();
       if(sar.Id == null){
       sar.Customer_Service_Charge__c = 'No';
       }
       if(sar.Status__c == 'Approved' || sar.Status__c == 'Rejected' || sar.status__c == 'Sample Analysis Completed'){
       showList = true;
       }else{
       showList = false;
       }
       
       recordTypeIdOfRecord = ApexPages.currentPage().getParameters().get('rid');//fetches the record type id.
       
       if(((sar.recordtypeid == checkRecordType('Customer Competitive')) && (sar.Opportunity__c != null)) || ((recordTypeIdOfRecord == checkRecordType('Customer Competitive')) && (sar.Opportunity__c != null))){  
        items = 'Yes';
        checkopp = true;
        checkopp1 = false;
        checktrue1 = true;
        }
       else if(((sar.recordtypeid == checkRecordType('Customer Competitive')) && (sar.Opportunity__c == null)) || ((recordTypeIdOfRecord == checkRecordType('Customer Competitive')) && (sar.Opportunity__c == null))){
        items = 'No';
        checktrue2 = true;
        checkopp1 = true;
        checkopp = false;
       }
      
       else if(((sar.Material__c != null) && (sar.recordtypeid == checkRecordType('Customer Value Add'))) || ((recordTypeIdOfRecord == checkRecordType('Customer Value Add')) && (sar.Material__c != null))){
        items1 = 'Yes';
        sar.Analysis_Type__c = 'Value-Add';
        checkmaterial = true;
        checksamplename = false;
        requirematerial = true;
        requiresamplename = false; 
       }
       else if(((sar.Material__c == null) && (sar.recordtypeid == checkRecordType('Customer Value Add'))) || ((recordTypeIdOfRecord == checkRecordType('Customer Value Add')) && (sar.Material__c == null))){
        items1 = 'No';
        checkmaterial = false;
        checksamplename = true;
        requirematerial = false;
        requiresamplename = true;
       }
       
       else if(((sar.recordtypeid == checkRecordType('Supplier')) && (sar.Material__c != null)) || ((recordTypeIdOfRecord == checkRecordType('Supplier')) && (sar.Material__c != null))){
        items1 = 'Yes';
        sar.Analysis_Type__c = 'Supplier Analytical Project';
        checkmaterial = true;
        checksamplename = false;
        requirematerial = true;
        requiresamplename = false;
       }
       else if(((sar.recordtypeid == checkRecordType('Supplier')) && (sar.Material__c == null)) || ((recordTypeIdOfRecord == checkRecordType('Supplier')) && (sar.Material__c == null))){
        items1 = 'No';
        checkmaterial = false;
        checksamplename = true;
        requirematerial = false;
        requiresamplename = true;
       }
      
       advID = UserInfo.getUserId(); // gets ID of person logged in    
       List<GroupMember> getGroup = [SELECT UserOrGroupId FROM GroupMember WHERE UserOrGroupId =:advid and group.name = 'Tech Service Group'];
       if (getGroup!=null && getGroup.size()>0){
            showButton=true;
            showList=false;
       }else{
            showButton=false;
            
        }
       }/* End of constructor*/
    
  
       
    /*Save method*/
    public pagereference customSave(){
     PageReference pageRef;
     String rid = ApexPages.currentPage().getParameters().get('rid');
     String ent1 = ApexPages.currentPage().getParameters().get('ent');
     if(rid == checkRecordType('Customer Competitive')){
       if(validate()){
        if(ent1 != null){
         sar.ent__c = ent1;
        }
         sar.recordtypeid = rid;
          upsert sar;
           pageref = Page.SampleViewCustomerCompetitive;
            pageRef.getParameters().put('Id',sar.Id);
           }else
           return null;
          }
      else if(rid == checkRecordType('Customer Value Add')){
       if(validateCustomerValueAdd()){
        sar.recordtypeid = rid;
         if(ent1 != null){
           sar.ent__c = ent1;
          }
          upsert sar;
           pageref = Page.SampleViewCustomerValueAdd;
            pageRef.getParameters().put('Id',sar.Id);
          }else
           return null;
          }
      else if(rid == checkRecordType('Supplier')){
       if(validateSupplier()){
        sar.recordtypeid = rid;
         if(ent1 != null){
           sar.ent__c = ent1;
          }
          upsert sar;
           pageref = Page.SampleViewSupplier;
            pageRef.getParameters().put('Id',sar.Id);
          }else
           return null;
          }
     else if((rid == checkRecordType('Customer Complaint'))){
       if(validateCustomerValueAdd()){
        sar.recordtypeid = rid;
         if(ent1 != null){
           sar.ent__c = ent1;
          }
          upsert sar;
           pageref = Page.SampleViewCustomerComplaint;
            pageRef.getParameters().put('Id',sar.Id);
          }else
           return null;
          }
     else if((rid == checkRecordType('Plant'))){
       if(validateCustomerValueAdd()){
        sar.recordtypeid = rid;
         if(ent1 != null){
           sar.ent__c = ent1;
          }
          upsert sar;
           pageref = Page.SampleViewPlant;
            pageRef.getParameters().put('Id',sar.Id);
          }else
           return null;
          }              
      else return null;    
      pageRef.setRedirect(true);        
      return pageref;
     } 
    
    
    /*Validation rule for Customer value add recordtype*/
    public boolean validateCustomerValueAdd(){
      if((sar.CommentsNew__c == '') && ((recordTypeIdOfRecord == checkRecordType('Customer Value Add')) || (recordTypeIdOfRecord == checkRecordType('Plant')) || (recordTypeIdOfRecord == checkRecordType('Customer Value Add')))){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter details in Comments box.');
           ApexPages.addMessage(myMsg);
           return false;
       }else return true;
    }
    
    /*Validation rule for Supplier record type*/
    public boolean validateSupplier(){
      boolean status = true;
      if((sar.Supplier__c != null) && (sar.Other__c != null) && (recordTypeIdOfRecord == checkRecordType('Supplier'))){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter either Supplier or Other but not both.');
           ApexPages.addMessage(myMsg);
           status = false; 
        }
      else if(sar.CommentsNew__c == ''){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter details in Comments box.');
           ApexPages.addMessage(myMsg);
           status = false;
        }  
        else {status = true;}
        return status;
    }

    //Method added to check pass the validation rules.
    public boolean validate(){ 
       boolean status = true;
       String message = 'Please fill in Opportunity or Volume UOM/Opportunity Volume based on "Opportunity avaialble" radio box.';
        if(sar.CommentsNew__c == ''){
           ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,'Please enter details in Comments box.');
           ApexPages.addMessage(myMsg);
           status = false;
        }
        else if((items == 'No') && (sar.Opportunity_Volume__c == null || sar.Volume_UOM__c == null)){
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.FATAL,message);
            ApexPages.addMessage(myMsg);
            status = false;
            }
        else if(sar.Opportunity__c == null && items == 'Yes'){
            status = false;
            }
        else{ 
            status = true;
            }
        return status;    
        }
    

    //Getter method to display values in "Opportunity Available" radio button.
    public List<SelectOption> getOppAvailable() {
        List<SelectOption> options = new List<SelectOption>(); 
         options.add(new SelectOption('Yes','Yes')); 
          options.add(new SelectOption('No','No'));
         return options; 
     }
   
   //Method to display a picklist value
   public List<SelectOption> getAnalysisType(){
         List<SelectOption> options = new List<SelectOption>();
          if(recordTypeIdOfRecord == checkRecordType('Customer Value Add')){
           options.add(new SelectOption('Value-Add','Value-Add'));
          }else if(recordTypeIdOfRecord == checkRecordType('Supplier')){
           options.add(new SelectOption('Supplier Analytical Project','Supplier Analytical Project'));
          }else if(recordTypeIdOfRecord == checkRecordType('Customer Complaint')){
           options.add(new SelectOption('Customer Complaint - Product Not Used','Customer Complaint - Product Not Used'));
           options.add(new SelectOption('Customer Complaint - Product Used','Customer Complaint - Product Used'));
          }else if(recordTypeIdOfRecord == checkRecordType('Plant')){
           options.add(new SelectOption('Line Flush','Line Flush'));
           options.add(new SelectOption('Quality','Quality'));
           options.add(new SelectOption('Other','Other')); 
          }else return null;
         return options;
    }
   
   //Method to display picklist values 
   public List<SelectOption> getBusinessGroup(){
         List<SelectOption> options = new List<SelectOption>();
          if(recordTypeIdOfRecord == checkRecordType('Supplier')){
           options.add(new SelectOption('Chemical Distribution','Chemical Distribution'));
          }else if(recordTypeIdOfRecord == checkRecordType('Customer Complaint')){
           options.add(new SelectOption('Chemical Distribution','Chemical Distribution'));
          }else if(recordTypeIdOfRecord == checkRecordType('Plant')){
           options.add(new SelectOption('Plant Operations','Plant Operations'));
          }else return null;    
          return options;
      }
    
    
   //Method to display fields on selection of the radio button
    public void showFields(){
     String action = ApexPages.currentPage().getParameters().get('action');
      if(action == 'Yes'){
        checkopp = true;
        checkopp1 = false;
        checktrue1 = true;
        checktrue2 = false;
        checkmaterial = true;
        checksamplename = false;
        requiresamplename = false;
        requirematerial = true;
        
       }
      else if(action == 'No'){
        checkopp = false;
        checkopp1 = true;
        checktrue2 = true;
        checktrue1 = false;
        checkmaterial = false;
        checksamplename = true;
        requiresamplename = true;
        requirematerial = false;
       }
    }
   
   //Method to display selected customer's field values.
   //@Rajeev 
   public void getCustomerDetails(){
    String customerId = ApexPages.currentPage().getParameters().get('customerId');
    if(customerId != null){
     List<Account> acc = [Select Id, AccountNumber, SAP_Customer_Group__c,SAP_Customer_Group_Desc__c from Account where Id = :customerId limit 1];   
      if(acc != null && acc.size()>0){
       sar.Market_Tag_new__c = acc[0].SAP_Customer_Group_Desc__c;
       sar.Customer_Account_new__c = acc[0].AccountNumber;
      }
     else{
     sar.Market_Tag_new__c = '';
     sar.Customer_Account_new__c = '';
    } 
    }else{
     sar.Market_Tag_new__c = '';
     sar.Customer_Account_new__c = '';
    }
   }  
   
   /*Fetch SAP Plant details*/
   public void getPlantDetails(){
    String PlantId = ApexPages.currentPage().getParameters().get('plantId');
     if(PlantId != null){
      List<SAP_Plant__c> plant = [Select Id, Plant_Name__c,Plant_Code__c from SAP_Plant__c where Id = :PlantId limit 1];
       if(plant != null && plant.size()>0){
          sar.Plant_Description__c = plant[0].Plant_Name__c;
         sar.Plant_Code__c = plant[0].Plant_Code__c;
        }else{
        sar.Plant_Description__c = '';
       sar.Plant_Code__c = '';
      }
     }else{
     sar.Plant_Description__c = '';
    sar.Plant_Code__c = '';
    }
   }
   
   
   /*Fetch Material details*/
   public void getMaterialDetails(){
    String materialid = ApexPages.currentPage().getParameters().get('materialId');
     if(materialid != null){
      Material_Sales_Data2__c msd2 = [Select Id, Material_Number__c from Material_Sales_Data2__c where Id = :materialid limit 1];
       if(msd2.Material_Number__c != null){
       sar.Material_NumberNew__c = msd2.Material_Number__c;
       }else
       sar.Material_NumberNew__c = '';
   }else
    sar.Material_NumberNew__c = ''; 
   }
   
   
   //Method added for "Save and New" functionality
   //@Rajeev
   public pagereference doSaveAndNew(){
    Pagereference pgrf;
     String rid = ApexPages.currentPage().getParameters().get('rid');
      String returl = ApexPages.currentPage().getParameters().get('returl');
       String ent = ApexPages.currentPage().getParameters().get('ent');
      if(rid == checkRecordType('Customer Competitive')){
       if(validate()){
        sar.recordtypeid = rid;
         if(ent != null){
          sar.ent__c = ent;
        }
        
       upsert sar;
       }
      else return null;
      }
      else if((rid == checkRecordType('Customer Value Add'))){
       if(validateCustomerValueAdd()){
         sar.recordtypeid = rid;
          if(ent != null){
           sar.ent__c = ent;
         }
       upsert sar;
      }
      else return null;
      }else if(rid == checkRecordType('Supplier')){
       if(validateSupplier()){
         sar.recordtypeid = rid;
          if(ent != null){
           sar.ent__c = ent;
         }
       upsert sar;
      }
      else return null;
      }else if(rid == checkRecordType('Customer Complaint')){
       if(validateCustomerValueAdd()){
         sar.recordtypeid = rid;
          if(ent != null){
           sar.ent__c = ent;
         }
       upsert sar;
      }
      else return null;
      }else if(rid == checkRecordType('Plant')){
       if(validateCustomerValueAdd()){
         sar.recordtypeid = rid;
          if(ent != null){
           sar.ent__c = ent;
         }
       upsert sar;
      }
      else return null;
      }
      
      
      Schema.DescribeSObjectResult R = Sample_Analysis_Request__c.SObjectType.getDescribe();
       if(!ApexPages.currentPage().getParameters().containskey('id')){
         pgrf = new pagereference('/setup/ui/recordtypeselect.jsp?ent='+sar.ent__c+'&retURL=%2F'+R.getKeyPrefix()+'%2Fo&save_new_url=%2F'+R.getKeyPrefix()+'%2Fe%3FretURL%3D%252F'+R.getKeyPrefix()+'%252Fo');
        }else{
          String id = ApexPages.currentPage().getParameters().get('id');
           List<Sample_Analysis_Request__c> c = [Select id, recordtypeid,ent__c,RecordTypeName__c From Sample_Analysis_Request__c Where Id = :id];
            if(c[0].ent__c != null){ 
             pgrf = new pagereference('/setup/ui/recordtypeselect.jsp?ent='+c[0].ent__c+'&retURL=%2F'+R.getKeyPrefix()+'%2Fo&save_new_url=%2F'+R.getKeyPrefix()+'%2Fe%3FretURL%3D%252F'+R.getKeyPrefix()+'%252Fo');
            }else{
             pgrf = new pagereference('/'+R.getKeyPrefix()+'/e?RecordType='+c[0].recordtypeid+'&returl=%2Fa4Z%2Fo');
            }
           }
          pgrf.setRedirect(true);
        return pgrf;
   }
   
   //Returns recordtype id.     
   public static Id checkRecordType(String recordtypename){
    Id returnedId;
     Map<String, Schema.RecordTypeInfo> RTMap  = Sample_Analysis_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
      returnedId = RTMap.get(recordtypename).getrecordtypeid();
       if(returnedId != null)
      return returnedId;
     else
    return null;
   }     
  //**********************************END*******************************************
    
}