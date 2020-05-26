/**  
* @Name PriceSupportMassApproveRejectController
* @Purpose This is a controller class used Mass Approve/Reject Price Supports .
* @Author  Deepak
* @Version 1.0 
*/
public with sharing class PriceSupportMassApproveRejectController {
    
    public list<Wrapper> nexeoPriceSupports{get ;set;}
    public list<Wrapper> supplierPriceSupports{get; set;}
    public String nexeoComments {get;set;}
    public String supplierComments {get;set;}
    private final String NEXEO_APPROVAL = 'Nexeo Approval';
    private final String NEXEO_REJECTION = 'Nexeo Rejection';
    private final String SUPPLIER_APPROVAL = 'Supplier Approval';
    private final String SUPPLIER_REJECTION = 'Supplier Rejection';
    public String customerName{get;set;}
    public boolean isNexeoEmpty{get;set;}
    public boolean isSupplierEmpty{get;set;}
    public String tabInFocus{get;set;}
    public ApexPages.StandardSetController setCon{get;set;}
    Public Integer size{get;set;} 
    
    List<Price_Support__c> nexeoApprovalList=null;
    List<Price_Support__c> supplierApprovalList=null;
    Set<String> supplierGroupIds = new Set<String>();
    Set<String> nexeoGroupIds = new Set<String>();
    String awaitingNexeoApproval = '\''+PriceSupportUtil.AWAITING_NEXEO_APPROVAL+'\'';
    String awaitingSupplierApproval = '\''+PriceSupportUtil.AWAITING_SUPPLIER_APPROVAL+'\'';
    private String soql;
    private String soqlNexeo;
    public integer noOfRecords{get;set;}
    
    public PriceSupportMassApproveRejectController(){
        String tabName = Apexpages.currentPage().getParameters().get('tab');
        if(tabName==null || tabName=='')
            tabInFocus='NexeoTab';
        else
            tabInFocus='SupplierTab';
        System.debug('---------tabInFocus---------'+tabInFocus);
        init();
    }
    
     public String sortDir {
    get  { if (sortDir == null) {  sortDir = 'asc'; } return sortDir;  }
    set;
  }
   public String sortField {
    get  { if (sortField == null) {sortField = 'CustomerName_Mail__c'; } return sortField;  }
    set;
  }
    
    
    // public PageReference runSearch() {

   // String customerName = Apexpages.currentPage().getParameters().get('customerName');
   //  init();
 
    //soql = 'Select Id,name,Agreement_Number__c,Status__c,Support_Type__c,Customer_Name__c,Material_Description_Selling__c,Supplier_Name__c,Supplier_Supported_Price__c,Upfront_Cost__c,Purchase_Cost__c,Nexeo_Main_Approver_Name__c,New_or_Changed__c,Supplier_Reference__c,Hub_Name__c,Supplier_Main_Approver_Name__c,Units__c,Dis1_Sell__c,Dis2_Sell__c,Dis1_Buy__c,Dis2_Buy__c,Requested_Rebate_Amount__c,Effective_Date__c,Expiration_Date__c from Price_Support__c where Archieved__c=false AND (Supplier_Group__c IN:supplierGroupIds OR Supplier_Main_Approver__c='+'\''+UserInfo.getUserId()+'\')';
     // if (!customerName.equals(''))
     // soql += ' and CustomerName_Mail__c LIKE \'%'+String.escapeSingleQuotes(customerName)+'%\''; 
   
     //run the query again
   // runQuery();
   
    //return null;
 // }
  
  /** public void runQuery() {
 
    try {
        setCon = new ApexPages.StandardSetController(Database.getQueryLocator(soql));
      size = 200;
      setCon.setPageSize(size); 
      noOfRecords = setCon.getResultSize();
    } catch (Exception e) {
      ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, e.getMessage()));
    }
 
  }**/
  
    /**  
  * @Name toggleSort
  * @Purpose This method is used to toggle the sort.
  * @param 
  * @return 
  * @Author  Deepak
  */
  // toggles the sorting of query from asc<-->desc
   public void toggleSort() {
    // simply toggle the direction
    System.debug('-----------Inside toggleSort------------');
    sortDir = sortDir.equals('asc') ? 'desc' : 'asc';
  
    // run the query again
   init();
  }
    
    /**  
    * @Name init
    * @Purpose This is used fetch those Price Supports that are awaiting approval and that can be approved by logged in User.
    * @param 
    * @return 
    * @Author  Deepak
    */
    public void init(){
                
        String customerName = Apexpages.currentPage().getParameters().get('customerName');
        system.debug('---------Customer Name-----------' +customerName );
        nexeoPriceSupports = new List<Wrapper>();
        supplierPriceSupports = new List<Wrapper>();
        List<Supplier_Member__c> supplierMembers=[SELECT Approver__c,Supplier_Group__r.Id, Name__r.Id,Supplier_Group__r.Main_Approver__c FROM Supplier_Member__c where (Name__r.Id=:UserInfo.getUserId()  AND Approver__c=true ) OR Supplier_Group__r.Main_Approver__c=:UserInfo.getUserId()]; 
        List<Nexeo_Member__c> nexeoMembers=[SELECT Approver__c, Name__r.Id, Nexeo_Group__r.Id, Supplier_Group__r.Id,Nexeo_Group__r.Main_Approver__c,Supplier_Group__r.Main_Approver__c FROM Nexeo_Member__c where (Name__r.Id=:UserInfo.getUserId() AND  Approver__c=true )OR Supplier_Group__r.Main_Approver__c=:UserInfo.getUserId() OR Nexeo_Group__r.Main_Approver__c=:UserInfo.getUserId()];
        
        for(Nexeo_Member__c member:nexeoMembers){
            if(member.Nexeo_Group__r.Id!=null){
                nexeoGroupIds.add(member.Nexeo_Group__r.Id);
            }
            if(member.Supplier_Group__r.Id!=null){
                supplierGroupIds.add(member.Supplier_Group__r.Id);
            }
        }
        
        for(Supplier_Member__c member:supplierMembers){
            
            if(member.Supplier_Group__r.Id!=null){
                supplierGroupIds.add(member.Supplier_Group__r.Id);
            }
        }
        
        System.debug('---------nexeoGroupIds---------'+nexeoGroupIds);
        System.debug('---------supplierGroupIds---------'+supplierGroupIds);
        
        /*String query = 'SELECT ';
          for(Schema.FieldSetMember f : SObjectType.Price_Support__c.FieldSets.Approval_Wizard_Fields.getFields()) {
             query += f.getFieldPath() + ', ';
          }
          query += 'name,Id,Nexeo_Group__c,Submitted_to_Supplier_by__c,Submitted_to_Supplier_Date__c,Supplier_1st_Action_by__c,SAP_Transfer__c,Supplier_1st_Action_Date__c,Final_Action_by__c,Final_Action_by_Date__c,Additional_Comments__c,Supplier_Group__c,Nexeo_Main_Approver__c,Supplier_Main_Approver__c from Price_Support__c where Status__c=';
          System.debug('-----Query-------'+query);
          
          nexeoApprovalList = Database.query(query+awaitingNexeoApproval+' AND Nexeo_Group__c IN:nexeoGroupIds');
          supplierApprovalList = Database.query(query+awaitingSupplierApproval + 'AND Supplier_Group__c IN: supplierGroupIds');*/
        
          System.debug('-----Customer Name-------'+customerName );
          
          soqlNexeo = 'Select Support_ID__c,Support_Type__c,Customer_Name__c,Region_Code__c,All_regions__c,CustomerName_Mail__c,Supplier_Name__c,New_or_Changed__c,Nexeo_Group_Name__c,Supplier_Group_Name__c,'+
          'Effective_Date__c,Expiration_Date__c,Net_Support_Cost__c,Net_Purchase_Cost__c,Requested_Rebate_Amount__c,Status__c,'+
          'Name,Id,Nexeo_Group__c,Submitted_to_Supplier_by__c,Submitted_to_Supplier_Date__c,Supplier_1st_Action_by__c,SAP_Transfer__c,'+
          'Supplier_1st_Action_Date__c,Final_Action_by__c,Final_Action_by_Date__c,Additional_Comments__c,Supplier_Group__c,'+
          'Nexeo_Main_Approver__c,Supplier_Main_Approver__c from Price_Support__c '+
          ' where  Status__c='+'\'' + PriceSupportUtil.AWAITING_NEXEO_APPROVAL + '\' AND ( Nexeo_Group__c IN:nexeoGroupIds OR Nexeo_Main_Approver__c='+'\''+UserInfo.getUserId()+'\')';
          
          if (customerName!=null && !customerName.equals(''))
          soql += 'and CustomerName_Mail__c LIKE \'%'+String.escapeSingleQuotes(customerName)+'%\''; 
          soql += 'order by ' +sortfield+' '+sortdir+' ';
          system.debug(soqlNexeo);
          
          nexeoApprovalList = Database.query(soqlNexeo );
         
          
       
           
           soql ='Select Support_ID__c,Support_Type__c,Customer_Name__c,Region_Code__c,All_Regions__c,Supplier_Name__c,Nexeo_Group_Name__c,Supplier_Group_Name__c,'+
          'Effective_Date__c,Expiration_Date__c,Net_Support_Cost__c,Net_Purchase_Cost__c,Requested_Rebate_Amount__c,Status__c,'+
          'Name,Id,Nexeo_Group__c,Submitted_to_Supplier_by__c,Submitted_to_Supplier_Date__c,Supplier_1st_Action_by__c,SAP_Transfer__c,'+
          'Supplier_1st_Action_Date__c,Final_Action_by__c,Final_Action_by_Date__c,Additional_Comments__c,Supplier_Group__c,'+
          'Nexeo_Main_Approver__c,Supplier_Main_Approver__c,Material_Description_Buying__c,Supplier_Supported_Price__c,Packaging_Allowance__c,'+
          'Dis2_Sell__c,Dis1_Sell__c,Freight_Allowance_Selling__c,Upfront_Cost__c,Other_Allowances__c,New_or_Changed__c,'+
          'Supplier_Sales_Contact__c,Competitor_Name__c,Actual_Annual_Volume__c,Competitor_Manufacturer__c,Application__c,Market_Segment__c,Seller__c '+ 
          'from Price_Support__c where Status__c=' +'\''+PriceSupportUtil.AWAITING_SUPPLIER_APPROVAL +'\' AND (Supplier_Group__c IN :supplierGroupIds OR Supplier_Main_Approver__c='+'\''+UserInfo.getUserId()+'\')';
          if (customerName!=null && !customerName.equals(''))
          soql += 'and CustomerName_Mail__c LIKE \'%'+String.escapeSingleQuotes(customerName)+'%\''; 
          soql += 'order by ' +sortfield+' '+sortdir+' ';
          system.debug(soql);
          supplierApprovalList=Database.query(soql);
         
          
         
          
          
          Wrapper wrap = null;
          if(nexeoApprovalList!=null && !nexeoApprovalList.isEmpty()){
            isNexeoEmpty = false;
            for(Price_Support__c nexeoSupport:nexeoApprovalList){
                wrap = new Wrapper(nexeoSupport);
                nexeoPriceSupports.add(wrap);
            }
          }else{
            isNexeoEmpty = true;
          }
          if(supplierApprovalList!=null && !supplierApprovalList.isEmpty()){
            isSupplierEmpty = false;
            for(Price_Support__c supplierSupport:supplierApprovalList){
                wrap = new Wrapper(supplierSupport);
                supplierPriceSupports.add(wrap);
            }
          }else{
            isSupplierEmpty = true;
          }
            
          System.debug('---------nexeoApprovalList---------'+nexeoApprovalList);
          System.debug('---------supplierApprovalList---------'+supplierApprovalList);      
    }
    /**  
    * @Name nexeoApprove
    * @Purpose This is used to perform Nexeo approval.
    * @param 
    * @return PageReference
    * @Author  Deepak
    */
    public PageReference nexeoApprove(){
        
        PageReference pageRef = Page.PriceSupportMassApproveReject;
        pageRef.setRedirect(true); 
        System.debug('--------nexeoApprove Nexeo Comments---------'+nexeoComments);
        if(nexeoPriceSupports.size()>0){
            List<Price_Support__c> updateObj = processRecords(nexeoPriceSupports,NEXEO_APPROVAL);
            if(updateObj.size()>0){
                update updateObj;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Completed Mass Nexeo Approval.'));
            }
        }
    
        return pageRef; 
        //
    }
    /**  
    * @Name nexeoReject
    * @Purpose This is used to perform Nexeo Rejection.
    * @param 
    * @return PageReference
    * @Author  Deepak
    */
    public PageReference nexeoReject(){
        
        PageReference pageRef = Page.PriceSupportMassApproveReject;
        pageRef.setRedirect(true); 
        System.debug('--------nexeoReject Nexeo Comments---------'+nexeoComments);
        if(nexeoPriceSupports.size()>0){
            List<Price_Support__c> updateObj = processRecords(nexeoPriceSupports,NEXEO_REJECTION);
            if(updateObj.size()>0){
                update updateObj;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Completed Mass Nexeo Rejection.'));
            }
        }
        
        return pageRef; 
        
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Completed Mass Nexeo Rejection.'));
    }
    /**  
    * @Name supplierApprove
    * @Purpose This is used to perform Supplier Approval.
    * @param 
    * @return PageReference
    * @Author  Deepak
    */
    public PageReference supplierApprove(){
    
        System.debug('--------supplierApprove Supplier Comments---------'+supplierComments);
        PageReference pageRef = Page.PriceSupportMassApproveReject;
        pageRef.setRedirect(true);
        pageRef.getParameters().put('tab','SupplierTab'); 
        system.debug('***************Entering If');
        if(supplierPriceSupports.size()>0){
            List<Price_Support__c> updateObj = processRecords(supplierPriceSupports,SUPPLIER_APPROVAL);
            if(updateObj.size()>0){
                update updateObj;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Completed Mass Supplier Approval.'));
            }
        }
        return pageRef; 
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Completed Mass Supplier Approval.'));
    }
    /**  
    * @Name supplierReject
    * @Purpose This is used to perform Supplier Rejection.
    * @param 
    * @return PageReference
    * @Author  Deepak
    */
    public PageReference supplierReject(){
        PageReference pageRef = Page.PriceSupportMassApproveReject;
        pageRef.setRedirect(true); 
        System.debug('--------supplierReject Supplier Comments---------'+supplierComments);
        if(supplierPriceSupports.size()>0){
            List<Price_Support__c> updateObj = processRecords(supplierPriceSupports,SUPPLIER_REJECTION);
            if(updateObj.size()>0){
                update updateObj;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Completed Mass Supplier Rejection.'));
            }
        }
        pageRef.getParameters().put('tab','SupplierTab');
        return pageRef; 
        //ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.INFO,'Completed Mass Supplier Rejection.'));
    }
    /**  
    * @Name processRecords
    * @Purpose This is used to process the records selected for approval/rejection.
    * @param  List<Wrapper>
    * @return  List<Price_Support__c>
    * @Author  Deepak
    */
    private List<Price_Support__c> processRecords(List<Wrapper> wrapperList,String operation){
        
        System.debug('----------processRecords-----------Operation--'+operation);
        List<Price_Support__c> processedList = new List<Price_Support__c>();
        Price_Support__c priceObj = null;
        for(Wrapper wrapObj:wrapperList){
            System.debug('--------isselected---------'+wrapObj.isselected);
            if(wrapObj.isselected){
                priceObj = wrapObj.pricesupport;
                if(operation.equalsIgnoreCase(NEXEO_APPROVAL)){
                    priceObj.Status__c = PriceSupportUtil.AWAITING_SUPPLIER_APPROVAL;
                    priceObj.Submitted_to_Supplier_by__c = System.Userinfo.getName();
                    priceObj.Submitted_to_Supplier_Date__c = System.today();
                    priceObj.Additional_Comments__c = nullCheck(priceObj.Additional_Comments__c)+'\n'+System.now()+' '+nexeoComments;
                }else if(operation.equalsIgnoreCase(NEXEO_REJECTION)){
                    priceObj.Status__c = PriceSupportUtil.REJECTED;
                    priceObj.Additional_Comments__c = nullCheck(priceObj.Additional_Comments__c)+'\n'+System.now()+' '+nexeoComments;
                }else if(operation.equalsIgnoreCase(SUPPLIER_APPROVAL)){
                    System.debug('--------Supplier Approval---------');
                    priceObj.Status__c = PriceSupportUtil.APPROVED;
                    if(priceObj.Support_Type__c ==PriceSupportUtil.REBATE){
                        priceObj.SAP_Transfer__c = PriceSupportUtil.OPEN;
                    }
                    priceObj.Supplier_1st_Action_by__c = System.Userinfo.getName();
                    priceObj.Supplier_1st_Action_Date__c = System.today();
                    priceObj.Final_Action_by__c = System.Userinfo.getName();
                    priceObj.Final_Action_by_Date__c = System.now();
                    System.debug('---------priceObj.Additional_Comments__c'+priceObj.Additional_Comments__c);
                    System.debug('---------supplierComments'+supplierComments);
                    priceObj.Additional_Comments__c = nullCheck(priceObj.Additional_Comments__c)+'\n'+System.now()+' '+supplierComments;
                }else if(operation.equalsIgnoreCase(SUPPLIER_REJECTION)){
                    System.debug('--------Supplier Rejection---------');
                    priceObj.Status__c = PriceSupportUtil.REJECTED_BY_SUPPLIER;
                    priceObj.Supplier_1st_Action_by__c = System.Userinfo.getName();
                    priceObj.Supplier_1st_Action_Date__c = System.today();
                    priceObj.Additional_Comments__c = nullCheck(priceObj.Additional_Comments__c)+'\n'+System.now()+' '+supplierComments;
                }
                
                processedList.add(priceObj);
            }
        }
        System.debug('--------processedList---------'+processedList);
        if(processedList.isEmpty()){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.severity.ERROR,'Please select atleast one record.'));
        }
        return processedList;
    }
    
    /**  
    * @Name Wrapper
    * @Purpose This a wrapper class used to get the selected records.
    * @param  
    * @return  
    * @Author  Deepak
    */
    public class Wrapper{

        public Price_Support__c pricesupport{get; set;}
        public boolean isselected{get; set;}
        
        public wrapper(Price_Support__c p){
            pricesupport = p;
            isselected = false;
        }
    }
    
    private String nullCheck(String val){
        
        if(val==null){
            return '';
        }else{
            return val;
        }
    
    }
    
    
}