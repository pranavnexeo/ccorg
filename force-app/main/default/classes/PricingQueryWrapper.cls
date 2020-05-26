public class PricingQueryWrapper {
    
    public String searchDataInput;
    public String sortCriteria;
	public String sortDir;
    public String page;
    
   	public static PricingQueryWrapper parse(String json) {
		return (PricingQueryWrapper) System.JSON.deserialize(json, PricingQueryWrapper.class);
	}

	public String serialize()
    {
        return JSON.serialize(this);
    }

}