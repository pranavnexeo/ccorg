public class cc_mn_json_myInvoiceRequest {

	public String document;

	
	public static cc_mn_json_myInvoiceRequest parse(String json) 
	{
		return (cc_mn_json_myInvoiceRequest) System.JSON.deserialize(json, cc_mn_json_myInvoiceRequest.class);
	}


	public String serialize()
    {
        return JSON.serialize(this);
    }
}