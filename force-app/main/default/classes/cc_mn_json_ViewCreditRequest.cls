public with sharing class cc_mn_json_ViewCreditRequest 
{
	public String customerno;
	public String company_code;
	public String salesorg;
	public String distr_chan;
	public String division;

	public static cc_mn_json_ViewCreditRequest parse(String json)
	{
        return (cc_mn_json_ViewCreditRequest) System.JSON.deserialize(json, cc_mn_json_ViewCreditRequest.class);
    }

    public String serialize()
    {
        return JSON.serialize(this);
    }


}