public class cc_mn_json_myInvoiceResponse {

	 public String document;
	 public boolean success;
	 public String responseCode;
	 public String message;

	
	public static cc_mn_json_myInvoiceResponse parse(String json)
	{
		return (cc_mn_json_myInvoiceResponse) System.JSON.deserialize(json, cc_mn_json_myInvoiceResponse.class);
	}

    public String serialize()
    {
        return JSON.serialize(this);
    }
	
}