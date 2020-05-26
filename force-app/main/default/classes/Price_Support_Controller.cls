public class Price_Support_Controller {


    Public Price_Request_Transaction__c transactions{Get;Set;}
    Public Id recordId{Get;Set;}
    public SAP_Price_Support__c priceSupport{Get;Set;}
    Public List<Price_Request_Transaction__c> prt{Get;Set;}
    public List<SAP_Price_Support__c> PS{Get;Set;}
    public List<Price_Support_Junction__c> PSJ{Get;Set;}    
    Public Date psDate = Date.Today();  
    public boolean checklist{get;set;}
    public Price_Support_Controller(ApexPages.StandardController sc) {
         checklist = false;       
       
        
        transactions = (Price_Request_Transaction__c)sc.getrecord();
        List<Id> ams = new List<Id>();
        List<Id> spslist = new List<Id>();
        
        prt = [select id, name, Account_Material__c, Account_Material__r.name, Ship_To_Account_Number__c, Ship_to_Name__c, HQ_Seller_Name__c, Ship_To_Seller__c, Competitive_Price__c, Plant__c, Region_of_Seller__c, 
            Price_Protection_Changed_Value__c, Requested_Drum_Deposit__c, Requested_Price_Protection__c, Approval_Level__c, Type__c, Approval_Status__c, Approver__r.name, Competitor__c,Competitor__r.name, Estimated_Annual_Volume__c,
                Estimated_Annual_Volume_UOM__c, Estimated_Order_Qty__c, Estimated_Order_Qty_UoM__c, Quantity__c, SAP_Material__c, Material__c, Ship_To__r.SAP_Payer_Account_Number__c, Ship_To__r.SAP_Payer_Account_Name__c from Price_Request_Transaction__c where id =: transactions.id];
        
        recordId = prt[0].id;
                
        for(Price_Request_Transaction__c prt1: prt){
            ams.add(prt1.Account_Material__c);
        }  
        
        PSJ = [Select id,Nexprice_CPI__c,SAP_Price_Support__c from Price_Support_Junction__c where Nexprice_CPI__c =: ams];                
        
        for(Price_Support_Junction__c psj1: PSJ){
           spslist.add(psj1.SAP_Price_Support__c);
       }
      
      If(PSJ.size()>0){  
        PS = [select id, Name, Supplier_Name__c,Material_Buying__r.Name,Supplier_Number__c,Customer_Name__r.Name,Deletion_Indicator__c,Expiration_Date__c,
              Base_Material_Code_Buying__c,Approval_Date__c, Job_Number__c,Effective_Date__c,Agreement_Number__c,X1st_Discount_Sell__c, Supplier_Supported_Price__c 
              from SAP_Price_Support__c where id =: spslist];
        
        if(PS.size()>0)
        checklist = true;      
   }
   }
   
   
    public String getHeaderDate() {   
      String result;
      result = getLongDate();
      return result;
    }

    public String getLongDate() {
      String LongDate = '';
      Datetime cDT = System.now();
      LongDate = cDT.format('MMMM d, yyyy');
      return LongDate;
    }

}