public class cc_imp_json_TaxRequest {

    public class Partner {
        public String partn_role;   // 3d: AG=sold to, WE=ship to   mn:
        public String partn_numb;   // 3d: blank    mn:
        public String itm_number;   
        public String title;        // 3d: blank
        public String name;
        public String name_2;       // 3d: blank
        public String name_3;       // 3d: blank
        public String name_4;       // 3d: blank
        public String street;
        public String country;      // 3d: blank
        public String country_iso;  // 3d: blank
        public String postl_code;
        public String pobx_pcd;     // 3d: blank
        public String pobx_cty;     // 3d: blank
        public String city;
        public String district;     // 3d: blank
        public String region;       // 3d: state/blank
        public String po_box;       // 3d: blank
        public String telephone;    // 3d: blank
        public String telephone2;   // 3d: blank
        public String telebox;      // 3d: blank
        public String fax_number;   // 3d: blank
        public String teletex_no;   // 3d: blank
        public String telex_no;     // 3d: blank
        public String langu;        // 3d: blank
        public String langu_iso;    // 3d: blank
        public String unload_pt;    // 3d: blank
        public String transpzone;   // 3d: blank
        public String taxjurcode;   // 3d: blank
        public String address;      // 3d: blank
        public String priv_addr;    // 3d: blank
        public String addr_type;    // 3d: blank
        public String addr_orig;    // 3d: blank
        public String addr_link;    // 3d: blank
        public String vat_reg_no;   // 3d: blank
      
    }

    public String ship_to;          // 3d: 888888   mn: 
    public String sold_to;          // 3d: 888888   mn: 
    public String material;         // 3d: 
    public String quantity;
    public String sales_unit;
    public String price;
    public String curr;
    public String price_unit;
    public String plant;            // 3d: blank    mn:
    public String sfdc_account_id;
    public String sfdc_material_id;
    public String price_date;       // 3d: blank    mn:
    public String sales_org;        // 3d: blank    mn:
    public String distr_chan;
    public String division;
    public String customer_size;    // 3d: blank
    public String pricing_endmkt;   // 3d: blank
    public String sub_region;       // 3d: blank
    public String freight_terms;    // 3d: ZD1  mn:
    public String shipping_amt;    
    public String alttax_cls;       // tax classification. 0=no tax, 1=tax
    public List<Partner> partners;
    public String DISCOUNT_TYPE;
    public Decimal DISCOUNT_AMOUNT; 

    
    public static List<cc_imp_json_TaxRequest> parse(String json) {
        return (List<cc_imp_json_TaxRequest>) System.JSON.deserialize(json, List<cc_imp_json_TaxRequest>.class);
    }
}


/* Old Version - remove  once new version is tested and working
public class cc_imp_json_TaxRequest {

    public String ship_to;          // ccrz__E_CartItem__c.
    public String sold_to;          // ccrz__E_CartItem__c.
    public String material;         // ccrz__E_CartItem__c.ccrz__Product__r.NexeoMaterialId__c
    public Decimal quantity;         // ccrz__E_CartItem__c.ccrz__Quantity__c
    public String sales_unit;       // Product Sales UoM?
    public Decimal price;            // ccrz__E_CartItem__c.ccrz__Price__c * quantity
    public Decimal price_unit;       // ccrz__E_CartItem__c.ccrz__Price__c
    public String curr;             // ccrz__E_CartItem__c.CurrencyIsoCode ??
    public String plant;            // ccrz__E_CartItem__c.
    public String sfdc_account_id;  // ccrz__E_CartItem__r.ccrz__Cart__r.ccrz__Account__c
    public String sfdc_material_id; // Product - SAP Material, or NexeoMaterialId?
    public String sales_org;        // ccrz__E_CartItem__c.ccrz__Product__r.SalesOrgCode__c
    public String distr_chan;       // ccrz__E_CartItem__c.ccrz__Product__r.DistChannel__c
    public String division;         // ccrz__E_CartItem__c.ccrz__Product__r.DivisionCode__c
    public String freight_terms;    // ccrz__E_CartItem__c.

    public static List<cc_imp_json_TaxRequest> parse(String json) {
        return (List<cc_imp_json_TaxRequest>) System.JSON.deserialize(json, List<cc_imp_json_TaxRequest>.class);
    }
}
*/