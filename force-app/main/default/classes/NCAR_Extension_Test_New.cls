/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 *
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
//@isTest(SeeAllData=true)
@isTest
public class NCAR_Extension_Test_New {
    //public static NCAR_Extension_New NCAR;
   // static Account acc;
  //  static Account accplant;
    //static NCAR_Cases__c cas;
    static NCAR_Cases__c cas1;
    static string returl='';
    static string retUrlold='ttt';
    static String selectedcontact = null;
    static boolean isreturn;
    static boolean isApprover;
    static boolean isSubmitted=true;
    static boolean isCDC;
    static boolean isvalid;
    static boolean displayactionstaken;
    static boolean firstload = true;
    //static Account acc ;
   
       
       
    public static testmethod NCAR_Extension_New myUnitTest(){
    //User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
      
     Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
      User u = (User) testData.get('testUser1'); 
           
    Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
    insert acc;
       
    Account accplant = new Account(Name='TestAcc',type = 'Ashland Plant',site = 'sitekhjkj');
    insert accplant;
       
    contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself',  No_Email__c = true);
    insert c; 
    
    SAP_Plant__c sapp = new SAP_Plant__c();
    sapp.Name= 'Test Plant';
    sapp.plant_Code__c='000965'; 
    insert sapp;
    
       Open_Orders__c order = new Open_Orders__c();
        order.Ordered_Qty_in_LB__c = 100;
        order.sales_Order_Number__c = '1234';
        order.key__c = 'NCARTEST1';
        order.Line_Item_Number__c = '0010';
        //Updated the query for Removal of G2
        //order.plant__c = [select id from SAP_Plant__c where plant_Code__c LIKE '%000965%'limit 1].id;
        order.plant__c = sapp.Id;
        order.shipTo__c = acc.id;
        order.soldTo__C = acc.id;
        insert order;
        Map<String, Schema.RecordTypeInfo> RTMap = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName(); 

        NCAR_Cases__c cas = new NCAR_Cases__c();
        cas.Account__c = acc.id;
        //cas.RecordTypeId = RTMap.get('Nexeo Standard Incident').getrecordtypeid();
        //cas.RecordTypeId = RTMap.get('Nexeo Credit Debit Claim').getrecordtypeid();
       
       isvalid=true;
       isreturn=true;
       isCDC=false;
       if(isreturn){
       cas.recordtypeid = RTMap.get('Nexeo Return').getrecordtypeid();
     
       // cas.recordtypeid = RTMap.get('Nexeo Standard Incident').getrecordtypeid();
         }
       if(isCDC){
        cas.recordtypeid = RTMap.get('Nexeo Credit Debit Claim').getrecordtypeid();
         }
     // else{
        //cas.recordtypeid = RTMap.get('Nexeo Standard Incident').getrecordtypeid();
       // }
       
        cas.subject__c = 'test';
        cas.Origin__c = 'SAP';
        cas.Status__c = 'Submitted to Purchasing';
        cas.nexeo_plant__c = acc.id;
        cas.category__c = 'Date Requested Not Met';
        cas.Import_Export__c = 'yes';
        cas.Acknowledgement_Format__c ='Fax';
        cas.category__c = 'Date Requested Not Met';
        cas.subcategory__c = 'Material not in stock';
        cas.subcategory_details__c ='Inventory Discrepancy';
        cas.customer_response_required__C = false; 
        cas.Contact__c= c.id; 
        cas.Type__c = 'Nexeo Physical Material Return';
        cas.Nexeo_Plant__c =accplant.id;
        cas.employee__c = u.id;
        cas.Restocking_Fee__c=2345.32;
        cas.Description__c='test';
       // cas.status__c = 'Submitted to Purchasing';
        cas.Route_To__c = 'Plant';
        cas.Formal_Corrective_Action_Response_Req1__c = 'Yes';
        cas.Acknowledgement_Format__c = 'Print/Mail';
        cas.case_to_clear_DZ__c='No';
        cas.response_format__c = 'Phone';
        cas.actions_taken__c = '';
        cas.carrier__c='Alliance';
        cas.collectible__c = true;
        cas.reason_rejected__c ='Tiers Dispute';
        insert cas;
       
 
        NCAR_Line_Item__c cl= new NCAR_Line_Item__c();
        cl.NCAR_Cases__c = cas.id;
        cl.open_orders__c = order.id;
        insert cl;
       
       
        apexpages.currentpage().getparameters().put('id', cas.id); 
        apexpages.currentpage().getparameters().put('cid', c.id); 
        apexpages.currentpage().getparameters().put('aid', acc.id); 
        apexpages.currentpage().getparameters().put('returl','account');
       
        ApexPages.standardController sc = new ApexPages.standardcontroller(cas);
        NCAR_Extension_New NCAR = new NCAR_Extension_New(sc);
       
       /* ApexPages.standardController sc1 = new ApexPages.standardcontroller(cas2);
        NCAR_Extension_New NCAR1 = new NCAR_Extension_New(sc1 );*/
       
        NCAR_Extension_New.wrapper wapObj = new NCAR_Extension_New.wrapper(order);
        wapObj.selected = true;
        NCAR.addorders();

        NCAR_Extension_New.wrapper wap = new NCAR_Extension_New.wrapper(cl);
        wap.selected = true;
        NCAR.addorders();
        NCAR.isreturn=true;
        NCAR.removelines();
        NCAR.subtitle = 'gdfsh';
        NCAR.selectedcontact = c.id;
        NCAR.contact = c;
        NCAR.salesorder = 'uuuu';
        NCAR.isApprover = true;
        NCAR.isSubmitted = false;
        NCAR.displayrequestmoreinfoerror = false;
        NCAR.accountchanged();
        NCAR.refreshcontact();
        NCAR.showcontactpopup();
        NCAR.createcontact();
        NCAR.hidecontactpopup();
        NCAR.searchorders();
        NCAR.savedraftincident();
        NCAR.createsubmitincident();
        NCAR.getiscontactvalid();
        NCAR.getdisplayapproverlayout();
        NCAR.isreturn=false;
        NCAR.searchorders();

        cas.revised_category__c = 'Revised Category';
        cas.revised_subcategory__c = 'Revised Subcategory';
        cas.revised_subcategory_details__c = '';
        cas.subcategory_details__c = '';
        cas.Formal_Corrective_Action_Response_Req1__c  ='Yes';
        cas.response_format__c = 'Email';
        cas.Status__c = 'Customer Response Required';
        cas.carrier__c='';
        cas.route_to__c = 'Plant';
       
        cas.Acknowledgement_Format__c = 'Email';
        update cas;
        return NCAR;
        }
       
