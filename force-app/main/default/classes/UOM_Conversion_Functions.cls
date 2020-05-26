public class UOM_Conversion_Functions {

    public static final SelectOption OPTION_NONE = new SelectOption('', '--None--');

    public static final String SAMPLE_QUANTITY_1 = 'SAMPLE_QUANTITY_1'; 
    public static final String SAMPLE_QUANTITY_2 = 'SAMPLE_QUANTITY_2'; 
    public static final String SAMPLE_QUANTITY_3 = 'SAMPLE_QUANTITY_3'; 
    
  public static List<UOM_Conversion__c> UOMConversions;

  public static void populateUOMConversions() {
        if (UOMConversions == null)
          {
          UOMConversions = [SELECT UOM__c, Qty_Greater_Than_or_Equal_to_5_Gallons__c FROM UOM_Conversion__c];
          }                                                
    
  }

  public static Boolean UOMQty_Greater_Than_5_Gallons(String UOM, Double quantity) {
  
    Boolean GreaterThan5Gallons = false;
    Double UOMQuantity = 0;
    
    populateUOMConversions();
    
    for (UOM_Conversion__c UOMConversion : UOMConversions)
      {
      if(UOMConversion.UOM__c == UOM) {UOMQuantity = UOMConversion.Qty_Greater_Than_or_Equal_to_5_Gallons__c;}
      }
    
    if (quantity > UOMQuantity) {GreaterThan5Gallons = true;}
    
    return GreaterThan5Gallons;
  }

    public static List<SelectOption> getUomSelectOptions(String accountRecordType) {
    	List<SelectOption> slist = new List<SelectOption>();
        slist.add(OPTION_NONE);
        SelectOption s;
    	for (UOM_Account_Record_Type__c u : [select UOM__c 
    	                                       from UOM_Account_Record_Type__c
    	                                      where Account_Record_Type__c = :accountRecordType
    	                                      order by UOM__c
    	                                    ]) {
    		s = new SelectOption(u.UOM__c, u.UOM__c);
    		slist.add(s);
    	}
    	return slist;
    }
    
    public static Map<String, Map<String, Double>> getSampleQuantities(String accountRecordType) {
    	Map<String, Map<String, Double>> amap = new Map<String, Map<String, Double>>();
		for (UOM_Account_Record_Type__c u : [select Sample_Quantity_1__c,
		                                            Sample_Quantity_2__c,
		                                            Sample_Quantity_3__c,
		                                            UOM__c
                                               from UOM_Account_Record_Type__c
                                              where Account_Record_Type__c = :accountRecordType
		                                    ]) {
            Map<String, Double> bmap = new Map<String, Double> {
                SAMPLE_QUANTITY_1 => u.Sample_Quantity_1__c,
                SAMPLE_QUANTITY_2 => u.Sample_Quantity_2__c,
                SAMPLE_QUANTITY_3 => u.Sample_Quantity_3__c
            };
            amap.put(u.UOM__c, bmap);
        }
        return amap;
    }

    public static void setRouteForApprovalFlags(String accountRecordType,
                                                Sample_Request__c sampleRequest,
                                                List<Sample_Material__c> sampleMaterials) {
        sampleRequest.Route_for_Approval_1__c = false;
        sampleRequest.Route_for_Approval_2__c = false;
        sampleRequest.Route_for_Approval_3__c = false;
        Map<String, Map<String, Double>> umap = getSampleQuantities(accountRecordType);
        String msu;
        Double msq, usq;
        Map<String, Double> qmap;
        for (Sample_Material__c m : sampleMaterials) {
            msu = m.Sample_UOM__c;
            msq = m.Sample_Quantity__c;
            if (umap.containsKey(msu)) {
                qmap = umap.get(msu);
                if (qmap.containsKey(SAMPLE_QUANTITY_1)) {
                    usq = qmap.get(SAMPLE_QUANTITY_1);
                    if (usq != null && msq > usq) {
                        sampleRequest.Route_for_Approval_1__c = true;
                    }
                }
                if (qmap.containsKey(SAMPLE_QUANTITY_2)) {
                    usq = qmap.get(SAMPLE_QUANTITY_2);
                    if (usq != null && msq > usq) {
                        sampleRequest.Route_for_Approval_2__c = true;
                    }
                }
                if (qmap.containsKey(SAMPLE_QUANTITY_3)) {
                    usq = qmap.get(SAMPLE_QUANTITY_3);
                    if (usq != null && msq > usq) {
                        sampleRequest.Route_for_Approval_3__c = true;
                    }
                }
            } // end of check for uom
        } // end of materials loop
    } 
    
/*
*******************************************************
Test Methods are in UOM_Conversion_Functions_Test class 
*******************************************************
*/

}