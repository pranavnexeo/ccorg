/**
* Description: Test for TierPricingWrapper Customer Portal
* Date: 08 / 20 / 2018
* Developer: Ignacio Gonzalez
*/
@IsTest
public class TierPricingWrapper_Test {

    @IsTest
    public static void wrapper() {
        
        TierPricingWrapper tier = new TierPricingWrapper();
        tier.startDate = String.valueOf(Date.today());
        tier.endDate = String.valueOf(Date.today().addDays(30));
        tier.lowerBound = 'lowerBound';
        tier.valueType = 'valueType';
        tier.amount = 'amount';
        tier.baseAmount = 'baseAmount';
       
        
    }
}