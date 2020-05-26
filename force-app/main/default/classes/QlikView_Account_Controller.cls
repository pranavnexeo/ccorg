public with sharing class QlikView_Account_Controller {

    public String accId{get;set;}
    public String accId1{get;set;}
    public String SalesOrg{get;set;}
    public String accntregion{get;set;}
    public String iframeSource { get; set; }
    public Id AccountId;
    public QlikView_Account_Controller(ApexPages.StandardController controller) {
    AccountId=(Id)controller.getRecord().id; 
    accId1=[select id, AccountNumber from Account where Id = :AccountId limit 1].AccountNumber;
    accId=drop_leading_zeros(accId1);
    
    system.debug('This is the account'+accId);
           
        SalesOrg = [select id, SAP_Sales_Org__c from Account where Id = :AccountId limit 1].SAP_Sales_Org__c;
        system.debug('AAAAA:'+ SalesOrg);
        
        accntregion = [select name, Region__c from Account_Region__c where name = :SalesOrg limit 1].Region__c;
            
        system.debug('BBBBB:'+ accntregion);
        if(accntregion == 'NA')
        iframeSource ='https://qlikplas.nexeosolutions.com/QvAJAXZfc/opendoc.htm?document=production%5Csales%20reports2.0%20-%20na.qvw&host=QVS%40CDCVQLKP01&Select=LB526,2&Select=LB523';
        else if(accntregion == 'EMEA')
        iframeSource ='https://qlikplas.nexeosolutions.com/QvAJAXZfc/opendoc.htm?document=production%5Csales%20reports2.0%20-%20emea.qvw&host=QVS%40CDCVQLKP01&Select=LB526,2&Select=LB523';
        else if(accntregion == 'ASIA')
        iframeSource ='https://qlikplas.nexeosolutions.com/QvAJAXZfc/opendoc.htm?document=production%5Csales%20reports2.0%20-%20asia.qvw&host=QVS%40CDCVQLKP01&Select=LB526,2&Select=LB523';
        else
        iframeSource ='https://qlikplas.nexeosolutions.com/QvAJAXZfc/opendoc.htm?document=production%5Csales%20reports2.0%20-%20na.qvw&host=QVS%40CDCVQLKP01&Select=LB526,2&Select=LB523';
    }
    public static String drop_leading_zeros(String passedValue) {
        String return_string = null; 
        if (passedValue != null) { 
            return_string = passedValue.trim(); 
            Pattern valid_characters = Pattern.compile('([0-9]+)'); 
            Matcher check_chars = valid_characters.matcher(return_string); 
            if (check_chars.matches()) { 
                if (return_string.startsWith('0') && return_string.length() > 1) { 
                    boolean keepChecking = true; 
                    while (keepChecking) { 
                        if (return_string.startsWith('0') && return_string.length() > 1) { 
                            return_string = return_string.substring(1);
                        } else { 
                            keepChecking = false; 
                        }
                    }
                }
                if (return_string == '0') { 
                    return_string = null; 
                }
            } else { 
                return_string = null; 
            }
        }
        return return_string; 
        
    }
    
    
}