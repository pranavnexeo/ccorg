@IsTest
public class cc_imp_json_TaxRequestTest {
    
    static testMethod void testParse() {
        String json = '[{'+
        '      \"ship_to\":\"888888\",'+
        '      \"sold_to\":\"888888\",'+
        '      \"material\":\"000000000000052705\",'+
        '      \"quantity\":\"1\",'+
        '      \"sales_unit\":\"EA\",'+
        '      \"price\":\"15.00\",'+
        '      \"curr\":\"USD\",'+
        '      \"price_unit\":\"LB\",'+
        '      \"plant\":\"\",'+
        '      \"sfdc_account_id\":\"a56E00000008ehsIAA\",'+
        '      \"sfdc_material_id\":\"12345\",'+
        '      \"price_date\":\"\",'+
        '      \"sales_org\":\"\",'+
        '      \"distr_chan\":\"30\",'+
        '      \"division\":\"31\",'+
        '      \"customer_size\":\"\",'+
        '      \"pricing_endmkt\":\"\",'+
        '      \"sub_region\":\"\",'+
        '      \"freight_terms\":\"ZD1\",'+
        '      \"partners\":['+
        '         {'+
        '            \"partn_role\":\"AG\",'+
        '            \"partn_numb\":\"\",'+
        '            \"itm_number\":\"000000\",'+
        '            \"title\":\"\",'+
        '            \"name\":\"Joe Customer\",'+
        '            \"name_2\":\"\",'+
        '            \"name_3\":\"\",'+
        '            \"name_4\":\"\",'+
        '            \"street\":\"3 Waterway Square Pl #1000\",'+
        '            \"country\":\"\",'+
        '            \"country_iso\":\"\",'+
        '            \"postl_code\":\"77380\",'+
        '            \"pobx_pcd\":\"\",'+
        '            \"pobx_cty\":\"\",'+
        '            \"city\":\"The Woodlands\",'+
        '            \"district\":\"\",'+
        '            \"region\":\"TX\",'+
        '            \"po_box\":\"\",'+
        '            \"telephone\":\"\",'+
        '            \"telephone2\":\"\",'+
        '            \"telebox\":\"\",'+
        '            \"fax_number\":\"\",'+
        '            \"teletex_no\":\"\",'+
        '            \"telex_no\":\"\",'+
        '            \"langu\":\"\",'+
        '            \"langu_iso\":\"\",'+
        '            \"unload_pt\":\"\",'+
        '            \"transpzone\":\"\",'+
        '            \"taxjurcode\":\"\",'+
        '            \"address\":\"\",'+
        '            \"priv_addr\":\"\",'+
        '            \"addr_type\":\"\",'+
        '            \"addr_orig\":\"\",'+
        '            \"addr_link\":\"\",'+
        '            \"vat_reg_no\":\"\"'+
        '         },'+
        '         {'+
        '            \"partn_role\":\"WE\",'+
        '            \"partn_numb\":\"\",'+
        '            \"itm_number\":\"000000\",'+
        '            \"title\":\"\",'+
        '            \"name\":\"Joe Customer\",'+
        '            \"name_2\":\"\",'+
        '            \"name_3\":\"\",'+
        '            \"name_4\":\"\",'+
        '            \"street\":\"3 Waterway Square Pl #1000\",'+
        '            \"country\":\"\",'+
        '            \"country_iso\":\"\",'+
        '            \"postl_code\":\"77380\",'+
        '            \"pobx_pcd\":\"\",'+
        '            \"pobx_cty\":\"\",'+
        '            \"city\":\"The Woodlands\",'+
        '            \"district\":\"\",'+
        '            \"region\":\"TX\",'+
        '            \"po_box\":\"\",'+
        '            \"telephone\":\"\",'+
        '            \"telephone2\":\"\",'+
        '            \"telebox\":\"\",'+
        '            \"fax_number\":\"\",'+
        '            \"teletex_no\":\"\",'+
        '            \"telex_no\":\"\",'+
        '            \"langu\":\"\",'+
        '            \"langu_iso\":\"\",'+
        '            \"unload_pt\":\"\",'+
        '            \"transpzone\":\"\",'+
        '            \"taxjurcode\":\"\",'+
        '            \"address\":\"\",'+
        '            \"priv_addr\":\"\",'+
        '            \"addr_type\":\"\",'+
        '            \"addr_orig\":\"\",'+
        '            \"addr_link\":\"\",'+
        '            \"vat_reg_no\":\"\"'+
        '         }'+
        '      ]'+
        '   }]';
        List<cc_imp_json_TaxRequest> obj = cc_imp_json_TaxRequest.parse(json);
        System.assert(obj != null);
    }
}