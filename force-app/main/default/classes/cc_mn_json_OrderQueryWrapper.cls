public class cc_mn_json_OrderQueryWrapper {

	public String searchOrderInput;
	public String searchOrderStatus;
	public String fromDateStr;
	public String toDateStr;
	public String ascending;
	public String sortCriteria;
	public String sortDir;


	public static cc_mn_json_OrderQueryWrapper parse(String json) {
		return (cc_mn_json_OrderQueryWrapper) System.JSON.deserialize(json, cc_mn_json_OrderQueryWrapper.class);
	}

	public String serialize()
    {
        return JSON.serialize(this);
    }
}