       public static testmethod NCAR_Extension_New myUnitTestData2(){
      // User u = [select id, managerid from user where id = :userinfo.getuserid() limit 1];
       
       Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
      User u = (User) testData.get('testUser1'); 
           
      Account acc = new Account(Name='TestAcc',type = 'Distribution Customer',site = 'sitekhjkj');
     // insert acc;
       
      Account accplant = new Account(Name='TestAcc',type = 'Ashland Plant',site = 'sitekhjkj');
      insert accplant;
   
      contact c = new contact(Accountid = acc.id, firstname = 'Me', lastname = 'Myself',  No_Email__c = true);
      insert c; 
       
       
        SAP_Plant__c sapp = new SAP_Plant__c();
        sapp.Name= 'Test Plant';
        sapp.plant_Code__c='000965'; 
        insert sapp;
       
        Open_Orders__c order = new Open_Orders__c();
        order.Ordered_Qty_in_LB__c = 100;
        order.sales_Order_Number__c = '1234';
        order.key__c = 'NCARTEST';
        order.Line_Item_Number__c = '0010';
        //Updated the query for Removal of G2
       // order.plant__c = [select id from SAP_Plant__c where plant_Code__c LIKE '%000965%'limit 1].id;
        order.plant__c = sapp.Id;
        order.shipTo__c = acc.id;
        order.soldTo__C = acc.id;
        insert order;
          
           Map<String, Schema.RecordTypeInfo> RTMap1 = NCAR_Cases__c.sObjectType.getDescribe().getRecordTypeInfosByName();
           NCAR_Cases__c cas2 = new NCAR_Cases__c();
           cas2.recordtypeid = RTMap1.get('Nexeo Credit Debit Claim').getrecordtypeid();
           cas2.Formal_Corrective_Action_Response_Req1__c='Yes';
           cas2.Status__c ='More Information Required';
           cas2.route_to__c = 'QOS';
           cas2.reason_rejected__c='More Information Required';
            cas2.category__c = 'Date Requested Not Met';
            cas2.subcategory__c = 'Material not in stock';
            cas2.subcategory_details__c ='Inventory Discrepancy';
           
            insert cas2;
            ApexPages.standardController sc1 = new ApexPages.standardcontroller(cas2);
            NCAR_Extension_New NCAR1 = new NCAR_Extension_New(sc1 );
            return NCAR1 ;
        }
       
       
       public static testmethod void myUnitTest1(){
           NCAR_Extension_New NCAR  = myUnitTest();
           NCAR.getdisplayapproverlayout();
           NCAR.EvaluatorApprove();
           NCAR.addorders();}
           
