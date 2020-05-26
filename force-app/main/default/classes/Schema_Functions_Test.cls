@isTest
private class Schema_Functions_Test {

    static List<String> objnames = new List<String>{
            'Account', 
            'Approval',
            'Asset', 
            'Campaign',
            'Case',
            'Contact',
            'Contract',
            'Lead',
            'Opportunity',
//            'Partner',
            'Quote',
            'Task'
    };

    static Map<String, Map<String, Id>> rtnmap;  
    static Map<String, Map<Id, String>> rtimap;
    
    static void debug(String s) {
    	System.debug(LoggingLevel.INFO, '>>>>>>>> ' + s);
    }
//*
    static testMethod void test01() {
        Test.startTest();
    	Schema.DescribeFieldResult dfr = Account.SAP_Sales_Office_Desc__c.getDescribe();
        Map<String, String> somap = Schema_Functions.getSelectOptionValueLabelMap(dfr);
        System.debug(somap);
        List<String> labels = new List<String>{'RBT EASTERN US'};
        List<SelectOption> solist = Schema_Functions.getSelectOptionList(dfr, labels);
        System.debug(solist);
        Test.stopTest();
    }

    static testMethod void test02() {
        Test.startTest();
        rtimap = Schema_Functions.getRecordTypeIdMap(objnames);
        System.debug(rtimap.size() + ':' + rtimap.get('Task'));
        Test.stopTest();
    }

    static testMethod void test03() {
        Test.startTest();
        rtnmap = Schema_Functions.getRecordTypeNameMap(objnames);
        System.debug(rtnmap.size() + ':' + rtnmap.get('Task'));
        Test.stopTest();
    }
//*/    
}