@isTest
public class cc_mn_ProfilesControllerTest {
    
    @isTest static void ValidateProfile()
    {
        cc_imp_StorefrontSettings__C objCS = new cc_imp_StorefrontSettings__C(name='mynexeo',ProfilePath__c='test');
        insert objCs;
        
        cc_mn_ProfilesController  obj = new cc_mn_ProfilesController ();
        cc_mn_ProfilesController.WrapProfile obj1= new cc_mn_ProfilesController.WrapProfile('test','test','20180102','test','test');
    }
}