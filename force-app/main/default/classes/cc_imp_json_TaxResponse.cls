public class cc_imp_json_TaxResponse {

	public static final String SUCCESS_STATUS = 'SUCCESS';

	public String sfdc_account_id;
	public String sfdc_material_id;
	public String price;
	public String curr;
	public String price_support;
	public String ic_charge;
	public String add_charge;
	public String mat_cost;
	public String warehouse_charge;
	public String freight_charge;
	public String rebate;
	public String quantity;
	public String revenue;
	public String cost;
	public String contrib_margin;
	public String cm_percent;
	public String unit_cm;
	public String unit_mat_cost;
	public String unit_warehouse_chg;
	public String unit_freight_chg;
	public List<Subtotals> subtotals;
	public String status;
	public String message;

	public class Subtotals {
		public String posnr;
		public String cm_group;
		public String cm_group_name;
		public String cm_subtotal;
		public String cm_subtotal_name;
		public String kwert;
		public String waers;
	}

	
	public static List<cc_imp_json_TaxResponse> parse(String json) {
		return (List<cc_imp_json_TaxResponse>) System.JSON.deserialize(json, List<cc_imp_json_TaxResponse>.class);
	}
}