@isTest
public class  Integration_Error_Functions_Test{
 
  public static testMethod void Test1() {
     string subject='test';
     string body = '';
     body += '============\n';
     body += 'iDoc Number : 12345\niDoc# 12345\nidocNumber : 12345\n';
     body += 'SAP_Customer_Number_c : 12345\nAccount Number : 12345\n';
     body += 'SAP CUstomer Number : 12345\nShipTo_Number__c 12345\nSAP_Supplier_Number : 12345\n';
     body += 'SAP_Supplier_Number__c = 12345\nSAP_Sales_Org_c : 12345\nSAP_Sales_Org__c 12345\n';
     body += 'SAP_DistChannel_c : 12345\nDistribution_Channel_Code__c 12345\nEmployee ID : 12345\n';
     body += 'SAP_Division_Code_c : 12345\nCustomer Number 12345\nSAP_Business_Parter_Customer_Number__c : 12345\n';
     body += 'Customer Number# 12345\nAccount id : 12345\nUser Id : 12345\n*******\n=================';
    
     Integration_Error_Functions.insertError(subject, body);
     Integration_Error_Functions.findValue('subject', 'subject body');
      
     string body2 = '';
     body2 += 'IDoc Number 12345\niDoc# 12345\nidocNumber  12345\n';
     body2 += 'SAP_Customer_Number_c : 12345\nAccount Number : 12345\n';
     body2 += 'SAP CUstomer Number : 12345\nShipTo_Number__c 12345\nSAP_Supplier_Number : 12345\n';
     body2 += 'SAP_Supplier_Number__c = 12345\nSAP_Sales_Org_c : 12345\nSAP_Sales_Org__c 12345\n';
     body2 += 'SAP_DistChannel_c : 12345\nDistribution_Channel_Code__c 12345\nEmployee ID : 12345\n';
     body2 += 'SAP_Division_Code_c : 12345\nCustomer Number 12345\nSAP_Business_Parter_Customer_Number__c : 12345\n';
     body2 += 'Customer Number# 12345\nAccount id : 12345\nUser Id : 12345';
     body2 += 'Sales_Org_Code__c';
     body2 += 'SAP_Business_Partner_Customer_Number__c :';
     body2 += 'Records Details as below';
     body2 += '\n*******';
     Integration_Error_Functions.insertError(subject, body2);
      
  }

}