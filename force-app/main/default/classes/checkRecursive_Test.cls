@isTest

public class checkRecursive_Test{
    
    public static testMethod void testMe(){
        test.startTest();
        boolean temp = checkRecursive.runOnce();
        temp = checkRecursive.runOnce();
        boolean temp1 = checkRecursive.runAccountOnce();
        temp1 = checkRecursive.runAccountOnce();
        boolean temp2 = checkRecursive.runAccountOnce1();
        temp2 = checkRecursive.runAccountOnce1();
        boolean temp4 = checkRecursive.runAccountOnce2();
        temp4 = checkRecursive.runAccountOnce2();
        boolean temp5 = checkRecursive.runAccountOnce3();
        temp5 = checkRecursive.runAccountOnce3();
        
        checkRecursive.resetAccountOnce2();
        boolean temp3 = checkRecursive.runOnceCdf();
        temp3 = checkRecursive.runOnceCdf();
        test.stopTest();
    
    }
}