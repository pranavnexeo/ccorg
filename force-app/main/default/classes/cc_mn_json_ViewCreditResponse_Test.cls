@IsTest
public class cc_mn_json_ViewCreditResponse_Test 
{
  
  static testMethod void testParse() 
  {
    String json = '{\"customer\": \"0000102483\", \"cust_name\": \"ENGINEERED MATERIALS SYSTEMS/ DELAWARE OH  43015 USA\", \"company\": \"1000\", \"company_name\": \"Nexeo Solutions LLC\", \"salesorg\": \"1000\", \"distr_chan\": \"30\", \"division\": \"31\", \"amt_open\": \"0.00 \", \"amt_0to5\": \"0.00 \", \"amt_6to15\": \"0.00 \", \"amt_16to30\": \"0.00 \", \"amt_31to60\": \"0.00 \", \"amt_over60\": \"90061.53 \", \"amt_total\": \"90061.53 \", \"currency_key\": \"USD\", \"payment_terms\": \"Z045\"}';
    cc_mn_json_ViewCreditResponse obj = cc_mn_json_ViewCreditResponse.parse(json);
    System.assert(obj != null);
    System.assertNotEquals(null, obj.serialize());
  }
}