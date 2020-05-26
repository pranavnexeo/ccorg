public class Custom_Config_Functions {

	public static Map<String,String> CustomConfigs;

	public static String RetrieveCustomConfig(String configGroup, String setting) {
		String result = '';

		if (CustomConfigs == null) {CustomConfigs = new Map<String,String>();}
		
		String configKey = configGroup + '_' + setting;

		if (CustomConfigs.containsKey(configKey) == true)
			{
			result = CustomConfigs.get(configKey);
			}
		else
			{
	        try {        
	        	result = [SELECT Value__c FROM Custom_Config__c WHERE Config_Group__c = :configGroup and Setting__c = :setting].Value__c;
	        	}
	        catch (Exception e) {}
	        
	        CustomConfigs.put(configKey,result);
			}
		
		return result;
	}




//******************
//Test Method 
//******************
  static testMethod void TestMe() {

    String result = '';
    
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('BW','Updating Data');
    System.debug('result = ' + result);
    result = RetrieveCustomConfig('X','X');
    System.debug('result = ' + result);

  }

//The End

}