public with sharing class cc_mn_json_MSDSResponse 
{
	 public String document;
	 public boolean success;
	 public String responseCode;
	 public String message;

	
	public static cc_mn_json_MSDSResponse parse(String json)
	{
		return (cc_mn_json_MSDSResponse) System.JSON.deserialize(json, cc_mn_json_MSDSResponse.class);
	}

    public String serialize()
    {
        return JSON.serialize(this);
    }
}