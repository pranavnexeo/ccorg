@isTest
public class CPI_TriggerHandlerTest {
	@isTest
    public static void tesCPIHandler1(){
        Map<String, SObject> testData = new Map<String, SObject>(NexeoTestUtils_Test.initData());
        Account a= (Account) testData.get('testGeneralAccount2');
        Material_General_Data2__c mgd2 = new Material_General_Data2__c(Material_Number__c ='091234',Division_Code__c='31');        
        insert mgd2;
        Material_Sales_Data2__c msd = new Material_Sales_Data2__c(Name='test',Material_Number__c='091234',Create_CC_Product__c=false,Dist_Channel_Code__c='30',Record_Key__c='09123410003031',Sales_Org_Code__c='1000');
        insert msd;
        Customer_Product_Info__c cpi = new Customer_Product_Info__c(ShipTo_Number__c='0000012343',SAP_Material__c=msd.id,Chem_Account__c =a.id,CPI_Account__c=a.id,Plastics_Account__c=a.id,Deletion_Indicator__c='',CPI_Record_Type__c='1',Material_Number__c='091234',Customer_Number__c='12343',Distribution_Channel_Code__c='30',Record_Key__c='11234310003031091234',Sales_Org_Code__c='1000');
        insert cpi;
    }
}