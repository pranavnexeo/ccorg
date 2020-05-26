@isTest
private class updateCPPricingSchedul_Test {
    
    public static testMethod void updateCPPricingSchedul() {
        String CRON_EXP = '0 0 0 15 3 ? 2022';
        System.schedule('ScheduledApexTest', CRON_EXP, new updateCPPricingSchedul());     
    }
}