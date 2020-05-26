public class cc_mn_json_InvoiceQueryWrapper {

	public String fromDateStr;
	public String searchInvoiceInput;
	public String searchInvoiceStatus;
	public String searchInvoiceType;
	public String sortCriteria;
	public String sortDir;
	public String toDateStr;

	
	public static cc_mn_json_InvoiceQueryWrapper parse(String json) {
		return (cc_mn_json_InvoiceQueryWrapper) System.JSON.deserialize(json, cc_mn_json_InvoiceQueryWrapper.class);
	}

	public String serialize()
    {
        return JSON.serialize(this);
    }
}