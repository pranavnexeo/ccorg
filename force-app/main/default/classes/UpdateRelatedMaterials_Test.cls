@isTest
private class UpdateRelatedMaterials_Test {

    static testMethod void testdata(){
        
        Material_Sales_Data2__c msd2 = new Material_Sales_Data2__c ();
        msd2.Material_Group2_Code__c = '107';
        msd2.Material_Group2_Desc__c  = 'Test Name1';
        msd2.Dist_Channel_Code__c = 'AB';
        msd2.Sales_Org_Code__c = '1000';
        msd2.Material_Number__c	= '123456';
        msd2.Record_Key__c = '1234567891000';
        insert msd2;
        
        Material_Pricing_Group2__c mpg2 = new Material_Pricing_Group2__c();
        mpg2.Language_Code__c = 'EN';
        mpg2.Material_Pricing_Group2_Code__c = '107';
        mpg2.Material_Pricing_Group2_Description__c = 'Test Name1';
        insert mpg2;
        
        mpg2.Material_Pricing_Group2_Description__c = 'Test Name2';
        update mpg2;
            
        msd2 = [select id, Material_Group2_Code__c, Material_Group2_Desc__c from Material_Sales_Data2__c where Id = :msd2.Id];
        mpg2 = [select id, Material_Pricing_Group2_Description__c from Material_Pricing_Group2__c where Id = :mpg2.Id];
        System.assertequals('Test Name2', mpg2.Material_Pricing_Group2_Description__c);
        System.assertNotEquals('Test Name2', msd2.Material_Group2_Desc__c);        
        
    } 
}