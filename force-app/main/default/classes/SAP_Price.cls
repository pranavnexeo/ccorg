Public Class SAP_Price{
Public SAP_Price__c SAP_Price{get; set;}
Public List<SAP_Price_Tier__c> SAP_Tiers{Get; set;}

Public SAP_Price(){
  SAP_Price = new SAP_Price__c();
  SAP_Tiers = new List<SAP_Price_Tier__c>();
}
}