            public static testmethod void myUnitTest18(){
           NCAR_Extension_New NCAR1 = myUnitTestdata2();
          
           
           NCAR1 .getdisplayapproverlayout();
           NCAR1 .EvaluatorApprove();}
        //NCAR.mycase = cas;
       
      
       public static testmethod void myUnitTest2(){
           NCAR_Extension_New NCAR  = myUnitTest();
           NCAR.approversaveincident();
           NCAR.removelines();
           NCAR.Cancel();
           NCAR.getDisplayReadOnlyLayout();
       }
      
       public static testmethod void myUnitTest3(){
           NCAR_Extension_New NCAR  = myUnitTest();
           NCAR.getDisplayDeliveryBlockRemovedButton();
           NCAR.DeliveryBlockRemoved();
           NCAR.getDisplayLevel1Approver();
           NCAR.removelines();
     
       }
      
       public static testmethod void myUnitTest4(){
           NCAR_Extension_New NCAR  = myUnitTest();
           NCAR.getDisplayDeliveryBlockRemovedButton();
           NCAR.DeliveryBlockRemoved();
           NCAR.getDisplayLevel1Approver();
           NCAR.getDisplayLevel2Approver();
           }
          
        public static testmethod void myUnitTest5(){
           NCAR_Extension_New NCAR  = myUnitTest();  
           NCAR.getDisplayLevel3Approver();
           NCAR.getDisplayQOSApprover();
           NCAR.getdisplayCSSApprover();
           try{
          NCAR.returntypechanged();
          }catch(exception e){}
           }
       public static testmethod void myUnitTest6(){
           NCAR_Extension_New NCAR  = myUnitTest();      
           NCAR.createsubmitReturn();
           NCAR.createsubmitclaim();
           NCAR.savedraftReturn();
           NCAR.savedraftClaim();
          
           }
      
       public static testmethod void myUnitTest7(){
           NCAR_Extension_New NCAR  = myUnitTest();
           NCAR.resubmitIncident();
           NCAR.toggledisplayactionstaken();
           }
          
          
        public static testmethod void myUnitTest8(){
            NCAR_Extension_New NCAR = myUnitTest();
            NCAR.ReturnProcessed();
            NCAR.CSSApprovedReturn();
            NCAR.Reject();
            NCAR.Approve();
            }
           
         public static testmethod void myUnitTest9(){
           NCAR_Extension_New NCAR  = myUnitTest();   
           NCAR.isSubmitted = true;
           try{
           NCAR.RequestMoreInfo();
           NCAR.EvaluatorReject();
           NCAR.QOSapprove();
           }catch(DmlException e){}
           
           }
          
         public static testmethod void myUnitTest10(){
           NCAR_Extension_New NCAR = myUnitTest(); 
           NCAR.QOSreject();
           NCAR.field1init();
           NCAR.Field2Changed();
           }
          
        public static testmethod void myUnitTest11(){
           NCAR_Extension_New NCAR  = myUnitTest();   
           NCAR.field1changed();
           NCAR.field3changed();
           NCAR.revfield1init();
           }
          
        public static testmethod void myUnitTest12(){
           NCAR_Extension_New NCAR  = myUnitTest();       
           NCAR.revfield1changed();
           NCAR.revfield2changed();
           NCAR.revfield3changed();
           NCAR.revfield4changed();
           }
          
        public static testmethod void myUnitTest13(){
           NCAR_Extension_New NCAR  = myUnitTest();
           NCAR.selectedcontact='';
           NCAR.refreshcontact();
           NCAR.selectedcontact='New';
           NCAR.refreshcontact();
           NCAR.isreturn = true;
           } 
           
       public static testmethod void myUnitTest14(){
          NCAR_Extension_New NCAR  = myUnitTest();
          NCAR.accountchanged();
          NCAR.refreshcontact();
          NCAR.showcontactpopup();
          NCAR.createcontact(); 
          }     
        
        public static testmethod void myUnitTest15(){
          NCAR_Extension_New NCAR1  = myUnitTestData2();
         
          NCAR1.savedraftincident();
          NCAR1.createsubmitincident();
          }
         
           public static testmethod void myUnitTest17(){
           NCAR_Extension_New NCAR1  = myUnitTestData2();
           NCAR1.hidecontactpopup();
           NCAR1.searchorders();
          
          }
        public static testmethod void myUnitTest16(){
          NCAR_Extension_New NCAR1  = myUnitTestData2();
          NCAR1.getiscontactvalid();
          NCAR1.getdisplayapproverlayout();
          NCAR1.isreturn=false;
          NCAR1.searchorders();
          }
          public static testmethod void myUnitTest19(){
           NCAR_Extension_New NCAR  = myUnitTest();
           try{
           NCAR.approverSaveReturn();
           NCAR.cancelandclose();
           }Catch(Exception e){}
          }
          /*public static testmethod void myUnitTest20(){
           NCAR_Extension_New NCAR  = myUnitTest();
           try{
           NCAR.cancelandclose();
           }Catch(Exception e){}
          }*/
          
}