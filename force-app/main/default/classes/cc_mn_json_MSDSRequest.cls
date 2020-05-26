public with sharing class cc_mn_json_MSDSRequest 
{
	public String material;

	
	public static cc_mn_json_MSDSRequest parse(String json) 
	{
		return (cc_mn_json_MSDSRequest) System.JSON.deserialize(json, cc_mn_json_MSDSRequest.class);
	}


	public String serialize()
    {
        return JSON.serialize(this);
    }
}