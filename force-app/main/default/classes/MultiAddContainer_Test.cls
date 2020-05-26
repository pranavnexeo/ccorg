@isTest
public class MultiAddContainer_Test {
    public static testMethod void testMultiAddContainer() {
        MultiAddContainer.innerClass inc = new MultiAddContainer.innerClass(20);
        
        Container_Chemical_Junction__c ccj = new Container_Chemical_Junction__c();
        List<Container_Chemical_Junction__c>lstAcct = new List<Container_Chemical_Junction__c>();
        
        ApexPages.standardController sc = new ApexPages.standardcontroller(ccj);           
        MultiAddContainer mac = new MultiAddContainer(sc);
        
        //PageReference pr = mac.Save();
        mac.selectedRowIndex = '1';
        mac.Add();
        mac.Del();
        try{
        mac.Save();
        }catch(exception e){}
    }
}