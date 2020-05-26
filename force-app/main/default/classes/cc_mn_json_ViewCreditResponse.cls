public with sharing class cc_mn_json_ViewCreditResponse 
{
	public String customer ;
	public String cust_name ;
	public String company ;
	public String company_name ;
	public String salesorg ;
	public String distr_chan ;
	public String division ;
	public String amt_open ;
	public String amt_0to5 ;
	public String amt_6to15 ;
	public String amt_16to30 ;
	public String amt_31to60 ;
	public String amt_over60 ;
	public String amt_total ;
	public String currency_key ;
	public String payment_terms ;
	public boolean success;
	public String statusCode;
	public String message;

	
	public static cc_mn_json_ViewCreditResponse parse(String json) 
	{
		return (cc_mn_json_ViewCreditResponse) System.JSON.deserialize(json, cc_mn_json_ViewCreditResponse.class);
	}

    public String serialize()
    {
        return JSON.serialize(this);
    }
}