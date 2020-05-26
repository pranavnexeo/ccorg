/***********************************************************************************************************************   
Nexeo Solutions    
---------------------------------------------------------------------------------------------------------------------
*
*   Date Created:        4/10/2017
*   Author:              Shwetha Suvarna
*   Last Modified:       4/10/2017
*   Last Modified By:    Shwetha Suvarna
*
*   **********************************************************************************************************************/

@isTest
private class CPI_AfterUpsertTest {
    public static testMethod void testmybatch1(){ 
    
        List<Account> acclist = new List<Account>();    
        //Account a = new Account(Name = 'test',type = 'Customer',AccountNumber='12343',Account_Number__c='000001234310003031');
       // insert a;
       Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
        Account a= (Account) testData.get('testGeneralAccount2');
        User u = (User) testData.get('firstUser');
        //Account a1 = new Account(Name = 'test1',type = 'Customer',AccountNumber='12347',ccrz__UsedByCloudcraze__c=true,Account_Number__c='000001234710003031');
        //insert a1;
        System.runAs(u) {
        Material_General_Data2__c mgd2 = new Material_General_Data2__c(Material_Number__c ='091234',Division_Code__c='31');        
        insert mgd2;
        Material_Sales_Data2__c msd = new Material_Sales_Data2__c(Name='test',Material_Number__c='091234',Create_CC_Product__c=false,Dist_Channel_Code__c='30',Record_Key__c='09123410003031',Sales_Org_Code__c='1000');
        insert msd;
        Customer_Product_Info__c cpi = new Customer_Product_Info__c(ShipTo_Number__c='0000012343',SAP_Material__c=msd.id,Chem_Account__c =a.id,CPI_Account__c=a.id,Deletion_Indicator__c='',CPI_Record_Type__c='1',Material_Number__c='091234',Customer_Number__c='12343',Distribution_Channel_Code__c='30',Record_Key__c='11234310003031091234',Sales_Org_Code__c='1000');
        insert cpi;
        Account_Material__c am = new Account_Material__c(Account__c=a.id,SAP_Material__c=msd.id);
        insert am;
        }
       // Customer_Product_Info__c cpi1 = new Customer_Product_Info__c(ShipTo_Number__c='0000012347',SAP_Material__c=msd.id,Es_Account__c =a1.id,Comp_Account__c =a1.id,Plastics_Account__c=a1.id,CPI_Account__c=a1.id,Deletion_Indicator__c='X',CPI_Record_Type__c='1',Material_Number__c='091234',Customer_Number__c='12343',Distribution_Channel_Code__c='30',Record_Key__c='11234710003033091231',Sales_Org_Code__c='1000');
       // insert cpi1;
       // Customer_Product_Info__c cpi2 = new Customer_Product_Info__c(ShipTo_Number__c='0000012347',SAP_Material__c=msd.id,Es_Account__c =a1.id,CPI_Account__c=a1.id,Deletion_Indicator__c='',CPI_Record_Type__c='1',Material_Number__c='091234',Customer_Number__c='12347',Distribution_Channel_Code__c='30',Record_Key__c='11234710003033091234',Sales_Org_Code__c='1000');
       // insert cpi2;
                
        List<Id> accId = new List<Id>();
        accId.add(a.id);
        accList.add(a);
    
    }
    public static testMethod void testmybatch2(){
    
        List<Account> acclist = new List<Account>();    
       // Account a = new Account(Name = 'test',type = 'Customer',AccountNumber='12343',Account_Number__c='000001234310003031');
        //insert a;
        Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
        Account a= (Account) testData.get('testGeneralAccount2');
        User u = (User) testData.get('firstUser');
       // Account a1 = new Account(Name = 'test1',type = 'Customer',AccountNumber='12347',ccrz__UsedByCloudcraze__c=true,Account_Number__c='000001234710003031');
       // insert a1;
        System.runAs(u){
        Material_General_Data2__c mgd2 = new Material_General_Data2__c(Material_Number__c ='091234',Division_Code__c='31');        
        insert mgd2;
        Material_Sales_Data2__c msd = new Material_Sales_Data2__c(Name='test',Material_Number__c='091234',Create_CC_Product__c=false,Dist_Channel_Code__c='30',Record_Key__c='09123410003031',Sales_Org_Code__c='1000');
        insert msd;
        Customer_Product_Info__c cpi = new Customer_Product_Info__c(ShipTo_Number__c='0000012343',SAP_Material__c=msd.id,Chem_Account__c =a.id,CPI_Account__c=a.id,Deletion_Indicator__c='',CPI_Record_Type__c='1',Material_Number__c='091234',Customer_Number__c='12343',Distribution_Channel_Code__c='30',Record_Key__c='11234310003031091234',Sales_Org_Code__c='1000');
        insert cpi;
        Account_Material__c am = new Account_Material__c(Account__c=a.id,SAP_Material__c=msd.id);
        insert am;
        ccrz__E_PriceList__c pl = new ccrz__E_PriceList__c(name='test',Account__c=a.id);
        insert pl;
        ccrz__E_PriceListItem__c pi = new ccrz__E_PriceListItem__c(cpi__c = cpi.id,ccrz__Pricelist__c=pl.id);
        insert pi;
        
        cpi.Deletion_Indicator__c = 'X';
        update cpi;
        }
        
        List<Id> accId = new List<Id>();
        accId.add(a.id);
        accList.add(a);
    
    }
}