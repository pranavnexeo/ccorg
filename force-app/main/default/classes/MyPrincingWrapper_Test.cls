/**
* Description: Test for MyPrincingWrapper Customer Portal
* Date: 08 / 15 / 2018
* Developer: Ignacio Gonzalez
*/
@IsTest
public class MyPrincingWrapper_Test {
    
    @IsTest
    public static void wrapper() {
        MyPrincingWrapper newPricing = new MyPrincingWrapper();
        newPricing.materialNumber = 'materialNumber';
        newPricing.materialDescription = 'materialDescription';  
        newPricing.customerMaterialNumber = 'customerMaterialNumber';
        newPricing.pricingType = 'pricingType';
        newPricing.description = 'description';  
        newPricing.incoTerms = 'incoTerms';
        
        List<TierPricingWrapper> tierList = new List<TierPricingWrapper>();
        TierPricingWrapper tier = new TierPricingWrapper();
        tier.startDate = String.valueOf(Date.today());
        tier.endDate = String.valueOf(Date.today().addDays(30));
        tier.lowerBound = 'lowerBound';
        tier.valueType = 'valueType';
        tier.amount = 'amount';
        tier.baseAmount = 'baseAmount';
        tierList.add(tier);
        newPricing.tierList = tierList;
        
        
    }

}