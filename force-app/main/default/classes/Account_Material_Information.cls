Public Class Account_Material_Information{

public Id recordid{get; set;}
Public Account_Material__c amInfo;


Public Account_Material__c getamInfo(){

amInfo=[Select id, Account_Number__c, Account__r.Name, Price_Support_Indicator__c, Account_Name__c, Account_City__c, Account_Ship_To_State__c, Account_Sold_To__c, Account__r.SAP_Corporate_Account__c, Material__c, Material_Base_Code__c from Account_Material__c where id =:recordid];

if(amInfo!=null)
return amInfo;

else
return null;

}
}