@isTest
public class Price_Request_Transaction_Test
{
public static testMethod void  Price_Request_Test()
{

 List<CSP_JSON_Response.tbl_sales_units> res = new List<CSP_JSON_Response.tbl_sales_units>();
 Price_Request_Transaction__c pReq = new Price_Request_Transaction__c();
 Price_Request_Transaction pRT = new Price_Request_Transaction(pReq);
 pRT.setconversions(res);
 pRT.getconversions();
 pRT.getSalesUnitsList();
 pRT.getTopCSP();
 pRT.getTopCSPEffDate();
 pRT.getTopCSPExpDate();
 pRT.getTopDrumDeposit();
 pRT.getTopPriceProtectionDesc();
 pRT.getTopCSPVolume();
 pRT.getTopCSPVolUom();
 pRT.getTopCSPPriceUom();
 pRT.getTopTarget();
 pRT.getTopTargetVolume();
 pRT.getTopTargetPriceUoM();
 pRT.getTopTargetVolumeUoM();
 pRT.getTopTargetEffDate();
 pRT.getTopTargetExpDate();
 pRT.getTopTPI();
 pRT.ConvertUnitsTo(314159,'sUnitFrom','UnitT',true);
 }
 }