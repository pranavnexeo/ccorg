@IsTest
public class cc_mn_bean_ResultsBaseData_Test {

    static testmethod void test() {	
        cc_mn_bean_ResultsBaseData testObject = new cc_mn_bean_ResultsBaseData('1234', '123456', 'Test Name', '2017-05-12', 2, 10.5, 'CAD', '3,4');
        testObject.ranking = 2;
    }
}