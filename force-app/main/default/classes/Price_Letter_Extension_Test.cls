@isTest
private class Price_Letter_Extension_Test 
{

    static testMethod void myUnitTest() 
    {
    Price_Letter__c PS=new Price_Letter__c();
    insert PS;
    ApexPages.standardcontroller con=new ApexPages.standardcontroller(PS);
    Price_Letter_Extension pl=new Price_Letter_Extension(con);
   // pl.Price_Letter_Extension();
     pl.redirectme();
    }
    }