@isTest
public class Price_Letter_Page_Test {

    public static testMethod void test(){
    
        Price_Letter__c priceLetter = new Price_Letter__c();
        List<SAP_Price_Tier__c> spt = new List<SAP_Price_Tier__c>();
        ApexPages.standardController sc = new ApexPages.standardcontroller(priceLetter);
    
        Price_Letter_Page priceLetterPage = new Price_Letter_Page(sc);
        priceLetterPage.getHeaderDetailLine();
        priceLetterPage.getLongDate();
        priceLetterPage.getHeaderDetailLineFrench();
        priceLetterPage.Quote_Tiers = spt;
        priceLetterPage.CSP_Tiers = spt;
        
        //Price_Request_Transaction__c t, Material_Sales_Data2__c m, List<SAP_Price_tier__c> Req, List<SAP_Price_tier__c> CSP 
        Price_Letter_Page.Price_Letter_Location priceLetterLoc = new Price_Letter_Page.Price_Letter_Location(new Price_Request_Transaction__c(), new Material_Sales_Data2__c(), new List<SAP_Price_tier__c>(), new List<SAP_Price_tier__c>());
        priceLetterLoc.addItem(new Material_Sales_Data2__c(), new List<SAP_Price_tier__c>(), new List<SAP_Price_tier__c>());
        
        Price_Letter_Page.Price_Letter_Item priceLetterItem = new Price_Letter_Page.Price_Letter_Item(new Material_Sales_Data2__c(), new List<SAP_Price_Tier__c>(), new List<SAP_Price_tier__c>());
        Price_Letter_Page.Price_Letter_Item priceLetterItem2 = new Price_Letter_Page.Price_Letter_Item('String', new Material_Sales_Data2__c(), new List<SAP_Price_Tier__c>(), new List<SAP_Price_tier__c>());
        
        Price_Letter_Page.Location location = new Price_Letter_Page.Location('String', new Account(Name='TestAcc'));
    }
}