// Class Name: PriceSupportRequest
// Developer Name: Sneha Likhar
// Functionality Description:  Price_support_request_page Controller
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


public class PriceSupportRequest{

    @remoteaction
    public static List<Price_Support_Request__c> getAllRecords() {
      return [SELECT Id, Name, CUPS__c,Upfront__c,Supplier__r.Name,Agreement_Number__c,Payer__c,ship_to_name_Number__c,material_name_and_number__c,Effective_Date__c,Closed_Date__c,Price_Request_Transaction__r.Ship_To__r.Name,Price_Request_Transaction__r.Ship_To__r.AccountNumber,Material_Buying__r.Name,Support_Disc1_UoM__c,Support_Disc2_UoM__c,Support_Disc_1__c,Support_Disc_2__c,Expiration_Date__c,Additional_Comments__c,Customer_Name__r.SAP_Payer_Account_Name__c,Customer_Name__r.SAP_Payer_Account_Number__c,Customer_Name__r.Name,Customer_Name__r.AccountNumber,Base_Material_Code_Buying__c,Supplier_Supported_Price__c,status__c,Material_Group_2_Buying__c,UOM__c,Plant_name_and_number__c,Material_Buying__r.Material_Group2_Code__c,Supplier_Name__c FROM Price_Support_Request__c where Status__c = 'Open'];
    }    
    
    Public static string getDateFormat(){
      date d = Date.valueof('1999-01-22');
      string dformat = d.format();
      string f = '';
    
      if(dformat.indexof('22') < dformat.indexof('01'))
        f = 'dd/mm';
      else
        f = 'mm/dd';
      if(dformat.indexof('01') < dformat.indexof('1999'))
        f = f + '/yy';
      else
        f = 'yy/' + f;
      return f;
      
  }
  
  @RemoteAction
  public static void saveRecord(String RequestId,String comments){
     
      if(RequestId != null && RequestId != '')
        {
              RequestId = RequestId.replaceall('Ids=', '');
              List<String> splitstrings = RequestId.split('&');     
                         
              List<Price_Support_Request__c> addComm = [Select Id,Comments__c,Status__c from  Price_Support_Request__c where Id in : splitstrings];             
                        
                 for(Price_Support_Request__c psr:addComm)
                 {            
                    psr.Status__c = 'Closed';
                    psr.Comments__c = comments;                    
                 }
            
             update addComm;
        }
    }    
      
}