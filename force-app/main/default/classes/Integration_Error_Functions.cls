public class Integration_Error_Functions{

public static void insertError(String subject, string body){
  
  List<Integration_Error__c> errors = new List<Integration_Error__c>();
  
  boolean foundstars = false;
  boolean foundbars = false;
  boolean inprogress = false;  
  string errorstr = '';  
  string idoc = ''; 
  string AccountNumber = '';
  string salesorg = '';
  string distchan = '';  
  string division = ''; 
  string custnum = '';
  string aid = '';
  string uid = ''; 
  string vendor = '';  
  string employee = '';  

  List<String> lines = new List<String>();
  
  if(body != null)
    lines.addall(body.split('\n'));
 
  system.debug('lines: ' + lines.size());
  system.debug('body: ' + body);
  for(string str:lines)
  {  
     string s = str.trim();
     
     if(s.containsIgnoreCase('============'))
       foundbars = true;
          
     if(s.containsIgnoreCase('IDoc') && !s.containsIgnoreCase('IDoc#'))
       idoc = findValue('IDoc', s); 
     
     if(s.containsIgnoreCase('IDoc Number') && !s.containsIgnoreCase('IDoc Number :'))
       idoc = findValue('IDoc Number', s);
       
     if(s.containsIgnoreCase('IDoc Number :'))
       idoc = findValue('IDoc Number :', s);     
         
     if(s.containsIgnoreCase('IDoc#'))
       idoc = findValue('IDoc#', s);

     if(s.containsIgnoreCase('IdocNumber :'))
       idoc = findValue('IdocNumber :', s);
                       
     if(s.containsIgnoreCase('SAP_Customer_Number_c :'))
       AccountNumber = findValue('SAP_Customer_Number_c :', s); 
       
     if(s.containsIgnoreCase('Account Number : '))
       AccountNumber = findValue('Account Number : ', s);   
        
     if(s.containsIgnoreCase('SAP Customer Number : '))
       AccountNumber = findValue('SAP Customer Number : ', s);
     
     if(s.containsIgnoreCase('ShipTo_Number__c'))
       AccountNumber = findValue('ShipTo_Number__c', s);
          
     if(s.containsIgnoreCase('SAP_Supplier_Number :'))
       vendor = findValue('SAP_Supplier_Number :', s);
       
     if(s.containsIgnoreCase('SAP_Supplier_Number__c ='))
       vendor = findValue('SAP_Supplier_Number__c =', s);
                 
     if(s.containsIgnoreCase('SAP_Sales_Org_c :'))
       SalesOrg = findValue('SAP_Sales_Org_c :', s);
     
     if(s.containsIgnoreCase('Sales_Org_Code__c'))
        SalesOrg = findValue('Sales_Org_Code__c', s);     
       
     if(s.containsIgnoreCase('SAP_DistChannel_c :'))
       DistChan = findValue('SAP_DistChannel_c :', s); 
        
     if(s.containsIgnoreCase('Distribution_Channel_Code__c'))
       DistChan = findValue('Distribution_Channel_Code__c', s);  
     
     if(s.containsIgnoreCase('Employee ID :'))
       employee = findValue('Employee ID :', s);
            
     if(s.containsIgnoreCase('SAP_Division_Code'))
       Division = findValue('SAP_Division_Code_c :', s);
               
     if(s.containsIgnoreCase('Customer Number ') && 
       !s.containsIgnoreCase('Customer Number# ') && 
       !s.ContainsIgnoreCase('SAP Customer Number :'))
          custnum = findValue('Customer Number ', s);
     
     if(s.containsIgnoreCase('SAP_Business_Partner_Customer_Number__c :'))
       custnum = findValue('SAP_Business_Partner_Customer_Number__c :', s);
           
     if(s.containsIgnoreCase('Customer Number# '))
       custnum = findValue('Customer Number# ', s);
                
     if(s.containsIgnoreCase('Account Id :'))
       aid = findValue('Account Id :', s);
     
     if(s.containsIgnoreCase('User Id :'))
       uid = findValue('User Id :', s);  

     if((s.containsIgnoreCase('*****') || (s.containsIgnoreCase('Records Details as below') && foundbars)) && inprogress == false){
       foundstars = true;
       inprogress = true;        
     }
     else{
       if((s.containsIgnoreCase('*****') || s.containsIgnoreCase('========')) && inprogress == true){  
          inprogress = false;  
          errors.add(generateError(subject, body, errorstr, idoc, AccountNumber, SalesOrg, DistChan, Division, custnum, aid, uid, vendor, employee));  
          errorstr = '';    
          idoc = ''; 
          AccountNumber = '';
          SalesOrg = '';
          DistChan = '';
          Division = '';
          CustNum = '';
          aid = '';
          uid = '';
          vendor = ''; 
          Employee = '';            
       } 
     }
     if(inprogress == true && !s.containsIgnoreCase('*****') && !s.containsIgnoreCase('======='))
        {
          errorstr += s + '\n';   
        } 
  }
  if(errors.size() == 0)
    errors.add(generateError(subject, body, body, idoc, AccountNumber, SalesOrg, DistChan, Division, custnum, aid, uid, vendor, employee));
  if(errors.size() > 0)
    insert errors;  
}
@TestVisible private static Integration_Error__c generateError(string subject, string body, string errorstring, string iDoc,
                                                  string AccountNumber, String SalesOrg, String DistChan, String Division,
                                                  string custnum, string aid, string uid, string vendor, string employee){
    Integration_Error__c e = new Integration_Error__c();
    e.name = subject;
    e.Interface__c = subject.right(subject.length() - subject.lastindexof('ERROR - ') - 8);
    e.email__c = body;
    e.error_details__c = errorstring;  
    e.iDoc_Number__c = idoc;
    e.error_short__c = errorstring.abbreviate(250); 
    e.Account_Number__c = accountnumber;
    e.Sales_Org__c = salesorg;
    e.Distribution_Channel__c = distchan;
    e.Division__c = division;
    e.Customer_Number__c = custnum;
    e.Account_Id__c = aid;
    e.User_Id__c = uid;
    e.Vendor_Number__c = vendor; 
    e.Employee_Number__c = employee;
    return e; 
  
}

@TestVisible private static string findValue(string key, string instr){
  string val = '';  
  for( integer i=(instr.indexofignorecase(key) + key.length()); i< instr.length(); i++)
  {  
     string s = instr.mid(i, 1);
     if(!s.isWhiteSpace() && s != '.' && s != ':' && s != ',')
     val += s;
     if( s.isWhiteSpace() && val != '')
        break;
             
  }
  return val.trim();
}

}