public class Sample_Request_Fixed_Costs_Functions {

  public static Decimal Retrieve_Additional_Cost_per_Sample(String RecordType_Name, String Region) {
  	Decimal result = 0.0;
  	
  	Sample_Request_Fixed_Costs__c fc;
  	
  	try {
  	  	fc = [SELECT Additional_Cost_per_Sample__c, Additional_Cost_per_Line_Item__c FROM Sample_Request_Fixed_Costs__c
  	           WHERE (RecordType_Name__c = :RecordType_Name OR RecordType_Name__c = null OR RecordType_Name__c = '') 
  	             AND (Region__c = :Region OR Region__c = null OR Region__c = '')
  	        ORDER BY Process_Order__c
  	           LIMIT 1]; }
    catch (Exception e) {}
  	         
	if (fc != null)
		{
		result = fc.Additional_Cost_per_Sample__c; 
		}  	         
  	
  	return result;
  }

  public static Decimal Retrieve_Additional_Cost_per_Line_Item(String RecordType_Name, String Region) {
  	Decimal result = 0.0;
  	
  	Sample_Request_Fixed_Costs__c fc;
  	
  	try {
  	  	fc = [SELECT Additional_Cost_per_Sample__c, Additional_Cost_per_Line_Item__c FROM Sample_Request_Fixed_Costs__c
  	           WHERE (RecordType_Name__c = :RecordType_Name OR RecordType_Name__c = null OR RecordType_Name__c = '') 
  	             AND (Region__c = :Region OR Region__c = null OR Region__c = '')
  	        ORDER BY Process_Order__c
  	           LIMIT 1]; }
    catch (Exception e) {}
  	         
	if (fc != null)
		{
		result = fc.Additional_Cost_per_Line_Item__c; 
		}  	         
  	
  	return result;
  }




//******************
//Test Method 
//******************
  static testMethod void TestMe() {

  Double cost = 0.0;
  
  cost = Retrieve_Additional_Cost_per_Sample('', '');
  cost = Retrieve_Additional_Cost_per_Line_Item('', '');

  }

//The End

}