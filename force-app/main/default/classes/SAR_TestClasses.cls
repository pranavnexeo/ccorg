//LAB Project.
//Sample request analysis part.
//@Rajeev

@isTest

//Test method for "DispatcherContactEditController" test.
//LAB Project
private class SAR_TestClasses{

    public static testMethod void TestMyMethod(){
    Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
    
    Test.startTest();
    User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='saxs2bh77gfdhddc@gorg.com', IsActive = true);
    insert u; 
  
    Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
    insert a; 
    
    Map<String, Schema.RecordTypeInfo> RTMap = Sample_Analysis_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
    
    Sample_Analysis_Request__c SAR=new Sample_Analysis_Request__c(CommentsNew__c = 'test Sample',Recordtypeid = RTMap.get('Customer Competitive').getrecordtypeid(),Requested_by__c = u.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
    insert SAR;
    
    Sample_Analysis_Request__c SAR1=new Sample_Analysis_Request__c(CommentsNew__c = '',Recordtypeid = RTMap.get('Customer Complaint').getrecordtypeid(),Requested_by__c = u.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
    insert SAR1;
    
    Sample_Analysis_Request__c SAR2=new Sample_Analysis_Request__c(CommentsNew__c = 'testSample',Recordtypeid = RTMap.get('Customer Competitive').getrecordtypeid(),Requested_by__c = u.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
    insert SAR2;
    
    Sample_Analysis_Request__c SAR3=new Sample_Analysis_Request__c(Recordtypeid = RTMap.get('Plant').getrecordtypeid(),Requested_by__c = u.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
    insert SAR3;
    
    Sample_Analysis_Request__c SAR4=new Sample_Analysis_Request__c(Recordtypeid = RTMap.get('Customer Complaint').getrecordtypeid(),Requested_by__c = u.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
    insert SAR4;
    Test.stopTest();
    
    ApexPages.currentPage().getParameters().put('id',SAR.Id);
    ApexPages.Standardcontroller con = new ApexPages.Standardcontroller(SAR);
    DispatcherContactEditController ext = new DispatcherContactEditController(con);
    PageReference pageRef = Page.SampleViewCustomerCompetitive;
    
    ApexPages.currentPage().getParameters().put('id',SAR1.Id);
    ApexPages.Standardcontroller con1 = new ApexPages.Standardcontroller(SAR1);
    DispatcherContactEditController ext1 = new DispatcherContactEditController(con1);
    PageReference pageRef1  = Page.SampleViewCustomerComplaint;
    
    ApexPages.currentPage().getParameters().put('id',SAR2.Id);
    ApexPages.Standardcontroller con2 = new ApexPages.Standardcontroller(SAR2);
    DispatcherContactEditController ext2 = new DispatcherContactEditController(con2);
    PageReference pageRef2 = Page.SampleViewCustomerValueAdd;
    
    ApexPages.currentPage().getParameters().put('id',SAR3.Id);
    ApexPages.Standardcontroller con3 = new ApexPages.Standardcontroller(SAR3);
    DispatcherContactEditController ext3 = new DispatcherContactEditController(con3);
    PageReference pageRef3  = Page.SampleViewPlant;
    
    ApexPages.currentPage().getParameters().put('id',SAR4.Id);
    ApexPages.currentPage().getParameters().put('rid',RTMap.get('Customer Complaint').getrecordtypeid());
    ApexPages.currentPage().getParameters().put('rid',RTMap.get('Customer Competitive').getrecordtypeid());
    ApexPages.currentPage().getParameters().put('rid',RTMap.get('Customer Value Add').getrecordtypeid());
    ApexPages.currentPage().getParameters().put('rid',RTMap.get('Supplier').getrecordtypeid());
    
    ApexPages.Standardcontroller con4 = new ApexPages.Standardcontroller(SAR4);
    DispatcherContactEditController ext4 = new DispatcherContactEditController(con4);
    PageReference pageRef4  = Page.SampleViewSupplier;
    Pagereference pageref5 = Page.sampleeditcustomercompetitive;
    Pagereference pageref6 = Page.SampleEditCustomerValueAdd;
    Pagereference pageref7 = Page.SampleEditSupplier;
    Pagereference pageref8 = Page.SampleEditCustomerComplaint;    
    
    ext.getRedir();
    ext.getRedirEdit();
    try{
     ext.redirectToCustComp();
    }catch(exception e){}  
    
    ext1.getRedir();
    ext1.getRedirEdit();
   try{
    ext1.redirectToCustComp();
    }catch(exception e){}    
    ext2.getRedir();
    ext2.getRedirEdit();
    try{
    ext2.redirectToCustComp();
    }
    catch(exception e){}    
    ext3.getRedir();
    ext3.getRedirEdit();
    try{
    ext3.redirectToCustComp();
    }
    catch(exception e){}
    
    ext4.getRedir();
    ext4.getRedirEdit();
    try{
    ext4.redirectToCustComp();
    }catch(exception e){}

    } 
  
  
  //Test method for "MultiAdd" class
  //Lab Project
  //@Rajeev
  public static testMethod void MultiAdd_TestMethod() {  
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
  User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbh77gfdevfshddc@gorg.com', IsActive = true);
  insert u; 
  
  Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
  insert a; 
  
  Sample_Analysis_Request__c SAR=new Sample_Analysis_Request__c(Requested_by__c = u.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
  insert SAR;

  Test_Case2_del__c TND2=new Test_Case2_del__c(Name='Test');
  Test_Case_del__c TND=new Test_Case_del__c(Test_Name_del__c=SAR.Id,Test_Case2_del__c=TND2.Id);
  
  ApexPages.Standardcontroller con = new ApexPages.Standardcontroller(TND);
  MultiAdd ext=new MultiAdd(con);
  PageReference pageRef = Page.SampleViewCustomerCompetitive;
  PageReference pageRef1 = Page.SampleViewCustomerComplaint;
  PageReference pageRef2 = Page.SampleViewCustomerValueAdd;
  PageReference pageRef3 = Page.SampleViewPlant;
  PageReference pageRef4 = Page.SampleViewSupplier;
  Test.setCurrentPage(pageRef);

  ext.add();
  }
  
  
  //Test method for "SampleButtonHide" class.
  //LAB Project
  //@Rajeev
  public static testMethod void SampleButtonHide_Test() { 
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
  User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbh77sbdcgfdevfshddc@gorg.com', IsActive = true);
  insert u; 
  
  Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
  insert a; 
  
    Material_Sales_Data2__c msd = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',Record_Key__c = 'Test Record Key',Material_Group3_Desc__c='SPECIALTY');        
        insert msd;
  
  Map<String, Schema.RecordTypeInfo> RTMap = Sample_Analysis_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  Id rId = RTMap.get('Plant').getrecordtypeid();
  Sample_Analysis_Request__c SAR=new Sample_Analysis_Request__c(Recordtypeid = rId,Requested_by__c = u.id,Status__c = 'New',Sample_Tracking_Number__c = '1234',Material__c = msd.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
  insert SAR;
  
  ApexPages.currentPage().getParameters().put('id',SAR.Id);
  ApexPages.currentPage().getParameters().put('rid',rId);
  ApexPages.currentPage().getParameters().put('customerId',SAR.Id);
  ApexPages.currentPage().getParameters().put('action','Yes');
  //ApexPages.currentPage().getParameters().put('action','No');
  ApexPages.currentPage().getParameters().put('RecordType',rId);
  ApexPages.Standardcontroller con = new ApexPages.Standardcontroller(SAR);
  SampleButtonHide ext=new SampleButtonHide(con);
  
  Map<String, Schema.RecordTypeInfo> RTMap2 = Sample_Analysis_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  Id rId2 = RTMap.get('Plant').getrecordtypeid();
  Sample_Analysis_Request__c SAR2=new Sample_Analysis_Request__c(CommentsNew__c = '',Recordtypeid = rId,Requested_by__c = u.id,Status__c = 'New',Sample_Tracking_Number__c = '1234',Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
  insert SAR2;
  
  ApexPages.currentPage().getParameters().put('id',SAR2.Id);
  ApexPages.currentPage().getParameters().put('rid',rId2);
  ApexPages.currentPage().getParameters().put('customerId',SAR2.Id);
  ApexPages.currentPage().getParameters().put('action','Yes');
  //ApexPages.currentPage().getParameters().put('action','No');
  ApexPages.currentPage().getParameters().put('RecordType',rId2);
  ApexPages.Standardcontroller con2 = new ApexPages.Standardcontroller(SAR2);
  SampleButtonHide ext2=new SampleButtonHide(con2);
  
  Map<String, Schema.RecordTypeInfo> RTMap1 = Sample_Analysis_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  Id rId1 = RTMap.get('Plant').getrecordtypeid();
  Sample_Analysis_Request__c SAR1=new Sample_Analysis_Request__c(Recordtypeid = rId1,Requested_by__c = u.id,Status__c = 'New',Sample_Tracking_Number__c = '1234',Material__c = msd.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
  insert SAR1;
  
  ApexPages.currentPage().getParameters().put('id',SAR1.Id);
  ApexPages.currentPage().getParameters().put('rid',rId1);
  ApexPages.currentPage().getParameters().put('customerId',SAR1.Id);
  ApexPages.currentPage().getParameters().put('action','Yes');
  ApexPages.currentPage().getParameters().put('action','No');
  ApexPages.currentPage().getParameters().put('RecordType',rId1);
  ApexPages.Standardcontroller con1 = new ApexPages.Standardcontroller(SAR1);
  SampleButtonHide ext1=new SampleButtonHide(con1);
  ext1.items1 = 'test';
  PageReference pageRef = Page.SampleViewCustomerCompetitive;
  PageReference pageRef1 = Page.SampleViewSupplier;
  PageReference pageRef2 = Page.SampleViewCustomerValueAdd;
  ext.getCustomerDetails();
  ext.showFields();
  ext.customSave();
  ext.doSaveAndNew();
  ext.validateCustomerValueAdd();
  ext.validateSupplier();
  ext.validate();
  ext.getAnalysisType();
  ext.getBusinessGroup();
  ext.getOppAvailable();
  ext.getMaterialDetails();
  ext.getPlantDetails();
  }  
  
  
  public static testMethod void SampleButtonHide_Test1() { 
  
  String plant = '1234';
  
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
  User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbh77sbdcgfdevfshddc@gorg.com', IsActive = true);
  insert u; 
  
  List<Account> accl = new List<Account>();
  Account a = new Account(SAP_Customer_Group__c = 'dta',SAP_Customer_Group_Desc__c = 'Power',Name = 'test11',type = 'Customer', OwnerId = u.id);
  insert a; 
  accl.add(a);
  
  Material_Sales_Data2__c msd = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',Record_Key__c = 'Test Record Key',Material_Group3_Desc__c='SPECIALTY');        
        insert msd; 
  //try{
  Map<String, Schema.RecordTypeInfo> RTMap = Sample_Analysis_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  Id rId = RTMap.get('Customer Complaint').getrecordtypeid();
  Sample_Analysis_Request__c SAR=new Sample_Analysis_Request__c(Recordtypeid = rId,Requested_by__c = u.id,Status__c = 'Rejected',Sample_Tracking_Number__c = '1234',Material__c = msd.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
  insert SAR;
  
  List<SAP_Plant__c> spl = new List<SAP_Plant__c>();
  SAP_Plant__c sp = new SAP_Plant__c();
  sp.Plant_Code__c = plant;
  sp.Plant_Name__c = 'testplant';
  insert sp;
  spl.add(sp);
  
  ApexPages.currentPage().getParameters().put('id',SAR.Id);
  ApexPages.currentPage().getParameters().put('rid',rId);
  ApexPages.currentPage().getParameters().put('customerId',SAR.Id);
  //ApexPages.currentPage().getParameters().put('action','Yes');
  ApexPages.currentPage().getParameters().put('action','No');
  ApexPages.currentPage().getParameters().put('RecordType',rId);
  ApexPages.currentPage().getParameters().put('plantId','sp.id');
  ApexPages.Standardcontroller con = new ApexPages.Standardcontroller(SAR);
  SampleButtonHide ext=new SampleButtonHide(con);  
   
   Map<String, Schema.RecordTypeInfo> RTMap1 = Sample_Analysis_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  Id rId1 = RTMap.get('Customer Complaint').getrecordtypeid();
  Sample_Analysis_Request__c SAR1=new Sample_Analysis_Request__c(Recordtypeid = rId1,Requested_by__c = u.id,Status__c = 'New',Sample_Tracking_Number__c = '1234',Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Charge_Status__c='Charged');
  insert SAR1;
  
  ApexPages.currentPage().getParameters().put('id',SAR1.Id);
  ApexPages.currentPage().getParameters().put('rid',rId1);
  ApexPages.currentPage().getParameters().put('customerId',SAR1.Id);
  //ApexPages.currentPage().getParameters().put('action','Yes');
  ApexPages.currentPage().getParameters().put('action','No');
  ApexPages.currentPage().getParameters().put('RecordType',rId1);
  ApexPages.Standardcontroller con1 = new ApexPages.Standardcontroller(SAR1);
  SampleButtonHide ext1=new SampleButtonHide(con1);  
   
  PageReference pageRef = Page.SampleViewCustomerCompetitive;
  PageReference pageRef1 = Page.SampleViewSupplier;
  PageReference pageRef2 = Page.SampleViewCustomerValueAdd;
  ext.getCustomerDetails();
  ext.showFields();
  ext.customSave();
  ext.doSaveAndNew();
  ext.validateCustomerValueAdd();
  ext.validateSupplier();
  ext.validate();
  ext.getAnalysisType();
  ext.getBusinessGroup();
  ext.getOppAvailable();
  ext.getMaterialDetails();
  ext.getPlantDetails();
 // }  catch(exception e){}
  }
  
 public static testMethod void SampleButtonHide_Test2() { 
  Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
  User u = new User(Alias = 'standt1', Email='ooo@testorg.com',EmailEncodingKey='UTF-8', LastName='Nexeo_Integration User', LanguageLocaleKey='en_US', LocaleSidKey='en_US', ProfileId = p.Id, 
             TimeZoneSidKey='America/Los_Angeles', UserName='sbh77sbdcgfdevfshddc@gorg.com', IsActive = true);
  insert u; 
  
  Account a = new Account(Name = 'test11',type = 'Customer', OwnerId = u.id);
  insert a; 
  
  opportunity op = new opportunity(name = 'Distribution Plastics',CurrencyIsoCode = 'AUD',Customer_Prospect__c = a.id,CloseDate = system.today(),StageName = 'Concept');
        insert op;
  
  Material_Sales_Data2__c msd = new Material_Sales_Data2__c(name = 'Test Material', Material_Number__c = '12344321', Dist_Channel_Code__c = 'ac', Sales_Org_Code__c = '1000',Record_Key__c = 'Test Record Key',Material_Group3_Desc__c='SPECIALTY');        
        insert msd; 
  //try{
  Map<String, Schema.RecordTypeInfo> RTMap = Sample_Analysis_Request__c.sObjectType.getDescribe().getRecordTypeInfosByName();
  Id rId = RTMap.get('Customer Competitive').getrecordtypeid();
  Sample_Analysis_Request__c SAR=new Sample_Analysis_Request__c(Recordtypeid = rId,Requested_by__c = u.id,Status__c = 'Rejected',Sample_Tracking_Number__c = '1234',Material__c = msd.id,Buisness_Group__c='Inside Sales',Customer__c = a.id,Sample_Name__c='Test',Comments__c='Test',Customer_Service_Charge__c='Yes',Opportunity__c=op.id,Charge_Status__c='Charged');
  insert SAR;
  
  ApexPages.currentPage().getParameters().put('id',SAR.Id);
  ApexPages.currentPage().getParameters().put('rid',rId);
  ApexPages.currentPage().getParameters().put('customerId',SAR.Id);
  ApexPages.currentPage().getParameters().put('action','Yes');
  ApexPages.currentPage().getParameters().put('action','No');
  ApexPages.currentPage().getParameters().put('RecordType',rId);
  ApexPages.currentPage().getParameters().put('materialId',msd.Id);
  ApexPages.Standardcontroller con = new ApexPages.Standardcontroller(SAR);
  SampleButtonHide ext=new SampleButtonHide(con);     
   
  PageReference pageRef = Page.SampleViewCustomerCompetitive;
  PageReference pageRef1 = Page.SampleViewSupplier;
  PageReference pageRef2 = Page.SampleViewCustomerValueAdd;
  ext.getCustomerDetails();
  ext.showFields();
  ext.customSave();
  ext.doSaveAndNew();
  ext.validateCustomerValueAdd();
  ext.validateSupplier();
  ext.validate();
  ext.getAnalysisType();
  ext.getBusinessGroup();
  ext.getOppAvailable();
  ext.getMaterialDetails();
  ext.getPlantDetails();
  //}  catch(exception e){}
  }
}