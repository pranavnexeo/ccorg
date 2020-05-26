public class Salesforce_System_Info_Functions {

  private static String URL_Prefix = '';

  public static String Retrieve_URL_Prefix() {
    String result = '';

    if (URL_Prefix == '') {
        List<Salesforce_System_Info__c> alist = [SELECT URL_Prefix__c FROM Salesforce_System_Info__c LIMIT 1];
        if (!alist.isEmpty()) {URL_Prefix = alist[0].URL_Prefix__c;}
    }

    result = URL_Prefix;
    
    return result;
  }


//******************
//Test Method 
//******************
  static testMethod void TestMe() {
    System.debug(Retrieve_URL_Prefix());
    System.debug(Retrieve_URL_Prefix());
    System.debug(Retrieve_URL_Prefix());
  }

//The End
}